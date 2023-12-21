
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 1e 05 00 00       	call   800554 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x200000, 0x201000, 0x202000, 0x203000, 0x204000, 0x205000, 0x206000,0x207000,	//Data
		0x800000, 0x801000, 0x802000, 0x803000,		//Code
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/} ;//Stack

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 74 00 00 01    	sub    $0x1000074,%esp

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	//("STEP 0: checking Initial WS entries ...\n");
	{
		found = sys_check_WS_list(expectedInitialVAs, 14, 0, 1);
  800042:	6a 01                	push   $0x1
  800044:	6a 00                	push   $0x0
  800046:	6a 0e                	push   $0xe
  800048:	68 00 30 80 00       	push   $0x803000
  80004d:	e8 f2 1c 00 00       	call   801d44 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800058:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 80 20 80 00       	push   $0x802080
  800066:	6a 15                	push   $0x15
  800068:	68 c1 20 80 00       	push   $0x8020c1
  80006d:	e8 10 06 00 00       	call   800682 <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800072:	a1 40 30 80 00       	mov    0x803040,%eax
  800077:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  80007d:	85 c0                	test   %eax,%eax
  80007f:	74 14                	je     800095 <_main+0x5d>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	68 d8 20 80 00       	push   $0x8020d8
  800089:	6a 19                	push   $0x19
  80008b:	68 c1 20 80 00       	push   $0x8020c1
  800090:	e8 ed 05 00 00       	call   800682 <_panic>
		/*====================================*/
	}
	int eval = 0;
  800095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80009c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000a3:	e8 ca 17 00 00       	call   801872 <sys_pf_calculate_allocated_pages>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  8000ab:	e8 77 17 00 00       	call   801827 <sys_calculate_free_frames>
  8000b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i=0;
  8000b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(;i<=PAGE_SIZE;i++)
  8000ba:	eb 11                	jmp    8000cd <_main+0x95>
	{
		arr[i] = 1;
  8000bc:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	c6 00 01             	movb   $0x1,(%eax)
	int eval = 0;
	bool is_correct = 1;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  8000ca:	ff 45 ec             	incl   -0x14(%ebp)
  8000cd:	81 7d ec 00 10 00 00 	cmpl   $0x1000,-0x14(%ebp)
  8000d4:	7e e6                	jle    8000bc <_main+0x84>
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
  8000d6:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000dd:	eb 11                	jmp    8000f0 <_main+0xb8>
	{
		arr[i] = 2;
  8000df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e8:	01 d0                	add    %edx,%eax
  8000ea:	c6 00 02             	movb   $0x2,(%eax)
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000ed:	ff 45 ec             	incl   -0x14(%ebp)
  8000f0:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  8000f7:	7e e6                	jle    8000df <_main+0xa7>
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
  8000f9:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800100:	eb 11                	jmp    800113 <_main+0xdb>
	{
		arr[i] = 3;
  800102:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	c6 00 03             	movb   $0x3,(%eax)
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800110:	ff 45 ec             	incl   -0x14(%ebp)
  800113:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  80011a:	7e e6                	jle    800102 <_main+0xca>
	{
		arr[i] = 3;
	}

	is_correct = 1;
  80011c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 18 21 80 00       	push   $0x802118
  80012b:	e8 0f 08 00 00       	call   80093f <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800133:	8a 85 dc ff ff fe    	mov    -0x1000024(%ebp),%al
  800139:	3c 01                	cmp    $0x1,%al
  80013b:	74 17                	je     800154 <_main+0x11c>
  80013d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	68 48 21 80 00       	push   $0x802148
  80014c:	e8 ee 07 00 00       	call   80093f <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800154:	8a 85 dc 0f 00 ff    	mov    -0xfff024(%ebp),%al
  80015a:	3c 01                	cmp    $0x1,%al
  80015c:	74 17                	je     800175 <_main+0x13d>
  80015e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 48 21 80 00       	push   $0x802148
  80016d:	e8 cd 07 00 00       	call   80093f <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800175:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  80017b:	3c 02                	cmp    $0x2,%al
  80017d:	74 17                	je     800196 <_main+0x15e>
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 48 21 80 00       	push   $0x802148
  80018e:	e8 ac 07 00 00       	call   80093f <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800196:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  80019c:	3c 02                	cmp    $0x2,%al
  80019e:	74 17                	je     8001b7 <_main+0x17f>
  8001a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 48 21 80 00       	push   $0x802148
  8001af:	e8 8b 07 00 00       	call   80093f <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001b7:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001bd:	3c 03                	cmp    $0x3,%al
  8001bf:	74 17                	je     8001d8 <_main+0x1a0>
  8001c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 48 21 80 00       	push   $0x802148
  8001d0:	e8 6a 07 00 00       	call   80093f <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001d8:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  8001de:	3c 03                	cmp    $0x3,%al
  8001e0:	74 17                	je     8001f9 <_main+0x1c1>
  8001e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 48 21 80 00       	push   $0x802148
  8001f1:	e8 49 07 00 00       	call   80093f <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT be written to Page File until evicted as victim\n");}
  8001f9:	e8 74 16 00 00       	call   801872 <sys_pf_calculate_allocated_pages>
  8001fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800201:	74 17                	je     80021a <_main+0x1e2>
  800203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 68 21 80 00       	push   $0x802168
  800212:	e8 28 07 00 00       	call   80093f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp

		int expected = 5 /*pages*/ + 2 /*tables*/;
  80021a:	c7 45 dc 07 00 00 00 	movl   $0x7,-0x24(%ebp)
		if( (freePages - sys_calculate_free_frames() ) != expected )
  800221:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800224:	e8 fe 15 00 00       	call   801827 <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 da                	mov    %ebx,%edx
  80022d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800230:	39 c2                	cmp    %eax,%edx
  800232:	74 27                	je     80025b <_main+0x223>
		{ is_correct = 0; cprintf("allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  800234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80023b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80023e:	e8 e4 15 00 00       	call   801827 <sys_calculate_free_frames>
  800243:	29 c3                	sub    %eax,%ebx
  800245:	89 d8                	mov    %ebx,%eax
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	ff 75 dc             	pushl  -0x24(%ebp)
  80024e:	68 b4 21 80 00       	push   $0x8021b4
  800253:	e8 e7 06 00 00       	call   80093f <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A finished: PLACEMENT fault handling !\n\n\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 fc 21 80 00       	push   $0x8021fc
  800263:	e8 d7 06 00 00       	call   80093f <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp

	if (is_correct)
  80026b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80026f:	74 04                	je     800275 <_main+0x23d>
	{
		eval += 40;
  800271:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	}
	is_correct = 1;
  800275:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking WS entries ...\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 2c 22 80 00       	push   $0x80222c
  800284:	e8 b6 06 00 00       	call   80093f <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
		//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
		//				0x800000,0x801000,0x802000,0x803000,
		//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80028c:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800293:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800296:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80029d:	10 20 00 
			expectedPages[2] = 0x202000 ;
  8002a0:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  8002a7:	20 20 00 
			expectedPages[3] = 0x203000 ;
  8002aa:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  8002b1:	30 20 00 
			expectedPages[4] = 0x204000 ;
  8002b4:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  8002bb:	40 20 00 
			expectedPages[5] = 0x205000 ;
  8002be:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  8002c5:	50 20 00 
			expectedPages[6] = 0x206000 ;
  8002c8:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  8002cf:	60 20 00 
			expectedPages[7] = 0x207000 ;
  8002d2:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  8002d9:	70 20 00 
			expectedPages[8] = 0x800000 ;
  8002dc:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  8002e3:	00 80 00 
			expectedPages[9] = 0x801000 ;
  8002e6:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  8002ed:	10 80 00 
			expectedPages[10] = 0x802000 ;
  8002f0:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  8002f7:	20 80 00 
			expectedPages[11] = 0x803000 ;
  8002fa:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  800301:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800304:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  80030b:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80030e:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  800315:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  800318:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  80031f:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  800322:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  800329:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  80032c:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  800333:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  800336:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  80033d:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  800340:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  800347:	e0 3f ee 
		}
		found = sys_check_WS_list(expectedPages, 19, 0, 1);
  80034a:	6a 01                	push   $0x1
  80034c:	6a 00                	push   $0x0
  80034e:	6a 13                	push   $0x13
  800350:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  800356:	50                   	push   %eax
  800357:	e8 e8 19 00 00       	call   801d44 <sys_check_WS_list>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  800362:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800366:	74 17                	je     80037f <_main+0x347>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 50 22 80 00       	push   $0x802250
  800377:	e8 c3 05 00 00       	call   80093f <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B finished: WS entries test \n\n\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 a4 22 80 00       	push   $0x8022a4
  800387:	e8 b3 05 00 00       	call   80093f <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80038f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800393:	74 04                	je     800399 <_main+0x361>
	{
		eval += 30;
  800395:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800399:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP C: checking working sets WHEN BECOMES FULL...\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 cc 22 80 00       	push   $0x8022cc
  8003a8:	e8 92 05 00 00       	call   80093f <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
  8003b0:	a1 40 30 80 00       	mov    0x803040,%eax
  8003b5:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 17                	je     8003d6 <_main+0x39e>
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  8003bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 00 23 80 00       	push   $0x802300
  8003ce:	e8 6c 05 00 00       	call   80093f <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp

		i=PAGE_SIZE*1024*3;
  8003d6:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003dd:	eb 11                	jmp    8003f0 <_main+0x3b8>
		{
			arr[i] = 4;
  8003df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8003e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	c6 00 04             	movb   $0x4,(%eax)
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003ed:	ff 45 ec             	incl   -0x14(%ebp)
  8003f0:	81 7d ec 00 00 c0 00 	cmpl   $0xc00000,-0x14(%ebp)
  8003f7:	7e e6                	jle    8003df <_main+0x3a7>
		{
			arr[i] = 4;
		}

		if( arr[PAGE_SIZE*1024*3] != 4)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8003f9:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  8003ff:	3c 04                	cmp    $0x4,%al
  800401:	74 17                	je     80041a <_main+0x3e2>
  800403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	68 48 21 80 00       	push   $0x802148
  800412:	e8 28 05 00 00       	call   80093f <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
//				0x800000,0x801000,0x802000,0x803000,
//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80041a:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800421:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800424:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80042b:	10 20 00 
			expectedPages[2] = 0x202000 ;
  80042e:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  800435:	20 20 00 
			expectedPages[3] = 0x203000 ;
  800438:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  80043f:	30 20 00 
			expectedPages[4] = 0x204000 ;
  800442:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  800449:	40 20 00 
			expectedPages[5] = 0x205000 ;
  80044c:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  800453:	50 20 00 
			expectedPages[6] = 0x206000 ;
  800456:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  80045d:	60 20 00 
			expectedPages[7] = 0x207000 ;
  800460:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  800467:	70 20 00 
			expectedPages[8] = 0x800000 ;
  80046a:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800471:	00 80 00 
			expectedPages[9] = 0x801000 ;
  800474:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  80047b:	10 80 00 
			expectedPages[10] = 0x802000 ;
  80047e:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  800485:	20 80 00 
			expectedPages[11] = 0x803000 ;
  800488:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  80048f:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800492:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  800499:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80049c:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  8004a3:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  8004a6:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  8004ad:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  8004b0:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  8004b7:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  8004ba:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  8004c1:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  8004c4:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  8004cb:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  8004ce:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  8004d5:	e0 3f ee 
			expectedPages[19] = 0xee7fd000 ;
  8004d8:	c7 85 dc ff ff fe 00 	movl   $0xee7fd000,-0x1000024(%ebp)
  8004df:	d0 7f ee 
		}
		found = sys_check_WS_list(expectedPages, 20, 0x200000, 1);
  8004e2:	6a 01                	push   $0x1
  8004e4:	68 00 00 20 00       	push   $0x200000
  8004e9:	6a 14                	push   $0x14
  8004eb:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	e8 4d 18 00 00       	call   801d44 <sys_check_WS_list>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  8004fd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800501:	74 17                	je     80051a <_main+0x4e2>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 50 22 80 00       	push   $0x802250
  800512:	e8 28 04 00 00       	call   80093f <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		//if(myEnv->page_last_WS_index != 0) { is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

	}
	cprintf("STEP C finished: WS is FULL now\n\n\n");
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 58 23 80 00       	push   $0x802358
  800522:	e8 18 04 00 00       	call   80093f <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80052a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80052e:	74 04                	je     800534 <_main+0x4fc>
	{
		eval += 30;
  800530:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800534:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//	/cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
	cprintf("[AUTO_GR@DING_PARTIAL]%d\n", eval);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	68 7b 23 80 00       	push   $0x80237b
  800546:	e8 f4 03 00 00       	call   80093f <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	return;
  80054e:	90                   	nop
}
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80055a:	e8 53 15 00 00       	call   801ab2 <sys_getenvindex>
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800565:	89 d0                	mov    %edx,%eax
  800567:	01 c0                	add    %eax,%eax
  800569:	01 d0                	add    %edx,%eax
  80056b:	c1 e0 06             	shl    $0x6,%eax
  80056e:	29 d0                	sub    %edx,%eax
  800570:	c1 e0 03             	shl    $0x3,%eax
  800573:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800578:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80057d:	a1 40 30 80 00       	mov    0x803040,%eax
  800582:	8a 40 68             	mov    0x68(%eax),%al
  800585:	84 c0                	test   %al,%al
  800587:	74 0d                	je     800596 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800589:	a1 40 30 80 00       	mov    0x803040,%eax
  80058e:	83 c0 68             	add    $0x68,%eax
  800591:	a3 38 30 80 00       	mov    %eax,0x803038

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800596:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80059a:	7e 0a                	jle    8005a6 <libmain+0x52>
		binaryname = argv[0];
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	a3 38 30 80 00       	mov    %eax,0x803038

	// call user main routine
	_main(argc, argv);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ac:	ff 75 08             	pushl  0x8(%ebp)
  8005af:	e8 84 fa ff ff       	call   800038 <_main>
  8005b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005b7:	e8 03 13 00 00       	call   8018bf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005bc:	83 ec 0c             	sub    $0xc,%esp
  8005bf:	68 b0 23 80 00       	push   $0x8023b0
  8005c4:	e8 76 03 00 00       	call   80093f <cprintf>
  8005c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005cc:	a1 40 30 80 00       	mov    0x803040,%eax
  8005d1:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8005d7:	a1 40 30 80 00       	mov    0x803040,%eax
  8005dc:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8005e2:	83 ec 04             	sub    $0x4,%esp
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	68 d8 23 80 00       	push   $0x8023d8
  8005ec:	e8 4e 03 00 00       	call   80093f <cprintf>
  8005f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005f4:	a1 40 30 80 00       	mov    0x803040,%eax
  8005f9:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8005ff:	a1 40 30 80 00       	mov    0x803040,%eax
  800604:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80060a:	a1 40 30 80 00       	mov    0x803040,%eax
  80060f:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 00 24 80 00       	push   $0x802400
  80061d:	e8 1d 03 00 00       	call   80093f <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800625:	a1 40 30 80 00       	mov    0x803040,%eax
  80062a:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	50                   	push   %eax
  800634:	68 58 24 80 00       	push   $0x802458
  800639:	e8 01 03 00 00       	call   80093f <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	68 b0 23 80 00       	push   $0x8023b0
  800649:	e8 f1 02 00 00       	call   80093f <cprintf>
  80064e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800651:	e8 83 12 00 00       	call   8018d9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800656:	e8 19 00 00 00       	call   800674 <exit>
}
  80065b:	90                   	nop
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800664:	83 ec 0c             	sub    $0xc,%esp
  800667:	6a 00                	push   $0x0
  800669:	e8 10 14 00 00       	call   801a7e <sys_destroy_env>
  80066e:	83 c4 10             	add    $0x10,%esp
}
  800671:	90                   	nop
  800672:	c9                   	leave  
  800673:	c3                   	ret    

00800674 <exit>:

void
exit(void)
{
  800674:	55                   	push   %ebp
  800675:	89 e5                	mov    %esp,%ebp
  800677:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80067a:	e8 65 14 00 00       	call   801ae4 <sys_exit_env>
}
  80067f:	90                   	nop
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800688:	8d 45 10             	lea    0x10(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800691:	a1 38 31 80 00       	mov    0x803138,%eax
  800696:	85 c0                	test   %eax,%eax
  800698:	74 16                	je     8006b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80069a:	a1 38 31 80 00       	mov    0x803138,%eax
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	50                   	push   %eax
  8006a3:	68 6c 24 80 00       	push   $0x80246c
  8006a8:	e8 92 02 00 00       	call   80093f <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006b0:	a1 38 30 80 00       	mov    0x803038,%eax
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	68 71 24 80 00       	push   $0x802471
  8006c1:	e8 79 02 00 00       	call   80093f <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	e8 fc 01 00 00       	call   8008d4 <vcprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	6a 00                	push   $0x0
  8006e0:	68 8d 24 80 00       	push   $0x80248d
  8006e5:	e8 ea 01 00 00       	call   8008d4 <vcprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006ed:	e8 82 ff ff ff       	call   800674 <exit>

	// should not return here
	while (1) ;
  8006f2:	eb fe                	jmp    8006f2 <_panic+0x70>

008006f4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8006fa:	a1 40 30 80 00       	mov    0x803040,%eax
  8006ff:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800705:	8b 45 0c             	mov    0xc(%ebp),%eax
  800708:	39 c2                	cmp    %eax,%edx
  80070a:	74 14                	je     800720 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80070c:	83 ec 04             	sub    $0x4,%esp
  80070f:	68 90 24 80 00       	push   $0x802490
  800714:	6a 26                	push   $0x26
  800716:	68 dc 24 80 00       	push   $0x8024dc
  80071b:	e8 62 ff ff ff       	call   800682 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800720:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800727:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072e:	e9 c5 00 00 00       	jmp    8007f8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800736:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	01 d0                	add    %edx,%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	85 c0                	test   %eax,%eax
  800746:	75 08                	jne    800750 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800748:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80074b:	e9 a5 00 00 00       	jmp    8007f5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800750:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800757:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80075e:	eb 69                	jmp    8007c9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800760:	a1 40 30 80 00       	mov    0x803040,%eax
  800765:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80076b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80076e:	89 d0                	mov    %edx,%eax
  800770:	01 c0                	add    %eax,%eax
  800772:	01 d0                	add    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 c8                	add    %ecx,%eax
  800779:	8a 40 04             	mov    0x4(%eax),%al
  80077c:	84 c0                	test   %al,%al
  80077e:	75 46                	jne    8007c6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800780:	a1 40 30 80 00       	mov    0x803040,%eax
  800785:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80078b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80078e:	89 d0                	mov    %edx,%eax
  800790:	01 c0                	add    %eax,%eax
  800792:	01 d0                	add    %edx,%eax
  800794:	c1 e0 03             	shl    $0x3,%eax
  800797:	01 c8                	add    %ecx,%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80079e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007a6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	01 c8                	add    %ecx,%eax
  8007b7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007b9:	39 c2                	cmp    %eax,%edx
  8007bb:	75 09                	jne    8007c6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8007bd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007c4:	eb 15                	jmp    8007db <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007c6:	ff 45 e8             	incl   -0x18(%ebp)
  8007c9:	a1 40 30 80 00       	mov    0x803040,%eax
  8007ce:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8007d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d7:	39 c2                	cmp    %eax,%edx
  8007d9:	77 85                	ja     800760 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007df:	75 14                	jne    8007f5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8007e1:	83 ec 04             	sub    $0x4,%esp
  8007e4:	68 e8 24 80 00       	push   $0x8024e8
  8007e9:	6a 3a                	push   $0x3a
  8007eb:	68 dc 24 80 00       	push   $0x8024dc
  8007f0:	e8 8d fe ff ff       	call   800682 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8007f5:	ff 45 f0             	incl   -0x10(%ebp)
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007fe:	0f 8c 2f ff ff ff    	jl     800733 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800804:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80080b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800812:	eb 26                	jmp    80083a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800814:	a1 40 30 80 00       	mov    0x803040,%eax
  800819:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80081f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800822:	89 d0                	mov    %edx,%eax
  800824:	01 c0                	add    %eax,%eax
  800826:	01 d0                	add    %edx,%eax
  800828:	c1 e0 03             	shl    $0x3,%eax
  80082b:	01 c8                	add    %ecx,%eax
  80082d:	8a 40 04             	mov    0x4(%eax),%al
  800830:	3c 01                	cmp    $0x1,%al
  800832:	75 03                	jne    800837 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800834:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800837:	ff 45 e0             	incl   -0x20(%ebp)
  80083a:	a1 40 30 80 00       	mov    0x803040,%eax
  80083f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800848:	39 c2                	cmp    %eax,%edx
  80084a:	77 c8                	ja     800814 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80084c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800852:	74 14                	je     800868 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	68 3c 25 80 00       	push   $0x80253c
  80085c:	6a 44                	push   $0x44
  80085e:	68 dc 24 80 00       	push   $0x8024dc
  800863:	e8 1a fe ff ff       	call   800682 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800868:	90                   	nop
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800871:	8b 45 0c             	mov    0xc(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	8d 48 01             	lea    0x1(%eax),%ecx
  800879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087c:	89 0a                	mov    %ecx,(%edx)
  80087e:	8b 55 08             	mov    0x8(%ebp),%edx
  800881:	88 d1                	mov    %dl,%cl
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800894:	75 2c                	jne    8008c2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800896:	a0 44 30 80 00       	mov    0x803044,%al
  80089b:	0f b6 c0             	movzbl %al,%eax
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	8b 12                	mov    (%edx),%edx
  8008a3:	89 d1                	mov    %edx,%ecx
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a8:	83 c2 08             	add    $0x8,%edx
  8008ab:	83 ec 04             	sub    $0x4,%esp
  8008ae:	50                   	push   %eax
  8008af:	51                   	push   %ecx
  8008b0:	52                   	push   %edx
  8008b1:	e8 b0 0e 00 00       	call   801766 <sys_cputs>
  8008b6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	8b 40 04             	mov    0x4(%eax),%eax
  8008c8:	8d 50 01             	lea    0x1(%eax),%edx
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008d1:	90                   	nop
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    

008008d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008e4:	00 00 00 
	b.cnt = 0;
  8008e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	68 6b 08 80 00       	push   $0x80086b
  800903:	e8 11 02 00 00       	call   800b19 <vprintfmt>
  800908:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80090b:	a0 44 30 80 00       	mov    0x803044,%al
  800910:	0f b6 c0             	movzbl %al,%eax
  800913:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800919:	83 ec 04             	sub    $0x4,%esp
  80091c:	50                   	push   %eax
  80091d:	52                   	push   %edx
  80091e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800924:	83 c0 08             	add    $0x8,%eax
  800927:	50                   	push   %eax
  800928:	e8 39 0e 00 00       	call   801766 <sys_cputs>
  80092d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800930:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800937:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80093d:	c9                   	leave  
  80093e:	c3                   	ret    

0080093f <cprintf>:

int cprintf(const char *fmt, ...) {
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800945:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80094c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80094f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 f4             	pushl  -0xc(%ebp)
  80095b:	50                   	push   %eax
  80095c:	e8 73 ff ff ff       	call   8008d4 <vcprintf>
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800967:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

0080096c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800972:	e8 48 0f 00 00       	call   8018bf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800977:	8d 45 0c             	lea    0xc(%ebp),%eax
  80097a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 f4             	pushl  -0xc(%ebp)
  800986:	50                   	push   %eax
  800987:	e8 48 ff ff ff       	call   8008d4 <vcprintf>
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800992:	e8 42 0f 00 00       	call   8018d9 <sys_enable_interrupt>
	return cnt;
  800997:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	83 ec 14             	sub    $0x14,%esp
  8009a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009af:	8b 45 18             	mov    0x18(%ebp),%eax
  8009b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009ba:	77 55                	ja     800a11 <printnum+0x75>
  8009bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009bf:	72 05                	jb     8009c6 <printnum+0x2a>
  8009c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009c4:	77 4b                	ja     800a11 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8009cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d4:	52                   	push   %edx
  8009d5:	50                   	push   %eax
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009dc:	e8 2b 14 00 00       	call   801e0c <__udivdi3>
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	ff 75 20             	pushl  0x20(%ebp)
  8009ea:	53                   	push   %ebx
  8009eb:	ff 75 18             	pushl  0x18(%ebp)
  8009ee:	52                   	push   %edx
  8009ef:	50                   	push   %eax
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	ff 75 08             	pushl  0x8(%ebp)
  8009f6:	e8 a1 ff ff ff       	call   80099c <printnum>
  8009fb:	83 c4 20             	add    $0x20,%esp
  8009fe:	eb 1a                	jmp    800a1a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a00:	83 ec 08             	sub    $0x8,%esp
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 20             	pushl  0x20(%ebp)
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a11:	ff 4d 1c             	decl   0x1c(%ebp)
  800a14:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a18:	7f e6                	jg     800a00 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a1a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	53                   	push   %ebx
  800a29:	51                   	push   %ecx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	e8 eb 14 00 00       	call   801f1c <__umoddi3>
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	05 b4 27 80 00       	add    $0x8027b4,%eax
  800a39:	8a 00                	mov    (%eax),%al
  800a3b:	0f be c0             	movsbl %al,%eax
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	50                   	push   %eax
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	ff d0                	call   *%eax
  800a4a:	83 c4 10             	add    $0x10,%esp
}
  800a4d:	90                   	nop
  800a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a56:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a5a:	7e 1c                	jle    800a78 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	8d 50 08             	lea    0x8(%eax),%edx
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 10                	mov    %edx,(%eax)
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 e8 08             	sub    $0x8,%eax
  800a71:	8b 50 04             	mov    0x4(%eax),%edx
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	eb 40                	jmp    800ab8 <getuint+0x65>
	else if (lflag)
  800a78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7c:	74 1e                	je     800a9c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	8d 50 04             	lea    0x4(%eax),%edx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	89 10                	mov    %edx,(%eax)
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 00                	mov    (%eax),%eax
  800a90:	83 e8 04             	sub    $0x4,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9a:	eb 1c                	jmp    800ab8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	8d 50 04             	lea    0x4(%eax),%edx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	89 10                	mov    %edx,(%eax)
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8b 00                	mov    (%eax),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800abd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ac1:	7e 1c                	jle    800adf <getint+0x25>
		return va_arg(*ap, long long);
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8b 00                	mov    (%eax),%eax
  800ac8:	8d 50 08             	lea    0x8(%eax),%edx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	89 10                	mov    %edx,(%eax)
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 00                	mov    (%eax),%eax
  800ad5:	83 e8 08             	sub    $0x8,%eax
  800ad8:	8b 50 04             	mov    0x4(%eax),%edx
  800adb:	8b 00                	mov    (%eax),%eax
  800add:	eb 38                	jmp    800b17 <getint+0x5d>
	else if (lflag)
  800adf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae3:	74 1a                	je     800aff <getint+0x45>
		return va_arg(*ap, long);
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	8d 50 04             	lea    0x4(%eax),%edx
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	89 10                	mov    %edx,(%eax)
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 e8 04             	sub    $0x4,%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	99                   	cltd   
  800afd:	eb 18                	jmp    800b17 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	8d 50 04             	lea    0x4(%eax),%edx
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	89 10                	mov    %edx,(%eax)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	83 e8 04             	sub    $0x4,%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	99                   	cltd   
}
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b21:	eb 17                	jmp    800b3a <vprintfmt+0x21>
			if (ch == '\0')
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	0f 84 af 03 00 00    	je     800eda <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	89 55 10             	mov    %edx,0x10(%ebp)
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	0f b6 d8             	movzbl %al,%ebx
  800b48:	83 fb 25             	cmp    $0x25,%ebx
  800b4b:	75 d6                	jne    800b23 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b58:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b5f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b66:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	89 55 10             	mov    %edx,0x10(%ebp)
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	0f b6 d8             	movzbl %al,%ebx
  800b7b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b7e:	83 f8 55             	cmp    $0x55,%eax
  800b81:	0f 87 2b 03 00 00    	ja     800eb2 <vprintfmt+0x399>
  800b87:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800b8e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b90:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b94:	eb d7                	jmp    800b6d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b96:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b9a:	eb d1                	jmp    800b6d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ba3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba6:	89 d0                	mov    %edx,%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	01 d0                	add    %edx,%eax
  800bad:	01 c0                	add    %eax,%eax
  800baf:	01 d8                	add    %ebx,%eax
  800bb1:	83 e8 30             	sub    $0x30,%eax
  800bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bbf:	83 fb 2f             	cmp    $0x2f,%ebx
  800bc2:	7e 3e                	jle    800c02 <vprintfmt+0xe9>
  800bc4:	83 fb 39             	cmp    $0x39,%ebx
  800bc7:	7f 39                	jg     800c02 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bcc:	eb d5                	jmp    800ba3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bce:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd1:	83 c0 04             	add    $0x4,%eax
  800bd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bda:	83 e8 04             	sub    $0x4,%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800be2:	eb 1f                	jmp    800c03 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800be4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be8:	79 83                	jns    800b6d <vprintfmt+0x54>
				width = 0;
  800bea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bf1:	e9 77 ff ff ff       	jmp    800b6d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bf6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bfd:	e9 6b ff ff ff       	jmp    800b6d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c02:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c07:	0f 89 60 ff ff ff    	jns    800b6d <vprintfmt+0x54>
				width = precision, precision = -1;
  800c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c1a:	e9 4e ff ff ff       	jmp    800b6d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c1f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c22:	e9 46 ff ff ff       	jmp    800b6d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	83 c0 04             	add    $0x4,%eax
  800c2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c30:	8b 45 14             	mov    0x14(%ebp),%eax
  800c33:	83 e8 04             	sub    $0x4,%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	50                   	push   %eax
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			break;
  800c47:	e9 89 02 00 00       	jmp    800ed5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4f:	83 c0 04             	add    $0x4,%eax
  800c52:	89 45 14             	mov    %eax,0x14(%ebp)
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 e8 04             	sub    $0x4,%eax
  800c5b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c5d:	85 db                	test   %ebx,%ebx
  800c5f:	79 02                	jns    800c63 <vprintfmt+0x14a>
				err = -err;
  800c61:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c63:	83 fb 64             	cmp    $0x64,%ebx
  800c66:	7f 0b                	jg     800c73 <vprintfmt+0x15a>
  800c68:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  800c6f:	85 f6                	test   %esi,%esi
  800c71:	75 19                	jne    800c8c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c73:	53                   	push   %ebx
  800c74:	68 c5 27 80 00       	push   $0x8027c5
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 5e 02 00 00       	call   800ee2 <printfmt>
  800c84:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c87:	e9 49 02 00 00       	jmp    800ed5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c8c:	56                   	push   %esi
  800c8d:	68 ce 27 80 00       	push   $0x8027ce
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	ff 75 08             	pushl  0x8(%ebp)
  800c98:	e8 45 02 00 00       	call   800ee2 <printfmt>
  800c9d:	83 c4 10             	add    $0x10,%esp
			break;
  800ca0:	e9 30 02 00 00       	jmp    800ed5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 c0 04             	add    $0x4,%eax
  800cab:	89 45 14             	mov    %eax,0x14(%ebp)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	83 e8 04             	sub    $0x4,%eax
  800cb4:	8b 30                	mov    (%eax),%esi
  800cb6:	85 f6                	test   %esi,%esi
  800cb8:	75 05                	jne    800cbf <vprintfmt+0x1a6>
				p = "(null)";
  800cba:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  800cbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc3:	7e 6d                	jle    800d32 <vprintfmt+0x219>
  800cc5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cc9:	74 67                	je     800d32 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	50                   	push   %eax
  800cd2:	56                   	push   %esi
  800cd3:	e8 0c 03 00 00       	call   800fe4 <strnlen>
  800cd8:	83 c4 10             	add    $0x10,%esp
  800cdb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cde:	eb 16                	jmp    800cf6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ce0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfa:	7f e4                	jg     800ce0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfc:	eb 34                	jmp    800d32 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d02:	74 1c                	je     800d20 <vprintfmt+0x207>
  800d04:	83 fb 1f             	cmp    $0x1f,%ebx
  800d07:	7e 05                	jle    800d0e <vprintfmt+0x1f5>
  800d09:	83 fb 7e             	cmp    $0x7e,%ebx
  800d0c:	7e 12                	jle    800d20 <vprintfmt+0x207>
					putch('?', putdat);
  800d0e:	83 ec 08             	sub    $0x8,%esp
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	6a 3f                	push   $0x3f
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	ff d0                	call   *%eax
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	eb 0f                	jmp    800d2f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	53                   	push   %ebx
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800d32:	89 f0                	mov    %esi,%eax
  800d34:	8d 70 01             	lea    0x1(%eax),%esi
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f be d8             	movsbl %al,%ebx
  800d3c:	85 db                	test   %ebx,%ebx
  800d3e:	74 24                	je     800d64 <vprintfmt+0x24b>
  800d40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d44:	78 b8                	js     800cfe <vprintfmt+0x1e5>
  800d46:	ff 4d e0             	decl   -0x20(%ebp)
  800d49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4d:	79 af                	jns    800cfe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4f:	eb 13                	jmp    800d64 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	6a 20                	push   $0x20
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	ff d0                	call   *%eax
  800d5e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d61:	ff 4d e4             	decl   -0x1c(%ebp)
  800d64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d68:	7f e7                	jg     800d51 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d6a:	e9 66 01 00 00       	jmp    800ed5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	ff 75 e8             	pushl  -0x18(%ebp)
  800d75:	8d 45 14             	lea    0x14(%ebp),%eax
  800d78:	50                   	push   %eax
  800d79:	e8 3c fd ff ff       	call   800aba <getint>
  800d7e:	83 c4 10             	add    $0x10,%esp
  800d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8d:	85 d2                	test   %edx,%edx
  800d8f:	79 23                	jns    800db4 <vprintfmt+0x29b>
				putch('-', putdat);
  800d91:	83 ec 08             	sub    $0x8,%esp
  800d94:	ff 75 0c             	pushl  0xc(%ebp)
  800d97:	6a 2d                	push   $0x2d
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	ff d0                	call   *%eax
  800d9e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da7:	f7 d8                	neg    %eax
  800da9:	83 d2 00             	adc    $0x0,%edx
  800dac:	f7 da                	neg    %edx
  800dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800db4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dbb:	e9 bc 00 00 00       	jmp    800e7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dc0:	83 ec 08             	sub    $0x8,%esp
  800dc3:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc6:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc9:	50                   	push   %eax
  800dca:	e8 84 fc ff ff       	call   800a53 <getuint>
  800dcf:	83 c4 10             	add    $0x10,%esp
  800dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ddf:	e9 98 00 00 00       	jmp    800e7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 58                	push   $0x58
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	6a 58                	push   $0x58
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	ff d0                	call   *%eax
  800e01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	6a 58                	push   $0x58
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	ff d0                	call   *%eax
  800e11:	83 c4 10             	add    $0x10,%esp
			break;
  800e14:	e9 bc 00 00 00       	jmp    800ed5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	6a 30                	push   $0x30
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	ff d0                	call   *%eax
  800e26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	ff 75 0c             	pushl  0xc(%ebp)
  800e2f:	6a 78                	push   $0x78
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	ff d0                	call   *%eax
  800e36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e5b:	eb 1f                	jmp    800e7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 e8             	pushl  -0x18(%ebp)
  800e63:	8d 45 14             	lea    0x14(%ebp),%eax
  800e66:	50                   	push   %eax
  800e67:	e8 e7 fb ff ff       	call   800a53 <getuint>
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e83:	83 ec 04             	sub    $0x4,%esp
  800e86:	52                   	push   %edx
  800e87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	ff 75 08             	pushl  0x8(%ebp)
  800e97:	e8 00 fb ff ff       	call   80099c <printnum>
  800e9c:	83 c4 20             	add    $0x20,%esp
			break;
  800e9f:	eb 34                	jmp    800ed5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	53                   	push   %ebx
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	ff d0                	call   *%eax
  800ead:	83 c4 10             	add    $0x10,%esp
			break;
  800eb0:	eb 23                	jmp    800ed5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 25                	push   $0x25
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec2:	ff 4d 10             	decl   0x10(%ebp)
  800ec5:	eb 03                	jmp    800eca <vprintfmt+0x3b1>
  800ec7:	ff 4d 10             	decl   0x10(%ebp)
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	48                   	dec    %eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	3c 25                	cmp    $0x25,%al
  800ed2:	75 f3                	jne    800ec7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ed4:	90                   	nop
		}
	}
  800ed5:	e9 47 fc ff ff       	jmp    800b21 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800eda:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800edb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ee8:	8d 45 10             	lea    0x10(%ebp),%eax
  800eeb:	83 c0 04             	add    $0x4,%eax
  800eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef7:	50                   	push   %eax
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	ff 75 08             	pushl  0x8(%ebp)
  800efe:	e8 16 fc ff ff       	call   800b19 <vprintfmt>
  800f03:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f06:	90                   	nop
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	8b 40 08             	mov    0x8(%eax),%eax
  800f12:	8d 50 01             	lea    0x1(%eax),%edx
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8b 10                	mov    (%eax),%edx
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	8b 40 04             	mov    0x4(%eax),%eax
  800f26:	39 c2                	cmp    %eax,%edx
  800f28:	73 12                	jae    800f3c <sprintputch+0x33>
		*b->buf++ = ch;
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8b 00                	mov    (%eax),%eax
  800f2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f35:	89 0a                	mov    %ecx,(%edx)
  800f37:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3a:	88 10                	mov    %dl,(%eax)
}
  800f3c:	90                   	nop
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	01 d0                	add    %edx,%eax
  800f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f64:	74 06                	je     800f6c <vsnprintf+0x2d>
  800f66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6a:	7f 07                	jg     800f73 <vsnprintf+0x34>
		return -E_INVAL;
  800f6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800f71:	eb 20                	jmp    800f93 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f73:	ff 75 14             	pushl  0x14(%ebp)
  800f76:	ff 75 10             	pushl  0x10(%ebp)
  800f79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f7c:	50                   	push   %eax
  800f7d:	68 09 0f 80 00       	push   $0x800f09
  800f82:	e8 92 fb ff ff       	call   800b19 <vprintfmt>
  800f87:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f9e:	83 c0 04             	add    $0x4,%eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	ff 75 f4             	pushl  -0xc(%ebp)
  800faa:	50                   	push   %eax
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	ff 75 08             	pushl  0x8(%ebp)
  800fb1:	e8 89 ff ff ff       	call   800f3f <vsnprintf>
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fce:	eb 06                	jmp    800fd6 <strlen+0x15>
		n++;
  800fd0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 f1                	jne    800fd0 <strlen+0xf>
		n++;
	return n;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff1:	eb 09                	jmp    800ffc <strnlen+0x18>
		n++;
  800ff3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 4d 0c             	decl   0xc(%ebp)
  800ffc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801000:	74 09                	je     80100b <strnlen+0x27>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	84 c0                	test   %al,%al
  801009:	75 e8                	jne    800ff3 <strnlen+0xf>
		n++;
	return n;
  80100b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80101c:	90                   	nop
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8d 50 01             	lea    0x1(%eax),%edx
  801023:	89 55 08             	mov    %edx,0x8(%ebp)
  801026:	8b 55 0c             	mov    0xc(%ebp),%edx
  801029:	8d 4a 01             	lea    0x1(%edx),%ecx
  80102c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80102f:	8a 12                	mov    (%edx),%dl
  801031:	88 10                	mov    %dl,(%eax)
  801033:	8a 00                	mov    (%eax),%al
  801035:	84 c0                	test   %al,%al
  801037:	75 e4                	jne    80101d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801039:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801051:	eb 1f                	jmp    801072 <strncpy+0x34>
		*dst++ = *src;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8d 50 01             	lea    0x1(%eax),%edx
  801059:	89 55 08             	mov    %edx,0x8(%ebp)
  80105c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105f:	8a 12                	mov    (%edx),%dl
  801061:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 03                	je     80106f <strncpy+0x31>
			src++;
  80106c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80106f:	ff 45 fc             	incl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	3b 45 10             	cmp    0x10(%ebp),%eax
  801078:	72 d9                	jb     801053 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80108b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108f:	74 30                	je     8010c1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801091:	eb 16                	jmp    8010a9 <strlcpy+0x2a>
			*dst++ = *src++;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8d 50 01             	lea    0x1(%eax),%edx
  801099:	89 55 08             	mov    %edx,0x8(%ebp)
  80109c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010a5:	8a 12                	mov    (%edx),%dl
  8010a7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010a9:	ff 4d 10             	decl   0x10(%ebp)
  8010ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b0:	74 09                	je     8010bb <strlcpy+0x3c>
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 d8                	jne    801093 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010d0:	eb 06                	jmp    8010d8 <strcmp+0xb>
		p++, q++;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	84 c0                	test   %al,%al
  8010df:	74 0e                	je     8010ef <strcmp+0x22>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 10                	mov    (%eax),%dl
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	38 c2                	cmp    %al,%dl
  8010ed:	74 e3                	je     8010d2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	0f b6 d0             	movzbl %al,%edx
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 c0             	movzbl %al,%eax
  8010ff:	29 c2                	sub    %eax,%edx
  801101:	89 d0                	mov    %edx,%eax
}
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801108:	eb 09                	jmp    801113 <strncmp+0xe>
		n--, p++, q++;
  80110a:	ff 4d 10             	decl   0x10(%ebp)
  80110d:	ff 45 08             	incl   0x8(%ebp)
  801110:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801117:	74 17                	je     801130 <strncmp+0x2b>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	84 c0                	test   %al,%al
  801120:	74 0e                	je     801130 <strncmp+0x2b>
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 10                	mov    (%eax),%dl
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	38 c2                	cmp    %al,%dl
  80112e:	74 da                	je     80110a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801130:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801134:	75 07                	jne    80113d <strncmp+0x38>
		return 0;
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
  80113b:	eb 14                	jmp    801151 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	0f b6 d0             	movzbl %al,%edx
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 c0             	movzbl %al,%eax
  80114d:	29 c2                	sub    %eax,%edx
  80114f:	89 d0                	mov    %edx,%eax
}
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 04             	sub    $0x4,%esp
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80115f:	eb 12                	jmp    801173 <strchr+0x20>
		if (*s == c)
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801169:	75 05                	jne    801170 <strchr+0x1d>
			return (char *) s;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	eb 11                	jmp    801181 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801170:	ff 45 08             	incl   0x8(%ebp)
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	75 e5                	jne    801161 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80118f:	eb 0d                	jmp    80119e <strfind+0x1b>
		if (*s == c)
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801199:	74 0e                	je     8011a9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80119b:	ff 45 08             	incl   0x8(%ebp)
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	84 c0                	test   %al,%al
  8011a5:	75 ea                	jne    801191 <strfind+0xe>
  8011a7:	eb 01                	jmp    8011aa <strfind+0x27>
		if (*s == c)
			break;
  8011a9:	90                   	nop
	return (char *) s;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011c1:	eb 0e                	jmp    8011d1 <memset+0x22>
		*p++ = c;
  8011c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c6:	8d 50 01             	lea    0x1(%eax),%edx
  8011c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011d1:	ff 4d f8             	decl   -0x8(%ebp)
  8011d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8011d8:	79 e9                	jns    8011c3 <memset+0x14>
		*p++ = c;

	return v;
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8011f1:	eb 16                	jmp    801209 <memcpy+0x2a>
		*d++ = *s++;
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801202:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801205:	8a 12                	mov    (%edx),%dl
  801207:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120f:	89 55 10             	mov    %edx,0x10(%ebp)
  801212:	85 c0                	test   %eax,%eax
  801214:	75 dd                	jne    8011f3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80122d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801230:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801233:	73 50                	jae    801285 <memmove+0x6a>
  801235:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801240:	76 43                	jbe    801285 <memmove+0x6a>
		s += n;
  801242:	8b 45 10             	mov    0x10(%ebp),%eax
  801245:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80124e:	eb 10                	jmp    801260 <memmove+0x45>
			*--d = *--s;
  801250:	ff 4d f8             	decl   -0x8(%ebp)
  801253:	ff 4d fc             	decl   -0x4(%ebp)
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8a 10                	mov    (%eax),%dl
  80125b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	8d 50 ff             	lea    -0x1(%eax),%edx
  801266:	89 55 10             	mov    %edx,0x10(%ebp)
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 e3                	jne    801250 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80126d:	eb 23                	jmp    801292 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80126f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801272:	8d 50 01             	lea    0x1(%eax),%edx
  801275:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801278:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80127e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801281:	8a 12                	mov    (%edx),%dl
  801283:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128b:	89 55 10             	mov    %edx,0x10(%ebp)
  80128e:	85 c0                	test   %eax,%eax
  801290:	75 dd                	jne    80126f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012a9:	eb 2a                	jmp    8012d5 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ae:	8a 10                	mov    (%eax),%dl
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	38 c2                	cmp    %al,%dl
  8012b7:	74 16                	je     8012cf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f b6 d0             	movzbl %al,%edx
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f b6 c0             	movzbl %al,%eax
  8012c9:	29 c2                	sub    %eax,%edx
  8012cb:	89 d0                	mov    %edx,%eax
  8012cd:	eb 18                	jmp    8012e7 <memcmp+0x50>
		s1++, s2++;
  8012cf:	ff 45 fc             	incl   -0x4(%ebp)
  8012d2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 c9                	jne    8012ab <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	01 d0                	add    %edx,%eax
  8012f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012fa:	eb 15                	jmp    801311 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	0f b6 d0             	movzbl %al,%edx
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	0f b6 c0             	movzbl %al,%eax
  80130a:	39 c2                	cmp    %eax,%edx
  80130c:	74 0d                	je     80131b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80130e:	ff 45 08             	incl   0x8(%ebp)
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801317:	72 e3                	jb     8012fc <memfind+0x13>
  801319:	eb 01                	jmp    80131c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80131b:	90                   	nop
	return (void *) s;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801327:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80132e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801335:	eb 03                	jmp    80133a <strtol+0x19>
		s++;
  801337:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	3c 20                	cmp    $0x20,%al
  801341:	74 f4                	je     801337 <strtol+0x16>
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	3c 09                	cmp    $0x9,%al
  80134a:	74 eb                	je     801337 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	3c 2b                	cmp    $0x2b,%al
  801353:	75 05                	jne    80135a <strtol+0x39>
		s++;
  801355:	ff 45 08             	incl   0x8(%ebp)
  801358:	eb 13                	jmp    80136d <strtol+0x4c>
	else if (*s == '-')
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	3c 2d                	cmp    $0x2d,%al
  801361:	75 0a                	jne    80136d <strtol+0x4c>
		s++, neg = 1;
  801363:	ff 45 08             	incl   0x8(%ebp)
  801366:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80136d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801371:	74 06                	je     801379 <strtol+0x58>
  801373:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801377:	75 20                	jne    801399 <strtol+0x78>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	3c 30                	cmp    $0x30,%al
  801380:	75 17                	jne    801399 <strtol+0x78>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	40                   	inc    %eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	3c 78                	cmp    $0x78,%al
  80138a:	75 0d                	jne    801399 <strtol+0x78>
		s += 2, base = 16;
  80138c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801390:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801397:	eb 28                	jmp    8013c1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139d:	75 15                	jne    8013b4 <strtol+0x93>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	3c 30                	cmp    $0x30,%al
  8013a6:	75 0c                	jne    8013b4 <strtol+0x93>
		s++, base = 8;
  8013a8:	ff 45 08             	incl   0x8(%ebp)
  8013ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013b2:	eb 0d                	jmp    8013c1 <strtol+0xa0>
	else if (base == 0)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	75 07                	jne    8013c1 <strtol+0xa0>
		base = 10;
  8013ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	3c 2f                	cmp    $0x2f,%al
  8013c8:	7e 19                	jle    8013e3 <strtol+0xc2>
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	3c 39                	cmp    $0x39,%al
  8013d1:	7f 10                	jg     8013e3 <strtol+0xc2>
			dig = *s - '0';
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	0f be c0             	movsbl %al,%eax
  8013db:	83 e8 30             	sub    $0x30,%eax
  8013de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013e1:	eb 42                	jmp    801425 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 60                	cmp    $0x60,%al
  8013ea:	7e 19                	jle    801405 <strtol+0xe4>
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	3c 7a                	cmp    $0x7a,%al
  8013f3:	7f 10                	jg     801405 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	0f be c0             	movsbl %al,%eax
  8013fd:	83 e8 57             	sub    $0x57,%eax
  801400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801403:	eb 20                	jmp    801425 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 40                	cmp    $0x40,%al
  80140c:	7e 39                	jle    801447 <strtol+0x126>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 5a                	cmp    $0x5a,%al
  801415:	7f 30                	jg     801447 <strtol+0x126>
			dig = *s - 'A' + 10;
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 37             	sub    $0x37,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801428:	3b 45 10             	cmp    0x10(%ebp),%eax
  80142b:	7d 19                	jge    801446 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80142d:	ff 45 08             	incl   0x8(%ebp)
  801430:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801433:	0f af 45 10          	imul   0x10(%ebp),%eax
  801437:	89 c2                	mov    %eax,%edx
  801439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143c:	01 d0                	add    %edx,%eax
  80143e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801441:	e9 7b ff ff ff       	jmp    8013c1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801446:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801447:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80144b:	74 08                	je     801455 <strtol+0x134>
		*endptr = (char *) s;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	8b 55 08             	mov    0x8(%ebp),%edx
  801453:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801455:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801459:	74 07                	je     801462 <strtol+0x141>
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	f7 d8                	neg    %eax
  801460:	eb 03                	jmp    801465 <strtol+0x144>
  801462:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <ltostr>:

void
ltostr(long value, char *str)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80146d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801474:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80147b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80147f:	79 13                	jns    801494 <ltostr+0x2d>
	{
		neg = 1;
  801481:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80148e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801491:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80149c:	99                   	cltd   
  80149d:	f7 f9                	idiv   %ecx
  80149f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a5:	8d 50 01             	lea    0x1(%eax),%edx
  8014a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ab:	89 c2                	mov    %eax,%edx
  8014ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b0:	01 d0                	add    %edx,%eax
  8014b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014b5:	83 c2 30             	add    $0x30,%edx
  8014b8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014bd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014c2:	f7 e9                	imul   %ecx
  8014c4:	c1 fa 02             	sar    $0x2,%edx
  8014c7:	89 c8                	mov    %ecx,%eax
  8014c9:	c1 f8 1f             	sar    $0x1f,%eax
  8014cc:	29 c2                	sub    %eax,%edx
  8014ce:	89 d0                	mov    %edx,%eax
  8014d0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014db:	f7 e9                	imul   %ecx
  8014dd:	c1 fa 02             	sar    $0x2,%edx
  8014e0:	89 c8                	mov    %ecx,%eax
  8014e2:	c1 f8 1f             	sar    $0x1f,%eax
  8014e5:	29 c2                	sub    %eax,%edx
  8014e7:	89 d0                	mov    %edx,%eax
  8014e9:	c1 e0 02             	shl    $0x2,%eax
  8014ec:	01 d0                	add    %edx,%eax
  8014ee:	01 c0                	add    %eax,%eax
  8014f0:	29 c1                	sub    %eax,%ecx
  8014f2:	89 ca                	mov    %ecx,%edx
  8014f4:	85 d2                	test   %edx,%edx
  8014f6:	75 9c                	jne    801494 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	48                   	dec    %eax
  801503:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801506:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80150a:	74 3d                	je     801549 <ltostr+0xe2>
		start = 1 ;
  80150c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801513:	eb 34                	jmp    801549 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151b:	01 d0                	add    %edx,%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	01 c2                	add    %eax,%edx
  80152a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	01 c8                	add    %ecx,%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801536:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	01 c2                	add    %eax,%edx
  80153e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801541:	88 02                	mov    %al,(%edx)
		start++ ;
  801543:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801546:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80154f:	7c c4                	jl     801515 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801551:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	01 d0                	add    %edx,%eax
  801559:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80155c:	90                   	nop
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	e8 54 fa ff ff       	call   800fc1 <strlen>
  80156d:	83 c4 04             	add    $0x4,%esp
  801570:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	e8 46 fa ff ff       	call   800fc1 <strlen>
  80157b:	83 c4 04             	add    $0x4,%esp
  80157e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801588:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80158f:	eb 17                	jmp    8015a8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801591:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801594:	8b 45 10             	mov    0x10(%ebp),%eax
  801597:	01 c2                	add    %eax,%edx
  801599:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	01 c8                	add    %ecx,%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015a5:	ff 45 fc             	incl   -0x4(%ebp)
  8015a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015ae:	7c e1                	jl     801591 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015be:	eb 1f                	jmp    8015df <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c3:	8d 50 01             	lea    0x1(%eax),%edx
  8015c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015c9:	89 c2                	mov    %eax,%edx
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ce:	01 c2                	add    %eax,%edx
  8015d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	01 c8                	add    %ecx,%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015dc:	ff 45 f8             	incl   -0x8(%ebp)
  8015df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e5:	7c d9                	jl     8015c0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 d0                	add    %edx,%eax
  8015ef:	c6 00 00             	movb   $0x0,(%eax)
}
  8015f2:	90                   	nop
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801601:	8b 45 14             	mov    0x14(%ebp),%eax
  801604:	8b 00                	mov    (%eax),%eax
  801606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801618:	eb 0c                	jmp    801626 <strsplit+0x31>
			*string++ = 0;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8d 50 01             	lea    0x1(%eax),%edx
  801620:	89 55 08             	mov    %edx,0x8(%ebp)
  801623:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	84 c0                	test   %al,%al
  80162d:	74 18                	je     801647 <strsplit+0x52>
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	0f be c0             	movsbl %al,%eax
  801637:	50                   	push   %eax
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	e8 13 fb ff ff       	call   801153 <strchr>
  801640:	83 c4 08             	add    $0x8,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	75 d3                	jne    80161a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	84 c0                	test   %al,%al
  80164e:	74 5a                	je     8016aa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801650:	8b 45 14             	mov    0x14(%ebp),%eax
  801653:	8b 00                	mov    (%eax),%eax
  801655:	83 f8 0f             	cmp    $0xf,%eax
  801658:	75 07                	jne    801661 <strsplit+0x6c>
		{
			return 0;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	eb 66                	jmp    8016c7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801661:	8b 45 14             	mov    0x14(%ebp),%eax
  801664:	8b 00                	mov    (%eax),%eax
  801666:	8d 48 01             	lea    0x1(%eax),%ecx
  801669:	8b 55 14             	mov    0x14(%ebp),%edx
  80166c:	89 0a                	mov    %ecx,(%edx)
  80166e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801675:	8b 45 10             	mov    0x10(%ebp),%eax
  801678:	01 c2                	add    %eax,%edx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80167f:	eb 03                	jmp    801684 <strsplit+0x8f>
			string++;
  801681:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	84 c0                	test   %al,%al
  80168b:	74 8b                	je     801618 <strsplit+0x23>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	0f be c0             	movsbl %al,%eax
  801695:	50                   	push   %eax
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	e8 b5 fa ff ff       	call   801153 <strchr>
  80169e:	83 c4 08             	add    $0x8,%esp
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	74 dc                	je     801681 <strsplit+0x8c>
			string++;
	}
  8016a5:	e9 6e ff ff ff       	jmp    801618 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016aa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ae:	8b 00                	mov    (%eax),%eax
  8016b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	01 d0                	add    %edx,%eax
  8016bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8016cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016d6:	eb 4c                	jmp    801724 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8016d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	3c 40                	cmp    $0x40,%al
  8016e4:	7e 27                	jle    80170d <str2lower+0x44>
  8016e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ec:	01 d0                	add    %edx,%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	3c 5a                	cmp    $0x5a,%al
  8016f2:	7f 19                	jg     80170d <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	01 d0                	add    %edx,%eax
  8016fc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	01 ca                	add    %ecx,%edx
  801704:	8a 12                	mov    (%edx),%dl
  801706:	83 c2 20             	add    $0x20,%edx
  801709:	88 10                	mov    %dl,(%eax)
  80170b:	eb 14                	jmp    801721 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80170d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	01 c2                	add    %eax,%edx
  801715:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171b:	01 c8                	add    %ecx,%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	e8 95 f8 ff ff       	call   800fc1 <strlen>
  80172c:	83 c4 04             	add    $0x4,%esp
  80172f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801732:	7f a4                	jg     8016d8 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	57                   	push   %edi
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801750:	8b 7d 18             	mov    0x18(%ebp),%edi
  801753:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801756:	cd 30                	int    $0x30
  801758:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5f                   	pop    %edi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	8b 45 10             	mov    0x10(%ebp),%eax
  80176f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801772:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	52                   	push   %edx
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	50                   	push   %eax
  801782:	6a 00                	push   $0x0
  801784:	e8 b2 ff ff ff       	call   80173b <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	90                   	nop
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_cgetc>:

int
sys_cgetc(void)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 01                	push   $0x1
  80179e:	e8 98 ff ff ff       	call   80173b <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 05                	push   $0x5
  8017bb:	e8 7b ff ff ff       	call   80173b <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	56                   	push   %esi
  8017c9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ca:	8b 75 18             	mov    0x18(%ebp),%esi
  8017cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	51                   	push   %ecx
  8017dc:	52                   	push   %edx
  8017dd:	50                   	push   %eax
  8017de:	6a 06                	push   $0x6
  8017e0:	e8 56 ff ff ff       	call   80173b <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017eb:	5b                   	pop    %ebx
  8017ec:	5e                   	pop    %esi
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	52                   	push   %edx
  8017ff:	50                   	push   %eax
  801800:	6a 07                	push   $0x7
  801802:	e8 34 ff ff ff       	call   80173b <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	6a 08                	push   $0x8
  80181d:	e8 19 ff ff ff       	call   80173b <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 09                	push   $0x9
  801836:	e8 00 ff ff ff       	call   80173b <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 0a                	push   $0xa
  80184f:	e8 e7 fe ff ff       	call   80173b <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 0b                	push   $0xb
  801868:	e8 ce fe ff ff       	call   80173b <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 0c                	push   $0xc
  801881:	e8 b5 fe ff ff       	call   80173b <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	ff 75 08             	pushl  0x8(%ebp)
  801899:	6a 0d                	push   $0xd
  80189b:	e8 9b fe ff ff       	call   80173b <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 0e                	push   $0xe
  8018b4:	e8 82 fe ff ff       	call   80173b <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 11                	push   $0x11
  8018ce:	e8 68 fe ff ff       	call   80173b <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	90                   	nop
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 12                	push   $0x12
  8018e8:	e8 4e fe ff ff       	call   80173b <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 04             	sub    $0x4,%esp
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	50                   	push   %eax
  80190c:	6a 13                	push   $0x13
  80190e:	e8 28 fe ff ff       	call   80173b <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 14                	push   $0x14
  801928:	e8 0e fe ff ff       	call   80173b <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	90                   	nop
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	50                   	push   %eax
  801943:	6a 15                	push   $0x15
  801945:	e8 f1 fd ff ff       	call   80173b <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	6a 18                	push   $0x18
  801962:	e8 d4 fd ff ff       	call   80173b <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 16                	push   $0x16
  80197f:	e8 b7 fd ff ff       	call   80173b <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80198d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 17                	push   $0x17
  80199d:	e8 99 fd ff ff       	call   80173b <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	51                   	push   %ecx
  8019c1:	52                   	push   %edx
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	6a 19                	push   $0x19
  8019c8:	e8 6e fd ff ff       	call   80173b <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 1a                	push   $0x1a
  8019e5:	e8 51 fd ff ff       	call   80173b <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	51                   	push   %ecx
  801a00:	52                   	push   %edx
  801a01:	50                   	push   %eax
  801a02:	6a 1b                	push   $0x1b
  801a04:	e8 32 fd ff ff       	call   80173b <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 1c                	push   $0x1c
  801a21:	e8 15 fd ff ff       	call   80173b <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 1d                	push   $0x1d
  801a3a:	e8 fc fc ff ff       	call   80173b <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 14             	pushl  0x14(%ebp)
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	50                   	push   %eax
  801a56:	6a 1e                	push   $0x1e
  801a58:	e8 de fc ff ff       	call   80173b <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	50                   	push   %eax
  801a71:	6a 1f                	push   $0x1f
  801a73:	e8 c3 fc ff ff       	call   80173b <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	50                   	push   %eax
  801a8d:	6a 20                	push   $0x20
  801a8f:	e8 a7 fc ff ff       	call   80173b <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 02                	push   $0x2
  801aa8:	e8 8e fc ff ff       	call   80173b <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 03                	push   $0x3
  801ac1:	e8 75 fc ff ff       	call   80173b <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 04                	push   $0x4
  801ada:	e8 5c fc ff ff       	call   80173b <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 21                	push   $0x21
  801af3:	e8 43 fc ff ff       	call   80173b <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	90                   	nop
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b07:	8d 50 04             	lea    0x4(%eax),%edx
  801b0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 22                	push   $0x22
  801b17:	e8 1f fc ff ff       	call   80173b <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b28:	89 01                	mov    %eax,(%ecx)
  801b2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	c9                   	leave  
  801b31:	c2 04 00             	ret    $0x4

00801b34 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 10             	pushl  0x10(%ebp)
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	6a 10                	push   $0x10
  801b46:	e8 f0 fb ff ff       	call   80173b <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 23                	push   $0x23
  801b60:	e8 d6 fb ff ff       	call   80173b <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	50                   	push   %eax
  801b83:	6a 24                	push   $0x24
  801b85:	e8 b1 fb ff ff       	call   80173b <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8d:	90                   	nop
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <rsttst>:
void rsttst()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 26                	push   $0x26
  801b9f:	e8 97 fb ff ff       	call   80173b <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bb6:	8b 55 18             	mov    0x18(%ebp),%edx
  801bb9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	ff 75 10             	pushl  0x10(%ebp)
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	6a 25                	push   $0x25
  801bca:	e8 6c fb ff ff       	call   80173b <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <chktst>:
void chktst(uint32 n)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	6a 27                	push   $0x27
  801be5:	e8 51 fb ff ff       	call   80173b <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <inctst>:

void inctst()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 28                	push   $0x28
  801bff:	e8 37 fb ff ff       	call   80173b <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
	return ;
  801c07:	90                   	nop
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <gettst>:
uint32 gettst()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 29                	push   $0x29
  801c19:	e8 1d fb ff ff       	call   80173b <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 2a                	push   $0x2a
  801c35:	e8 01 fb ff ff       	call   80173b <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
  801c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c40:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c44:	75 07                	jne    801c4d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	eb 05                	jmp    801c52 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 2a                	push   $0x2a
  801c66:	e8 d0 fa ff ff       	call   80173b <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
  801c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c71:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c75:	75 07                	jne    801c7e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c77:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7c:	eb 05                	jmp    801c83 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 2a                	push   $0x2a
  801c97:	e8 9f fa ff ff       	call   80173b <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
  801c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ca2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ca6:	75 07                	jne    801caf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ca8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cad:	eb 05                	jmp    801cb4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 2a                	push   $0x2a
  801cc8:	e8 6e fa ff ff       	call   80173b <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
  801cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cd3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cd7:	75 07                	jne    801ce0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	eb 05                	jmp    801ce5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	6a 2b                	push   $0x2b
  801cf7:	e8 3f fa ff ff       	call   80173b <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	53                   	push   %ebx
  801d15:	51                   	push   %ecx
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	6a 2c                	push   $0x2c
  801d1a:	e8 1c fa ff ff       	call   80173b <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 2d                	push   $0x2d
  801d3a:	e8 fc f9 ff ff       	call   80173b <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	51                   	push   %ecx
  801d53:	ff 75 10             	pushl  0x10(%ebp)
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 2e                	push   $0x2e
  801d5a:	e8 dc f9 ff ff       	call   80173b <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 10             	pushl  0x10(%ebp)
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	ff 75 08             	pushl  0x8(%ebp)
  801d74:	6a 0f                	push   $0xf
  801d76:	e8 c0 f9 ff ff       	call   80173b <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7e:	90                   	nop
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	50                   	push   %eax
  801d90:	6a 2f                	push   $0x2f
  801d92:	e8 a4 f9 ff ff       	call   80173b <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp

}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 30                	push   $0x30
  801dad:	e8 89 f9 ff ff       	call   80173b <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return;
  801db5:	90                   	nop
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	6a 31                	push   $0x31
  801dc9:	e8 6d f9 ff ff       	call   80173b <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
	return;
  801dd1:	90                   	nop
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 32                	push   $0x32
  801de3:	e8 53 f9 ff ff       	call   80173b <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	50                   	push   %eax
  801dfc:	6a 33                	push   $0x33
  801dfe:	e8 38 f9 ff ff       	call   80173b <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	90                   	nop
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    
  801e09:	66 90                	xchg   %ax,%ax
  801e0b:	90                   	nop

00801e0c <__udivdi3>:
  801e0c:	55                   	push   %ebp
  801e0d:	57                   	push   %edi
  801e0e:	56                   	push   %esi
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 1c             	sub    $0x1c,%esp
  801e13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e23:	89 ca                	mov    %ecx,%edx
  801e25:	89 f8                	mov    %edi,%eax
  801e27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e2b:	85 f6                	test   %esi,%esi
  801e2d:	75 2d                	jne    801e5c <__udivdi3+0x50>
  801e2f:	39 cf                	cmp    %ecx,%edi
  801e31:	77 65                	ja     801e98 <__udivdi3+0x8c>
  801e33:	89 fd                	mov    %edi,%ebp
  801e35:	85 ff                	test   %edi,%edi
  801e37:	75 0b                	jne    801e44 <__udivdi3+0x38>
  801e39:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3e:	31 d2                	xor    %edx,%edx
  801e40:	f7 f7                	div    %edi
  801e42:	89 c5                	mov    %eax,%ebp
  801e44:	31 d2                	xor    %edx,%edx
  801e46:	89 c8                	mov    %ecx,%eax
  801e48:	f7 f5                	div    %ebp
  801e4a:	89 c1                	mov    %eax,%ecx
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	f7 f5                	div    %ebp
  801e50:	89 cf                	mov    %ecx,%edi
  801e52:	89 fa                	mov    %edi,%edx
  801e54:	83 c4 1c             	add    $0x1c,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    
  801e5c:	39 ce                	cmp    %ecx,%esi
  801e5e:	77 28                	ja     801e88 <__udivdi3+0x7c>
  801e60:	0f bd fe             	bsr    %esi,%edi
  801e63:	83 f7 1f             	xor    $0x1f,%edi
  801e66:	75 40                	jne    801ea8 <__udivdi3+0x9c>
  801e68:	39 ce                	cmp    %ecx,%esi
  801e6a:	72 0a                	jb     801e76 <__udivdi3+0x6a>
  801e6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e70:	0f 87 9e 00 00 00    	ja     801f14 <__udivdi3+0x108>
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	89 fa                	mov    %edi,%edx
  801e7d:	83 c4 1c             	add    $0x1c,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    
  801e85:	8d 76 00             	lea    0x0(%esi),%esi
  801e88:	31 ff                	xor    %edi,%edi
  801e8a:	31 c0                	xor    %eax,%eax
  801e8c:	89 fa                	mov    %edi,%edx
  801e8e:	83 c4 1c             	add    $0x1c,%esp
  801e91:	5b                   	pop    %ebx
  801e92:	5e                   	pop    %esi
  801e93:	5f                   	pop    %edi
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    
  801e96:	66 90                	xchg   %ax,%ax
  801e98:	89 d8                	mov    %ebx,%eax
  801e9a:	f7 f7                	div    %edi
  801e9c:	31 ff                	xor    %edi,%edi
  801e9e:	89 fa                	mov    %edi,%edx
  801ea0:	83 c4 1c             	add    $0x1c,%esp
  801ea3:	5b                   	pop    %ebx
  801ea4:	5e                   	pop    %esi
  801ea5:	5f                   	pop    %edi
  801ea6:	5d                   	pop    %ebp
  801ea7:	c3                   	ret    
  801ea8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ead:	89 eb                	mov    %ebp,%ebx
  801eaf:	29 fb                	sub    %edi,%ebx
  801eb1:	89 f9                	mov    %edi,%ecx
  801eb3:	d3 e6                	shl    %cl,%esi
  801eb5:	89 c5                	mov    %eax,%ebp
  801eb7:	88 d9                	mov    %bl,%cl
  801eb9:	d3 ed                	shr    %cl,%ebp
  801ebb:	89 e9                	mov    %ebp,%ecx
  801ebd:	09 f1                	or     %esi,%ecx
  801ebf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ec3:	89 f9                	mov    %edi,%ecx
  801ec5:	d3 e0                	shl    %cl,%eax
  801ec7:	89 c5                	mov    %eax,%ebp
  801ec9:	89 d6                	mov    %edx,%esi
  801ecb:	88 d9                	mov    %bl,%cl
  801ecd:	d3 ee                	shr    %cl,%esi
  801ecf:	89 f9                	mov    %edi,%ecx
  801ed1:	d3 e2                	shl    %cl,%edx
  801ed3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ed7:	88 d9                	mov    %bl,%cl
  801ed9:	d3 e8                	shr    %cl,%eax
  801edb:	09 c2                	or     %eax,%edx
  801edd:	89 d0                	mov    %edx,%eax
  801edf:	89 f2                	mov    %esi,%edx
  801ee1:	f7 74 24 0c          	divl   0xc(%esp)
  801ee5:	89 d6                	mov    %edx,%esi
  801ee7:	89 c3                	mov    %eax,%ebx
  801ee9:	f7 e5                	mul    %ebp
  801eeb:	39 d6                	cmp    %edx,%esi
  801eed:	72 19                	jb     801f08 <__udivdi3+0xfc>
  801eef:	74 0b                	je     801efc <__udivdi3+0xf0>
  801ef1:	89 d8                	mov    %ebx,%eax
  801ef3:	31 ff                	xor    %edi,%edi
  801ef5:	e9 58 ff ff ff       	jmp    801e52 <__udivdi3+0x46>
  801efa:	66 90                	xchg   %ax,%ax
  801efc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f00:	89 f9                	mov    %edi,%ecx
  801f02:	d3 e2                	shl    %cl,%edx
  801f04:	39 c2                	cmp    %eax,%edx
  801f06:	73 e9                	jae    801ef1 <__udivdi3+0xe5>
  801f08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f0b:	31 ff                	xor    %edi,%edi
  801f0d:	e9 40 ff ff ff       	jmp    801e52 <__udivdi3+0x46>
  801f12:	66 90                	xchg   %ax,%ax
  801f14:	31 c0                	xor    %eax,%eax
  801f16:	e9 37 ff ff ff       	jmp    801e52 <__udivdi3+0x46>
  801f1b:	90                   	nop

00801f1c <__umoddi3>:
  801f1c:	55                   	push   %ebp
  801f1d:	57                   	push   %edi
  801f1e:	56                   	push   %esi
  801f1f:	53                   	push   %ebx
  801f20:	83 ec 1c             	sub    $0x1c,%esp
  801f23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f3b:	89 f3                	mov    %esi,%ebx
  801f3d:	89 fa                	mov    %edi,%edx
  801f3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f43:	89 34 24             	mov    %esi,(%esp)
  801f46:	85 c0                	test   %eax,%eax
  801f48:	75 1a                	jne    801f64 <__umoddi3+0x48>
  801f4a:	39 f7                	cmp    %esi,%edi
  801f4c:	0f 86 a2 00 00 00    	jbe    801ff4 <__umoddi3+0xd8>
  801f52:	89 c8                	mov    %ecx,%eax
  801f54:	89 f2                	mov    %esi,%edx
  801f56:	f7 f7                	div    %edi
  801f58:	89 d0                	mov    %edx,%eax
  801f5a:	31 d2                	xor    %edx,%edx
  801f5c:	83 c4 1c             	add    $0x1c,%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5f                   	pop    %edi
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    
  801f64:	39 f0                	cmp    %esi,%eax
  801f66:	0f 87 ac 00 00 00    	ja     802018 <__umoddi3+0xfc>
  801f6c:	0f bd e8             	bsr    %eax,%ebp
  801f6f:	83 f5 1f             	xor    $0x1f,%ebp
  801f72:	0f 84 ac 00 00 00    	je     802024 <__umoddi3+0x108>
  801f78:	bf 20 00 00 00       	mov    $0x20,%edi
  801f7d:	29 ef                	sub    %ebp,%edi
  801f7f:	89 fe                	mov    %edi,%esi
  801f81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f85:	89 e9                	mov    %ebp,%ecx
  801f87:	d3 e0                	shl    %cl,%eax
  801f89:	89 d7                	mov    %edx,%edi
  801f8b:	89 f1                	mov    %esi,%ecx
  801f8d:	d3 ef                	shr    %cl,%edi
  801f8f:	09 c7                	or     %eax,%edi
  801f91:	89 e9                	mov    %ebp,%ecx
  801f93:	d3 e2                	shl    %cl,%edx
  801f95:	89 14 24             	mov    %edx,(%esp)
  801f98:	89 d8                	mov    %ebx,%eax
  801f9a:	d3 e0                	shl    %cl,%eax
  801f9c:	89 c2                	mov    %eax,%edx
  801f9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fa2:	d3 e0                	shl    %cl,%eax
  801fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fac:	89 f1                	mov    %esi,%ecx
  801fae:	d3 e8                	shr    %cl,%eax
  801fb0:	09 d0                	or     %edx,%eax
  801fb2:	d3 eb                	shr    %cl,%ebx
  801fb4:	89 da                	mov    %ebx,%edx
  801fb6:	f7 f7                	div    %edi
  801fb8:	89 d3                	mov    %edx,%ebx
  801fba:	f7 24 24             	mull   (%esp)
  801fbd:	89 c6                	mov    %eax,%esi
  801fbf:	89 d1                	mov    %edx,%ecx
  801fc1:	39 d3                	cmp    %edx,%ebx
  801fc3:	0f 82 87 00 00 00    	jb     802050 <__umoddi3+0x134>
  801fc9:	0f 84 91 00 00 00    	je     802060 <__umoddi3+0x144>
  801fcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fd3:	29 f2                	sub    %esi,%edx
  801fd5:	19 cb                	sbb    %ecx,%ebx
  801fd7:	89 d8                	mov    %ebx,%eax
  801fd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fdd:	d3 e0                	shl    %cl,%eax
  801fdf:	89 e9                	mov    %ebp,%ecx
  801fe1:	d3 ea                	shr    %cl,%edx
  801fe3:	09 d0                	or     %edx,%eax
  801fe5:	89 e9                	mov    %ebp,%ecx
  801fe7:	d3 eb                	shr    %cl,%ebx
  801fe9:	89 da                	mov    %ebx,%edx
  801feb:	83 c4 1c             	add    $0x1c,%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5e                   	pop    %esi
  801ff0:	5f                   	pop    %edi
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    
  801ff3:	90                   	nop
  801ff4:	89 fd                	mov    %edi,%ebp
  801ff6:	85 ff                	test   %edi,%edi
  801ff8:	75 0b                	jne    802005 <__umoddi3+0xe9>
  801ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  801fff:	31 d2                	xor    %edx,%edx
  802001:	f7 f7                	div    %edi
  802003:	89 c5                	mov    %eax,%ebp
  802005:	89 f0                	mov    %esi,%eax
  802007:	31 d2                	xor    %edx,%edx
  802009:	f7 f5                	div    %ebp
  80200b:	89 c8                	mov    %ecx,%eax
  80200d:	f7 f5                	div    %ebp
  80200f:	89 d0                	mov    %edx,%eax
  802011:	e9 44 ff ff ff       	jmp    801f5a <__umoddi3+0x3e>
  802016:	66 90                	xchg   %ax,%ax
  802018:	89 c8                	mov    %ecx,%eax
  80201a:	89 f2                	mov    %esi,%edx
  80201c:	83 c4 1c             	add    $0x1c,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    
  802024:	3b 04 24             	cmp    (%esp),%eax
  802027:	72 06                	jb     80202f <__umoddi3+0x113>
  802029:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80202d:	77 0f                	ja     80203e <__umoddi3+0x122>
  80202f:	89 f2                	mov    %esi,%edx
  802031:	29 f9                	sub    %edi,%ecx
  802033:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802037:	89 14 24             	mov    %edx,(%esp)
  80203a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80203e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802042:	8b 14 24             	mov    (%esp),%edx
  802045:	83 c4 1c             	add    $0x1c,%esp
  802048:	5b                   	pop    %ebx
  802049:	5e                   	pop    %esi
  80204a:	5f                   	pop    %edi
  80204b:	5d                   	pop    %ebp
  80204c:	c3                   	ret    
  80204d:	8d 76 00             	lea    0x0(%esi),%esi
  802050:	2b 04 24             	sub    (%esp),%eax
  802053:	19 fa                	sbb    %edi,%edx
  802055:	89 d1                	mov    %edx,%ecx
  802057:	89 c6                	mov    %eax,%esi
  802059:	e9 71 ff ff ff       	jmp    801fcf <__umoddi3+0xb3>
  80205e:	66 90                	xchg   %ax,%ax
  802060:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802064:	72 ea                	jb     802050 <__umoddi3+0x134>
  802066:	89 d9                	mov    %ebx,%ecx
  802068:	e9 62 ff ff ff       	jmp    801fcf <__umoddi3+0xb3>
