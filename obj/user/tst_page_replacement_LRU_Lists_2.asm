
obj/user/tst_page_replacement_LRU_Lists_2:     file format elf32-i386


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
  800031:	e8 7f 02 00 00       	call   8002b5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char* ptr2 = (char* )0x0804000 ;
uint32 actual_active_list_init[6] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x204000, 0x203000};
uint32 actual_second_list_init[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	//	cprintf("envID = %d\n",envID);
	int x = 0;
  80003e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

	//("STEP 0: checking Initial WS entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list_init, actual_second_list_init, 6, 5);
  800045:	6a 05                	push   $0x5
  800047:	6a 06                	push   $0x6
  800049:	68 20 30 80 00       	push   $0x803020
  80004e:	68 08 30 80 00       	push   $0x803008
  800053:	e8 0b 1a 00 00       	call   801a63 <sys_check_LRU_lists>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(check == 0)
  80005e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800062:	75 14                	jne    800078 <_main+0x40>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 c0 1d 80 00       	push   $0x801dc0
  80006c:	6a 18                	push   $0x18
  80006e:	68 44 1e 80 00       	push   $0x801e44
  800073:	e8 6b 03 00 00       	call   8003e3 <_panic>
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  800078:	a0 5f e0 80 00       	mov    0x80e05f,%al
  80007d:	88 45 e7             	mov    %al,-0x19(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800080:	a0 5f f0 80 00       	mov    0x80f05f,%al
  800085:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800088:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80008f:	eb 4a                	jmp    8000db <_main+0xa3>
	{
		arr[i] = -1 ;
  800091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800094:	05 60 30 80 00       	add    $0x803060,%eax
  800099:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr + garbage5;
  80009c:	a1 00 30 80 00       	mov    0x803000,%eax
  8000a1:	8a 00                	mov    (%eax),%al
  8000a3:	88 c2                	mov    %al,%dl
  8000a5:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000a8:	01 d0                	add    %edx,%eax
  8000aa:	88 45 e5             	mov    %al,-0x1b(%ebp)
		garbage5 = *ptr2 + garbage4;
  8000ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b2:	8a 00                	mov    (%eax),%al
  8000b4:	88 c2                	mov    %al,%dl
  8000b6:	8a 45 e5             	mov    -0x1b(%ebp),%al
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	88 45 f7             	mov    %al,-0x9(%ebp)
		ptr++ ; ptr2++ ;
  8000be:	a1 00 30 80 00       	mov    0x803000,%eax
  8000c3:	40                   	inc    %eax
  8000c4:	a3 00 30 80 00       	mov    %eax,0x803000
  8000c9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ce:	40                   	inc    %eax
  8000cf:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000d4:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000db:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000e2:	7e ad                	jle    800091 <_main+0x59>

	//("STEP 1: checking LRU LISTS after new page FAULTS...\n");
	//uint32 actual_active_list[6] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x804000, 0x80c000};
	uint32 actual_active_list[6] ;
	{
		actual_active_list[0] = 0x803000;
  8000e4:	c7 45 bc 00 30 80 00 	movl   $0x803000,-0x44(%ebp)
		actual_active_list[1] = 0x801000;
  8000eb:	c7 45 c0 00 10 80 00 	movl   $0x801000,-0x40(%ebp)
		actual_active_list[2] = 0x800000;
  8000f2:	c7 45 c4 00 00 80 00 	movl   $0x800000,-0x3c(%ebp)
		actual_active_list[3] = 0xeebfd000;
  8000f9:	c7 45 c8 00 d0 bf ee 	movl   $0xeebfd000,-0x38(%ebp)
		actual_active_list[4] = 0x804000;
  800100:	c7 45 cc 00 40 80 00 	movl   $0x804000,-0x34(%ebp)
		actual_active_list[5] = 0x80c000;
  800107:	c7 45 d0 00 c0 80 00 	movl   $0x80c000,-0x30(%ebp)
	}
	//uint32 actual_second_list[5] = {0x80b000, 0x80a000, 0x809000, 0x808000, 0x807000};
	uint32 actual_second_list[5] ;
	{
		actual_second_list[0] = 0x80b000 ;
  80010e:	c7 45 a8 00 b0 80 00 	movl   $0x80b000,-0x58(%ebp)
		actual_second_list[1] = 0x80a000 ;
  800115:	c7 45 ac 00 a0 80 00 	movl   $0x80a000,-0x54(%ebp)
		actual_second_list[2] = 0x809000 ;
  80011c:	c7 45 b0 00 90 80 00 	movl   $0x809000,-0x50(%ebp)
		actual_second_list[3] = 0x808000 ;
  800123:	c7 45 b4 00 80 80 00 	movl   $0x808000,-0x4c(%ebp)
		actual_second_list[4] = 0x807000 ;
  80012a:	c7 45 b8 00 70 80 00 	movl   $0x807000,-0x48(%ebp)
	}
	int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  800131:	6a 05                	push   $0x5
  800133:	6a 06                	push   $0x6
  800135:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800138:	50                   	push   %eax
  800139:	8d 45 bc             	lea    -0x44(%ebp),%eax
  80013c:	50                   	push   %eax
  80013d:	e8 21 19 00 00       	call   801a63 <sys_check_LRU_lists>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(check == 0)
  800148:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80014c:	75 14                	jne    800162 <_main+0x12a>
		panic("PAGE LRU Lists entry checking failed when new PAGE FAULTs occurred..!!");
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 6c 1e 80 00       	push   $0x801e6c
  800156:	6a 46                	push   $0x46
  800158:	68 44 1e 80 00       	push   $0x801e44
  80015d:	e8 81 02 00 00       	call   8003e3 <_panic>


	//("STEP 2: Checking PAGE LRU LIST algorithm after faults due to ACCESS in the second chance list... \n");
	{
		uint32* secondlistVA = (uint32*)0x809000;
  800162:	c7 45 dc 00 90 80 00 	movl   $0x809000,-0x24(%ebp)
		x = x + *secondlistVA;
  800169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016c:	8b 10                	mov    (%eax),%edx
  80016e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800171:	01 d0                	add    %edx,%eax
  800173:	89 45 ec             	mov    %eax,-0x14(%ebp)
		secondlistVA = (uint32*)0x807000;
  800176:	c7 45 dc 00 70 80 00 	movl   $0x807000,-0x24(%ebp)
		x = x + *secondlistVA;
  80017d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800180:	8b 10                	mov    (%eax),%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	89 45 ec             	mov    %eax,-0x14(%ebp)
		secondlistVA = (uint32*)0x804000;
  80018a:	c7 45 dc 00 40 80 00 	movl   $0x804000,-0x24(%ebp)
		x = x + *secondlistVA;
  800191:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800194:	8b 10                	mov    (%eax),%edx
  800196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		actual_active_list[0] = 0x801000;
  80019e:	c7 45 bc 00 10 80 00 	movl   $0x801000,-0x44(%ebp)
		actual_active_list[1] = 0x800000;
  8001a5:	c7 45 c0 00 00 80 00 	movl   $0x800000,-0x40(%ebp)
		actual_active_list[2] = 0xeebfd000;
  8001ac:	c7 45 c4 00 d0 bf ee 	movl   $0xeebfd000,-0x3c(%ebp)
		actual_active_list[3] = 0x804000;
  8001b3:	c7 45 c8 00 40 80 00 	movl   $0x804000,-0x38(%ebp)
		actual_active_list[4] = 0x807000;
  8001ba:	c7 45 cc 00 70 80 00 	movl   $0x807000,-0x34(%ebp)
		actual_active_list[5] = 0x809000;
  8001c1:	c7 45 d0 00 90 80 00 	movl   $0x809000,-0x30(%ebp)

		actual_second_list[0] = 0x803000;
  8001c8:	c7 45 a8 00 30 80 00 	movl   $0x803000,-0x58(%ebp)
		actual_second_list[1] = 0x80c000;
  8001cf:	c7 45 ac 00 c0 80 00 	movl   $0x80c000,-0x54(%ebp)
		actual_second_list[2] = 0x80b000;
  8001d6:	c7 45 b0 00 b0 80 00 	movl   $0x80b000,-0x50(%ebp)
		actual_second_list[3] = 0x80a000;
  8001dd:	c7 45 b4 00 a0 80 00 	movl   $0x80a000,-0x4c(%ebp)
		actual_second_list[4] = 0x808000;
  8001e4:	c7 45 b8 00 80 80 00 	movl   $0x808000,-0x48(%ebp)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  8001eb:	6a 05                	push   $0x5
  8001ed:	6a 06                	push   $0x6
  8001ef:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8001f2:	50                   	push   %eax
  8001f3:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	e8 67 18 00 00       	call   801a63 <sys_check_LRU_lists>
  8001fc:	83 c4 10             	add    $0x10,%esp
  8001ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(check == 0)
  800202:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800206:	75 14                	jne    80021c <_main+0x1e4>
			panic("PAGE LRU Lists entry checking failed when a new PAGE ACCESS from the SECOND LIST is occurred..!!");
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	68 b4 1e 80 00       	push   $0x801eb4
  800210:	6a 60                	push   $0x60
  800212:	68 44 1e 80 00       	push   $0x801e44
  800217:	e8 c7 01 00 00       	call   8003e3 <_panic>
	}

	//("STEP 3: NEW FAULTS to test applying LRU algorithm on the second list by removing the LRU page... \n");
	{
		//Reading (Not Modified)
		char garbage3 = arr[PAGE_SIZE*13-1] ;
  80021c:	a0 5f 00 81 00       	mov    0x81005f,%al
  800221:	88 45 d7             	mov    %al,-0x29(%ebp)
		actual_active_list[0] = 0x810000;
  800224:	c7 45 bc 00 00 81 00 	movl   $0x810000,-0x44(%ebp)
		actual_active_list[1] = 0x801000;
  80022b:	c7 45 c0 00 10 80 00 	movl   $0x801000,-0x40(%ebp)
		actual_active_list[2] = 0x800000;
  800232:	c7 45 c4 00 00 80 00 	movl   $0x800000,-0x3c(%ebp)
		actual_active_list[3] = 0xeebfd000;
  800239:	c7 45 c8 00 d0 bf ee 	movl   $0xeebfd000,-0x38(%ebp)
		actual_active_list[4] = 0x804000;
  800240:	c7 45 cc 00 40 80 00 	movl   $0x804000,-0x34(%ebp)
		actual_active_list[5] = 0x807000;
  800247:	c7 45 d0 00 70 80 00 	movl   $0x807000,-0x30(%ebp)

		actual_second_list[0] = 0x809000;
  80024e:	c7 45 a8 00 90 80 00 	movl   $0x809000,-0x58(%ebp)
		actual_second_list[1] = 0x803000;
  800255:	c7 45 ac 00 30 80 00 	movl   $0x803000,-0x54(%ebp)
		actual_second_list[2] = 0x80c000;
  80025c:	c7 45 b0 00 c0 80 00 	movl   $0x80c000,-0x50(%ebp)
		actual_second_list[3] = 0x80b000;
  800263:	c7 45 b4 00 b0 80 00 	movl   $0x80b000,-0x4c(%ebp)
		actual_second_list[4] = 0x80a000;
  80026a:	c7 45 b8 00 a0 80 00 	movl   $0x80a000,-0x48(%ebp)
		check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  800271:	6a 05                	push   $0x5
  800273:	6a 06                	push   $0x6
  800275:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	8d 45 bc             	lea    -0x44(%ebp),%eax
  80027c:	50                   	push   %eax
  80027d:	e8 e1 17 00 00       	call   801a63 <sys_check_LRU_lists>
  800282:	83 c4 10             	add    $0x10,%esp
  800285:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  800288:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80028c:	75 14                	jne    8002a2 <_main+0x26a>
			panic("PAGE LRU Lists entry checking failed when a new PAGE FAULT occurred..!!");
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 18 1f 80 00       	push   $0x801f18
  800296:	6a 75                	push   $0x75
  800298:	68 44 1e 80 00       	push   $0x801e44
  80029d:	e8 41 01 00 00       	call   8003e3 <_panic>
	}
	cprintf("Congratulations!! test PAGE replacement [LRU Alg. on the 2nd chance list] is completed successfully.\n");
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	68 60 1f 80 00       	push   $0x801f60
  8002aa:	e8 f1 03 00 00       	call   8006a0 <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
	return;
  8002b2:	90                   	nop
}
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002bb:	e8 53 15 00 00       	call   801813 <sys_getenvindex>
  8002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c6:	89 d0                	mov    %edx,%eax
  8002c8:	01 c0                	add    %eax,%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	c1 e0 06             	shl    $0x6,%eax
  8002cf:	29 d0                	sub    %edx,%eax
  8002d1:	c1 e0 03             	shl    $0x3,%eax
  8002d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002d9:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002de:	a1 40 30 80 00       	mov    0x803040,%eax
  8002e3:	8a 40 68             	mov    0x68(%eax),%al
  8002e6:	84 c0                	test   %al,%al
  8002e8:	74 0d                	je     8002f7 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8002ea:	a1 40 30 80 00       	mov    0x803040,%eax
  8002ef:	83 c0 68             	add    $0x68,%eax
  8002f2:	a3 34 30 80 00       	mov    %eax,0x803034

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fb:	7e 0a                	jle    800307 <libmain+0x52>
		binaryname = argv[0];
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	a3 34 30 80 00       	mov    %eax,0x803034

	// call user main routine
	_main(argc, argv);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 0c             	pushl  0xc(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 23 fd ff ff       	call   800038 <_main>
  800315:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800318:	e8 03 13 00 00       	call   801620 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80031d:	83 ec 0c             	sub    $0xc,%esp
  800320:	68 e0 1f 80 00       	push   $0x801fe0
  800325:	e8 76 03 00 00       	call   8006a0 <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80032d:	a1 40 30 80 00       	mov    0x803040,%eax
  800332:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800338:	a1 40 30 80 00       	mov    0x803040,%eax
  80033d:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	52                   	push   %edx
  800347:	50                   	push   %eax
  800348:	68 08 20 80 00       	push   $0x802008
  80034d:	e8 4e 03 00 00       	call   8006a0 <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800355:	a1 40 30 80 00       	mov    0x803040,%eax
  80035a:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800360:	a1 40 30 80 00       	mov    0x803040,%eax
  800365:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80036b:	a1 40 30 80 00       	mov    0x803040,%eax
  800370:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800376:	51                   	push   %ecx
  800377:	52                   	push   %edx
  800378:	50                   	push   %eax
  800379:	68 30 20 80 00       	push   $0x802030
  80037e:	e8 1d 03 00 00       	call   8006a0 <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800386:	a1 40 30 80 00       	mov    0x803040,%eax
  80038b:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	50                   	push   %eax
  800395:	68 88 20 80 00       	push   $0x802088
  80039a:	e8 01 03 00 00       	call   8006a0 <cprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	68 e0 1f 80 00       	push   $0x801fe0
  8003aa:	e8 f1 02 00 00       	call   8006a0 <cprintf>
  8003af:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003b2:	e8 83 12 00 00       	call   80163a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003b7:	e8 19 00 00 00       	call   8003d5 <exit>
}
  8003bc:	90                   	nop
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003c5:	83 ec 0c             	sub    $0xc,%esp
  8003c8:	6a 00                	push   $0x0
  8003ca:	e8 10 14 00 00       	call   8017df <sys_destroy_env>
  8003cf:	83 c4 10             	add    $0x10,%esp
}
  8003d2:	90                   	nop
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <exit>:

void
exit(void)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003db:	e8 65 14 00 00       	call   801845 <sys_exit_env>
}
  8003e0:	90                   	nop
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8003ec:	83 c0 04             	add    $0x4,%eax
  8003ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003f2:	a1 38 01 81 00       	mov    0x810138,%eax
  8003f7:	85 c0                	test   %eax,%eax
  8003f9:	74 16                	je     800411 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003fb:	a1 38 01 81 00       	mov    0x810138,%eax
  800400:	83 ec 08             	sub    $0x8,%esp
  800403:	50                   	push   %eax
  800404:	68 9c 20 80 00       	push   $0x80209c
  800409:	e8 92 02 00 00       	call   8006a0 <cprintf>
  80040e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800411:	a1 34 30 80 00       	mov    0x803034,%eax
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	50                   	push   %eax
  80041d:	68 a1 20 80 00       	push   $0x8020a1
  800422:	e8 79 02 00 00       	call   8006a0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80042a:	8b 45 10             	mov    0x10(%ebp),%eax
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	ff 75 f4             	pushl  -0xc(%ebp)
  800433:	50                   	push   %eax
  800434:	e8 fc 01 00 00       	call   800635 <vcprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	6a 00                	push   $0x0
  800441:	68 bd 20 80 00       	push   $0x8020bd
  800446:	e8 ea 01 00 00       	call   800635 <vcprintf>
  80044b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80044e:	e8 82 ff ff ff       	call   8003d5 <exit>

	// should not return here
	while (1) ;
  800453:	eb fe                	jmp    800453 <_panic+0x70>

00800455 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80045b:	a1 40 30 80 00       	mov    0x803040,%eax
  800460:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800466:	8b 45 0c             	mov    0xc(%ebp),%eax
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	74 14                	je     800481 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	68 c0 20 80 00       	push   $0x8020c0
  800475:	6a 26                	push   $0x26
  800477:	68 0c 21 80 00       	push   $0x80210c
  80047c:	e8 62 ff ff ff       	call   8003e3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800481:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80048f:	e9 c5 00 00 00       	jmp    800559 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	85 c0                	test   %eax,%eax
  8004a7:	75 08                	jne    8004b1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004a9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ac:	e9 a5 00 00 00       	jmp    800556 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004bf:	eb 69                	jmp    80052a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004c1:	a1 40 30 80 00       	mov    0x803040,%eax
  8004c6:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8004cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	84 c0                	test   %al,%al
  8004df:	75 46                	jne    800527 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e1:	a1 40 30 80 00       	mov    0x803040,%eax
  8004e6:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8004ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004ef:	89 d0                	mov    %edx,%eax
  8004f1:	01 c0                	add    %eax,%eax
  8004f3:	01 d0                	add    %edx,%eax
  8004f5:	c1 e0 03             	shl    $0x3,%eax
  8004f8:	01 c8                	add    %ecx,%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800502:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800507:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80050c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	01 c8                	add    %ecx,%eax
  800518:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80051a:	39 c2                	cmp    %eax,%edx
  80051c:	75 09                	jne    800527 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80051e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800525:	eb 15                	jmp    80053c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800527:	ff 45 e8             	incl   -0x18(%ebp)
  80052a:	a1 40 30 80 00       	mov    0x803040,%eax
  80052f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800538:	39 c2                	cmp    %eax,%edx
  80053a:	77 85                	ja     8004c1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80053c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800540:	75 14                	jne    800556 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 18 21 80 00       	push   $0x802118
  80054a:	6a 3a                	push   $0x3a
  80054c:	68 0c 21 80 00       	push   $0x80210c
  800551:	e8 8d fe ff ff       	call   8003e3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800556:	ff 45 f0             	incl   -0x10(%ebp)
  800559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80055f:	0f 8c 2f ff ff ff    	jl     800494 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800565:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800573:	eb 26                	jmp    80059b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800575:	a1 40 30 80 00       	mov    0x803040,%eax
  80057a:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800580:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800583:	89 d0                	mov    %edx,%eax
  800585:	01 c0                	add    %eax,%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	c1 e0 03             	shl    $0x3,%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	8a 40 04             	mov    0x4(%eax),%al
  800591:	3c 01                	cmp    $0x1,%al
  800593:	75 03                	jne    800598 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800595:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800598:	ff 45 e0             	incl   -0x20(%ebp)
  80059b:	a1 40 30 80 00       	mov    0x803040,%eax
  8005a0:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8005a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a9:	39 c2                	cmp    %eax,%edx
  8005ab:	77 c8                	ja     800575 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005b3:	74 14                	je     8005c9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005b5:	83 ec 04             	sub    $0x4,%esp
  8005b8:	68 6c 21 80 00       	push   $0x80216c
  8005bd:	6a 44                	push   $0x44
  8005bf:	68 0c 21 80 00       	push   $0x80210c
  8005c4:	e8 1a fe ff ff       	call   8003e3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005c9:	90                   	nop
  8005ca:	c9                   	leave  
  8005cb:	c3                   	ret    

008005cc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005dd:	89 0a                	mov    %ecx,(%edx)
  8005df:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e2:	88 d1                	mov    %dl,%cl
  8005e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005f5:	75 2c                	jne    800623 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005f7:	a0 44 30 80 00       	mov    0x803044,%al
  8005fc:	0f b6 c0             	movzbl %al,%eax
  8005ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800602:	8b 12                	mov    (%edx),%edx
  800604:	89 d1                	mov    %edx,%ecx
  800606:	8b 55 0c             	mov    0xc(%ebp),%edx
  800609:	83 c2 08             	add    $0x8,%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	51                   	push   %ecx
  800611:	52                   	push   %edx
  800612:	e8 b0 0e 00 00       	call   8014c7 <sys_cputs>
  800617:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800623:	8b 45 0c             	mov    0xc(%ebp),%eax
  800626:	8b 40 04             	mov    0x4(%eax),%eax
  800629:	8d 50 01             	lea    0x1(%eax),%edx
  80062c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80063e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800645:	00 00 00 
	b.cnt = 0;
  800648:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80064f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 08             	pushl  0x8(%ebp)
  800658:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065e:	50                   	push   %eax
  80065f:	68 cc 05 80 00       	push   $0x8005cc
  800664:	e8 11 02 00 00       	call   80087a <vprintfmt>
  800669:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80066c:	a0 44 30 80 00       	mov    0x803044,%al
  800671:	0f b6 c0             	movzbl %al,%eax
  800674:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	50                   	push   %eax
  80067e:	52                   	push   %edx
  80067f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800685:	83 c0 08             	add    $0x8,%eax
  800688:	50                   	push   %eax
  800689:	e8 39 0e 00 00       	call   8014c7 <sys_cputs>
  80068e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800691:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800698:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80069e:	c9                   	leave  
  80069f:	c3                   	ret    

008006a0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006a6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	50                   	push   %eax
  8006bd:	e8 73 ff ff ff       	call   800635 <vcprintf>
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006d3:	e8 48 0f 00 00       	call   801620 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	e8 48 ff ff ff       	call   800635 <vcprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006f3:	e8 42 0f 00 00       	call   80163a <sys_enable_interrupt>
	return cnt;
  8006f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	53                   	push   %ebx
  800701:	83 ec 14             	sub    $0x14,%esp
  800704:	8b 45 10             	mov    0x10(%ebp),%eax
  800707:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071b:	77 55                	ja     800772 <printnum+0x75>
  80071d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800720:	72 05                	jb     800727 <printnum+0x2a>
  800722:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800725:	77 4b                	ja     800772 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800727:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80072a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80072d:	8b 45 18             	mov    0x18(%ebp),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	52                   	push   %edx
  800736:	50                   	push   %eax
  800737:	ff 75 f4             	pushl  -0xc(%ebp)
  80073a:	ff 75 f0             	pushl  -0x10(%ebp)
  80073d:	e8 0e 14 00 00       	call   801b50 <__udivdi3>
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	ff 75 20             	pushl  0x20(%ebp)
  80074b:	53                   	push   %ebx
  80074c:	ff 75 18             	pushl  0x18(%ebp)
  80074f:	52                   	push   %edx
  800750:	50                   	push   %eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	e8 a1 ff ff ff       	call   8006fd <printnum>
  80075c:	83 c4 20             	add    $0x20,%esp
  80075f:	eb 1a                	jmp    80077b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 20             	pushl  0x20(%ebp)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800772:	ff 4d 1c             	decl   0x1c(%ebp)
  800775:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800779:	7f e6                	jg     800761 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80077e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800789:	53                   	push   %ebx
  80078a:	51                   	push   %ecx
  80078b:	52                   	push   %edx
  80078c:	50                   	push   %eax
  80078d:	e8 ce 14 00 00       	call   801c60 <__umoddi3>
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	05 d4 23 80 00       	add    $0x8023d4,%eax
  80079a:	8a 00                	mov    (%eax),%al
  80079c:	0f be c0             	movsbl %al,%eax
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	50                   	push   %eax
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	ff d0                	call   *%eax
  8007ab:	83 c4 10             	add    $0x10,%esp
}
  8007ae:	90                   	nop
  8007af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    

008007b4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007bb:	7e 1c                	jle    8007d9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	8d 50 08             	lea    0x8(%eax),%edx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	89 10                	mov    %edx,(%eax)
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	83 e8 08             	sub    $0x8,%eax
  8007d2:	8b 50 04             	mov    0x4(%eax),%edx
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	eb 40                	jmp    800819 <getuint+0x65>
	else if (lflag)
  8007d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007dd:	74 1e                	je     8007fd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	8d 50 04             	lea    0x4(%eax),%edx
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	89 10                	mov    %edx,(%eax)
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	83 e8 04             	sub    $0x4,%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fb:	eb 1c                	jmp    800819 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	8d 50 04             	lea    0x4(%eax),%edx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	89 10                	mov    %edx,(%eax)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	83 e8 04             	sub    $0x4,%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80081e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800822:	7e 1c                	jle    800840 <getint+0x25>
		return va_arg(*ap, long long);
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	8d 50 08             	lea    0x8(%eax),%edx
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	89 10                	mov    %edx,(%eax)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	83 e8 08             	sub    $0x8,%eax
  800839:	8b 50 04             	mov    0x4(%eax),%edx
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	eb 38                	jmp    800878 <getint+0x5d>
	else if (lflag)
  800840:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800844:	74 1a                	je     800860 <getint+0x45>
		return va_arg(*ap, long);
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	8d 50 04             	lea    0x4(%eax),%edx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	89 10                	mov    %edx,(%eax)
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	99                   	cltd   
  80085e:	eb 18                	jmp    800878 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	8d 50 04             	lea    0x4(%eax),%edx
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	89 10                	mov    %edx,(%eax)
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	83 e8 04             	sub    $0x4,%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	99                   	cltd   
}
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800882:	eb 17                	jmp    80089b <vprintfmt+0x21>
			if (ch == '\0')
  800884:	85 db                	test   %ebx,%ebx
  800886:	0f 84 af 03 00 00    	je     800c3b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	53                   	push   %ebx
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089b:	8b 45 10             	mov    0x10(%ebp),%eax
  80089e:	8d 50 01             	lea    0x1(%eax),%edx
  8008a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a4:	8a 00                	mov    (%eax),%al
  8008a6:	0f b6 d8             	movzbl %al,%ebx
  8008a9:	83 fb 25             	cmp    $0x25,%ebx
  8008ac:	75 d6                	jne    800884 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ae:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d1:	8d 50 01             	lea    0x1(%eax),%edx
  8008d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	0f b6 d8             	movzbl %al,%ebx
  8008dc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008df:	83 f8 55             	cmp    $0x55,%eax
  8008e2:	0f 87 2b 03 00 00    	ja     800c13 <vprintfmt+0x399>
  8008e8:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8008ef:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008f5:	eb d7                	jmp    8008ce <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008fb:	eb d1                	jmp    8008ce <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800904:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	c1 e0 02             	shl    $0x2,%eax
  80090c:	01 d0                	add    %edx,%eax
  80090e:	01 c0                	add    %eax,%eax
  800910:	01 d8                	add    %ebx,%eax
  800912:	83 e8 30             	sub    $0x30,%eax
  800915:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800918:	8b 45 10             	mov    0x10(%ebp),%eax
  80091b:	8a 00                	mov    (%eax),%al
  80091d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800920:	83 fb 2f             	cmp    $0x2f,%ebx
  800923:	7e 3e                	jle    800963 <vprintfmt+0xe9>
  800925:	83 fb 39             	cmp    $0x39,%ebx
  800928:	7f 39                	jg     800963 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80092d:	eb d5                	jmp    800904 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800943:	eb 1f                	jmp    800964 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800945:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800949:	79 83                	jns    8008ce <vprintfmt+0x54>
				width = 0;
  80094b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800952:	e9 77 ff ff ff       	jmp    8008ce <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800957:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80095e:	e9 6b ff ff ff       	jmp    8008ce <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800963:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800964:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800968:	0f 89 60 ff ff ff    	jns    8008ce <vprintfmt+0x54>
				width = precision, precision = -1;
  80096e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80097b:	e9 4e ff ff ff       	jmp    8008ce <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800980:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800983:	e9 46 ff ff ff       	jmp    8008ce <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
			break;
  8009a8:	e9 89 02 00 00       	jmp    800c36 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	83 c0 04             	add    $0x4,%eax
  8009b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	83 e8 04             	sub    $0x4,%eax
  8009bc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009be:	85 db                	test   %ebx,%ebx
  8009c0:	79 02                	jns    8009c4 <vprintfmt+0x14a>
				err = -err;
  8009c2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c4:	83 fb 64             	cmp    $0x64,%ebx
  8009c7:	7f 0b                	jg     8009d4 <vprintfmt+0x15a>
  8009c9:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  8009d0:	85 f6                	test   %esi,%esi
  8009d2:	75 19                	jne    8009ed <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d4:	53                   	push   %ebx
  8009d5:	68 e5 23 80 00       	push   $0x8023e5
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	ff 75 08             	pushl  0x8(%ebp)
  8009e0:	e8 5e 02 00 00       	call   800c43 <printfmt>
  8009e5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e8:	e9 49 02 00 00       	jmp    800c36 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ed:	56                   	push   %esi
  8009ee:	68 ee 23 80 00       	push   $0x8023ee
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	ff 75 08             	pushl  0x8(%ebp)
  8009f9:	e8 45 02 00 00       	call   800c43 <printfmt>
  8009fe:	83 c4 10             	add    $0x10,%esp
			break;
  800a01:	e9 30 02 00 00       	jmp    800c36 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	83 c0 04             	add    $0x4,%eax
  800a0c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	83 e8 04             	sub    $0x4,%eax
  800a15:	8b 30                	mov    (%eax),%esi
  800a17:	85 f6                	test   %esi,%esi
  800a19:	75 05                	jne    800a20 <vprintfmt+0x1a6>
				p = "(null)";
  800a1b:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a24:	7e 6d                	jle    800a93 <vprintfmt+0x219>
  800a26:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a2a:	74 67                	je     800a93 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	50                   	push   %eax
  800a33:	56                   	push   %esi
  800a34:	e8 0c 03 00 00       	call   800d45 <strnlen>
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a3f:	eb 16                	jmp    800a57 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a41:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 0c             	pushl  0xc(%ebp)
  800a4b:	50                   	push   %eax
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e4                	jg     800a41 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5d:	eb 34                	jmp    800a93 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a63:	74 1c                	je     800a81 <vprintfmt+0x207>
  800a65:	83 fb 1f             	cmp    $0x1f,%ebx
  800a68:	7e 05                	jle    800a6f <vprintfmt+0x1f5>
  800a6a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a6d:	7e 12                	jle    800a81 <vprintfmt+0x207>
					putch('?', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 3f                	push   $0x3f
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	eb 0f                	jmp    800a90 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	53                   	push   %ebx
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a90:	ff 4d e4             	decl   -0x1c(%ebp)
  800a93:	89 f0                	mov    %esi,%eax
  800a95:	8d 70 01             	lea    0x1(%eax),%esi
  800a98:	8a 00                	mov    (%eax),%al
  800a9a:	0f be d8             	movsbl %al,%ebx
  800a9d:	85 db                	test   %ebx,%ebx
  800a9f:	74 24                	je     800ac5 <vprintfmt+0x24b>
  800aa1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa5:	78 b8                	js     800a5f <vprintfmt+0x1e5>
  800aa7:	ff 4d e0             	decl   -0x20(%ebp)
  800aaa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aae:	79 af                	jns    800a5f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab0:	eb 13                	jmp    800ac5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	6a 20                	push   $0x20
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	ff d0                	call   *%eax
  800abf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac9:	7f e7                	jg     800ab2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800acb:	e9 66 01 00 00       	jmp    800c36 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad9:	50                   	push   %eax
  800ada:	e8 3c fd ff ff       	call   80081b <getint>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aee:	85 d2                	test   %edx,%edx
  800af0:	79 23                	jns    800b15 <vprintfmt+0x29b>
				putch('-', putdat);
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	6a 2d                	push   $0x2d
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	ff d0                	call   *%eax
  800aff:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b08:	f7 d8                	neg    %eax
  800b0a:	83 d2 00             	adc    $0x0,%edx
  800b0d:	f7 da                	neg    %edx
  800b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b15:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b1c:	e9 bc 00 00 00       	jmp    800bdd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b21:	83 ec 08             	sub    $0x8,%esp
  800b24:	ff 75 e8             	pushl  -0x18(%ebp)
  800b27:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2a:	50                   	push   %eax
  800b2b:	e8 84 fc ff ff       	call   8007b4 <getuint>
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b39:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b40:	e9 98 00 00 00       	jmp    800bdd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	6a 58                	push   $0x58
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			break;
  800b75:	e9 bc 00 00 00       	jmp    800c36 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	6a 30                	push   $0x30
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 78                	push   $0x78
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9d:	83 c0 04             	add    $0x4,%eax
  800ba0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba6:	83 e8 04             	sub    $0x4,%eax
  800ba9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bb5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bbc:	eb 1f                	jmp    800bdd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 e7 fb ff ff       	call   8007b4 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bdd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be4:	83 ec 04             	sub    $0x4,%esp
  800be7:	52                   	push   %edx
  800be8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800beb:	50                   	push   %eax
  800bec:	ff 75 f4             	pushl  -0xc(%ebp)
  800bef:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	ff 75 08             	pushl  0x8(%ebp)
  800bf8:	e8 00 fb ff ff       	call   8006fd <printnum>
  800bfd:	83 c4 20             	add    $0x20,%esp
			break;
  800c00:	eb 34                	jmp    800c36 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	53                   	push   %ebx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	ff d0                	call   *%eax
  800c0e:	83 c4 10             	add    $0x10,%esp
			break;
  800c11:	eb 23                	jmp    800c36 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 25                	push   $0x25
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c23:	ff 4d 10             	decl   0x10(%ebp)
  800c26:	eb 03                	jmp    800c2b <vprintfmt+0x3b1>
  800c28:	ff 4d 10             	decl   0x10(%ebp)
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2e:	48                   	dec    %eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	3c 25                	cmp    $0x25,%al
  800c33:	75 f3                	jne    800c28 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c35:	90                   	nop
		}
	}
  800c36:	e9 47 fc ff ff       	jmp    800882 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c3b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c49:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4c:	83 c0 04             	add    $0x4,%eax
  800c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	ff 75 f4             	pushl  -0xc(%ebp)
  800c58:	50                   	push   %eax
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	ff 75 08             	pushl  0x8(%ebp)
  800c5f:	e8 16 fc ff ff       	call   80087a <vprintfmt>
  800c64:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c67:	90                   	nop
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8b 40 08             	mov    0x8(%eax),%eax
  800c73:	8d 50 01             	lea    0x1(%eax),%edx
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	8b 10                	mov    (%eax),%edx
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	8b 40 04             	mov    0x4(%eax),%eax
  800c87:	39 c2                	cmp    %eax,%edx
  800c89:	73 12                	jae    800c9d <sprintputch+0x33>
		*b->buf++ = ch;
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	8d 48 01             	lea    0x1(%eax),%ecx
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	89 0a                	mov    %ecx,(%edx)
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	88 10                	mov    %dl,(%eax)
}
  800c9d:	90                   	nop
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	01 d0                	add    %edx,%eax
  800cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cc5:	74 06                	je     800ccd <vsnprintf+0x2d>
  800cc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccb:	7f 07                	jg     800cd4 <vsnprintf+0x34>
		return -E_INVAL;
  800ccd:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd2:	eb 20                	jmp    800cf4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cd4:	ff 75 14             	pushl  0x14(%ebp)
  800cd7:	ff 75 10             	pushl  0x10(%ebp)
  800cda:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cdd:	50                   	push   %eax
  800cde:	68 6a 0c 80 00       	push   $0x800c6a
  800ce3:	e8 92 fb ff ff       	call   80087a <vprintfmt>
  800ce8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cfc:	8d 45 10             	lea    0x10(%ebp),%eax
  800cff:	83 c0 04             	add    $0x4,%eax
  800d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d05:	8b 45 10             	mov    0x10(%ebp),%eax
  800d08:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0b:	50                   	push   %eax
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 89 ff ff ff       	call   800ca0 <vsnprintf>
  800d17:	83 c4 10             	add    $0x10,%esp
  800d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2f:	eb 06                	jmp    800d37 <strlen+0x15>
		n++;
  800d31:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	84 c0                	test   %al,%al
  800d3e:	75 f1                	jne    800d31 <strlen+0xf>
		n++;
	return n;
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d52:	eb 09                	jmp    800d5d <strnlen+0x18>
		n++;
  800d54:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d57:	ff 45 08             	incl   0x8(%ebp)
  800d5a:	ff 4d 0c             	decl   0xc(%ebp)
  800d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d61:	74 09                	je     800d6c <strnlen+0x27>
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 e8                	jne    800d54 <strnlen+0xf>
		n++;
	return n;
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d7d:	90                   	nop
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8d 50 01             	lea    0x1(%eax),%edx
  800d84:	89 55 08             	mov    %edx,0x8(%ebp)
  800d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d90:	8a 12                	mov    (%edx),%dl
  800d92:	88 10                	mov    %dl,(%eax)
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 e4                	jne    800d7e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db2:	eb 1f                	jmp    800dd3 <strncpy+0x34>
		*dst++ = *src;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 08             	mov    %edx,0x8(%ebp)
  800dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc0:	8a 12                	mov    (%edx),%dl
  800dc2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	74 03                	je     800dd0 <strncpy+0x31>
			src++;
  800dcd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd0:	ff 45 fc             	incl   -0x4(%ebp)
  800dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd9:	72 d9                	jb     800db4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df0:	74 30                	je     800e22 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df2:	eb 16                	jmp    800e0a <strlcpy+0x2a>
			*dst++ = *src++;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8d 50 01             	lea    0x1(%eax),%edx
  800dfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e06:	8a 12                	mov    (%edx),%dl
  800e08:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e0a:	ff 4d 10             	decl   0x10(%ebp)
  800e0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e11:	74 09                	je     800e1c <strlcpy+0x3c>
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	84 c0                	test   %al,%al
  800e1a:	75 d8                	jne    800df4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e28:	29 c2                	sub    %eax,%edx
  800e2a:	89 d0                	mov    %edx,%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e31:	eb 06                	jmp    800e39 <strcmp+0xb>
		p++, q++;
  800e33:	ff 45 08             	incl   0x8(%ebp)
  800e36:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	74 0e                	je     800e50 <strcmp+0x22>
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	38 c2                	cmp    %al,%dl
  800e4e:	74 e3                	je     800e33 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f b6 d0             	movzbl %al,%edx
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 c0             	movzbl %al,%eax
  800e60:	29 c2                	sub    %eax,%edx
  800e62:	89 d0                	mov    %edx,%eax
}
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    

00800e66 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e69:	eb 09                	jmp    800e74 <strncmp+0xe>
		n--, p++, q++;
  800e6b:	ff 4d 10             	decl   0x10(%ebp)
  800e6e:	ff 45 08             	incl   0x8(%ebp)
  800e71:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	74 17                	je     800e91 <strncmp+0x2b>
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	84 c0                	test   %al,%al
  800e81:	74 0e                	je     800e91 <strncmp+0x2b>
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 10                	mov    (%eax),%dl
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	38 c2                	cmp    %al,%dl
  800e8f:	74 da                	je     800e6b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e95:	75 07                	jne    800e9e <strncmp+0x38>
		return 0;
  800e97:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9c:	eb 14                	jmp    800eb2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	0f b6 d0             	movzbl %al,%edx
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 c0             	movzbl %al,%eax
  800eae:	29 c2                	sub    %eax,%edx
  800eb0:	89 d0                	mov    %edx,%eax
}
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 04             	sub    $0x4,%esp
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec0:	eb 12                	jmp    800ed4 <strchr+0x20>
		if (*s == c)
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eca:	75 05                	jne    800ed1 <strchr+0x1d>
			return (char *) s;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	eb 11                	jmp    800ee2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed1:	ff 45 08             	incl   0x8(%ebp)
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	84 c0                	test   %al,%al
  800edb:	75 e5                	jne    800ec2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 04             	sub    $0x4,%esp
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef0:	eb 0d                	jmp    800eff <strfind+0x1b>
		if (*s == c)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800efa:	74 0e                	je     800f0a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800efc:	ff 45 08             	incl   0x8(%ebp)
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	84 c0                	test   %al,%al
  800f06:	75 ea                	jne    800ef2 <strfind+0xe>
  800f08:	eb 01                	jmp    800f0b <strfind+0x27>
		if (*s == c)
			break;
  800f0a:	90                   	nop
	return (char *) s;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f22:	eb 0e                	jmp    800f32 <memset+0x22>
		*p++ = c;
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	8d 50 01             	lea    0x1(%eax),%edx
  800f2a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f30:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f32:	ff 4d f8             	decl   -0x8(%ebp)
  800f35:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f39:	79 e9                	jns    800f24 <memset+0x14>
		*p++ = c;

	return v;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f52:	eb 16                	jmp    800f6a <memcpy+0x2a>
		*d++ = *s++;
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	8d 50 01             	lea    0x1(%eax),%edx
  800f5a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f63:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f66:	8a 12                	mov    (%edx),%dl
  800f68:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f70:	89 55 10             	mov    %edx,0x10(%ebp)
  800f73:	85 c0                	test   %eax,%eax
  800f75:	75 dd                	jne    800f54 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    

00800f7c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f94:	73 50                	jae    800fe6 <memmove+0x6a>
  800f96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 d0                	add    %edx,%eax
  800f9e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa1:	76 43                	jbe    800fe6 <memmove+0x6a>
		s += n;
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800faf:	eb 10                	jmp    800fc1 <memmove+0x45>
			*--d = *--s;
  800fb1:	ff 4d f8             	decl   -0x8(%ebp)
  800fb4:	ff 4d fc             	decl   -0x4(%ebp)
  800fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fba:	8a 10                	mov    (%eax),%dl
  800fbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	75 e3                	jne    800fb1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fce:	eb 23                	jmp    800ff3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	8d 50 01             	lea    0x1(%eax),%edx
  800fd6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe2:	8a 12                	mov    (%edx),%dl
  800fe4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	89 55 10             	mov    %edx,0x10(%ebp)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	75 dd                	jne    800fd0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80100a:	eb 2a                	jmp    801036 <memcmp+0x3e>
		if (*s1 != *s2)
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100f:	8a 10                	mov    (%eax),%dl
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	38 c2                	cmp    %al,%dl
  801018:	74 16                	je     801030 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80101a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	0f b6 d0             	movzbl %al,%edx
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 c0             	movzbl %al,%eax
  80102a:	29 c2                	sub    %eax,%edx
  80102c:	89 d0                	mov    %edx,%eax
  80102e:	eb 18                	jmp    801048 <memcmp+0x50>
		s1++, s2++;
  801030:	ff 45 fc             	incl   -0x4(%ebp)
  801033:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103c:	89 55 10             	mov    %edx,0x10(%ebp)
  80103f:	85 c0                	test   %eax,%eax
  801041:	75 c9                	jne    80100c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801050:	8b 55 08             	mov    0x8(%ebp),%edx
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	01 d0                	add    %edx,%eax
  801058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80105b:	eb 15                	jmp    801072 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f b6 d0             	movzbl %al,%edx
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	0f b6 c0             	movzbl %al,%eax
  80106b:	39 c2                	cmp    %eax,%edx
  80106d:	74 0d                	je     80107c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80106f:	ff 45 08             	incl   0x8(%ebp)
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801078:	72 e3                	jb     80105d <memfind+0x13>
  80107a:	eb 01                	jmp    80107d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80107c:	90                   	nop
	return (void *) s;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80108f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801096:	eb 03                	jmp    80109b <strtol+0x19>
		s++;
  801098:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 20                	cmp    $0x20,%al
  8010a2:	74 f4                	je     801098 <strtol+0x16>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 09                	cmp    $0x9,%al
  8010ab:	74 eb                	je     801098 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 2b                	cmp    $0x2b,%al
  8010b4:	75 05                	jne    8010bb <strtol+0x39>
		s++;
  8010b6:	ff 45 08             	incl   0x8(%ebp)
  8010b9:	eb 13                	jmp    8010ce <strtol+0x4c>
	else if (*s == '-')
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 2d                	cmp    $0x2d,%al
  8010c2:	75 0a                	jne    8010ce <strtol+0x4c>
		s++, neg = 1;
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d2:	74 06                	je     8010da <strtol+0x58>
  8010d4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d8:	75 20                	jne    8010fa <strtol+0x78>
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 30                	cmp    $0x30,%al
  8010e1:	75 17                	jne    8010fa <strtol+0x78>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	40                   	inc    %eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 78                	cmp    $0x78,%al
  8010eb:	75 0d                	jne    8010fa <strtol+0x78>
		s += 2, base = 16;
  8010ed:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f8:	eb 28                	jmp    801122 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fe:	75 15                	jne    801115 <strtol+0x93>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 0c                	jne    801115 <strtol+0x93>
		s++, base = 8;
  801109:	ff 45 08             	incl   0x8(%ebp)
  80110c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801113:	eb 0d                	jmp    801122 <strtol+0xa0>
	else if (base == 0)
  801115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801119:	75 07                	jne    801122 <strtol+0xa0>
		base = 10;
  80111b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 2f                	cmp    $0x2f,%al
  801129:	7e 19                	jle    801144 <strtol+0xc2>
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	3c 39                	cmp    $0x39,%al
  801132:	7f 10                	jg     801144 <strtol+0xc2>
			dig = *s - '0';
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	0f be c0             	movsbl %al,%eax
  80113c:	83 e8 30             	sub    $0x30,%eax
  80113f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801142:	eb 42                	jmp    801186 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	3c 60                	cmp    $0x60,%al
  80114b:	7e 19                	jle    801166 <strtol+0xe4>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	3c 7a                	cmp    $0x7a,%al
  801154:	7f 10                	jg     801166 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	0f be c0             	movsbl %al,%eax
  80115e:	83 e8 57             	sub    $0x57,%eax
  801161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801164:	eb 20                	jmp    801186 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	3c 40                	cmp    $0x40,%al
  80116d:	7e 39                	jle    8011a8 <strtol+0x126>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	3c 5a                	cmp    $0x5a,%al
  801176:	7f 30                	jg     8011a8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f be c0             	movsbl %al,%eax
  801180:	83 e8 37             	sub    $0x37,%eax
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	3b 45 10             	cmp    0x10(%ebp),%eax
  80118c:	7d 19                	jge    8011a7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80118e:	ff 45 08             	incl   0x8(%ebp)
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	0f af 45 10          	imul   0x10(%ebp),%eax
  801198:	89 c2                	mov    %eax,%edx
  80119a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011a2:	e9 7b ff ff ff       	jmp    801122 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011a7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ac:	74 08                	je     8011b6 <strtol+0x134>
		*endptr = (char *) s;
  8011ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ba:	74 07                	je     8011c3 <strtol+0x141>
  8011bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bf:	f7 d8                	neg    %eax
  8011c1:	eb 03                	jmp    8011c6 <strtol+0x144>
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e0:	79 13                	jns    8011f5 <ltostr+0x2d>
	{
		neg = 1;
  8011e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ef:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011fd:	99                   	cltd   
  8011fe:	f7 f9                	idiv   %ecx
  801200:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801203:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801216:	83 c2 30             	add    $0x30,%edx
  801219:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80121b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801223:	f7 e9                	imul   %ecx
  801225:	c1 fa 02             	sar    $0x2,%edx
  801228:	89 c8                	mov    %ecx,%eax
  80122a:	c1 f8 1f             	sar    $0x1f,%eax
  80122d:	29 c2                	sub    %eax,%edx
  80122f:	89 d0                	mov    %edx,%eax
  801231:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801234:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801237:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123c:	f7 e9                	imul   %ecx
  80123e:	c1 fa 02             	sar    $0x2,%edx
  801241:	89 c8                	mov    %ecx,%eax
  801243:	c1 f8 1f             	sar    $0x1f,%eax
  801246:	29 c2                	sub    %eax,%edx
  801248:	89 d0                	mov    %edx,%eax
  80124a:	c1 e0 02             	shl    $0x2,%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	01 c0                	add    %eax,%eax
  801251:	29 c1                	sub    %eax,%ecx
  801253:	89 ca                	mov    %ecx,%edx
  801255:	85 d2                	test   %edx,%edx
  801257:	75 9c                	jne    8011f5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	48                   	dec    %eax
  801264:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801267:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126b:	74 3d                	je     8012aa <ltostr+0xe2>
		start = 1 ;
  80126d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801274:	eb 34                	jmp    8012aa <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 c2                	add    %eax,%edx
  80128b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c8                	add    %ecx,%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801297:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	01 c2                	add    %eax,%edx
  80129f:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c c4                	jl     801276 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c6:	ff 75 08             	pushl  0x8(%ebp)
  8012c9:	e8 54 fa ff ff       	call   800d22 <strlen>
  8012ce:	83 c4 04             	add    $0x4,%esp
  8012d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	e8 46 fa ff ff       	call   800d22 <strlen>
  8012dc:	83 c4 04             	add    $0x4,%esp
  8012df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f0:	eb 17                	jmp    801309 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	01 c2                	add    %eax,%edx
  8012fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	01 c8                	add    %ecx,%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801306:	ff 45 fc             	incl   -0x4(%ebp)
  801309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130f:	7c e1                	jl     8012f2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801311:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131f:	eb 1f                	jmp    801340 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801324:	8d 50 01             	lea    0x1(%eax),%edx
  801327:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	8b 45 10             	mov    0x10(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 c8                	add    %ecx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133d:	ff 45 f8             	incl   -0x8(%ebp)
  801340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801343:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801346:	7c d9                	jl     801321 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	c6 00 00             	movb   $0x0,(%eax)
}
  801353:	90                   	nop
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801379:	eb 0c                	jmp    801387 <strsplit+0x31>
			*string++ = 0;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8d 50 01             	lea    0x1(%eax),%edx
  801381:	89 55 08             	mov    %edx,0x8(%ebp)
  801384:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	84 c0                	test   %al,%al
  80138e:	74 18                	je     8013a8 <strsplit+0x52>
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f be c0             	movsbl %al,%eax
  801398:	50                   	push   %eax
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	e8 13 fb ff ff       	call   800eb4 <strchr>
  8013a1:	83 c4 08             	add    $0x8,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	75 d3                	jne    80137b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	84 c0                	test   %al,%al
  8013af:	74 5a                	je     80140b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b4:	8b 00                	mov    (%eax),%eax
  8013b6:	83 f8 0f             	cmp    $0xf,%eax
  8013b9:	75 07                	jne    8013c2 <strsplit+0x6c>
		{
			return 0;
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	eb 66                	jmp    801428 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ca:	8b 55 14             	mov    0x14(%ebp),%edx
  8013cd:	89 0a                	mov    %ecx,(%edx)
  8013cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	01 c2                	add    %eax,%edx
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e0:	eb 03                	jmp    8013e5 <strsplit+0x8f>
			string++;
  8013e2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	84 c0                	test   %al,%al
  8013ec:	74 8b                	je     801379 <strsplit+0x23>
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be c0             	movsbl %al,%eax
  8013f6:	50                   	push   %eax
  8013f7:	ff 75 0c             	pushl  0xc(%ebp)
  8013fa:	e8 b5 fa ff ff       	call   800eb4 <strchr>
  8013ff:	83 c4 08             	add    $0x8,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	74 dc                	je     8013e2 <strsplit+0x8c>
			string++;
	}
  801406:	e9 6e ff ff ff       	jmp    801379 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80140b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140c:	8b 45 14             	mov    0x14(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801418:	8b 45 10             	mov    0x10(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801423:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801430:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801437:	eb 4c                	jmp    801485 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801439:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	3c 40                	cmp    $0x40,%al
  801445:	7e 27                	jle    80146e <str2lower+0x44>
  801447:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 d0                	add    %edx,%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	3c 5a                	cmp    $0x5a,%al
  801453:	7f 19                	jg     80146e <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801455:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	01 ca                	add    %ecx,%edx
  801465:	8a 12                	mov    (%edx),%dl
  801467:	83 c2 20             	add    $0x20,%edx
  80146a:	88 10                	mov    %dl,(%eax)
  80146c:	eb 14                	jmp    801482 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80146e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	01 c2                	add    %eax,%edx
  801476:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 c8                	add    %ecx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801482:	ff 45 fc             	incl   -0x4(%ebp)
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	e8 95 f8 ff ff       	call   800d22 <strlen>
  80148d:	83 c4 04             	add    $0x4,%esp
  801490:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801493:	7f a4                	jg     801439 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	57                   	push   %edi
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014b7:	cd 30                	int    $0x30
  8014b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	52                   	push   %edx
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	50                   	push   %eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	e8 b2 ff ff ff       	call   80149c <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	90                   	nop
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 01                	push   $0x1
  8014ff:	e8 98 ff ff ff       	call   80149c <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80150c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	52                   	push   %edx
  801519:	50                   	push   %eax
  80151a:	6a 05                	push   $0x5
  80151c:	e8 7b ff ff ff       	call   80149c <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80152b:	8b 75 18             	mov    0x18(%ebp),%esi
  80152e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801531:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801534:	8b 55 0c             	mov    0xc(%ebp),%edx
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	56                   	push   %esi
  80153b:	53                   	push   %ebx
  80153c:	51                   	push   %ecx
  80153d:	52                   	push   %edx
  80153e:	50                   	push   %eax
  80153f:	6a 06                	push   $0x6
  801541:	e8 56 ff ff ff       	call   80149c <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    

00801550 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	52                   	push   %edx
  801560:	50                   	push   %eax
  801561:	6a 07                	push   $0x7
  801563:	e8 34 ff ff ff       	call   80149c <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	ff 75 0c             	pushl  0xc(%ebp)
  801579:	ff 75 08             	pushl  0x8(%ebp)
  80157c:	6a 08                	push   $0x8
  80157e:	e8 19 ff ff ff       	call   80149c <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 09                	push   $0x9
  801597:	e8 00 ff ff ff       	call   80149c <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 0a                	push   $0xa
  8015b0:	e8 e7 fe ff ff       	call   80149c <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 0b                	push   $0xb
  8015c9:	e8 ce fe ff ff       	call   80149c <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 0c                	push   $0xc
  8015e2:	e8 b5 fe ff ff       	call   80149c <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	6a 0d                	push   $0xd
  8015fc:	e8 9b fe ff ff       	call   80149c <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 0e                	push   $0xe
  801615:	e8 82 fe ff ff       	call   80149c <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 11                	push   $0x11
  80162f:	e8 68 fe ff ff       	call   80149c <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 12                	push   $0x12
  801649:	e8 4e fe ff ff       	call   80149c <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	90                   	nop
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_cputc>:


void
sys_cputc(const char c)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801660:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	50                   	push   %eax
  80166d:	6a 13                	push   $0x13
  80166f:	e8 28 fe ff ff       	call   80149c <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	90                   	nop
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 14                	push   $0x14
  801689:	e8 0e fe ff ff       	call   80149c <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	50                   	push   %eax
  8016a4:	6a 15                	push   $0x15
  8016a6:	e8 f1 fd ff ff       	call   80149c <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	6a 18                	push   $0x18
  8016c3:	e8 d4 fd ff ff       	call   80149c <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	6a 16                	push   $0x16
  8016e0:	e8 b7 fd ff ff       	call   80149c <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	6a 17                	push   $0x17
  8016fe:	e8 99 fd ff ff       	call   80149c <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	90                   	nop
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	8b 45 10             	mov    0x10(%ebp),%eax
  801712:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801715:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801718:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	51                   	push   %ecx
  801722:	52                   	push   %edx
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	6a 19                	push   $0x19
  801729:	e8 6e fd ff ff       	call   80149c <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 1a                	push   $0x1a
  801746:	e8 51 fd ff ff       	call   80149c <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801753:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	51                   	push   %ecx
  801761:	52                   	push   %edx
  801762:	50                   	push   %eax
  801763:	6a 1b                	push   $0x1b
  801765:	e8 32 fd ff ff       	call   80149c <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	52                   	push   %edx
  80177f:	50                   	push   %eax
  801780:	6a 1c                	push   $0x1c
  801782:	e8 15 fd ff ff       	call   80149c <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 1d                	push   $0x1d
  80179b:	e8 fc fc ff ff       	call   80149c <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	ff 75 14             	pushl  0x14(%ebp)
  8017b0:	ff 75 10             	pushl  0x10(%ebp)
  8017b3:	ff 75 0c             	pushl  0xc(%ebp)
  8017b6:	50                   	push   %eax
  8017b7:	6a 1e                	push   $0x1e
  8017b9:	e8 de fc ff ff       	call   80149c <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	50                   	push   %eax
  8017d2:	6a 1f                	push   $0x1f
  8017d4:	e8 c3 fc ff ff       	call   80149c <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	90                   	nop
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	50                   	push   %eax
  8017ee:	6a 20                	push   $0x20
  8017f0:	e8 a7 fc ff ff       	call   80149c <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 02                	push   $0x2
  801809:	e8 8e fc ff ff       	call   80149c <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 03                	push   $0x3
  801822:	e8 75 fc ff ff       	call   80149c <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 04                	push   $0x4
  80183b:	e8 5c fc ff ff       	call   80149c <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_exit_env>:


void sys_exit_env(void)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 21                	push   $0x21
  801854:	e8 43 fc ff ff       	call   80149c <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	90                   	nop
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801865:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801868:	8d 50 04             	lea    0x4(%eax),%edx
  80186b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	50                   	push   %eax
  801876:	6a 22                	push   $0x22
  801878:	e8 1f fc ff ff       	call   80149c <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return result;
  801880:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801883:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801886:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801889:	89 01                	mov    %eax,(%ecx)
  80188b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	c9                   	leave  
  801892:	c2 04 00             	ret    $0x4

00801895 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 10             	pushl  0x10(%ebp)
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	ff 75 08             	pushl  0x8(%ebp)
  8018a5:	6a 10                	push   $0x10
  8018a7:	e8 f0 fb ff ff       	call   80149c <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8018af:	90                   	nop
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 23                	push   $0x23
  8018c1:	e8 d6 fb ff ff       	call   80149c <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018d7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	50                   	push   %eax
  8018e4:	6a 24                	push   $0x24
  8018e6:	e8 b1 fb ff ff       	call   80149c <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <rsttst>:
void rsttst()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 26                	push   $0x26
  801900:	e8 97 fb ff ff       	call   80149c <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
	return ;
  801908:	90                   	nop
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 45 14             	mov    0x14(%ebp),%eax
  801914:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801917:	8b 55 18             	mov    0x18(%ebp),%edx
  80191a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	ff 75 10             	pushl  0x10(%ebp)
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	6a 25                	push   $0x25
  80192b:	e8 6c fb ff ff       	call   80149c <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
	return ;
  801933:	90                   	nop
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <chktst>:
void chktst(uint32 n)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	ff 75 08             	pushl  0x8(%ebp)
  801944:	6a 27                	push   $0x27
  801946:	e8 51 fb ff ff       	call   80149c <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
	return ;
  80194e:	90                   	nop
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <inctst>:

void inctst()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 28                	push   $0x28
  801960:	e8 37 fb ff ff       	call   80149c <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
	return ;
  801968:	90                   	nop
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <gettst>:
uint32 gettst()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 29                	push   $0x29
  80197a:	e8 1d fb ff ff       	call   80149c <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 2a                	push   $0x2a
  801996:	e8 01 fb ff ff       	call   80149c <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
  80199e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019a1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019a5:	75 07                	jne    8019ae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ac:	eb 05                	jmp    8019b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 2a                	push   $0x2a
  8019c7:	e8 d0 fa ff ff       	call   80149c <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
  8019cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019d2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019d6:	75 07                	jne    8019df <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019dd:	eb 05                	jmp    8019e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 2a                	push   $0x2a
  8019f8:	e8 9f fa ff ff       	call   80149c <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
  801a00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a07:	75 07                	jne    801a10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0e:	eb 05                	jmp    801a15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 2a                	push   $0x2a
  801a29:	e8 6e fa ff ff       	call   80149c <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
  801a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a38:	75 07                	jne    801a41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3f:	eb 05                	jmp    801a46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 2b                	push   $0x2b
  801a58:	e8 3f fa ff ff       	call   80149c <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a60:	90                   	nop
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	53                   	push   %ebx
  801a76:	51                   	push   %ecx
  801a77:	52                   	push   %edx
  801a78:	50                   	push   %eax
  801a79:	6a 2c                	push   $0x2c
  801a7b:	e8 1c fa ff ff       	call   80149c <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 2d                	push   $0x2d
  801a9b:	e8 fc f9 ff ff       	call   80149c <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aa8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	6a 00                	push   $0x0
  801ab3:	51                   	push   %ecx
  801ab4:	ff 75 10             	pushl  0x10(%ebp)
  801ab7:	52                   	push   %edx
  801ab8:	50                   	push   %eax
  801ab9:	6a 2e                	push   $0x2e
  801abb:	e8 dc f9 ff ff       	call   80149c <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	ff 75 10             	pushl  0x10(%ebp)
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	6a 0f                	push   $0xf
  801ad7:	e8 c0 f9 ff ff       	call   80149c <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
	return ;
  801adf:	90                   	nop
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	50                   	push   %eax
  801af1:	6a 2f                	push   $0x2f
  801af3:	e8 a4 f9 ff ff       	call   80149c <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp

}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	6a 30                	push   $0x30
  801b0e:	e8 89 f9 ff ff       	call   80149c <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
	return;
  801b16:	90                   	nop
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	ff 75 08             	pushl  0x8(%ebp)
  801b28:	6a 31                	push   $0x31
  801b2a:	e8 6d f9 ff ff       	call   80149c <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
	return;
  801b32:	90                   	nop
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 32                	push   $0x32
  801b44:	e8 53 f9 ff ff       	call   80149c <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    
  801b4e:	66 90                	xchg   %ax,%ax

00801b50 <__udivdi3>:
  801b50:	55                   	push   %ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b67:	89 ca                	mov    %ecx,%edx
  801b69:	89 f8                	mov    %edi,%eax
  801b6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b6f:	85 f6                	test   %esi,%esi
  801b71:	75 2d                	jne    801ba0 <__udivdi3+0x50>
  801b73:	39 cf                	cmp    %ecx,%edi
  801b75:	77 65                	ja     801bdc <__udivdi3+0x8c>
  801b77:	89 fd                	mov    %edi,%ebp
  801b79:	85 ff                	test   %edi,%edi
  801b7b:	75 0b                	jne    801b88 <__udivdi3+0x38>
  801b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b82:	31 d2                	xor    %edx,%edx
  801b84:	f7 f7                	div    %edi
  801b86:	89 c5                	mov    %eax,%ebp
  801b88:	31 d2                	xor    %edx,%edx
  801b8a:	89 c8                	mov    %ecx,%eax
  801b8c:	f7 f5                	div    %ebp
  801b8e:	89 c1                	mov    %eax,%ecx
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	f7 f5                	div    %ebp
  801b94:	89 cf                	mov    %ecx,%edi
  801b96:	89 fa                	mov    %edi,%edx
  801b98:	83 c4 1c             	add    $0x1c,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
  801ba0:	39 ce                	cmp    %ecx,%esi
  801ba2:	77 28                	ja     801bcc <__udivdi3+0x7c>
  801ba4:	0f bd fe             	bsr    %esi,%edi
  801ba7:	83 f7 1f             	xor    $0x1f,%edi
  801baa:	75 40                	jne    801bec <__udivdi3+0x9c>
  801bac:	39 ce                	cmp    %ecx,%esi
  801bae:	72 0a                	jb     801bba <__udivdi3+0x6a>
  801bb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bb4:	0f 87 9e 00 00 00    	ja     801c58 <__udivdi3+0x108>
  801bba:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbf:	89 fa                	mov    %edi,%edx
  801bc1:	83 c4 1c             	add    $0x1c,%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5f                   	pop    %edi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    
  801bc9:	8d 76 00             	lea    0x0(%esi),%esi
  801bcc:	31 ff                	xor    %edi,%edi
  801bce:	31 c0                	xor    %eax,%eax
  801bd0:	89 fa                	mov    %edi,%edx
  801bd2:	83 c4 1c             	add    $0x1c,%esp
  801bd5:	5b                   	pop    %ebx
  801bd6:	5e                   	pop    %esi
  801bd7:	5f                   	pop    %edi
  801bd8:	5d                   	pop    %ebp
  801bd9:	c3                   	ret    
  801bda:	66 90                	xchg   %ax,%ax
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	f7 f7                	div    %edi
  801be0:	31 ff                	xor    %edi,%edi
  801be2:	89 fa                	mov    %edi,%edx
  801be4:	83 c4 1c             	add    $0x1c,%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
  801bec:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bf1:	89 eb                	mov    %ebp,%ebx
  801bf3:	29 fb                	sub    %edi,%ebx
  801bf5:	89 f9                	mov    %edi,%ecx
  801bf7:	d3 e6                	shl    %cl,%esi
  801bf9:	89 c5                	mov    %eax,%ebp
  801bfb:	88 d9                	mov    %bl,%cl
  801bfd:	d3 ed                	shr    %cl,%ebp
  801bff:	89 e9                	mov    %ebp,%ecx
  801c01:	09 f1                	or     %esi,%ecx
  801c03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c07:	89 f9                	mov    %edi,%ecx
  801c09:	d3 e0                	shl    %cl,%eax
  801c0b:	89 c5                	mov    %eax,%ebp
  801c0d:	89 d6                	mov    %edx,%esi
  801c0f:	88 d9                	mov    %bl,%cl
  801c11:	d3 ee                	shr    %cl,%esi
  801c13:	89 f9                	mov    %edi,%ecx
  801c15:	d3 e2                	shl    %cl,%edx
  801c17:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 e8                	shr    %cl,%eax
  801c1f:	09 c2                	or     %eax,%edx
  801c21:	89 d0                	mov    %edx,%eax
  801c23:	89 f2                	mov    %esi,%edx
  801c25:	f7 74 24 0c          	divl   0xc(%esp)
  801c29:	89 d6                	mov    %edx,%esi
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	f7 e5                	mul    %ebp
  801c2f:	39 d6                	cmp    %edx,%esi
  801c31:	72 19                	jb     801c4c <__udivdi3+0xfc>
  801c33:	74 0b                	je     801c40 <__udivdi3+0xf0>
  801c35:	89 d8                	mov    %ebx,%eax
  801c37:	31 ff                	xor    %edi,%edi
  801c39:	e9 58 ff ff ff       	jmp    801b96 <__udivdi3+0x46>
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c44:	89 f9                	mov    %edi,%ecx
  801c46:	d3 e2                	shl    %cl,%edx
  801c48:	39 c2                	cmp    %eax,%edx
  801c4a:	73 e9                	jae    801c35 <__udivdi3+0xe5>
  801c4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c4f:	31 ff                	xor    %edi,%edi
  801c51:	e9 40 ff ff ff       	jmp    801b96 <__udivdi3+0x46>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	31 c0                	xor    %eax,%eax
  801c5a:	e9 37 ff ff ff       	jmp    801b96 <__udivdi3+0x46>
  801c5f:	90                   	nop

00801c60 <__umoddi3>:
  801c60:	55                   	push   %ebp
  801c61:	57                   	push   %edi
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
  801c64:	83 ec 1c             	sub    $0x1c,%esp
  801c67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c7f:	89 f3                	mov    %esi,%ebx
  801c81:	89 fa                	mov    %edi,%edx
  801c83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c87:	89 34 24             	mov    %esi,(%esp)
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	75 1a                	jne    801ca8 <__umoddi3+0x48>
  801c8e:	39 f7                	cmp    %esi,%edi
  801c90:	0f 86 a2 00 00 00    	jbe    801d38 <__umoddi3+0xd8>
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	89 f2                	mov    %esi,%edx
  801c9a:	f7 f7                	div    %edi
  801c9c:	89 d0                	mov    %edx,%eax
  801c9e:	31 d2                	xor    %edx,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	39 f0                	cmp    %esi,%eax
  801caa:	0f 87 ac 00 00 00    	ja     801d5c <__umoddi3+0xfc>
  801cb0:	0f bd e8             	bsr    %eax,%ebp
  801cb3:	83 f5 1f             	xor    $0x1f,%ebp
  801cb6:	0f 84 ac 00 00 00    	je     801d68 <__umoddi3+0x108>
  801cbc:	bf 20 00 00 00       	mov    $0x20,%edi
  801cc1:	29 ef                	sub    %ebp,%edi
  801cc3:	89 fe                	mov    %edi,%esi
  801cc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	d3 e0                	shl    %cl,%eax
  801ccd:	89 d7                	mov    %edx,%edi
  801ccf:	89 f1                	mov    %esi,%ecx
  801cd1:	d3 ef                	shr    %cl,%edi
  801cd3:	09 c7                	or     %eax,%edi
  801cd5:	89 e9                	mov    %ebp,%ecx
  801cd7:	d3 e2                	shl    %cl,%edx
  801cd9:	89 14 24             	mov    %edx,(%esp)
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	d3 e0                	shl    %cl,%eax
  801ce0:	89 c2                	mov    %eax,%edx
  801ce2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce6:	d3 e0                	shl    %cl,%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf0:	89 f1                	mov    %esi,%ecx
  801cf2:	d3 e8                	shr    %cl,%eax
  801cf4:	09 d0                	or     %edx,%eax
  801cf6:	d3 eb                	shr    %cl,%ebx
  801cf8:	89 da                	mov    %ebx,%edx
  801cfa:	f7 f7                	div    %edi
  801cfc:	89 d3                	mov    %edx,%ebx
  801cfe:	f7 24 24             	mull   (%esp)
  801d01:	89 c6                	mov    %eax,%esi
  801d03:	89 d1                	mov    %edx,%ecx
  801d05:	39 d3                	cmp    %edx,%ebx
  801d07:	0f 82 87 00 00 00    	jb     801d94 <__umoddi3+0x134>
  801d0d:	0f 84 91 00 00 00    	je     801da4 <__umoddi3+0x144>
  801d13:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d17:	29 f2                	sub    %esi,%edx
  801d19:	19 cb                	sbb    %ecx,%ebx
  801d1b:	89 d8                	mov    %ebx,%eax
  801d1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d21:	d3 e0                	shl    %cl,%eax
  801d23:	89 e9                	mov    %ebp,%ecx
  801d25:	d3 ea                	shr    %cl,%edx
  801d27:	09 d0                	or     %edx,%eax
  801d29:	89 e9                	mov    %ebp,%ecx
  801d2b:	d3 eb                	shr    %cl,%ebx
  801d2d:	89 da                	mov    %ebx,%edx
  801d2f:	83 c4 1c             	add    $0x1c,%esp
  801d32:	5b                   	pop    %ebx
  801d33:	5e                   	pop    %esi
  801d34:	5f                   	pop    %edi
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    
  801d37:	90                   	nop
  801d38:	89 fd                	mov    %edi,%ebp
  801d3a:	85 ff                	test   %edi,%edi
  801d3c:	75 0b                	jne    801d49 <__umoddi3+0xe9>
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	31 d2                	xor    %edx,%edx
  801d45:	f7 f7                	div    %edi
  801d47:	89 c5                	mov    %eax,%ebp
  801d49:	89 f0                	mov    %esi,%eax
  801d4b:	31 d2                	xor    %edx,%edx
  801d4d:	f7 f5                	div    %ebp
  801d4f:	89 c8                	mov    %ecx,%eax
  801d51:	f7 f5                	div    %ebp
  801d53:	89 d0                	mov    %edx,%eax
  801d55:	e9 44 ff ff ff       	jmp    801c9e <__umoddi3+0x3e>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	89 c8                	mov    %ecx,%eax
  801d5e:	89 f2                	mov    %esi,%edx
  801d60:	83 c4 1c             	add    $0x1c,%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5f                   	pop    %edi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    
  801d68:	3b 04 24             	cmp    (%esp),%eax
  801d6b:	72 06                	jb     801d73 <__umoddi3+0x113>
  801d6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d71:	77 0f                	ja     801d82 <__umoddi3+0x122>
  801d73:	89 f2                	mov    %esi,%edx
  801d75:	29 f9                	sub    %edi,%ecx
  801d77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d7b:	89 14 24             	mov    %edx,(%esp)
  801d7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d82:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d86:	8b 14 24             	mov    (%esp),%edx
  801d89:	83 c4 1c             	add    $0x1c,%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5f                   	pop    %edi
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    
  801d91:	8d 76 00             	lea    0x0(%esi),%esi
  801d94:	2b 04 24             	sub    (%esp),%eax
  801d97:	19 fa                	sbb    %edi,%edx
  801d99:	89 d1                	mov    %edx,%ecx
  801d9b:	89 c6                	mov    %eax,%esi
  801d9d:	e9 71 ff ff ff       	jmp    801d13 <__umoddi3+0xb3>
  801da2:	66 90                	xchg   %ax,%ax
  801da4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801da8:	72 ea                	jb     801d94 <__umoddi3+0x134>
  801daa:	89 d9                	mov    %ebx,%ecx
  801dac:	e9 62 ff ff ff       	jmp    801d13 <__umoddi3+0xb3>
