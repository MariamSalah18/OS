
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 cf 1e 00 00       	call   801f15 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 38 80 00       	push   $0x803860
  80004e:	e8 dc 09 00 00       	call   800a2f <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 38 80 00       	push   $0x803862
  80005e:	e8 cc 09 00 00       	call   800a2f <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 38 80 00       	push   $0x80387b
  80006e:	e8 bc 09 00 00       	call   800a2f <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 38 80 00       	push   $0x803862
  80007e:	e8 ac 09 00 00       	call   800a2f <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 38 80 00       	push   $0x803860
  80008e:	e8 9c 09 00 00       	call   800a2f <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 38 80 00       	push   $0x803894
  8000a5:	e8 07 10 00 00       	call   8010b1 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 57 15 00 00       	call   801617 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 89 19 00 00       	call   801a5e <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 b4 38 80 00       	push   $0x8038b4
  8000e3:	e8 47 09 00 00       	call   800a2f <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d6 38 80 00       	push   $0x8038d6
  8000f3:	e8 37 09 00 00       	call   800a2f <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e4 38 80 00       	push   $0x8038e4
  800103:	e8 27 09 00 00       	call   800a2f <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 f3 38 80 00       	push   $0x8038f3
  800113:	e8 17 09 00 00       	call   800a2f <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 03 39 80 00       	push   $0x803903
  800123:	e8 07 09 00 00       	call   800a2f <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 c8 1d 00 00       	call   801f2f <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 3b 1d 00 00       	call   801f15 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 39 80 00       	push   $0x80390c
  8001e2:	e8 48 08 00 00       	call   800a2f <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 40 1d 00 00       	call   801f2f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 40 39 80 00       	push   $0x803940
  800211:	6a 49                	push   $0x49
  800213:	68 62 39 80 00       	push   $0x803962
  800218:	e8 55 05 00 00       	call   800772 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 f3 1c 00 00       	call   801f15 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 80 39 80 00       	push   $0x803980
  80022a:	e8 00 08 00 00       	call   800a2f <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 b4 39 80 00       	push   $0x8039b4
  80023a:	e8 f0 07 00 00       	call   800a2f <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e8 39 80 00       	push   $0x8039e8
  80024a:	e8 e0 07 00 00       	call   800a2f <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 d8 1c 00 00       	call   801f2f <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 58 19 00 00       	call   801bba <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 ab 1c 00 00       	call   801f15 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 1a 3a 80 00       	push   $0x803a1a
  800272:	e8 b8 07 00 00       	call   800a2f <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 8b 1c 00 00       	call   801f2f <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 60 38 80 00       	push   $0x803860
  800549:	e8 e1 04 00 00       	call   800a2f <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 38 3a 80 00       	push   $0x803a38
  80056b:	e8 bf 04 00 00       	call   800a2f <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 3d 3a 80 00       	push   $0x803a3d
  800599:	e8 91 04 00 00       	call   800a2f <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 8c 19 00 00       	call   801f49 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 47 19 00 00       	call   801f15 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 68 19 00 00       	call   801f49 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 46 19 00 00       	call   801f2f <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 e5 17 00 00       	call   801de5 <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 fc 18 00 00       	call   801f15 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 be 17 00 00       	call   801de5 <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 fa 18 00 00       	call   801f2f <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 b9 1a 00 00       	call   802108 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 06             	shl    $0x6,%eax
  80065e:	29 d0                	sub    %edx,%eax
  800660:	c1 e0 03             	shl    $0x3,%eax
  800663:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800668:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80066d:	a1 24 50 80 00       	mov    0x805024,%eax
  800672:	8a 40 68             	mov    0x68(%eax),%al
  800675:	84 c0                	test   %al,%al
  800677:	74 0d                	je     800686 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800679:	a1 24 50 80 00       	mov    0x805024,%eax
  80067e:	83 c0 68             	add    $0x68,%eax
  800681:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800686:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80068a:	7e 0a                	jle    800696 <libmain+0x52>
		binaryname = argv[0];
  80068c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 0c             	pushl  0xc(%ebp)
  80069c:	ff 75 08             	pushl  0x8(%ebp)
  80069f:	e8 94 f9 ff ff       	call   800038 <_main>
  8006a4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006a7:	e8 69 18 00 00       	call   801f15 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ac:	83 ec 0c             	sub    $0xc,%esp
  8006af:	68 5c 3a 80 00       	push   $0x803a5c
  8006b4:	e8 76 03 00 00       	call   800a2f <cprintf>
  8006b9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006bc:	a1 24 50 80 00       	mov    0x805024,%eax
  8006c1:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8006c7:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cc:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8006d2:	83 ec 04             	sub    $0x4,%esp
  8006d5:	52                   	push   %edx
  8006d6:	50                   	push   %eax
  8006d7:	68 84 3a 80 00       	push   $0x803a84
  8006dc:	e8 4e 03 00 00       	call   800a2f <cprintf>
  8006e1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006e4:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e9:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8006ef:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f4:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  8006fa:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ff:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800705:	51                   	push   %ecx
  800706:	52                   	push   %edx
  800707:	50                   	push   %eax
  800708:	68 ac 3a 80 00       	push   $0x803aac
  80070d:	e8 1d 03 00 00       	call   800a2f <cprintf>
  800712:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800715:	a1 24 50 80 00       	mov    0x805024,%eax
  80071a:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	50                   	push   %eax
  800724:	68 04 3b 80 00       	push   $0x803b04
  800729:	e8 01 03 00 00       	call   800a2f <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800731:	83 ec 0c             	sub    $0xc,%esp
  800734:	68 5c 3a 80 00       	push   $0x803a5c
  800739:	e8 f1 02 00 00       	call   800a2f <cprintf>
  80073e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800741:	e8 e9 17 00 00       	call   801f2f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800746:	e8 19 00 00 00       	call   800764 <exit>
}
  80074b:	90                   	nop
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	6a 00                	push   $0x0
  800759:	e8 76 19 00 00       	call   8020d4 <sys_destroy_env>
  80075e:	83 c4 10             	add    $0x10,%esp
}
  800761:	90                   	nop
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <exit>:

void
exit(void)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80076a:	e8 cb 19 00 00       	call   80213a <sys_exit_env>
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800778:	8d 45 10             	lea    0x10(%ebp),%eax
  80077b:	83 c0 04             	add    $0x4,%eax
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800781:	a1 18 51 80 00       	mov    0x805118,%eax
  800786:	85 c0                	test   %eax,%eax
  800788:	74 16                	je     8007a0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80078a:	a1 18 51 80 00       	mov    0x805118,%eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	50                   	push   %eax
  800793:	68 18 3b 80 00       	push   $0x803b18
  800798:	e8 92 02 00 00       	call   800a2f <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007a0:	a1 00 50 80 00       	mov    0x805000,%eax
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 08             	pushl  0x8(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	68 1d 3b 80 00       	push   $0x803b1d
  8007b1:	e8 79 02 00 00       	call   800a2f <cprintf>
  8007b6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 fc 01 00 00       	call   8009c4 <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	6a 00                	push   $0x0
  8007d0:	68 39 3b 80 00       	push   $0x803b39
  8007d5:	e8 ea 01 00 00       	call   8009c4 <vcprintf>
  8007da:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007dd:	e8 82 ff ff ff       	call   800764 <exit>

	// should not return here
	while (1) ;
  8007e2:	eb fe                	jmp    8007e2 <_panic+0x70>

008007e4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007ea:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ef:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8007f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f8:	39 c2                	cmp    %eax,%edx
  8007fa:	74 14                	je     800810 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007fc:	83 ec 04             	sub    $0x4,%esp
  8007ff:	68 3c 3b 80 00       	push   $0x803b3c
  800804:	6a 26                	push   $0x26
  800806:	68 88 3b 80 00       	push   $0x803b88
  80080b:	e8 62 ff ff ff       	call   800772 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800817:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80081e:	e9 c5 00 00 00       	jmp    8008e8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	01 d0                	add    %edx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	85 c0                	test   %eax,%eax
  800836:	75 08                	jne    800840 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800838:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80083b:	e9 a5 00 00 00       	jmp    8008e5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800840:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800847:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80084e:	eb 69                	jmp    8008b9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800850:	a1 24 50 80 00       	mov    0x805024,%eax
  800855:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80085b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80085e:	89 d0                	mov    %edx,%eax
  800860:	01 c0                	add    %eax,%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	c1 e0 03             	shl    $0x3,%eax
  800867:	01 c8                	add    %ecx,%eax
  800869:	8a 40 04             	mov    0x4(%eax),%al
  80086c:	84 c0                	test   %al,%al
  80086e:	75 46                	jne    8008b6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80087b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087e:	89 d0                	mov    %edx,%eax
  800880:	01 c0                	add    %eax,%eax
  800882:	01 d0                	add    %edx,%eax
  800884:	c1 e0 03             	shl    $0x3,%eax
  800887:	01 c8                	add    %ecx,%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80088e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800891:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800896:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	01 c8                	add    %ecx,%eax
  8008a7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008a9:	39 c2                	cmp    %eax,%edx
  8008ab:	75 09                	jne    8008b6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008ad:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008b4:	eb 15                	jmp    8008cb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b6:	ff 45 e8             	incl   -0x18(%ebp)
  8008b9:	a1 24 50 80 00       	mov    0x805024,%eax
  8008be:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8008c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c7:	39 c2                	cmp    %eax,%edx
  8008c9:	77 85                	ja     800850 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008cf:	75 14                	jne    8008e5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008d1:	83 ec 04             	sub    $0x4,%esp
  8008d4:	68 94 3b 80 00       	push   $0x803b94
  8008d9:	6a 3a                	push   $0x3a
  8008db:	68 88 3b 80 00       	push   $0x803b88
  8008e0:	e8 8d fe ff ff       	call   800772 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008e5:	ff 45 f0             	incl   -0x10(%ebp)
  8008e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008ee:	0f 8c 2f ff ff ff    	jl     800823 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800902:	eb 26                	jmp    80092a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800904:	a1 24 50 80 00       	mov    0x805024,%eax
  800909:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80090f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800912:	89 d0                	mov    %edx,%eax
  800914:	01 c0                	add    %eax,%eax
  800916:	01 d0                	add    %edx,%eax
  800918:	c1 e0 03             	shl    $0x3,%eax
  80091b:	01 c8                	add    %ecx,%eax
  80091d:	8a 40 04             	mov    0x4(%eax),%al
  800920:	3c 01                	cmp    $0x1,%al
  800922:	75 03                	jne    800927 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800924:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800927:	ff 45 e0             	incl   -0x20(%ebp)
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800935:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	77 c8                	ja     800904 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80093c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800942:	74 14                	je     800958 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800944:	83 ec 04             	sub    $0x4,%esp
  800947:	68 e8 3b 80 00       	push   $0x803be8
  80094c:	6a 44                	push   $0x44
  80094e:	68 88 3b 80 00       	push   $0x803b88
  800953:	e8 1a fe ff ff       	call   800772 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800958:	90                   	nop
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800961:	8b 45 0c             	mov    0xc(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	8d 48 01             	lea    0x1(%eax),%ecx
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	89 0a                	mov    %ecx,(%edx)
  80096e:	8b 55 08             	mov    0x8(%ebp),%edx
  800971:	88 d1                	mov    %dl,%cl
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800984:	75 2c                	jne    8009b2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800986:	a0 28 50 80 00       	mov    0x805028,%al
  80098b:	0f b6 c0             	movzbl %al,%eax
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800991:	8b 12                	mov    (%edx),%edx
  800993:	89 d1                	mov    %edx,%ecx
  800995:	8b 55 0c             	mov    0xc(%ebp),%edx
  800998:	83 c2 08             	add    $0x8,%edx
  80099b:	83 ec 04             	sub    $0x4,%esp
  80099e:	50                   	push   %eax
  80099f:	51                   	push   %ecx
  8009a0:	52                   	push   %edx
  8009a1:	e8 16 14 00 00       	call   801dbc <sys_cputs>
  8009a6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	8b 40 04             	mov    0x4(%eax),%eax
  8009b8:	8d 50 01             	lea    0x1(%eax),%edx
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c1:	90                   	nop
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d4:	00 00 00 
	b.cnt = 0;
  8009d7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009de:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	ff 75 08             	pushl  0x8(%ebp)
  8009e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ed:	50                   	push   %eax
  8009ee:	68 5b 09 80 00       	push   $0x80095b
  8009f3:	e8 11 02 00 00       	call   800c09 <vprintfmt>
  8009f8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009fb:	a0 28 50 80 00       	mov    0x805028,%al
  800a00:	0f b6 c0             	movzbl %al,%eax
  800a03:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a09:	83 ec 04             	sub    $0x4,%esp
  800a0c:	50                   	push   %eax
  800a0d:	52                   	push   %edx
  800a0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a14:	83 c0 08             	add    $0x8,%eax
  800a17:	50                   	push   %eax
  800a18:	e8 9f 13 00 00       	call   801dbc <sys_cputs>
  800a1d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a20:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a27:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a35:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a3c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4b:	50                   	push   %eax
  800a4c:	e8 73 ff ff ff       	call   8009c4 <vcprintf>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a62:	e8 ae 14 00 00       	call   801f15 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a67:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 f4             	pushl  -0xc(%ebp)
  800a76:	50                   	push   %eax
  800a77:	e8 48 ff ff ff       	call   8009c4 <vcprintf>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a82:	e8 a8 14 00 00       	call   801f2f <sys_enable_interrupt>
	return cnt;
  800a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	53                   	push   %ebx
  800a90:	83 ec 14             	sub    $0x14,%esp
  800a93:	8b 45 10             	mov    0x10(%ebp),%eax
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a9f:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaa:	77 55                	ja     800b01 <printnum+0x75>
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	72 05                	jb     800ab6 <printnum+0x2a>
  800ab1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab4:	77 4b                	ja     800b01 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ab6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ab9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800abc:	8b 45 18             	mov    0x18(%ebp),%eax
  800abf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac4:	52                   	push   %edx
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac9:	ff 75 f0             	pushl  -0x10(%ebp)
  800acc:	e8 13 2b 00 00       	call   8035e4 <__udivdi3>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	83 ec 04             	sub    $0x4,%esp
  800ad7:	ff 75 20             	pushl  0x20(%ebp)
  800ada:	53                   	push   %ebx
  800adb:	ff 75 18             	pushl  0x18(%ebp)
  800ade:	52                   	push   %edx
  800adf:	50                   	push   %eax
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 a1 ff ff ff       	call   800a8c <printnum>
  800aeb:	83 c4 20             	add    $0x20,%esp
  800aee:	eb 1a                	jmp    800b0a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 20             	pushl  0x20(%ebp)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b01:	ff 4d 1c             	decl   0x1c(%ebp)
  800b04:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b08:	7f e6                	jg     800af0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	53                   	push   %ebx
  800b19:	51                   	push   %ecx
  800b1a:	52                   	push   %edx
  800b1b:	50                   	push   %eax
  800b1c:	e8 d3 2b 00 00       	call   8036f4 <__umoddi3>
  800b21:	83 c4 10             	add    $0x10,%esp
  800b24:	05 54 3e 80 00       	add    $0x803e54,%eax
  800b29:	8a 00                	mov    (%eax),%al
  800b2b:	0f be c0             	movsbl %al,%eax
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	50                   	push   %eax
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
}
  800b3d:	90                   	nop
  800b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b46:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4a:	7e 1c                	jle    800b68 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 08             	lea    0x8(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 08             	sub    $0x8,%eax
  800b61:	8b 50 04             	mov    0x4(%eax),%edx
  800b64:	8b 00                	mov    (%eax),%eax
  800b66:	eb 40                	jmp    800ba8 <getuint+0x65>
	else if (lflag)
  800b68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6c:	74 1e                	je     800b8c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	8d 50 04             	lea    0x4(%eax),%edx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	89 10                	mov    %edx,(%eax)
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8b 00                	mov    (%eax),%eax
  800b80:	83 e8 04             	sub    $0x4,%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8a:	eb 1c                	jmp    800ba8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	8d 50 04             	lea    0x4(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 10                	mov    %edx,(%eax)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	83 e8 04             	sub    $0x4,%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb1:	7e 1c                	jle    800bcf <getint+0x25>
		return va_arg(*ap, long long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 08             	lea    0x8(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 08             	sub    $0x8,%eax
  800bc8:	8b 50 04             	mov    0x4(%eax),%edx
  800bcb:	8b 00                	mov    (%eax),%eax
  800bcd:	eb 38                	jmp    800c07 <getint+0x5d>
	else if (lflag)
  800bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd3:	74 1a                	je     800bef <getint+0x45>
		return va_arg(*ap, long);
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	8d 50 04             	lea    0x4(%eax),%edx
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	89 10                	mov    %edx,(%eax)
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	83 e8 04             	sub    $0x4,%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	99                   	cltd   
  800bed:	eb 18                	jmp    800c07 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	8d 50 04             	lea    0x4(%eax),%edx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	89 10                	mov    %edx,(%eax)
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	83 e8 04             	sub    $0x4,%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	99                   	cltd   
}
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c11:	eb 17                	jmp    800c2a <vprintfmt+0x21>
			if (ch == '\0')
  800c13:	85 db                	test   %ebx,%ebx
  800c15:	0f 84 af 03 00 00    	je     800fca <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	53                   	push   %ebx
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2d:	8d 50 01             	lea    0x1(%eax),%edx
  800c30:	89 55 10             	mov    %edx,0x10(%ebp)
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	0f b6 d8             	movzbl %al,%ebx
  800c38:	83 fb 25             	cmp    $0x25,%ebx
  800c3b:	75 d6                	jne    800c13 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c3d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c41:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c4f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c56:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c60:	8d 50 01             	lea    0x1(%eax),%edx
  800c63:	89 55 10             	mov    %edx,0x10(%ebp)
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	0f b6 d8             	movzbl %al,%ebx
  800c6b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c6e:	83 f8 55             	cmp    $0x55,%eax
  800c71:	0f 87 2b 03 00 00    	ja     800fa2 <vprintfmt+0x399>
  800c77:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  800c7e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c80:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c84:	eb d7                	jmp    800c5d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c86:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8a:	eb d1                	jmp    800c5d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c96:	89 d0                	mov    %edx,%eax
  800c98:	c1 e0 02             	shl    $0x2,%eax
  800c9b:	01 d0                	add    %edx,%eax
  800c9d:	01 c0                	add    %eax,%eax
  800c9f:	01 d8                	add    %ebx,%eax
  800ca1:	83 e8 30             	sub    $0x30,%eax
  800ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800caf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb2:	7e 3e                	jle    800cf2 <vprintfmt+0xe9>
  800cb4:	83 fb 39             	cmp    $0x39,%ebx
  800cb7:	7f 39                	jg     800cf2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cbc:	eb d5                	jmp    800c93 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc1:	83 c0 04             	add    $0x4,%eax
  800cc4:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cca:	83 e8 04             	sub    $0x4,%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd2:	eb 1f                	jmp    800cf3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd8:	79 83                	jns    800c5d <vprintfmt+0x54>
				width = 0;
  800cda:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce1:	e9 77 ff ff ff       	jmp    800c5d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ce6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ced:	e9 6b ff ff ff       	jmp    800c5d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf7:	0f 89 60 ff ff ff    	jns    800c5d <vprintfmt+0x54>
				width = precision, precision = -1;
  800cfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d03:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0a:	e9 4e ff ff ff       	jmp    800c5d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d0f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d12:	e9 46 ff ff ff       	jmp    800c5d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d17:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1a:	83 c0 04             	add    $0x4,%eax
  800d1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d20:	8b 45 14             	mov    0x14(%ebp),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
			break;
  800d37:	e9 89 02 00 00       	jmp    800fc5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3f:	83 c0 04             	add    $0x4,%eax
  800d42:	89 45 14             	mov    %eax,0x14(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	83 e8 04             	sub    $0x4,%eax
  800d4b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d4d:	85 db                	test   %ebx,%ebx
  800d4f:	79 02                	jns    800d53 <vprintfmt+0x14a>
				err = -err;
  800d51:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d53:	83 fb 64             	cmp    $0x64,%ebx
  800d56:	7f 0b                	jg     800d63 <vprintfmt+0x15a>
  800d58:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800d5f:	85 f6                	test   %esi,%esi
  800d61:	75 19                	jne    800d7c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d63:	53                   	push   %ebx
  800d64:	68 65 3e 80 00       	push   $0x803e65
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	e8 5e 02 00 00       	call   800fd2 <printfmt>
  800d74:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d77:	e9 49 02 00 00       	jmp    800fc5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d7c:	56                   	push   %esi
  800d7d:	68 6e 3e 80 00       	push   $0x803e6e
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	ff 75 08             	pushl  0x8(%ebp)
  800d88:	e8 45 02 00 00       	call   800fd2 <printfmt>
  800d8d:	83 c4 10             	add    $0x10,%esp
			break;
  800d90:	e9 30 02 00 00       	jmp    800fc5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d95:	8b 45 14             	mov    0x14(%ebp),%eax
  800d98:	83 c0 04             	add    $0x4,%eax
  800d9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800da1:	83 e8 04             	sub    $0x4,%eax
  800da4:	8b 30                	mov    (%eax),%esi
  800da6:	85 f6                	test   %esi,%esi
  800da8:	75 05                	jne    800daf <vprintfmt+0x1a6>
				p = "(null)";
  800daa:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  800daf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db3:	7e 6d                	jle    800e22 <vprintfmt+0x219>
  800db5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800db9:	74 67                	je     800e22 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dbe:	83 ec 08             	sub    $0x8,%esp
  800dc1:	50                   	push   %eax
  800dc2:	56                   	push   %esi
  800dc3:	e8 12 05 00 00       	call   8012da <strnlen>
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dce:	eb 16                	jmp    800de6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	ff d0                	call   *%eax
  800de0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de3:	ff 4d e4             	decl   -0x1c(%ebp)
  800de6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dea:	7f e4                	jg     800dd0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dec:	eb 34                	jmp    800e22 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df2:	74 1c                	je     800e10 <vprintfmt+0x207>
  800df4:	83 fb 1f             	cmp    $0x1f,%ebx
  800df7:	7e 05                	jle    800dfe <vprintfmt+0x1f5>
  800df9:	83 fb 7e             	cmp    $0x7e,%ebx
  800dfc:	7e 12                	jle    800e10 <vprintfmt+0x207>
					putch('?', putdat);
  800dfe:	83 ec 08             	sub    $0x8,%esp
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	6a 3f                	push   $0x3f
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	ff d0                	call   *%eax
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	eb 0f                	jmp    800e1f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	53                   	push   %ebx
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e22:	89 f0                	mov    %esi,%eax
  800e24:	8d 70 01             	lea    0x1(%eax),%esi
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f be d8             	movsbl %al,%ebx
  800e2c:	85 db                	test   %ebx,%ebx
  800e2e:	74 24                	je     800e54 <vprintfmt+0x24b>
  800e30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e34:	78 b8                	js     800dee <vprintfmt+0x1e5>
  800e36:	ff 4d e0             	decl   -0x20(%ebp)
  800e39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e3d:	79 af                	jns    800dee <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e3f:	eb 13                	jmp    800e54 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 20                	push   $0x20
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e51:	ff 4d e4             	decl   -0x1c(%ebp)
  800e54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e58:	7f e7                	jg     800e41 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5a:	e9 66 01 00 00       	jmp    800fc5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 e8             	pushl  -0x18(%ebp)
  800e65:	8d 45 14             	lea    0x14(%ebp),%eax
  800e68:	50                   	push   %eax
  800e69:	e8 3c fd ff ff       	call   800baa <getint>
  800e6e:	83 c4 10             	add    $0x10,%esp
  800e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e74:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7d:	85 d2                	test   %edx,%edx
  800e7f:	79 23                	jns    800ea4 <vprintfmt+0x29b>
				putch('-', putdat);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	6a 2d                	push   $0x2d
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	ff d0                	call   *%eax
  800e8e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e97:	f7 d8                	neg    %eax
  800e99:	83 d2 00             	adc    $0x0,%edx
  800e9c:	f7 da                	neg    %edx
  800e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eab:	e9 bc 00 00 00       	jmp    800f6c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb0:	83 ec 08             	sub    $0x8,%esp
  800eb3:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb6:	8d 45 14             	lea    0x14(%ebp),%eax
  800eb9:	50                   	push   %eax
  800eba:	e8 84 fc ff ff       	call   800b43 <getuint>
  800ebf:	83 c4 10             	add    $0x10,%esp
  800ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ec8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecf:	e9 98 00 00 00       	jmp    800f6c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	ff 75 0c             	pushl  0xc(%ebp)
  800eda:	6a 58                	push   $0x58
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	ff d0                	call   *%eax
  800ee1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee4:	83 ec 08             	sub    $0x8,%esp
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	6a 58                	push   $0x58
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			break;
  800f04:	e9 bc 00 00 00       	jmp    800fc5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	6a 30                	push   $0x30
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	ff d0                	call   *%eax
  800f16:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f19:	83 ec 08             	sub    $0x8,%esp
  800f1c:	ff 75 0c             	pushl  0xc(%ebp)
  800f1f:	6a 78                	push   $0x78
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	ff d0                	call   *%eax
  800f26:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f29:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2c:	83 c0 04             	add    $0x4,%eax
  800f2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	83 e8 04             	sub    $0x4,%eax
  800f38:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f44:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f4b:	eb 1f                	jmp    800f6c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 e8             	pushl  -0x18(%ebp)
  800f53:	8d 45 14             	lea    0x14(%ebp),%eax
  800f56:	50                   	push   %eax
  800f57:	e8 e7 fb ff ff       	call   800b43 <getuint>
  800f5c:	83 c4 10             	add    $0x10,%esp
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f65:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f6c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	52                   	push   %edx
  800f77:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7e:	ff 75 f0             	pushl  -0x10(%ebp)
  800f81:	ff 75 0c             	pushl  0xc(%ebp)
  800f84:	ff 75 08             	pushl  0x8(%ebp)
  800f87:	e8 00 fb ff ff       	call   800a8c <printnum>
  800f8c:	83 c4 20             	add    $0x20,%esp
			break;
  800f8f:	eb 34                	jmp    800fc5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	53                   	push   %ebx
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	ff d0                	call   *%eax
  800f9d:	83 c4 10             	add    $0x10,%esp
			break;
  800fa0:	eb 23                	jmp    800fc5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	ff 75 0c             	pushl  0xc(%ebp)
  800fa8:	6a 25                	push   $0x25
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	ff d0                	call   *%eax
  800faf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb2:	ff 4d 10             	decl   0x10(%ebp)
  800fb5:	eb 03                	jmp    800fba <vprintfmt+0x3b1>
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	48                   	dec    %eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	3c 25                	cmp    $0x25,%al
  800fc2:	75 f3                	jne    800fb7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc4:	90                   	nop
		}
	}
  800fc5:	e9 47 fc ff ff       	jmp    800c11 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fca:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fd8:	8d 45 10             	lea    0x10(%ebp),%eax
  800fdb:	83 c0 04             	add    $0x4,%eax
  800fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe7:	50                   	push   %eax
  800fe8:	ff 75 0c             	pushl  0xc(%ebp)
  800feb:	ff 75 08             	pushl  0x8(%ebp)
  800fee:	e8 16 fc ff ff       	call   800c09 <vprintfmt>
  800ff3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ff6:	90                   	nop
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	8b 40 08             	mov    0x8(%eax),%eax
  801002:	8d 50 01             	lea    0x1(%eax),%edx
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	8b 10                	mov    (%eax),%edx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 40 04             	mov    0x4(%eax),%eax
  801016:	39 c2                	cmp    %eax,%edx
  801018:	73 12                	jae    80102c <sprintputch+0x33>
		*b->buf++ = ch;
  80101a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101d:	8b 00                	mov    (%eax),%eax
  80101f:	8d 48 01             	lea    0x1(%eax),%ecx
  801022:	8b 55 0c             	mov    0xc(%ebp),%edx
  801025:	89 0a                	mov    %ecx,(%edx)
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	88 10                	mov    %dl,(%eax)
}
  80102c:	90                   	nop
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801049:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801050:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801054:	74 06                	je     80105c <vsnprintf+0x2d>
  801056:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105a:	7f 07                	jg     801063 <vsnprintf+0x34>
		return -E_INVAL;
  80105c:	b8 03 00 00 00       	mov    $0x3,%eax
  801061:	eb 20                	jmp    801083 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801063:	ff 75 14             	pushl  0x14(%ebp)
  801066:	ff 75 10             	pushl  0x10(%ebp)
  801069:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80106c:	50                   	push   %eax
  80106d:	68 f9 0f 80 00       	push   $0x800ff9
  801072:	e8 92 fb ff ff       	call   800c09 <vprintfmt>
  801077:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80107d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801080:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801083:	c9                   	leave  
  801084:	c3                   	ret    

00801085 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80108b:	8d 45 10             	lea    0x10(%ebp),%eax
  80108e:	83 c0 04             	add    $0x4,%eax
  801091:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801094:	8b 45 10             	mov    0x10(%ebp),%eax
  801097:	ff 75 f4             	pushl  -0xc(%ebp)
  80109a:	50                   	push   %eax
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	ff 75 08             	pushl  0x8(%ebp)
  8010a1:	e8 89 ff ff ff       	call   80102f <vsnprintf>
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    

008010b1 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bb:	74 13                	je     8010d0 <readline+0x1f>
		cprintf("%s", prompt);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 08             	pushl  0x8(%ebp)
  8010c3:	68 d0 3f 80 00       	push   $0x803fd0
  8010c8:	e8 62 f9 ff ff       	call   800a2f <cprintf>
  8010cd:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 59 f5 ff ff       	call   80063a <iscons>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010e7:	e8 00 f5 ff ff       	call   8005ec <getchar>
  8010ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f3:	79 22                	jns    801117 <readline+0x66>
			if (c != -E_EOF)
  8010f5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010f9:	0f 84 ad 00 00 00    	je     8011ac <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	ff 75 ec             	pushl  -0x14(%ebp)
  801105:	68 d3 3f 80 00       	push   $0x803fd3
  80110a:	e8 20 f9 ff ff       	call   800a2f <cprintf>
  80110f:	83 c4 10             	add    $0x10,%esp
			return;
  801112:	e9 95 00 00 00       	jmp    8011ac <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801117:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80111b:	7e 34                	jle    801151 <readline+0xa0>
  80111d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801124:	7f 2b                	jg     801151 <readline+0xa0>
			if (echoing)
  801126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112a:	74 0e                	je     80113a <readline+0x89>
				cputchar(c);
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	ff 75 ec             	pushl  -0x14(%ebp)
  801132:	e8 6d f4 ff ff       	call   8005a4 <cputchar>
  801137:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113d:	8d 50 01             	lea    0x1(%eax),%edx
  801140:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801143:	89 c2                	mov    %eax,%edx
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	01 d0                	add    %edx,%eax
  80114a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80114d:	88 10                	mov    %dl,(%eax)
  80114f:	eb 56                	jmp    8011a7 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801151:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801155:	75 1f                	jne    801176 <readline+0xc5>
  801157:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80115b:	7e 19                	jle    801176 <readline+0xc5>
			if (echoing)
  80115d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801161:	74 0e                	je     801171 <readline+0xc0>
				cputchar(c);
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	ff 75 ec             	pushl  -0x14(%ebp)
  801169:	e8 36 f4 ff ff       	call   8005a4 <cputchar>
  80116e:	83 c4 10             	add    $0x10,%esp

			i--;
  801171:	ff 4d f4             	decl   -0xc(%ebp)
  801174:	eb 31                	jmp    8011a7 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801176:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117a:	74 0a                	je     801186 <readline+0xd5>
  80117c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801180:	0f 85 61 ff ff ff    	jne    8010e7 <readline+0x36>
			if (echoing)
  801186:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118a:	74 0e                	je     80119a <readline+0xe9>
				cputchar(c);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	ff 75 ec             	pushl  -0x14(%ebp)
  801192:	e8 0d f4 ff ff       	call   8005a4 <cputchar>
  801197:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011a5:	eb 06                	jmp    8011ad <readline+0xfc>
		}
	}
  8011a7:	e9 3b ff ff ff       	jmp    8010e7 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011ac:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011b5:	e8 5b 0d 00 00       	call   801f15 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011be:	74 13                	je     8011d3 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c0:	83 ec 08             	sub    $0x8,%esp
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	68 d0 3f 80 00       	push   $0x803fd0
  8011cb:	e8 5f f8 ff ff       	call   800a2f <cprintf>
  8011d0:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	6a 00                	push   $0x0
  8011df:	e8 56 f4 ff ff       	call   80063a <iscons>
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ea:	e8 fd f3 ff ff       	call   8005ec <getchar>
  8011ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011f6:	79 23                	jns    80121b <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011f8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011fc:	74 13                	je     801211 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011fe:	83 ec 08             	sub    $0x8,%esp
  801201:	ff 75 ec             	pushl  -0x14(%ebp)
  801204:	68 d3 3f 80 00       	push   $0x803fd3
  801209:	e8 21 f8 ff ff       	call   800a2f <cprintf>
  80120e:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801211:	e8 19 0d 00 00       	call   801f2f <sys_enable_interrupt>
			return;
  801216:	e9 9a 00 00 00       	jmp    8012b5 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80121b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80121f:	7e 34                	jle    801255 <atomic_readline+0xa6>
  801221:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801228:	7f 2b                	jg     801255 <atomic_readline+0xa6>
			if (echoing)
  80122a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80122e:	74 0e                	je     80123e <atomic_readline+0x8f>
				cputchar(c);
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	ff 75 ec             	pushl  -0x14(%ebp)
  801236:	e8 69 f3 ff ff       	call   8005a4 <cputchar>
  80123b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80123e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801241:	8d 50 01             	lea    0x1(%eax),%edx
  801244:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801247:	89 c2                	mov    %eax,%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
  801253:	eb 5b                	jmp    8012b0 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801255:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801259:	75 1f                	jne    80127a <atomic_readline+0xcb>
  80125b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80125f:	7e 19                	jle    80127a <atomic_readline+0xcb>
			if (echoing)
  801261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801265:	74 0e                	je     801275 <atomic_readline+0xc6>
				cputchar(c);
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	ff 75 ec             	pushl  -0x14(%ebp)
  80126d:	e8 32 f3 ff ff       	call   8005a4 <cputchar>
  801272:	83 c4 10             	add    $0x10,%esp
			i--;
  801275:	ff 4d f4             	decl   -0xc(%ebp)
  801278:	eb 36                	jmp    8012b0 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80127e:	74 0a                	je     80128a <atomic_readline+0xdb>
  801280:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801284:	0f 85 60 ff ff ff    	jne    8011ea <atomic_readline+0x3b>
			if (echoing)
  80128a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128e:	74 0e                	je     80129e <atomic_readline+0xef>
				cputchar(c);
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	ff 75 ec             	pushl  -0x14(%ebp)
  801296:	e8 09 f3 ff ff       	call   8005a4 <cputchar>
  80129b:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80129e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012a9:	e8 81 0c 00 00       	call   801f2f <sys_enable_interrupt>
			return;
  8012ae:	eb 05                	jmp    8012b5 <atomic_readline+0x106>
		}
	}
  8012b0:	e9 35 ff ff ff       	jmp    8011ea <atomic_readline+0x3b>
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c4:	eb 06                	jmp    8012cc <strlen+0x15>
		n++;
  8012c6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c9:	ff 45 08             	incl   0x8(%ebp)
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	84 c0                	test   %al,%al
  8012d3:	75 f1                	jne    8012c6 <strlen+0xf>
		n++;
	return n;
  8012d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e7:	eb 09                	jmp    8012f2 <strnlen+0x18>
		n++;
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	ff 4d 0c             	decl   0xc(%ebp)
  8012f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f6:	74 09                	je     801301 <strnlen+0x27>
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	84 c0                	test   %al,%al
  8012ff:	75 e8                	jne    8012e9 <strnlen+0xf>
		n++;
	return n;
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801312:	90                   	nop
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8d 50 01             	lea    0x1(%eax),%edx
  801319:	89 55 08             	mov    %edx,0x8(%ebp)
  80131c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801322:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801325:	8a 12                	mov    (%edx),%dl
  801327:	88 10                	mov    %dl,(%eax)
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	75 e4                	jne    801313 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80132f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801347:	eb 1f                	jmp    801368 <strncpy+0x34>
		*dst++ = *src;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8d 50 01             	lea    0x1(%eax),%edx
  80134f:	89 55 08             	mov    %edx,0x8(%ebp)
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	8a 12                	mov    (%edx),%dl
  801357:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 03                	je     801365 <strncpy+0x31>
			src++;
  801362:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801365:	ff 45 fc             	incl   -0x4(%ebp)
  801368:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80136e:	72 d9                	jb     801349 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801370:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801385:	74 30                	je     8013b7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801387:	eb 16                	jmp    80139f <strlcpy+0x2a>
			*dst++ = *src++;
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8d 50 01             	lea    0x1(%eax),%edx
  80138f:	89 55 08             	mov    %edx,0x8(%ebp)
  801392:	8b 55 0c             	mov    0xc(%ebp),%edx
  801395:	8d 4a 01             	lea    0x1(%edx),%ecx
  801398:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80139b:	8a 12                	mov    (%edx),%dl
  80139d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80139f:	ff 4d 10             	decl   0x10(%ebp)
  8013a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a6:	74 09                	je     8013b1 <strlcpy+0x3c>
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	84 c0                	test   %al,%al
  8013af:	75 d8                	jne    801389 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bd:	29 c2                	sub    %eax,%edx
  8013bf:	89 d0                	mov    %edx,%eax
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013c6:	eb 06                	jmp    8013ce <strcmp+0xb>
		p++, q++;
  8013c8:	ff 45 08             	incl   0x8(%ebp)
  8013cb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	84 c0                	test   %al,%al
  8013d5:	74 0e                	je     8013e5 <strcmp+0x22>
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 10                	mov    (%eax),%dl
  8013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	38 c2                	cmp    %al,%dl
  8013e3:	74 e3                	je     8013c8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	0f b6 d0             	movzbl %al,%edx
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	0f b6 c0             	movzbl %al,%eax
  8013f5:	29 c2                	sub    %eax,%edx
  8013f7:	89 d0                	mov    %edx,%eax
}
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013fe:	eb 09                	jmp    801409 <strncmp+0xe>
		n--, p++, q++;
  801400:	ff 4d 10             	decl   0x10(%ebp)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140d:	74 17                	je     801426 <strncmp+0x2b>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	84 c0                	test   %al,%al
  801416:	74 0e                	je     801426 <strncmp+0x2b>
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 10                	mov    (%eax),%dl
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	38 c2                	cmp    %al,%dl
  801424:	74 da                	je     801400 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801426:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142a:	75 07                	jne    801433 <strncmp+0x38>
		return 0;
  80142c:	b8 00 00 00 00       	mov    $0x0,%eax
  801431:	eb 14                	jmp    801447 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	0f b6 d0             	movzbl %al,%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	0f b6 c0             	movzbl %al,%eax
  801443:	29 c2                	sub    %eax,%edx
  801445:	89 d0                	mov    %edx,%eax
}
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    

00801449 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801455:	eb 12                	jmp    801469 <strchr+0x20>
		if (*s == c)
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80145f:	75 05                	jne    801466 <strchr+0x1d>
			return (char *) s;
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	eb 11                	jmp    801477 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801466:	ff 45 08             	incl   0x8(%ebp)
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	84 c0                	test   %al,%al
  801470:	75 e5                	jne    801457 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801472:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801485:	eb 0d                	jmp    801494 <strfind+0x1b>
		if (*s == c)
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80148f:	74 0e                	je     80149f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801491:	ff 45 08             	incl   0x8(%ebp)
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	84 c0                	test   %al,%al
  80149b:	75 ea                	jne    801487 <strfind+0xe>
  80149d:	eb 01                	jmp    8014a0 <strfind+0x27>
		if (*s == c)
			break;
  80149f:	90                   	nop
	return (char *) s;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014b7:	eb 0e                	jmp    8014c7 <memset+0x22>
		*p++ = c;
  8014b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bc:	8d 50 01             	lea    0x1(%eax),%edx
  8014bf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014c7:	ff 4d f8             	decl   -0x8(%ebp)
  8014ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014ce:	79 e9                	jns    8014b9 <memset+0x14>
		*p++ = c;

	return v;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014e7:	eb 16                	jmp    8014ff <memcpy+0x2a>
		*d++ = *s++;
  8014e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ec:	8d 50 01             	lea    0x1(%eax),%edx
  8014ef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014fb:	8a 12                	mov    (%edx),%dl
  8014fd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801502:	8d 50 ff             	lea    -0x1(%eax),%edx
  801505:	89 55 10             	mov    %edx,0x10(%ebp)
  801508:	85 c0                	test   %eax,%eax
  80150a:	75 dd                	jne    8014e9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801526:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801529:	73 50                	jae    80157b <memmove+0x6a>
  80152b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	01 d0                	add    %edx,%eax
  801533:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801536:	76 43                	jbe    80157b <memmove+0x6a>
		s += n;
  801538:	8b 45 10             	mov    0x10(%ebp),%eax
  80153b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80153e:	8b 45 10             	mov    0x10(%ebp),%eax
  801541:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801544:	eb 10                	jmp    801556 <memmove+0x45>
			*--d = *--s;
  801546:	ff 4d f8             	decl   -0x8(%ebp)
  801549:	ff 4d fc             	decl   -0x4(%ebp)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 e3                	jne    801546 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801563:	eb 23                	jmp    801588 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801565:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801568:	8d 50 01             	lea    0x1(%eax),%edx
  80156b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80156e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801571:	8d 4a 01             	lea    0x1(%edx),%ecx
  801574:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801577:	8a 12                	mov    (%edx),%dl
  801579:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80157b:	8b 45 10             	mov    0x10(%ebp),%eax
  80157e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801581:	89 55 10             	mov    %edx,0x10(%ebp)
  801584:	85 c0                	test   %eax,%eax
  801586:	75 dd                	jne    801565 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80159f:	eb 2a                	jmp    8015cb <memcmp+0x3e>
		if (*s1 != *s2)
  8015a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a4:	8a 10                	mov    (%eax),%dl
  8015a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	38 c2                	cmp    %al,%dl
  8015ad:	74 16                	je     8015c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b2:	8a 00                	mov    (%eax),%al
  8015b4:	0f b6 d0             	movzbl %al,%edx
  8015b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ba:	8a 00                	mov    (%eax),%al
  8015bc:	0f b6 c0             	movzbl %al,%eax
  8015bf:	29 c2                	sub    %eax,%edx
  8015c1:	89 d0                	mov    %edx,%eax
  8015c3:	eb 18                	jmp    8015dd <memcmp+0x50>
		s1++, s2++;
  8015c5:	ff 45 fc             	incl   -0x4(%ebp)
  8015c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	75 c9                	jne    8015a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f0:	eb 15                	jmp    801607 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8a 00                	mov    (%eax),%al
  8015f7:	0f b6 d0             	movzbl %al,%edx
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	0f b6 c0             	movzbl %al,%eax
  801600:	39 c2                	cmp    %eax,%edx
  801602:	74 0d                	je     801611 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80160d:	72 e3                	jb     8015f2 <memfind+0x13>
  80160f:	eb 01                	jmp    801612 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801611:	90                   	nop
	return (void *) s;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80161d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801624:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162b:	eb 03                	jmp    801630 <strtol+0x19>
		s++;
  80162d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8a 00                	mov    (%eax),%al
  801635:	3c 20                	cmp    $0x20,%al
  801637:	74 f4                	je     80162d <strtol+0x16>
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	3c 09                	cmp    $0x9,%al
  801640:	74 eb                	je     80162d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2b                	cmp    $0x2b,%al
  801649:	75 05                	jne    801650 <strtol+0x39>
		s++;
  80164b:	ff 45 08             	incl   0x8(%ebp)
  80164e:	eb 13                	jmp    801663 <strtol+0x4c>
	else if (*s == '-')
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	8a 00                	mov    (%eax),%al
  801655:	3c 2d                	cmp    $0x2d,%al
  801657:	75 0a                	jne    801663 <strtol+0x4c>
		s++, neg = 1;
  801659:	ff 45 08             	incl   0x8(%ebp)
  80165c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801663:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801667:	74 06                	je     80166f <strtol+0x58>
  801669:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80166d:	75 20                	jne    80168f <strtol+0x78>
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	3c 30                	cmp    $0x30,%al
  801676:	75 17                	jne    80168f <strtol+0x78>
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	40                   	inc    %eax
  80167c:	8a 00                	mov    (%eax),%al
  80167e:	3c 78                	cmp    $0x78,%al
  801680:	75 0d                	jne    80168f <strtol+0x78>
		s += 2, base = 16;
  801682:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801686:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80168d:	eb 28                	jmp    8016b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80168f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801693:	75 15                	jne    8016aa <strtol+0x93>
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	8a 00                	mov    (%eax),%al
  80169a:	3c 30                	cmp    $0x30,%al
  80169c:	75 0c                	jne    8016aa <strtol+0x93>
		s++, base = 8;
  80169e:	ff 45 08             	incl   0x8(%ebp)
  8016a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016a8:	eb 0d                	jmp    8016b7 <strtol+0xa0>
	else if (base == 0)
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	75 07                	jne    8016b7 <strtol+0xa0>
		base = 10;
  8016b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	3c 2f                	cmp    $0x2f,%al
  8016be:	7e 19                	jle    8016d9 <strtol+0xc2>
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	3c 39                	cmp    $0x39,%al
  8016c7:	7f 10                	jg     8016d9 <strtol+0xc2>
			dig = *s - '0';
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	0f be c0             	movsbl %al,%eax
  8016d1:	83 e8 30             	sub    $0x30,%eax
  8016d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d7:	eb 42                	jmp    80171b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	3c 60                	cmp    $0x60,%al
  8016e0:	7e 19                	jle    8016fb <strtol+0xe4>
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	3c 7a                	cmp    $0x7a,%al
  8016e9:	7f 10                	jg     8016fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f be c0             	movsbl %al,%eax
  8016f3:	83 e8 57             	sub    $0x57,%eax
  8016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f9:	eb 20                	jmp    80171b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	3c 40                	cmp    $0x40,%al
  801702:	7e 39                	jle    80173d <strtol+0x126>
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3c 5a                	cmp    $0x5a,%al
  80170b:	7f 30                	jg     80173d <strtol+0x126>
			dig = *s - 'A' + 10;
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	0f be c0             	movsbl %al,%eax
  801715:	83 e8 37             	sub    $0x37,%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801721:	7d 19                	jge    80173c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801723:	ff 45 08             	incl   0x8(%ebp)
  801726:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801729:	0f af 45 10          	imul   0x10(%ebp),%eax
  80172d:	89 c2                	mov    %eax,%edx
  80172f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801732:	01 d0                	add    %edx,%eax
  801734:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801737:	e9 7b ff ff ff       	jmp    8016b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80173c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80173d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801741:	74 08                	je     80174b <strtol+0x134>
		*endptr = (char *) s;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 55 08             	mov    0x8(%ebp),%edx
  801749:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80174b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80174f:	74 07                	je     801758 <strtol+0x141>
  801751:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801754:	f7 d8                	neg    %eax
  801756:	eb 03                	jmp    80175b <strtol+0x144>
  801758:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <ltostr>:

void
ltostr(long value, char *str)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801763:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801771:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801775:	79 13                	jns    80178a <ltostr+0x2d>
	{
		neg = 1;
  801777:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80177e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801781:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801784:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801787:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801792:	99                   	cltd   
  801793:	f7 f9                	idiv   %ecx
  801795:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801798:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179b:	8d 50 01             	lea    0x1(%eax),%edx
  80179e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017ab:	83 c2 30             	add    $0x30,%edx
  8017ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017b8:	f7 e9                	imul   %ecx
  8017ba:	c1 fa 02             	sar    $0x2,%edx
  8017bd:	89 c8                	mov    %ecx,%eax
  8017bf:	c1 f8 1f             	sar    $0x1f,%eax
  8017c2:	29 c2                	sub    %eax,%edx
  8017c4:	89 d0                	mov    %edx,%eax
  8017c6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d1:	f7 e9                	imul   %ecx
  8017d3:	c1 fa 02             	sar    $0x2,%edx
  8017d6:	89 c8                	mov    %ecx,%eax
  8017d8:	c1 f8 1f             	sar    $0x1f,%eax
  8017db:	29 c2                	sub    %eax,%edx
  8017dd:	89 d0                	mov    %edx,%eax
  8017df:	c1 e0 02             	shl    $0x2,%eax
  8017e2:	01 d0                	add    %edx,%eax
  8017e4:	01 c0                	add    %eax,%eax
  8017e6:	29 c1                	sub    %eax,%ecx
  8017e8:	89 ca                	mov    %ecx,%edx
  8017ea:	85 d2                	test   %edx,%edx
  8017ec:	75 9c                	jne    80178a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f8:	48                   	dec    %eax
  8017f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801800:	74 3d                	je     80183f <ltostr+0xe2>
		start = 1 ;
  801802:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801809:	eb 34                	jmp    80183f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80180b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801811:	01 d0                	add    %edx,%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	01 c2                	add    %eax,%edx
  801820:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	01 c8                	add    %ecx,%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80182c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801832:	01 c2                	add    %eax,%edx
  801834:	8a 45 eb             	mov    -0x15(%ebp),%al
  801837:	88 02                	mov    %al,(%edx)
		start++ ;
  801839:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80183c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801845:	7c c4                	jl     80180b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801847:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184d:	01 d0                	add    %edx,%eax
  80184f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80185b:	ff 75 08             	pushl  0x8(%ebp)
  80185e:	e8 54 fa ff ff       	call   8012b7 <strlen>
  801863:	83 c4 04             	add    $0x4,%esp
  801866:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	e8 46 fa ff ff       	call   8012b7 <strlen>
  801871:	83 c4 04             	add    $0x4,%esp
  801874:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801877:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80187e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801885:	eb 17                	jmp    80189e <strcconcat+0x49>
		final[s] = str1[s] ;
  801887:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188a:	8b 45 10             	mov    0x10(%ebp),%eax
  80188d:	01 c2                	add    %eax,%edx
  80188f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	01 c8                	add    %ecx,%eax
  801897:	8a 00                	mov    (%eax),%al
  801899:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80189b:	ff 45 fc             	incl   -0x4(%ebp)
  80189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a4:	7c e1                	jl     801887 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b4:	eb 1f                	jmp    8018d5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b9:	8d 50 01             	lea    0x1(%eax),%edx
  8018bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018bf:	89 c2                	mov    %eax,%edx
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d2:	ff 45 f8             	incl   -0x8(%ebp)
  8018d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018db:	7c d9                	jl     8018b6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	01 d0                	add    %edx,%eax
  8018e5:	c6 00 00             	movb   $0x0,(%eax)
}
  8018e8:	90                   	nop
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fa:	8b 00                	mov    (%eax),%eax
  8018fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801903:	8b 45 10             	mov    0x10(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80190e:	eb 0c                	jmp    80191c <strsplit+0x31>
			*string++ = 0;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8d 50 01             	lea    0x1(%eax),%edx
  801916:	89 55 08             	mov    %edx,0x8(%ebp)
  801919:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	8a 00                	mov    (%eax),%al
  801921:	84 c0                	test   %al,%al
  801923:	74 18                	je     80193d <strsplit+0x52>
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	0f be c0             	movsbl %al,%eax
  80192d:	50                   	push   %eax
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	e8 13 fb ff ff       	call   801449 <strchr>
  801936:	83 c4 08             	add    $0x8,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	75 d3                	jne    801910 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8a 00                	mov    (%eax),%al
  801942:	84 c0                	test   %al,%al
  801944:	74 5a                	je     8019a0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801946:	8b 45 14             	mov    0x14(%ebp),%eax
  801949:	8b 00                	mov    (%eax),%eax
  80194b:	83 f8 0f             	cmp    $0xf,%eax
  80194e:	75 07                	jne    801957 <strsplit+0x6c>
		{
			return 0;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
  801955:	eb 66                	jmp    8019bd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801957:	8b 45 14             	mov    0x14(%ebp),%eax
  80195a:	8b 00                	mov    (%eax),%eax
  80195c:	8d 48 01             	lea    0x1(%eax),%ecx
  80195f:	8b 55 14             	mov    0x14(%ebp),%edx
  801962:	89 0a                	mov    %ecx,(%edx)
  801964:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	01 c2                	add    %eax,%edx
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801975:	eb 03                	jmp    80197a <strsplit+0x8f>
			string++;
  801977:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	84 c0                	test   %al,%al
  801981:	74 8b                	je     80190e <strsplit+0x23>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	0f be c0             	movsbl %al,%eax
  80198b:	50                   	push   %eax
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	e8 b5 fa ff ff       	call   801449 <strchr>
  801994:	83 c4 08             	add    $0x8,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	74 dc                	je     801977 <strsplit+0x8c>
			string++;
	}
  80199b:	e9 6e ff ff ff       	jmp    80190e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a4:	8b 00                	mov    (%eax),%eax
  8019a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b0:	01 d0                	add    %edx,%eax
  8019b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8019c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019cc:	eb 4c                	jmp    801a1a <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8019ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	3c 40                	cmp    $0x40,%al
  8019da:	7e 27                	jle    801a03 <str2lower+0x44>
  8019dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e2:	01 d0                	add    %edx,%eax
  8019e4:	8a 00                	mov    (%eax),%al
  8019e6:	3c 5a                	cmp    $0x5a,%al
  8019e8:	7f 19                	jg     801a03 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8019ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	01 d0                	add    %edx,%eax
  8019f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	01 ca                	add    %ecx,%edx
  8019fa:	8a 12                	mov    (%edx),%dl
  8019fc:	83 c2 20             	add    $0x20,%edx
  8019ff:	88 10                	mov    %dl,(%eax)
  801a01:	eb 14                	jmp    801a17 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801a03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	01 c2                	add    %eax,%edx
  801a0b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	01 c8                	add    %ecx,%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801a17:	ff 45 fc             	incl   -0x4(%ebp)
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	e8 95 f8 ff ff       	call   8012b7 <strlen>
  801a22:	83 c4 04             	add    $0x4,%esp
  801a25:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a28:	7f a4                	jg     8019ce <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801a32:	a1 04 50 80 00       	mov    0x805004,%eax
  801a37:	85 c0                	test   %eax,%eax
  801a39:	74 0a                	je     801a45 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a3b:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a42:	00 00 00 
	}
}
  801a45:	90                   	nop
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    

00801a48 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801a4e:	83 ec 0c             	sub    $0xc,%esp
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	e8 7e 09 00 00       	call   8023d7 <sys_sbrk>
  801a59:	83 c4 10             	add    $0x10,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a64:	e8 c6 ff ff ff       	call   801a2f <InitializeUHeap>
	if (size == 0)
  801a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a6d:	75 0a                	jne    801a79 <malloc+0x1b>
		return NULL;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a74:	e9 3f 01 00 00       	jmp    801bb8 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801a79:	e8 ac 09 00 00       	call   80242a <sys_get_hard_limit>
  801a7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8b:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801a90:	c1 e8 0c             	shr    $0xc,%eax
  801a93:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801a96:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	48                   	dec    %eax
  801aa6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801aa9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aac:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab1:	f7 75 d8             	divl   -0x28(%ebp)
  801ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ab7:	29 d0                	sub    %edx,%eax
  801ab9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801abc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801abf:	c1 e8 0c             	shr    $0xc,%eax
  801ac2:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801ac5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ac9:	75 0a                	jne    801ad5 <malloc+0x77>
		return NULL;
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	e9 e3 00 00 00       	jmp    801bb8 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad8:	05 00 00 00 80       	add    $0x80000000,%eax
  801add:	c1 e8 0c             	shr    $0xc,%eax
  801ae0:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801ae5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801aec:	77 19                	ja     801b07 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	e8 60 0b 00 00       	call   802659 <alloc_block_FF>
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b02:	e9 b1 00 00 00       	jmp    801bb8 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b0d:	eb 4d                	jmp    801b5c <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b12:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801b19:	84 c0                	test   %al,%al
  801b1b:	75 27                	jne    801b44 <malloc+0xe6>
			{
				counter++;
  801b1d:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801b20:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801b24:	75 14                	jne    801b3a <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b29:	05 00 00 08 00       	add    $0x80000,%eax
  801b2e:	c1 e0 0c             	shl    $0xc,%eax
  801b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801b40:	75 17                	jne    801b59 <malloc+0xfb>
				{
					break;
  801b42:	eb 21                	jmp    801b65 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b47:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801b4e:	3c 01                	cmp    $0x1,%al
  801b50:	75 07                	jne    801b59 <malloc+0xfb>
			{
				counter = 0;
  801b52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801b59:	ff 45 e8             	incl   -0x18(%ebp)
  801b5c:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801b63:	76 aa                	jbe    801b0f <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b68:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801b6b:	75 46                	jne    801bb3 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801b6d:	83 ec 08             	sub    $0x8,%esp
  801b70:	ff 75 d0             	pushl  -0x30(%ebp)
  801b73:	ff 75 f4             	pushl  -0xc(%ebp)
  801b76:	e8 93 08 00 00       	call   80240e <sys_allocate_user_mem>
  801b7b:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801b84:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b91:	eb 0e                	jmp    801ba1 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b96:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  801b9d:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801b9e:	ff 45 e4             	incl   -0x1c(%ebp)
  801ba1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba7:	01 d0                	add    %edx,%eax
  801ba9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801bac:	77 e5                	ja     801b93 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	eb 05                	jmp    801bb8 <malloc+0x15a>
		}
	}

	return NULL;
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801bc0:	e8 65 08 00 00       	call   80242a <sys_get_hard_limit>
  801bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801bce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bd2:	0f 84 c1 00 00 00    	je     801c99 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	79 1b                	jns    801bfa <free+0x40>
  801bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be5:	73 13                	jae    801bfa <free+0x40>
    {
        free_block(virtual_address);
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	e8 34 10 00 00       	call   802c26 <free_block>
  801bf2:	83 c4 10             	add    $0x10,%esp
    	return;
  801bf5:	e9 a6 00 00 00       	jmp    801ca0 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfd:	05 00 10 00 00       	add    $0x1000,%eax
  801c02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801c05:	0f 87 91 00 00 00    	ja     801c9c <free+0xe2>
  801c0b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801c12:	0f 87 84 00 00 00    	ja     801c9c <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2c:	05 00 00 00 80       	add    $0x80000000,%eax
  801c31:	c1 e8 0c             	shr    $0xc,%eax
  801c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c3a:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  801c41:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801c44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c48:	74 55                	je     801c9f <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4d:	c1 e8 0c             	shr    $0xc,%eax
  801c50:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c56:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801c5d:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c67:	eb 0e                	jmp    801c77 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6c:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  801c73:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801c74:	ff 45 f4             	incl   -0xc(%ebp)
  801c77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7d:	01 c2                	add    %eax,%edx
  801c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c82:	39 c2                	cmp    %eax,%edx
  801c84:	77 e3                	ja     801c69 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801c86:	83 ec 08             	sub    $0x8,%esp
  801c89:	ff 75 e0             	pushl  -0x20(%ebp)
  801c8c:	ff 75 ec             	pushl  -0x14(%ebp)
  801c8f:	e8 5e 07 00 00       	call   8023f2 <sys_free_user_mem>
  801c94:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801c97:	eb 07                	jmp    801ca0 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801c99:	90                   	nop
  801c9a:	eb 04                	jmp    801ca0 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801c9c:	90                   	nop
  801c9d:	eb 01                	jmp    801ca0 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801c9f:	90                   	nop
    else
     {
    	return;
      }

}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 18             	sub    $0x18,%esp
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cae:	e8 7c fd ff ff       	call   801a2f <InitializeUHeap>
	if (size == 0)
  801cb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb7:	75 07                	jne    801cc0 <smalloc+0x1e>
		return NULL;
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	eb 17                	jmp    801cd7 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	68 e4 3f 80 00       	push   $0x803fe4
  801cc8:	68 ad 00 00 00       	push   $0xad
  801ccd:	68 0a 40 80 00       	push   $0x80400a
  801cd2:	e8 9b ea ff ff       	call   800772 <_panic>
	return NULL;
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cdf:	e8 4b fd ff ff       	call   801a2f <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	68 18 40 80 00       	push   $0x804018
  801cec:	68 ba 00 00 00       	push   $0xba
  801cf1:	68 0a 40 80 00       	push   $0x80400a
  801cf6:	e8 77 ea ff ff       	call   800772 <_panic>

00801cfb <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d01:	e8 29 fd ff ff       	call   801a2f <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	68 3c 40 80 00       	push   $0x80403c
  801d0e:	68 d8 00 00 00       	push   $0xd8
  801d13:	68 0a 40 80 00       	push   $0x80400a
  801d18:	e8 55 ea ff ff       	call   800772 <_panic>

00801d1d <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	68 64 40 80 00       	push   $0x804064
  801d2b:	68 ea 00 00 00       	push   $0xea
  801d30:	68 0a 40 80 00       	push   $0x80400a
  801d35:	e8 38 ea ff ff       	call   800772 <_panic>

00801d3a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d40:	83 ec 04             	sub    $0x4,%esp
  801d43:	68 88 40 80 00       	push   $0x804088
  801d48:	68 f2 00 00 00       	push   $0xf2
  801d4d:	68 0a 40 80 00       	push   $0x80400a
  801d52:	e8 1b ea ff ff       	call   800772 <_panic>

00801d57 <shrink>:

}
void shrink(uint32 newSize) {
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	68 88 40 80 00       	push   $0x804088
  801d65:	68 f6 00 00 00       	push   $0xf6
  801d6a:	68 0a 40 80 00       	push   $0x80400a
  801d6f:	e8 fe e9 ff ff       	call   800772 <_panic>

00801d74 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	68 88 40 80 00       	push   $0x804088
  801d82:	68 fa 00 00 00       	push   $0xfa
  801d87:	68 0a 40 80 00       	push   $0x80400a
  801d8c:	e8 e1 e9 ff ff       	call   800772 <_panic>

00801d91 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	57                   	push   %edi
  801d95:	56                   	push   %esi
  801d96:	53                   	push   %ebx
  801d97:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801da9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dac:	cd 30                	int    $0x30
  801dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    

00801dbc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dc8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	52                   	push   %edx
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	50                   	push   %eax
  801dd8:	6a 00                	push   $0x0
  801dda:	e8 b2 ff ff ff       	call   801d91 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	90                   	nop
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 01                	push   $0x1
  801df4:	e8 98 ff ff ff       	call   801d91 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	52                   	push   %edx
  801e0e:	50                   	push   %eax
  801e0f:	6a 05                	push   $0x5
  801e11:	e8 7b ff ff ff       	call   801d91 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e20:	8b 75 18             	mov    0x18(%ebp),%esi
  801e23:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	56                   	push   %esi
  801e30:	53                   	push   %ebx
  801e31:	51                   	push   %ecx
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	6a 06                	push   $0x6
  801e36:	e8 56 ff ff ff       	call   801d91 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	52                   	push   %edx
  801e55:	50                   	push   %eax
  801e56:	6a 07                	push   $0x7
  801e58:	e8 34 ff ff ff       	call   801d91 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	6a 08                	push   $0x8
  801e73:	e8 19 ff ff ff       	call   801d91 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 09                	push   $0x9
  801e8c:	e8 00 ff ff ff       	call   801d91 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 0a                	push   $0xa
  801ea5:	e8 e7 fe ff ff       	call   801d91 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 0b                	push   $0xb
  801ebe:	e8 ce fe ff ff       	call   801d91 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0c                	push   $0xc
  801ed7:	e8 b5 fe ff ff       	call   801d91 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	6a 0d                	push   $0xd
  801ef1:	e8 9b fe ff ff       	call   801d91 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 0e                	push   $0xe
  801f0a:	e8 82 fe ff ff       	call   801d91 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 11                	push   $0x11
  801f24:	e8 68 fe ff ff       	call   801d91 <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 12                	push   $0x12
  801f3e:	e8 4e fe ff ff       	call   801d91 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	90                   	nop
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	50                   	push   %eax
  801f62:	6a 13                	push   $0x13
  801f64:	e8 28 fe ff ff       	call   801d91 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 14                	push   $0x14
  801f7e:	e8 0e fe ff ff       	call   801d91 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	90                   	nop
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	50                   	push   %eax
  801f99:	6a 15                	push   $0x15
  801f9b:	e8 f1 fd ff ff       	call   801d91 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 18                	push   $0x18
  801fb8:	e8 d4 fd ff ff       	call   801d91 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	52                   	push   %edx
  801fd2:	50                   	push   %eax
  801fd3:	6a 16                	push   $0x16
  801fd5:	e8 b7 fd ff ff       	call   801d91 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	90                   	nop
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 17                	push   $0x17
  801ff3:	e8 99 fd ff ff       	call   801d91 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	8b 45 10             	mov    0x10(%ebp),%eax
  802007:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80200a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80200d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	6a 00                	push   $0x0
  802016:	51                   	push   %ecx
  802017:	52                   	push   %edx
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	50                   	push   %eax
  80201c:	6a 19                	push   $0x19
  80201e:	e8 6e fd ff ff       	call   801d91 <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	52                   	push   %edx
  802038:	50                   	push   %eax
  802039:	6a 1a                	push   $0x1a
  80203b:	e8 51 fd ff ff       	call   801d91 <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802048:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	51                   	push   %ecx
  802056:	52                   	push   %edx
  802057:	50                   	push   %eax
  802058:	6a 1b                	push   $0x1b
  80205a:	e8 32 fd ff ff       	call   801d91 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802067:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	6a 1c                	push   $0x1c
  802077:	e8 15 fd ff ff       	call   801d91 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 1d                	push   $0x1d
  802090:	e8 fc fc ff ff       	call   801d91 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	ff 75 14             	pushl  0x14(%ebp)
  8020a5:	ff 75 10             	pushl  0x10(%ebp)
  8020a8:	ff 75 0c             	pushl  0xc(%ebp)
  8020ab:	50                   	push   %eax
  8020ac:	6a 1e                	push   $0x1e
  8020ae:	e8 de fc ff ff       	call   801d91 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	50                   	push   %eax
  8020c7:	6a 1f                	push   $0x1f
  8020c9:	e8 c3 fc ff ff       	call   801d91 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	50                   	push   %eax
  8020e3:	6a 20                	push   $0x20
  8020e5:	e8 a7 fc ff ff       	call   801d91 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 02                	push   $0x2
  8020fe:	e8 8e fc ff ff       	call   801d91 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 03                	push   $0x3
  802117:	e8 75 fc ff ff       	call   801d91 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 04                	push   $0x4
  802130:	e8 5c fc ff ff       	call   801d91 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_exit_env>:


void sys_exit_env(void)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 21                	push   $0x21
  802149:	e8 43 fc ff ff       	call   801d91 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80215a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80215d:	8d 50 04             	lea    0x4(%eax),%edx
  802160:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	52                   	push   %edx
  80216a:	50                   	push   %eax
  80216b:	6a 22                	push   $0x22
  80216d:	e8 1f fc ff ff       	call   801d91 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
	return result;
  802175:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80217b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217e:	89 01                	mov    %eax,(%ecx)
  802180:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	c9                   	leave  
  802187:	c2 04 00             	ret    $0x4

0080218a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	ff 75 10             	pushl  0x10(%ebp)
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 10                	push   $0x10
  80219c:	e8 f0 fb ff ff       	call   801d91 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a4:	90                   	nop
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 23                	push   $0x23
  8021b6:	e8 d6 fb ff ff       	call   801d91 <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	50                   	push   %eax
  8021d9:	6a 24                	push   $0x24
  8021db:	e8 b1 fb ff ff       	call   801d91 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e3:	90                   	nop
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <rsttst>:
void rsttst()
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 26                	push   $0x26
  8021f5:	e8 97 fb ff ff       	call   801d91 <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fd:	90                   	nop
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	8b 45 14             	mov    0x14(%ebp),%eax
  802209:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80220c:	8b 55 18             	mov    0x18(%ebp),%edx
  80220f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802213:	52                   	push   %edx
  802214:	50                   	push   %eax
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	ff 75 08             	pushl  0x8(%ebp)
  80221e:	6a 25                	push   $0x25
  802220:	e8 6c fb ff ff       	call   801d91 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
	return ;
  802228:	90                   	nop
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <chktst>:
void chktst(uint32 n)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	ff 75 08             	pushl  0x8(%ebp)
  802239:	6a 27                	push   $0x27
  80223b:	e8 51 fb ff ff       	call   801d91 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
	return ;
  802243:	90                   	nop
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <inctst>:

void inctst()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 28                	push   $0x28
  802255:	e8 37 fb ff ff       	call   801d91 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
	return ;
  80225d:	90                   	nop
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <gettst>:
uint32 gettst()
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 29                	push   $0x29
  80226f:	e8 1d fb ff ff       	call   801d91 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 2a                	push   $0x2a
  80228b:	e8 01 fb ff ff       	call   801d91 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
  802293:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802296:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80229a:	75 07                	jne    8022a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80229c:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a1:	eb 05                	jmp    8022a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 2a                	push   $0x2a
  8022bc:	e8 d0 fa ff ff       	call   801d91 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
  8022c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022c7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022cb:	75 07                	jne    8022d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d2:	eb 05                	jmp    8022d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 2a                	push   $0x2a
  8022ed:	e8 9f fa ff ff       	call   801d91 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
  8022f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022f8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022fc:	75 07                	jne    802305 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	eb 05                	jmp    80230a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 2a                	push   $0x2a
  80231e:	e8 6e fa ff ff       	call   801d91 <syscall>
  802323:	83 c4 18             	add    $0x18,%esp
  802326:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802329:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80232d:	75 07                	jne    802336 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80232f:	b8 01 00 00 00       	mov    $0x1,%eax
  802334:	eb 05                	jmp    80233b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	6a 2b                	push   $0x2b
  80234d:	e8 3f fa ff ff       	call   801d91 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
	return ;
  802355:	90                   	nop
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80235c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80235f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802362:	8b 55 0c             	mov    0xc(%ebp),%edx
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	6a 00                	push   $0x0
  80236a:	53                   	push   %ebx
  80236b:	51                   	push   %ecx
  80236c:	52                   	push   %edx
  80236d:	50                   	push   %eax
  80236e:	6a 2c                	push   $0x2c
  802370:	e8 1c fa ff ff       	call   801d91 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802380:	8b 55 0c             	mov    0xc(%ebp),%edx
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	52                   	push   %edx
  80238d:	50                   	push   %eax
  80238e:	6a 2d                	push   $0x2d
  802390:	e8 fc f9 ff ff       	call   801d91 <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80239d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	6a 00                	push   $0x0
  8023a8:	51                   	push   %ecx
  8023a9:	ff 75 10             	pushl  0x10(%ebp)
  8023ac:	52                   	push   %edx
  8023ad:	50                   	push   %eax
  8023ae:	6a 2e                	push   $0x2e
  8023b0:	e8 dc f9 ff ff       	call   801d91 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	ff 75 10             	pushl  0x10(%ebp)
  8023c4:	ff 75 0c             	pushl  0xc(%ebp)
  8023c7:	ff 75 08             	pushl  0x8(%ebp)
  8023ca:	6a 0f                	push   $0xf
  8023cc:	e8 c0 f9 ff ff       	call   801d91 <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d4:	90                   	nop
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	50                   	push   %eax
  8023e6:	6a 2f                	push   $0x2f
  8023e8:	e8 a4 f9 ff ff       	call   801d91 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp

}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	ff 75 0c             	pushl  0xc(%ebp)
  8023fe:	ff 75 08             	pushl  0x8(%ebp)
  802401:	6a 30                	push   $0x30
  802403:	e8 89 f9 ff ff       	call   801d91 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
	return;
  80240b:	90                   	nop
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	ff 75 0c             	pushl  0xc(%ebp)
  80241a:	ff 75 08             	pushl  0x8(%ebp)
  80241d:	6a 31                	push   $0x31
  80241f:	e8 6d f9 ff ff       	call   801d91 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
	return;
  802427:	90                   	nop
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 32                	push   $0x32
  802439:	e8 53 f9 ff ff       	call   801d91 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	50                   	push   %eax
  802452:	6a 33                	push   $0x33
  802454:	e8 38 f9 ff ff       	call   801d91 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	90                   	nop
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	83 e8 10             	sub    $0x10,%eax
  80246b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  80246e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	83 e8 10             	sub    $0x10,%eax
  802481:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802484:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802487:	8a 40 04             	mov    0x4(%eax),%al
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249c:	83 f8 02             	cmp    $0x2,%eax
  80249f:	74 2b                	je     8024cc <alloc_block+0x40>
  8024a1:	83 f8 02             	cmp    $0x2,%eax
  8024a4:	7f 07                	jg     8024ad <alloc_block+0x21>
  8024a6:	83 f8 01             	cmp    $0x1,%eax
  8024a9:	74 0e                	je     8024b9 <alloc_block+0x2d>
  8024ab:	eb 58                	jmp    802505 <alloc_block+0x79>
  8024ad:	83 f8 03             	cmp    $0x3,%eax
  8024b0:	74 2d                	je     8024df <alloc_block+0x53>
  8024b2:	83 f8 04             	cmp    $0x4,%eax
  8024b5:	74 3b                	je     8024f2 <alloc_block+0x66>
  8024b7:	eb 4c                	jmp    802505 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8024b9:	83 ec 0c             	sub    $0xc,%esp
  8024bc:	ff 75 08             	pushl  0x8(%ebp)
  8024bf:	e8 95 01 00 00       	call   802659 <alloc_block_FF>
  8024c4:	83 c4 10             	add    $0x10,%esp
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024ca:	eb 4a                	jmp    802516 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8024cc:	83 ec 0c             	sub    $0xc,%esp
  8024cf:	ff 75 08             	pushl  0x8(%ebp)
  8024d2:	e8 32 07 00 00       	call   802c09 <alloc_block_NF>
  8024d7:	83 c4 10             	add    $0x10,%esp
  8024da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024dd:	eb 37                	jmp    802516 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024df:	83 ec 0c             	sub    $0xc,%esp
  8024e2:	ff 75 08             	pushl  0x8(%ebp)
  8024e5:	e8 a3 04 00 00       	call   80298d <alloc_block_BF>
  8024ea:	83 c4 10             	add    $0x10,%esp
  8024ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024f0:	eb 24                	jmp    802516 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8024f2:	83 ec 0c             	sub    $0xc,%esp
  8024f5:	ff 75 08             	pushl  0x8(%ebp)
  8024f8:	e8 ef 06 00 00       	call   802bec <alloc_block_WF>
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802503:	eb 11                	jmp    802516 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	68 98 40 80 00       	push   $0x804098
  80250d:	e8 1d e5 ff ff       	call   800a2f <cprintf>
  802512:	83 c4 10             	add    $0x10,%esp
		break;
  802515:	90                   	nop
	}
	return va;
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802521:	83 ec 0c             	sub    $0xc,%esp
  802524:	68 b8 40 80 00       	push   $0x8040b8
  802529:	e8 01 e5 ff ff       	call   800a2f <cprintf>
  80252e:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  802531:	83 ec 0c             	sub    $0xc,%esp
  802534:	68 e3 40 80 00       	push   $0x8040e3
  802539:	e8 f1 e4 ff ff       	call   800a2f <cprintf>
  80253e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802547:	eb 26                	jmp    80256f <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8a 40 04             	mov    0x4(%eax),%al
  80254f:	0f b6 d0             	movzbl %al,%edx
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	52                   	push   %edx
  80255b:	50                   	push   %eax
  80255c:	68 fb 40 80 00       	push   $0x8040fb
  802561:	e8 c9 e4 ff ff       	call   800a2f <cprintf>
  802566:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802569:	8b 45 10             	mov    0x10(%ebp),%eax
  80256c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802573:	74 08                	je     80257d <print_blocks_list+0x62>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 08             	mov    0x8(%eax),%eax
  80257b:	eb 05                	jmp    802582 <print_blocks_list+0x67>
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
  802582:	89 45 10             	mov    %eax,0x10(%ebp)
  802585:	8b 45 10             	mov    0x10(%ebp),%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	75 bd                	jne    802549 <print_blocks_list+0x2e>
  80258c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802590:	75 b7                	jne    802549 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	68 b8 40 80 00       	push   $0x8040b8
  80259a:	e8 90 e4 ff ff       	call   800a2f <cprintf>
  80259f:	83 c4 10             	add    $0x10,%esp

}
  8025a2:	90                   	nop
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  8025ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025af:	0f 84 a1 00 00 00    	je     802656 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  8025b5:	c7 05 30 50 80 00 01 	movl   $0x1,0x805030
  8025bc:	00 00 00 
	LIST_INIT(&list);
  8025bf:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  8025c6:	00 00 00 
  8025c9:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  8025d0:	00 00 00 
  8025d3:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  8025da:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f0:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  8025f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f6:	75 14                	jne    80260c <initialize_dynamic_allocator+0x67>
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 14 41 80 00       	push   $0x804114
  802600:	6a 64                	push   $0x64
  802602:	68 37 41 80 00       	push   $0x804137
  802607:	e8 66 e1 ff ff       	call   800772 <_panic>
  80260c:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	89 50 0c             	mov    %edx,0xc(%eax)
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 40 0c             	mov    0xc(%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 0d                	je     80262f <initialize_dynamic_allocator+0x8a>
  802622:	a1 44 51 90 00       	mov    0x905144,%eax
  802627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262a:	89 50 08             	mov    %edx,0x8(%eax)
  80262d:	eb 08                	jmp    802637 <initialize_dynamic_allocator+0x92>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	a3 40 51 90 00       	mov    %eax,0x905140
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	a3 44 51 90 00       	mov    %eax,0x905144
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802649:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80264e:	40                   	inc    %eax
  80264f:	a3 4c 51 90 00       	mov    %eax,0x90514c
  802654:	eb 01                	jmp    802657 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802656:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  80265f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802663:	75 0a                	jne    80266f <alloc_block_FF+0x16>
	{
		return NULL;
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
  80266a:	e9 1c 03 00 00       	jmp    80298b <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  80266f:	a1 30 50 80 00       	mov    0x805030,%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	75 40                	jne    8026b8 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	83 c0 10             	add    $0x10,%eax
  80267e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	83 ec 0c             	sub    $0xc,%esp
  802687:	50                   	push   %eax
  802688:	e8 bb f3 ff ff       	call   801a48 <sbrk>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802693:	83 ec 0c             	sub    $0xc,%esp
  802696:	6a 00                	push   $0x0
  802698:	e8 ab f3 ff ff       	call   801a48 <sbrk>
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8026a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8026a9:	83 ec 08             	sub    $0x8,%esp
  8026ac:	50                   	push   %eax
  8026ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8026b0:	e8 f0 fe ff ff       	call   8025a5 <initialize_dynamic_allocator>
  8026b5:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8026b8:	a1 40 51 90 00       	mov    0x905140,%eax
  8026bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c0:	e9 1e 01 00 00       	jmp    8027e3 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	8d 50 10             	lea    0x10(%eax),%edx
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	39 c2                	cmp    %eax,%edx
  8026d2:	75 1c                	jne    8026f0 <alloc_block_FF+0x97>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8a 40 04             	mov    0x4(%eax),%al
  8026da:	3c 01                	cmp    $0x1,%al
  8026dc:	75 12                	jne    8026f0 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	83 c0 10             	add    $0x10,%eax
  8026eb:	e9 9b 02 00 00       	jmp    80298b <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	8d 50 10             	lea    0x10(%eax),%edx
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	39 c2                	cmp    %eax,%edx
  8026fd:	0f 83 d8 00 00 00    	jae    8027db <alloc_block_FF+0x182>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8a 40 04             	mov    0x4(%eax),%al
  802709:	3c 01                	cmp    $0x1,%al
  80270b:	0f 85 ca 00 00 00    	jne    8027db <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	2b 45 08             	sub    0x8(%ebp),%eax
  802719:	83 e8 10             	sub    $0x10,%eax
  80271c:	83 f8 0f             	cmp    $0xf,%eax
  80271f:	0f 86 a4 00 00 00    	jbe    8027c9 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	01 d0                	add    %edx,%eax
  80272d:	83 c0 10             	add    $0x10,%eax
  802730:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	2b 45 08             	sub    0x8(%ebp),%eax
  80273b:	8d 50 f0             	lea    -0x10(%eax),%edx
  80273e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802741:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802743:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802746:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80274a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274e:	74 06                	je     802756 <alloc_block_FF+0xfd>
  802750:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802754:	75 17                	jne    80276d <alloc_block_FF+0x114>
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	68 50 41 80 00       	push   $0x804150
  80275e:	68 8f 00 00 00       	push   $0x8f
  802763:	68 37 41 80 00       	push   $0x804137
  802768:	e8 05 e0 ff ff       	call   800772 <_panic>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 50 08             	mov    0x8(%eax),%edx
  802773:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802776:	89 50 08             	mov    %edx,0x8(%eax)
  802779:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80277c:	8b 40 08             	mov    0x8(%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 0c                	je     80278f <alloc_block_FF+0x136>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80278c:	89 50 0c             	mov    %edx,0xc(%eax)
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802795:	89 50 08             	mov    %edx,0x8(%eax)
  802798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80279b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279e:	89 50 0c             	mov    %edx,0xc(%eax)
  8027a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027a4:	8b 40 08             	mov    0x8(%eax),%eax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	75 08                	jne    8027b3 <alloc_block_FF+0x15a>
  8027ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027ae:	a3 44 51 90 00       	mov    %eax,0x905144
  8027b3:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8027b8:	40                   	inc    %eax
  8027b9:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	8d 50 10             	lea    0x10(%eax),%edx
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	83 c0 10             	add    $0x10,%eax
  8027d6:	e9 b0 01 00 00       	jmp    80298b <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  8027db:	a1 48 51 90 00       	mov    0x905148,%eax
  8027e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e7:	74 08                	je     8027f1 <alloc_block_FF+0x198>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 08             	mov    0x8(%eax),%eax
  8027ef:	eb 05                	jmp    8027f6 <alloc_block_FF+0x19d>
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	a3 48 51 90 00       	mov    %eax,0x905148
  8027fb:	a1 48 51 90 00       	mov    0x905148,%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	0f 85 bd fe ff ff    	jne    8026c5 <alloc_block_FF+0x6c>
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	0f 85 b3 fe ff ff    	jne    8026c5 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	83 c0 10             	add    $0x10,%eax
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	50                   	push   %eax
  80281c:	e8 27 f2 ff ff       	call   801a48 <sbrk>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	6a 00                	push   $0x0
  80282c:	e8 17 f2 ff ff       	call   801a48 <sbrk>
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802837:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80283a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283d:	29 c2                	sub    %eax,%edx
  80283f:	89 d0                	mov    %edx,%eax
  802841:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802844:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802848:	0f 84 38 01 00 00    	je     802986 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  80284e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802851:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802854:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802858:	75 17                	jne    802871 <alloc_block_FF+0x218>
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	68 14 41 80 00       	push   $0x804114
  802862:	68 9f 00 00 00       	push   $0x9f
  802867:	68 37 41 80 00       	push   $0x804137
  80286c:	e8 01 df ff ff       	call   800772 <_panic>
  802871:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802877:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80287a:	89 50 0c             	mov    %edx,0xc(%eax)
  80287d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802880:	8b 40 0c             	mov    0xc(%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 0d                	je     802894 <alloc_block_FF+0x23b>
  802887:	a1 44 51 90 00       	mov    0x905144,%eax
  80288c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80288f:	89 50 08             	mov    %edx,0x8(%eax)
  802892:	eb 08                	jmp    80289c <alloc_block_FF+0x243>
  802894:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802897:	a3 40 51 90 00       	mov    %eax,0x905140
  80289c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80289f:	a3 44 51 90 00       	mov    %eax,0x905144
  8028a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028ae:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8028b3:	40                   	inc    %eax
  8028b4:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	8d 50 10             	lea    0x10(%eax),%edx
  8028bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028c2:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  8028c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028c7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  8028cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d1:	83 f8 10             	cmp    $0x10,%eax
  8028d4:	0f 84 a4 00 00 00    	je     80297e <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  8028da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e0:	83 e8 10             	sub    $0x10,%eax
  8028e3:	83 f8 0f             	cmp    $0xf,%eax
  8028e6:	0f 86 8a 00 00 00    	jbe    802976 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  8028ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	01 d0                	add    %edx,%eax
  8028f4:	83 c0 10             	add    $0x10,%eax
  8028f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  8028fa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8028fe:	75 17                	jne    802917 <alloc_block_FF+0x2be>
  802900:	83 ec 04             	sub    $0x4,%esp
  802903:	68 14 41 80 00       	push   $0x804114
  802908:	68 a7 00 00 00       	push   $0xa7
  80290d:	68 37 41 80 00       	push   $0x804137
  802912:	e8 5b de ff ff       	call   800772 <_panic>
  802917:	8b 15 44 51 90 00    	mov    0x905144,%edx
  80291d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802920:	89 50 0c             	mov    %edx,0xc(%eax)
  802923:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802926:	8b 40 0c             	mov    0xc(%eax),%eax
  802929:	85 c0                	test   %eax,%eax
  80292b:	74 0d                	je     80293a <alloc_block_FF+0x2e1>
  80292d:	a1 44 51 90 00       	mov    0x905144,%eax
  802932:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802935:	89 50 08             	mov    %edx,0x8(%eax)
  802938:	eb 08                	jmp    802942 <alloc_block_FF+0x2e9>
  80293a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80293d:	a3 40 51 90 00       	mov    %eax,0x905140
  802942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802945:	a3 44 51 90 00       	mov    %eax,0x905144
  80294a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80294d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802954:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802959:	40                   	inc    %eax
  80295a:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  80295f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802962:	2b 45 08             	sub    0x8(%ebp),%eax
  802965:	8d 50 f0             	lea    -0x10(%eax),%edx
  802968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80296b:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  80296d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802970:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802974:	eb 08                	jmp    80297e <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802976:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802979:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80297c:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  80297e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802981:	83 c0 10             	add    $0x10,%eax
  802984:	eb 05                	jmp    80298b <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  80298b:	c9                   	leave  
  80298c:	c3                   	ret    

0080298d <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
  802990:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802993:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  80299a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299e:	75 0a                	jne    8029aa <alloc_block_BF+0x1d>
	{
		return NULL;
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	e9 40 02 00 00       	jmp    802bea <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8029aa:	a1 40 51 90 00       	mov    0x905140,%eax
  8029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b2:	eb 66                	jmp    802a1a <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8a 40 04             	mov    0x4(%eax),%al
  8029ba:	3c 01                	cmp    $0x1,%al
  8029bc:	75 21                	jne    8029df <alloc_block_BF+0x52>
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8d 50 10             	lea    0x10(%eax),%edx
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	39 c2                	cmp    %eax,%edx
  8029cb:	75 12                	jne    8029df <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	83 c0 10             	add    $0x10,%eax
  8029da:	e9 0b 02 00 00       	jmp    802bea <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8a 40 04             	mov    0x4(%eax),%al
  8029e5:	3c 01                	cmp    $0x1,%al
  8029e7:	75 29                	jne    802a12 <alloc_block_BF+0x85>
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	8d 50 10             	lea    0x10(%eax),%edx
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	39 c2                	cmp    %eax,%edx
  8029f6:	77 1a                	ja     802a12 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  8029f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fc:	74 0e                	je     802a0c <alloc_block_BF+0x7f>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 10                	mov    (%eax),%edx
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	39 c2                	cmp    %eax,%edx
  802a0a:	73 06                	jae    802a12 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802a12:	a1 48 51 90 00       	mov    0x905148,%eax
  802a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1e:	74 08                	je     802a28 <alloc_block_BF+0x9b>
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	eb 05                	jmp    802a2d <alloc_block_BF+0xa0>
  802a28:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2d:	a3 48 51 90 00       	mov    %eax,0x905148
  802a32:	a1 48 51 90 00       	mov    0x905148,%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	0f 85 75 ff ff ff    	jne    8029b4 <alloc_block_BF+0x27>
  802a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a43:	0f 85 6b ff ff ff    	jne    8029b4 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4d:	0f 84 f8 00 00 00    	je     802b4b <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	8d 50 10             	lea    0x10(%eax),%edx
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	39 c2                	cmp    %eax,%edx
  802a60:	0f 87 e5 00 00 00    	ja     802b4b <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6e:	83 e8 10             	sub    $0x10,%eax
  802a71:	83 f8 0f             	cmp    $0xf,%eax
  802a74:	0f 86 bf 00 00 00    	jbe    802b39 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	01 d0                	add    %edx,%eax
  802a82:	83 c0 10             	add    $0x10,%eax
  802a85:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	2b 45 08             	sub    0x8(%ebp),%eax
  802a99:	8d 50 f0             	lea    -0x10(%eax),%edx
  802a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9f:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802aa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aac:	74 06                	je     802ab4 <alloc_block_BF+0x127>
  802aae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab2:	75 17                	jne    802acb <alloc_block_BF+0x13e>
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 50 41 80 00       	push   $0x804150
  802abc:	68 e3 00 00 00       	push   $0xe3
  802ac1:	68 37 41 80 00       	push   $0x804137
  802ac6:	e8 a7 dc ff ff       	call   800772 <_panic>
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 50 08             	mov    0x8(%eax),%edx
  802ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad4:	89 50 08             	mov    %edx,0x8(%eax)
  802ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ada:	8b 40 08             	mov    0x8(%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	74 0c                	je     802aed <alloc_block_BF+0x160>
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	8b 40 08             	mov    0x8(%eax),%eax
  802ae7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aea:	89 50 0c             	mov    %edx,0xc(%eax)
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af3:	89 50 08             	mov    %edx,0x8(%eax)
  802af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afc:	89 50 0c             	mov    %edx,0xc(%eax)
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	8b 40 08             	mov    0x8(%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	75 08                	jne    802b11 <alloc_block_BF+0x184>
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	a3 44 51 90 00       	mov    %eax,0x905144
  802b11:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802b16:	40                   	inc    %eax
  802b17:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	8d 50 10             	lea    0x10(%eax),%edx
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b31:	83 c0 10             	add    $0x10,%eax
  802b34:	e9 b1 00 00 00       	jmp    802bea <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	83 c0 10             	add    $0x10,%eax
  802b46:	e9 9f 00 00 00       	jmp    802bea <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	83 c0 10             	add    $0x10,%eax
  802b51:	83 ec 0c             	sub    $0xc,%esp
  802b54:	50                   	push   %eax
  802b55:	e8 ee ee ff ff       	call   801a48 <sbrk>
  802b5a:	83 c4 10             	add    $0x10,%esp
  802b5d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802b60:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802b64:	74 7f                	je     802be5 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b6a:	75 17                	jne    802b83 <alloc_block_BF+0x1f6>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 14 41 80 00       	push   $0x804114
  802b74:	68 f6 00 00 00       	push   $0xf6
  802b79:	68 37 41 80 00       	push   $0x804137
  802b7e:	e8 ef db ff ff       	call   800772 <_panic>
  802b83:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8c:	89 50 0c             	mov    %edx,0xc(%eax)
  802b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0d                	je     802ba6 <alloc_block_BF+0x219>
  802b99:	a1 44 51 90 00       	mov    0x905144,%eax
  802b9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba1:	89 50 08             	mov    %edx,0x8(%eax)
  802ba4:	eb 08                	jmp    802bae <alloc_block_BF+0x221>
  802ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba9:	a3 40 51 90 00       	mov    %eax,0x905140
  802bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb1:	a3 44 51 90 00       	mov    %eax,0x905144
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bc0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802bc5:	40                   	inc    %eax
  802bc6:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8d 50 10             	lea    0x10(%eax),%edx
  802bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd4:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be0:	83 c0 10             	add    $0x10,%eax
  802be3:	eb 05                	jmp    802bea <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802be5:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802bea:	c9                   	leave  
  802beb:	c3                   	ret    

00802bec <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
  802bef:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802bf2:	83 ec 04             	sub    $0x4,%esp
  802bf5:	68 84 41 80 00       	push   $0x804184
  802bfa:	68 07 01 00 00       	push   $0x107
  802bff:	68 37 41 80 00       	push   $0x804137
  802c04:	e8 69 db ff ff       	call   800772 <_panic>

00802c09 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802c09:	55                   	push   %ebp
  802c0a:	89 e5                	mov    %esp,%ebp
  802c0c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	68 ac 41 80 00       	push   $0x8041ac
  802c17:	68 0f 01 00 00       	push   $0x10f
  802c1c:	68 37 41 80 00       	push   $0x804137
  802c21:	e8 4c db ff ff       	call   800772 <_panic>

00802c26 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802c26:	55                   	push   %ebp
  802c27:	89 e5                	mov    %esp,%ebp
  802c29:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802c2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c30:	0f 84 ee 05 00 00    	je     803224 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	83 e8 10             	sub    $0x10,%eax
  802c3c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802c3f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802c43:	a1 40 51 90 00       	mov    0x905140,%eax
  802c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c4b:	eb 16                	jmp    802c63 <free_block+0x3d>
	{
		if (block_pointer == it)
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c53:	75 06                	jne    802c5b <free_block+0x35>
		{
			flagx = 1;
  802c55:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802c59:	eb 2f                	jmp    802c8a <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802c5b:	a1 48 51 90 00       	mov    0x905148,%eax
  802c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c67:	74 08                	je     802c71 <free_block+0x4b>
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 40 08             	mov    0x8(%eax),%eax
  802c6f:	eb 05                	jmp    802c76 <free_block+0x50>
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
  802c76:	a3 48 51 90 00       	mov    %eax,0x905148
  802c7b:	a1 48 51 90 00       	mov    0x905148,%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	75 c9                	jne    802c4d <free_block+0x27>
  802c84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c88:	75 c3                	jne    802c4d <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802c8a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802c8e:	0f 84 93 05 00 00    	je     803227 <free_block+0x601>
		return;
	if (va == NULL)
  802c94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c98:	0f 84 8c 05 00 00    	je     80322a <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802caa:	8b 40 08             	mov    0x8(%eax),%eax
  802cad:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802cb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cb4:	75 12                	jne    802cc8 <free_block+0xa2>
  802cb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cba:	75 0c                	jne    802cc8 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbf:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802cc3:	e9 63 05 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802cc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ccc:	0f 85 ca 00 00 00    	jne    802d9c <free_block+0x176>
  802cd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd5:	8a 40 04             	mov    0x4(%eax),%al
  802cd8:	3c 01                	cmp    $0x1,%al
  802cda:	0f 85 bc 00 00 00    	jne    802d9c <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 10                	mov    (%eax),%edx
  802cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	01 c2                	add    %eax,%edx
  802cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf6:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d04:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802d08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d0c:	75 17                	jne    802d25 <free_block+0xff>
  802d0e:	83 ec 04             	sub    $0x4,%esp
  802d11:	68 d2 41 80 00       	push   $0x8041d2
  802d16:	68 3c 01 00 00       	push   $0x13c
  802d1b:	68 37 41 80 00       	push   $0x804137
  802d20:	e8 4d da ff ff       	call   800772 <_panic>
  802d25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d28:	8b 40 08             	mov    0x8(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 11                	je     802d40 <free_block+0x11a>
  802d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d32:	8b 40 08             	mov    0x8(%eax),%eax
  802d35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d38:	8b 52 0c             	mov    0xc(%edx),%edx
  802d3b:	89 50 0c             	mov    %edx,0xc(%eax)
  802d3e:	eb 0b                	jmp    802d4b <free_block+0x125>
  802d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d43:	8b 40 0c             	mov    0xc(%eax),%eax
  802d46:	a3 44 51 90 00       	mov    %eax,0x905144
  802d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 11                	je     802d66 <free_block+0x140>
  802d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d58:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d5e:	8b 52 08             	mov    0x8(%edx),%edx
  802d61:	89 50 08             	mov    %edx,0x8(%eax)
  802d64:	eb 0b                	jmp    802d71 <free_block+0x14b>
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	8b 40 08             	mov    0x8(%eax),%eax
  802d6c:	a3 40 51 90 00       	mov    %eax,0x905140
  802d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d85:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d8a:	48                   	dec    %eax
  802d8b:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802d90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802d97:	e9 8f 04 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802d9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802da0:	75 16                	jne    802db8 <free_block+0x192>
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	8a 40 04             	mov    0x4(%eax),%al
  802da8:	84 c0                	test   %al,%al
  802daa:	75 0c                	jne    802db8 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802db3:	e9 73 04 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802db8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dbc:	0f 85 c3 00 00 00    	jne    802e85 <free_block+0x25f>
  802dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc5:	8a 40 04             	mov    0x4(%eax),%al
  802dc8:	3c 01                	cmp    $0x1,%al
  802dca:	0f 85 b5 00 00 00    	jne    802e85 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	8b 10                	mov    (%eax),%edx
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddf:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802df1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802df5:	75 17                	jne    802e0e <free_block+0x1e8>
  802df7:	83 ec 04             	sub    $0x4,%esp
  802dfa:	68 d2 41 80 00       	push   $0x8041d2
  802dff:	68 49 01 00 00       	push   $0x149
  802e04:	68 37 41 80 00       	push   $0x804137
  802e09:	e8 64 d9 ff ff       	call   800772 <_panic>
  802e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e11:	8b 40 08             	mov    0x8(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 11                	je     802e29 <free_block+0x203>
  802e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1b:	8b 40 08             	mov    0x8(%eax),%eax
  802e1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e21:	8b 52 0c             	mov    0xc(%edx),%edx
  802e24:	89 50 0c             	mov    %edx,0xc(%eax)
  802e27:	eb 0b                	jmp    802e34 <free_block+0x20e>
  802e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2f:	a3 44 51 90 00       	mov    %eax,0x905144
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 11                	je     802e4f <free_block+0x229>
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	8b 40 0c             	mov    0xc(%eax),%eax
  802e44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e47:	8b 52 08             	mov    0x8(%edx),%edx
  802e4a:	89 50 08             	mov    %edx,0x8(%eax)
  802e4d:	eb 0b                	jmp    802e5a <free_block+0x234>
  802e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	a3 40 51 90 00       	mov    %eax,0x905140
  802e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e6e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802e73:	48                   	dec    %eax
  802e74:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802e79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802e80:	e9 a6 03 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802e85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e89:	75 16                	jne    802ea1 <free_block+0x27b>
  802e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8e:	8a 40 04             	mov    0x4(%eax),%al
  802e91:	84 c0                	test   %al,%al
  802e93:	75 0c                	jne    802ea1 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e98:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e9c:	e9 8a 03 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802ea1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ea5:	0f 84 81 01 00 00    	je     80302c <free_block+0x406>
  802eab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eaf:	0f 84 77 01 00 00    	je     80302c <free_block+0x406>
  802eb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb8:	8a 40 04             	mov    0x4(%eax),%al
  802ebb:	3c 01                	cmp    $0x1,%al
  802ebd:	0f 85 69 01 00 00    	jne    80302c <free_block+0x406>
  802ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec6:	8a 40 04             	mov    0x4(%eax),%al
  802ec9:	3c 01                	cmp    $0x1,%al
  802ecb:	0f 85 5b 01 00 00    	jne    80302c <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed4:	8b 10                	mov    (%eax),%edx
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	8b 08                	mov    (%eax),%ecx
  802edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	01 c8                	add    %ecx,%eax
  802ee2:	01 c2                	add    %eax,%edx
  802ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee7:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f05:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802f09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f0d:	75 17                	jne    802f26 <free_block+0x300>
  802f0f:	83 ec 04             	sub    $0x4,%esp
  802f12:	68 d2 41 80 00       	push   $0x8041d2
  802f17:	68 59 01 00 00       	push   $0x159
  802f1c:	68 37 41 80 00       	push   $0x804137
  802f21:	e8 4c d8 ff ff       	call   800772 <_panic>
  802f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 11                	je     802f41 <free_block+0x31b>
  802f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f33:	8b 40 08             	mov    0x8(%eax),%eax
  802f36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f39:	8b 52 0c             	mov    0xc(%edx),%edx
  802f3c:	89 50 0c             	mov    %edx,0xc(%eax)
  802f3f:	eb 0b                	jmp    802f4c <free_block+0x326>
  802f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f44:	8b 40 0c             	mov    0xc(%eax),%eax
  802f47:	a3 44 51 90 00       	mov    %eax,0x905144
  802f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 11                	je     802f67 <free_block+0x341>
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f5f:	8b 52 08             	mov    0x8(%edx),%edx
  802f62:	89 50 08             	mov    %edx,0x8(%eax)
  802f65:	eb 0b                	jmp    802f72 <free_block+0x34c>
  802f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6a:	8b 40 08             	mov    0x8(%eax),%eax
  802f6d:	a3 40 51 90 00       	mov    %eax,0x905140
  802f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f86:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802f8b:	48                   	dec    %eax
  802f8c:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  802f91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f95:	75 17                	jne    802fae <free_block+0x388>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 d2 41 80 00       	push   $0x8041d2
  802f9f:	68 5a 01 00 00       	push   $0x15a
  802fa4:	68 37 41 80 00       	push   $0x804137
  802fa9:	e8 c4 d7 ff ff       	call   800772 <_panic>
  802fae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb1:	8b 40 08             	mov    0x8(%eax),%eax
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 11                	je     802fc9 <free_block+0x3a3>
  802fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbb:	8b 40 08             	mov    0x8(%eax),%eax
  802fbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fc1:	8b 52 0c             	mov    0xc(%edx),%edx
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
  802fc7:	eb 0b                	jmp    802fd4 <free_block+0x3ae>
  802fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcf:	a3 44 51 90 00       	mov    %eax,0x905144
  802fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 11                	je     802fef <free_block+0x3c9>
  802fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fe7:	8b 52 08             	mov    0x8(%edx),%edx
  802fea:	89 50 08             	mov    %edx,0x8(%eax)
  802fed:	eb 0b                	jmp    802ffa <free_block+0x3d4>
  802fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff2:	8b 40 08             	mov    0x8(%eax),%eax
  802ff5:	a3 40 51 90 00       	mov    %eax,0x905140
  802ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803007:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80300e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803013:	48                   	dec    %eax
  803014:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803019:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  803020:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803027:	e9 ff 01 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  80302c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803030:	0f 84 db 00 00 00    	je     803111 <free_block+0x4eb>
  803036:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303a:	0f 84 d1 00 00 00    	je     803111 <free_block+0x4eb>
  803040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803043:	8a 40 04             	mov    0x4(%eax),%al
  803046:	84 c0                	test   %al,%al
  803048:	0f 85 c3 00 00 00    	jne    803111 <free_block+0x4eb>
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8a 40 04             	mov    0x4(%eax),%al
  803054:	3c 01                	cmp    $0x1,%al
  803056:	0f 85 b5 00 00 00    	jne    803111 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  80305c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305f:	8b 10                	mov    (%eax),%edx
  803061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	01 c2                	add    %eax,%edx
  803068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306b:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  80306d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80307d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803081:	75 17                	jne    80309a <free_block+0x474>
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	68 d2 41 80 00       	push   $0x8041d2
  80308b:	68 64 01 00 00       	push   $0x164
  803090:	68 37 41 80 00       	push   $0x804137
  803095:	e8 d8 d6 ff ff       	call   800772 <_panic>
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	8b 40 08             	mov    0x8(%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 11                	je     8030b5 <free_block+0x48f>
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	8b 40 08             	mov    0x8(%eax),%eax
  8030aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8030b0:	89 50 0c             	mov    %edx,0xc(%eax)
  8030b3:	eb 0b                	jmp    8030c0 <free_block+0x49a>
  8030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bb:	a3 44 51 90 00       	mov    %eax,0x905144
  8030c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 11                	je     8030db <free_block+0x4b5>
  8030ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030d3:	8b 52 08             	mov    0x8(%edx),%edx
  8030d6:	89 50 08             	mov    %edx,0x8(%eax)
  8030d9:	eb 0b                	jmp    8030e6 <free_block+0x4c0>
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	8b 40 08             	mov    0x8(%eax),%eax
  8030e1:	a3 40 51 90 00       	mov    %eax,0x905140
  8030e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030fa:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8030ff:	48                   	dec    %eax
  803100:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803105:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80310c:	e9 1a 01 00 00       	jmp    80322b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803111:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803115:	0f 84 df 00 00 00    	je     8031fa <free_block+0x5d4>
  80311b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311f:	0f 84 d5 00 00 00    	je     8031fa <free_block+0x5d4>
  803125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803128:	8a 40 04             	mov    0x4(%eax),%al
  80312b:	3c 01                	cmp    $0x1,%al
  80312d:	0f 85 c7 00 00 00    	jne    8031fa <free_block+0x5d4>
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	8a 40 04             	mov    0x4(%eax),%al
  803139:	84 c0                	test   %al,%al
  80313b:	0f 85 b9 00 00 00    	jne    8031fa <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  803141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803144:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803148:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314b:	8b 10                	mov    (%eax),%edx
  80314d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	01 c2                	add    %eax,%edx
  803154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803157:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803165:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  803169:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80316d:	75 17                	jne    803186 <free_block+0x560>
  80316f:	83 ec 04             	sub    $0x4,%esp
  803172:	68 d2 41 80 00       	push   $0x8041d2
  803177:	68 6e 01 00 00       	push   $0x16e
  80317c:	68 37 41 80 00       	push   $0x804137
  803181:	e8 ec d5 ff ff       	call   800772 <_panic>
  803186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803189:	8b 40 08             	mov    0x8(%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	74 11                	je     8031a1 <free_block+0x57b>
  803190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803193:	8b 40 08             	mov    0x8(%eax),%eax
  803196:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803199:	8b 52 0c             	mov    0xc(%edx),%edx
  80319c:	89 50 0c             	mov    %edx,0xc(%eax)
  80319f:	eb 0b                	jmp    8031ac <free_block+0x586>
  8031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a7:	a3 44 51 90 00       	mov    %eax,0x905144
  8031ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031af:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 11                	je     8031c7 <free_block+0x5a1>
  8031b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031bf:	8b 52 08             	mov    0x8(%edx),%edx
  8031c2:	89 50 08             	mov    %edx,0x8(%eax)
  8031c5:	eb 0b                	jmp    8031d2 <free_block+0x5ac>
  8031c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ca:	8b 40 08             	mov    0x8(%eax),%eax
  8031cd:	a3 40 51 90 00       	mov    %eax,0x905140
  8031d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031e6:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8031eb:	48                   	dec    %eax
  8031ec:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  8031f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  8031f8:	eb 31                	jmp    80322b <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  8031fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031fe:	74 2b                	je     80322b <free_block+0x605>
  803200:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803204:	74 25                	je     80322b <free_block+0x605>
  803206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803209:	8a 40 04             	mov    0x4(%eax),%al
  80320c:	84 c0                	test   %al,%al
  80320e:	75 1b                	jne    80322b <free_block+0x605>
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8a 40 04             	mov    0x4(%eax),%al
  803216:	84 c0                	test   %al,%al
  803218:	75 11                	jne    80322b <free_block+0x605>
	{
		block_pointer->is_free = 1;
  80321a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  803221:	90                   	nop
  803222:	eb 07                	jmp    80322b <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803224:	90                   	nop
  803225:	eb 04                	jmp    80322b <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803227:	90                   	nop
  803228:	eb 01                	jmp    80322b <free_block+0x605>
	if (va == NULL)
		return;
  80322a:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	57                   	push   %edi
  803231:	56                   	push   %esi
  803232:	53                   	push   %ebx
  803233:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323a:	75 19                	jne    803255 <realloc_block_FF+0x28>
  80323c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803240:	74 13                	je     803255 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  803242:	83 ec 0c             	sub    $0xc,%esp
  803245:	ff 75 0c             	pushl  0xc(%ebp)
  803248:	e8 0c f4 ff ff       	call   802659 <alloc_block_FF>
  80324d:	83 c4 10             	add    $0x10,%esp
  803250:	e9 84 03 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  803255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803259:	75 3b                	jne    803296 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  80325b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325f:	75 17                	jne    803278 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  803261:	83 ec 0c             	sub    $0xc,%esp
  803264:	6a 00                	push   $0x0
  803266:	e8 ee f3 ff ff       	call   802659 <alloc_block_FF>
  80326b:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80326e:	b8 00 00 00 00       	mov    $0x0,%eax
  803273:	e9 61 03 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  803278:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327c:	74 18                	je     803296 <realloc_block_FF+0x69>
		{
			free_block(va);
  80327e:	83 ec 0c             	sub    $0xc,%esp
  803281:	ff 75 08             	pushl  0x8(%ebp)
  803284:	e8 9d f9 ff ff       	call   802c26 <free_block>
  803289:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80328c:	b8 00 00 00 00       	mov    $0x0,%eax
  803291:	e9 43 03 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  803296:	a1 40 51 90 00       	mov    0x905140,%eax
  80329b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80329e:	e9 02 03 00 00       	jmp    8035a5 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	83 e8 10             	sub    $0x10,%eax
  8032a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032ac:	0f 85 eb 02 00 00    	jne    80359d <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8032b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ba:	83 c2 10             	add    $0x10,%edx
  8032bd:	39 d0                	cmp    %edx,%eax
  8032bf:	75 08                	jne    8032c9 <realloc_block_FF+0x9c>
			{
				return va;
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	e9 10 03 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032d1:	0f 83 e0 01 00 00    	jae    8034b7 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  8032d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032da:	8b 40 08             	mov    0x8(%eax),%eax
  8032dd:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  8032e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e3:	8a 40 04             	mov    0x4(%eax),%al
  8032e6:	3c 01                	cmp    $0x1,%al
  8032e8:	0f 85 06 01 00 00    	jne    8033f4 <realloc_block_FF+0x1c7>
  8032ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f1:	8b 10                	mov    (%eax),%edx
  8032f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8032fb:	29 c1                	sub    %eax,%ecx
  8032fd:	89 c8                	mov    %ecx,%eax
  8032ff:	39 c2                	cmp    %eax,%edx
  803301:	0f 86 ed 00 00 00    	jbe    8033f4 <realloc_block_FF+0x1c7>
  803307:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80330b:	0f 84 e3 00 00 00    	je     8033f4 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  803311:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803314:	8b 10                	mov    (%eax),%edx
  803316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80331e:	01 d0                	add    %edx,%eax
  803320:	83 f8 0f             	cmp    $0xf,%eax
  803323:	0f 86 b5 00 00 00    	jbe    8033de <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80332c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332f:	01 d0                	add    %edx,%eax
  803331:	83 c0 10             	add    $0x10,%eax
  803334:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803337:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80333a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  803340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803343:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803347:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80334b:	74 06                	je     803353 <realloc_block_FF+0x126>
  80334d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803351:	75 17                	jne    80336a <realloc_block_FF+0x13d>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 50 41 80 00       	push   $0x804150
  80335b:	68 ad 01 00 00       	push   $0x1ad
  803360:	68 37 41 80 00       	push   $0x804137
  803365:	e8 08 d4 ff ff       	call   800772 <_panic>
  80336a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336d:	8b 50 08             	mov    0x8(%eax),%edx
  803370:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803373:	89 50 08             	mov    %edx,0x8(%eax)
  803376:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803379:	8b 40 08             	mov    0x8(%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 0c                	je     80338c <realloc_block_FF+0x15f>
  803380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803383:	8b 40 08             	mov    0x8(%eax),%eax
  803386:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803389:	89 50 0c             	mov    %edx,0xc(%eax)
  80338c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803392:	89 50 08             	mov    %edx,0x8(%eax)
  803395:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803398:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80339b:	89 50 0c             	mov    %edx,0xc(%eax)
  80339e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a1:	8b 40 08             	mov    0x8(%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	75 08                	jne    8033b0 <realloc_block_FF+0x183>
  8033a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ab:	a3 44 51 90 00       	mov    %eax,0x905144
  8033b0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8033b5:	40                   	inc    %eax
  8033b6:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  8033bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  8033c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  8033cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ce:	8d 50 10             	lea    0x10(%eax),%edx
  8033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d4:	89 10                	mov    %edx,(%eax)
						return va;
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	e9 fb 01 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  8033de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e1:	8d 50 10             	lea    0x10(%eax),%edx
  8033e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e7:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  8033e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ec:	83 c0 10             	add    $0x10,%eax
  8033ef:	e9 e5 01 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  8033f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f7:	8a 40 04             	mov    0x4(%eax),%al
  8033fa:	3c 01                	cmp    $0x1,%al
  8033fc:	75 59                	jne    803457 <realloc_block_FF+0x22a>
  8033fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803401:	8b 10                	mov    (%eax),%edx
  803403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80340b:	29 c1                	sub    %eax,%ecx
  80340d:	89 c8                	mov    %ecx,%eax
  80340f:	39 c2                	cmp    %eax,%edx
  803411:	75 44                	jne    803457 <realloc_block_FF+0x22a>
  803413:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803417:	74 3e                	je     803457 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803419:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80341c:	8b 40 08             	mov    0x8(%eax),%eax
  80341f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803425:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803428:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  80342b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80342e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803431:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803434:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  80343d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803440:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803444:	8b 45 0c             	mov    0xc(%ebp),%eax
  803447:	8d 50 10             	lea    0x10(%eax),%edx
  80344a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344d:	89 10                	mov    %edx,(%eax)
					return va;
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	e9 82 01 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803457:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345a:	8a 40 04             	mov    0x4(%eax),%al
  80345d:	84 c0                	test   %al,%al
  80345f:	74 0a                	je     80346b <realloc_block_FF+0x23e>
  803461:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803465:	0f 85 32 01 00 00    	jne    80359d <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  80346b:	83 ec 0c             	sub    $0xc,%esp
  80346e:	ff 75 0c             	pushl  0xc(%ebp)
  803471:	e8 e3 f1 ff ff       	call   802659 <alloc_block_FF>
  803476:	83 c4 10             	add    $0x10,%esp
  803479:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  80347c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803480:	74 2b                	je     8034ad <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  803482:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	89 c3                	mov    %eax,%ebx
  80348a:	b8 04 00 00 00       	mov    $0x4,%eax
  80348f:	89 d7                	mov    %edx,%edi
  803491:	89 de                	mov    %ebx,%esi
  803493:	89 c1                	mov    %eax,%ecx
  803495:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  803497:	83 ec 0c             	sub    $0xc,%esp
  80349a:	ff 75 08             	pushl  0x8(%ebp)
  80349d:	e8 84 f7 ff ff       	call   802c26 <free_block>
  8034a2:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  8034a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a8:	e9 2c 01 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  8034ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8034b2:	e9 22 01 00 00       	jmp    8035d9 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  8034b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034bf:	0f 86 d8 00 00 00    	jbe    80359d <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  8034c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034cd:	83 f8 0f             	cmp    $0xf,%eax
  8034d0:	0f 86 b4 00 00 00    	jbe    80358a <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  8034d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034dc:	01 d0                	add    %edx,%eax
  8034de:	83 c0 10             	add    $0x10,%eax
  8034e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  8034e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e7:	8b 00                	mov    (%eax),%eax
  8034e9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034ec:	8d 50 f0             	lea    -0x10(%eax),%edx
  8034ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034f2:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8034f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034f8:	74 06                	je     803500 <realloc_block_FF+0x2d3>
  8034fa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034fe:	75 17                	jne    803517 <realloc_block_FF+0x2ea>
  803500:	83 ec 04             	sub    $0x4,%esp
  803503:	68 50 41 80 00       	push   $0x804150
  803508:	68 dd 01 00 00       	push   $0x1dd
  80350d:	68 37 41 80 00       	push   $0x804137
  803512:	e8 5b d2 ff ff       	call   800772 <_panic>
  803517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351a:	8b 50 08             	mov    0x8(%eax),%edx
  80351d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803520:	89 50 08             	mov    %edx,0x8(%eax)
  803523:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803526:	8b 40 08             	mov    0x8(%eax),%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	74 0c                	je     803539 <realloc_block_FF+0x30c>
  80352d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803530:	8b 40 08             	mov    0x8(%eax),%eax
  803533:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803536:	89 50 0c             	mov    %edx,0xc(%eax)
  803539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80353f:	89 50 08             	mov    %edx,0x8(%eax)
  803542:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803545:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803548:	89 50 0c             	mov    %edx,0xc(%eax)
  80354b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80354e:	8b 40 08             	mov    0x8(%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	75 08                	jne    80355d <realloc_block_FF+0x330>
  803555:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803558:	a3 44 51 90 00       	mov    %eax,0x905144
  80355d:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803562:	40                   	inc    %eax
  803563:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  803568:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80356b:	83 c0 10             	add    $0x10,%eax
  80356e:	83 ec 0c             	sub    $0xc,%esp
  803571:	50                   	push   %eax
  803572:	e8 af f6 ff ff       	call   802c26 <free_block>
  803577:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  80357a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357d:	8d 50 10             	lea    0x10(%eax),%edx
  803580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803583:	89 10                	mov    %edx,(%eax)
					return va;
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	eb 4f                	jmp    8035d9 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  80358a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358d:	8d 50 10             	lea    0x10(%eax),%edx
  803590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803593:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	83 c0 10             	add    $0x10,%eax
  80359b:	eb 3c                	jmp    8035d9 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  80359d:	a1 48 51 90 00       	mov    0x905148,%eax
  8035a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8035a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a9:	74 08                	je     8035b3 <realloc_block_FF+0x386>
  8035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ae:	8b 40 08             	mov    0x8(%eax),%eax
  8035b1:	eb 05                	jmp    8035b8 <realloc_block_FF+0x38b>
  8035b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b8:	a3 48 51 90 00       	mov    %eax,0x905148
  8035bd:	a1 48 51 90 00       	mov    0x905148,%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	0f 85 d9 fc ff ff    	jne    8032a3 <realloc_block_FF+0x76>
  8035ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ce:	0f 85 cf fc ff ff    	jne    8032a3 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  8035d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8035dc:	5b                   	pop    %ebx
  8035dd:	5e                   	pop    %esi
  8035de:	5f                   	pop    %edi
  8035df:	5d                   	pop    %ebp
  8035e0:	c3                   	ret    
  8035e1:	66 90                	xchg   %ax,%ax
  8035e3:	90                   	nop

008035e4 <__udivdi3>:
  8035e4:	55                   	push   %ebp
  8035e5:	57                   	push   %edi
  8035e6:	56                   	push   %esi
  8035e7:	53                   	push   %ebx
  8035e8:	83 ec 1c             	sub    $0x1c,%esp
  8035eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035fb:	89 ca                	mov    %ecx,%edx
  8035fd:	89 f8                	mov    %edi,%eax
  8035ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803603:	85 f6                	test   %esi,%esi
  803605:	75 2d                	jne    803634 <__udivdi3+0x50>
  803607:	39 cf                	cmp    %ecx,%edi
  803609:	77 65                	ja     803670 <__udivdi3+0x8c>
  80360b:	89 fd                	mov    %edi,%ebp
  80360d:	85 ff                	test   %edi,%edi
  80360f:	75 0b                	jne    80361c <__udivdi3+0x38>
  803611:	b8 01 00 00 00       	mov    $0x1,%eax
  803616:	31 d2                	xor    %edx,%edx
  803618:	f7 f7                	div    %edi
  80361a:	89 c5                	mov    %eax,%ebp
  80361c:	31 d2                	xor    %edx,%edx
  80361e:	89 c8                	mov    %ecx,%eax
  803620:	f7 f5                	div    %ebp
  803622:	89 c1                	mov    %eax,%ecx
  803624:	89 d8                	mov    %ebx,%eax
  803626:	f7 f5                	div    %ebp
  803628:	89 cf                	mov    %ecx,%edi
  80362a:	89 fa                	mov    %edi,%edx
  80362c:	83 c4 1c             	add    $0x1c,%esp
  80362f:	5b                   	pop    %ebx
  803630:	5e                   	pop    %esi
  803631:	5f                   	pop    %edi
  803632:	5d                   	pop    %ebp
  803633:	c3                   	ret    
  803634:	39 ce                	cmp    %ecx,%esi
  803636:	77 28                	ja     803660 <__udivdi3+0x7c>
  803638:	0f bd fe             	bsr    %esi,%edi
  80363b:	83 f7 1f             	xor    $0x1f,%edi
  80363e:	75 40                	jne    803680 <__udivdi3+0x9c>
  803640:	39 ce                	cmp    %ecx,%esi
  803642:	72 0a                	jb     80364e <__udivdi3+0x6a>
  803644:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803648:	0f 87 9e 00 00 00    	ja     8036ec <__udivdi3+0x108>
  80364e:	b8 01 00 00 00       	mov    $0x1,%eax
  803653:	89 fa                	mov    %edi,%edx
  803655:	83 c4 1c             	add    $0x1c,%esp
  803658:	5b                   	pop    %ebx
  803659:	5e                   	pop    %esi
  80365a:	5f                   	pop    %edi
  80365b:	5d                   	pop    %ebp
  80365c:	c3                   	ret    
  80365d:	8d 76 00             	lea    0x0(%esi),%esi
  803660:	31 ff                	xor    %edi,%edi
  803662:	31 c0                	xor    %eax,%eax
  803664:	89 fa                	mov    %edi,%edx
  803666:	83 c4 1c             	add    $0x1c,%esp
  803669:	5b                   	pop    %ebx
  80366a:	5e                   	pop    %esi
  80366b:	5f                   	pop    %edi
  80366c:	5d                   	pop    %ebp
  80366d:	c3                   	ret    
  80366e:	66 90                	xchg   %ax,%ax
  803670:	89 d8                	mov    %ebx,%eax
  803672:	f7 f7                	div    %edi
  803674:	31 ff                	xor    %edi,%edi
  803676:	89 fa                	mov    %edi,%edx
  803678:	83 c4 1c             	add    $0x1c,%esp
  80367b:	5b                   	pop    %ebx
  80367c:	5e                   	pop    %esi
  80367d:	5f                   	pop    %edi
  80367e:	5d                   	pop    %ebp
  80367f:	c3                   	ret    
  803680:	bd 20 00 00 00       	mov    $0x20,%ebp
  803685:	89 eb                	mov    %ebp,%ebx
  803687:	29 fb                	sub    %edi,%ebx
  803689:	89 f9                	mov    %edi,%ecx
  80368b:	d3 e6                	shl    %cl,%esi
  80368d:	89 c5                	mov    %eax,%ebp
  80368f:	88 d9                	mov    %bl,%cl
  803691:	d3 ed                	shr    %cl,%ebp
  803693:	89 e9                	mov    %ebp,%ecx
  803695:	09 f1                	or     %esi,%ecx
  803697:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80369b:	89 f9                	mov    %edi,%ecx
  80369d:	d3 e0                	shl    %cl,%eax
  80369f:	89 c5                	mov    %eax,%ebp
  8036a1:	89 d6                	mov    %edx,%esi
  8036a3:	88 d9                	mov    %bl,%cl
  8036a5:	d3 ee                	shr    %cl,%esi
  8036a7:	89 f9                	mov    %edi,%ecx
  8036a9:	d3 e2                	shl    %cl,%edx
  8036ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036af:	88 d9                	mov    %bl,%cl
  8036b1:	d3 e8                	shr    %cl,%eax
  8036b3:	09 c2                	or     %eax,%edx
  8036b5:	89 d0                	mov    %edx,%eax
  8036b7:	89 f2                	mov    %esi,%edx
  8036b9:	f7 74 24 0c          	divl   0xc(%esp)
  8036bd:	89 d6                	mov    %edx,%esi
  8036bf:	89 c3                	mov    %eax,%ebx
  8036c1:	f7 e5                	mul    %ebp
  8036c3:	39 d6                	cmp    %edx,%esi
  8036c5:	72 19                	jb     8036e0 <__udivdi3+0xfc>
  8036c7:	74 0b                	je     8036d4 <__udivdi3+0xf0>
  8036c9:	89 d8                	mov    %ebx,%eax
  8036cb:	31 ff                	xor    %edi,%edi
  8036cd:	e9 58 ff ff ff       	jmp    80362a <__udivdi3+0x46>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036d8:	89 f9                	mov    %edi,%ecx
  8036da:	d3 e2                	shl    %cl,%edx
  8036dc:	39 c2                	cmp    %eax,%edx
  8036de:	73 e9                	jae    8036c9 <__udivdi3+0xe5>
  8036e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036e3:	31 ff                	xor    %edi,%edi
  8036e5:	e9 40 ff ff ff       	jmp    80362a <__udivdi3+0x46>
  8036ea:	66 90                	xchg   %ax,%ax
  8036ec:	31 c0                	xor    %eax,%eax
  8036ee:	e9 37 ff ff ff       	jmp    80362a <__udivdi3+0x46>
  8036f3:	90                   	nop

008036f4 <__umoddi3>:
  8036f4:	55                   	push   %ebp
  8036f5:	57                   	push   %edi
  8036f6:	56                   	push   %esi
  8036f7:	53                   	push   %ebx
  8036f8:	83 ec 1c             	sub    $0x1c,%esp
  8036fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803703:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803707:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80370b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80370f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803713:	89 f3                	mov    %esi,%ebx
  803715:	89 fa                	mov    %edi,%edx
  803717:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371b:	89 34 24             	mov    %esi,(%esp)
  80371e:	85 c0                	test   %eax,%eax
  803720:	75 1a                	jne    80373c <__umoddi3+0x48>
  803722:	39 f7                	cmp    %esi,%edi
  803724:	0f 86 a2 00 00 00    	jbe    8037cc <__umoddi3+0xd8>
  80372a:	89 c8                	mov    %ecx,%eax
  80372c:	89 f2                	mov    %esi,%edx
  80372e:	f7 f7                	div    %edi
  803730:	89 d0                	mov    %edx,%eax
  803732:	31 d2                	xor    %edx,%edx
  803734:	83 c4 1c             	add    $0x1c,%esp
  803737:	5b                   	pop    %ebx
  803738:	5e                   	pop    %esi
  803739:	5f                   	pop    %edi
  80373a:	5d                   	pop    %ebp
  80373b:	c3                   	ret    
  80373c:	39 f0                	cmp    %esi,%eax
  80373e:	0f 87 ac 00 00 00    	ja     8037f0 <__umoddi3+0xfc>
  803744:	0f bd e8             	bsr    %eax,%ebp
  803747:	83 f5 1f             	xor    $0x1f,%ebp
  80374a:	0f 84 ac 00 00 00    	je     8037fc <__umoddi3+0x108>
  803750:	bf 20 00 00 00       	mov    $0x20,%edi
  803755:	29 ef                	sub    %ebp,%edi
  803757:	89 fe                	mov    %edi,%esi
  803759:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80375d:	89 e9                	mov    %ebp,%ecx
  80375f:	d3 e0                	shl    %cl,%eax
  803761:	89 d7                	mov    %edx,%edi
  803763:	89 f1                	mov    %esi,%ecx
  803765:	d3 ef                	shr    %cl,%edi
  803767:	09 c7                	or     %eax,%edi
  803769:	89 e9                	mov    %ebp,%ecx
  80376b:	d3 e2                	shl    %cl,%edx
  80376d:	89 14 24             	mov    %edx,(%esp)
  803770:	89 d8                	mov    %ebx,%eax
  803772:	d3 e0                	shl    %cl,%eax
  803774:	89 c2                	mov    %eax,%edx
  803776:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377a:	d3 e0                	shl    %cl,%eax
  80377c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803780:	8b 44 24 08          	mov    0x8(%esp),%eax
  803784:	89 f1                	mov    %esi,%ecx
  803786:	d3 e8                	shr    %cl,%eax
  803788:	09 d0                	or     %edx,%eax
  80378a:	d3 eb                	shr    %cl,%ebx
  80378c:	89 da                	mov    %ebx,%edx
  80378e:	f7 f7                	div    %edi
  803790:	89 d3                	mov    %edx,%ebx
  803792:	f7 24 24             	mull   (%esp)
  803795:	89 c6                	mov    %eax,%esi
  803797:	89 d1                	mov    %edx,%ecx
  803799:	39 d3                	cmp    %edx,%ebx
  80379b:	0f 82 87 00 00 00    	jb     803828 <__umoddi3+0x134>
  8037a1:	0f 84 91 00 00 00    	je     803838 <__umoddi3+0x144>
  8037a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037ab:	29 f2                	sub    %esi,%edx
  8037ad:	19 cb                	sbb    %ecx,%ebx
  8037af:	89 d8                	mov    %ebx,%eax
  8037b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037b5:	d3 e0                	shl    %cl,%eax
  8037b7:	89 e9                	mov    %ebp,%ecx
  8037b9:	d3 ea                	shr    %cl,%edx
  8037bb:	09 d0                	or     %edx,%eax
  8037bd:	89 e9                	mov    %ebp,%ecx
  8037bf:	d3 eb                	shr    %cl,%ebx
  8037c1:	89 da                	mov    %ebx,%edx
  8037c3:	83 c4 1c             	add    $0x1c,%esp
  8037c6:	5b                   	pop    %ebx
  8037c7:	5e                   	pop    %esi
  8037c8:	5f                   	pop    %edi
  8037c9:	5d                   	pop    %ebp
  8037ca:	c3                   	ret    
  8037cb:	90                   	nop
  8037cc:	89 fd                	mov    %edi,%ebp
  8037ce:	85 ff                	test   %edi,%edi
  8037d0:	75 0b                	jne    8037dd <__umoddi3+0xe9>
  8037d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037d7:	31 d2                	xor    %edx,%edx
  8037d9:	f7 f7                	div    %edi
  8037db:	89 c5                	mov    %eax,%ebp
  8037dd:	89 f0                	mov    %esi,%eax
  8037df:	31 d2                	xor    %edx,%edx
  8037e1:	f7 f5                	div    %ebp
  8037e3:	89 c8                	mov    %ecx,%eax
  8037e5:	f7 f5                	div    %ebp
  8037e7:	89 d0                	mov    %edx,%eax
  8037e9:	e9 44 ff ff ff       	jmp    803732 <__umoddi3+0x3e>
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	89 c8                	mov    %ecx,%eax
  8037f2:	89 f2                	mov    %esi,%edx
  8037f4:	83 c4 1c             	add    $0x1c,%esp
  8037f7:	5b                   	pop    %ebx
  8037f8:	5e                   	pop    %esi
  8037f9:	5f                   	pop    %edi
  8037fa:	5d                   	pop    %ebp
  8037fb:	c3                   	ret    
  8037fc:	3b 04 24             	cmp    (%esp),%eax
  8037ff:	72 06                	jb     803807 <__umoddi3+0x113>
  803801:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803805:	77 0f                	ja     803816 <__umoddi3+0x122>
  803807:	89 f2                	mov    %esi,%edx
  803809:	29 f9                	sub    %edi,%ecx
  80380b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80380f:	89 14 24             	mov    %edx,(%esp)
  803812:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803816:	8b 44 24 04          	mov    0x4(%esp),%eax
  80381a:	8b 14 24             	mov    (%esp),%edx
  80381d:	83 c4 1c             	add    $0x1c,%esp
  803820:	5b                   	pop    %ebx
  803821:	5e                   	pop    %esi
  803822:	5f                   	pop    %edi
  803823:	5d                   	pop    %ebp
  803824:	c3                   	ret    
  803825:	8d 76 00             	lea    0x0(%esi),%esi
  803828:	2b 04 24             	sub    (%esp),%eax
  80382b:	19 fa                	sbb    %edi,%edx
  80382d:	89 d1                	mov    %edx,%ecx
  80382f:	89 c6                	mov    %eax,%esi
  803831:	e9 71 ff ff ff       	jmp    8037a7 <__umoddi3+0xb3>
  803836:	66 90                	xchg   %ax,%ax
  803838:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80383c:	72 ea                	jb     803828 <__umoddi3+0x134>
  80383e:	89 d9                	mov    %ebx,%ecx
  803840:	e9 62 ff ff ff       	jmp    8037a7 <__umoddi3+0xb3>
