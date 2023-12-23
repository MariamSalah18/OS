
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
  800031:	e8 39 12 00 00       	call   80126f <libmain>
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
  800060:	68 80 43 80 00       	push   $0x804380
  800065:	6a 1a                	push   $0x1a
  800067:	68 9c 43 80 00       	push   $0x80439c
  80006c:	e8 2c 13 00 00       	call   80139d <_panic>
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
  8000a8:	e8 f5 27 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  8000c4:	e8 d9 27 00 00       	call   8028a2 <sys_calculate_free_frames>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000cc:	e8 1c 28 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 9e 23 00 00       	call   802483 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000ee:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8000f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f7:	74 14                	je     80010d <_main+0xd5>
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 b0 43 80 00       	push   $0x8043b0
  800101:	6a 3d                	push   $0x3d
  800103:	68 9c 43 80 00       	push   $0x80439c
  800108:	e8 90 12 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80010d:	e8 db 27 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800112:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800115:	74 14                	je     80012b <_main+0xf3>
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 e0 43 80 00       	push   $0x8043e0
  80011f:	6a 3e                	push   $0x3e
  800121:	68 9c 43 80 00       	push   $0x80439c
  800126:	e8 72 12 00 00       	call   80139d <_panic>


			freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 72 27 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800167:	e8 36 27 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800184:	68 10 44 80 00       	push   $0x804410
  800189:	6a 49                	push   $0x49
  80018b:	68 9c 43 80 00       	push   $0x80439c
  800190:	e8 08 12 00 00       	call   80139d <_panic>

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
  8001cf:	e8 eb 2b 00 00       	call   802dbf <sys_check_WS_list>
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001da:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8001de:	74 14                	je     8001f4 <_main+0x1bc>
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	68 8c 44 80 00       	push   $0x80448c
  8001e8:	6a 4d                	push   $0x4d
  8001ea:	68 9c 43 80 00       	push   $0x80439c
  8001ef:	e8 a9 11 00 00       	call   80139d <_panic>
		}

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001f4:	e8 a9 26 00 00       	call   8028a2 <sys_calculate_free_frames>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001fc:	e8 ec 26 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  800204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 6e 22 00 00       	call   802483 <malloc>
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
  800239:	68 b0 43 80 00       	push   $0x8043b0
  80023e:	6a 55                	push   $0x55
  800240:	68 9c 43 80 00       	push   $0x80439c
  800245:	e8 53 11 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80024a:	e8 9e 26 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  80024f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800252:	74 14                	je     800268 <_main+0x230>
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	68 e0 43 80 00       	push   $0x8043e0
  80025c:	6a 56                	push   $0x56
  80025e:	68 9c 43 80 00       	push   $0x80439c
  800263:	e8 35 11 00 00       	call   80139d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800268:	e8 35 26 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  8002ad:	e8 f0 25 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  8002ca:	68 10 44 80 00       	push   $0x804410
  8002cf:	6a 60                	push   $0x60
  8002d1:	68 9c 43 80 00       	push   $0x80439c
  8002d6:	e8 c2 10 00 00       	call   80139d <_panic>
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
  800319:	e8 a1 2a 00 00       	call   802dbf <sys_check_WS_list>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800324:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800328:	74 14                	je     80033e <_main+0x306>
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	68 8c 44 80 00       	push   $0x80448c
  800332:	6a 63                	push   $0x63
  800334:	68 9c 43 80 00       	push   $0x80439c
  800339:	e8 5f 10 00 00       	call   80139d <_panic>
		}
		//cprintf("5\n");

		//3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80033e:	e8 5f 25 00 00       	call   8028a2 <sys_calculate_free_frames>
  800343:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800346:	e8 a2 25 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  80034b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80034e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800351:	89 c2                	mov    %eax,%edx
  800353:	01 d2                	add    %edx,%edx
  800355:	01 d0                	add    %edx,%eax
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	50                   	push   %eax
  80035b:	e8 23 21 00 00       	call   802483 <malloc>
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
  800385:	68 b0 43 80 00       	push   $0x8043b0
  80038a:	6a 6c                	push   $0x6c
  80038c:	68 9c 43 80 00       	push   $0x80439c
  800391:	e8 07 10 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800396:	e8 52 25 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  80039b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80039e:	74 14                	je     8003b4 <_main+0x37c>
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 e0 43 80 00       	push   $0x8043e0
  8003a8:	6a 6d                	push   $0x6d
  8003aa:	68 9c 43 80 00       	push   $0x80439c
  8003af:	e8 e9 0f 00 00       	call   80139d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8003b4:	e8 e9 24 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  8003f7:	e8 a6 24 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800414:	68 10 44 80 00       	push   $0x804410
  800419:	6a 77                	push   $0x77
  80041b:	68 9c 43 80 00       	push   $0x80439c
  800420:	e8 78 0f 00 00       	call   80139d <_panic>
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
  800466:	e8 54 29 00 00       	call   802dbf <sys_check_WS_list>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800471:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800475:	74 14                	je     80048b <_main+0x453>
  800477:	83 ec 04             	sub    $0x4,%esp
  80047a:	68 8c 44 80 00       	push   $0x80448c
  80047f:	6a 7a                	push   $0x7a
  800481:	68 9c 43 80 00       	push   $0x80439c
  800486:	e8 12 0f 00 00       	call   80139d <_panic>
		}

		//3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80048b:	e8 12 24 00 00       	call   8028a2 <sys_calculate_free_frames>
  800490:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800493:	e8 55 24 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  80049b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	01 d2                	add    %edx,%edx
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	50                   	push   %eax
  8004a8:	e8 d6 1f 00 00       	call   802483 <malloc>
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
  8004da:	68 b0 43 80 00       	push   $0x8043b0
  8004df:	68 82 00 00 00       	push   $0x82
  8004e4:	68 9c 43 80 00       	push   $0x80439c
  8004e9:	e8 af 0e 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ee:	e8 fa 23 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  8004f3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004f6:	74 17                	je     80050f <_main+0x4d7>
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	68 e0 43 80 00       	push   $0x8043e0
  800500:	68 83 00 00 00       	push   $0x83
  800505:	68 9c 43 80 00       	push   $0x80439c
  80050a:	e8 8e 0e 00 00       	call   80139d <_panic>
		}

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80050f:	e8 8e 23 00 00       	call   8028a2 <sys_calculate_free_frames>
  800514:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800517:	e8 d1 23 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
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
  800530:	e8 4e 1f 00 00       	call   802483 <malloc>
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
  800562:	68 b0 43 80 00       	push   $0x8043b0
  800567:	68 8b 00 00 00       	push   $0x8b
  80056c:	68 9c 43 80 00       	push   $0x80439c
  800571:	e8 27 0e 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800576:	e8 72 23 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  80057b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 e0 43 80 00       	push   $0x8043e0
  800588:	68 8c 00 00 00       	push   $0x8c
  80058d:	68 9c 43 80 00       	push   $0x80439c
  800592:	e8 06 0e 00 00       	call   80139d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800597:	e8 06 23 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800621:	e8 7c 22 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  80063e:	68 10 44 80 00       	push   $0x804410
  800643:	68 96 00 00 00       	push   $0x96
  800648:	68 9c 43 80 00       	push   $0x80439c
  80064d:	e8 4b 0d 00 00       	call   80139d <_panic>
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
  800693:	e8 27 27 00 00       	call   802dbf <sys_check_WS_list>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  80069e:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8006a2:	74 17                	je     8006bb <_main+0x683>
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 8c 44 80 00       	push   $0x80448c
  8006ac:	68 99 00 00 00       	push   $0x99
  8006b1:	68 9c 43 80 00       	push   $0x80439c
  8006b6:	e8 e2 0c 00 00       	call   80139d <_panic>
		}

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006bb:	e8 e2 21 00 00       	call   8028a2 <sys_calculate_free_frames>
  8006c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006c3:	e8 25 22 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  8006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8006cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	01 d2                	add    %edx,%edx
  8006d2:	01 d0                	add    %edx,%eax
  8006d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	50                   	push   %eax
  8006db:	e8 a3 1d 00 00       	call   802483 <malloc>
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
  80070d:	68 b0 43 80 00       	push   $0x8043b0
  800712:	68 a1 00 00 00       	push   $0xa1
  800717:	68 9c 43 80 00       	push   $0x80439c
  80071c:	e8 7c 0c 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800721:	e8 c7 21 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800726:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800729:	74 17                	je     800742 <_main+0x70a>
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	68 e0 43 80 00       	push   $0x8043e0
  800733:	68 a2 00 00 00       	push   $0xa2
  800738:	68 9c 43 80 00       	push   $0x80439c
  80073d:	e8 5b 0c 00 00       	call   80139d <_panic>
		}

		//6 MB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800742:	e8 a6 21 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
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
  80075c:	e8 22 1d 00 00       	call   802483 <malloc>
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
  800795:	68 b0 43 80 00       	push   $0x8043b0
  80079a:	68 a9 00 00 00       	push   $0xa9
  80079f:	68 9c 43 80 00       	push   $0x80439c
  8007a4:	e8 f4 0b 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8007a9:	e8 3f 21 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  8007ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007b1:	74 17                	je     8007ca <_main+0x792>
  8007b3:	83 ec 04             	sub    $0x4,%esp
  8007b6:	68 e0 43 80 00       	push   $0x8043e0
  8007bb:	68 aa 00 00 00       	push   $0xaa
  8007c0:	68 9c 43 80 00       	push   $0x80439c
  8007c5:	e8 d3 0b 00 00       	call   80139d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8007ca:	e8 d3 20 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800839:	e8 64 20 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800856:	68 10 44 80 00       	push   $0x804410
  80085b:	68 b5 00 00 00       	push   $0xb5
  800860:	68 9c 43 80 00       	push   $0x80439c
  800865:	e8 33 0b 00 00       	call   80139d <_panic>
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
  8008e3:	e8 d7 24 00 00       	call   802dbf <sys_check_WS_list>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8008ee:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 8c 44 80 00       	push   $0x80448c
  8008fc:	68 b8 00 00 00       	push   $0xb8
  800901:	68 9c 43 80 00       	push   $0x80439c
  800906:	e8 92 0a 00 00       	call   80139d <_panic>
		}

		//14 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80090b:	e8 dd 1f 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
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
  800926:	e8 58 1b 00 00       	call   802483 <malloc>
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
  800960:	68 b0 43 80 00       	push   $0x8043b0
  800965:	68 bf 00 00 00       	push   $0xbf
  80096a:	68 9c 43 80 00       	push   $0x80439c
  80096f:	e8 29 0a 00 00       	call   80139d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800974:	e8 74 1f 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800979:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80097c:	74 17                	je     800995 <_main+0x95d>
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	68 e0 43 80 00       	push   $0x8043e0
  800986:	68 c0 00 00 00       	push   $0xc0
  80098b:	68 9c 43 80 00       	push   $0x80439c
  800990:	e8 08 0a 00 00       	call   80139d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800995:	e8 08 1f 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800a1e:	e8 7f 1e 00 00       	call   8028a2 <sys_calculate_free_frames>
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
  800a3b:	68 10 44 80 00       	push   $0x804410
  800a40:	68 cb 00 00 00       	push   $0xcb
  800a45:	68 9c 43 80 00       	push   $0x80439c
  800a4a:	e8 4e 09 00 00       	call   80139d <_panic>
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
  800ad4:	e8 e6 22 00 00       	call   802dbf <sys_check_WS_list>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800adf:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ae3:	74 17                	je     800afc <_main+0xac4>
  800ae5:	83 ec 04             	sub    $0x4,%esp
  800ae8:	68 8c 44 80 00       	push   $0x80448c
  800aed:	68 ce 00 00 00       	push   $0xce
  800af2:	68 9c 43 80 00       	push   $0x80439c
  800af7:	e8 a1 08 00 00       	call   80139d <_panic>
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
  800b1f:	e8 7e 1d 00 00       	call   8028a2 <sys_calculate_free_frames>
  800b24:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b27:	e8 c1 1d 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[0]);
  800b2f:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800b35:	83 ec 0c             	sub    $0xc,%esp
  800b38:	50                   	push   %eax
  800b39:	e8 a1 1a 00 00       	call   8025df <free>
  800b3e:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800b41:	e8 a7 1d 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800b46:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800b49:	74 17                	je     800b62 <_main+0xb2a>
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	68 ac 44 80 00       	push   $0x8044ac
  800b53:	68 db 00 00 00       	push   $0xdb
  800b58:	68 9c 43 80 00       	push   $0x80439c
  800b5d:	e8 3b 08 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800b62:	e8 3b 1d 00 00       	call   8028a2 <sys_calculate_free_frames>
  800b67:	89 c2                	mov    %eax,%edx
  800b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b6c:	29 c2                	sub    %eax,%edx
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	83 f8 02             	cmp    $0x2,%eax
  800b73:	74 17                	je     800b8c <_main+0xb54>
  800b75:	83 ec 04             	sub    $0x4,%esp
  800b78:	68 e8 44 80 00       	push   $0x8044e8
  800b7d:	68 dc 00 00 00       	push   $0xdc
  800b82:	68 9c 43 80 00       	push   $0x80439c
  800b87:	e8 11 08 00 00       	call   80139d <_panic>
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
  800bd2:	e8 e8 21 00 00       	call   802dbf <sys_check_WS_list>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800bdd:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800be1:	74 17                	je     800bfa <_main+0xbc2>
  800be3:	83 ec 04             	sub    $0x4,%esp
  800be6:	68 34 45 80 00       	push   $0x804534
  800beb:	68 df 00 00 00       	push   $0xdf
  800bf0:	68 9c 43 80 00       	push   $0x80439c
  800bf5:	e8 a3 07 00 00       	call   80139d <_panic>
		}

		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bfa:	e8 a3 1c 00 00       	call   8028a2 <sys_calculate_free_frames>
  800bff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c02:	e8 e6 1c 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800c07:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[1]);
  800c0a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	e8 c6 19 00 00       	call   8025df <free>
  800c19:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800c1c:	e8 cc 1c 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800c21:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 ac 44 80 00       	push   $0x8044ac
  800c2e:	68 e7 00 00 00       	push   $0xe7
  800c33:	68 9c 43 80 00       	push   $0x80439c
  800c38:	e8 60 07 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800c3d:	e8 60 1c 00 00       	call   8028a2 <sys_calculate_free_frames>
  800c42:	89 c2                	mov    %eax,%edx
  800c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c47:	29 c2                	sub    %eax,%edx
  800c49:	89 d0                	mov    %edx,%eax
  800c4b:	83 f8 02             	cmp    $0x2,%eax
  800c4e:	74 17                	je     800c67 <_main+0xc2f>
  800c50:	83 ec 04             	sub    $0x4,%esp
  800c53:	68 e8 44 80 00       	push   $0x8044e8
  800c58:	68 e8 00 00 00       	push   $0xe8
  800c5d:	68 9c 43 80 00       	push   $0x80439c
  800c62:	e8 36 07 00 00       	call   80139d <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800c67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c6a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800c70:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c7b:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
  800c81:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800c84:	01 c0                	add    %eax,%eax
  800c86:	89 c2                	mov    %eax,%edx
  800c88:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c8b:	01 d0                	add    %edx,%eax
  800c8d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800c93:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c9e:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800ca4:	6a 03                	push   $0x3
  800ca6:	6a 00                	push   $0x0
  800ca8:	6a 02                	push   $0x2
  800caa:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800cb0:	50                   	push   %eax
  800cb1:	e8 09 21 00 00       	call   802dbf <sys_check_WS_list>
  800cb6:	83 c4 10             	add    $0x10,%esp
  800cb9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800cbc:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800cc0:	74 17                	je     800cd9 <_main+0xca1>
  800cc2:	83 ec 04             	sub    $0x4,%esp
  800cc5:	68 34 45 80 00       	push   $0x804534
  800cca:	68 eb 00 00 00       	push   $0xeb
  800ccf:	68 9c 43 80 00       	push   $0x80439c
  800cd4:	e8 c4 06 00 00       	call   80139d <_panic>
		}

		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800cd9:	e8 c4 1b 00 00       	call   8028a2 <sys_calculate_free_frames>
  800cde:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ce1:	e8 07 1c 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800ce6:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[6]);
  800ce9:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	e8 e7 18 00 00       	call   8025df <free>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800cfb:	e8 ed 1b 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xce4>
  800d05:	83 ec 04             	sub    $0x4,%esp
  800d08:	68 ac 44 80 00       	push   $0x8044ac
  800d0d:	68 f3 00 00 00       	push   $0xf3
  800d12:	68 9c 43 80 00       	push   $0x80439c
  800d17:	e8 81 06 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800d1c:	e8 81 1b 00 00       	call   8028a2 <sys_calculate_free_frames>
  800d21:	89 c2                	mov    %eax,%edx
  800d23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
  800d2a:	83 f8 03             	cmp    $0x3,%eax
  800d2d:	74 17                	je     800d46 <_main+0xd0e>
  800d2f:	83 ec 04             	sub    $0x4,%esp
  800d32:	68 e8 44 80 00       	push   $0x8044e8
  800d37:	68 f4 00 00 00       	push   $0xf4
  800d3c:	68 9c 43 80 00       	push   $0x80439c
  800d41:	e8 57 06 00 00       	call   80139d <_panic>
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800d46:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d4c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800d52:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d5d:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800d63:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d66:	89 c2                	mov    %eax,%edx
  800d68:	c1 ea 1f             	shr    $0x1f,%edx
  800d6b:	01 d0                	add    %edx,%eax
  800d6d:	d1 f8                	sar    %eax
  800d6f:	89 c2                	mov    %eax,%edx
  800d71:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d77:	01 d0                	add    %edx,%eax
  800d79:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800d7f:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d8a:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
  800d90:	8b 55 80             	mov    -0x80(%ebp),%edx
  800d93:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800da1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800da7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dac:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  800db2:	6a 03                	push   $0x3
  800db4:	6a 00                	push   $0x0
  800db6:	6a 03                	push   $0x3
  800db8:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  800dbe:	50                   	push   %eax
  800dbf:	e8 fb 1f 00 00       	call   802dbf <sys_check_WS_list>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800dca:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800dce:	74 17                	je     800de7 <_main+0xdaf>
  800dd0:	83 ec 04             	sub    $0x4,%esp
  800dd3:	68 34 45 80 00       	push   $0x804534
  800dd8:	68 f7 00 00 00       	push   $0xf7
  800ddd:	68 9c 43 80 00       	push   $0x80439c
  800de2:	e8 b6 05 00 00       	call   80139d <_panic>
		}

		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800de7:	e8 b6 1a 00 00       	call   8028a2 <sys_calculate_free_frames>
  800dec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800def:	e8 f9 1a 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800df4:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[4]);
  800df7:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	e8 d9 17 00 00       	call   8025df <free>
  800e06:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e09:	e8 df 1a 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800e0e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800e11:	74 17                	je     800e2a <_main+0xdf2>
  800e13:	83 ec 04             	sub    $0x4,%esp
  800e16:	68 ac 44 80 00       	push   $0x8044ac
  800e1b:	68 ff 00 00 00       	push   $0xff
  800e20:	68 9c 43 80 00       	push   $0x80439c
  800e25:	e8 73 05 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e2a:	e8 73 1a 00 00       	call   8028a2 <sys_calculate_free_frames>
  800e2f:	89 c2                	mov    %eax,%edx
  800e31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e34:	29 c2                	sub    %eax,%edx
  800e36:	89 d0                	mov    %edx,%eax
  800e38:	83 f8 02             	cmp    $0x2,%eax
  800e3b:	74 17                	je     800e54 <_main+0xe1c>
  800e3d:	83 ec 04             	sub    $0x4,%esp
  800e40:	68 e8 44 80 00       	push   $0x8044e8
  800e45:	68 00 01 00 00       	push   $0x100
  800e4a:	68 9c 43 80 00       	push   $0x80439c
  800e4f:	e8 49 05 00 00       	call   80139d <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800e54:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e57:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800e5d:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800e63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e68:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  800e6e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800e71:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800e78:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e7b:	01 d0                	add    %edx,%eax
  800e7d:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800e83:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800e89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e8e:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800e94:	6a 03                	push   $0x3
  800e96:	6a 00                	push   $0x0
  800e98:	6a 02                	push   $0x2
  800e9a:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	e8 19 1f 00 00       	call   802dbf <sys_check_WS_list>
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800eac:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800eb0:	74 17                	je     800ec9 <_main+0xe91>
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	68 34 45 80 00       	push   $0x804534
  800eba:	68 03 01 00 00       	push   $0x103
  800ebf:	68 9c 43 80 00       	push   $0x80439c
  800ec4:	e8 d4 04 00 00       	call   80139d <_panic>
		}

		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800ec9:	e8 d4 19 00 00       	call   8028a2 <sys_calculate_free_frames>
  800ece:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed1:	e8 17 1a 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800ed6:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[5]);
  800ed9:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	50                   	push   %eax
  800ee3:	e8 f7 16 00 00       	call   8025df <free>
  800ee8:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800eeb:	e8 fd 19 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800ef0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800ef3:	74 17                	je     800f0c <_main+0xed4>
  800ef5:	83 ec 04             	sub    $0x4,%esp
  800ef8:	68 ac 44 80 00       	push   $0x8044ac
  800efd:	68 0b 01 00 00       	push   $0x10b
  800f02:	68 9c 43 80 00       	push   $0x80439c
  800f07:	e8 91 04 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f0c:	e8 91 19 00 00       	call   8028a2 <sys_calculate_free_frames>
  800f11:	89 c2                	mov    %eax,%edx
  800f13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f16:	39 c2                	cmp    %eax,%edx
  800f18:	74 17                	je     800f31 <_main+0xef9>
  800f1a:	83 ec 04             	sub    $0x4,%esp
  800f1d:	68 e8 44 80 00       	push   $0x8044e8
  800f22:	68 0c 01 00 00       	push   $0x10c
  800f27:	68 9c 43 80 00       	push   $0x80439c
  800f2c:	e8 6c 04 00 00       	call   80139d <_panic>
		}

		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f31:	e8 6c 19 00 00       	call   8028a2 <sys_calculate_free_frames>
  800f36:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f39:	e8 af 19 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800f3e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[2]);
  800f41:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	50                   	push   %eax
  800f4b:	e8 8f 16 00 00       	call   8025df <free>
  800f50:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f53:	e8 95 19 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  800f58:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800f5b:	74 17                	je     800f74 <_main+0xf3c>
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	68 ac 44 80 00       	push   $0x8044ac
  800f65:	68 14 01 00 00       	push   $0x114
  800f6a:	68 9c 43 80 00       	push   $0x80439c
  800f6f:	e8 29 04 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f74:	e8 29 19 00 00       	call   8028a2 <sys_calculate_free_frames>
  800f79:	89 c2                	mov    %eax,%edx
  800f7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f7e:	29 c2                	sub    %eax,%edx
  800f80:	89 d0                	mov    %edx,%eax
  800f82:	83 f8 01             	cmp    $0x1,%eax
  800f85:	74 17                	je     800f9e <_main+0xf66>
  800f87:	83 ec 04             	sub    $0x4,%esp
  800f8a:	68 e8 44 80 00       	push   $0x8044e8
  800f8f:	68 15 01 00 00       	push   $0x115
  800f94:	68 9c 43 80 00       	push   $0x80439c
  800f99:	e8 ff 03 00 00       	call   80139d <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  800f9e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800fa1:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800fa7:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800fad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb2:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  800fb8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800fbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fc2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800fc5:	01 d0                	add    %edx,%eax
  800fc7:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800fcd:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800fd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd8:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800fde:	6a 03                	push   $0x3
  800fe0:	6a 00                	push   $0x0
  800fe2:	6a 02                	push   $0x2
  800fe4:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  800fea:	50                   	push   %eax
  800feb:	e8 cf 1d 00 00       	call   802dbf <sys_check_WS_list>
  800ff0:	83 c4 10             	add    $0x10,%esp
  800ff3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800ff6:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ffa:	74 17                	je     801013 <_main+0xfdb>
  800ffc:	83 ec 04             	sub    $0x4,%esp
  800fff:	68 34 45 80 00       	push   $0x804534
  801004:	68 18 01 00 00       	push   $0x118
  801009:	68 9c 43 80 00       	push   $0x80439c
  80100e:	e8 8a 03 00 00       	call   80139d <_panic>
		}

		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801013:	e8 8a 18 00 00       	call   8028a2 <sys_calculate_free_frames>
  801018:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80101b:	e8 cd 18 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  801020:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[3]);
  801023:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801029:	83 ec 0c             	sub    $0xc,%esp
  80102c:	50                   	push   %eax
  80102d:	e8 ad 15 00 00       	call   8025df <free>
  801032:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801035:	e8 b3 18 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  80103a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80103d:	74 17                	je     801056 <_main+0x101e>
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 ac 44 80 00       	push   $0x8044ac
  801047:	68 20 01 00 00       	push   $0x120
  80104c:	68 9c 43 80 00       	push   $0x80439c
  801051:	e8 47 03 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801056:	e8 47 18 00 00       	call   8028a2 <sys_calculate_free_frames>
  80105b:	89 c2                	mov    %eax,%edx
  80105d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801060:	39 c2                	cmp    %eax,%edx
  801062:	74 17                	je     80107b <_main+0x1043>
  801064:	83 ec 04             	sub    $0x4,%esp
  801067:	68 e8 44 80 00       	push   $0x8044e8
  80106c:	68 21 01 00 00       	push   $0x121
  801071:	68 9c 43 80 00       	push   $0x80439c
  801076:	e8 22 03 00 00       	call   80139d <_panic>
		}

		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80107b:	e8 22 18 00 00       	call   8028a2 <sys_calculate_free_frames>
  801080:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801083:	e8 65 18 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  801088:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[7]);
  80108b:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  801091:	83 ec 0c             	sub    $0xc,%esp
  801094:	50                   	push   %eax
  801095:	e8 45 15 00 00       	call   8025df <free>
  80109a:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80109d:	e8 4b 18 00 00       	call   8028ed <sys_pf_calculate_allocated_pages>
  8010a2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8010a5:	74 17                	je     8010be <_main+0x1086>
  8010a7:	83 ec 04             	sub    $0x4,%esp
  8010aa:	68 ac 44 80 00       	push   $0x8044ac
  8010af:	68 29 01 00 00       	push   $0x129
  8010b4:	68 9c 43 80 00       	push   $0x80439c
  8010b9:	e8 df 02 00 00       	call   80139d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8010be:	e8 df 17 00 00       	call   8028a2 <sys_calculate_free_frames>
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010c8:	29 c2                	sub    %eax,%edx
  8010ca:	89 d0                	mov    %edx,%eax
  8010cc:	83 f8 03             	cmp    $0x3,%eax
  8010cf:	74 17                	je     8010e8 <_main+0x10b0>
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	68 e8 44 80 00       	push   $0x8044e8
  8010d9:	68 2a 01 00 00       	push   $0x12a
  8010de:	68 9c 43 80 00       	push   $0x80439c
  8010e3:	e8 b5 02 00 00       	call   80139d <_panic>
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  8010e8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8010ee:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  8010f4:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  8010fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010ff:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801105:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80110b:	89 c2                	mov    %eax,%edx
  80110d:	c1 ea 1f             	shr    $0x1f,%edx
  801110:	01 d0                	add    %edx,%eax
  801112:	d1 f8                	sar    %eax
  801114:	01 c0                	add    %eax,%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801126:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80112c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801131:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
  801137:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80113d:	01 c0                	add    %eax,%eax
  80113f:	89 c2                	mov    %eax,%edx
  801141:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801147:	01 d0                	add    %edx,%eax
  801149:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80114f:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801155:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115a:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801160:	6a 03                	push   $0x3
  801162:	6a 00                	push   $0x0
  801164:	6a 03                	push   $0x3
  801166:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80116c:	50                   	push   %eax
  80116d:	e8 4d 1c 00 00       	call   802dbf <sys_check_WS_list>
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  801178:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  80117c:	74 17                	je     801195 <_main+0x115d>
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 34 45 80 00       	push   $0x804534
  801186:	68 2d 01 00 00       	push   $0x12d
  80118b:	68 9c 43 80 00       	push   $0x80439c
  801190:	e8 08 02 00 00       	call   80139d <_panic>
		}
	}

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		rsttst();
  801195:	e8 71 1a 00 00       	call   802c0b <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80119a:	a1 20 50 80 00       	mov    0x805020,%eax
  80119f:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  8011a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8011aa:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8011b0:	89 c1                	mov    %eax,%ecx
  8011b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b7:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  8011bd:	52                   	push   %edx
  8011be:	51                   	push   %ecx
  8011bf:	50                   	push   %eax
  8011c0:	68 56 45 80 00       	push   $0x804556
  8011c5:	e8 f5 18 00 00       	call   802abf <sys_create_env>
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		sys_run_env(ID1);
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	ff b5 1c ff ff ff    	pushl  -0xe4(%ebp)
  8011dc:	e8 fc 18 00 00       	call   802add <sys_run_env>
  8011e1:	83 c4 10             	add    $0x10,%esp

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8011e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011e9:	8b 90 c8 05 00 00    	mov    0x5c8(%eax),%edx
  8011ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f4:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8011fa:	89 c1                	mov    %eax,%ecx
  8011fc:	a1 20 50 80 00       	mov    0x805020,%eax
  801201:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  801207:	52                   	push   %edx
  801208:	51                   	push   %ecx
  801209:	50                   	push   %eax
  80120a:	68 61 45 80 00       	push   $0x804561
  80120f:	e8 ab 18 00 00       	call   802abf <sys_create_env>
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		sys_run_env(ID2);
  80121d:	83 ec 0c             	sub    $0xc,%esp
  801220:	ff b5 18 ff ff ff    	pushl  -0xe8(%ebp)
  801226:	e8 b2 18 00 00       	call   802add <sys_run_env>
  80122b:	83 c4 10             	add    $0x10,%esp

		env_sleep(10000);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	68 10 27 00 00       	push   $0x2710
  801236:	e8 28 2e 00 00       	call   804063 <env_sleep>
  80123b:	83 c4 10             	add    $0x10,%esp

		if (gettst() != 0)
  80123e:	e8 42 1a 00 00       	call   802c85 <gettst>
  801243:	85 c0                	test   %eax,%eax
  801245:	74 10                	je     801257 <_main+0x121f>
			cprintf("\nFree: successful access to freed space!! (processes should be killed by the validation of the fault handler)\n");
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	68 6c 45 80 00       	push   $0x80456c
  80124f:	e8 06 04 00 00       	call   80165a <cprintf>
  801254:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Congratulations!! test free [1] [PAGE ALLOCATOR] completed successfully.\n");
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	68 dc 45 80 00       	push   $0x8045dc
  80125f:	e8 f6 03 00 00       	call   80165a <cprintf>
  801264:	83 c4 10             	add    $0x10,%esp

	return;
  801267:	90                   	nop
}
  801268:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801275:	e8 b3 18 00 00       	call   802b2d <sys_getenvindex>
  80127a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	89 d0                	mov    %edx,%eax
  801282:	01 c0                	add    %eax,%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	c1 e0 06             	shl    $0x6,%eax
  801289:	29 d0                	sub    %edx,%eax
  80128b:	c1 e0 03             	shl    $0x3,%eax
  80128e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801293:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801298:	a1 20 50 80 00       	mov    0x805020,%eax
  80129d:	8a 40 68             	mov    0x68(%eax),%al
  8012a0:	84 c0                	test   %al,%al
  8012a2:	74 0d                	je     8012b1 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8012a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8012a9:	83 c0 68             	add    $0x68,%eax
  8012ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b5:	7e 0a                	jle    8012c1 <libmain+0x52>
		binaryname = argv[0];
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 00                	mov    (%eax),%eax
  8012bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	ff 75 0c             	pushl  0xc(%ebp)
  8012c7:	ff 75 08             	pushl  0x8(%ebp)
  8012ca:	e8 69 ed ff ff       	call   800038 <_main>
  8012cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8012d2:	e8 63 16 00 00       	call   80293a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	68 40 46 80 00       	push   $0x804640
  8012df:	e8 76 03 00 00       	call   80165a <cprintf>
  8012e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8012e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8012ec:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8012f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8012f7:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	52                   	push   %edx
  801301:	50                   	push   %eax
  801302:	68 68 46 80 00       	push   $0x804668
  801307:	e8 4e 03 00 00       	call   80165a <cprintf>
  80130c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80130f:	a1 20 50 80 00       	mov    0x805020,%eax
  801314:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80131a:	a1 20 50 80 00       	mov    0x805020,%eax
  80131f:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  801325:	a1 20 50 80 00       	mov    0x805020,%eax
  80132a:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  801330:	51                   	push   %ecx
  801331:	52                   	push   %edx
  801332:	50                   	push   %eax
  801333:	68 90 46 80 00       	push   $0x804690
  801338:	e8 1d 03 00 00       	call   80165a <cprintf>
  80133d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801340:	a1 20 50 80 00       	mov    0x805020,%eax
  801345:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80134b:	83 ec 08             	sub    $0x8,%esp
  80134e:	50                   	push   %eax
  80134f:	68 e8 46 80 00       	push   $0x8046e8
  801354:	e8 01 03 00 00       	call   80165a <cprintf>
  801359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	68 40 46 80 00       	push   $0x804640
  801364:	e8 f1 02 00 00       	call   80165a <cprintf>
  801369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80136c:	e8 e3 15 00 00       	call   802954 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801371:	e8 19 00 00 00       	call   80138f <exit>
}
  801376:	90                   	nop
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	6a 00                	push   $0x0
  801384:	e8 70 17 00 00       	call   802af9 <sys_destroy_env>
  801389:	83 c4 10             	add    $0x10,%esp
}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <exit>:

void
exit(void)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801395:	e8 c5 17 00 00       	call   802b5f <sys_exit_env>
}
  80139a:	90                   	nop
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8013a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8013a6:	83 c0 04             	add    $0x4,%eax
  8013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8013ac:	a1 18 51 80 00       	mov    0x805118,%eax
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	74 16                	je     8013cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8013b5:	a1 18 51 80 00       	mov    0x805118,%eax
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	50                   	push   %eax
  8013be:	68 fc 46 80 00       	push   $0x8046fc
  8013c3:	e8 92 02 00 00       	call   80165a <cprintf>
  8013c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8013cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8013d0:	ff 75 0c             	pushl  0xc(%ebp)
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	50                   	push   %eax
  8013d7:	68 01 47 80 00       	push   $0x804701
  8013dc:	e8 79 02 00 00       	call   80165a <cprintf>
  8013e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ed:	50                   	push   %eax
  8013ee:	e8 fc 01 00 00       	call   8015ef <vcprintf>
  8013f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	6a 00                	push   $0x0
  8013fb:	68 1d 47 80 00       	push   $0x80471d
  801400:	e8 ea 01 00 00       	call   8015ef <vcprintf>
  801405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801408:	e8 82 ff ff ff       	call   80138f <exit>

	// should not return here
	while (1) ;
  80140d:	eb fe                	jmp    80140d <_panic+0x70>

0080140f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801415:	a1 20 50 80 00       	mov    0x805020,%eax
  80141a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	39 c2                	cmp    %eax,%edx
  801425:	74 14                	je     80143b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	68 20 47 80 00       	push   $0x804720
  80142f:	6a 26                	push   $0x26
  801431:	68 6c 47 80 00       	push   $0x80476c
  801436:	e8 62 ff ff ff       	call   80139d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80143b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801442:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801449:	e9 c5 00 00 00       	jmp    801513 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80144e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	8b 00                	mov    (%eax),%eax
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 08                	jne    80146b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801463:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801466:	e9 a5 00 00 00       	jmp    801510 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80146b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801472:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801479:	eb 69                	jmp    8014e4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80147b:	a1 20 50 80 00       	mov    0x805020,%eax
  801480:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  801486:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801489:	89 d0                	mov    %edx,%eax
  80148b:	01 c0                	add    %eax,%eax
  80148d:	01 d0                	add    %edx,%eax
  80148f:	c1 e0 03             	shl    $0x3,%eax
  801492:	01 c8                	add    %ecx,%eax
  801494:	8a 40 04             	mov    0x4(%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	75 46                	jne    8014e1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80149b:	a1 20 50 80 00       	mov    0x805020,%eax
  8014a0:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8014a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014a9:	89 d0                	mov    %edx,%eax
  8014ab:	01 c0                	add    %eax,%eax
  8014ad:	01 d0                	add    %edx,%eax
  8014af:	c1 e0 03             	shl    $0x3,%eax
  8014b2:	01 c8                	add    %ecx,%eax
  8014b4:	8b 00                	mov    (%eax),%eax
  8014b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8014c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	01 c8                	add    %ecx,%eax
  8014d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8014d4:	39 c2                	cmp    %eax,%edx
  8014d6:	75 09                	jne    8014e1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8014d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8014df:	eb 15                	jmp    8014f6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014e1:	ff 45 e8             	incl   -0x18(%ebp)
  8014e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e9:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8014ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f2:	39 c2                	cmp    %eax,%edx
  8014f4:	77 85                	ja     80147b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8014f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014fa:	75 14                	jne    801510 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8014fc:	83 ec 04             	sub    $0x4,%esp
  8014ff:	68 78 47 80 00       	push   $0x804778
  801504:	6a 3a                	push   $0x3a
  801506:	68 6c 47 80 00       	push   $0x80476c
  80150b:	e8 8d fe ff ff       	call   80139d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801510:	ff 45 f0             	incl   -0x10(%ebp)
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801519:	0f 8c 2f ff ff ff    	jl     80144e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80151f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801526:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80152d:	eb 26                	jmp    801555 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80152f:	a1 20 50 80 00       	mov    0x805020,%eax
  801534:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80153a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	01 c0                	add    %eax,%eax
  801541:	01 d0                	add    %edx,%eax
  801543:	c1 e0 03             	shl    $0x3,%eax
  801546:	01 c8                	add    %ecx,%eax
  801548:	8a 40 04             	mov    0x4(%eax),%al
  80154b:	3c 01                	cmp    $0x1,%al
  80154d:	75 03                	jne    801552 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80154f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801552:	ff 45 e0             	incl   -0x20(%ebp)
  801555:	a1 20 50 80 00       	mov    0x805020,%eax
  80155a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  801560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801563:	39 c2                	cmp    %eax,%edx
  801565:	77 c8                	ja     80152f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80156d:	74 14                	je     801583 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	68 cc 47 80 00       	push   $0x8047cc
  801577:	6a 44                	push   $0x44
  801579:	68 6c 47 80 00       	push   $0x80476c
  80157e:	e8 1a fe ff ff       	call   80139d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	8b 00                	mov    (%eax),%eax
  801591:	8d 48 01             	lea    0x1(%eax),%ecx
  801594:	8b 55 0c             	mov    0xc(%ebp),%edx
  801597:	89 0a                	mov    %ecx,(%edx)
  801599:	8b 55 08             	mov    0x8(%ebp),%edx
  80159c:	88 d1                	mov    %dl,%cl
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8015af:	75 2c                	jne    8015dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8015b1:	a0 24 50 80 00       	mov    0x805024,%al
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 12                	mov    (%edx),%edx
  8015be:	89 d1                	mov    %edx,%ecx
  8015c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c3:	83 c2 08             	add    $0x8,%edx
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	50                   	push   %eax
  8015ca:	51                   	push   %ecx
  8015cb:	52                   	push   %edx
  8015cc:	e8 10 12 00 00       	call   8027e1 <sys_cputs>
  8015d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8015d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e0:	8b 40 04             	mov    0x4(%eax),%eax
  8015e3:	8d 50 01             	lea    0x1(%eax),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8015ec:	90                   	nop
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8015f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8015ff:	00 00 00 
	b.cnt = 0;
  801602:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801609:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801618:	50                   	push   %eax
  801619:	68 86 15 80 00       	push   $0x801586
  80161e:	e8 11 02 00 00       	call   801834 <vprintfmt>
  801623:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801626:	a0 24 50 80 00       	mov    0x805024,%al
  80162b:	0f b6 c0             	movzbl %al,%eax
  80162e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	50                   	push   %eax
  801638:	52                   	push   %edx
  801639:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80163f:	83 c0 08             	add    $0x8,%eax
  801642:	50                   	push   %eax
  801643:	e8 99 11 00 00       	call   8027e1 <sys_cputs>
  801648:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80164b:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801652:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <cprintf>:

int cprintf(const char *fmt, ...) {
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801660:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801667:	8d 45 0c             	lea    0xc(%ebp),%eax
  80166a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 f4             	pushl  -0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	e8 73 ff ff ff       	call   8015ef <vcprintf>
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80168d:	e8 a8 12 00 00       	call   80293a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801692:	8d 45 0c             	lea    0xc(%ebp),%eax
  801695:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a1:	50                   	push   %eax
  8016a2:	e8 48 ff ff ff       	call   8015ef <vcprintf>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8016ad:	e8 a2 12 00 00       	call   802954 <sys_enable_interrupt>
	return cnt;
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	53                   	push   %ebx
  8016bb:	83 ec 14             	sub    $0x14,%esp
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8016cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016d5:	77 55                	ja     80172c <printnum+0x75>
  8016d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016da:	72 05                	jb     8016e1 <printnum+0x2a>
  8016dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016df:	77 4b                	ja     80172c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8016e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8016e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	52                   	push   %edx
  8016f0:	50                   	push   %eax
  8016f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f7:	e8 1c 2a 00 00       	call   804118 <__udivdi3>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	ff 75 20             	pushl  0x20(%ebp)
  801705:	53                   	push   %ebx
  801706:	ff 75 18             	pushl  0x18(%ebp)
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 a1 ff ff ff       	call   8016b7 <printnum>
  801716:	83 c4 20             	add    $0x20,%esp
  801719:	eb 1a                	jmp    801735 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	ff 75 20             	pushl  0x20(%ebp)
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	ff d0                	call   *%eax
  801729:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80172c:	ff 4d 1c             	decl   0x1c(%ebp)
  80172f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801733:	7f e6                	jg     80171b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801735:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801738:	bb 00 00 00 00       	mov    $0x0,%ebx
  80173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801743:	53                   	push   %ebx
  801744:	51                   	push   %ecx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	e8 dc 2a 00 00       	call   804228 <__umoddi3>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	05 34 4a 80 00       	add    $0x804a34,%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	0f be c0             	movsbl %al,%eax
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	ff 75 0c             	pushl  0xc(%ebp)
  80175f:	50                   	push   %eax
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	ff d0                	call   *%eax
  801765:	83 c4 10             	add    $0x10,%esp
}
  801768:	90                   	nop
  801769:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801771:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801775:	7e 1c                	jle    801793 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	8b 00                	mov    (%eax),%eax
  80177c:	8d 50 08             	lea    0x8(%eax),%edx
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	89 10                	mov    %edx,(%eax)
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8b 00                	mov    (%eax),%eax
  801789:	83 e8 08             	sub    $0x8,%eax
  80178c:	8b 50 04             	mov    0x4(%eax),%edx
  80178f:	8b 00                	mov    (%eax),%eax
  801791:	eb 40                	jmp    8017d3 <getuint+0x65>
	else if (lflag)
  801793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801797:	74 1e                	je     8017b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8b 00                	mov    (%eax),%eax
  80179e:	8d 50 04             	lea    0x4(%eax),%edx
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	89 10                	mov    %edx,(%eax)
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8b 00                	mov    (%eax),%eax
  8017ab:	83 e8 04             	sub    $0x4,%eax
  8017ae:	8b 00                	mov    (%eax),%eax
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	eb 1c                	jmp    8017d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8b 00                	mov    (%eax),%eax
  8017bc:	8d 50 04             	lea    0x4(%eax),%edx
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	89 10                	mov    %edx,(%eax)
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8b 00                	mov    (%eax),%eax
  8017c9:	83 e8 04             	sub    $0x4,%eax
  8017cc:	8b 00                	mov    (%eax),%eax
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    

008017d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017dc:	7e 1c                	jle    8017fa <getint+0x25>
		return va_arg(*ap, long long);
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	8b 00                	mov    (%eax),%eax
  8017e3:	8d 50 08             	lea    0x8(%eax),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	89 10                	mov    %edx,(%eax)
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8b 00                	mov    (%eax),%eax
  8017f0:	83 e8 08             	sub    $0x8,%eax
  8017f3:	8b 50 04             	mov    0x4(%eax),%edx
  8017f6:	8b 00                	mov    (%eax),%eax
  8017f8:	eb 38                	jmp    801832 <getint+0x5d>
	else if (lflag)
  8017fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017fe:	74 1a                	je     80181a <getint+0x45>
		return va_arg(*ap, long);
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8b 00                	mov    (%eax),%eax
  801805:	8d 50 04             	lea    0x4(%eax),%edx
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	89 10                	mov    %edx,(%eax)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	83 e8 04             	sub    $0x4,%eax
  801815:	8b 00                	mov    (%eax),%eax
  801817:	99                   	cltd   
  801818:	eb 18                	jmp    801832 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	8d 50 04             	lea    0x4(%eax),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 10                	mov    %edx,(%eax)
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8b 00                	mov    (%eax),%eax
  80182c:	83 e8 04             	sub    $0x4,%eax
  80182f:	8b 00                	mov    (%eax),%eax
  801831:	99                   	cltd   
}
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80183c:	eb 17                	jmp    801855 <vprintfmt+0x21>
			if (ch == '\0')
  80183e:	85 db                	test   %ebx,%ebx
  801840:	0f 84 af 03 00 00    	je     801bf5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801846:	83 ec 08             	sub    $0x8,%esp
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	53                   	push   %ebx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	ff d0                	call   *%eax
  801852:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801855:	8b 45 10             	mov    0x10(%ebp),%eax
  801858:	8d 50 01             	lea    0x1(%eax),%edx
  80185b:	89 55 10             	mov    %edx,0x10(%ebp)
  80185e:	8a 00                	mov    (%eax),%al
  801860:	0f b6 d8             	movzbl %al,%ebx
  801863:	83 fb 25             	cmp    $0x25,%ebx
  801866:	75 d6                	jne    80183e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801868:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80186c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801873:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80187a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801881:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801888:	8b 45 10             	mov    0x10(%ebp),%eax
  80188b:	8d 50 01             	lea    0x1(%eax),%edx
  80188e:	89 55 10             	mov    %edx,0x10(%ebp)
  801891:	8a 00                	mov    (%eax),%al
  801893:	0f b6 d8             	movzbl %al,%ebx
  801896:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801899:	83 f8 55             	cmp    $0x55,%eax
  80189c:	0f 87 2b 03 00 00    	ja     801bcd <vprintfmt+0x399>
  8018a2:	8b 04 85 58 4a 80 00 	mov    0x804a58(,%eax,4),%eax
  8018a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8018ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8018af:	eb d7                	jmp    801888 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8018b5:	eb d1                	jmp    801888 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8018be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018c1:	89 d0                	mov    %edx,%eax
  8018c3:	c1 e0 02             	shl    $0x2,%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	01 c0                	add    %eax,%eax
  8018ca:	01 d8                	add    %ebx,%eax
  8018cc:	83 e8 30             	sub    $0x30,%eax
  8018cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8018d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d5:	8a 00                	mov    (%eax),%al
  8018d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8018da:	83 fb 2f             	cmp    $0x2f,%ebx
  8018dd:	7e 3e                	jle    80191d <vprintfmt+0xe9>
  8018df:	83 fb 39             	cmp    $0x39,%ebx
  8018e2:	7f 39                	jg     80191d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8018e7:	eb d5                	jmp    8018be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8018e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ec:	83 c0 04             	add    $0x4,%eax
  8018ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f5:	83 e8 04             	sub    $0x4,%eax
  8018f8:	8b 00                	mov    (%eax),%eax
  8018fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8018fd:	eb 1f                	jmp    80191e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8018ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801903:	79 83                	jns    801888 <vprintfmt+0x54>
				width = 0;
  801905:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80190c:	e9 77 ff ff ff       	jmp    801888 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801911:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801918:	e9 6b ff ff ff       	jmp    801888 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80191d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80191e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801922:	0f 89 60 ff ff ff    	jns    801888 <vprintfmt+0x54>
				width = precision, precision = -1;
  801928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80192e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801935:	e9 4e ff ff ff       	jmp    801888 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80193a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80193d:	e9 46 ff ff ff       	jmp    801888 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801942:	8b 45 14             	mov    0x14(%ebp),%eax
  801945:	83 c0 04             	add    $0x4,%eax
  801948:	89 45 14             	mov    %eax,0x14(%ebp)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	83 e8 04             	sub    $0x4,%eax
  801951:	8b 00                	mov    (%eax),%eax
  801953:	83 ec 08             	sub    $0x8,%esp
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	50                   	push   %eax
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	ff d0                	call   *%eax
  80195f:	83 c4 10             	add    $0x10,%esp
			break;
  801962:	e9 89 02 00 00       	jmp    801bf0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801967:	8b 45 14             	mov    0x14(%ebp),%eax
  80196a:	83 c0 04             	add    $0x4,%eax
  80196d:	89 45 14             	mov    %eax,0x14(%ebp)
  801970:	8b 45 14             	mov    0x14(%ebp),%eax
  801973:	83 e8 04             	sub    $0x4,%eax
  801976:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801978:	85 db                	test   %ebx,%ebx
  80197a:	79 02                	jns    80197e <vprintfmt+0x14a>
				err = -err;
  80197c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80197e:	83 fb 64             	cmp    $0x64,%ebx
  801981:	7f 0b                	jg     80198e <vprintfmt+0x15a>
  801983:	8b 34 9d a0 48 80 00 	mov    0x8048a0(,%ebx,4),%esi
  80198a:	85 f6                	test   %esi,%esi
  80198c:	75 19                	jne    8019a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80198e:	53                   	push   %ebx
  80198f:	68 45 4a 80 00       	push   $0x804a45
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	e8 5e 02 00 00       	call   801bfd <printfmt>
  80199f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8019a2:	e9 49 02 00 00       	jmp    801bf0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8019a7:	56                   	push   %esi
  8019a8:	68 4e 4a 80 00       	push   $0x804a4e
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	e8 45 02 00 00       	call   801bfd <printfmt>
  8019b8:	83 c4 10             	add    $0x10,%esp
			break;
  8019bb:	e9 30 02 00 00       	jmp    801bf0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8019c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c3:	83 c0 04             	add    $0x4,%eax
  8019c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	83 e8 04             	sub    $0x4,%eax
  8019cf:	8b 30                	mov    (%eax),%esi
  8019d1:	85 f6                	test   %esi,%esi
  8019d3:	75 05                	jne    8019da <vprintfmt+0x1a6>
				p = "(null)";
  8019d5:	be 51 4a 80 00       	mov    $0x804a51,%esi
			if (width > 0 && padc != '-')
  8019da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019de:	7e 6d                	jle    801a4d <vprintfmt+0x219>
  8019e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8019e4:	74 67                	je     801a4d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e9:	83 ec 08             	sub    $0x8,%esp
  8019ec:	50                   	push   %eax
  8019ed:	56                   	push   %esi
  8019ee:	e8 0c 03 00 00       	call   801cff <strnlen>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8019f9:	eb 16                	jmp    801a11 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8019fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	ff d0                	call   *%eax
  801a0b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  801a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a15:	7f e4                	jg     8019fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a17:	eb 34                	jmp    801a4d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a19:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a1d:	74 1c                	je     801a3b <vprintfmt+0x207>
  801a1f:	83 fb 1f             	cmp    $0x1f,%ebx
  801a22:	7e 05                	jle    801a29 <vprintfmt+0x1f5>
  801a24:	83 fb 7e             	cmp    $0x7e,%ebx
  801a27:	7e 12                	jle    801a3b <vprintfmt+0x207>
					putch('?', putdat);
  801a29:	83 ec 08             	sub    $0x8,%esp
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	6a 3f                	push   $0x3f
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	ff d0                	call   *%eax
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	eb 0f                	jmp    801a4a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801a3b:	83 ec 08             	sub    $0x8,%esp
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	53                   	push   %ebx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	ff d0                	call   *%eax
  801a47:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a4a:	ff 4d e4             	decl   -0x1c(%ebp)
  801a4d:	89 f0                	mov    %esi,%eax
  801a4f:	8d 70 01             	lea    0x1(%eax),%esi
  801a52:	8a 00                	mov    (%eax),%al
  801a54:	0f be d8             	movsbl %al,%ebx
  801a57:	85 db                	test   %ebx,%ebx
  801a59:	74 24                	je     801a7f <vprintfmt+0x24b>
  801a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a5f:	78 b8                	js     801a19 <vprintfmt+0x1e5>
  801a61:	ff 4d e0             	decl   -0x20(%ebp)
  801a64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a68:	79 af                	jns    801a19 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a6a:	eb 13                	jmp    801a7f <vprintfmt+0x24b>
				putch(' ', putdat);
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	6a 20                	push   $0x20
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	ff d0                	call   *%eax
  801a79:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a7c:	ff 4d e4             	decl   -0x1c(%ebp)
  801a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a83:	7f e7                	jg     801a6c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801a85:	e9 66 01 00 00       	jmp    801bf0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	ff 75 e8             	pushl  -0x18(%ebp)
  801a90:	8d 45 14             	lea    0x14(%ebp),%eax
  801a93:	50                   	push   %eax
  801a94:	e8 3c fd ff ff       	call   8017d5 <getint>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa8:	85 d2                	test   %edx,%edx
  801aaa:	79 23                	jns    801acf <vprintfmt+0x29b>
				putch('-', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 2d                	push   $0x2d
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac2:	f7 d8                	neg    %eax
  801ac4:	83 d2 00             	adc    $0x0,%edx
  801ac7:	f7 da                	neg    %edx
  801ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801acc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801acf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ad6:	e9 bc 00 00 00       	jmp    801b97 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	ff 75 e8             	pushl  -0x18(%ebp)
  801ae1:	8d 45 14             	lea    0x14(%ebp),%eax
  801ae4:	50                   	push   %eax
  801ae5:	e8 84 fc ff ff       	call   80176e <getuint>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801af3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801afa:	e9 98 00 00 00       	jmp    801b97 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	6a 58                	push   $0x58
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	ff d0                	call   *%eax
  801b0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	6a 58                	push   $0x58
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	ff d0                	call   *%eax
  801b1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b1f:	83 ec 08             	sub    $0x8,%esp
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	6a 58                	push   $0x58
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	ff d0                	call   *%eax
  801b2c:	83 c4 10             	add    $0x10,%esp
			break;
  801b2f:	e9 bc 00 00 00       	jmp    801bf0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801b34:	83 ec 08             	sub    $0x8,%esp
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	6a 30                	push   $0x30
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	ff d0                	call   *%eax
  801b41:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801b44:	83 ec 08             	sub    $0x8,%esp
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	6a 78                	push   $0x78
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	ff d0                	call   *%eax
  801b51:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801b54:	8b 45 14             	mov    0x14(%ebp),%eax
  801b57:	83 c0 04             	add    $0x4,%eax
  801b5a:	89 45 14             	mov    %eax,0x14(%ebp)
  801b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b60:	83 e8 04             	sub    $0x4,%eax
  801b63:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b6f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b76:	eb 1f                	jmp    801b97 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b78:	83 ec 08             	sub    $0x8,%esp
  801b7b:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7e:	8d 45 14             	lea    0x14(%ebp),%eax
  801b81:	50                   	push   %eax
  801b82:	e8 e7 fb ff ff       	call   80176e <getuint>
  801b87:	83 c4 10             	add    $0x10,%esp
  801b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b97:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	52                   	push   %edx
  801ba2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ba5:	50                   	push   %eax
  801ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba9:	ff 75 f0             	pushl  -0x10(%ebp)
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	e8 00 fb ff ff       	call   8016b7 <printnum>
  801bb7:	83 c4 20             	add    $0x20,%esp
			break;
  801bba:	eb 34                	jmp    801bf0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	53                   	push   %ebx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	ff d0                	call   *%eax
  801bc8:	83 c4 10             	add    $0x10,%esp
			break;
  801bcb:	eb 23                	jmp    801bf0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801bcd:	83 ec 08             	sub    $0x8,%esp
  801bd0:	ff 75 0c             	pushl  0xc(%ebp)
  801bd3:	6a 25                	push   $0x25
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	ff d0                	call   *%eax
  801bda:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bdd:	ff 4d 10             	decl   0x10(%ebp)
  801be0:	eb 03                	jmp    801be5 <vprintfmt+0x3b1>
  801be2:	ff 4d 10             	decl   0x10(%ebp)
  801be5:	8b 45 10             	mov    0x10(%ebp),%eax
  801be8:	48                   	dec    %eax
  801be9:	8a 00                	mov    (%eax),%al
  801beb:	3c 25                	cmp    $0x25,%al
  801bed:	75 f3                	jne    801be2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801bef:	90                   	nop
		}
	}
  801bf0:	e9 47 fc ff ff       	jmp    80183c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801bf5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf9:	5b                   	pop    %ebx
  801bfa:	5e                   	pop    %esi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    

00801bfd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c03:	8d 45 10             	lea    0x10(%ebp),%eax
  801c06:	83 c0 04             	add    $0x4,%eax
  801c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c12:	50                   	push   %eax
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	e8 16 fc ff ff       	call   801834 <vprintfmt>
  801c1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2a:	8b 40 08             	mov    0x8(%eax),%eax
  801c2d:	8d 50 01             	lea    0x1(%eax),%edx
  801c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c39:	8b 10                	mov    (%eax),%edx
  801c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3e:	8b 40 04             	mov    0x4(%eax),%eax
  801c41:	39 c2                	cmp    %eax,%edx
  801c43:	73 12                	jae    801c57 <sprintputch+0x33>
		*b->buf++ = ch;
  801c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c48:	8b 00                	mov    (%eax),%eax
  801c4a:	8d 48 01             	lea    0x1(%eax),%ecx
  801c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c50:	89 0a                	mov    %ecx,(%edx)
  801c52:	8b 55 08             	mov    0x8(%ebp),%edx
  801c55:	88 10                	mov    %dl,(%eax)
}
  801c57:	90                   	nop
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    

00801c5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c69:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	01 d0                	add    %edx,%eax
  801c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c7f:	74 06                	je     801c87 <vsnprintf+0x2d>
  801c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c85:	7f 07                	jg     801c8e <vsnprintf+0x34>
		return -E_INVAL;
  801c87:	b8 03 00 00 00       	mov    $0x3,%eax
  801c8c:	eb 20                	jmp    801cae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c8e:	ff 75 14             	pushl  0x14(%ebp)
  801c91:	ff 75 10             	pushl  0x10(%ebp)
  801c94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c97:	50                   	push   %eax
  801c98:	68 24 1c 80 00       	push   $0x801c24
  801c9d:	e8 92 fb ff ff       	call   801834 <vprintfmt>
  801ca2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cb6:	8d 45 10             	lea    0x10(%ebp),%eax
  801cb9:	83 c0 04             	add    $0x4,%eax
  801cbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc2:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc5:	50                   	push   %eax
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	ff 75 08             	pushl  0x8(%ebp)
  801ccc:	e8 89 ff ff ff       	call   801c5a <vsnprintf>
  801cd1:	83 c4 10             	add    $0x10,%esp
  801cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ce2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ce9:	eb 06                	jmp    801cf1 <strlen+0x15>
		n++;
  801ceb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801cee:	ff 45 08             	incl   0x8(%ebp)
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	8a 00                	mov    (%eax),%al
  801cf6:	84 c0                	test   %al,%al
  801cf8:	75 f1                	jne    801ceb <strlen+0xf>
		n++;
	return n;
  801cfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d0c:	eb 09                	jmp    801d17 <strnlen+0x18>
		n++;
  801d0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d11:	ff 45 08             	incl   0x8(%ebp)
  801d14:	ff 4d 0c             	decl   0xc(%ebp)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 09                	je     801d26 <strnlen+0x27>
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8a 00                	mov    (%eax),%al
  801d22:	84 c0                	test   %al,%al
  801d24:	75 e8                	jne    801d0e <strnlen+0xf>
		n++;
	return n;
  801d26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d37:	90                   	nop
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8d 50 01             	lea    0x1(%eax),%edx
  801d3e:	89 55 08             	mov    %edx,0x8(%ebp)
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d4a:	8a 12                	mov    (%edx),%dl
  801d4c:	88 10                	mov    %dl,(%eax)
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	84 c0                	test   %al,%al
  801d52:	75 e4                	jne    801d38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 1f                	jmp    801d8d <strncpy+0x34>
		*dst++ = *src;
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	8d 50 01             	lea    0x1(%eax),%edx
  801d74:	89 55 08             	mov    %edx,0x8(%ebp)
  801d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7a:	8a 12                	mov    (%edx),%dl
  801d7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d81:	8a 00                	mov    (%eax),%al
  801d83:	84 c0                	test   %al,%al
  801d85:	74 03                	je     801d8a <strncpy+0x31>
			src++;
  801d87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d8a:	ff 45 fc             	incl   -0x4(%ebp)
  801d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d93:	72 d9                	jb     801d6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801daa:	74 30                	je     801ddc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801dac:	eb 16                	jmp    801dc4 <strlcpy+0x2a>
			*dst++ = *src++;
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	8d 50 01             	lea    0x1(%eax),%edx
  801db4:	89 55 08             	mov    %edx,0x8(%ebp)
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dc0:	8a 12                	mov    (%edx),%dl
  801dc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801dc4:	ff 4d 10             	decl   0x10(%ebp)
  801dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dcb:	74 09                	je     801dd6 <strlcpy+0x3c>
  801dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd0:	8a 00                	mov    (%eax),%al
  801dd2:	84 c0                	test   %al,%al
  801dd4:	75 d8                	jne    801dae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	29 c2                	sub    %eax,%edx
  801de4:	89 d0                	mov    %edx,%eax
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801deb:	eb 06                	jmp    801df3 <strcmp+0xb>
		p++, q++;
  801ded:	ff 45 08             	incl   0x8(%ebp)
  801df0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	8a 00                	mov    (%eax),%al
  801df8:	84 c0                	test   %al,%al
  801dfa:	74 0e                	je     801e0a <strcmp+0x22>
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	8a 10                	mov    (%eax),%dl
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	38 c2                	cmp    %al,%dl
  801e08:	74 e3                	je     801ded <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	8a 00                	mov    (%eax),%al
  801e0f:	0f b6 d0             	movzbl %al,%edx
  801e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	0f b6 c0             	movzbl %al,%eax
  801e1a:	29 c2                	sub    %eax,%edx
  801e1c:	89 d0                	mov    %edx,%eax
}
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    

00801e20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e23:	eb 09                	jmp    801e2e <strncmp+0xe>
		n--, p++, q++;
  801e25:	ff 4d 10             	decl   0x10(%ebp)
  801e28:	ff 45 08             	incl   0x8(%ebp)
  801e2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e32:	74 17                	je     801e4b <strncmp+0x2b>
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	8a 00                	mov    (%eax),%al
  801e39:	84 c0                	test   %al,%al
  801e3b:	74 0e                	je     801e4b <strncmp+0x2b>
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	8a 10                	mov    (%eax),%dl
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	8a 00                	mov    (%eax),%al
  801e47:	38 c2                	cmp    %al,%dl
  801e49:	74 da                	je     801e25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4f:	75 07                	jne    801e58 <strncmp+0x38>
		return 0;
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
  801e56:	eb 14                	jmp    801e6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	8a 00                	mov    (%eax),%al
  801e5d:	0f b6 d0             	movzbl %al,%edx
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	8a 00                	mov    (%eax),%al
  801e65:	0f b6 c0             	movzbl %al,%eax
  801e68:	29 c2                	sub    %eax,%edx
  801e6a:	89 d0                	mov    %edx,%eax
}
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e7a:	eb 12                	jmp    801e8e <strchr+0x20>
		if (*s == c)
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	8a 00                	mov    (%eax),%al
  801e81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e84:	75 05                	jne    801e8b <strchr+0x1d>
			return (char *) s;
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	eb 11                	jmp    801e9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e8b:	ff 45 08             	incl   0x8(%ebp)
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	8a 00                	mov    (%eax),%al
  801e93:	84 c0                	test   %al,%al
  801e95:	75 e5                	jne    801e7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801eaa:	eb 0d                	jmp    801eb9 <strfind+0x1b>
		if (*s == c)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	8a 00                	mov    (%eax),%al
  801eb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801eb4:	74 0e                	je     801ec4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801eb6:	ff 45 08             	incl   0x8(%ebp)
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	8a 00                	mov    (%eax),%al
  801ebe:	84 c0                	test   %al,%al
  801ec0:	75 ea                	jne    801eac <strfind+0xe>
  801ec2:	eb 01                	jmp    801ec5 <strfind+0x27>
		if (*s == c)
			break;
  801ec4:	90                   	nop
	return (char *) s;
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801edc:	eb 0e                	jmp    801eec <memset+0x22>
		*p++ = c;
  801ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee1:	8d 50 01             	lea    0x1(%eax),%edx
  801ee4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801eec:	ff 4d f8             	decl   -0x8(%ebp)
  801eef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ef3:	79 e9                	jns    801ede <memset+0x14>
		*p++ = c;

	return v;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f0c:	eb 16                	jmp    801f24 <memcpy+0x2a>
		*d++ = *s++;
  801f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f11:	8d 50 01             	lea    0x1(%eax),%edx
  801f14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801f20:	8a 12                	mov    (%edx),%dl
  801f22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801f24:	8b 45 10             	mov    0x10(%ebp),%eax
  801f27:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f2a:	89 55 10             	mov    %edx,0x10(%ebp)
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	75 dd                	jne    801f0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f4e:	73 50                	jae    801fa0 <memmove+0x6a>
  801f50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f53:	8b 45 10             	mov    0x10(%ebp),%eax
  801f56:	01 d0                	add    %edx,%eax
  801f58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f5b:	76 43                	jbe    801fa0 <memmove+0x6a>
		s += n;
  801f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801f63:	8b 45 10             	mov    0x10(%ebp),%eax
  801f66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f69:	eb 10                	jmp    801f7b <memmove+0x45>
			*--d = *--s;
  801f6b:	ff 4d f8             	decl   -0x8(%ebp)
  801f6e:	ff 4d fc             	decl   -0x4(%ebp)
  801f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f74:	8a 10                	mov    (%eax),%dl
  801f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f81:	89 55 10             	mov    %edx,0x10(%ebp)
  801f84:	85 c0                	test   %eax,%eax
  801f86:	75 e3                	jne    801f6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801f88:	eb 23                	jmp    801fad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f8d:	8d 50 01             	lea    0x1(%eax),%edx
  801f90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f96:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801f9c:	8a 12                	mov    (%edx),%dl
  801f9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa3:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fa6:	89 55 10             	mov    %edx,0x10(%ebp)
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	75 dd                	jne    801f8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801fc4:	eb 2a                	jmp    801ff0 <memcmp+0x3e>
		if (*s1 != *s2)
  801fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc9:	8a 10                	mov    (%eax),%dl
  801fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fce:	8a 00                	mov    (%eax),%al
  801fd0:	38 c2                	cmp    %al,%dl
  801fd2:	74 16                	je     801fea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd7:	8a 00                	mov    (%eax),%al
  801fd9:	0f b6 d0             	movzbl %al,%edx
  801fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	0f b6 c0             	movzbl %al,%eax
  801fe4:	29 c2                	sub    %eax,%edx
  801fe6:	89 d0                	mov    %edx,%eax
  801fe8:	eb 18                	jmp    802002 <memcmp+0x50>
		s1++, s2++;
  801fea:	ff 45 fc             	incl   -0x4(%ebp)
  801fed:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff3:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ff6:	89 55 10             	mov    %edx,0x10(%ebp)
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 c9                	jne    801fc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80200a:	8b 55 08             	mov    0x8(%ebp),%edx
  80200d:	8b 45 10             	mov    0x10(%ebp),%eax
  802010:	01 d0                	add    %edx,%eax
  802012:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802015:	eb 15                	jmp    80202c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	8a 00                	mov    (%eax),%al
  80201c:	0f b6 d0             	movzbl %al,%edx
  80201f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802022:	0f b6 c0             	movzbl %al,%eax
  802025:	39 c2                	cmp    %eax,%edx
  802027:	74 0d                	je     802036 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802029:	ff 45 08             	incl   0x8(%ebp)
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802032:	72 e3                	jb     802017 <memfind+0x13>
  802034:	eb 01                	jmp    802037 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802036:	90                   	nop
	return (void *) s;
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802049:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802050:	eb 03                	jmp    802055 <strtol+0x19>
		s++;
  802052:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	8a 00                	mov    (%eax),%al
  80205a:	3c 20                	cmp    $0x20,%al
  80205c:	74 f4                	je     802052 <strtol+0x16>
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	8a 00                	mov    (%eax),%al
  802063:	3c 09                	cmp    $0x9,%al
  802065:	74 eb                	je     802052 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	8a 00                	mov    (%eax),%al
  80206c:	3c 2b                	cmp    $0x2b,%al
  80206e:	75 05                	jne    802075 <strtol+0x39>
		s++;
  802070:	ff 45 08             	incl   0x8(%ebp)
  802073:	eb 13                	jmp    802088 <strtol+0x4c>
	else if (*s == '-')
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	8a 00                	mov    (%eax),%al
  80207a:	3c 2d                	cmp    $0x2d,%al
  80207c:	75 0a                	jne    802088 <strtol+0x4c>
		s++, neg = 1;
  80207e:	ff 45 08             	incl   0x8(%ebp)
  802081:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802088:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208c:	74 06                	je     802094 <strtol+0x58>
  80208e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802092:	75 20                	jne    8020b4 <strtol+0x78>
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	8a 00                	mov    (%eax),%al
  802099:	3c 30                	cmp    $0x30,%al
  80209b:	75 17                	jne    8020b4 <strtol+0x78>
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	40                   	inc    %eax
  8020a1:	8a 00                	mov    (%eax),%al
  8020a3:	3c 78                	cmp    $0x78,%al
  8020a5:	75 0d                	jne    8020b4 <strtol+0x78>
		s += 2, base = 16;
  8020a7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8020ab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8020b2:	eb 28                	jmp    8020dc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8020b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b8:	75 15                	jne    8020cf <strtol+0x93>
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8a 00                	mov    (%eax),%al
  8020bf:	3c 30                	cmp    $0x30,%al
  8020c1:	75 0c                	jne    8020cf <strtol+0x93>
		s++, base = 8;
  8020c3:	ff 45 08             	incl   0x8(%ebp)
  8020c6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8020cd:	eb 0d                	jmp    8020dc <strtol+0xa0>
	else if (base == 0)
  8020cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d3:	75 07                	jne    8020dc <strtol+0xa0>
		base = 10;
  8020d5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	8a 00                	mov    (%eax),%al
  8020e1:	3c 2f                	cmp    $0x2f,%al
  8020e3:	7e 19                	jle    8020fe <strtol+0xc2>
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	8a 00                	mov    (%eax),%al
  8020ea:	3c 39                	cmp    $0x39,%al
  8020ec:	7f 10                	jg     8020fe <strtol+0xc2>
			dig = *s - '0';
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8a 00                	mov    (%eax),%al
  8020f3:	0f be c0             	movsbl %al,%eax
  8020f6:	83 e8 30             	sub    $0x30,%eax
  8020f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fc:	eb 42                	jmp    802140 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	8a 00                	mov    (%eax),%al
  802103:	3c 60                	cmp    $0x60,%al
  802105:	7e 19                	jle    802120 <strtol+0xe4>
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	8a 00                	mov    (%eax),%al
  80210c:	3c 7a                	cmp    $0x7a,%al
  80210e:	7f 10                	jg     802120 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8a 00                	mov    (%eax),%al
  802115:	0f be c0             	movsbl %al,%eax
  802118:	83 e8 57             	sub    $0x57,%eax
  80211b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211e:	eb 20                	jmp    802140 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	8a 00                	mov    (%eax),%al
  802125:	3c 40                	cmp    $0x40,%al
  802127:	7e 39                	jle    802162 <strtol+0x126>
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8a 00                	mov    (%eax),%al
  80212e:	3c 5a                	cmp    $0x5a,%al
  802130:	7f 30                	jg     802162 <strtol+0x126>
			dig = *s - 'A' + 10;
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	8a 00                	mov    (%eax),%al
  802137:	0f be c0             	movsbl %al,%eax
  80213a:	83 e8 37             	sub    $0x37,%eax
  80213d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	3b 45 10             	cmp    0x10(%ebp),%eax
  802146:	7d 19                	jge    802161 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802148:	ff 45 08             	incl   0x8(%ebp)
  80214b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80214e:	0f af 45 10          	imul   0x10(%ebp),%eax
  802152:	89 c2                	mov    %eax,%edx
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	01 d0                	add    %edx,%eax
  802159:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80215c:	e9 7b ff ff ff       	jmp    8020dc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802161:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802162:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802166:	74 08                	je     802170 <strtol+0x134>
		*endptr = (char *) s;
  802168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216b:	8b 55 08             	mov    0x8(%ebp),%edx
  80216e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802170:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802174:	74 07                	je     80217d <strtol+0x141>
  802176:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802179:	f7 d8                	neg    %eax
  80217b:	eb 03                	jmp    802180 <strtol+0x144>
  80217d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <ltostr>:

void
ltostr(long value, char *str)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802188:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80218f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219a:	79 13                	jns    8021af <ltostr+0x2d>
	{
		neg = 1;
  80219c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8021a9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8021ac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021b7:	99                   	cltd   
  8021b8:	f7 f9                	idiv   %ecx
  8021ba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8021bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c0:	8d 50 01             	lea    0x1(%eax),%edx
  8021c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021c6:	89 c2                	mov    %eax,%edx
  8021c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021d0:	83 c2 30             	add    $0x30,%edx
  8021d3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8021d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8021dd:	f7 e9                	imul   %ecx
  8021df:	c1 fa 02             	sar    $0x2,%edx
  8021e2:	89 c8                	mov    %ecx,%eax
  8021e4:	c1 f8 1f             	sar    $0x1f,%eax
  8021e7:	29 c2                	sub    %eax,%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8021ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8021f6:	f7 e9                	imul   %ecx
  8021f8:	c1 fa 02             	sar    $0x2,%edx
  8021fb:	89 c8                	mov    %ecx,%eax
  8021fd:	c1 f8 1f             	sar    $0x1f,%eax
  802200:	29 c2                	sub    %eax,%edx
  802202:	89 d0                	mov    %edx,%eax
  802204:	c1 e0 02             	shl    $0x2,%eax
  802207:	01 d0                	add    %edx,%eax
  802209:	01 c0                	add    %eax,%eax
  80220b:	29 c1                	sub    %eax,%ecx
  80220d:	89 ca                	mov    %ecx,%edx
  80220f:	85 d2                	test   %edx,%edx
  802211:	75 9c                	jne    8021af <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80221a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80221d:	48                   	dec    %eax
  80221e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802221:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802225:	74 3d                	je     802264 <ltostr+0xe2>
		start = 1 ;
  802227:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80222e:	eb 34                	jmp    802264 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802233:	8b 45 0c             	mov    0xc(%ebp),%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	8a 00                	mov    (%eax),%al
  80223a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	8b 45 0c             	mov    0xc(%ebp),%eax
  802243:	01 c2                	add    %eax,%edx
  802245:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224b:	01 c8                	add    %ecx,%eax
  80224d:	8a 00                	mov    (%eax),%al
  80224f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802254:	8b 45 0c             	mov    0xc(%ebp),%eax
  802257:	01 c2                	add    %eax,%edx
  802259:	8a 45 eb             	mov    -0x15(%ebp),%al
  80225c:	88 02                	mov    %al,(%edx)
		start++ ;
  80225e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802261:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80226a:	7c c4                	jl     802230 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80226c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80226f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802272:	01 d0                	add    %edx,%eax
  802274:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802277:	90                   	nop
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802280:	ff 75 08             	pushl  0x8(%ebp)
  802283:	e8 54 fa ff ff       	call   801cdc <strlen>
  802288:	83 c4 04             	add    $0x4,%esp
  80228b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80228e:	ff 75 0c             	pushl  0xc(%ebp)
  802291:	e8 46 fa ff ff       	call   801cdc <strlen>
  802296:	83 c4 04             	add    $0x4,%esp
  802299:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80229c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022aa:	eb 17                	jmp    8022c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8022ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022af:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b2:	01 c2                	add    %eax,%edx
  8022b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	01 c8                	add    %ecx,%eax
  8022bc:	8a 00                	mov    (%eax),%al
  8022be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022c0:	ff 45 fc             	incl   -0x4(%ebp)
  8022c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022c9:	7c e1                	jl     8022ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8022cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8022d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8022d9:	eb 1f                	jmp    8022fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8022db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022de:	8d 50 01             	lea    0x1(%eax),%edx
  8022e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8022e4:	89 c2                	mov    %eax,%edx
  8022e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e9:	01 c2                	add    %eax,%edx
  8022eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8022ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f1:	01 c8                	add    %ecx,%eax
  8022f3:	8a 00                	mov    (%eax),%al
  8022f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8022f7:	ff 45 f8             	incl   -0x8(%ebp)
  8022fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802300:	7c d9                	jl     8022db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802305:	8b 45 10             	mov    0x10(%ebp),%eax
  802308:	01 d0                	add    %edx,%eax
  80230a:	c6 00 00             	movb   $0x0,(%eax)
}
  80230d:	90                   	nop
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802313:	8b 45 14             	mov    0x14(%ebp),%eax
  802316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80231c:	8b 45 14             	mov    0x14(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802328:	8b 45 10             	mov    0x10(%ebp),%eax
  80232b:	01 d0                	add    %edx,%eax
  80232d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802333:	eb 0c                	jmp    802341 <strsplit+0x31>
			*string++ = 0;
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8d 50 01             	lea    0x1(%eax),%edx
  80233b:	89 55 08             	mov    %edx,0x8(%ebp)
  80233e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8a 00                	mov    (%eax),%al
  802346:	84 c0                	test   %al,%al
  802348:	74 18                	je     802362 <strsplit+0x52>
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	8a 00                	mov    (%eax),%al
  80234f:	0f be c0             	movsbl %al,%eax
  802352:	50                   	push   %eax
  802353:	ff 75 0c             	pushl  0xc(%ebp)
  802356:	e8 13 fb ff ff       	call   801e6e <strchr>
  80235b:	83 c4 08             	add    $0x8,%esp
  80235e:	85 c0                	test   %eax,%eax
  802360:	75 d3                	jne    802335 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8a 00                	mov    (%eax),%al
  802367:	84 c0                	test   %al,%al
  802369:	74 5a                	je     8023c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80236b:	8b 45 14             	mov    0x14(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	83 f8 0f             	cmp    $0xf,%eax
  802373:	75 07                	jne    80237c <strsplit+0x6c>
		{
			return 0;
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	eb 66                	jmp    8023e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80237c:	8b 45 14             	mov    0x14(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	8d 48 01             	lea    0x1(%eax),%ecx
  802384:	8b 55 14             	mov    0x14(%ebp),%edx
  802387:	89 0a                	mov    %ecx,(%edx)
  802389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802390:	8b 45 10             	mov    0x10(%ebp),%eax
  802393:	01 c2                	add    %eax,%edx
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80239a:	eb 03                	jmp    80239f <strsplit+0x8f>
			string++;
  80239c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	8a 00                	mov    (%eax),%al
  8023a4:	84 c0                	test   %al,%al
  8023a6:	74 8b                	je     802333 <strsplit+0x23>
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8a 00                	mov    (%eax),%al
  8023ad:	0f be c0             	movsbl %al,%eax
  8023b0:	50                   	push   %eax
  8023b1:	ff 75 0c             	pushl  0xc(%ebp)
  8023b4:	e8 b5 fa ff ff       	call   801e6e <strchr>
  8023b9:	83 c4 08             	add    $0x8,%esp
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 dc                	je     80239c <strsplit+0x8c>
			string++;
	}
  8023c0:	e9 6e ff ff ff       	jmp    802333 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8023c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8023c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d5:	01 d0                	add    %edx,%eax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8023dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8023ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8023f1:	eb 4c                	jmp    80243f <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8023f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	8a 00                	mov    (%eax),%al
  8023fd:	3c 40                	cmp    $0x40,%al
  8023ff:	7e 27                	jle    802428 <str2lower+0x44>
  802401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802404:	8b 45 0c             	mov    0xc(%ebp),%eax
  802407:	01 d0                	add    %edx,%eax
  802409:	8a 00                	mov    (%eax),%al
  80240b:	3c 5a                	cmp    $0x5a,%al
  80240d:	7f 19                	jg     802428 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80240f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	01 d0                	add    %edx,%eax
  802417:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80241a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241d:	01 ca                	add    %ecx,%edx
  80241f:	8a 12                	mov    (%edx),%dl
  802421:	83 c2 20             	add    $0x20,%edx
  802424:	88 10                	mov    %dl,(%eax)
  802426:	eb 14                	jmp    80243c <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  802428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	01 c2                	add    %eax,%edx
  802430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802433:	8b 45 0c             	mov    0xc(%ebp),%eax
  802436:	01 c8                	add    %ecx,%eax
  802438:	8a 00                	mov    (%eax),%al
  80243a:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80243c:	ff 45 fc             	incl   -0x4(%ebp)
  80243f:	ff 75 0c             	pushl  0xc(%ebp)
  802442:	e8 95 f8 ff ff       	call   801cdc <strlen>
  802447:	83 c4 04             	add    $0x4,%esp
  80244a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80244d:	7f a4                	jg     8023f3 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  802457:	a1 04 50 80 00       	mov    0x805004,%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 0a                	je     80246a <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  802460:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802467:	00 00 00 
	}
}
  80246a:	90                   	nop
  80246b:	5d                   	pop    %ebp
  80246c:	c3                   	ret    

0080246d <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	ff 75 08             	pushl  0x8(%ebp)
  802479:	e8 7e 09 00 00       	call   802dfc <sys_sbrk>
  80247e:	83 c4 10             	add    $0x10,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802489:	e8 c6 ff ff ff       	call   802454 <InitializeUHeap>
	if (size == 0)
  80248e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802492:	75 0a                	jne    80249e <malloc+0x1b>
		return NULL;
  802494:	b8 00 00 00 00       	mov    $0x0,%eax
  802499:	e9 3f 01 00 00       	jmp    8025dd <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  80249e:	e8 ac 09 00 00       	call   802e4f <sys_get_hard_limit>
  8024a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  8024a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  8024ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8024b5:	c1 e8 0c             	shr    $0xc,%eax
  8024b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8024bb:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c8:	01 d0                	add    %edx,%eax
  8024ca:	48                   	dec    %eax
  8024cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d6:	f7 75 d8             	divl   -0x28(%ebp)
  8024d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024dc:	29 d0                	sub    %edx,%eax
  8024de:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8024e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e4:	c1 e8 0c             	shr    $0xc,%eax
  8024e7:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8024ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ee:	75 0a                	jne    8024fa <malloc+0x77>
		return NULL;
  8024f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f5:	e9 e3 00 00 00       	jmp    8025dd <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  8024fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fd:	05 00 00 00 80       	add    $0x80000000,%eax
  802502:	c1 e8 0c             	shr    $0xc,%eax
  802505:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80250a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802511:	77 19                	ja     80252c <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	ff 75 08             	pushl  0x8(%ebp)
  802519:	e8 60 0b 00 00       	call   80307e <alloc_block_FF>
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  802524:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802527:	e9 b1 00 00 00       	jmp    8025dd <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80252c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80252f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802532:	eb 4d                	jmp    802581 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  802534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802537:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  80253e:	84 c0                	test   %al,%al
  802540:	75 27                	jne    802569 <malloc+0xe6>
			{
				counter++;
  802542:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  802545:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  802549:	75 14                	jne    80255f <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  80254b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254e:	05 00 00 08 00       	add    $0x80000,%eax
  802553:	c1 e0 0c             	shl    $0xc,%eax
  802556:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  802559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802565:	75 17                	jne    80257e <malloc+0xfb>
				{
					break;
  802567:	eb 21                	jmp    80258a <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  802569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80256c:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  802573:	3c 01                	cmp    $0x1,%al
  802575:	75 07                	jne    80257e <malloc+0xfb>
			{
				counter = 0;
  802577:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  80257e:	ff 45 e8             	incl   -0x18(%ebp)
  802581:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  802588:	76 aa                	jbe    802534 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80258a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802590:	75 46                	jne    8025d8 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  802592:	83 ec 08             	sub    $0x8,%esp
  802595:	ff 75 d0             	pushl  -0x30(%ebp)
  802598:	ff 75 f4             	pushl  -0xc(%ebp)
  80259b:	e8 93 08 00 00       	call   802e33 <sys_allocate_user_mem>
  8025a0:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8025a9:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8025b6:	eb 0e                	jmp    8025c6 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bb:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  8025c2:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8025c3:	ff 45 e4             	incl   -0x1c(%ebp)
  8025c6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8025c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025d1:	77 e5                	ja     8025b8 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	eb 05                	jmp    8025dd <malloc+0x15a>
		}
	}

	return NULL;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8025e5:	e8 65 08 00 00       	call   802e4f <sys_get_hard_limit>
  8025ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  8025f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f7:	0f 84 c1 00 00 00    	je     8026be <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  8025fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	79 1b                	jns    80261f <free+0x40>
  802604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80260a:	73 13                	jae    80261f <free+0x40>
    {
        free_block(virtual_address);
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	ff 75 08             	pushl  0x8(%ebp)
  802612:	e8 34 10 00 00       	call   80364b <free_block>
  802617:	83 c4 10             	add    $0x10,%esp
    	return;
  80261a:	e9 a6 00 00 00       	jmp    8026c5 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	05 00 10 00 00       	add    $0x1000,%eax
  802627:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80262a:	0f 87 91 00 00 00    	ja     8026c1 <free+0xe2>
  802630:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802637:	0f 87 84 00 00 00    	ja     8026c1 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  80263d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802640:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802646:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80264b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	05 00 00 00 80       	add    $0x80000000,%eax
  802656:	c1 e8 0c             	shr    $0xc,%eax
  802659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  80265c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265f:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  802666:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  802669:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80266d:	74 55                	je     8026c4 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  80266f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802672:	c1 e8 0c             	shr    $0xc,%eax
  802675:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  802678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267b:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  802682:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  802686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802689:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268c:	eb 0e                	jmp    80269c <free+0xbd>
	{
		userArr[i].is_allocated=0;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  802698:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  802699:	ff 45 f4             	incl   -0xc(%ebp)
  80269c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80269f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a2:	01 c2                	add    %eax,%edx
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	39 c2                	cmp    %eax,%edx
  8026a9:	77 e3                	ja     80268e <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  8026ab:	83 ec 08             	sub    $0x8,%esp
  8026ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8026b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8026b4:	e8 5e 07 00 00       	call   802e17 <sys_free_user_mem>
  8026b9:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8026bc:	eb 07                	jmp    8026c5 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8026be:	90                   	nop
  8026bf:	eb 04                	jmp    8026c5 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8026c1:	90                   	nop
  8026c2:	eb 01                	jmp    8026c5 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8026c4:	90                   	nop
    else
     {
    	return;
      }

}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 18             	sub    $0x18,%esp
  8026cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026d3:	e8 7c fd ff ff       	call   802454 <InitializeUHeap>
	if (size == 0)
  8026d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026dc:	75 07                	jne    8026e5 <smalloc+0x1e>
		return NULL;
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e3:	eb 17                	jmp    8026fc <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8026e5:	83 ec 04             	sub    $0x4,%esp
  8026e8:	68 b0 4b 80 00       	push   $0x804bb0
  8026ed:	68 ad 00 00 00       	push   $0xad
  8026f2:	68 d6 4b 80 00       	push   $0x804bd6
  8026f7:	e8 a1 ec ff ff       	call   80139d <_panic>
	return NULL;
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802704:	e8 4b fd ff ff       	call   802454 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	68 e4 4b 80 00       	push   $0x804be4
  802711:	68 ba 00 00 00       	push   $0xba
  802716:	68 d6 4b 80 00       	push   $0x804bd6
  80271b:	e8 7d ec ff ff       	call   80139d <_panic>

00802720 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802726:	e8 29 fd ff ff       	call   802454 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 08 4c 80 00       	push   $0x804c08
  802733:	68 d8 00 00 00       	push   $0xd8
  802738:	68 d6 4b 80 00       	push   $0x804bd6
  80273d:	e8 5b ec ff ff       	call   80139d <_panic>

00802742 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 30 4c 80 00       	push   $0x804c30
  802750:	68 ea 00 00 00       	push   $0xea
  802755:	68 d6 4b 80 00       	push   $0x804bd6
  80275a:	e8 3e ec ff ff       	call   80139d <_panic>

0080275f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802765:	83 ec 04             	sub    $0x4,%esp
  802768:	68 54 4c 80 00       	push   $0x804c54
  80276d:	68 f2 00 00 00       	push   $0xf2
  802772:	68 d6 4b 80 00       	push   $0x804bd6
  802777:	e8 21 ec ff ff       	call   80139d <_panic>

0080277c <shrink>:

}
void shrink(uint32 newSize) {
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 54 4c 80 00       	push   $0x804c54
  80278a:	68 f6 00 00 00       	push   $0xf6
  80278f:	68 d6 4b 80 00       	push   $0x804bd6
  802794:	e8 04 ec ff ff       	call   80139d <_panic>

00802799 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	68 54 4c 80 00       	push   $0x804c54
  8027a7:	68 fa 00 00 00       	push   $0xfa
  8027ac:	68 d6 4b 80 00       	push   $0x804bd6
  8027b1:	e8 e7 eb ff ff       	call   80139d <_panic>

008027b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	57                   	push   %edi
  8027ba:	56                   	push   %esi
  8027bb:	53                   	push   %ebx
  8027bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8027ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8027d1:	cd 30                	int    $0x30
  8027d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8027d9:	83 c4 10             	add    $0x10,%esp
  8027dc:	5b                   	pop    %ebx
  8027dd:	5e                   	pop    %esi
  8027de:	5f                   	pop    %edi
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    

008027e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	83 ec 04             	sub    $0x4,%esp
  8027e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8027ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	52                   	push   %edx
  8027f9:	ff 75 0c             	pushl  0xc(%ebp)
  8027fc:	50                   	push   %eax
  8027fd:	6a 00                	push   $0x0
  8027ff:	e8 b2 ff ff ff       	call   8027b6 <syscall>
  802804:	83 c4 18             	add    $0x18,%esp
}
  802807:	90                   	nop
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <sys_cgetc>:

int
sys_cgetc(void)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 01                	push   $0x1
  802819:	e8 98 ff ff ff       	call   8027b6 <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802826:	8b 55 0c             	mov    0xc(%ebp),%edx
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	52                   	push   %edx
  802833:	50                   	push   %eax
  802834:	6a 05                	push   $0x5
  802836:	e8 7b ff ff ff       	call   8027b6 <syscall>
  80283b:	83 c4 18             	add    $0x18,%esp
}
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	56                   	push   %esi
  802844:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802845:	8b 75 18             	mov    0x18(%ebp),%esi
  802848:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80284b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80284e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	56                   	push   %esi
  802855:	53                   	push   %ebx
  802856:	51                   	push   %ecx
  802857:	52                   	push   %edx
  802858:	50                   	push   %eax
  802859:	6a 06                	push   $0x6
  80285b:	e8 56 ff ff ff       	call   8027b6 <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
}
  802863:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802866:	5b                   	pop    %ebx
  802867:	5e                   	pop    %esi
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    

0080286a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80286d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	52                   	push   %edx
  80287a:	50                   	push   %eax
  80287b:	6a 07                	push   $0x7
  80287d:	e8 34 ff ff ff       	call   8027b6 <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
}
  802885:	c9                   	leave  
  802886:	c3                   	ret    

00802887 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	ff 75 0c             	pushl  0xc(%ebp)
  802893:	ff 75 08             	pushl  0x8(%ebp)
  802896:	6a 08                	push   $0x8
  802898:	e8 19 ff ff ff       	call   8027b6 <syscall>
  80289d:	83 c4 18             	add    $0x18,%esp
}
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 09                	push   $0x9
  8028b1:	e8 00 ff ff ff       	call   8027b6 <syscall>
  8028b6:	83 c4 18             	add    $0x18,%esp
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 0a                	push   $0xa
  8028ca:	e8 e7 fe ff ff       	call   8027b6 <syscall>
  8028cf:	83 c4 18             	add    $0x18,%esp
}
  8028d2:	c9                   	leave  
  8028d3:	c3                   	ret    

008028d4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8028d4:	55                   	push   %ebp
  8028d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 0b                	push   $0xb
  8028e3:	e8 ce fe ff ff       	call   8027b6 <syscall>
  8028e8:	83 c4 18             	add    $0x18,%esp
}
  8028eb:	c9                   	leave  
  8028ec:	c3                   	ret    

008028ed <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8028f0:	6a 00                	push   $0x0
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 0c                	push   $0xc
  8028fc:	e8 b5 fe ff ff       	call   8027b6 <syscall>
  802901:	83 c4 18             	add    $0x18,%esp
}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	ff 75 08             	pushl  0x8(%ebp)
  802914:	6a 0d                	push   $0xd
  802916:	e8 9b fe ff ff       	call   8027b6 <syscall>
  80291b:	83 c4 18             	add    $0x18,%esp
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 0e                	push   $0xe
  80292f:	e8 82 fe ff ff       	call   8027b6 <syscall>
  802934:	83 c4 18             	add    $0x18,%esp
}
  802937:	90                   	nop
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	6a 11                	push   $0x11
  802949:	e8 68 fe ff ff       	call   8027b6 <syscall>
  80294e:	83 c4 18             	add    $0x18,%esp
}
  802951:	90                   	nop
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 12                	push   $0x12
  802963:	e8 4e fe ff ff       	call   8027b6 <syscall>
  802968:	83 c4 18             	add    $0x18,%esp
}
  80296b:	90                   	nop
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <sys_cputc>:


void
sys_cputc(const char c)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80297a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	50                   	push   %eax
  802987:	6a 13                	push   $0x13
  802989:	e8 28 fe ff ff       	call   8027b6 <syscall>
  80298e:	83 c4 18             	add    $0x18,%esp
}
  802991:	90                   	nop
  802992:	c9                   	leave  
  802993:	c3                   	ret    

00802994 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 14                	push   $0x14
  8029a3:	e8 0e fe ff ff       	call   8027b6 <syscall>
  8029a8:	83 c4 18             	add    $0x18,%esp
}
  8029ab:	90                   	nop
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	ff 75 0c             	pushl  0xc(%ebp)
  8029bd:	50                   	push   %eax
  8029be:	6a 15                	push   $0x15
  8029c0:	e8 f1 fd ff ff       	call   8027b6 <syscall>
  8029c5:	83 c4 18             	add    $0x18,%esp
}
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	52                   	push   %edx
  8029da:	50                   	push   %eax
  8029db:	6a 18                	push   $0x18
  8029dd:	e8 d4 fd ff ff       	call   8027b6 <syscall>
  8029e2:	83 c4 18             	add    $0x18,%esp
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8029ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	52                   	push   %edx
  8029f7:	50                   	push   %eax
  8029f8:	6a 16                	push   $0x16
  8029fa:	e8 b7 fd ff ff       	call   8027b6 <syscall>
  8029ff:	83 c4 18             	add    $0x18,%esp
}
  802a02:	90                   	nop
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	52                   	push   %edx
  802a15:	50                   	push   %eax
  802a16:	6a 17                	push   $0x17
  802a18:	e8 99 fd ff ff       	call   8027b6 <syscall>
  802a1d:	83 c4 18             	add    $0x18,%esp
}
  802a20:	90                   	nop
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	8b 45 10             	mov    0x10(%ebp),%eax
  802a2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	6a 00                	push   $0x0
  802a3b:	51                   	push   %ecx
  802a3c:	52                   	push   %edx
  802a3d:	ff 75 0c             	pushl  0xc(%ebp)
  802a40:	50                   	push   %eax
  802a41:	6a 19                	push   $0x19
  802a43:	e8 6e fd ff ff       	call   8027b6 <syscall>
  802a48:	83 c4 18             	add    $0x18,%esp
}
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    

00802a4d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	52                   	push   %edx
  802a5d:	50                   	push   %eax
  802a5e:	6a 1a                	push   $0x1a
  802a60:	e8 51 fd ff ff       	call   8027b6 <syscall>
  802a65:	83 c4 18             	add    $0x18,%esp
}
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	51                   	push   %ecx
  802a7b:	52                   	push   %edx
  802a7c:	50                   	push   %eax
  802a7d:	6a 1b                	push   $0x1b
  802a7f:	e8 32 fd ff ff       	call   8027b6 <syscall>
  802a84:	83 c4 18             	add    $0x18,%esp
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	52                   	push   %edx
  802a99:	50                   	push   %eax
  802a9a:	6a 1c                	push   $0x1c
  802a9c:	e8 15 fd ff ff       	call   8027b6 <syscall>
  802aa1:	83 c4 18             	add    $0x18,%esp
}
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 00                	push   $0x0
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 1d                	push   $0x1d
  802ab5:	e8 fc fc ff ff       	call   8027b6 <syscall>
  802aba:	83 c4 18             	add    $0x18,%esp
}
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	6a 00                	push   $0x0
  802ac7:	ff 75 14             	pushl  0x14(%ebp)
  802aca:	ff 75 10             	pushl  0x10(%ebp)
  802acd:	ff 75 0c             	pushl  0xc(%ebp)
  802ad0:	50                   	push   %eax
  802ad1:	6a 1e                	push   $0x1e
  802ad3:	e8 de fc ff ff       	call   8027b6 <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
}
  802adb:	c9                   	leave  
  802adc:	c3                   	ret    

00802add <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	50                   	push   %eax
  802aec:	6a 1f                	push   $0x1f
  802aee:	e8 c3 fc ff ff       	call   8027b6 <syscall>
  802af3:	83 c4 18             	add    $0x18,%esp
}
  802af6:	90                   	nop
  802af7:	c9                   	leave  
  802af8:	c3                   	ret    

00802af9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	6a 00                	push   $0x0
  802b07:	50                   	push   %eax
  802b08:	6a 20                	push   $0x20
  802b0a:	e8 a7 fc ff ff       	call   8027b6 <syscall>
  802b0f:	83 c4 18             	add    $0x18,%esp
}
  802b12:	c9                   	leave  
  802b13:	c3                   	ret    

00802b14 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	6a 00                	push   $0x0
  802b21:	6a 02                	push   $0x2
  802b23:	e8 8e fc ff ff       	call   8027b6 <syscall>
  802b28:	83 c4 18             	add    $0x18,%esp
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 03                	push   $0x3
  802b3c:	e8 75 fc ff ff       	call   8027b6 <syscall>
  802b41:	83 c4 18             	add    $0x18,%esp
}
  802b44:	c9                   	leave  
  802b45:	c3                   	ret    

00802b46 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b46:	55                   	push   %ebp
  802b47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 04                	push   $0x4
  802b55:	e8 5c fc ff ff       	call   8027b6 <syscall>
  802b5a:	83 c4 18             	add    $0x18,%esp
}
  802b5d:	c9                   	leave  
  802b5e:	c3                   	ret    

00802b5f <sys_exit_env>:


void sys_exit_env(void)
{
  802b5f:	55                   	push   %ebp
  802b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 00                	push   $0x0
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 21                	push   $0x21
  802b6e:	e8 43 fc ff ff       	call   8027b6 <syscall>
  802b73:	83 c4 18             	add    $0x18,%esp
}
  802b76:	90                   	nop
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

00802b79 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
  802b7c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b7f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b82:	8d 50 04             	lea    0x4(%eax),%edx
  802b85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b88:	6a 00                	push   $0x0
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	52                   	push   %edx
  802b8f:	50                   	push   %eax
  802b90:	6a 22                	push   $0x22
  802b92:	e8 1f fc ff ff       	call   8027b6 <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
	return result;
  802b9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ba3:	89 01                	mov    %eax,(%ecx)
  802ba5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	c9                   	leave  
  802bac:	c2 04 00             	ret    $0x4

00802baf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802baf:	55                   	push   %ebp
  802bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 00                	push   $0x0
  802bb6:	ff 75 10             	pushl  0x10(%ebp)
  802bb9:	ff 75 0c             	pushl  0xc(%ebp)
  802bbc:	ff 75 08             	pushl  0x8(%ebp)
  802bbf:	6a 10                	push   $0x10
  802bc1:	e8 f0 fb ff ff       	call   8027b6 <syscall>
  802bc6:	83 c4 18             	add    $0x18,%esp
	return ;
  802bc9:	90                   	nop
}
  802bca:	c9                   	leave  
  802bcb:	c3                   	ret    

00802bcc <sys_rcr2>:
uint32 sys_rcr2()
{
  802bcc:	55                   	push   %ebp
  802bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802bcf:	6a 00                	push   $0x0
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 23                	push   $0x23
  802bdb:	e8 d6 fb ff ff       	call   8027b6 <syscall>
  802be0:	83 c4 18             	add    $0x18,%esp
}
  802be3:	c9                   	leave  
  802be4:	c3                   	ret    

00802be5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802be5:	55                   	push   %ebp
  802be6:	89 e5                	mov    %esp,%ebp
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802bf1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	50                   	push   %eax
  802bfe:	6a 24                	push   $0x24
  802c00:	e8 b1 fb ff ff       	call   8027b6 <syscall>
  802c05:	83 c4 18             	add    $0x18,%esp
	return ;
  802c08:	90                   	nop
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <rsttst>:
void rsttst()
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 26                	push   $0x26
  802c1a:	e8 97 fb ff ff       	call   8027b6 <syscall>
  802c1f:	83 c4 18             	add    $0x18,%esp
	return ;
  802c22:	90                   	nop
}
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    

00802c25 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
  802c28:	83 ec 04             	sub    $0x4,%esp
  802c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  802c2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c31:	8b 55 18             	mov    0x18(%ebp),%edx
  802c34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c38:	52                   	push   %edx
  802c39:	50                   	push   %eax
  802c3a:	ff 75 10             	pushl  0x10(%ebp)
  802c3d:	ff 75 0c             	pushl  0xc(%ebp)
  802c40:	ff 75 08             	pushl  0x8(%ebp)
  802c43:	6a 25                	push   $0x25
  802c45:	e8 6c fb ff ff       	call   8027b6 <syscall>
  802c4a:	83 c4 18             	add    $0x18,%esp
	return ;
  802c4d:	90                   	nop
}
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <chktst>:
void chktst(uint32 n)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	6a 00                	push   $0x0
  802c59:	6a 00                	push   $0x0
  802c5b:	ff 75 08             	pushl  0x8(%ebp)
  802c5e:	6a 27                	push   $0x27
  802c60:	e8 51 fb ff ff       	call   8027b6 <syscall>
  802c65:	83 c4 18             	add    $0x18,%esp
	return ;
  802c68:	90                   	nop
}
  802c69:	c9                   	leave  
  802c6a:	c3                   	ret    

00802c6b <inctst>:

void inctst()
{
  802c6b:	55                   	push   %ebp
  802c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c6e:	6a 00                	push   $0x0
  802c70:	6a 00                	push   $0x0
  802c72:	6a 00                	push   $0x0
  802c74:	6a 00                	push   $0x0
  802c76:	6a 00                	push   $0x0
  802c78:	6a 28                	push   $0x28
  802c7a:	e8 37 fb ff ff       	call   8027b6 <syscall>
  802c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  802c82:	90                   	nop
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <gettst>:
uint32 gettst()
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 00                	push   $0x0
  802c8e:	6a 00                	push   $0x0
  802c90:	6a 00                	push   $0x0
  802c92:	6a 29                	push   $0x29
  802c94:	e8 1d fb ff ff       	call   8027b6 <syscall>
  802c99:	83 c4 18             	add    $0x18,%esp
}
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	6a 00                	push   $0x0
  802cac:	6a 00                	push   $0x0
  802cae:	6a 2a                	push   $0x2a
  802cb0:	e8 01 fb ff ff       	call   8027b6 <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
  802cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802cbb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802cbf:	75 07                	jne    802cc8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc6:	eb 05                	jmp    802ccd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccd:	c9                   	leave  
  802cce:	c3                   	ret    

00802ccf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802ccf:	55                   	push   %ebp
  802cd0:	89 e5                	mov    %esp,%ebp
  802cd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 2a                	push   $0x2a
  802ce1:	e8 d0 fa ff ff       	call   8027b6 <syscall>
  802ce6:	83 c4 18             	add    $0x18,%esp
  802ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802cec:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802cf0:	75 07                	jne    802cf9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  802cf7:	eb 05                	jmp    802cfe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cfe:	c9                   	leave  
  802cff:	c3                   	ret    

00802d00 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802d00:	55                   	push   %ebp
  802d01:	89 e5                	mov    %esp,%ebp
  802d03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d06:	6a 00                	push   $0x0
  802d08:	6a 00                	push   $0x0
  802d0a:	6a 00                	push   $0x0
  802d0c:	6a 00                	push   $0x0
  802d0e:	6a 00                	push   $0x0
  802d10:	6a 2a                	push   $0x2a
  802d12:	e8 9f fa ff ff       	call   8027b6 <syscall>
  802d17:	83 c4 18             	add    $0x18,%esp
  802d1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802d1d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802d21:	75 07                	jne    802d2a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802d23:	b8 01 00 00 00       	mov    $0x1,%eax
  802d28:	eb 05                	jmp    802d2f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d2f:	c9                   	leave  
  802d30:	c3                   	ret    

00802d31 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
  802d34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 2a                	push   $0x2a
  802d43:	e8 6e fa ff ff       	call   8027b6 <syscall>
  802d48:	83 c4 18             	add    $0x18,%esp
  802d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802d4e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802d52:	75 07                	jne    802d5b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802d54:	b8 01 00 00 00       	mov    $0x1,%eax
  802d59:	eb 05                	jmp    802d60 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	ff 75 08             	pushl  0x8(%ebp)
  802d70:	6a 2b                	push   $0x2b
  802d72:	e8 3f fa ff ff       	call   8027b6 <syscall>
  802d77:	83 c4 18             	add    $0x18,%esp
	return ;
  802d7a:	90                   	nop
}
  802d7b:	c9                   	leave  
  802d7c:	c3                   	ret    

00802d7d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d7d:	55                   	push   %ebp
  802d7e:	89 e5                	mov    %esp,%ebp
  802d80:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	6a 00                	push   $0x0
  802d8f:	53                   	push   %ebx
  802d90:	51                   	push   %ecx
  802d91:	52                   	push   %edx
  802d92:	50                   	push   %eax
  802d93:	6a 2c                	push   $0x2c
  802d95:	e8 1c fa ff ff       	call   8027b6 <syscall>
  802d9a:	83 c4 18             	add    $0x18,%esp
}
  802d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802da0:	c9                   	leave  
  802da1:	c3                   	ret    

00802da2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802da2:	55                   	push   %ebp
  802da3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	6a 00                	push   $0x0
  802dad:	6a 00                	push   $0x0
  802daf:	6a 00                	push   $0x0
  802db1:	52                   	push   %edx
  802db2:	50                   	push   %eax
  802db3:	6a 2d                	push   $0x2d
  802db5:	e8 fc f9 ff ff       	call   8027b6 <syscall>
  802dba:	83 c4 18             	add    $0x18,%esp
}
  802dbd:	c9                   	leave  
  802dbe:	c3                   	ret    

00802dbf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802dbf:	55                   	push   %ebp
  802dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802dc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	6a 00                	push   $0x0
  802dcd:	51                   	push   %ecx
  802dce:	ff 75 10             	pushl  0x10(%ebp)
  802dd1:	52                   	push   %edx
  802dd2:	50                   	push   %eax
  802dd3:	6a 2e                	push   $0x2e
  802dd5:	e8 dc f9 ff ff       	call   8027b6 <syscall>
  802dda:	83 c4 18             	add    $0x18,%esp
}
  802ddd:	c9                   	leave  
  802dde:	c3                   	ret    

00802ddf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ddf:	55                   	push   %ebp
  802de0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	ff 75 10             	pushl  0x10(%ebp)
  802de9:	ff 75 0c             	pushl  0xc(%ebp)
  802dec:	ff 75 08             	pushl  0x8(%ebp)
  802def:	6a 0f                	push   $0xf
  802df1:	e8 c0 f9 ff ff       	call   8027b6 <syscall>
  802df6:	83 c4 18             	add    $0x18,%esp
	return ;
  802df9:	90                   	nop
}
  802dfa:	c9                   	leave  
  802dfb:	c3                   	ret    

00802dfc <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802dfc:	55                   	push   %ebp
  802dfd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	50                   	push   %eax
  802e0b:	6a 2f                	push   $0x2f
  802e0d:	e8 a4 f9 ff ff       	call   8027b6 <syscall>
  802e12:	83 c4 18             	add    $0x18,%esp

}
  802e15:	c9                   	leave  
  802e16:	c3                   	ret    

00802e17 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e17:	55                   	push   %ebp
  802e18:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	ff 75 0c             	pushl  0xc(%ebp)
  802e23:	ff 75 08             	pushl  0x8(%ebp)
  802e26:	6a 30                	push   $0x30
  802e28:	e8 89 f9 ff ff       	call   8027b6 <syscall>
  802e2d:	83 c4 18             	add    $0x18,%esp
	return;
  802e30:	90                   	nop
}
  802e31:	c9                   	leave  
  802e32:	c3                   	ret    

00802e33 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e33:	55                   	push   %ebp
  802e34:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 00                	push   $0x0
  802e3c:	ff 75 0c             	pushl  0xc(%ebp)
  802e3f:	ff 75 08             	pushl  0x8(%ebp)
  802e42:	6a 31                	push   $0x31
  802e44:	e8 6d f9 ff ff       	call   8027b6 <syscall>
  802e49:	83 c4 18             	add    $0x18,%esp
	return;
  802e4c:	90                   	nop
}
  802e4d:	c9                   	leave  
  802e4e:	c3                   	ret    

00802e4f <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802e4f:	55                   	push   %ebp
  802e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802e52:	6a 00                	push   $0x0
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 32                	push   $0x32
  802e5e:	e8 53 f9 ff ff       	call   8027b6 <syscall>
  802e63:	83 c4 18             	add    $0x18,%esp
}
  802e66:	c9                   	leave  
  802e67:	c3                   	ret    

00802e68 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  802e68:	55                   	push   %ebp
  802e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 00                	push   $0x0
  802e76:	50                   	push   %eax
  802e77:	6a 33                	push   $0x33
  802e79:	e8 38 f9 ff ff       	call   8027b6 <syscall>
  802e7e:	83 c4 18             	add    $0x18,%esp
}
  802e81:	90                   	nop
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	83 e8 10             	sub    $0x10,%eax
  802e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  802e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
}
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
  802e9d:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	83 e8 10             	sub    $0x10,%eax
  802ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802eac:	8a 40 04             	mov    0x4(%eax),%al
}
  802eaf:	c9                   	leave  
  802eb0:	c3                   	ret    

00802eb1 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802eb1:	55                   	push   %ebp
  802eb2:	89 e5                	mov    %esp,%ebp
  802eb4:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec1:	83 f8 02             	cmp    $0x2,%eax
  802ec4:	74 2b                	je     802ef1 <alloc_block+0x40>
  802ec6:	83 f8 02             	cmp    $0x2,%eax
  802ec9:	7f 07                	jg     802ed2 <alloc_block+0x21>
  802ecb:	83 f8 01             	cmp    $0x1,%eax
  802ece:	74 0e                	je     802ede <alloc_block+0x2d>
  802ed0:	eb 58                	jmp    802f2a <alloc_block+0x79>
  802ed2:	83 f8 03             	cmp    $0x3,%eax
  802ed5:	74 2d                	je     802f04 <alloc_block+0x53>
  802ed7:	83 f8 04             	cmp    $0x4,%eax
  802eda:	74 3b                	je     802f17 <alloc_block+0x66>
  802edc:	eb 4c                	jmp    802f2a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802ede:	83 ec 0c             	sub    $0xc,%esp
  802ee1:	ff 75 08             	pushl  0x8(%ebp)
  802ee4:	e8 95 01 00 00       	call   80307e <alloc_block_FF>
  802ee9:	83 c4 10             	add    $0x10,%esp
  802eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802eef:	eb 4a                	jmp    802f3b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802ef1:	83 ec 0c             	sub    $0xc,%esp
  802ef4:	ff 75 08             	pushl  0x8(%ebp)
  802ef7:	e8 32 07 00 00       	call   80362e <alloc_block_NF>
  802efc:	83 c4 10             	add    $0x10,%esp
  802eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f02:	eb 37                	jmp    802f3b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802f04:	83 ec 0c             	sub    $0xc,%esp
  802f07:	ff 75 08             	pushl  0x8(%ebp)
  802f0a:	e8 a3 04 00 00       	call   8033b2 <alloc_block_BF>
  802f0f:	83 c4 10             	add    $0x10,%esp
  802f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f15:	eb 24                	jmp    802f3b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802f17:	83 ec 0c             	sub    $0xc,%esp
  802f1a:	ff 75 08             	pushl  0x8(%ebp)
  802f1d:	e8 ef 06 00 00       	call   803611 <alloc_block_WF>
  802f22:	83 c4 10             	add    $0x10,%esp
  802f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f28:	eb 11                	jmp    802f3b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802f2a:	83 ec 0c             	sub    $0xc,%esp
  802f2d:	68 64 4c 80 00       	push   $0x804c64
  802f32:	e8 23 e7 ff ff       	call   80165a <cprintf>
  802f37:	83 c4 10             	add    $0x10,%esp
		break;
  802f3a:	90                   	nop
	}
	return va;
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802f3e:	c9                   	leave  
  802f3f:	c3                   	ret    

00802f40 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802f40:	55                   	push   %ebp
  802f41:	89 e5                	mov    %esp,%ebp
  802f43:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802f46:	83 ec 0c             	sub    $0xc,%esp
  802f49:	68 84 4c 80 00       	push   $0x804c84
  802f4e:	e8 07 e7 ff ff       	call   80165a <cprintf>
  802f53:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802f56:	83 ec 0c             	sub    $0xc,%esp
  802f59:	68 af 4c 80 00       	push   $0x804caf
  802f5e:	e8 f7 e6 ff ff       	call   80165a <cprintf>
  802f63:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6c:	eb 26                	jmp    802f94 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8a 40 04             	mov    0x4(%eax),%al
  802f74:	0f b6 d0             	movzbl %al,%edx
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	52                   	push   %edx
  802f80:	50                   	push   %eax
  802f81:	68 c7 4c 80 00       	push   $0x804cc7
  802f86:	e8 cf e6 ff ff       	call   80165a <cprintf>
  802f8b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f98:	74 08                	je     802fa2 <print_blocks_list+0x62>
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	eb 05                	jmp    802fa7 <print_blocks_list+0x67>
  802fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa7:	89 45 10             	mov    %eax,0x10(%ebp)
  802faa:	8b 45 10             	mov    0x10(%ebp),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	75 bd                	jne    802f6e <print_blocks_list+0x2e>
  802fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb5:	75 b7                	jne    802f6e <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802fb7:	83 ec 0c             	sub    $0xc,%esp
  802fba:	68 84 4c 80 00       	push   $0x804c84
  802fbf:	e8 96 e6 ff ff       	call   80165a <cprintf>
  802fc4:	83 c4 10             	add    $0x10,%esp

}
  802fc7:	90                   	nop
  802fc8:	c9                   	leave  
  802fc9:	c3                   	ret    

00802fca <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802fca:	55                   	push   %ebp
  802fcb:	89 e5                	mov    %esp,%ebp
  802fcd:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  802fd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd4:	0f 84 a1 00 00 00    	je     80307b <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802fda:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802fe1:	00 00 00 
	LIST_INIT(&list);
  802fe4:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802feb:	00 00 00 
  802fee:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  802ff5:	00 00 00 
  802ff8:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802fff:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 55 0c             	mov    0xc(%ebp),%edx
  803015:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  803017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301b:	75 14                	jne    803031 <initialize_dynamic_allocator+0x67>
  80301d:	83 ec 04             	sub    $0x4,%esp
  803020:	68 e0 4c 80 00       	push   $0x804ce0
  803025:	6a 64                	push   $0x64
  803027:	68 03 4d 80 00       	push   $0x804d03
  80302c:	e8 6c e3 ff ff       	call   80139d <_panic>
  803031:	8b 15 44 51 90 00    	mov    0x905144,%edx
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	89 50 0c             	mov    %edx,0xc(%eax)
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 40 0c             	mov    0xc(%eax),%eax
  803043:	85 c0                	test   %eax,%eax
  803045:	74 0d                	je     803054 <initialize_dynamic_allocator+0x8a>
  803047:	a1 44 51 90 00       	mov    0x905144,%eax
  80304c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80304f:	89 50 08             	mov    %edx,0x8(%eax)
  803052:	eb 08                	jmp    80305c <initialize_dynamic_allocator+0x92>
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	a3 40 51 90 00       	mov    %eax,0x905140
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	a3 44 51 90 00       	mov    %eax,0x905144
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80306e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803073:	40                   	inc    %eax
  803074:	a3 4c 51 90 00       	mov    %eax,0x90514c
  803079:	eb 01                	jmp    80307c <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  80307b:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  80307c:	c9                   	leave  
  80307d:	c3                   	ret    

0080307e <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80307e:	55                   	push   %ebp
  80307f:	89 e5                	mov    %esp,%ebp
  803081:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  803084:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803088:	75 0a                	jne    803094 <alloc_block_FF+0x16>
	{
		return NULL;
  80308a:	b8 00 00 00 00       	mov    $0x0,%eax
  80308f:	e9 1c 03 00 00       	jmp    8033b0 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  803094:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	75 40                	jne    8030dd <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	83 c0 10             	add    $0x10,%eax
  8030a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a9:	83 ec 0c             	sub    $0xc,%esp
  8030ac:	50                   	push   %eax
  8030ad:	e8 bb f3 ff ff       	call   80246d <sbrk>
  8030b2:	83 c4 10             	add    $0x10,%esp
  8030b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  8030b8:	83 ec 0c             	sub    $0xc,%esp
  8030bb:	6a 00                	push   $0x0
  8030bd:	e8 ab f3 ff ff       	call   80246d <sbrk>
  8030c2:	83 c4 10             	add    $0x10,%esp
  8030c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8030ce:	83 ec 08             	sub    $0x8,%esp
  8030d1:	50                   	push   %eax
  8030d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8030d5:	e8 f0 fe ff ff       	call   802fca <initialize_dynamic_allocator>
  8030da:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8030dd:	a1 40 51 90 00       	mov    0x905140,%eax
  8030e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e5:	e9 1e 01 00 00       	jmp    803208 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8d 50 10             	lea    0x10(%eax),%edx
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	39 c2                	cmp    %eax,%edx
  8030f7:	75 1c                	jne    803115 <alloc_block_FF+0x97>
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8a 40 04             	mov    0x4(%eax),%al
  8030ff:	3c 01                	cmp    $0x1,%al
  803101:	75 12                	jne    803115 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  80310a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310d:	83 c0 10             	add    $0x10,%eax
  803110:	e9 9b 02 00 00       	jmp    8033b0 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	8d 50 10             	lea    0x10(%eax),%edx
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	39 c2                	cmp    %eax,%edx
  803122:	0f 83 d8 00 00 00    	jae    803200 <alloc_block_FF+0x182>
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8a 40 04             	mov    0x4(%eax),%al
  80312e:	3c 01                	cmp    $0x1,%al
  803130:	0f 85 ca 00 00 00    	jne    803200 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 00                	mov    (%eax),%eax
  80313b:	2b 45 08             	sub    0x8(%ebp),%eax
  80313e:	83 e8 10             	sub    $0x10,%eax
  803141:	83 f8 0f             	cmp    $0xf,%eax
  803144:	0f 86 a4 00 00 00    	jbe    8031ee <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  80314a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	01 d0                	add    %edx,%eax
  803152:	83 c0 10             	add    $0x10,%eax
  803155:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	2b 45 08             	sub    0x8(%ebp),%eax
  803160:	8d 50 f0             	lea    -0x10(%eax),%edx
  803163:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803166:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  803168:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80316b:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80316f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803173:	74 06                	je     80317b <alloc_block_FF+0xfd>
  803175:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803179:	75 17                	jne    803192 <alloc_block_FF+0x114>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 1c 4d 80 00       	push   $0x804d1c
  803183:	68 8f 00 00 00       	push   $0x8f
  803188:	68 03 4d 80 00       	push   $0x804d03
  80318d:	e8 0b e2 ff ff       	call   80139d <_panic>
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 50 08             	mov    0x8(%eax),%edx
  803198:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80319b:	89 50 08             	mov    %edx,0x8(%eax)
  80319e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031a1:	8b 40 08             	mov    0x8(%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	74 0c                	je     8031b4 <alloc_block_FF+0x136>
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 40 08             	mov    0x8(%eax),%eax
  8031ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031b1:	89 50 0c             	mov    %edx,0xc(%eax)
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031ba:	89 50 08             	mov    %edx,0x8(%eax)
  8031bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c3:	89 50 0c             	mov    %edx,0xc(%eax)
  8031c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c9:	8b 40 08             	mov    0x8(%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	75 08                	jne    8031d8 <alloc_block_FF+0x15a>
  8031d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031d3:	a3 44 51 90 00       	mov    %eax,0x905144
  8031d8:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8d 50 10             	lea    0x10(%eax),%edx
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	83 c0 10             	add    $0x10,%eax
  8031fb:	e9 b0 01 00 00       	jmp    8033b0 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  803200:	a1 48 51 90 00       	mov    0x905148,%eax
  803205:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803208:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320c:	74 08                	je     803216 <alloc_block_FF+0x198>
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 40 08             	mov    0x8(%eax),%eax
  803214:	eb 05                	jmp    80321b <alloc_block_FF+0x19d>
  803216:	b8 00 00 00 00       	mov    $0x0,%eax
  80321b:	a3 48 51 90 00       	mov    %eax,0x905148
  803220:	a1 48 51 90 00       	mov    0x905148,%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	0f 85 bd fe ff ff    	jne    8030ea <alloc_block_FF+0x6c>
  80322d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803231:	0f 85 b3 fe ff ff    	jne    8030ea <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	83 c0 10             	add    $0x10,%eax
  80323d:	83 ec 0c             	sub    $0xc,%esp
  803240:	50                   	push   %eax
  803241:	e8 27 f2 ff ff       	call   80246d <sbrk>
  803246:	83 c4 10             	add    $0x10,%esp
  803249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  80324c:	83 ec 0c             	sub    $0xc,%esp
  80324f:	6a 00                	push   $0x0
  803251:	e8 17 f2 ff ff       	call   80246d <sbrk>
  803256:	83 c4 10             	add    $0x10,%esp
  803259:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  80325c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80325f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803262:	29 c2                	sub    %eax,%edx
  803264:	89 d0                	mov    %edx,%eax
  803266:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  803269:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80326d:	0f 84 38 01 00 00    	je     8033ab <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  803273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803276:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  803279:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80327d:	75 17                	jne    803296 <alloc_block_FF+0x218>
  80327f:	83 ec 04             	sub    $0x4,%esp
  803282:	68 e0 4c 80 00       	push   $0x804ce0
  803287:	68 9f 00 00 00       	push   $0x9f
  80328c:	68 03 4d 80 00       	push   $0x804d03
  803291:	e8 07 e1 ff ff       	call   80139d <_panic>
  803296:	8b 15 44 51 90 00    	mov    0x905144,%edx
  80329c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80329f:	89 50 0c             	mov    %edx,0xc(%eax)
  8032a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0d                	je     8032b9 <alloc_block_FF+0x23b>
  8032ac:	a1 44 51 90 00       	mov    0x905144,%eax
  8032b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032b4:	89 50 08             	mov    %edx,0x8(%eax)
  8032b7:	eb 08                	jmp    8032c1 <alloc_block_FF+0x243>
  8032b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032bc:	a3 40 51 90 00       	mov    %eax,0x905140
  8032c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032c4:	a3 44 51 90 00       	mov    %eax,0x905144
  8032c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032d3:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8032d8:	40                   	inc    %eax
  8032d9:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	8d 50 10             	lea    0x10(%eax),%edx
  8032e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e7:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  8032e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ec:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  8032f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8032f6:	83 f8 10             	cmp    $0x10,%eax
  8032f9:	0f 84 a4 00 00 00    	je     8033a3 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  8032ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803302:	2b 45 08             	sub    0x8(%ebp),%eax
  803305:	83 e8 10             	sub    $0x10,%eax
  803308:	83 f8 0f             	cmp    $0xf,%eax
  80330b:	0f 86 8a 00 00 00    	jbe    80339b <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  803311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	01 d0                	add    %edx,%eax
  803319:	83 c0 10             	add    $0x10,%eax
  80331c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  80331f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803323:	75 17                	jne    80333c <alloc_block_FF+0x2be>
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	68 e0 4c 80 00       	push   $0x804ce0
  80332d:	68 a7 00 00 00       	push   $0xa7
  803332:	68 03 4d 80 00       	push   $0x804d03
  803337:	e8 61 e0 ff ff       	call   80139d <_panic>
  80333c:	8b 15 44 51 90 00    	mov    0x905144,%edx
  803342:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803345:	89 50 0c             	mov    %edx,0xc(%eax)
  803348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334b:	8b 40 0c             	mov    0xc(%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 0d                	je     80335f <alloc_block_FF+0x2e1>
  803352:	a1 44 51 90 00       	mov    0x905144,%eax
  803357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335a:	89 50 08             	mov    %edx,0x8(%eax)
  80335d:	eb 08                	jmp    803367 <alloc_block_FF+0x2e9>
  80335f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803362:	a3 40 51 90 00       	mov    %eax,0x905140
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	a3 44 51 90 00       	mov    %eax,0x905144
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803379:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  803384:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803387:	2b 45 08             	sub    0x8(%ebp),%eax
  80338a:	8d 50 f0             	lea    -0x10(%eax),%edx
  80338d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803390:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  803392:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803395:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  803399:	eb 08                	jmp    8033a3 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  80339b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80339e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  8033a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a6:	83 c0 10             	add    $0x10,%eax
  8033a9:	eb 05                	jmp    8033b0 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  8033ab:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8033b2:	55                   	push   %ebp
  8033b3:	89 e5                	mov    %esp,%ebp
  8033b5:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  8033b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  8033bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c3:	75 0a                	jne    8033cf <alloc_block_BF+0x1d>
	{
		return NULL;
  8033c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ca:	e9 40 02 00 00       	jmp    80360f <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8033cf:	a1 40 51 90 00       	mov    0x905140,%eax
  8033d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d7:	eb 66                	jmp    80343f <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	8a 40 04             	mov    0x4(%eax),%al
  8033df:	3c 01                	cmp    $0x1,%al
  8033e1:	75 21                	jne    803404 <alloc_block_BF+0x52>
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8d 50 10             	lea    0x10(%eax),%edx
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	39 c2                	cmp    %eax,%edx
  8033f0:	75 12                	jne    803404 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	83 c0 10             	add    $0x10,%eax
  8033ff:	e9 0b 02 00 00       	jmp    80360f <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  803404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803407:	8a 40 04             	mov    0x4(%eax),%al
  80340a:	3c 01                	cmp    $0x1,%al
  80340c:	75 29                	jne    803437 <alloc_block_BF+0x85>
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	8d 50 10             	lea    0x10(%eax),%edx
  803414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	39 c2                	cmp    %eax,%edx
  80341b:	77 1a                	ja     803437 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  80341d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803421:	74 0e                	je     803431 <alloc_block_BF+0x7f>
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 10                	mov    (%eax),%edx
  803428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	39 c2                	cmp    %eax,%edx
  80342f:	73 06                	jae    803437 <alloc_block_BF+0x85>
			{
				BF = iterator;
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  803437:	a1 48 51 90 00       	mov    0x905148,%eax
  80343c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803443:	74 08                	je     80344d <alloc_block_BF+0x9b>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 08             	mov    0x8(%eax),%eax
  80344b:	eb 05                	jmp    803452 <alloc_block_BF+0xa0>
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	a3 48 51 90 00       	mov    %eax,0x905148
  803457:	a1 48 51 90 00       	mov    0x905148,%eax
  80345c:	85 c0                	test   %eax,%eax
  80345e:	0f 85 75 ff ff ff    	jne    8033d9 <alloc_block_BF+0x27>
  803464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803468:	0f 85 6b ff ff ff    	jne    8033d9 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  80346e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803472:	0f 84 f8 00 00 00    	je     803570 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	8d 50 10             	lea    0x10(%eax),%edx
  80347e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	39 c2                	cmp    %eax,%edx
  803485:	0f 87 e5 00 00 00    	ja     803570 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	2b 45 08             	sub    0x8(%ebp),%eax
  803493:	83 e8 10             	sub    $0x10,%eax
  803496:	83 f8 0f             	cmp    $0xf,%eax
  803499:	0f 86 bf 00 00 00    	jbe    80355e <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  80349f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	01 d0                	add    %edx,%eax
  8034a7:	83 c0 10             	add    $0x10,%eax
  8034aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  8034ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  8034b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b9:	8b 00                	mov    (%eax),%eax
  8034bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8034be:	8d 50 f0             	lea    -0x10(%eax),%edx
  8034c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c4:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8034c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8034cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d1:	74 06                	je     8034d9 <alloc_block_BF+0x127>
  8034d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034d7:	75 17                	jne    8034f0 <alloc_block_BF+0x13e>
  8034d9:	83 ec 04             	sub    $0x4,%esp
  8034dc:	68 1c 4d 80 00       	push   $0x804d1c
  8034e1:	68 e3 00 00 00       	push   $0xe3
  8034e6:	68 03 4d 80 00       	push   $0x804d03
  8034eb:	e8 ad de ff ff       	call   80139d <_panic>
  8034f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f3:	8b 50 08             	mov    0x8(%eax),%edx
  8034f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f9:	89 50 08             	mov    %edx,0x8(%eax)
  8034fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ff:	8b 40 08             	mov    0x8(%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0c                	je     803512 <alloc_block_BF+0x160>
  803506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803509:	8b 40 08             	mov    0x8(%eax),%eax
  80350c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80350f:	89 50 0c             	mov    %edx,0xc(%eax)
  803512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803515:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803518:	89 50 08             	mov    %edx,0x8(%eax)
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803521:	89 50 0c             	mov    %edx,0xc(%eax)
  803524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803527:	8b 40 08             	mov    0x8(%eax),%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	75 08                	jne    803536 <alloc_block_BF+0x184>
  80352e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803531:	a3 44 51 90 00       	mov    %eax,0x905144
  803536:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80353b:	40                   	inc    %eax
  80353c:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	8d 50 10             	lea    0x10(%eax),%edx
  803547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354a:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  80354c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354f:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  803553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803556:	83 c0 10             	add    $0x10,%eax
  803559:	e9 b1 00 00 00       	jmp    80360f <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  80355e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803561:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  803565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803568:	83 c0 10             	add    $0x10,%eax
  80356b:	e9 9f 00 00 00       	jmp    80360f <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	83 c0 10             	add    $0x10,%eax
  803576:	83 ec 0c             	sub    $0xc,%esp
  803579:	50                   	push   %eax
  80357a:	e8 ee ee ff ff       	call   80246d <sbrk>
  80357f:	83 c4 10             	add    $0x10,%esp
  803582:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  803585:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  803589:	74 7f                	je     80360a <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  80358b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80358f:	75 17                	jne    8035a8 <alloc_block_BF+0x1f6>
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	68 e0 4c 80 00       	push   $0x804ce0
  803599:	68 f6 00 00 00       	push   $0xf6
  80359e:	68 03 4d 80 00       	push   $0x804d03
  8035a3:	e8 f5 dd ff ff       	call   80139d <_panic>
  8035a8:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	89 50 0c             	mov    %edx,0xc(%eax)
  8035b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	74 0d                	je     8035cb <alloc_block_BF+0x219>
  8035be:	a1 44 51 90 00       	mov    0x905144,%eax
  8035c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c6:	89 50 08             	mov    %edx,0x8(%eax)
  8035c9:	eb 08                	jmp    8035d3 <alloc_block_BF+0x221>
  8035cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ce:	a3 40 51 90 00       	mov    %eax,0x905140
  8035d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d6:	a3 44 51 90 00       	mov    %eax,0x905144
  8035db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035e5:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8035ea:	40                   	inc    %eax
  8035eb:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8d 50 10             	lea    0x10(%eax),%edx
  8035f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f9:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  8035fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fe:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  803602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803605:	83 c0 10             	add    $0x10,%eax
  803608:	eb 05                	jmp    80360f <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  80360a:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  80360f:	c9                   	leave  
  803610:	c3                   	ret    

00803611 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
  803614:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803617:	83 ec 04             	sub    $0x4,%esp
  80361a:	68 50 4d 80 00       	push   $0x804d50
  80361f:	68 07 01 00 00       	push   $0x107
  803624:	68 03 4d 80 00       	push   $0x804d03
  803629:	e8 6f dd ff ff       	call   80139d <_panic>

0080362e <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  80362e:	55                   	push   %ebp
  80362f:	89 e5                	mov    %esp,%ebp
  803631:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 78 4d 80 00       	push   $0x804d78
  80363c:	68 0f 01 00 00       	push   $0x10f
  803641:	68 03 4d 80 00       	push   $0x804d03
  803646:	e8 52 dd ff ff       	call   80139d <_panic>

0080364b <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80364b:	55                   	push   %ebp
  80364c:	89 e5                	mov    %esp,%ebp
  80364e:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  803651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803655:	0f 84 ee 05 00 00    	je     803c49 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	83 e8 10             	sub    $0x10,%eax
  803661:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  803664:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803668:	a1 40 51 90 00       	mov    0x905140,%eax
  80366d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803670:	eb 16                	jmp    803688 <free_block+0x3d>
	{
		if (block_pointer == it)
  803672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803678:	75 06                	jne    803680 <free_block+0x35>
		{
			flagx = 1;
  80367a:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  80367e:	eb 2f                	jmp    8036af <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  803680:	a1 48 51 90 00       	mov    0x905148,%eax
  803685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803688:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80368c:	74 08                	je     803696 <free_block+0x4b>
  80368e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803691:	8b 40 08             	mov    0x8(%eax),%eax
  803694:	eb 05                	jmp    80369b <free_block+0x50>
  803696:	b8 00 00 00 00       	mov    $0x0,%eax
  80369b:	a3 48 51 90 00       	mov    %eax,0x905148
  8036a0:	a1 48 51 90 00       	mov    0x905148,%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	75 c9                	jne    803672 <free_block+0x27>
  8036a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ad:	75 c3                	jne    803672 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  8036af:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8036b3:	0f 84 93 05 00 00    	je     803c4c <free_block+0x601>
		return;
	if (va == NULL)
  8036b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bd:	0f 84 8c 05 00 00    	je     803c4f <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8036c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8036cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cf:	8b 40 08             	mov    0x8(%eax),%eax
  8036d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8036d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036d9:	75 12                	jne    8036ed <free_block+0xa2>
  8036db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036df:	75 0c                	jne    8036ed <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8036e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8036e8:	e9 63 05 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  8036ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036f1:	0f 85 ca 00 00 00    	jne    8037c1 <free_block+0x176>
  8036f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fa:	8a 40 04             	mov    0x4(%eax),%al
  8036fd:	3c 01                	cmp    $0x1,%al
  8036ff:	0f 85 bc 00 00 00    	jne    8037c1 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  803705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803708:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  80370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370f:	8b 10                	mov    (%eax),%edx
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	8b 00                	mov    (%eax),%eax
  803716:	01 c2                	add    %eax,%edx
  803718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371b:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80371d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803729:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  80372d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803731:	75 17                	jne    80374a <free_block+0xff>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 9e 4d 80 00       	push   $0x804d9e
  80373b:	68 3c 01 00 00       	push   $0x13c
  803740:	68 03 4d 80 00       	push   $0x804d03
  803745:	e8 53 dc ff ff       	call   80139d <_panic>
  80374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374d:	8b 40 08             	mov    0x8(%eax),%eax
  803750:	85 c0                	test   %eax,%eax
  803752:	74 11                	je     803765 <free_block+0x11a>
  803754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803757:	8b 40 08             	mov    0x8(%eax),%eax
  80375a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375d:	8b 52 0c             	mov    0xc(%edx),%edx
  803760:	89 50 0c             	mov    %edx,0xc(%eax)
  803763:	eb 0b                	jmp    803770 <free_block+0x125>
  803765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803768:	8b 40 0c             	mov    0xc(%eax),%eax
  80376b:	a3 44 51 90 00       	mov    %eax,0x905144
  803770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803773:	8b 40 0c             	mov    0xc(%eax),%eax
  803776:	85 c0                	test   %eax,%eax
  803778:	74 11                	je     80378b <free_block+0x140>
  80377a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377d:	8b 40 0c             	mov    0xc(%eax),%eax
  803780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803783:	8b 52 08             	mov    0x8(%edx),%edx
  803786:	89 50 08             	mov    %edx,0x8(%eax)
  803789:	eb 0b                	jmp    803796 <free_block+0x14b>
  80378b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378e:	8b 40 08             	mov    0x8(%eax),%eax
  803791:	a3 40 51 90 00       	mov    %eax,0x905140
  803796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803799:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8037aa:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8037af:	48                   	dec    %eax
  8037b0:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  8037b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8037bc:	e9 8f 04 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  8037c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c5:	75 16                	jne    8037dd <free_block+0x192>
  8037c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ca:	8a 40 04             	mov    0x4(%eax),%al
  8037cd:	84 c0                	test   %al,%al
  8037cf:	75 0c                	jne    8037dd <free_block+0x192>
	{
		block_pointer->is_free = 1;
  8037d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8037d8:	e9 73 04 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  8037dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e1:	0f 85 c3 00 00 00    	jne    8038aa <free_block+0x25f>
  8037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ea:	8a 40 04             	mov    0x4(%eax),%al
  8037ed:	3c 01                	cmp    $0x1,%al
  8037ef:	0f 85 b5 00 00 00    	jne    8038aa <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  8037f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f8:	8b 10                	mov    (%eax),%edx
  8037fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	01 c2                	add    %eax,%edx
  803801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803804:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80380f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803812:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803816:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80381a:	75 17                	jne    803833 <free_block+0x1e8>
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	68 9e 4d 80 00       	push   $0x804d9e
  803824:	68 49 01 00 00       	push   $0x149
  803829:	68 03 4d 80 00       	push   $0x804d03
  80382e:	e8 6a db ff ff       	call   80139d <_panic>
  803833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803836:	8b 40 08             	mov    0x8(%eax),%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	74 11                	je     80384e <free_block+0x203>
  80383d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803840:	8b 40 08             	mov    0x8(%eax),%eax
  803843:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803846:	8b 52 0c             	mov    0xc(%edx),%edx
  803849:	89 50 0c             	mov    %edx,0xc(%eax)
  80384c:	eb 0b                	jmp    803859 <free_block+0x20e>
  80384e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803851:	8b 40 0c             	mov    0xc(%eax),%eax
  803854:	a3 44 51 90 00       	mov    %eax,0x905144
  803859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385c:	8b 40 0c             	mov    0xc(%eax),%eax
  80385f:	85 c0                	test   %eax,%eax
  803861:	74 11                	je     803874 <free_block+0x229>
  803863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803866:	8b 40 0c             	mov    0xc(%eax),%eax
  803869:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80386c:	8b 52 08             	mov    0x8(%edx),%edx
  80386f:	89 50 08             	mov    %edx,0x8(%eax)
  803872:	eb 0b                	jmp    80387f <free_block+0x234>
  803874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803877:	8b 40 08             	mov    0x8(%eax),%eax
  80387a:	a3 40 51 90 00       	mov    %eax,0x905140
  80387f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803882:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80388c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803893:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803898:	48                   	dec    %eax
  803899:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  80389e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8038a5:	e9 a6 03 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  8038aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ae:	75 16                	jne    8038c6 <free_block+0x27b>
  8038b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b3:	8a 40 04             	mov    0x4(%eax),%al
  8038b6:	84 c0                	test   %al,%al
  8038b8:	75 0c                	jne    8038c6 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  8038ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038bd:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8038c1:	e9 8a 03 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  8038c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ca:	0f 84 81 01 00 00    	je     803a51 <free_block+0x406>
  8038d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038d4:	0f 84 77 01 00 00    	je     803a51 <free_block+0x406>
  8038da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038dd:	8a 40 04             	mov    0x4(%eax),%al
  8038e0:	3c 01                	cmp    $0x1,%al
  8038e2:	0f 85 69 01 00 00    	jne    803a51 <free_block+0x406>
  8038e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038eb:	8a 40 04             	mov    0x4(%eax),%al
  8038ee:	3c 01                	cmp    $0x1,%al
  8038f0:	0f 85 5b 01 00 00    	jne    803a51 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  8038f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f9:	8b 10                	mov    (%eax),%edx
  8038fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038fe:	8b 08                	mov    (%eax),%ecx
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	01 c8                	add    %ecx,%eax
  803907:	01 c2                	add    %eax,%edx
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80391e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803921:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80392e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803932:	75 17                	jne    80394b <free_block+0x300>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 9e 4d 80 00       	push   $0x804d9e
  80393c:	68 59 01 00 00       	push   $0x159
  803941:	68 03 4d 80 00       	push   $0x804d03
  803946:	e8 52 da ff ff       	call   80139d <_panic>
  80394b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80394e:	8b 40 08             	mov    0x8(%eax),%eax
  803951:	85 c0                	test   %eax,%eax
  803953:	74 11                	je     803966 <free_block+0x31b>
  803955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803958:	8b 40 08             	mov    0x8(%eax),%eax
  80395b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80395e:	8b 52 0c             	mov    0xc(%edx),%edx
  803961:	89 50 0c             	mov    %edx,0xc(%eax)
  803964:	eb 0b                	jmp    803971 <free_block+0x326>
  803966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803969:	8b 40 0c             	mov    0xc(%eax),%eax
  80396c:	a3 44 51 90 00       	mov    %eax,0x905144
  803971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803974:	8b 40 0c             	mov    0xc(%eax),%eax
  803977:	85 c0                	test   %eax,%eax
  803979:	74 11                	je     80398c <free_block+0x341>
  80397b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397e:	8b 40 0c             	mov    0xc(%eax),%eax
  803981:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803984:	8b 52 08             	mov    0x8(%edx),%edx
  803987:	89 50 08             	mov    %edx,0x8(%eax)
  80398a:	eb 0b                	jmp    803997 <free_block+0x34c>
  80398c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398f:	8b 40 08             	mov    0x8(%eax),%eax
  803992:	a3 40 51 90 00       	mov    %eax,0x905140
  803997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8039ab:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8039b0:	48                   	dec    %eax
  8039b1:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  8039b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039ba:	75 17                	jne    8039d3 <free_block+0x388>
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 9e 4d 80 00       	push   $0x804d9e
  8039c4:	68 5a 01 00 00       	push   $0x15a
  8039c9:	68 03 4d 80 00       	push   $0x804d03
  8039ce:	e8 ca d9 ff ff       	call   80139d <_panic>
  8039d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d6:	8b 40 08             	mov    0x8(%eax),%eax
  8039d9:	85 c0                	test   %eax,%eax
  8039db:	74 11                	je     8039ee <free_block+0x3a3>
  8039dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e0:	8b 40 08             	mov    0x8(%eax),%eax
  8039e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8039e9:	89 50 0c             	mov    %edx,0xc(%eax)
  8039ec:	eb 0b                	jmp    8039f9 <free_block+0x3ae>
  8039ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039f4:	a3 44 51 90 00       	mov    %eax,0x905144
  8039f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ff:	85 c0                	test   %eax,%eax
  803a01:	74 11                	je     803a14 <free_block+0x3c9>
  803a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a06:	8b 40 0c             	mov    0xc(%eax),%eax
  803a09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a0c:	8b 52 08             	mov    0x8(%edx),%edx
  803a0f:	89 50 08             	mov    %edx,0x8(%eax)
  803a12:	eb 0b                	jmp    803a1f <free_block+0x3d4>
  803a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a17:	8b 40 08             	mov    0x8(%eax),%eax
  803a1a:	a3 40 51 90 00       	mov    %eax,0x905140
  803a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803a33:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803a38:	48                   	dec    %eax
  803a39:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803a3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  803a45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803a4c:	e9 ff 01 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a55:	0f 84 db 00 00 00    	je     803b36 <free_block+0x4eb>
  803a5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a5f:	0f 84 d1 00 00 00    	je     803b36 <free_block+0x4eb>
  803a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a68:	8a 40 04             	mov    0x4(%eax),%al
  803a6b:	84 c0                	test   %al,%al
  803a6d:	0f 85 c3 00 00 00    	jne    803b36 <free_block+0x4eb>
  803a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a76:	8a 40 04             	mov    0x4(%eax),%al
  803a79:	3c 01                	cmp    $0x1,%al
  803a7b:	0f 85 b5 00 00 00    	jne    803b36 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  803a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a84:	8b 10                	mov    (%eax),%edx
  803a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a89:	8b 00                	mov    (%eax),%eax
  803a8b:	01 c2                	add    %eax,%edx
  803a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a90:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  803a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a9e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803aa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803aa6:	75 17                	jne    803abf <free_block+0x474>
  803aa8:	83 ec 04             	sub    $0x4,%esp
  803aab:	68 9e 4d 80 00       	push   $0x804d9e
  803ab0:	68 64 01 00 00       	push   $0x164
  803ab5:	68 03 4d 80 00       	push   $0x804d03
  803aba:	e8 de d8 ff ff       	call   80139d <_panic>
  803abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac2:	8b 40 08             	mov    0x8(%eax),%eax
  803ac5:	85 c0                	test   %eax,%eax
  803ac7:	74 11                	je     803ada <free_block+0x48f>
  803ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acc:	8b 40 08             	mov    0x8(%eax),%eax
  803acf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ad2:	8b 52 0c             	mov    0xc(%edx),%edx
  803ad5:	89 50 0c             	mov    %edx,0xc(%eax)
  803ad8:	eb 0b                	jmp    803ae5 <free_block+0x49a>
  803ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803add:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae0:	a3 44 51 90 00       	mov    %eax,0x905144
  803ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae8:	8b 40 0c             	mov    0xc(%eax),%eax
  803aeb:	85 c0                	test   %eax,%eax
  803aed:	74 11                	je     803b00 <free_block+0x4b5>
  803aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af2:	8b 40 0c             	mov    0xc(%eax),%eax
  803af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803af8:	8b 52 08             	mov    0x8(%edx),%edx
  803afb:	89 50 08             	mov    %edx,0x8(%eax)
  803afe:	eb 0b                	jmp    803b0b <free_block+0x4c0>
  803b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b03:	8b 40 08             	mov    0x8(%eax),%eax
  803b06:	a3 40 51 90 00       	mov    %eax,0x905140
  803b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803b1f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803b24:	48                   	dec    %eax
  803b25:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803b2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803b31:	e9 1a 01 00 00       	jmp    803c50 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803b36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b3a:	0f 84 df 00 00 00    	je     803c1f <free_block+0x5d4>
  803b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b44:	0f 84 d5 00 00 00    	je     803c1f <free_block+0x5d4>
  803b4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4d:	8a 40 04             	mov    0x4(%eax),%al
  803b50:	3c 01                	cmp    $0x1,%al
  803b52:	0f 85 c7 00 00 00    	jne    803c1f <free_block+0x5d4>
  803b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b5b:	8a 40 04             	mov    0x4(%eax),%al
  803b5e:	84 c0                	test   %al,%al
  803b60:	0f 85 b9 00 00 00    	jne    803c1f <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  803b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b69:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b70:	8b 10                	mov    (%eax),%edx
  803b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b75:	8b 00                	mov    (%eax),%eax
  803b77:	01 c2                	add    %eax,%edx
  803b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b7c:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  803b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b92:	75 17                	jne    803bab <free_block+0x560>
  803b94:	83 ec 04             	sub    $0x4,%esp
  803b97:	68 9e 4d 80 00       	push   $0x804d9e
  803b9c:	68 6e 01 00 00       	push   $0x16e
  803ba1:	68 03 4d 80 00       	push   $0x804d03
  803ba6:	e8 f2 d7 ff ff       	call   80139d <_panic>
  803bab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bae:	8b 40 08             	mov    0x8(%eax),%eax
  803bb1:	85 c0                	test   %eax,%eax
  803bb3:	74 11                	je     803bc6 <free_block+0x57b>
  803bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb8:	8b 40 08             	mov    0x8(%eax),%eax
  803bbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bbe:	8b 52 0c             	mov    0xc(%edx),%edx
  803bc1:	89 50 0c             	mov    %edx,0xc(%eax)
  803bc4:	eb 0b                	jmp    803bd1 <free_block+0x586>
  803bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  803bcc:	a3 44 51 90 00       	mov    %eax,0x905144
  803bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd7:	85 c0                	test   %eax,%eax
  803bd9:	74 11                	je     803bec <free_block+0x5a1>
  803bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bde:	8b 40 0c             	mov    0xc(%eax),%eax
  803be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be4:	8b 52 08             	mov    0x8(%edx),%edx
  803be7:	89 50 08             	mov    %edx,0x8(%eax)
  803bea:	eb 0b                	jmp    803bf7 <free_block+0x5ac>
  803bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bef:	8b 40 08             	mov    0x8(%eax),%eax
  803bf2:	a3 40 51 90 00       	mov    %eax,0x905140
  803bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803c0b:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803c10:	48                   	dec    %eax
  803c11:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803c16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803c1d:	eb 31                	jmp    803c50 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803c1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c23:	74 2b                	je     803c50 <free_block+0x605>
  803c25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c29:	74 25                	je     803c50 <free_block+0x605>
  803c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2e:	8a 40 04             	mov    0x4(%eax),%al
  803c31:	84 c0                	test   %al,%al
  803c33:	75 1b                	jne    803c50 <free_block+0x605>
  803c35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c38:	8a 40 04             	mov    0x4(%eax),%al
  803c3b:	84 c0                	test   %al,%al
  803c3d:	75 11                	jne    803c50 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c42:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803c46:	90                   	nop
  803c47:	eb 07                	jmp    803c50 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803c49:	90                   	nop
  803c4a:	eb 04                	jmp    803c50 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803c4c:	90                   	nop
  803c4d:	eb 01                	jmp    803c50 <free_block+0x605>
	if (va == NULL)
		return;
  803c4f:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803c50:	c9                   	leave  
  803c51:	c3                   	ret    

00803c52 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803c52:	55                   	push   %ebp
  803c53:	89 e5                	mov    %esp,%ebp
  803c55:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c5c:	75 19                	jne    803c77 <realloc_block_FF+0x25>
  803c5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c62:	74 13                	je     803c77 <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  803c64:	83 ec 0c             	sub    $0xc,%esp
  803c67:	ff 75 0c             	pushl  0xc(%ebp)
  803c6a:	e8 0f f4 ff ff       	call   80307e <alloc_block_FF>
  803c6f:	83 c4 10             	add    $0x10,%esp
  803c72:	e9 ea 03 00 00       	jmp    804061 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  803c77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c7b:	75 3b                	jne    803cb8 <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  803c7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c81:	75 17                	jne    803c9a <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  803c83:	83 ec 0c             	sub    $0xc,%esp
  803c86:	6a 00                	push   $0x0
  803c88:	e8 f1 f3 ff ff       	call   80307e <alloc_block_FF>
  803c8d:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803c90:	b8 00 00 00 00       	mov    $0x0,%eax
  803c95:	e9 c7 03 00 00       	jmp    804061 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  803c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c9e:	74 18                	je     803cb8 <realloc_block_FF+0x66>
		{
			free_block(va);
  803ca0:	83 ec 0c             	sub    $0xc,%esp
  803ca3:	ff 75 08             	pushl  0x8(%ebp)
  803ca6:	e8 a0 f9 ff ff       	call   80364b <free_block>
  803cab:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803cae:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb3:	e9 a9 03 00 00       	jmp    804061 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  803cb8:	a1 40 51 90 00       	mov    0x905140,%eax
  803cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cc0:	e9 68 03 00 00       	jmp    80402d <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  803cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc8:	83 e8 10             	sub    $0x10,%eax
  803ccb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803cce:	0f 85 51 03 00 00    	jne    804025 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  803cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd7:	8b 00                	mov    (%eax),%eax
  803cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cdc:	83 c2 10             	add    $0x10,%edx
  803cdf:	39 d0                	cmp    %edx,%eax
  803ce1:	75 08                	jne    803ceb <realloc_block_FF+0x99>
			{
				return va;
  803ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce6:	e9 76 03 00 00       	jmp    804061 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  803ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cee:	8b 00                	mov    (%eax),%eax
  803cf0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803cf3:	0f 83 45 02 00 00    	jae    803f3e <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfc:	8b 40 08             	mov    0x8(%eax),%eax
  803cff:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  803d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d05:	8a 40 04             	mov    0x4(%eax),%al
  803d08:	3c 01                	cmp    $0x1,%al
  803d0a:	0f 85 6b 01 00 00    	jne    803e7b <realloc_block_FF+0x229>
  803d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d14:	0f 84 61 01 00 00    	je     803e7b <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  803d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1d:	8b 10                	mov    (%eax),%edx
  803d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d22:	8b 00                	mov    (%eax),%eax
  803d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803d27:	29 c1                	sub    %eax,%ecx
  803d29:	89 c8                	mov    %ecx,%eax
  803d2b:	39 c2                	cmp    %eax,%edx
  803d2d:	0f 86 e3 00 00 00    	jbe    803e16 <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  803d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d36:	8b 10                	mov    (%eax),%edx
  803d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3b:	8b 00                	mov    (%eax),%eax
  803d3d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803d40:	01 d0                	add    %edx,%eax
  803d42:	83 f8 0f             	cmp    $0xf,%eax
  803d45:	0f 86 b5 00 00 00    	jbe    803e00 <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  803d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d51:	01 d0                	add    %edx,%eax
  803d53:	83 c0 10             	add    $0x10,%eax
  803d56:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  803d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  803d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d65:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  803d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d6d:	74 06                	je     803d75 <realloc_block_FF+0x123>
  803d6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d73:	75 17                	jne    803d8c <realloc_block_FF+0x13a>
  803d75:	83 ec 04             	sub    $0x4,%esp
  803d78:	68 1c 4d 80 00       	push   $0x804d1c
  803d7d:	68 ae 01 00 00       	push   $0x1ae
  803d82:	68 03 4d 80 00       	push   $0x804d03
  803d87:	e8 11 d6 ff ff       	call   80139d <_panic>
  803d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8f:	8b 50 08             	mov    0x8(%eax),%edx
  803d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d95:	89 50 08             	mov    %edx,0x8(%eax)
  803d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d9b:	8b 40 08             	mov    0x8(%eax),%eax
  803d9e:	85 c0                	test   %eax,%eax
  803da0:	74 0c                	je     803dae <realloc_block_FF+0x15c>
  803da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da5:	8b 40 08             	mov    0x8(%eax),%eax
  803da8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dab:	89 50 0c             	mov    %edx,0xc(%eax)
  803dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803db4:	89 50 08             	mov    %edx,0x8(%eax)
  803db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dbd:	89 50 0c             	mov    %edx,0xc(%eax)
  803dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dc3:	8b 40 08             	mov    0x8(%eax),%eax
  803dc6:	85 c0                	test   %eax,%eax
  803dc8:	75 08                	jne    803dd2 <realloc_block_FF+0x180>
  803dca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dcd:	a3 44 51 90 00       	mov    %eax,0x905144
  803dd2:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803dd7:	40                   	inc    %eax
  803dd8:	a3 4c 51 90 00       	mov    %eax,0x90514c
							next->size = 0;
  803ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  803de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  803ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df0:	8d 50 10             	lea    0x10(%eax),%edx
  803df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df6:	89 10                	mov    %edx,(%eax)
							return va;
  803df8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfb:	e9 61 02 00 00       	jmp    804061 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  803e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e03:	8d 50 10             	lea    0x10(%eax),%edx
  803e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e09:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  803e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0e:	83 c0 10             	add    $0x10,%eax
  803e11:	e9 4b 02 00 00       	jmp    804061 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  803e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e19:	8b 10                	mov    (%eax),%edx
  803e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1e:	8b 00                	mov    (%eax),%eax
  803e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e23:	29 c1                	sub    %eax,%ecx
  803e25:	89 c8                	mov    %ecx,%eax
  803e27:	39 c2                	cmp    %eax,%edx
  803e29:	0f 83 f5 01 00 00    	jae    804024 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803e2f:	83 ec 0c             	sub    $0xc,%esp
  803e32:	ff 75 0c             	pushl  0xc(%ebp)
  803e35:	e8 44 f2 ff ff       	call   80307e <alloc_block_FF>
  803e3a:	83 c4 10             	add    $0x10,%esp
  803e3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  803e40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e44:	74 2d                	je     803e73 <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  803e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e49:	8b 00                	mov    (%eax),%eax
  803e4b:	83 ec 04             	sub    $0x4,%esp
  803e4e:	50                   	push   %eax
  803e4f:	ff 75 08             	pushl  0x8(%ebp)
  803e52:	ff 75 ec             	pushl  -0x14(%ebp)
  803e55:	e8 a0 e0 ff ff       	call   801efa <memcpy>
  803e5a:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  803e5d:	83 ec 0c             	sub    $0xc,%esp
  803e60:	ff 75 08             	pushl  0x8(%ebp)
  803e63:	e8 e3 f7 ff ff       	call   80364b <free_block>
  803e68:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  803e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6e:	e9 ee 01 00 00       	jmp    804061 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  803e73:	8b 45 08             	mov    0x8(%ebp),%eax
  803e76:	e9 e6 01 00 00       	jmp    804061 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e7e:	8a 40 04             	mov    0x4(%eax),%al
  803e81:	3c 01                	cmp    $0x1,%al
  803e83:	75 59                	jne    803ede <realloc_block_FF+0x28c>
  803e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e88:	8b 10                	mov    (%eax),%edx
  803e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e92:	29 c1                	sub    %eax,%ecx
  803e94:	89 c8                	mov    %ecx,%eax
  803e96:	39 c2                	cmp    %eax,%edx
  803e98:	75 44                	jne    803ede <realloc_block_FF+0x28c>
  803e9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e9e:	74 3e                	je     803ede <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea3:	8b 40 08             	mov    0x8(%eax),%eax
  803ea6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eaf:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eb8:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ece:	8d 50 10             	lea    0x10(%eax),%edx
  803ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed4:	89 10                	mov    %edx,(%eax)
					return va;
  803ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed9:	e9 83 01 00 00       	jmp    804061 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee1:	8a 40 04             	mov    0x4(%eax),%al
  803ee4:	84 c0                	test   %al,%al
  803ee6:	74 0a                	je     803ef2 <realloc_block_FF+0x2a0>
  803ee8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803eec:	0f 85 33 01 00 00    	jne    804025 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803ef2:	83 ec 0c             	sub    $0xc,%esp
  803ef5:	ff 75 0c             	pushl  0xc(%ebp)
  803ef8:	e8 81 f1 ff ff       	call   80307e <alloc_block_FF>
  803efd:	83 c4 10             	add    $0x10,%esp
  803f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  803f03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803f07:	74 2d                	je     803f36 <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  803f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0c:	8b 00                	mov    (%eax),%eax
  803f0e:	83 ec 04             	sub    $0x4,%esp
  803f11:	50                   	push   %eax
  803f12:	ff 75 08             	pushl  0x8(%ebp)
  803f15:	ff 75 e0             	pushl  -0x20(%ebp)
  803f18:	e8 dd df ff ff       	call   801efa <memcpy>
  803f1d:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  803f20:	83 ec 0c             	sub    $0xc,%esp
  803f23:	ff 75 08             	pushl  0x8(%ebp)
  803f26:	e8 20 f7 ff ff       	call   80364b <free_block>
  803f2b:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f31:	e9 2b 01 00 00       	jmp    804061 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  803f36:	8b 45 08             	mov    0x8(%ebp),%eax
  803f39:	e9 23 01 00 00       	jmp    804061 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f41:	8b 00                	mov    (%eax),%eax
  803f43:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f46:	0f 86 d9 00 00 00    	jbe    804025 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4f:	8b 00                	mov    (%eax),%eax
  803f51:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f54:	83 f8 0f             	cmp    $0xf,%eax
  803f57:	0f 86 b4 00 00 00    	jbe    804011 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f63:	01 d0                	add    %edx,%eax
  803f65:	83 c0 10             	add    $0x10,%eax
  803f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6e:	8b 00                	mov    (%eax),%eax
  803f70:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f73:	8d 50 f0             	lea    -0x10(%eax),%edx
  803f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f79:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f7f:	74 06                	je     803f87 <realloc_block_FF+0x335>
  803f81:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f85:	75 17                	jne    803f9e <realloc_block_FF+0x34c>
  803f87:	83 ec 04             	sub    $0x4,%esp
  803f8a:	68 1c 4d 80 00       	push   $0x804d1c
  803f8f:	68 ed 01 00 00       	push   $0x1ed
  803f94:	68 03 4d 80 00       	push   $0x804d03
  803f99:	e8 ff d3 ff ff       	call   80139d <_panic>
  803f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa1:	8b 50 08             	mov    0x8(%eax),%edx
  803fa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fa7:	89 50 08             	mov    %edx,0x8(%eax)
  803faa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fad:	8b 40 08             	mov    0x8(%eax),%eax
  803fb0:	85 c0                	test   %eax,%eax
  803fb2:	74 0c                	je     803fc0 <realloc_block_FF+0x36e>
  803fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb7:	8b 40 08             	mov    0x8(%eax),%eax
  803fba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fbd:	89 50 0c             	mov    %edx,0xc(%eax)
  803fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fc6:	89 50 08             	mov    %edx,0x8(%eax)
  803fc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fcf:	89 50 0c             	mov    %edx,0xc(%eax)
  803fd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fd5:	8b 40 08             	mov    0x8(%eax),%eax
  803fd8:	85 c0                	test   %eax,%eax
  803fda:	75 08                	jne    803fe4 <realloc_block_FF+0x392>
  803fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fdf:	a3 44 51 90 00       	mov    %eax,0x905144
  803fe4:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803fe9:	40                   	inc    %eax
  803fea:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  803fef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ff2:	83 c0 10             	add    $0x10,%eax
  803ff5:	83 ec 0c             	sub    $0xc,%esp
  803ff8:	50                   	push   %eax
  803ff9:	e8 4d f6 ff ff       	call   80364b <free_block>
  803ffe:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  804001:	8b 45 0c             	mov    0xc(%ebp),%eax
  804004:	8d 50 10             	lea    0x10(%eax),%edx
  804007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400a:	89 10                	mov    %edx,(%eax)
					return va;
  80400c:	8b 45 08             	mov    0x8(%ebp),%eax
  80400f:	eb 50                	jmp    804061 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  804011:	8b 45 0c             	mov    0xc(%ebp),%eax
  804014:	8d 50 10             	lea    0x10(%eax),%edx
  804017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401a:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  80401c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401f:	83 c0 10             	add    $0x10,%eax
  804022:	eb 3d                	jmp    804061 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  804024:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  804025:	a1 48 51 90 00       	mov    0x905148,%eax
  80402a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80402d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804031:	74 08                	je     80403b <realloc_block_FF+0x3e9>
  804033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804036:	8b 40 08             	mov    0x8(%eax),%eax
  804039:	eb 05                	jmp    804040 <realloc_block_FF+0x3ee>
  80403b:	b8 00 00 00 00       	mov    $0x0,%eax
  804040:	a3 48 51 90 00       	mov    %eax,0x905148
  804045:	a1 48 51 90 00       	mov    0x905148,%eax
  80404a:	85 c0                	test   %eax,%eax
  80404c:	0f 85 73 fc ff ff    	jne    803cc5 <realloc_block_FF+0x73>
  804052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804056:	0f 85 69 fc ff ff    	jne    803cc5 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  80405c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804061:	c9                   	leave  
  804062:	c3                   	ret    

00804063 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804063:	55                   	push   %ebp
  804064:	89 e5                	mov    %esp,%ebp
  804066:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804069:	8b 55 08             	mov    0x8(%ebp),%edx
  80406c:	89 d0                	mov    %edx,%eax
  80406e:	c1 e0 02             	shl    $0x2,%eax
  804071:	01 d0                	add    %edx,%eax
  804073:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80407a:	01 d0                	add    %edx,%eax
  80407c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804083:	01 d0                	add    %edx,%eax
  804085:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80408c:	01 d0                	add    %edx,%eax
  80408e:	c1 e0 04             	shl    $0x4,%eax
  804091:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804094:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80409b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80409e:	83 ec 0c             	sub    $0xc,%esp
  8040a1:	50                   	push   %eax
  8040a2:	e8 d2 ea ff ff       	call   802b79 <sys_get_virtual_time>
  8040a7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8040aa:	eb 41                	jmp    8040ed <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8040ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8040af:	83 ec 0c             	sub    $0xc,%esp
  8040b2:	50                   	push   %eax
  8040b3:	e8 c1 ea ff ff       	call   802b79 <sys_get_virtual_time>
  8040b8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8040bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040c1:	29 c2                	sub    %eax,%edx
  8040c3:	89 d0                	mov    %edx,%eax
  8040c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8040c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ce:	89 d1                	mov    %edx,%ecx
  8040d0:	29 c1                	sub    %eax,%ecx
  8040d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8040d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040d8:	39 c2                	cmp    %eax,%edx
  8040da:	0f 97 c0             	seta   %al
  8040dd:	0f b6 c0             	movzbl %al,%eax
  8040e0:	29 c1                	sub    %eax,%ecx
  8040e2:	89 c8                	mov    %ecx,%eax
  8040e4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8040e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8040ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8040f3:	72 b7                	jb     8040ac <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8040f5:	90                   	nop
  8040f6:	c9                   	leave  
  8040f7:	c3                   	ret    

008040f8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8040f8:	55                   	push   %ebp
  8040f9:	89 e5                	mov    %esp,%ebp
  8040fb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8040fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804105:	eb 03                	jmp    80410a <busy_wait+0x12>
  804107:	ff 45 fc             	incl   -0x4(%ebp)
  80410a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80410d:	3b 45 08             	cmp    0x8(%ebp),%eax
  804110:	72 f5                	jb     804107 <busy_wait+0xf>
	return i;
  804112:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804115:	c9                   	leave  
  804116:	c3                   	ret    
  804117:	90                   	nop

00804118 <__udivdi3>:
  804118:	55                   	push   %ebp
  804119:	57                   	push   %edi
  80411a:	56                   	push   %esi
  80411b:	53                   	push   %ebx
  80411c:	83 ec 1c             	sub    $0x1c,%esp
  80411f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804123:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804127:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80412b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80412f:	89 ca                	mov    %ecx,%edx
  804131:	89 f8                	mov    %edi,%eax
  804133:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804137:	85 f6                	test   %esi,%esi
  804139:	75 2d                	jne    804168 <__udivdi3+0x50>
  80413b:	39 cf                	cmp    %ecx,%edi
  80413d:	77 65                	ja     8041a4 <__udivdi3+0x8c>
  80413f:	89 fd                	mov    %edi,%ebp
  804141:	85 ff                	test   %edi,%edi
  804143:	75 0b                	jne    804150 <__udivdi3+0x38>
  804145:	b8 01 00 00 00       	mov    $0x1,%eax
  80414a:	31 d2                	xor    %edx,%edx
  80414c:	f7 f7                	div    %edi
  80414e:	89 c5                	mov    %eax,%ebp
  804150:	31 d2                	xor    %edx,%edx
  804152:	89 c8                	mov    %ecx,%eax
  804154:	f7 f5                	div    %ebp
  804156:	89 c1                	mov    %eax,%ecx
  804158:	89 d8                	mov    %ebx,%eax
  80415a:	f7 f5                	div    %ebp
  80415c:	89 cf                	mov    %ecx,%edi
  80415e:	89 fa                	mov    %edi,%edx
  804160:	83 c4 1c             	add    $0x1c,%esp
  804163:	5b                   	pop    %ebx
  804164:	5e                   	pop    %esi
  804165:	5f                   	pop    %edi
  804166:	5d                   	pop    %ebp
  804167:	c3                   	ret    
  804168:	39 ce                	cmp    %ecx,%esi
  80416a:	77 28                	ja     804194 <__udivdi3+0x7c>
  80416c:	0f bd fe             	bsr    %esi,%edi
  80416f:	83 f7 1f             	xor    $0x1f,%edi
  804172:	75 40                	jne    8041b4 <__udivdi3+0x9c>
  804174:	39 ce                	cmp    %ecx,%esi
  804176:	72 0a                	jb     804182 <__udivdi3+0x6a>
  804178:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80417c:	0f 87 9e 00 00 00    	ja     804220 <__udivdi3+0x108>
  804182:	b8 01 00 00 00       	mov    $0x1,%eax
  804187:	89 fa                	mov    %edi,%edx
  804189:	83 c4 1c             	add    $0x1c,%esp
  80418c:	5b                   	pop    %ebx
  80418d:	5e                   	pop    %esi
  80418e:	5f                   	pop    %edi
  80418f:	5d                   	pop    %ebp
  804190:	c3                   	ret    
  804191:	8d 76 00             	lea    0x0(%esi),%esi
  804194:	31 ff                	xor    %edi,%edi
  804196:	31 c0                	xor    %eax,%eax
  804198:	89 fa                	mov    %edi,%edx
  80419a:	83 c4 1c             	add    $0x1c,%esp
  80419d:	5b                   	pop    %ebx
  80419e:	5e                   	pop    %esi
  80419f:	5f                   	pop    %edi
  8041a0:	5d                   	pop    %ebp
  8041a1:	c3                   	ret    
  8041a2:	66 90                	xchg   %ax,%ax
  8041a4:	89 d8                	mov    %ebx,%eax
  8041a6:	f7 f7                	div    %edi
  8041a8:	31 ff                	xor    %edi,%edi
  8041aa:	89 fa                	mov    %edi,%edx
  8041ac:	83 c4 1c             	add    $0x1c,%esp
  8041af:	5b                   	pop    %ebx
  8041b0:	5e                   	pop    %esi
  8041b1:	5f                   	pop    %edi
  8041b2:	5d                   	pop    %ebp
  8041b3:	c3                   	ret    
  8041b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041b9:	89 eb                	mov    %ebp,%ebx
  8041bb:	29 fb                	sub    %edi,%ebx
  8041bd:	89 f9                	mov    %edi,%ecx
  8041bf:	d3 e6                	shl    %cl,%esi
  8041c1:	89 c5                	mov    %eax,%ebp
  8041c3:	88 d9                	mov    %bl,%cl
  8041c5:	d3 ed                	shr    %cl,%ebp
  8041c7:	89 e9                	mov    %ebp,%ecx
  8041c9:	09 f1                	or     %esi,%ecx
  8041cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8041cf:	89 f9                	mov    %edi,%ecx
  8041d1:	d3 e0                	shl    %cl,%eax
  8041d3:	89 c5                	mov    %eax,%ebp
  8041d5:	89 d6                	mov    %edx,%esi
  8041d7:	88 d9                	mov    %bl,%cl
  8041d9:	d3 ee                	shr    %cl,%esi
  8041db:	89 f9                	mov    %edi,%ecx
  8041dd:	d3 e2                	shl    %cl,%edx
  8041df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041e3:	88 d9                	mov    %bl,%cl
  8041e5:	d3 e8                	shr    %cl,%eax
  8041e7:	09 c2                	or     %eax,%edx
  8041e9:	89 d0                	mov    %edx,%eax
  8041eb:	89 f2                	mov    %esi,%edx
  8041ed:	f7 74 24 0c          	divl   0xc(%esp)
  8041f1:	89 d6                	mov    %edx,%esi
  8041f3:	89 c3                	mov    %eax,%ebx
  8041f5:	f7 e5                	mul    %ebp
  8041f7:	39 d6                	cmp    %edx,%esi
  8041f9:	72 19                	jb     804214 <__udivdi3+0xfc>
  8041fb:	74 0b                	je     804208 <__udivdi3+0xf0>
  8041fd:	89 d8                	mov    %ebx,%eax
  8041ff:	31 ff                	xor    %edi,%edi
  804201:	e9 58 ff ff ff       	jmp    80415e <__udivdi3+0x46>
  804206:	66 90                	xchg   %ax,%ax
  804208:	8b 54 24 08          	mov    0x8(%esp),%edx
  80420c:	89 f9                	mov    %edi,%ecx
  80420e:	d3 e2                	shl    %cl,%edx
  804210:	39 c2                	cmp    %eax,%edx
  804212:	73 e9                	jae    8041fd <__udivdi3+0xe5>
  804214:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804217:	31 ff                	xor    %edi,%edi
  804219:	e9 40 ff ff ff       	jmp    80415e <__udivdi3+0x46>
  80421e:	66 90                	xchg   %ax,%ax
  804220:	31 c0                	xor    %eax,%eax
  804222:	e9 37 ff ff ff       	jmp    80415e <__udivdi3+0x46>
  804227:	90                   	nop

00804228 <__umoddi3>:
  804228:	55                   	push   %ebp
  804229:	57                   	push   %edi
  80422a:	56                   	push   %esi
  80422b:	53                   	push   %ebx
  80422c:	83 ec 1c             	sub    $0x1c,%esp
  80422f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804233:	8b 74 24 34          	mov    0x34(%esp),%esi
  804237:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80423b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80423f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804243:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804247:	89 f3                	mov    %esi,%ebx
  804249:	89 fa                	mov    %edi,%edx
  80424b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80424f:	89 34 24             	mov    %esi,(%esp)
  804252:	85 c0                	test   %eax,%eax
  804254:	75 1a                	jne    804270 <__umoddi3+0x48>
  804256:	39 f7                	cmp    %esi,%edi
  804258:	0f 86 a2 00 00 00    	jbe    804300 <__umoddi3+0xd8>
  80425e:	89 c8                	mov    %ecx,%eax
  804260:	89 f2                	mov    %esi,%edx
  804262:	f7 f7                	div    %edi
  804264:	89 d0                	mov    %edx,%eax
  804266:	31 d2                	xor    %edx,%edx
  804268:	83 c4 1c             	add    $0x1c,%esp
  80426b:	5b                   	pop    %ebx
  80426c:	5e                   	pop    %esi
  80426d:	5f                   	pop    %edi
  80426e:	5d                   	pop    %ebp
  80426f:	c3                   	ret    
  804270:	39 f0                	cmp    %esi,%eax
  804272:	0f 87 ac 00 00 00    	ja     804324 <__umoddi3+0xfc>
  804278:	0f bd e8             	bsr    %eax,%ebp
  80427b:	83 f5 1f             	xor    $0x1f,%ebp
  80427e:	0f 84 ac 00 00 00    	je     804330 <__umoddi3+0x108>
  804284:	bf 20 00 00 00       	mov    $0x20,%edi
  804289:	29 ef                	sub    %ebp,%edi
  80428b:	89 fe                	mov    %edi,%esi
  80428d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804291:	89 e9                	mov    %ebp,%ecx
  804293:	d3 e0                	shl    %cl,%eax
  804295:	89 d7                	mov    %edx,%edi
  804297:	89 f1                	mov    %esi,%ecx
  804299:	d3 ef                	shr    %cl,%edi
  80429b:	09 c7                	or     %eax,%edi
  80429d:	89 e9                	mov    %ebp,%ecx
  80429f:	d3 e2                	shl    %cl,%edx
  8042a1:	89 14 24             	mov    %edx,(%esp)
  8042a4:	89 d8                	mov    %ebx,%eax
  8042a6:	d3 e0                	shl    %cl,%eax
  8042a8:	89 c2                	mov    %eax,%edx
  8042aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042ae:	d3 e0                	shl    %cl,%eax
  8042b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042b8:	89 f1                	mov    %esi,%ecx
  8042ba:	d3 e8                	shr    %cl,%eax
  8042bc:	09 d0                	or     %edx,%eax
  8042be:	d3 eb                	shr    %cl,%ebx
  8042c0:	89 da                	mov    %ebx,%edx
  8042c2:	f7 f7                	div    %edi
  8042c4:	89 d3                	mov    %edx,%ebx
  8042c6:	f7 24 24             	mull   (%esp)
  8042c9:	89 c6                	mov    %eax,%esi
  8042cb:	89 d1                	mov    %edx,%ecx
  8042cd:	39 d3                	cmp    %edx,%ebx
  8042cf:	0f 82 87 00 00 00    	jb     80435c <__umoddi3+0x134>
  8042d5:	0f 84 91 00 00 00    	je     80436c <__umoddi3+0x144>
  8042db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042df:	29 f2                	sub    %esi,%edx
  8042e1:	19 cb                	sbb    %ecx,%ebx
  8042e3:	89 d8                	mov    %ebx,%eax
  8042e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042e9:	d3 e0                	shl    %cl,%eax
  8042eb:	89 e9                	mov    %ebp,%ecx
  8042ed:	d3 ea                	shr    %cl,%edx
  8042ef:	09 d0                	or     %edx,%eax
  8042f1:	89 e9                	mov    %ebp,%ecx
  8042f3:	d3 eb                	shr    %cl,%ebx
  8042f5:	89 da                	mov    %ebx,%edx
  8042f7:	83 c4 1c             	add    $0x1c,%esp
  8042fa:	5b                   	pop    %ebx
  8042fb:	5e                   	pop    %esi
  8042fc:	5f                   	pop    %edi
  8042fd:	5d                   	pop    %ebp
  8042fe:	c3                   	ret    
  8042ff:	90                   	nop
  804300:	89 fd                	mov    %edi,%ebp
  804302:	85 ff                	test   %edi,%edi
  804304:	75 0b                	jne    804311 <__umoddi3+0xe9>
  804306:	b8 01 00 00 00       	mov    $0x1,%eax
  80430b:	31 d2                	xor    %edx,%edx
  80430d:	f7 f7                	div    %edi
  80430f:	89 c5                	mov    %eax,%ebp
  804311:	89 f0                	mov    %esi,%eax
  804313:	31 d2                	xor    %edx,%edx
  804315:	f7 f5                	div    %ebp
  804317:	89 c8                	mov    %ecx,%eax
  804319:	f7 f5                	div    %ebp
  80431b:	89 d0                	mov    %edx,%eax
  80431d:	e9 44 ff ff ff       	jmp    804266 <__umoddi3+0x3e>
  804322:	66 90                	xchg   %ax,%ax
  804324:	89 c8                	mov    %ecx,%eax
  804326:	89 f2                	mov    %esi,%edx
  804328:	83 c4 1c             	add    $0x1c,%esp
  80432b:	5b                   	pop    %ebx
  80432c:	5e                   	pop    %esi
  80432d:	5f                   	pop    %edi
  80432e:	5d                   	pop    %ebp
  80432f:	c3                   	ret    
  804330:	3b 04 24             	cmp    (%esp),%eax
  804333:	72 06                	jb     80433b <__umoddi3+0x113>
  804335:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804339:	77 0f                	ja     80434a <__umoddi3+0x122>
  80433b:	89 f2                	mov    %esi,%edx
  80433d:	29 f9                	sub    %edi,%ecx
  80433f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804343:	89 14 24             	mov    %edx,(%esp)
  804346:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80434a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80434e:	8b 14 24             	mov    (%esp),%edx
  804351:	83 c4 1c             	add    $0x1c,%esp
  804354:	5b                   	pop    %ebx
  804355:	5e                   	pop    %esi
  804356:	5f                   	pop    %edi
  804357:	5d                   	pop    %ebp
  804358:	c3                   	ret    
  804359:	8d 76 00             	lea    0x0(%esi),%esi
  80435c:	2b 04 24             	sub    (%esp),%eax
  80435f:	19 fa                	sbb    %edi,%edx
  804361:	89 d1                	mov    %edx,%ecx
  804363:	89 c6                	mov    %eax,%esi
  804365:	e9 71 ff ff ff       	jmp    8042db <__umoddi3+0xb3>
  80436a:	66 90                	xchg   %ax,%ax
  80436c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804370:	72 ea                	jb     80435c <__umoddi3+0x134>
  804372:	89 d9                	mov    %ebx,%ecx
  804374:	e9 62 ff ff ff       	jmp    8042db <__umoddi3+0xb3>
