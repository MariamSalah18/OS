
obj/user/tst_page_replacement_FIFO_2:     file format elf32-i386


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
  800031:	e8 84 02 00 00       	call   8002ba <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
} ;


#define kilo 1024
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	//			0xeebfd000, 																					//Stack
	//			0x80a000, 0x80b000, 0x804000, 0x80c000,0x807000,0x808000,0x800000,0x801000,0x809000,0x803000,	//Code & Data
	//	} ;

	{
		expectedMidVAs[0] = 0xeebfd000;
  800041:	c7 45 a8 00 d0 bf ee 	movl   $0xeebfd000,-0x58(%ebp)
		expectedMidVAs[1] = 0x80a000;
  800048:	c7 45 ac 00 a0 80 00 	movl   $0x80a000,-0x54(%ebp)
		expectedMidVAs[2] = 0x80b000;
  80004f:	c7 45 b0 00 b0 80 00 	movl   $0x80b000,-0x50(%ebp)
		expectedMidVAs[3] = 0x804000;
  800056:	c7 45 b4 00 40 80 00 	movl   $0x804000,-0x4c(%ebp)
		expectedMidVAs[4] = 0x80c000;
  80005d:	c7 45 b8 00 c0 80 00 	movl   $0x80c000,-0x48(%ebp)
		expectedMidVAs[5] = 0x807000;
  800064:	c7 45 bc 00 70 80 00 	movl   $0x807000,-0x44(%ebp)
		expectedMidVAs[6] = 0x808000;
  80006b:	c7 45 c0 00 80 80 00 	movl   $0x808000,-0x40(%ebp)
		expectedMidVAs[7] = 0x800000;
  800072:	c7 45 c4 00 00 80 00 	movl   $0x800000,-0x3c(%ebp)
		expectedMidVAs[8] = 0x801000;
  800079:	c7 45 c8 00 10 80 00 	movl   $0x801000,-0x38(%ebp)
		expectedMidVAs[9] = 0x809000;
  800080:	c7 45 cc 00 90 80 00 	movl   $0x809000,-0x34(%ebp)
		expectedMidVAs[10] = 0x803000;
  800087:	c7 45 d0 00 30 80 00 	movl   $0x803000,-0x30(%ebp)
//			0x803000,0x805000,0x806000,0x807000,0x808000, //Data
//	} ;

	uint32 expectedFinalVAs[11] ;
	{
		expectedFinalVAs[0] =  0x80b000;
  80008e:	c7 85 7c ff ff ff 00 	movl   $0x80b000,-0x84(%ebp)
  800095:	b0 80 00 
		expectedFinalVAs[1] =  0x804000;
  800098:	c7 45 80 00 40 80 00 	movl   $0x804000,-0x80(%ebp)
		expectedFinalVAs[2] =  0x80c000;
  80009f:	c7 45 84 00 c0 80 00 	movl   $0x80c000,-0x7c(%ebp)
		expectedFinalVAs[3] =  0x800000;
  8000a6:	c7 45 88 00 00 80 00 	movl   $0x800000,-0x78(%ebp)
		expectedFinalVAs[4] =  0x801000;
  8000ad:	c7 45 8c 00 10 80 00 	movl   $0x801000,-0x74(%ebp)
		expectedFinalVAs[5] =  0xeebfd000;
  8000b4:	c7 45 90 00 d0 bf ee 	movl   $0xeebfd000,-0x70(%ebp)
		expectedFinalVAs[6] =  0x803000;
  8000bb:	c7 45 94 00 30 80 00 	movl   $0x803000,-0x6c(%ebp)
		expectedFinalVAs[7] =  0x805000;
  8000c2:	c7 45 98 00 50 80 00 	movl   $0x805000,-0x68(%ebp)
		expectedFinalVAs[8] =  0x806000;
  8000c9:	c7 45 9c 00 60 80 00 	movl   $0x806000,-0x64(%ebp)
		expectedFinalVAs[9] =  0x807000;
  8000d0:	c7 45 a0 00 70 80 00 	movl   $0x807000,-0x60(%ebp)
		expectedFinalVAs[10] =  0x808000;
  8000d7:	c7 45 a4 00 80 80 00 	movl   $0x808000,-0x5c(%ebp)
	}

	char* tempArr = (char*)0x90000000;
  8000de:	c7 45 e8 00 00 00 90 	movl   $0x90000000,-0x18(%ebp)
	uint32 tempArrSize = 5*PAGE_SIZE;
  8000e5:	c7 45 e4 00 50 00 00 	movl   $0x5000,-0x1c(%ebp)
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  8000ec:	6a 01                	push   $0x1
  8000ee:	68 00 00 20 00       	push   $0x200000
  8000f3:	6a 0b                	push   $0xb
  8000f5:	68 20 30 80 00       	push   $0x803020
  8000fa:	e8 ab 19 00 00       	call   801aaa <sys_check_WS_list>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800105:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  800109:	74 14                	je     80011f <_main+0xe7>
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	68 e0 1d 80 00       	push   $0x801de0
  800113:	6a 44                	push   $0x44
  800115:	68 54 1e 80 00       	push   $0x801e54
  80011a:	e8 c9 02 00 00       	call   8003e8 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  80011f:	e8 69 14 00 00       	call   80158d <sys_calculate_free_frames>
  800124:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800127:	e8 ac 14 00 00       	call   8015d8 <sys_pf_calculate_allocated_pages>
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  80012f:	a0 7f e0 80 00       	mov    0x80e07f,%al
  800134:	88 45 d7             	mov    %al,-0x29(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  800137:	a0 7f f0 80 00       	mov    0x80f07f,%al
  80013c:	88 45 d6             	mov    %al,-0x2a(%ebp)
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80013f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800146:	eb 26                	jmp    80016e <_main+0x136>
	{
		arr[i] = 'A' ;
  800148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014b:	05 80 30 80 00       	add    $0x803080,%eax
  800150:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		//ptr++ ; ptr2++ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  800153:	a1 00 30 80 00       	mov    0x803000,%eax
  800158:	8a 00                	mov    (%eax),%al
  80015a:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *ptr2 ;
  80015d:	a1 04 30 80 00       	mov    0x803004,%eax
  800162:	8a 00                	mov    (%eax),%al
  800164:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800167:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  80016e:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  800175:	7e d1                	jle    800148 <_main+0x110>
		garbage5 = *ptr2 ;
	}

	//Check FIFO 1
	{
		found = sys_check_WS_list(expectedMidVAs, 11, 0x807000, 1);
  800177:	6a 01                	push   $0x1
  800179:	68 00 70 80 00       	push   $0x807000
  80017e:	6a 0b                	push   $0xb
  800180:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	e8 21 19 00 00       	call   801aaa <sys_check_WS_list>
  800189:	83 c4 10             	add    $0x10,%esp
  80018c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (found != 1) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80018f:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 78 1e 80 00       	push   $0x801e78
  80019d:	6a 63                	push   $0x63
  80019f:	68 54 1e 80 00       	push   $0x801e54
  8001a4:	e8 3f 02 00 00       	call   8003e8 <_panic>
	}

	//char* tempArr = malloc(4*PAGE_SIZE);
	sys_allocate_user_mem((uint32)tempArr, tempArrSize);
  8001a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b2:	50                   	push   %eax
  8001b3:	e8 66 19 00 00       	call   801b1e <sys_allocate_user_mem>
  8001b8:	83 c4 10             	add    $0x10,%esp
	//cprintf("1\n");

	int c;
	for(c = 0;c < tempArrSize - 1;c++)
  8001bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001c2:	eb 0e                	jmp    8001d2 <_main+0x19a>
	{
		tempArr[c] = 'a';
  8001c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	c6 00 61             	movb   $0x61,(%eax)
	//char* tempArr = malloc(4*PAGE_SIZE);
	sys_allocate_user_mem((uint32)tempArr, tempArrSize);
	//cprintf("1\n");

	int c;
	for(c = 0;c < tempArrSize - 1;c++)
  8001cf:	ff 45 ec             	incl   -0x14(%ebp)
  8001d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 e5                	ja     8001c4 <_main+0x18c>
		tempArr[c] = 'a';
	}

	//cprintf("2\n");

	sys_free_user_mem((uint32)tempArr, tempArrSize);
  8001df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e8:	50                   	push   %eax
  8001e9:	e8 14 19 00 00       	call   801b02 <sys_free_user_mem>
  8001ee:	83 c4 10             	add    $0x10,%esp

	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*0 ; i < PAGE_SIZE*6 ; i+=PAGE_SIZE/2)
  8001f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f8:	eb 26                	jmp    800220 <_main+0x1e8>
	{
		arr[i] = 'A' ;
  8001fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001fd:	05 80 30 80 00       	add    $0x803080,%eax
  800202:	c6 00 41             	movb   $0x41,(%eax)
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  800205:	a1 00 30 80 00       	mov    0x803000,%eax
  80020a:	8a 00                	mov    (%eax),%al
  80020c:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *ptr2 ;
  80020f:	a1 04 30 80 00       	mov    0x803004,%eax
  800214:	8a 00                	mov    (%eax),%al
  800216:	88 45 f6             	mov    %al,-0xa(%ebp)
	sys_free_user_mem((uint32)tempArr, tempArrSize);

	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*0 ; i < PAGE_SIZE*6 ; i+=PAGE_SIZE/2)
  800219:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  800220:	81 7d f0 ff 5f 00 00 	cmpl   $0x5fff,-0x10(%ebp)
  800227:	7e d1                	jle    8001fa <_main+0x1c2>

	//===================

	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0x80b000, 1);
  800229:	6a 01                	push   $0x1
  80022b:	68 00 b0 80 00       	push   $0x80b000
  800230:	6a 0b                	push   $0xb
  800232:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800238:	50                   	push   %eax
  800239:	e8 6c 18 00 00       	call   801aaa <sys_check_WS_list>
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (found != 1) panic("Page FIFO algo failed [AFTER Freeing an Allocated Space].. MAKE SURE to update the last_WS_element & the correct FIFO order after freeing space");
  800244:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  800248:	74 17                	je     800261 <_main+0x229>
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 c4 1e 80 00       	push   $0x801ec4
  800252:	68 85 00 00 00       	push   $0x85
  800257:	68 54 1e 80 00       	push   $0x801e54
  80025c:	e8 87 01 00 00       	call   8003e8 <_panic>
	}

	{
		if (garbage4 != *ptr) panic("test failed!");
  800261:	a1 00 30 80 00       	mov    0x803000,%eax
  800266:	8a 00                	mov    (%eax),%al
  800268:	3a 45 f7             	cmp    -0x9(%ebp),%al
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	68 54 1f 80 00       	push   $0x801f54
  800275:	68 89 00 00 00       	push   $0x89
  80027a:	68 54 1e 80 00       	push   $0x801e54
  80027f:	e8 64 01 00 00       	call   8003e8 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  800284:	a1 04 30 80 00       	mov    0x803004,%eax
  800289:	8a 00                	mov    (%eax),%al
  80028b:	3a 45 f6             	cmp    -0xa(%ebp),%al
  80028e:	74 17                	je     8002a7 <_main+0x26f>
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	68 54 1f 80 00       	push   $0x801f54
  800298:	68 8a 00 00 00       	push   $0x8a
  80029d:	68 54 1e 80 00       	push   $0x801e54
  8002a2:	e8 41 01 00 00       	call   8003e8 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [FIFO 2] is completed successfully.\n");
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	68 64 1f 80 00       	push   $0x801f64
  8002af:	e8 f1 03 00 00       	call   8006a5 <cprintf>
  8002b4:	83 c4 10             	add    $0x10,%esp
	return;
  8002b7:	90                   	nop
}
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c0:	e8 53 15 00 00       	call   801818 <sys_getenvindex>
  8002c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002cb:	89 d0                	mov    %edx,%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	01 d0                	add    %edx,%eax
  8002d1:	c1 e0 06             	shl    $0x6,%eax
  8002d4:	29 d0                	sub    %edx,%eax
  8002d6:	c1 e0 03             	shl    $0x3,%eax
  8002d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002de:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e3:	a1 60 30 80 00       	mov    0x803060,%eax
  8002e8:	8a 40 68             	mov    0x68(%eax),%al
  8002eb:	84 c0                	test   %al,%al
  8002ed:	74 0d                	je     8002fc <libmain+0x42>
		binaryname = myEnv->prog_name;
  8002ef:	a1 60 30 80 00       	mov    0x803060,%eax
  8002f4:	83 c0 68             	add    $0x68,%eax
  8002f7:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800300:	7e 0a                	jle    80030c <libmain+0x52>
		binaryname = argv[0];
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	8b 00                	mov    (%eax),%eax
  800307:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// call user main routine
	_main(argc, argv);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	ff 75 0c             	pushl  0xc(%ebp)
  800312:	ff 75 08             	pushl  0x8(%ebp)
  800315:	e8 1e fd ff ff       	call   800038 <_main>
  80031a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80031d:	e8 03 13 00 00       	call   801625 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800322:	83 ec 0c             	sub    $0xc,%esp
  800325:	68 cc 1f 80 00       	push   $0x801fcc
  80032a:	e8 76 03 00 00       	call   8006a5 <cprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800332:	a1 60 30 80 00       	mov    0x803060,%eax
  800337:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  80033d:	a1 60 30 80 00       	mov    0x803060,%eax
  800342:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	52                   	push   %edx
  80034c:	50                   	push   %eax
  80034d:	68 f4 1f 80 00       	push   $0x801ff4
  800352:	e8 4e 03 00 00       	call   8006a5 <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80035a:	a1 60 30 80 00       	mov    0x803060,%eax
  80035f:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800365:	a1 60 30 80 00       	mov    0x803060,%eax
  80036a:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800370:	a1 60 30 80 00       	mov    0x803060,%eax
  800375:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80037b:	51                   	push   %ecx
  80037c:	52                   	push   %edx
  80037d:	50                   	push   %eax
  80037e:	68 1c 20 80 00       	push   $0x80201c
  800383:	e8 1d 03 00 00       	call   8006a5 <cprintf>
  800388:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80038b:	a1 60 30 80 00       	mov    0x803060,%eax
  800390:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	50                   	push   %eax
  80039a:	68 74 20 80 00       	push   $0x802074
  80039f:	e8 01 03 00 00       	call   8006a5 <cprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 cc 1f 80 00       	push   $0x801fcc
  8003af:	e8 f1 02 00 00       	call   8006a5 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003b7:	e8 83 12 00 00       	call   80163f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003bc:	e8 19 00 00 00       	call   8003da <exit>
}
  8003c1:	90                   	nop
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	6a 00                	push   $0x0
  8003cf:	e8 10 14 00 00       	call   8017e4 <sys_destroy_env>
  8003d4:	83 c4 10             	add    $0x10,%esp
}
  8003d7:	90                   	nop
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <exit>:

void
exit(void)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003e0:	e8 65 14 00 00       	call   80184a <sys_exit_env>
}
  8003e5:	90                   	nop
  8003e6:	c9                   	leave  
  8003e7:	c3                   	ret    

008003e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8003f1:	83 c0 04             	add    $0x4,%eax
  8003f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003f7:	a1 58 f1 80 00       	mov    0x80f158,%eax
  8003fc:	85 c0                	test   %eax,%eax
  8003fe:	74 16                	je     800416 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800400:	a1 58 f1 80 00       	mov    0x80f158,%eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	50                   	push   %eax
  800409:	68 88 20 80 00       	push   $0x802088
  80040e:	e8 92 02 00 00       	call   8006a5 <cprintf>
  800413:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800416:	a1 4c 30 80 00       	mov    0x80304c,%eax
  80041b:	ff 75 0c             	pushl  0xc(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	50                   	push   %eax
  800422:	68 8d 20 80 00       	push   $0x80208d
  800427:	e8 79 02 00 00       	call   8006a5 <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80042f:	8b 45 10             	mov    0x10(%ebp),%eax
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	ff 75 f4             	pushl  -0xc(%ebp)
  800438:	50                   	push   %eax
  800439:	e8 fc 01 00 00       	call   80063a <vcprintf>
  80043e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	6a 00                	push   $0x0
  800446:	68 a9 20 80 00       	push   $0x8020a9
  80044b:	e8 ea 01 00 00       	call   80063a <vcprintf>
  800450:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800453:	e8 82 ff ff ff       	call   8003da <exit>

	// should not return here
	while (1) ;
  800458:	eb fe                	jmp    800458 <_panic+0x70>

0080045a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800460:	a1 60 30 80 00       	mov    0x803060,%eax
  800465:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	74 14                	je     800486 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 ac 20 80 00       	push   $0x8020ac
  80047a:	6a 26                	push   $0x26
  80047c:	68 f8 20 80 00       	push   $0x8020f8
  800481:	e8 62 ff ff ff       	call   8003e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800486:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80048d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800494:	e9 c5 00 00 00       	jmp    80055e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	01 d0                	add    %edx,%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	85 c0                	test   %eax,%eax
  8004ac:	75 08                	jne    8004b6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004ae:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004b1:	e9 a5 00 00 00       	jmp    80055b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004c4:	eb 69                	jmp    80052f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004c6:	a1 60 30 80 00       	mov    0x803060,%eax
  8004cb:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8004d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004d4:	89 d0                	mov    %edx,%eax
  8004d6:	01 c0                	add    %eax,%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c1 e0 03             	shl    $0x3,%eax
  8004dd:	01 c8                	add    %ecx,%eax
  8004df:	8a 40 04             	mov    0x4(%eax),%al
  8004e2:	84 c0                	test   %al,%al
  8004e4:	75 46                	jne    80052c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e6:	a1 60 30 80 00       	mov    0x803060,%eax
  8004eb:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8004f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f4:	89 d0                	mov    %edx,%eax
  8004f6:	01 c0                	add    %eax,%eax
  8004f8:	01 d0                	add    %edx,%eax
  8004fa:	c1 e0 03             	shl    $0x3,%eax
  8004fd:	01 c8                	add    %ecx,%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800504:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800507:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80050c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80050e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800511:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	01 c8                	add    %ecx,%eax
  80051d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80051f:	39 c2                	cmp    %eax,%edx
  800521:	75 09                	jne    80052c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800523:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80052a:	eb 15                	jmp    800541 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052c:	ff 45 e8             	incl   -0x18(%ebp)
  80052f:	a1 60 30 80 00       	mov    0x803060,%eax
  800534:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80053a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80053d:	39 c2                	cmp    %eax,%edx
  80053f:	77 85                	ja     8004c6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800541:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800545:	75 14                	jne    80055b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 04 21 80 00       	push   $0x802104
  80054f:	6a 3a                	push   $0x3a
  800551:	68 f8 20 80 00       	push   $0x8020f8
  800556:	e8 8d fe ff ff       	call   8003e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80055b:	ff 45 f0             	incl   -0x10(%ebp)
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800561:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800564:	0f 8c 2f ff ff ff    	jl     800499 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80056a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800571:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800578:	eb 26                	jmp    8005a0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80057a:	a1 60 30 80 00       	mov    0x803060,%eax
  80057f:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800585:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	01 c0                	add    %eax,%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	c1 e0 03             	shl    $0x3,%eax
  800591:	01 c8                	add    %ecx,%eax
  800593:	8a 40 04             	mov    0x4(%eax),%al
  800596:	3c 01                	cmp    $0x1,%al
  800598:	75 03                	jne    80059d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80059a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059d:	ff 45 e0             	incl   -0x20(%ebp)
  8005a0:	a1 60 30 80 00       	mov    0x803060,%eax
  8005a5:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8005ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ae:	39 c2                	cmp    %eax,%edx
  8005b0:	77 c8                	ja     80057a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005b8:	74 14                	je     8005ce <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005ba:	83 ec 04             	sub    $0x4,%esp
  8005bd:	68 58 21 80 00       	push   $0x802158
  8005c2:	6a 44                	push   $0x44
  8005c4:	68 f8 20 80 00       	push   $0x8020f8
  8005c9:	e8 1a fe ff ff       	call   8003e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005ce:	90                   	nop
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8005df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e2:	89 0a                	mov    %ecx,(%edx)
  8005e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e7:	88 d1                	mov    %dl,%cl
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fa:	75 2c                	jne    800628 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005fc:	a0 64 30 80 00       	mov    0x803064,%al
  800601:	0f b6 c0             	movzbl %al,%eax
  800604:	8b 55 0c             	mov    0xc(%ebp),%edx
  800607:	8b 12                	mov    (%edx),%edx
  800609:	89 d1                	mov    %edx,%ecx
  80060b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060e:	83 c2 08             	add    $0x8,%edx
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	50                   	push   %eax
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	e8 b0 0e 00 00       	call   8014cc <sys_cputs>
  80061c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	8b 40 04             	mov    0x4(%eax),%eax
  80062e:	8d 50 01             	lea    0x1(%eax),%edx
  800631:	8b 45 0c             	mov    0xc(%ebp),%eax
  800634:	89 50 04             	mov    %edx,0x4(%eax)
}
  800637:	90                   	nop
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800643:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064a:	00 00 00 
	b.cnt = 0;
  80064d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800654:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800663:	50                   	push   %eax
  800664:	68 d1 05 80 00       	push   $0x8005d1
  800669:	e8 11 02 00 00       	call   80087f <vprintfmt>
  80066e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800671:	a0 64 30 80 00       	mov    0x803064,%al
  800676:	0f b6 c0             	movzbl %al,%eax
  800679:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	50                   	push   %eax
  800683:	52                   	push   %edx
  800684:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068a:	83 c0 08             	add    $0x8,%eax
  80068d:	50                   	push   %eax
  80068e:	e8 39 0e 00 00       	call   8014cc <sys_cputs>
  800693:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800696:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  80069d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ab:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  8006b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	e8 73 ff ff ff       	call   80063a <vcprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006d8:	e8 48 0f 00 00       	call   801625 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	e8 48 ff ff ff       	call   80063a <vcprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006f8:	e8 42 0f 00 00       	call   80163f <sys_enable_interrupt>
	return cnt;
  8006fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	53                   	push   %ebx
  800706:	83 ec 14             	sub    $0x14,%esp
  800709:	8b 45 10             	mov    0x10(%ebp),%eax
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800715:	8b 45 18             	mov    0x18(%ebp),%eax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800720:	77 55                	ja     800777 <printnum+0x75>
  800722:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800725:	72 05                	jb     80072c <printnum+0x2a>
  800727:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072a:	77 4b                	ja     800777 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80072f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800732:	8b 45 18             	mov    0x18(%ebp),%eax
  800735:	ba 00 00 00 00       	mov    $0x0,%edx
  80073a:	52                   	push   %edx
  80073b:	50                   	push   %eax
  80073c:	ff 75 f4             	pushl  -0xc(%ebp)
  80073f:	ff 75 f0             	pushl  -0x10(%ebp)
  800742:	e8 29 14 00 00       	call   801b70 <__udivdi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	83 ec 04             	sub    $0x4,%esp
  80074d:	ff 75 20             	pushl  0x20(%ebp)
  800750:	53                   	push   %ebx
  800751:	ff 75 18             	pushl  0x18(%ebp)
  800754:	52                   	push   %edx
  800755:	50                   	push   %eax
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	ff 75 08             	pushl  0x8(%ebp)
  80075c:	e8 a1 ff ff ff       	call   800702 <printnum>
  800761:	83 c4 20             	add    $0x20,%esp
  800764:	eb 1a                	jmp    800780 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	ff 75 20             	pushl  0x20(%ebp)
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800777:	ff 4d 1c             	decl   0x1c(%ebp)
  80077a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80077e:	7f e6                	jg     800766 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800780:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800783:	bb 00 00 00 00       	mov    $0x0,%ebx
  800788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078e:	53                   	push   %ebx
  80078f:	51                   	push   %ecx
  800790:	52                   	push   %edx
  800791:	50                   	push   %eax
  800792:	e8 e9 14 00 00       	call   801c80 <__umoddi3>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	05 d4 23 80 00       	add    $0x8023d4,%eax
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f be c0             	movsbl %al,%eax
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
}
  8007b3:	90                   	nop
  8007b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c0:	7e 1c                	jle    8007de <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 08             	lea    0x8(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 08             	sub    $0x8,%eax
  8007d7:	8b 50 04             	mov    0x4(%eax),%edx
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	eb 40                	jmp    80081e <getuint+0x65>
	else if (lflag)
  8007de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e2:	74 1e                	je     800802 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	8d 50 04             	lea    0x4(%eax),%edx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 10                	mov    %edx,(%eax)
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	83 e8 04             	sub    $0x4,%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800800:	eb 1c                	jmp    80081e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	8d 50 04             	lea    0x4(%eax),%edx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	89 10                	mov    %edx,(%eax)
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	83 e8 04             	sub    $0x4,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800823:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800827:	7e 1c                	jle    800845 <getint+0x25>
		return va_arg(*ap, long long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 08             	lea    0x8(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 08             	sub    $0x8,%eax
  80083e:	8b 50 04             	mov    0x4(%eax),%edx
  800841:	8b 00                	mov    (%eax),%eax
  800843:	eb 38                	jmp    80087d <getint+0x5d>
	else if (lflag)
  800845:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800849:	74 1a                	je     800865 <getint+0x45>
		return va_arg(*ap, long);
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	8d 50 04             	lea    0x4(%eax),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	89 10                	mov    %edx,(%eax)
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	99                   	cltd   
  800863:	eb 18                	jmp    80087d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	8d 50 04             	lea    0x4(%eax),%edx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	89 10                	mov    %edx,(%eax)
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	83 e8 04             	sub    $0x4,%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	99                   	cltd   
}
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800887:	eb 17                	jmp    8008a0 <vprintfmt+0x21>
			if (ch == '\0')
  800889:	85 db                	test   %ebx,%ebx
  80088b:	0f 84 af 03 00 00    	je     800c40 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	53                   	push   %ebx
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a3:	8d 50 01             	lea    0x1(%eax),%edx
  8008a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a9:	8a 00                	mov    (%eax),%al
  8008ab:	0f b6 d8             	movzbl %al,%ebx
  8008ae:	83 fb 25             	cmp    $0x25,%ebx
  8008b1:	75 d6                	jne    800889 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	8d 50 01             	lea    0x1(%eax),%edx
  8008d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008dc:	8a 00                	mov    (%eax),%al
  8008de:	0f b6 d8             	movzbl %al,%ebx
  8008e1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e4:	83 f8 55             	cmp    $0x55,%eax
  8008e7:	0f 87 2b 03 00 00    	ja     800c18 <vprintfmt+0x399>
  8008ed:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8008f4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fa:	eb d7                	jmp    8008d3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800900:	eb d1                	jmp    8008d3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800902:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800909:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090c:	89 d0                	mov    %edx,%eax
  80090e:	c1 e0 02             	shl    $0x2,%eax
  800911:	01 d0                	add    %edx,%eax
  800913:	01 c0                	add    %eax,%eax
  800915:	01 d8                	add    %ebx,%eax
  800917:	83 e8 30             	sub    $0x30,%eax
  80091a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	8a 00                	mov    (%eax),%al
  800922:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800925:	83 fb 2f             	cmp    $0x2f,%ebx
  800928:	7e 3e                	jle    800968 <vprintfmt+0xe9>
  80092a:	83 fb 39             	cmp    $0x39,%ebx
  80092d:	7f 39                	jg     800968 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800932:	eb d5                	jmp    800909 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 c0 04             	add    $0x4,%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 e8 04             	sub    $0x4,%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800948:	eb 1f                	jmp    800969 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	79 83                	jns    8008d3 <vprintfmt+0x54>
				width = 0;
  800950:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800957:	e9 77 ff ff ff       	jmp    8008d3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800963:	e9 6b ff ff ff       	jmp    8008d3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800968:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	0f 89 60 ff ff ff    	jns    8008d3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800979:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800980:	e9 4e ff ff ff       	jmp    8008d3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800985:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800988:	e9 46 ff ff ff       	jmp    8008d3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 c0 04             	add    $0x4,%eax
  800993:	89 45 14             	mov    %eax,0x14(%ebp)
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	83 e8 04             	sub    $0x4,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	50                   	push   %eax
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	ff d0                	call   *%eax
  8009aa:	83 c4 10             	add    $0x10,%esp
			break;
  8009ad:	e9 89 02 00 00       	jmp    800c3b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	83 c0 04             	add    $0x4,%eax
  8009b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	83 e8 04             	sub    $0x4,%eax
  8009c1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c3:	85 db                	test   %ebx,%ebx
  8009c5:	79 02                	jns    8009c9 <vprintfmt+0x14a>
				err = -err;
  8009c7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c9:	83 fb 64             	cmp    $0x64,%ebx
  8009cc:	7f 0b                	jg     8009d9 <vprintfmt+0x15a>
  8009ce:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  8009d5:	85 f6                	test   %esi,%esi
  8009d7:	75 19                	jne    8009f2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d9:	53                   	push   %ebx
  8009da:	68 e5 23 80 00       	push   $0x8023e5
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 5e 02 00 00       	call   800c48 <printfmt>
  8009ea:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ed:	e9 49 02 00 00       	jmp    800c3b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f2:	56                   	push   %esi
  8009f3:	68 ee 23 80 00       	push   $0x8023ee
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	e8 45 02 00 00       	call   800c48 <printfmt>
  800a03:	83 c4 10             	add    $0x10,%esp
			break;
  800a06:	e9 30 02 00 00       	jmp    800c3b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	83 c0 04             	add    $0x4,%eax
  800a11:	89 45 14             	mov    %eax,0x14(%ebp)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	83 e8 04             	sub    $0x4,%eax
  800a1a:	8b 30                	mov    (%eax),%esi
  800a1c:	85 f6                	test   %esi,%esi
  800a1e:	75 05                	jne    800a25 <vprintfmt+0x1a6>
				p = "(null)";
  800a20:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a29:	7e 6d                	jle    800a98 <vprintfmt+0x219>
  800a2b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a2f:	74 67                	je     800a98 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	50                   	push   %eax
  800a38:	56                   	push   %esi
  800a39:	e8 0c 03 00 00       	call   800d4a <strnlen>
  800a3e:	83 c4 10             	add    $0x10,%esp
  800a41:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a44:	eb 16                	jmp    800a5c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a46:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
  800a56:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a59:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a60:	7f e4                	jg     800a46 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a62:	eb 34                	jmp    800a98 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a68:	74 1c                	je     800a86 <vprintfmt+0x207>
  800a6a:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6d:	7e 05                	jle    800a74 <vprintfmt+0x1f5>
  800a6f:	83 fb 7e             	cmp    $0x7e,%ebx
  800a72:	7e 12                	jle    800a86 <vprintfmt+0x207>
					putch('?', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 3f                	push   $0x3f
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	eb 0f                	jmp    800a95 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	53                   	push   %ebx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a95:	ff 4d e4             	decl   -0x1c(%ebp)
  800a98:	89 f0                	mov    %esi,%eax
  800a9a:	8d 70 01             	lea    0x1(%eax),%esi
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	0f be d8             	movsbl %al,%ebx
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	74 24                	je     800aca <vprintfmt+0x24b>
  800aa6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aaa:	78 b8                	js     800a64 <vprintfmt+0x1e5>
  800aac:	ff 4d e0             	decl   -0x20(%ebp)
  800aaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab3:	79 af                	jns    800a64 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab5:	eb 13                	jmp    800aca <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 20                	push   $0x20
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ace:	7f e7                	jg     800ab7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad0:	e9 66 01 00 00       	jmp    800c3b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 e8             	pushl  -0x18(%ebp)
  800adb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ade:	50                   	push   %eax
  800adf:	e8 3c fd ff ff       	call   800820 <getint>
  800ae4:	83 c4 10             	add    $0x10,%esp
  800ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af3:	85 d2                	test   %edx,%edx
  800af5:	79 23                	jns    800b1a <vprintfmt+0x29b>
				putch('-', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 2d                	push   $0x2d
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0d:	f7 d8                	neg    %eax
  800b0f:	83 d2 00             	adc    $0x0,%edx
  800b12:	f7 da                	neg    %edx
  800b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b21:	e9 bc 00 00 00       	jmp    800be2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2f:	50                   	push   %eax
  800b30:	e8 84 fc ff ff       	call   8007b9 <getuint>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b45:	e9 98 00 00 00       	jmp    800be2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	6a 58                	push   $0x58
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	6a 58                	push   $0x58
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	6a 58                	push   $0x58
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			break;
  800b7a:	e9 bc 00 00 00       	jmp    800c3b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 30                	push   $0x30
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 78                	push   $0x78
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba2:	83 c0 04             	add    $0x4,%eax
  800ba5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bab:	83 e8 04             	sub    $0x4,%eax
  800bae:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc1:	eb 1f                	jmp    800be2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcc:	50                   	push   %eax
  800bcd:	e8 e7 fb ff ff       	call   8007b9 <getuint>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bdb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be9:	83 ec 04             	sub    $0x4,%esp
  800bec:	52                   	push   %edx
  800bed:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	ff 75 08             	pushl  0x8(%ebp)
  800bfd:	e8 00 fb ff ff       	call   800702 <printnum>
  800c02:	83 c4 20             	add    $0x20,%esp
			break;
  800c05:	eb 34                	jmp    800c3b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	53                   	push   %ebx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			break;
  800c16:	eb 23                	jmp    800c3b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c18:	83 ec 08             	sub    $0x8,%esp
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	6a 25                	push   $0x25
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	ff d0                	call   *%eax
  800c25:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c28:	ff 4d 10             	decl   0x10(%ebp)
  800c2b:	eb 03                	jmp    800c30 <vprintfmt+0x3b1>
  800c2d:	ff 4d 10             	decl   0x10(%ebp)
  800c30:	8b 45 10             	mov    0x10(%ebp),%eax
  800c33:	48                   	dec    %eax
  800c34:	8a 00                	mov    (%eax),%al
  800c36:	3c 25                	cmp    $0x25,%al
  800c38:	75 f3                	jne    800c2d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3a:	90                   	nop
		}
	}
  800c3b:	e9 47 fc ff ff       	jmp    800887 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c40:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c4e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c51:	83 c0 04             	add    $0x4,%eax
  800c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c57:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5d:	50                   	push   %eax
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	ff 75 08             	pushl  0x8(%ebp)
  800c64:	e8 16 fc ff ff       	call   80087f <vprintfmt>
  800c69:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6c:	90                   	nop
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	8b 40 08             	mov    0x8(%eax),%eax
  800c78:	8d 50 01             	lea    0x1(%eax),%edx
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	8b 10                	mov    (%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	8b 40 04             	mov    0x4(%eax),%eax
  800c8c:	39 c2                	cmp    %eax,%edx
  800c8e:	73 12                	jae    800ca2 <sprintputch+0x33>
		*b->buf++ = ch;
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 48 01             	lea    0x1(%eax),%ecx
  800c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9b:	89 0a                	mov    %ecx,(%edx)
  800c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca0:	88 10                	mov    %dl,(%eax)
}
  800ca2:	90                   	nop
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cca:	74 06                	je     800cd2 <vsnprintf+0x2d>
  800ccc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd0:	7f 07                	jg     800cd9 <vsnprintf+0x34>
		return -E_INVAL;
  800cd2:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd7:	eb 20                	jmp    800cf9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cd9:	ff 75 14             	pushl  0x14(%ebp)
  800cdc:	ff 75 10             	pushl  0x10(%ebp)
  800cdf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce2:	50                   	push   %eax
  800ce3:	68 6f 0c 80 00       	push   $0x800c6f
  800ce8:	e8 92 fb ff ff       	call   80087f <vprintfmt>
  800ced:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d01:	8d 45 10             	lea    0x10(%ebp),%eax
  800d04:	83 c0 04             	add    $0x4,%eax
  800d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d10:	50                   	push   %eax
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	ff 75 08             	pushl  0x8(%ebp)
  800d17:	e8 89 ff ff ff       	call   800ca5 <vsnprintf>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 06                	jmp    800d3c <strlen+0x15>
		n++;
  800d36:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d39:	ff 45 08             	incl   0x8(%ebp)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 f1                	jne    800d36 <strlen+0xf>
		n++;
	return n;
  800d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d57:	eb 09                	jmp    800d62 <strnlen+0x18>
		n++;
  800d59:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 4d 0c             	decl   0xc(%ebp)
  800d62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d66:	74 09                	je     800d71 <strnlen+0x27>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	75 e8                	jne    800d59 <strnlen+0xf>
		n++;
	return n;
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d82:	90                   	nop
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8d 50 01             	lea    0x1(%eax),%edx
  800d89:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d92:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d95:	8a 12                	mov    (%edx),%dl
  800d97:	88 10                	mov    %dl,(%eax)
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	84 c0                	test   %al,%al
  800d9d:	75 e4                	jne    800d83 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db7:	eb 1f                	jmp    800dd8 <strncpy+0x34>
		*dst++ = *src;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc5:	8a 12                	mov    (%edx),%dl
  800dc7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	74 03                	je     800dd5 <strncpy+0x31>
			src++;
  800dd2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd5:	ff 45 fc             	incl   -0x4(%ebp)
  800dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dde:	72 d9                	jb     800db9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	74 30                	je     800e27 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df7:	eb 16                	jmp    800e0f <strlcpy+0x2a>
			*dst++ = *src++;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8d 50 01             	lea    0x1(%eax),%edx
  800dff:	89 55 08             	mov    %edx,0x8(%ebp)
  800e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e08:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0b:	8a 12                	mov    (%edx),%dl
  800e0d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e16:	74 09                	je     800e21 <strlcpy+0x3c>
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	84 c0                	test   %al,%al
  800e1f:	75 d8                	jne    800df9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2d:	29 c2                	sub    %eax,%edx
  800e2f:	89 d0                	mov    %edx,%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e36:	eb 06                	jmp    800e3e <strcmp+0xb>
		p++, q++;
  800e38:	ff 45 08             	incl   0x8(%ebp)
  800e3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	74 0e                	je     800e55 <strcmp+0x22>
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 10                	mov    (%eax),%dl
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	38 c2                	cmp    %al,%dl
  800e53:	74 e3                	je     800e38 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 d0             	movzbl %al,%edx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f b6 c0             	movzbl %al,%eax
  800e65:	29 c2                	sub    %eax,%edx
  800e67:	89 d0                	mov    %edx,%eax
}
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e6e:	eb 09                	jmp    800e79 <strncmp+0xe>
		n--, p++, q++;
  800e70:	ff 4d 10             	decl   0x10(%ebp)
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7d:	74 17                	je     800e96 <strncmp+0x2b>
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 0e                	je     800e96 <strncmp+0x2b>
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	38 c2                	cmp    %al,%dl
  800e94:	74 da                	je     800e70 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9a:	75 07                	jne    800ea3 <strncmp+0x38>
		return 0;
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea1:	eb 14                	jmp    800eb7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	0f b6 d0             	movzbl %al,%edx
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	0f b6 c0             	movzbl %al,%eax
  800eb3:	29 c2                	sub    %eax,%edx
  800eb5:	89 d0                	mov    %edx,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 04             	sub    $0x4,%esp
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec5:	eb 12                	jmp    800ed9 <strchr+0x20>
		if (*s == c)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ecf:	75 05                	jne    800ed6 <strchr+0x1d>
			return (char *) s;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	eb 11                	jmp    800ee7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed6:	ff 45 08             	incl   0x8(%ebp)
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	84 c0                	test   %al,%al
  800ee0:	75 e5                	jne    800ec7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 04             	sub    $0x4,%esp
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef5:	eb 0d                	jmp    800f04 <strfind+0x1b>
		if (*s == c)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eff:	74 0e                	je     800f0f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f01:	ff 45 08             	incl   0x8(%ebp)
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	84 c0                	test   %al,%al
  800f0b:	75 ea                	jne    800ef7 <strfind+0xe>
  800f0d:	eb 01                	jmp    800f10 <strfind+0x27>
		if (*s == c)
			break;
  800f0f:	90                   	nop
	return (char *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f27:	eb 0e                	jmp    800f37 <memset+0x22>
		*p++ = c;
  800f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2c:	8d 50 01             	lea    0x1(%eax),%edx
  800f2f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f35:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f37:	ff 4d f8             	decl   -0x8(%ebp)
  800f3a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f3e:	79 e9                	jns    800f29 <memset+0x14>
		*p++ = c;

	return v;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f57:	eb 16                	jmp    800f6f <memcpy+0x2a>
		*d++ = *s++;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6b:	8a 12                	mov    (%edx),%dl
  800f6d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	89 55 10             	mov    %edx,0x10(%ebp)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 dd                	jne    800f59 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f99:	73 50                	jae    800feb <memmove+0x6a>
  800f9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	01 d0                	add    %edx,%eax
  800fa3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa6:	76 43                	jbe    800feb <memmove+0x6a>
		s += n;
  800fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fab:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fae:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb4:	eb 10                	jmp    800fc6 <memmove+0x45>
			*--d = *--s;
  800fb6:	ff 4d f8             	decl   -0x8(%ebp)
  800fb9:	ff 4d fc             	decl   -0x4(%ebp)
  800fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbf:	8a 10                	mov    (%eax),%dl
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	75 e3                	jne    800fb6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd3:	eb 23                	jmp    800ff8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd8:	8d 50 01             	lea    0x1(%eax),%edx
  800fdb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe7:	8a 12                	mov    (%edx),%dl
  800fe9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff4:	85 c0                	test   %eax,%eax
  800ff6:	75 dd                	jne    800fd5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80100f:	eb 2a                	jmp    80103b <memcmp+0x3e>
		if (*s1 != *s2)
  801011:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801014:	8a 10                	mov    (%eax),%dl
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	38 c2                	cmp    %al,%dl
  80101d:	74 16                	je     801035 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80101f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f b6 d0             	movzbl %al,%edx
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f b6 c0             	movzbl %al,%eax
  80102f:	29 c2                	sub    %eax,%edx
  801031:	89 d0                	mov    %edx,%eax
  801033:	eb 18                	jmp    80104d <memcmp+0x50>
		s1++, s2++;
  801035:	ff 45 fc             	incl   -0x4(%ebp)
  801038:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103b:	8b 45 10             	mov    0x10(%ebp),%eax
  80103e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801041:	89 55 10             	mov    %edx,0x10(%ebp)
  801044:	85 c0                	test   %eax,%eax
  801046:	75 c9                	jne    801011 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	8b 45 10             	mov    0x10(%ebp),%eax
  80105b:	01 d0                	add    %edx,%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801060:	eb 15                	jmp    801077 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	0f b6 d0             	movzbl %al,%edx
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	0f b6 c0             	movzbl %al,%eax
  801070:	39 c2                	cmp    %eax,%edx
  801072:	74 0d                	je     801081 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801074:	ff 45 08             	incl   0x8(%ebp)
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80107d:	72 e3                	jb     801062 <memfind+0x13>
  80107f:	eb 01                	jmp    801082 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801081:	90                   	nop
	return (void *) s;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80108d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801094:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109b:	eb 03                	jmp    8010a0 <strtol+0x19>
		s++;
  80109d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 20                	cmp    $0x20,%al
  8010a7:	74 f4                	je     80109d <strtol+0x16>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 09                	cmp    $0x9,%al
  8010b0:	74 eb                	je     80109d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	3c 2b                	cmp    $0x2b,%al
  8010b9:	75 05                	jne    8010c0 <strtol+0x39>
		s++;
  8010bb:	ff 45 08             	incl   0x8(%ebp)
  8010be:	eb 13                	jmp    8010d3 <strtol+0x4c>
	else if (*s == '-')
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 2d                	cmp    $0x2d,%al
  8010c7:	75 0a                	jne    8010d3 <strtol+0x4c>
		s++, neg = 1;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
  8010cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	74 06                	je     8010df <strtol+0x58>
  8010d9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010dd:	75 20                	jne    8010ff <strtol+0x78>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 30                	cmp    $0x30,%al
  8010e6:	75 17                	jne    8010ff <strtol+0x78>
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	40                   	inc    %eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 78                	cmp    $0x78,%al
  8010f0:	75 0d                	jne    8010ff <strtol+0x78>
		s += 2, base = 16;
  8010f2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010fd:	eb 28                	jmp    801127 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801103:	75 15                	jne    80111a <strtol+0x93>
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 30                	cmp    $0x30,%al
  80110c:	75 0c                	jne    80111a <strtol+0x93>
		s++, base = 8;
  80110e:	ff 45 08             	incl   0x8(%ebp)
  801111:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801118:	eb 0d                	jmp    801127 <strtol+0xa0>
	else if (base == 0)
  80111a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111e:	75 07                	jne    801127 <strtol+0xa0>
		base = 10;
  801120:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 2f                	cmp    $0x2f,%al
  80112e:	7e 19                	jle    801149 <strtol+0xc2>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 39                	cmp    $0x39,%al
  801137:	7f 10                	jg     801149 <strtol+0xc2>
			dig = *s - '0';
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 30             	sub    $0x30,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 42                	jmp    80118b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 60                	cmp    $0x60,%al
  801150:	7e 19                	jle    80116b <strtol+0xe4>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 7a                	cmp    $0x7a,%al
  801159:	7f 10                	jg     80116b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 57             	sub    $0x57,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801169:	eb 20                	jmp    80118b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 40                	cmp    $0x40,%al
  801172:	7e 39                	jle    8011ad <strtol+0x126>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 5a                	cmp    $0x5a,%al
  80117b:	7f 30                	jg     8011ad <strtol+0x126>
			dig = *s - 'A' + 10;
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	0f be c0             	movsbl %al,%eax
  801185:	83 e8 37             	sub    $0x37,%eax
  801188:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801191:	7d 19                	jge    8011ac <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801199:	0f af 45 10          	imul   0x10(%ebp),%eax
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a2:	01 d0                	add    %edx,%eax
  8011a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011a7:	e9 7b ff ff ff       	jmp    801127 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ac:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b1:	74 08                	je     8011bb <strtol+0x134>
		*endptr = (char *) s;
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011bf:	74 07                	je     8011c8 <strtol+0x141>
  8011c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c4:	f7 d8                	neg    %eax
  8011c6:	eb 03                	jmp    8011cb <strtol+0x144>
  8011c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <ltostr>:

void
ltostr(long value, char *str)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	79 13                	jns    8011fa <ltostr+0x2d>
	{
		neg = 1;
  8011e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011f7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801202:	99                   	cltd   
  801203:	f7 f9                	idiv   %ecx
  801205:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801208:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120b:	8d 50 01             	lea    0x1(%eax),%edx
  80120e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801211:	89 c2                	mov    %eax,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	01 d0                	add    %edx,%eax
  801218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121b:	83 c2 30             	add    $0x30,%edx
  80121e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801223:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801228:	f7 e9                	imul   %ecx
  80122a:	c1 fa 02             	sar    $0x2,%edx
  80122d:	89 c8                	mov    %ecx,%eax
  80122f:	c1 f8 1f             	sar    $0x1f,%eax
  801232:	29 c2                	sub    %eax,%edx
  801234:	89 d0                	mov    %edx,%eax
  801236:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801241:	f7 e9                	imul   %ecx
  801243:	c1 fa 02             	sar    $0x2,%edx
  801246:	89 c8                	mov    %ecx,%eax
  801248:	c1 f8 1f             	sar    $0x1f,%eax
  80124b:	29 c2                	sub    %eax,%edx
  80124d:	89 d0                	mov    %edx,%eax
  80124f:	c1 e0 02             	shl    $0x2,%eax
  801252:	01 d0                	add    %edx,%eax
  801254:	01 c0                	add    %eax,%eax
  801256:	29 c1                	sub    %eax,%ecx
  801258:	89 ca                	mov    %ecx,%edx
  80125a:	85 d2                	test   %edx,%edx
  80125c:	75 9c                	jne    8011fa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80125e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801265:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801268:	48                   	dec    %eax
  801269:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801270:	74 3d                	je     8012af <ltostr+0xe2>
		start = 1 ;
  801272:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801279:	eb 34                	jmp    8012af <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 c2                	add    %eax,%edx
  801290:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	01 c8                	add    %ecx,%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	01 c2                	add    %eax,%edx
  8012a4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a7:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ac:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b5:	7c c4                	jl     80127b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	01 d0                	add    %edx,%eax
  8012bf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c2:	90                   	nop
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cb:	ff 75 08             	pushl  0x8(%ebp)
  8012ce:	e8 54 fa ff ff       	call   800d27 <strlen>
  8012d3:	83 c4 04             	add    $0x4,%esp
  8012d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 46 fa ff ff       	call   800d27 <strlen>
  8012e1:	83 c4 04             	add    $0x4,%esp
  8012e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f5:	eb 17                	jmp    80130e <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 c2                	add    %eax,%edx
  8012ff:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	01 c8                	add    %ecx,%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130b:	ff 45 fc             	incl   -0x4(%ebp)
  80130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801311:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801314:	7c e1                	jl     8012f7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801324:	eb 1f                	jmp    801345 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801329:	8d 50 01             	lea    0x1(%eax),%edx
  80132c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80132f:	89 c2                	mov    %eax,%edx
  801331:	8b 45 10             	mov    0x10(%ebp),%eax
  801334:	01 c2                	add    %eax,%edx
  801336:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	01 c8                	add    %ecx,%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801342:	ff 45 f8             	incl   -0x8(%ebp)
  801345:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801348:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134b:	7c d9                	jl     801326 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801350:	8b 45 10             	mov    0x10(%ebp),%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	c6 00 00             	movb   $0x0,(%eax)
}
  801358:	90                   	nop
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80135e:	8b 45 14             	mov    0x14(%ebp),%eax
  801361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801367:	8b 45 14             	mov    0x14(%ebp),%eax
  80136a:	8b 00                	mov    (%eax),%eax
  80136c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137e:	eb 0c                	jmp    80138c <strsplit+0x31>
			*string++ = 0;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8d 50 01             	lea    0x1(%eax),%edx
  801386:	89 55 08             	mov    %edx,0x8(%ebp)
  801389:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	84 c0                	test   %al,%al
  801393:	74 18                	je     8013ad <strsplit+0x52>
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	0f be c0             	movsbl %al,%eax
  80139d:	50                   	push   %eax
  80139e:	ff 75 0c             	pushl  0xc(%ebp)
  8013a1:	e8 13 fb ff ff       	call   800eb9 <strchr>
  8013a6:	83 c4 08             	add    $0x8,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	75 d3                	jne    801380 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	74 5a                	je     801410 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	83 f8 0f             	cmp    $0xf,%eax
  8013be:	75 07                	jne    8013c7 <strsplit+0x6c>
		{
			return 0;
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c5:	eb 66                	jmp    80142d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ca:	8b 00                	mov    (%eax),%eax
  8013cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8013cf:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d2:	89 0a                	mov    %ecx,(%edx)
  8013d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	01 c2                	add    %eax,%edx
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e5:	eb 03                	jmp    8013ea <strsplit+0x8f>
			string++;
  8013e7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	84 c0                	test   %al,%al
  8013f1:	74 8b                	je     80137e <strsplit+0x23>
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	0f be c0             	movsbl %al,%eax
  8013fb:	50                   	push   %eax
  8013fc:	ff 75 0c             	pushl  0xc(%ebp)
  8013ff:	e8 b5 fa ff ff       	call   800eb9 <strchr>
  801404:	83 c4 08             	add    $0x8,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	74 dc                	je     8013e7 <strsplit+0x8c>
			string++;
	}
  80140b:	e9 6e ff ff ff       	jmp    80137e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801410:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801411:	8b 45 14             	mov    0x14(%ebp),%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141d:	8b 45 10             	mov    0x10(%ebp),%eax
  801420:	01 d0                	add    %edx,%eax
  801422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801428:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143c:	eb 4c                	jmp    80148a <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  80143e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 d0                	add    %edx,%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	3c 40                	cmp    $0x40,%al
  80144a:	7e 27                	jle    801473 <str2lower+0x44>
  80144c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 5a                	cmp    $0x5a,%al
  801458:	7f 19                	jg     801473 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80145a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801465:	8b 55 0c             	mov    0xc(%ebp),%edx
  801468:	01 ca                	add    %ecx,%edx
  80146a:	8a 12                	mov    (%edx),%dl
  80146c:	83 c2 20             	add    $0x20,%edx
  80146f:	88 10                	mov    %dl,(%eax)
  801471:	eb 14                	jmp    801487 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801473:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	01 c2                	add    %eax,%edx
  80147b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801481:	01 c8                	add    %ecx,%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	ff 75 0c             	pushl  0xc(%ebp)
  80148d:	e8 95 f8 ff ff       	call   800d27 <strlen>
  801492:	83 c4 04             	add    $0x4,%esp
  801495:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801498:	7f a4                	jg     80143e <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  80149a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	57                   	push   %edi
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014bc:	cd 30                	int    $0x30
  8014be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	5b                   	pop    %ebx
  8014c8:	5e                   	pop    %esi
  8014c9:	5f                   	pop    %edi
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	52                   	push   %edx
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	50                   	push   %eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	e8 b2 ff ff ff       	call   8014a1 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 01                	push   $0x1
  801504:	e8 98 ff ff ff       	call   8014a1 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	52                   	push   %edx
  80151e:	50                   	push   %eax
  80151f:	6a 05                	push   $0x5
  801521:	e8 7b ff ff ff       	call   8014a1 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	56                   	push   %esi
  80152f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801530:	8b 75 18             	mov    0x18(%ebp),%esi
  801533:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801536:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	56                   	push   %esi
  801540:	53                   	push   %ebx
  801541:	51                   	push   %ecx
  801542:	52                   	push   %edx
  801543:	50                   	push   %eax
  801544:	6a 06                	push   $0x6
  801546:	e8 56 ff ff ff       	call   8014a1 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    

00801555 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	52                   	push   %edx
  801565:	50                   	push   %eax
  801566:	6a 07                	push   $0x7
  801568:	e8 34 ff ff ff       	call   8014a1 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	ff 75 0c             	pushl  0xc(%ebp)
  80157e:	ff 75 08             	pushl  0x8(%ebp)
  801581:	6a 08                	push   $0x8
  801583:	e8 19 ff ff ff       	call   8014a1 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 09                	push   $0x9
  80159c:	e8 00 ff ff ff       	call   8014a1 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 0a                	push   $0xa
  8015b5:	e8 e7 fe ff ff       	call   8014a1 <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 0b                	push   $0xb
  8015ce:	e8 ce fe ff ff       	call   8014a1 <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 0c                	push   $0xc
  8015e7:	e8 b5 fe ff ff       	call   8014a1 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	6a 0d                	push   $0xd
  801601:	e8 9b fe ff ff       	call   8014a1 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 0e                	push   $0xe
  80161a:	e8 82 fe ff ff       	call   8014a1 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	90                   	nop
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 11                	push   $0x11
  801634:	e8 68 fe ff ff       	call   8014a1 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	90                   	nop
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 12                	push   $0x12
  80164e:	e8 4e fe ff ff       	call   8014a1 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	90                   	nop
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_cputc>:


void
sys_cputc(const char c)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801665:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	50                   	push   %eax
  801672:	6a 13                	push   $0x13
  801674:	e8 28 fe ff ff       	call   8014a1 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	90                   	nop
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 14                	push   $0x14
  80168e:	e8 0e fe ff ff       	call   8014a1 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	50                   	push   %eax
  8016a9:	6a 15                	push   $0x15
  8016ab:	e8 f1 fd ff ff       	call   8014a1 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 18                	push   $0x18
  8016c8:	e8 d4 fd ff ff       	call   8014a1 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	52                   	push   %edx
  8016e2:	50                   	push   %eax
  8016e3:	6a 16                	push   $0x16
  8016e5:	e8 b7 fd ff ff       	call   8014a1 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 17                	push   $0x17
  801703:	e8 99 fd ff ff       	call   8014a1 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	90                   	nop
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	8b 45 10             	mov    0x10(%ebp),%eax
  801717:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80171a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80171d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	51                   	push   %ecx
  801727:	52                   	push   %edx
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	50                   	push   %eax
  80172c:	6a 19                	push   $0x19
  80172e:	e8 6e fd ff ff       	call   8014a1 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80173b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 1a                	push   $0x1a
  80174b:	e8 51 fd ff ff       	call   8014a1 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801758:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	51                   	push   %ecx
  801766:	52                   	push   %edx
  801767:	50                   	push   %eax
  801768:	6a 1b                	push   $0x1b
  80176a:	e8 32 fd ff ff       	call   8014a1 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801777:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	6a 1c                	push   $0x1c
  801787:	e8 15 fd ff ff       	call   8014a1 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 1d                	push   $0x1d
  8017a0:	e8 fc fc ff ff       	call   8014a1 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	ff 75 14             	pushl  0x14(%ebp)
  8017b5:	ff 75 10             	pushl  0x10(%ebp)
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	50                   	push   %eax
  8017bc:	6a 1e                	push   $0x1e
  8017be:	e8 de fc ff ff       	call   8014a1 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	50                   	push   %eax
  8017d7:	6a 1f                	push   $0x1f
  8017d9:	e8 c3 fc ff ff       	call   8014a1 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	90                   	nop
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	50                   	push   %eax
  8017f3:	6a 20                	push   $0x20
  8017f5:	e8 a7 fc ff ff       	call   8014a1 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 02                	push   $0x2
  80180e:	e8 8e fc ff ff       	call   8014a1 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 03                	push   $0x3
  801827:	e8 75 fc ff ff       	call   8014a1 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 04                	push   $0x4
  801840:	e8 5c fc ff ff       	call   8014a1 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_exit_env>:


void sys_exit_env(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 21                	push   $0x21
  801859:	e8 43 fc ff ff       	call   8014a1 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80186a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80186d:	8d 50 04             	lea    0x4(%eax),%edx
  801870:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	6a 22                	push   $0x22
  80187d:	e8 1f fc ff ff       	call   8014a1 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
	return result;
  801885:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801888:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188e:	89 01                	mov    %eax,(%ecx)
  801890:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	c9                   	leave  
  801897:	c2 04 00             	ret    $0x4

0080189a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	ff 75 08             	pushl  0x8(%ebp)
  8018aa:	6a 10                	push   $0x10
  8018ac:	e8 f0 fb ff ff       	call   8014a1 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b4:	90                   	nop
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 23                	push   $0x23
  8018c6:	e8 d6 fb ff ff       	call   8014a1 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018dc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	50                   	push   %eax
  8018e9:	6a 24                	push   $0x24
  8018eb:	e8 b1 fb ff ff       	call   8014a1 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f3:	90                   	nop
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <rsttst>:
void rsttst()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 26                	push   $0x26
  801905:	e8 97 fb ff ff       	call   8014a1 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
	return ;
  80190d:	90                   	nop
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 04             	sub    $0x4,%esp
  801916:	8b 45 14             	mov    0x14(%ebp),%eax
  801919:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80191c:	8b 55 18             	mov    0x18(%ebp),%edx
  80191f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	ff 75 10             	pushl  0x10(%ebp)
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 25                	push   $0x25
  801930:	e8 6c fb ff ff       	call   8014a1 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return ;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <chktst>:
void chktst(uint32 n)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	ff 75 08             	pushl  0x8(%ebp)
  801949:	6a 27                	push   $0x27
  80194b:	e8 51 fb ff ff       	call   8014a1 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
	return ;
  801953:	90                   	nop
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <inctst>:

void inctst()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 28                	push   $0x28
  801965:	e8 37 fb ff ff       	call   8014a1 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <gettst>:
uint32 gettst()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 29                	push   $0x29
  80197f:	e8 1d fb ff ff       	call   8014a1 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 2a                	push   $0x2a
  80199b:	e8 01 fb ff ff       	call   8014a1 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
  8019a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019a6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019aa:	75 07                	jne    8019b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b1:	eb 05                	jmp    8019b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 2a                	push   $0x2a
  8019cc:	e8 d0 fa ff ff       	call   8014a1 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
  8019d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019d7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019db:	75 07                	jne    8019e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e2:	eb 05                	jmp    8019e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 2a                	push   $0x2a
  8019fd:	e8 9f fa ff ff       	call   8014a1 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
  801a05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a08:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a0c:	75 07                	jne    801a15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a13:	eb 05                	jmp    801a1a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 2a                	push   $0x2a
  801a2e:	e8 6e fa ff ff       	call   8014a1 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
  801a36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a39:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a3d:	75 07                	jne    801a46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a44:	eb 05                	jmp    801a4b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	ff 75 08             	pushl  0x8(%ebp)
  801a5b:	6a 2b                	push   $0x2b
  801a5d:	e8 3f fa ff ff       	call   8014a1 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
	return ;
  801a65:	90                   	nop
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	53                   	push   %ebx
  801a7b:	51                   	push   %ecx
  801a7c:	52                   	push   %edx
  801a7d:	50                   	push   %eax
  801a7e:	6a 2c                	push   $0x2c
  801a80:	e8 1c fa ff ff       	call   8014a1 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 2d                	push   $0x2d
  801aa0:	e8 fc f9 ff ff       	call   8014a1 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	51                   	push   %ecx
  801ab9:	ff 75 10             	pushl  0x10(%ebp)
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 2e                	push   $0x2e
  801ac0:	e8 dc f9 ff ff       	call   8014a1 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	6a 0f                	push   $0xf
  801adc:	e8 c0 f9 ff ff       	call   8014a1 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 2f                	push   $0x2f
  801af8:	e8 a4 f9 ff ff       	call   8014a1 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp

}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 30                	push   $0x30
  801b13:	e8 89 f9 ff ff       	call   8014a1 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 31                	push   $0x31
  801b2f:	e8 6d f9 ff ff       	call   8014a1 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 32                	push   $0x32
  801b49:	e8 53 f9 ff ff       	call   8014a1 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	50                   	push   %eax
  801b62:	6a 33                	push   $0x33
  801b64:	e8 38 f9 ff ff       	call   8014a1 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    
  801b6f:	90                   	nop

00801b70 <__udivdi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b87:	89 ca                	mov    %ecx,%edx
  801b89:	89 f8                	mov    %edi,%eax
  801b8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8f:	85 f6                	test   %esi,%esi
  801b91:	75 2d                	jne    801bc0 <__udivdi3+0x50>
  801b93:	39 cf                	cmp    %ecx,%edi
  801b95:	77 65                	ja     801bfc <__udivdi3+0x8c>
  801b97:	89 fd                	mov    %edi,%ebp
  801b99:	85 ff                	test   %edi,%edi
  801b9b:	75 0b                	jne    801ba8 <__udivdi3+0x38>
  801b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba2:	31 d2                	xor    %edx,%edx
  801ba4:	f7 f7                	div    %edi
  801ba6:	89 c5                	mov    %eax,%ebp
  801ba8:	31 d2                	xor    %edx,%edx
  801baa:	89 c8                	mov    %ecx,%eax
  801bac:	f7 f5                	div    %ebp
  801bae:	89 c1                	mov    %eax,%ecx
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f5                	div    %ebp
  801bb4:	89 cf                	mov    %ecx,%edi
  801bb6:	89 fa                	mov    %edi,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	39 ce                	cmp    %ecx,%esi
  801bc2:	77 28                	ja     801bec <__udivdi3+0x7c>
  801bc4:	0f bd fe             	bsr    %esi,%edi
  801bc7:	83 f7 1f             	xor    $0x1f,%edi
  801bca:	75 40                	jne    801c0c <__udivdi3+0x9c>
  801bcc:	39 ce                	cmp    %ecx,%esi
  801bce:	72 0a                	jb     801bda <__udivdi3+0x6a>
  801bd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd4:	0f 87 9e 00 00 00    	ja     801c78 <__udivdi3+0x108>
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	89 fa                	mov    %edi,%edx
  801be1:	83 c4 1c             	add    $0x1c,%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    
  801be9:	8d 76 00             	lea    0x0(%esi),%esi
  801bec:	31 ff                	xor    %edi,%edi
  801bee:	31 c0                	xor    %eax,%eax
  801bf0:	89 fa                	mov    %edi,%edx
  801bf2:	83 c4 1c             	add    $0x1c,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	f7 f7                	div    %edi
  801c00:	31 ff                	xor    %edi,%edi
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c11:	89 eb                	mov    %ebp,%ebx
  801c13:	29 fb                	sub    %edi,%ebx
  801c15:	89 f9                	mov    %edi,%ecx
  801c17:	d3 e6                	shl    %cl,%esi
  801c19:	89 c5                	mov    %eax,%ebp
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 ed                	shr    %cl,%ebp
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	09 f1                	or     %esi,%ecx
  801c23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c27:	89 f9                	mov    %edi,%ecx
  801c29:	d3 e0                	shl    %cl,%eax
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 d6                	mov    %edx,%esi
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 ee                	shr    %cl,%esi
  801c33:	89 f9                	mov    %edi,%ecx
  801c35:	d3 e2                	shl    %cl,%edx
  801c37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3b:	88 d9                	mov    %bl,%cl
  801c3d:	d3 e8                	shr    %cl,%eax
  801c3f:	09 c2                	or     %eax,%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	f7 74 24 0c          	divl   0xc(%esp)
  801c49:	89 d6                	mov    %edx,%esi
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	f7 e5                	mul    %ebp
  801c4f:	39 d6                	cmp    %edx,%esi
  801c51:	72 19                	jb     801c6c <__udivdi3+0xfc>
  801c53:	74 0b                	je     801c60 <__udivdi3+0xf0>
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	31 ff                	xor    %edi,%edi
  801c59:	e9 58 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c64:	89 f9                	mov    %edi,%ecx
  801c66:	d3 e2                	shl    %cl,%edx
  801c68:	39 c2                	cmp    %eax,%edx
  801c6a:	73 e9                	jae    801c55 <__udivdi3+0xe5>
  801c6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 40 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	31 c0                	xor    %eax,%eax
  801c7a:	e9 37 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c7f:	90                   	nop

00801c80 <__umoddi3>:
  801c80:	55                   	push   %ebp
  801c81:	57                   	push   %edi
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	83 ec 1c             	sub    $0x1c,%esp
  801c87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9f:	89 f3                	mov    %esi,%ebx
  801ca1:	89 fa                	mov    %edi,%edx
  801ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca7:	89 34 24             	mov    %esi,(%esp)
  801caa:	85 c0                	test   %eax,%eax
  801cac:	75 1a                	jne    801cc8 <__umoddi3+0x48>
  801cae:	39 f7                	cmp    %esi,%edi
  801cb0:	0f 86 a2 00 00 00    	jbe    801d58 <__umoddi3+0xd8>
  801cb6:	89 c8                	mov    %ecx,%eax
  801cb8:	89 f2                	mov    %esi,%edx
  801cba:	f7 f7                	div    %edi
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	31 d2                	xor    %edx,%edx
  801cc0:	83 c4 1c             	add    $0x1c,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
  801cc8:	39 f0                	cmp    %esi,%eax
  801cca:	0f 87 ac 00 00 00    	ja     801d7c <__umoddi3+0xfc>
  801cd0:	0f bd e8             	bsr    %eax,%ebp
  801cd3:	83 f5 1f             	xor    $0x1f,%ebp
  801cd6:	0f 84 ac 00 00 00    	je     801d88 <__umoddi3+0x108>
  801cdc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce1:	29 ef                	sub    %ebp,%edi
  801ce3:	89 fe                	mov    %edi,%esi
  801ce5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce9:	89 e9                	mov    %ebp,%ecx
  801ceb:	d3 e0                	shl    %cl,%eax
  801ced:	89 d7                	mov    %edx,%edi
  801cef:	89 f1                	mov    %esi,%ecx
  801cf1:	d3 ef                	shr    %cl,%edi
  801cf3:	09 c7                	or     %eax,%edi
  801cf5:	89 e9                	mov    %ebp,%ecx
  801cf7:	d3 e2                	shl    %cl,%edx
  801cf9:	89 14 24             	mov    %edx,(%esp)
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	d3 e0                	shl    %cl,%eax
  801d00:	89 c2                	mov    %eax,%edx
  801d02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d06:	d3 e0                	shl    %cl,%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d10:	89 f1                	mov    %esi,%ecx
  801d12:	d3 e8                	shr    %cl,%eax
  801d14:	09 d0                	or     %edx,%eax
  801d16:	d3 eb                	shr    %cl,%ebx
  801d18:	89 da                	mov    %ebx,%edx
  801d1a:	f7 f7                	div    %edi
  801d1c:	89 d3                	mov    %edx,%ebx
  801d1e:	f7 24 24             	mull   (%esp)
  801d21:	89 c6                	mov    %eax,%esi
  801d23:	89 d1                	mov    %edx,%ecx
  801d25:	39 d3                	cmp    %edx,%ebx
  801d27:	0f 82 87 00 00 00    	jb     801db4 <__umoddi3+0x134>
  801d2d:	0f 84 91 00 00 00    	je     801dc4 <__umoddi3+0x144>
  801d33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d37:	29 f2                	sub    %esi,%edx
  801d39:	19 cb                	sbb    %ecx,%ebx
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d41:	d3 e0                	shl    %cl,%eax
  801d43:	89 e9                	mov    %ebp,%ecx
  801d45:	d3 ea                	shr    %cl,%edx
  801d47:	09 d0                	or     %edx,%eax
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 eb                	shr    %cl,%ebx
  801d4d:	89 da                	mov    %ebx,%edx
  801d4f:	83 c4 1c             	add    $0x1c,%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5f                   	pop    %edi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    
  801d57:	90                   	nop
  801d58:	89 fd                	mov    %edi,%ebp
  801d5a:	85 ff                	test   %edi,%edi
  801d5c:	75 0b                	jne    801d69 <__umoddi3+0xe9>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f7                	div    %edi
  801d67:	89 c5                	mov    %eax,%ebp
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 c8                	mov    %ecx,%eax
  801d71:	f7 f5                	div    %ebp
  801d73:	89 d0                	mov    %edx,%eax
  801d75:	e9 44 ff ff ff       	jmp    801cbe <__umoddi3+0x3e>
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	89 c8                	mov    %ecx,%eax
  801d7e:	89 f2                	mov    %esi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	3b 04 24             	cmp    (%esp),%eax
  801d8b:	72 06                	jb     801d93 <__umoddi3+0x113>
  801d8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d91:	77 0f                	ja     801da2 <__umoddi3+0x122>
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	29 f9                	sub    %edi,%ecx
  801d97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d9b:	89 14 24             	mov    %edx,(%esp)
  801d9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da6:	8b 14 24             	mov    (%esp),%edx
  801da9:	83 c4 1c             	add    $0x1c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    
  801db1:	8d 76 00             	lea    0x0(%esi),%esi
  801db4:	2b 04 24             	sub    (%esp),%eax
  801db7:	19 fa                	sbb    %edi,%edx
  801db9:	89 d1                	mov    %edx,%ecx
  801dbb:	89 c6                	mov    %eax,%esi
  801dbd:	e9 71 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc8:	72 ea                	jb     801db4 <__umoddi3+0x134>
  801dca:	89 d9                	mov    %ebx,%ecx
  801dcc:	e9 62 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
