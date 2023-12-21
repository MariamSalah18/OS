
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 52 20 00 00       	call   802098 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 39 80 00       	push   $0x8039e0
  80004e:	e8 5d 0b 00 00       	call   800bb0 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 39 80 00       	push   $0x8039e2
  80005e:	e8 4d 0b 00 00       	call   800bb0 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 39 80 00       	push   $0x8039f8
  80006e:	e8 3d 0b 00 00       	call   800bb0 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 39 80 00       	push   $0x8039e2
  80007e:	e8 2d 0b 00 00       	call   800bb0 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 39 80 00       	push   $0x8039e0
  80008e:	e8 1d 0b 00 00       	call   800bb0 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 10 3a 80 00       	push   $0x803a10
  8000a5:	e8 88 11 00 00       	call   801232 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 d8 16 00 00       	call   801798 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 0c 1b 00 00       	call   801be1 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 30 3a 80 00       	push   $0x803a30
  8000e3:	e8 c8 0a 00 00       	call   800bb0 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 52 3a 80 00       	push   $0x803a52
  8000f3:	e8 b8 0a 00 00       	call   800bb0 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 60 3a 80 00       	push   $0x803a60
  800103:	e8 a8 0a 00 00       	call   800bb0 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 6f 3a 80 00       	push   $0x803a6f
  800113:	e8 98 0a 00 00       	call   800bb0 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 7f 3a 80 00       	push   $0x803a7f
  800123:	e8 88 0a 00 00       	call   800bb0 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 4b 1f 00 00       	call   8020b2 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
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
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 bc 1e 00 00       	call   802098 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 88 3a 80 00       	push   $0x803a88
  8001e4:	e8 c7 09 00 00       	call   800bb0 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 c1 1e 00 00       	call   8020b2 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 bc 3a 80 00       	push   $0x803abc
  800213:	6a 4a                	push   $0x4a
  800215:	68 de 3a 80 00       	push   $0x803ade
  80021a:	e8 d4 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 74 1e 00 00       	call   802098 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 fc 3a 80 00       	push   $0x803afc
  80022c:	e8 7f 09 00 00       	call   800bb0 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 30 3b 80 00       	push   $0x803b30
  80023c:	e8 6f 09 00 00       	call   800bb0 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 64 3b 80 00       	push   $0x803b64
  80024c:	e8 5f 09 00 00       	call   800bb0 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 59 1e 00 00       	call   8020b2 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 d9 1a 00 00       	call   801d3d <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 2c 1e 00 00       	call   802098 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 96 3b 80 00       	push   $0x803b96
  80027a:	e8 31 09 00 00       	call   800bb0 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 ed 1d 00 00       	call   8020b2 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 e0 39 80 00       	push   $0x8039e0
  800459:	e8 52 07 00 00       	call   800bb0 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 b4 3b 80 00       	push   $0x803bb4
  80047b:	e8 30 07 00 00       	call   800bb0 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 b9 3b 80 00       	push   $0x803bb9
  8004a9:	e8 02 07 00 00       	call   800bb0 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 92 16 00 00       	call   801be1 <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 7d 16 00 00       	call   801be1 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 2c 16 00 00       	call   801d3d <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 1e 16 00 00       	call   801d3d <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 8e 19 00 00       	call   8020cc <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 49 19 00 00       	call   802098 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 6a 19 00 00       	call   8020cc <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 48 19 00 00       	call   8020b2 <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 e7 17 00 00       	call   801f68 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 fe 18 00 00       	call   802098 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 c0 17 00 00       	call   801f68 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 fc 18 00 00       	call   8020b2 <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 bb 1a 00 00       	call   80228b <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 06             	shl    $0x6,%eax
  8007df:	29 d0                	sub    %edx,%eax
  8007e1:	c1 e0 03             	shl    $0x3,%eax
  8007e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e9:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8007f3:	8a 40 68             	mov    0x68(%eax),%al
  8007f6:	84 c0                	test   %al,%al
  8007f8:	74 0d                	je     800807 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8007fa:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ff:	83 c0 68             	add    $0x68,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x52>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 6b 18 00 00       	call   802098 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 d8 3b 80 00       	push   $0x803bd8
  800835:	e8 76 03 00 00       	call   800bb0 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 00 3c 80 00       	push   $0x803c00
  80085d:	e8 4e 03 00 00       	call   800bb0 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 28 3c 80 00       	push   $0x803c28
  80088e:	e8 1d 03 00 00       	call   800bb0 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 80 3c 80 00       	push   $0x803c80
  8008aa:	e8 01 03 00 00       	call   800bb0 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 d8 3b 80 00       	push   $0x803bd8
  8008ba:	e8 f1 02 00 00       	call   800bb0 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 eb 17 00 00       	call   8020b2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 78 19 00 00       	call   802257 <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 cd 19 00 00       	call   8022bd <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 18 51 80 00       	mov    0x805118,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 18 51 80 00       	mov    0x805118,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 94 3c 80 00       	push   $0x803c94
  800919:	e8 92 02 00 00       	call   800bb0 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 99 3c 80 00       	push   $0x803c99
  800932:	e8 79 02 00 00       	call   800bb0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 fc 01 00 00       	call   800b45 <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 b5 3c 80 00       	push   $0x803cb5
  800956:	e8 ea 01 00 00       	call   800b45 <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800976:	8b 45 0c             	mov    0xc(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	74 14                	je     800991 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097d:	83 ec 04             	sub    $0x4,%esp
  800980:	68 b8 3c 80 00       	push   $0x803cb8
  800985:	6a 26                	push   $0x26
  800987:	68 04 3d 80 00       	push   $0x803d04
  80098c:	e8 62 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800991:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800998:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099f:	e9 c5 00 00 00       	jmp    800a69 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	01 d0                	add    %edx,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	75 08                	jne    8009c1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009b9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009bc:	e9 a5 00 00 00       	jmp    800a66 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cf:	eb 69                	jmp    800a3a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009d1:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d6:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8009dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009df:	89 d0                	mov    %edx,%eax
  8009e1:	01 c0                	add    %eax,%eax
  8009e3:	01 d0                	add    %edx,%eax
  8009e5:	c1 e0 03             	shl    $0x3,%eax
  8009e8:	01 c8                	add    %ecx,%eax
  8009ea:	8a 40 04             	mov    0x4(%eax),%al
  8009ed:	84 c0                	test   %al,%al
  8009ef:	75 46                	jne    800a37 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009f1:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f6:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8009fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ff:	89 d0                	mov    %edx,%eax
  800a01:	01 c0                	add    %eax,%eax
  800a03:	01 d0                	add    %edx,%eax
  800a05:	c1 e0 03             	shl    $0x3,%eax
  800a08:	01 c8                	add    %ecx,%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a17:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	01 c8                	add    %ecx,%eax
  800a28:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a2a:	39 c2                	cmp    %eax,%edx
  800a2c:	75 09                	jne    800a37 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a2e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a35:	eb 15                	jmp    800a4c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a37:	ff 45 e8             	incl   -0x18(%ebp)
  800a3a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a48:	39 c2                	cmp    %eax,%edx
  800a4a:	77 85                	ja     8009d1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a50:	75 14                	jne    800a66 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a52:	83 ec 04             	sub    $0x4,%esp
  800a55:	68 10 3d 80 00       	push   $0x803d10
  800a5a:	6a 3a                	push   $0x3a
  800a5c:	68 04 3d 80 00       	push   $0x803d04
  800a61:	e8 8d fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a66:	ff 45 f0             	incl   -0x10(%ebp)
  800a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a6f:	0f 8c 2f ff ff ff    	jl     8009a4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a7c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a83:	eb 26                	jmp    800aab <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a85:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8a:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800a90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a93:	89 d0                	mov    %edx,%eax
  800a95:	01 c0                	add    %eax,%eax
  800a97:	01 d0                	add    %edx,%eax
  800a99:	c1 e0 03             	shl    $0x3,%eax
  800a9c:	01 c8                	add    %ecx,%eax
  800a9e:	8a 40 04             	mov    0x4(%eax),%al
  800aa1:	3c 01                	cmp    $0x1,%al
  800aa3:	75 03                	jne    800aa8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800aa5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa8:	ff 45 e0             	incl   -0x20(%ebp)
  800aab:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab0:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab9:	39 c2                	cmp    %eax,%edx
  800abb:	77 c8                	ja     800a85 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac3:	74 14                	je     800ad9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	68 64 3d 80 00       	push   $0x803d64
  800acd:	6a 44                	push   $0x44
  800acf:	68 04 3d 80 00       	push   $0x803d04
  800ad4:	e8 1a fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad9:	90                   	nop
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	8d 48 01             	lea    0x1(%eax),%ecx
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	89 0a                	mov    %ecx,(%edx)
  800aef:	8b 55 08             	mov    0x8(%ebp),%edx
  800af2:	88 d1                	mov    %dl,%cl
  800af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8b 00                	mov    (%eax),%eax
  800b00:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b05:	75 2c                	jne    800b33 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b07:	a0 28 50 80 00       	mov    0x805028,%al
  800b0c:	0f b6 c0             	movzbl %al,%eax
  800b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b12:	8b 12                	mov    (%edx),%edx
  800b14:	89 d1                	mov    %edx,%ecx
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	83 c2 08             	add    $0x8,%edx
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	50                   	push   %eax
  800b20:	51                   	push   %ecx
  800b21:	52                   	push   %edx
  800b22:	e8 18 14 00 00       	call   801f3f <sys_cputs>
  800b27:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 04             	mov    0x4(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b4e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b55:	00 00 00 
	b.cnt = 0;
  800b58:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b5f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b6e:	50                   	push   %eax
  800b6f:	68 dc 0a 80 00       	push   $0x800adc
  800b74:	e8 11 02 00 00       	call   800d8a <vprintfmt>
  800b79:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b7c:	a0 28 50 80 00       	mov    0x805028,%al
  800b81:	0f b6 c0             	movzbl %al,%eax
  800b84:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8a:	83 ec 04             	sub    $0x4,%esp
  800b8d:	50                   	push   %eax
  800b8e:	52                   	push   %edx
  800b8f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b95:	83 c0 08             	add    $0x8,%eax
  800b98:	50                   	push   %eax
  800b99:	e8 a1 13 00 00       	call   801f3f <sys_cputs>
  800b9e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800ba8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bb6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bbd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcc:	50                   	push   %eax
  800bcd:	e8 73 ff ff ff       	call   800b45 <vcprintf>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be3:	e8 b0 14 00 00       	call   802098 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800be8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	50                   	push   %eax
  800bf8:	e8 48 ff ff ff       	call   800b45 <vcprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c03:	e8 aa 14 00 00       	call   8020b2 <sys_enable_interrupt>
	return cnt;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	53                   	push   %ebx
  800c11:	83 ec 14             	sub    $0x14,%esp
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c20:	8b 45 18             	mov    0x18(%ebp),%eax
  800c23:	ba 00 00 00 00       	mov    $0x0,%edx
  800c28:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c2b:	77 55                	ja     800c82 <printnum+0x75>
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	72 05                	jb     800c37 <printnum+0x2a>
  800c32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c35:	77 4b                	ja     800c82 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c37:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c3d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c40:	ba 00 00 00 00       	mov    $0x0,%edx
  800c45:	52                   	push   %edx
  800c46:	50                   	push   %eax
  800c47:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c4d:	e8 12 2b 00 00       	call   803764 <__udivdi3>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	83 ec 04             	sub    $0x4,%esp
  800c58:	ff 75 20             	pushl  0x20(%ebp)
  800c5b:	53                   	push   %ebx
  800c5c:	ff 75 18             	pushl  0x18(%ebp)
  800c5f:	52                   	push   %edx
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 a1 ff ff ff       	call   800c0d <printnum>
  800c6c:	83 c4 20             	add    $0x20,%esp
  800c6f:	eb 1a                	jmp    800c8b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 0c             	pushl  0xc(%ebp)
  800c77:	ff 75 20             	pushl  0x20(%ebp)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c82:	ff 4d 1c             	decl   0x1c(%ebp)
  800c85:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c89:	7f e6                	jg     800c71 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c8b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c99:	53                   	push   %ebx
  800c9a:	51                   	push   %ecx
  800c9b:	52                   	push   %edx
  800c9c:	50                   	push   %eax
  800c9d:	e8 d2 2b 00 00       	call   803874 <__umoddi3>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	05 d4 3f 80 00       	add    $0x803fd4,%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	0f be c0             	movsbl %al,%eax
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	50                   	push   %eax
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
}
  800cbe:	90                   	nop
  800cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cc7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ccb:	7e 1c                	jle    800ce9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8b 00                	mov    (%eax),%eax
  800cd2:	8d 50 08             	lea    0x8(%eax),%edx
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	89 10                	mov    %edx,(%eax)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	83 e8 08             	sub    $0x8,%eax
  800ce2:	8b 50 04             	mov    0x4(%eax),%edx
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	eb 40                	jmp    800d29 <getuint+0x65>
	else if (lflag)
  800ce9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ced:	74 1e                	je     800d0d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8b 00                	mov    (%eax),%eax
  800cf4:	8d 50 04             	lea    0x4(%eax),%edx
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	89 10                	mov    %edx,(%eax)
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8b 00                	mov    (%eax),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0b:	eb 1c                	jmp    800d29 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	8d 50 04             	lea    0x4(%eax),%edx
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	89 10                	mov    %edx,(%eax)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8b 00                	mov    (%eax),%eax
  800d1f:	83 e8 04             	sub    $0x4,%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d2e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d32:	7e 1c                	jle    800d50 <getint+0x25>
		return va_arg(*ap, long long);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8b 00                	mov    (%eax),%eax
  800d39:	8d 50 08             	lea    0x8(%eax),%edx
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 10                	mov    %edx,(%eax)
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	83 e8 08             	sub    $0x8,%eax
  800d49:	8b 50 04             	mov    0x4(%eax),%edx
  800d4c:	8b 00                	mov    (%eax),%eax
  800d4e:	eb 38                	jmp    800d88 <getint+0x5d>
	else if (lflag)
  800d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d54:	74 1a                	je     800d70 <getint+0x45>
		return va_arg(*ap, long);
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8b 00                	mov    (%eax),%eax
  800d5b:	8d 50 04             	lea    0x4(%eax),%edx
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	89 10                	mov    %edx,(%eax)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	99                   	cltd   
  800d6e:	eb 18                	jmp    800d88 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	8d 50 04             	lea    0x4(%eax),%edx
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 10                	mov    %edx,(%eax)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8b 00                	mov    (%eax),%eax
  800d82:	83 e8 04             	sub    $0x4,%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	99                   	cltd   
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d92:	eb 17                	jmp    800dab <vprintfmt+0x21>
			if (ch == '\0')
  800d94:	85 db                	test   %ebx,%ebx
  800d96:	0f 84 af 03 00 00    	je     80114b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	53                   	push   %ebx
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	ff d0                	call   *%eax
  800da8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	89 55 10             	mov    %edx,0x10(%ebp)
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	0f b6 d8             	movzbl %al,%ebx
  800db9:	83 fb 25             	cmp    $0x25,%ebx
  800dbc:	75 d6                	jne    800d94 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dbe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dd7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dde:	8b 45 10             	mov    0x10(%ebp),%eax
  800de1:	8d 50 01             	lea    0x1(%eax),%edx
  800de4:	89 55 10             	mov    %edx,0x10(%ebp)
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	0f b6 d8             	movzbl %al,%ebx
  800dec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800def:	83 f8 55             	cmp    $0x55,%eax
  800df2:	0f 87 2b 03 00 00    	ja     801123 <vprintfmt+0x399>
  800df8:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
  800dff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e01:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e05:	eb d7                	jmp    800dde <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e07:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e0b:	eb d1                	jmp    800dde <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e17:	89 d0                	mov    %edx,%eax
  800e19:	c1 e0 02             	shl    $0x2,%eax
  800e1c:	01 d0                	add    %edx,%eax
  800e1e:	01 c0                	add    %eax,%eax
  800e20:	01 d8                	add    %ebx,%eax
  800e22:	83 e8 30             	sub    $0x30,%eax
  800e25:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e30:	83 fb 2f             	cmp    $0x2f,%ebx
  800e33:	7e 3e                	jle    800e73 <vprintfmt+0xe9>
  800e35:	83 fb 39             	cmp    $0x39,%ebx
  800e38:	7f 39                	jg     800e73 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e3d:	eb d5                	jmp    800e14 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 c0 04             	add    $0x4,%eax
  800e45:	89 45 14             	mov    %eax,0x14(%ebp)
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	83 e8 04             	sub    $0x4,%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e53:	eb 1f                	jmp    800e74 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e59:	79 83                	jns    800dde <vprintfmt+0x54>
				width = 0;
  800e5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e62:	e9 77 ff ff ff       	jmp    800dde <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e67:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e6e:	e9 6b ff ff ff       	jmp    800dde <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e73:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	0f 89 60 ff ff ff    	jns    800dde <vprintfmt+0x54>
				width = precision, precision = -1;
  800e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e8b:	e9 4e ff ff ff       	jmp    800dde <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e90:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e93:	e9 46 ff ff ff       	jmp    800dde <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 00                	mov    (%eax),%eax
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	50                   	push   %eax
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	ff d0                	call   *%eax
  800eb5:	83 c4 10             	add    $0x10,%esp
			break;
  800eb8:	e9 89 02 00 00       	jmp    801146 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 c0 04             	add    $0x4,%eax
  800ec3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec9:	83 e8 04             	sub    $0x4,%eax
  800ecc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ece:	85 db                	test   %ebx,%ebx
  800ed0:	79 02                	jns    800ed4 <vprintfmt+0x14a>
				err = -err;
  800ed2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed4:	83 fb 64             	cmp    $0x64,%ebx
  800ed7:	7f 0b                	jg     800ee4 <vprintfmt+0x15a>
  800ed9:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  800ee0:	85 f6                	test   %esi,%esi
  800ee2:	75 19                	jne    800efd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee4:	53                   	push   %ebx
  800ee5:	68 e5 3f 80 00       	push   $0x803fe5
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	ff 75 08             	pushl  0x8(%ebp)
  800ef0:	e8 5e 02 00 00       	call   801153 <printfmt>
  800ef5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ef8:	e9 49 02 00 00       	jmp    801146 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800efd:	56                   	push   %esi
  800efe:	68 ee 3f 80 00       	push   $0x803fee
  800f03:	ff 75 0c             	pushl  0xc(%ebp)
  800f06:	ff 75 08             	pushl  0x8(%ebp)
  800f09:	e8 45 02 00 00       	call   801153 <printfmt>
  800f0e:	83 c4 10             	add    $0x10,%esp
			break;
  800f11:	e9 30 02 00 00       	jmp    801146 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 c0 04             	add    $0x4,%eax
  800f1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f22:	83 e8 04             	sub    $0x4,%eax
  800f25:	8b 30                	mov    (%eax),%esi
  800f27:	85 f6                	test   %esi,%esi
  800f29:	75 05                	jne    800f30 <vprintfmt+0x1a6>
				p = "(null)";
  800f2b:	be f1 3f 80 00       	mov    $0x803ff1,%esi
			if (width > 0 && padc != '-')
  800f30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f34:	7e 6d                	jle    800fa3 <vprintfmt+0x219>
  800f36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3a:	74 67                	je     800fa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	50                   	push   %eax
  800f43:	56                   	push   %esi
  800f44:	e8 12 05 00 00       	call   80145b <strnlen>
  800f49:	83 c4 10             	add    $0x10,%esp
  800f4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f4f:	eb 16                	jmp    800f67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	50                   	push   %eax
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f64:	ff 4d e4             	decl   -0x1c(%ebp)
  800f67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f6b:	7f e4                	jg     800f51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f73:	74 1c                	je     800f91 <vprintfmt+0x207>
  800f75:	83 fb 1f             	cmp    $0x1f,%ebx
  800f78:	7e 05                	jle    800f7f <vprintfmt+0x1f5>
  800f7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f7d:	7e 12                	jle    800f91 <vprintfmt+0x207>
					putch('?', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	6a 3f                	push   $0x3f
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
  800f8f:	eb 0f                	jmp    800fa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	53                   	push   %ebx
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	ff d0                	call   *%eax
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa3:	89 f0                	mov    %esi,%eax
  800fa5:	8d 70 01             	lea    0x1(%eax),%esi
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f be d8             	movsbl %al,%ebx
  800fad:	85 db                	test   %ebx,%ebx
  800faf:	74 24                	je     800fd5 <vprintfmt+0x24b>
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	78 b8                	js     800f6f <vprintfmt+0x1e5>
  800fb7:	ff 4d e0             	decl   -0x20(%ebp)
  800fba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fbe:	79 af                	jns    800f6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc0:	eb 13                	jmp    800fd5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 20                	push   $0x20
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd9:	7f e7                	jg     800fc2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fdb:	e9 66 01 00 00       	jmp    801146 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe0:	83 ec 08             	sub    $0x8,%esp
  800fe3:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe6:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe9:	50                   	push   %eax
  800fea:	e8 3c fd ff ff       	call   800d2b <getint>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffe:	85 d2                	test   %edx,%edx
  801000:	79 23                	jns    801025 <vprintfmt+0x29b>
				putch('-', putdat);
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	ff 75 0c             	pushl  0xc(%ebp)
  801008:	6a 2d                	push   $0x2d
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	ff d0                	call   *%eax
  80100f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801018:	f7 d8                	neg    %eax
  80101a:	83 d2 00             	adc    $0x0,%edx
  80101d:	f7 da                	neg    %edx
  80101f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801022:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801025:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102c:	e9 bc 00 00 00       	jmp    8010ed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 e8             	pushl  -0x18(%ebp)
  801037:	8d 45 14             	lea    0x14(%ebp),%eax
  80103a:	50                   	push   %eax
  80103b:	e8 84 fc ff ff       	call   800cc4 <getuint>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801049:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801050:	e9 98 00 00 00       	jmp    8010ed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	ff 75 0c             	pushl  0xc(%ebp)
  80105b:	6a 58                	push   $0x58
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	ff d0                	call   *%eax
  801062:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			break;
  801085:	e9 bc 00 00 00       	jmp    801146 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108a:	83 ec 08             	sub    $0x8,%esp
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	6a 30                	push   $0x30
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	ff d0                	call   *%eax
  801097:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 78                	push   $0x78
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 c0 04             	add    $0x4,%eax
  8010b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b6:	83 e8 04             	sub    $0x4,%eax
  8010b9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010cc:	eb 1f                	jmp    8010ed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	e8 e7 fb ff ff       	call   800cc4 <getuint>
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f4:	83 ec 04             	sub    $0x4,%esp
  8010f7:	52                   	push   %edx
  8010f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010fb:	50                   	push   %eax
  8010fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	ff 75 08             	pushl  0x8(%ebp)
  801108:	e8 00 fb ff ff       	call   800c0d <printnum>
  80110d:	83 c4 20             	add    $0x20,%esp
			break;
  801110:	eb 34                	jmp    801146 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	53                   	push   %ebx
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	ff d0                	call   *%eax
  80111e:	83 c4 10             	add    $0x10,%esp
			break;
  801121:	eb 23                	jmp    801146 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801123:	83 ec 08             	sub    $0x8,%esp
  801126:	ff 75 0c             	pushl  0xc(%ebp)
  801129:	6a 25                	push   $0x25
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	ff d0                	call   *%eax
  801130:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801133:	ff 4d 10             	decl   0x10(%ebp)
  801136:	eb 03                	jmp    80113b <vprintfmt+0x3b1>
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	48                   	dec    %eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 25                	cmp    $0x25,%al
  801143:	75 f3                	jne    801138 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801145:	90                   	nop
		}
	}
  801146:	e9 47 fc ff ff       	jmp    800d92 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80114b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80114c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801159:	8d 45 10             	lea    0x10(%ebp),%eax
  80115c:	83 c0 04             	add    $0x4,%eax
  80115f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	ff 75 f4             	pushl  -0xc(%ebp)
  801168:	50                   	push   %eax
  801169:	ff 75 0c             	pushl  0xc(%ebp)
  80116c:	ff 75 08             	pushl  0x8(%ebp)
  80116f:	e8 16 fc ff ff       	call   800d8a <vprintfmt>
  801174:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801177:	90                   	nop
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8b 40 08             	mov    0x8(%eax),%eax
  801183:	8d 50 01             	lea    0x1(%eax),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	8b 10                	mov    (%eax),%edx
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 40 04             	mov    0x4(%eax),%eax
  801197:	39 c2                	cmp    %eax,%edx
  801199:	73 12                	jae    8011ad <sprintputch+0x33>
		*b->buf++ = ch;
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8b 00                	mov    (%eax),%eax
  8011a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a6:	89 0a                	mov    %ecx,(%edx)
  8011a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ab:	88 10                	mov    %dl,(%eax)
}
  8011ad:	90                   	nop
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d5:	74 06                	je     8011dd <vsnprintf+0x2d>
  8011d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011db:	7f 07                	jg     8011e4 <vsnprintf+0x34>
		return -E_INVAL;
  8011dd:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e2:	eb 20                	jmp    801204 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e4:	ff 75 14             	pushl  0x14(%ebp)
  8011e7:	ff 75 10             	pushl  0x10(%ebp)
  8011ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011ed:	50                   	push   %eax
  8011ee:	68 7a 11 80 00       	push   $0x80117a
  8011f3:	e8 92 fb ff ff       	call   800d8a <vprintfmt>
  8011f8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80120c:	8d 45 10             	lea    0x10(%ebp),%eax
  80120f:	83 c0 04             	add    $0x4,%eax
  801212:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	ff 75 f4             	pushl  -0xc(%ebp)
  80121b:	50                   	push   %eax
  80121c:	ff 75 0c             	pushl  0xc(%ebp)
  80121f:	ff 75 08             	pushl  0x8(%ebp)
  801222:	e8 89 ff ff ff       	call   8011b0 <vsnprintf>
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80122d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801238:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123c:	74 13                	je     801251 <readline+0x1f>
		cprintf("%s", prompt);
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	ff 75 08             	pushl  0x8(%ebp)
  801244:	68 50 41 80 00       	push   $0x804150
  801249:	e8 62 f9 ff ff       	call   800bb0 <cprintf>
  80124e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801258:	83 ec 0c             	sub    $0xc,%esp
  80125b:	6a 00                	push   $0x0
  80125d:	e8 59 f5 ff ff       	call   8007bb <iscons>
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801268:	e8 00 f5 ff ff       	call   80076d <getchar>
  80126d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801270:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801274:	79 22                	jns    801298 <readline+0x66>
			if (c != -E_EOF)
  801276:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127a:	0f 84 ad 00 00 00    	je     80132d <readline+0xfb>
				cprintf("read error: %e\n", c);
  801280:	83 ec 08             	sub    $0x8,%esp
  801283:	ff 75 ec             	pushl  -0x14(%ebp)
  801286:	68 53 41 80 00       	push   $0x804153
  80128b:	e8 20 f9 ff ff       	call   800bb0 <cprintf>
  801290:	83 c4 10             	add    $0x10,%esp
			return;
  801293:	e9 95 00 00 00       	jmp    80132d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801298:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80129c:	7e 34                	jle    8012d2 <readline+0xa0>
  80129e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012a5:	7f 2b                	jg     8012d2 <readline+0xa0>
			if (echoing)
  8012a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ab:	74 0e                	je     8012bb <readline+0x89>
				cputchar(c);
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b3:	e8 6d f4 ff ff       	call   800725 <cputchar>
  8012b8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 d0                	add    %edx,%eax
  8012cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ce:	88 10                	mov    %dl,(%eax)
  8012d0:	eb 56                	jmp    801328 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012d6:	75 1f                	jne    8012f7 <readline+0xc5>
  8012d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012dc:	7e 19                	jle    8012f7 <readline+0xc5>
			if (echoing)
  8012de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e2:	74 0e                	je     8012f2 <readline+0xc0>
				cputchar(c);
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ea:	e8 36 f4 ff ff       	call   800725 <cputchar>
  8012ef:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f2:	ff 4d f4             	decl   -0xc(%ebp)
  8012f5:	eb 31                	jmp    801328 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012f7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012fb:	74 0a                	je     801307 <readline+0xd5>
  8012fd:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801301:	0f 85 61 ff ff ff    	jne    801268 <readline+0x36>
			if (echoing)
  801307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80130b:	74 0e                	je     80131b <readline+0xe9>
				cputchar(c);
  80130d:	83 ec 0c             	sub    $0xc,%esp
  801310:	ff 75 ec             	pushl  -0x14(%ebp)
  801313:	e8 0d f4 ff ff       	call   800725 <cputchar>
  801318:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80131b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801326:	eb 06                	jmp    80132e <readline+0xfc>
		}
	}
  801328:	e9 3b ff ff ff       	jmp    801268 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  80132d:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801336:	e8 5d 0d 00 00       	call   802098 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  80133b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133f:	74 13                	je     801354 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	68 50 41 80 00       	push   $0x804150
  80134c:	e8 5f f8 ff ff       	call   800bb0 <cprintf>
  801351:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801354:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80135b:	83 ec 0c             	sub    $0xc,%esp
  80135e:	6a 00                	push   $0x0
  801360:	e8 56 f4 ff ff       	call   8007bb <iscons>
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80136b:	e8 fd f3 ff ff       	call   80076d <getchar>
  801370:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801373:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801377:	79 23                	jns    80139c <atomic_readline+0x6c>
			if (c != -E_EOF)
  801379:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80137d:	74 13                	je     801392 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80137f:	83 ec 08             	sub    $0x8,%esp
  801382:	ff 75 ec             	pushl  -0x14(%ebp)
  801385:	68 53 41 80 00       	push   $0x804153
  80138a:	e8 21 f8 ff ff       	call   800bb0 <cprintf>
  80138f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801392:	e8 1b 0d 00 00       	call   8020b2 <sys_enable_interrupt>
			return;
  801397:	e9 9a 00 00 00       	jmp    801436 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80139c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a0:	7e 34                	jle    8013d6 <atomic_readline+0xa6>
  8013a2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013a9:	7f 2b                	jg     8013d6 <atomic_readline+0xa6>
			if (echoing)
  8013ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013af:	74 0e                	je     8013bf <atomic_readline+0x8f>
				cputchar(c);
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b7:	e8 69 f3 ff ff       	call   800725 <cputchar>
  8013bc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c2:	8d 50 01             	lea    0x1(%eax),%edx
  8013c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013c8:	89 c2                	mov    %eax,%edx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	01 d0                	add    %edx,%eax
  8013cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d2:	88 10                	mov    %dl,(%eax)
  8013d4:	eb 5b                	jmp    801431 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013d6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013da:	75 1f                	jne    8013fb <atomic_readline+0xcb>
  8013dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e0:	7e 19                	jle    8013fb <atomic_readline+0xcb>
			if (echoing)
  8013e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013e6:	74 0e                	je     8013f6 <atomic_readline+0xc6>
				cputchar(c);
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ee:	e8 32 f3 ff ff       	call   800725 <cputchar>
  8013f3:	83 c4 10             	add    $0x10,%esp
			i--;
  8013f6:	ff 4d f4             	decl   -0xc(%ebp)
  8013f9:	eb 36                	jmp    801431 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013fb:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013ff:	74 0a                	je     80140b <atomic_readline+0xdb>
  801401:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801405:	0f 85 60 ff ff ff    	jne    80136b <atomic_readline+0x3b>
			if (echoing)
  80140b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140f:	74 0e                	je     80141f <atomic_readline+0xef>
				cputchar(c);
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	ff 75 ec             	pushl  -0x14(%ebp)
  801417:	e8 09 f3 ff ff       	call   800725 <cputchar>
  80141c:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80141f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 d0                	add    %edx,%eax
  801427:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142a:	e8 83 0c 00 00       	call   8020b2 <sys_enable_interrupt>
			return;
  80142f:	eb 05                	jmp    801436 <atomic_readline+0x106>
		}
	}
  801431:	e9 35 ff ff ff       	jmp    80136b <atomic_readline+0x3b>
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80143e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801445:	eb 06                	jmp    80144d <strlen+0x15>
		n++;
  801447:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144a:	ff 45 08             	incl   0x8(%ebp)
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	84 c0                	test   %al,%al
  801454:	75 f1                	jne    801447 <strlen+0xf>
		n++;
	return n;
  801456:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801468:	eb 09                	jmp    801473 <strnlen+0x18>
		n++;
  80146a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80146d:	ff 45 08             	incl   0x8(%ebp)
  801470:	ff 4d 0c             	decl   0xc(%ebp)
  801473:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801477:	74 09                	je     801482 <strnlen+0x27>
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	84 c0                	test   %al,%al
  801480:	75 e8                	jne    80146a <strnlen+0xf>
		n++;
	return n;
  801482:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801493:	90                   	nop
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 08             	mov    %edx,0x8(%ebp)
  80149d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	84 c0                	test   %al,%al
  8014ae:	75 e4                	jne    801494 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c8:	eb 1f                	jmp    8014e9 <strncpy+0x34>
		*dst++ = *src;
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	8a 12                	mov    (%edx),%dl
  8014d8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 03                	je     8014e6 <strncpy+0x31>
			src++;
  8014e3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014e6:	ff 45 fc             	incl   -0x4(%ebp)
  8014e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ef:	72 d9                	jb     8014ca <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801502:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801506:	74 30                	je     801538 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801508:	eb 16                	jmp    801520 <strlcpy+0x2a>
			*dst++ = *src++;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8d 50 01             	lea    0x1(%eax),%edx
  801510:	89 55 08             	mov    %edx,0x8(%ebp)
  801513:	8b 55 0c             	mov    0xc(%ebp),%edx
  801516:	8d 4a 01             	lea    0x1(%edx),%ecx
  801519:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80151c:	8a 12                	mov    (%edx),%dl
  80151e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801520:	ff 4d 10             	decl   0x10(%ebp)
  801523:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801527:	74 09                	je     801532 <strlcpy+0x3c>
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	84 c0                	test   %al,%al
  801530:	75 d8                	jne    80150a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801538:	8b 55 08             	mov    0x8(%ebp),%edx
  80153b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153e:	29 c2                	sub    %eax,%edx
  801540:	89 d0                	mov    %edx,%eax
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801547:	eb 06                	jmp    80154f <strcmp+0xb>
		p++, q++;
  801549:	ff 45 08             	incl   0x8(%ebp)
  80154c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	84 c0                	test   %al,%al
  801556:	74 0e                	je     801566 <strcmp+0x22>
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 10                	mov    (%eax),%dl
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	38 c2                	cmp    %al,%dl
  801564:	74 e3                	je     801549 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	0f b6 d0             	movzbl %al,%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	0f b6 c0             	movzbl %al,%eax
  801576:	29 c2                	sub    %eax,%edx
  801578:	89 d0                	mov    %edx,%eax
}
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    

0080157c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80157f:	eb 09                	jmp    80158a <strncmp+0xe>
		n--, p++, q++;
  801581:	ff 4d 10             	decl   0x10(%ebp)
  801584:	ff 45 08             	incl   0x8(%ebp)
  801587:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158e:	74 17                	je     8015a7 <strncmp+0x2b>
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	84 c0                	test   %al,%al
  801597:	74 0e                	je     8015a7 <strncmp+0x2b>
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 10                	mov    (%eax),%dl
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	38 c2                	cmp    %al,%dl
  8015a5:	74 da                	je     801581 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ab:	75 07                	jne    8015b4 <strncmp+0x38>
		return 0;
  8015ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b2:	eb 14                	jmp    8015c8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
}
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015d6:	eb 12                	jmp    8015ea <strchr+0x20>
		if (*s == c)
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	8a 00                	mov    (%eax),%al
  8015dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e0:	75 05                	jne    8015e7 <strchr+0x1d>
			return (char *) s;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	eb 11                	jmp    8015f8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015e7:	ff 45 08             	incl   0x8(%ebp)
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	84 c0                	test   %al,%al
  8015f1:	75 e5                	jne    8015d8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801606:	eb 0d                	jmp    801615 <strfind+0x1b>
		if (*s == c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801610:	74 0e                	je     801620 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801612:	ff 45 08             	incl   0x8(%ebp)
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	84 c0                	test   %al,%al
  80161c:	75 ea                	jne    801608 <strfind+0xe>
  80161e:	eb 01                	jmp    801621 <strfind+0x27>
		if (*s == c)
			break;
  801620:	90                   	nop
	return (char *) s;
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801638:	eb 0e                	jmp    801648 <memset+0x22>
		*p++ = c;
  80163a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163d:	8d 50 01             	lea    0x1(%eax),%edx
  801640:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801648:	ff 4d f8             	decl   -0x8(%ebp)
  80164b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80164f:	79 e9                	jns    80163a <memset+0x14>
		*p++ = c;

	return v;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80165c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801668:	eb 16                	jmp    801680 <memcpy+0x2a>
		*d++ = *s++;
  80166a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166d:	8d 50 01             	lea    0x1(%eax),%edx
  801670:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801673:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801676:	8d 4a 01             	lea    0x1(%edx),%ecx
  801679:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80167c:	8a 12                	mov    (%edx),%dl
  80167e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	8d 50 ff             	lea    -0x1(%eax),%edx
  801686:	89 55 10             	mov    %edx,0x10(%ebp)
  801689:	85 c0                	test   %eax,%eax
  80168b:	75 dd                	jne    80166a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016aa:	73 50                	jae    8016fc <memmove+0x6a>
  8016ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	01 d0                	add    %edx,%eax
  8016b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016b7:	76 43                	jbe    8016fc <memmove+0x6a>
		s += n;
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016c5:	eb 10                	jmp    8016d7 <memmove+0x45>
			*--d = *--s;
  8016c7:	ff 4d f8             	decl   -0x8(%ebp)
  8016ca:	ff 4d fc             	decl   -0x4(%ebp)
  8016cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d0:	8a 10                	mov    (%eax),%dl
  8016d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 e3                	jne    8016c7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e4:	eb 23                	jmp    801709 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e9:	8d 50 01             	lea    0x1(%eax),%edx
  8016ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016f8:	8a 12                	mov    (%edx),%dl
  8016fa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801702:	89 55 10             	mov    %edx,0x10(%ebp)
  801705:	85 c0                	test   %eax,%eax
  801707:	75 dd                	jne    8016e6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801720:	eb 2a                	jmp    80174c <memcmp+0x3e>
		if (*s1 != *s2)
  801722:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801725:	8a 10                	mov    (%eax),%dl
  801727:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172a:	8a 00                	mov    (%eax),%al
  80172c:	38 c2                	cmp    %al,%dl
  80172e:	74 16                	je     801746 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	0f b6 d0             	movzbl %al,%edx
  801738:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	0f b6 c0             	movzbl %al,%eax
  801740:	29 c2                	sub    %eax,%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	eb 18                	jmp    80175e <memcmp+0x50>
		s1++, s2++;
  801746:	ff 45 fc             	incl   -0x4(%ebp)
  801749:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80174c:	8b 45 10             	mov    0x10(%ebp),%eax
  80174f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801752:	89 55 10             	mov    %edx,0x10(%ebp)
  801755:	85 c0                	test   %eax,%eax
  801757:	75 c9                	jne    801722 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801766:	8b 55 08             	mov    0x8(%ebp),%edx
  801769:	8b 45 10             	mov    0x10(%ebp),%eax
  80176c:	01 d0                	add    %edx,%eax
  80176e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801771:	eb 15                	jmp    801788 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	0f b6 d0             	movzbl %al,%edx
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	0f b6 c0             	movzbl %al,%eax
  801781:	39 c2                	cmp    %eax,%edx
  801783:	74 0d                	je     801792 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801785:	ff 45 08             	incl   0x8(%ebp)
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80178e:	72 e3                	jb     801773 <memfind+0x13>
  801790:	eb 01                	jmp    801793 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801792:	90                   	nop
	return (void *) s;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80179e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ac:	eb 03                	jmp    8017b1 <strtol+0x19>
		s++;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	3c 20                	cmp    $0x20,%al
  8017b8:	74 f4                	je     8017ae <strtol+0x16>
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	3c 09                	cmp    $0x9,%al
  8017c1:	74 eb                	je     8017ae <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	3c 2b                	cmp    $0x2b,%al
  8017ca:	75 05                	jne    8017d1 <strtol+0x39>
		s++;
  8017cc:	ff 45 08             	incl   0x8(%ebp)
  8017cf:	eb 13                	jmp    8017e4 <strtol+0x4c>
	else if (*s == '-')
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8a 00                	mov    (%eax),%al
  8017d6:	3c 2d                	cmp    $0x2d,%al
  8017d8:	75 0a                	jne    8017e4 <strtol+0x4c>
		s++, neg = 1;
  8017da:	ff 45 08             	incl   0x8(%ebp)
  8017dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e8:	74 06                	je     8017f0 <strtol+0x58>
  8017ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017ee:	75 20                	jne    801810 <strtol+0x78>
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	3c 30                	cmp    $0x30,%al
  8017f7:	75 17                	jne    801810 <strtol+0x78>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	40                   	inc    %eax
  8017fd:	8a 00                	mov    (%eax),%al
  8017ff:	3c 78                	cmp    $0x78,%al
  801801:	75 0d                	jne    801810 <strtol+0x78>
		s += 2, base = 16;
  801803:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801807:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80180e:	eb 28                	jmp    801838 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801810:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801814:	75 15                	jne    80182b <strtol+0x93>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 30                	cmp    $0x30,%al
  80181d:	75 0c                	jne    80182b <strtol+0x93>
		s++, base = 8;
  80181f:	ff 45 08             	incl   0x8(%ebp)
  801822:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801829:	eb 0d                	jmp    801838 <strtol+0xa0>
	else if (base == 0)
  80182b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182f:	75 07                	jne    801838 <strtol+0xa0>
		base = 10;
  801831:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 2f                	cmp    $0x2f,%al
  80183f:	7e 19                	jle    80185a <strtol+0xc2>
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3c 39                	cmp    $0x39,%al
  801848:	7f 10                	jg     80185a <strtol+0xc2>
			dig = *s - '0';
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8a 00                	mov    (%eax),%al
  80184f:	0f be c0             	movsbl %al,%eax
  801852:	83 e8 30             	sub    $0x30,%eax
  801855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801858:	eb 42                	jmp    80189c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	3c 60                	cmp    $0x60,%al
  801861:	7e 19                	jle    80187c <strtol+0xe4>
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8a 00                	mov    (%eax),%al
  801868:	3c 7a                	cmp    $0x7a,%al
  80186a:	7f 10                	jg     80187c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	8a 00                	mov    (%eax),%al
  801871:	0f be c0             	movsbl %al,%eax
  801874:	83 e8 57             	sub    $0x57,%eax
  801877:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187a:	eb 20                	jmp    80189c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	8a 00                	mov    (%eax),%al
  801881:	3c 40                	cmp    $0x40,%al
  801883:	7e 39                	jle    8018be <strtol+0x126>
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	3c 5a                	cmp    $0x5a,%al
  80188c:	7f 30                	jg     8018be <strtol+0x126>
			dig = *s - 'A' + 10;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	0f be c0             	movsbl %al,%eax
  801896:	83 e8 37             	sub    $0x37,%eax
  801899:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a2:	7d 19                	jge    8018bd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a4:	ff 45 08             	incl   0x8(%ebp)
  8018a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018ae:	89 c2                	mov    %eax,%edx
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	01 d0                	add    %edx,%eax
  8018b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018b8:	e9 7b ff ff ff       	jmp    801838 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018bd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c2:	74 08                	je     8018cc <strtol+0x134>
		*endptr = (char *) s;
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ca:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d0:	74 07                	je     8018d9 <strtol+0x141>
  8018d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d5:	f7 d8                	neg    %eax
  8018d7:	eb 03                	jmp    8018dc <strtol+0x144>
  8018d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <ltostr>:

void
ltostr(long value, char *str)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f6:	79 13                	jns    80190b <ltostr+0x2d>
	{
		neg = 1;
  8018f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801905:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801908:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801913:	99                   	cltd   
  801914:	f7 f9                	idiv   %ecx
  801916:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801919:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191c:	8d 50 01             	lea    0x1(%eax),%edx
  80191f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801922:	89 c2                	mov    %eax,%edx
  801924:	8b 45 0c             	mov    0xc(%ebp),%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80192c:	83 c2 30             	add    $0x30,%edx
  80192f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801931:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801934:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801939:	f7 e9                	imul   %ecx
  80193b:	c1 fa 02             	sar    $0x2,%edx
  80193e:	89 c8                	mov    %ecx,%eax
  801940:	c1 f8 1f             	sar    $0x1f,%eax
  801943:	29 c2                	sub    %eax,%edx
  801945:	89 d0                	mov    %edx,%eax
  801947:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801952:	f7 e9                	imul   %ecx
  801954:	c1 fa 02             	sar    $0x2,%edx
  801957:	89 c8                	mov    %ecx,%eax
  801959:	c1 f8 1f             	sar    $0x1f,%eax
  80195c:	29 c2                	sub    %eax,%edx
  80195e:	89 d0                	mov    %edx,%eax
  801960:	c1 e0 02             	shl    $0x2,%eax
  801963:	01 d0                	add    %edx,%eax
  801965:	01 c0                	add    %eax,%eax
  801967:	29 c1                	sub    %eax,%ecx
  801969:	89 ca                	mov    %ecx,%edx
  80196b:	85 d2                	test   %edx,%edx
  80196d:	75 9c                	jne    80190b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80196f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801976:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801979:	48                   	dec    %eax
  80197a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80197d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801981:	74 3d                	je     8019c0 <ltostr+0xe2>
		start = 1 ;
  801983:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198a:	eb 34                	jmp    8019c0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80198c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	8a 00                	mov    (%eax),%al
  801996:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801999:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	01 c2                	add    %eax,%edx
  8019a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a7:	01 c8                	add    %ecx,%eax
  8019a9:	8a 00                	mov    (%eax),%al
  8019ab:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b3:	01 c2                	add    %eax,%edx
  8019b5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019b8:	88 02                	mov    %al,(%edx)
		start++ ;
  8019ba:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019bd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c6:	7c c4                	jl     80198c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	e8 54 fa ff ff       	call   801438 <strlen>
  8019e4:	83 c4 04             	add    $0x4,%esp
  8019e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	e8 46 fa ff ff       	call   801438 <strlen>
  8019f2:	83 c4 04             	add    $0x4,%esp
  8019f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a06:	eb 17                	jmp    801a1f <strcconcat+0x49>
		final[s] = str1[s] ;
  801a08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0e:	01 c2                	add    %eax,%edx
  801a10:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	01 c8                	add    %ecx,%eax
  801a18:	8a 00                	mov    (%eax),%al
  801a1a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a1c:	ff 45 fc             	incl   -0x4(%ebp)
  801a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a25:	7c e1                	jl     801a08 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a27:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a2e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a35:	eb 1f                	jmp    801a56 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3a:	8d 50 01             	lea    0x1(%eax),%edx
  801a3d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	8b 45 10             	mov    0x10(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a53:	ff 45 f8             	incl   -0x8(%ebp)
  801a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a5c:	7c d9                	jl     801a37 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a61:	8b 45 10             	mov    0x10(%ebp),%eax
  801a64:	01 d0                	add    %edx,%eax
  801a66:	c6 00 00             	movb   $0x0,(%eax)
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a78:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a84:	8b 45 10             	mov    0x10(%ebp),%eax
  801a87:	01 d0                	add    %edx,%eax
  801a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a8f:	eb 0c                	jmp    801a9d <strsplit+0x31>
			*string++ = 0;
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8d 50 01             	lea    0x1(%eax),%edx
  801a97:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8a 00                	mov    (%eax),%al
  801aa2:	84 c0                	test   %al,%al
  801aa4:	74 18                	je     801abe <strsplit+0x52>
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	8a 00                	mov    (%eax),%al
  801aab:	0f be c0             	movsbl %al,%eax
  801aae:	50                   	push   %eax
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	e8 13 fb ff ff       	call   8015ca <strchr>
  801ab7:	83 c4 08             	add    $0x8,%esp
  801aba:	85 c0                	test   %eax,%eax
  801abc:	75 d3                	jne    801a91 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	84 c0                	test   %al,%al
  801ac5:	74 5a                	je     801b21 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aca:	8b 00                	mov    (%eax),%eax
  801acc:	83 f8 0f             	cmp    $0xf,%eax
  801acf:	75 07                	jne    801ad8 <strsplit+0x6c>
		{
			return 0;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad6:	eb 66                	jmp    801b3e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  801adb:	8b 00                	mov    (%eax),%eax
  801add:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae3:	89 0a                	mov    %ecx,(%edx)
  801ae5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aec:	8b 45 10             	mov    0x10(%ebp),%eax
  801aef:	01 c2                	add    %eax,%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801af6:	eb 03                	jmp    801afb <strsplit+0x8f>
			string++;
  801af8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8a 00                	mov    (%eax),%al
  801b00:	84 c0                	test   %al,%al
  801b02:	74 8b                	je     801a8f <strsplit+0x23>
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8a 00                	mov    (%eax),%al
  801b09:	0f be c0             	movsbl %al,%eax
  801b0c:	50                   	push   %eax
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	e8 b5 fa ff ff       	call   8015ca <strchr>
  801b15:	83 c4 08             	add    $0x8,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	74 dc                	je     801af8 <strsplit+0x8c>
			string++;
	}
  801b1c:	e9 6e ff ff ff       	jmp    801a8f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b21:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b22:	8b 45 14             	mov    0x14(%ebp),%eax
  801b25:	8b 00                	mov    (%eax),%eax
  801b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b31:	01 d0                	add    %edx,%eax
  801b33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b39:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801b46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b4d:	eb 4c                	jmp    801b9b <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801b4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	01 d0                	add    %edx,%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 40                	cmp    $0x40,%al
  801b5b:	7e 27                	jle    801b84 <str2lower+0x44>
  801b5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	01 d0                	add    %edx,%eax
  801b65:	8a 00                	mov    (%eax),%al
  801b67:	3c 5a                	cmp    $0x5a,%al
  801b69:	7f 19                	jg     801b84 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801b6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	01 d0                	add    %edx,%eax
  801b73:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	01 ca                	add    %ecx,%edx
  801b7b:	8a 12                	mov    (%edx),%dl
  801b7d:	83 c2 20             	add    $0x20,%edx
  801b80:	88 10                	mov    %dl,(%eax)
  801b82:	eb 14                	jmp    801b98 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	01 c2                	add    %eax,%edx
  801b8c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b92:	01 c8                	add    %ecx,%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801b98:	ff 45 fc             	incl   -0x4(%ebp)
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	e8 95 f8 ff ff       	call   801438 <strlen>
  801ba3:	83 c4 04             	add    $0x4,%esp
  801ba6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ba9:	7f a4                	jg     801b4f <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801bb5:	a1 04 50 80 00       	mov    0x805004,%eax
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	74 0a                	je     801bc8 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801bbe:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801bc5:	00 00 00 
	}
}
  801bc8:	90                   	nop
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    

00801bcb <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	e8 7e 09 00 00       	call   80255a <sys_sbrk>
  801bdc:	83 c4 10             	add    $0x10,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801be7:	e8 c6 ff ff ff       	call   801bb2 <InitializeUHeap>
	if (size == 0)
  801bec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bf0:	75 0a                	jne    801bfc <malloc+0x1b>
		return NULL;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf7:	e9 3f 01 00 00       	jmp    801d3b <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801bfc:	e8 ac 09 00 00       	call   8025ad <sys_get_hard_limit>
  801c01:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801c04:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801c13:	c1 e8 0c             	shr    $0xc,%eax
  801c16:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801c19:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801c20:	8b 55 08             	mov    0x8(%ebp),%edx
  801c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c26:	01 d0                	add    %edx,%eax
  801c28:	48                   	dec    %eax
  801c29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	f7 75 d8             	divl   -0x28(%ebp)
  801c37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c3a:	29 d0                	sub    %edx,%eax
  801c3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801c3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c42:	c1 e8 0c             	shr    $0xc,%eax
  801c45:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801c48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c4c:	75 0a                	jne    801c58 <malloc+0x77>
		return NULL;
  801c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c53:	e9 e3 00 00 00       	jmp    801d3b <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5b:	05 00 00 00 80       	add    $0x80000000,%eax
  801c60:	c1 e8 0c             	shr    $0xc,%eax
  801c63:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c68:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c6f:	77 19                	ja     801c8a <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	e8 60 0b 00 00       	call   8027dc <alloc_block_FF>
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801c82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c85:	e9 b1 00 00 00       	jmp    801d3b <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c90:	eb 4d                	jmp    801cdf <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c95:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c9c:	84 c0                	test   %al,%al
  801c9e:	75 27                	jne    801cc7 <malloc+0xe6>
			{
				counter++;
  801ca0:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801ca3:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801ca7:	75 14                	jne    801cbd <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cac:	05 00 00 08 00       	add    $0x80000,%eax
  801cb1:	c1 e0 0c             	shl    $0xc,%eax
  801cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc0:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cc3:	75 17                	jne    801cdc <malloc+0xfb>
				{
					break;
  801cc5:	eb 21                	jmp    801ce8 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cca:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801cd1:	3c 01                	cmp    $0x1,%al
  801cd3:	75 07                	jne    801cdc <malloc+0xfb>
			{
				counter = 0;
  801cd5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801cdc:	ff 45 e8             	incl   -0x18(%ebp)
  801cdf:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801ce6:	76 aa                	jbe    801c92 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ceb:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cee:	75 46                	jne    801d36 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801cf0:	83 ec 08             	sub    $0x8,%esp
  801cf3:	ff 75 d0             	pushl  -0x30(%ebp)
  801cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf9:	e8 93 08 00 00       	call   802591 <sys_allocate_user_mem>
  801cfe:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d04:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801d07:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d14:	eb 0e                	jmp    801d24 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d19:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  801d20:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801d21:	ff 45 e4             	incl   -0x1c(%ebp)
  801d24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2a:	01 d0                	add    %edx,%eax
  801d2c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d2f:	77 e5                	ja     801d16 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d34:	eb 05                	jmp    801d3b <malloc+0x15a>
		}
	}

	return NULL;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801d43:	e8 65 08 00 00       	call   8025ad <sys_get_hard_limit>
  801d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801d51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d55:	0f 84 c1 00 00 00    	je     801e1c <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	79 1b                	jns    801d7d <free+0x40>
  801d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d68:	73 13                	jae    801d7d <free+0x40>
    {
        free_block(virtual_address);
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	e8 34 10 00 00       	call   802da9 <free_block>
  801d75:	83 c4 10             	add    $0x10,%esp
    	return;
  801d78:	e9 a6 00 00 00       	jmp    801e23 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d80:	05 00 10 00 00       	add    $0x1000,%eax
  801d85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d88:	0f 87 91 00 00 00    	ja     801e1f <free+0xe2>
  801d8e:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d95:	0f 87 84 00 00 00    	ja     801e1f <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801daf:	05 00 00 00 80       	add    $0x80000000,%eax
  801db4:	c1 e8 0c             	shr    $0xc,%eax
  801db7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbd:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  801dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dcb:	74 55                	je     801e22 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd0:	c1 e8 0c             	shr    $0xc,%eax
  801dd3:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd9:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801de0:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dea:	eb 0e                	jmp    801dfa <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  801df6:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801df7:	ff 45 f4             	incl   -0xc(%ebp)
  801dfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e00:	01 c2                	add    %eax,%edx
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	39 c2                	cmp    %eax,%edx
  801e07:	77 e3                	ja     801dec <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801e09:	83 ec 08             	sub    $0x8,%esp
  801e0c:	ff 75 e0             	pushl  -0x20(%ebp)
  801e0f:	ff 75 ec             	pushl  -0x14(%ebp)
  801e12:	e8 5e 07 00 00       	call   802575 <sys_free_user_mem>
  801e17:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801e1a:	eb 07                	jmp    801e23 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801e1c:	90                   	nop
  801e1d:	eb 04                	jmp    801e23 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801e1f:	90                   	nop
  801e20:	eb 01                	jmp    801e23 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801e22:	90                   	nop
    else
     {
    	return;
      }

}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 18             	sub    $0x18,%esp
  801e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e31:	e8 7c fd ff ff       	call   801bb2 <InitializeUHeap>
	if (size == 0)
  801e36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e3a:	75 07                	jne    801e43 <smalloc+0x1e>
		return NULL;
  801e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e41:	eb 17                	jmp    801e5a <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	68 64 41 80 00       	push   $0x804164
  801e4b:	68 ad 00 00 00       	push   $0xad
  801e50:	68 8a 41 80 00       	push   $0x80418a
  801e55:	e8 99 ea ff ff       	call   8008f3 <_panic>
	return NULL;
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e62:	e8 4b fd ff ff       	call   801bb2 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e67:	83 ec 04             	sub    $0x4,%esp
  801e6a:	68 98 41 80 00       	push   $0x804198
  801e6f:	68 ba 00 00 00       	push   $0xba
  801e74:	68 8a 41 80 00       	push   $0x80418a
  801e79:	e8 75 ea ff ff       	call   8008f3 <_panic>

00801e7e <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e84:	e8 29 fd ff ff       	call   801bb2 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 bc 41 80 00       	push   $0x8041bc
  801e91:	68 d8 00 00 00       	push   $0xd8
  801e96:	68 8a 41 80 00       	push   $0x80418a
  801e9b:	e8 53 ea ff ff       	call   8008f3 <_panic>

00801ea0 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	68 e4 41 80 00       	push   $0x8041e4
  801eae:	68 ea 00 00 00       	push   $0xea
  801eb3:	68 8a 41 80 00       	push   $0x80418a
  801eb8:	e8 36 ea ff ff       	call   8008f3 <_panic>

00801ebd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 08 42 80 00       	push   $0x804208
  801ecb:	68 f2 00 00 00       	push   $0xf2
  801ed0:	68 8a 41 80 00       	push   $0x80418a
  801ed5:	e8 19 ea ff ff       	call   8008f3 <_panic>

00801eda <shrink>:

}
void shrink(uint32 newSize) {
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 08 42 80 00       	push   $0x804208
  801ee8:	68 f6 00 00 00       	push   $0xf6
  801eed:	68 8a 41 80 00       	push   $0x80418a
  801ef2:	e8 fc e9 ff ff       	call   8008f3 <_panic>

00801ef7 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	68 08 42 80 00       	push   $0x804208
  801f05:	68 fa 00 00 00       	push   $0xfa
  801f0a:	68 8a 41 80 00       	push   $0x80418a
  801f0f:	e8 df e9 ff ff       	call   8008f3 <_panic>

00801f14 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	57                   	push   %edi
  801f18:	56                   	push   %esi
  801f19:	53                   	push   %ebx
  801f1a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f29:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f2c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f2f:	cd 30                	int    $0x30
  801f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	5b                   	pop    %ebx
  801f3b:	5e                   	pop    %esi
  801f3c:	5f                   	pop    %edi
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	8b 45 10             	mov    0x10(%ebp),%eax
  801f48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	52                   	push   %edx
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	50                   	push   %eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 b2 ff ff ff       	call   801f14 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	90                   	nop
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 01                	push   $0x1
  801f77:	e8 98 ff ff ff       	call   801f14 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	52                   	push   %edx
  801f91:	50                   	push   %eax
  801f92:	6a 05                	push   $0x5
  801f94:	e8 7b ff ff ff       	call   801f14 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa3:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	51                   	push   %ecx
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	6a 06                	push   $0x6
  801fb9:	e8 56 ff ff ff       	call   801f14 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	52                   	push   %edx
  801fd8:	50                   	push   %eax
  801fd9:	6a 07                	push   $0x7
  801fdb:	e8 34 ff ff ff       	call   801f14 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	6a 08                	push   $0x8
  801ff6:	e8 19 ff ff ff       	call   801f14 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 09                	push   $0x9
  80200f:	e8 00 ff ff ff       	call   801f14 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 0a                	push   $0xa
  802028:	e8 e7 fe ff ff       	call   801f14 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 0b                	push   $0xb
  802041:	e8 ce fe ff ff       	call   801f14 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 0c                	push   $0xc
  80205a:	e8 b5 fe ff ff       	call   801f14 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	ff 75 08             	pushl  0x8(%ebp)
  802072:	6a 0d                	push   $0xd
  802074:	e8 9b fe ff ff       	call   801f14 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 0e                	push   $0xe
  80208d:	e8 82 fe ff ff       	call   801f14 <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	90                   	nop
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 11                	push   $0x11
  8020a7:	e8 68 fe ff ff       	call   801f14 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	90                   	nop
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 12                	push   $0x12
  8020c1:	e8 4e fe ff ff       	call   801f14 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	90                   	nop
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_cputc>:


void
sys_cputc(const char c)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	50                   	push   %eax
  8020e5:	6a 13                	push   $0x13
  8020e7:	e8 28 fe ff ff       	call   801f14 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	90                   	nop
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 14                	push   $0x14
  802101:	e8 0e fe ff ff       	call   801f14 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	90                   	nop
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	50                   	push   %eax
  80211c:	6a 15                	push   $0x15
  80211e:	e8 f1 fd ff ff       	call   801f14 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80212b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	52                   	push   %edx
  802138:	50                   	push   %eax
  802139:	6a 18                	push   $0x18
  80213b:	e8 d4 fd ff ff       	call   801f14 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802148:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	52                   	push   %edx
  802155:	50                   	push   %eax
  802156:	6a 16                	push   $0x16
  802158:	e8 b7 fd ff ff       	call   801f14 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	90                   	nop
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	52                   	push   %edx
  802173:	50                   	push   %eax
  802174:	6a 17                	push   $0x17
  802176:	e8 99 fd ff ff       	call   801f14 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	90                   	nop
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	8b 45 10             	mov    0x10(%ebp),%eax
  80218a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80218d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802190:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	51                   	push   %ecx
  80219a:	52                   	push   %edx
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	50                   	push   %eax
  80219f:	6a 19                	push   $0x19
  8021a1:	e8 6e fd ff ff       	call   801f14 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 1a                	push   $0x1a
  8021be:	e8 51 fd ff ff       	call   801f14 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	51                   	push   %ecx
  8021d9:	52                   	push   %edx
  8021da:	50                   	push   %eax
  8021db:	6a 1b                	push   $0x1b
  8021dd:	e8 32 fd ff ff       	call   801f14 <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	52                   	push   %edx
  8021f7:	50                   	push   %eax
  8021f8:	6a 1c                	push   $0x1c
  8021fa:	e8 15 fd ff ff       	call   801f14 <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 1d                	push   $0x1d
  802213:	e8 fc fc ff ff       	call   801f14 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	ff 75 14             	pushl  0x14(%ebp)
  802228:	ff 75 10             	pushl  0x10(%ebp)
  80222b:	ff 75 0c             	pushl  0xc(%ebp)
  80222e:	50                   	push   %eax
  80222f:	6a 1e                	push   $0x1e
  802231:	e8 de fc ff ff       	call   801f14 <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	50                   	push   %eax
  80224a:	6a 1f                	push   $0x1f
  80224c:	e8 c3 fc ff ff       	call   801f14 <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	90                   	nop
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	50                   	push   %eax
  802266:	6a 20                	push   $0x20
  802268:	e8 a7 fc ff ff       	call   801f14 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 02                	push   $0x2
  802281:	e8 8e fc ff ff       	call   801f14 <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 03                	push   $0x3
  80229a:	e8 75 fc ff ff       	call   801f14 <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 04                	push   $0x4
  8022b3:	e8 5c fc ff ff       	call   801f14 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_exit_env>:


void sys_exit_env(void)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 21                	push   $0x21
  8022cc:	e8 43 fc ff ff       	call   801f14 <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	90                   	nop
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e0:	8d 50 04             	lea    0x4(%eax),%edx
  8022e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	52                   	push   %edx
  8022ed:	50                   	push   %eax
  8022ee:	6a 22                	push   $0x22
  8022f0:	e8 1f fc ff ff       	call   801f14 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8022f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802301:	89 01                	mov    %eax,(%ecx)
  802303:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	c9                   	leave  
  80230a:	c2 04 00             	ret    $0x4

0080230d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	ff 75 10             	pushl  0x10(%ebp)
  802317:	ff 75 0c             	pushl  0xc(%ebp)
  80231a:	ff 75 08             	pushl  0x8(%ebp)
  80231d:	6a 10                	push   $0x10
  80231f:	e8 f0 fb ff ff       	call   801f14 <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
	return ;
  802327:	90                   	nop
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_rcr2>:
uint32 sys_rcr2()
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 23                	push   $0x23
  802339:	e8 d6 fb ff ff       	call   801f14 <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80234f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	50                   	push   %eax
  80235c:	6a 24                	push   $0x24
  80235e:	e8 b1 fb ff ff       	call   801f14 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
	return ;
  802366:	90                   	nop
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <rsttst>:
void rsttst()
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 26                	push   $0x26
  802378:	e8 97 fb ff ff       	call   801f14 <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return ;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	8b 45 14             	mov    0x14(%ebp),%eax
  80238c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80238f:	8b 55 18             	mov    0x18(%ebp),%edx
  802392:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802396:	52                   	push   %edx
  802397:	50                   	push   %eax
  802398:	ff 75 10             	pushl  0x10(%ebp)
  80239b:	ff 75 0c             	pushl  0xc(%ebp)
  80239e:	ff 75 08             	pushl  0x8(%ebp)
  8023a1:	6a 25                	push   $0x25
  8023a3:	e8 6c fb ff ff       	call   801f14 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ab:	90                   	nop
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <chktst>:
void chktst(uint32 n)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	ff 75 08             	pushl  0x8(%ebp)
  8023bc:	6a 27                	push   $0x27
  8023be:	e8 51 fb ff ff       	call   801f14 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c6:	90                   	nop
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <inctst>:

void inctst()
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 28                	push   $0x28
  8023d8:	e8 37 fb ff ff       	call   801f14 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e0:	90                   	nop
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <gettst>:
uint32 gettst()
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 29                	push   $0x29
  8023f2:	e8 1d fb ff ff       	call   801f14 <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 2a                	push   $0x2a
  80240e:	e8 01 fb ff ff       	call   801f14 <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
  802416:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802419:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80241d:	75 07                	jne    802426 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80241f:	b8 01 00 00 00       	mov    $0x1,%eax
  802424:	eb 05                	jmp    80242b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 2a                	push   $0x2a
  80243f:	e8 d0 fa ff ff       	call   801f14 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
  802447:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80244a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80244e:	75 07                	jne    802457 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802450:	b8 01 00 00 00       	mov    $0x1,%eax
  802455:	eb 05                	jmp    80245c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 2a                	push   $0x2a
  802470:	e8 9f fa ff ff       	call   801f14 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
  802478:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80247b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80247f:	75 07                	jne    802488 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802481:	b8 01 00 00 00       	mov    $0x1,%eax
  802486:	eb 05                	jmp    80248d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 2a                	push   $0x2a
  8024a1:	e8 6e fa ff ff       	call   801f14 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
  8024a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024b0:	75 07                	jne    8024b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b7:	eb 05                	jmp    8024be <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	ff 75 08             	pushl  0x8(%ebp)
  8024ce:	6a 2b                	push   $0x2b
  8024d0:	e8 3f fa ff ff       	call   801f14 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d8:	90                   	nop
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	6a 00                	push   $0x0
  8024ed:	53                   	push   %ebx
  8024ee:	51                   	push   %ecx
  8024ef:	52                   	push   %edx
  8024f0:	50                   	push   %eax
  8024f1:	6a 2c                	push   $0x2c
  8024f3:	e8 1c fa ff ff       	call   801f14 <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802503:	8b 55 0c             	mov    0xc(%ebp),%edx
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	52                   	push   %edx
  802510:	50                   	push   %eax
  802511:	6a 2d                	push   $0x2d
  802513:	e8 fc f9 ff ff       	call   801f14 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802520:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	51                   	push   %ecx
  80252c:	ff 75 10             	pushl  0x10(%ebp)
  80252f:	52                   	push   %edx
  802530:	50                   	push   %eax
  802531:	6a 2e                	push   $0x2e
  802533:	e8 dc f9 ff ff       	call   801f14 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	ff 75 10             	pushl  0x10(%ebp)
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	6a 0f                	push   $0xf
  80254f:	e8 c0 f9 ff ff       	call   801f14 <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
	return ;
  802557:	90                   	nop
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	50                   	push   %eax
  802569:	6a 2f                	push   $0x2f
  80256b:	e8 a4 f9 ff ff       	call   801f14 <syscall>
  802570:	83 c4 18             	add    $0x18,%esp

}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	ff 75 0c             	pushl  0xc(%ebp)
  802581:	ff 75 08             	pushl  0x8(%ebp)
  802584:	6a 30                	push   $0x30
  802586:	e8 89 f9 ff ff       	call   801f14 <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
	return;
  80258e:	90                   	nop
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	6a 31                	push   $0x31
  8025a2:	e8 6d f9 ff ff       	call   801f14 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
	return;
  8025aa:	90                   	nop
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 32                	push   $0x32
  8025bc:	e8 53 f9 ff ff       	call   801f14 <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	50                   	push   %eax
  8025d5:	6a 33                	push   $0x33
  8025d7:	e8 38 f9 ff ff       	call   801f14 <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
}
  8025df:	90                   	nop
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	83 e8 10             	sub    $0x10,%eax
  8025ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  8025f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	83 e8 10             	sub    $0x10,%eax
  802604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802607:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260a:	8a 40 04             	mov    0x4(%eax),%al
}
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802615:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80261c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261f:	83 f8 02             	cmp    $0x2,%eax
  802622:	74 2b                	je     80264f <alloc_block+0x40>
  802624:	83 f8 02             	cmp    $0x2,%eax
  802627:	7f 07                	jg     802630 <alloc_block+0x21>
  802629:	83 f8 01             	cmp    $0x1,%eax
  80262c:	74 0e                	je     80263c <alloc_block+0x2d>
  80262e:	eb 58                	jmp    802688 <alloc_block+0x79>
  802630:	83 f8 03             	cmp    $0x3,%eax
  802633:	74 2d                	je     802662 <alloc_block+0x53>
  802635:	83 f8 04             	cmp    $0x4,%eax
  802638:	74 3b                	je     802675 <alloc_block+0x66>
  80263a:	eb 4c                	jmp    802688 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80263c:	83 ec 0c             	sub    $0xc,%esp
  80263f:	ff 75 08             	pushl  0x8(%ebp)
  802642:	e8 95 01 00 00       	call   8027dc <alloc_block_FF>
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264d:	eb 4a                	jmp    802699 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80264f:	83 ec 0c             	sub    $0xc,%esp
  802652:	ff 75 08             	pushl  0x8(%ebp)
  802655:	e8 32 07 00 00       	call   802d8c <alloc_block_NF>
  80265a:	83 c4 10             	add    $0x10,%esp
  80265d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802660:	eb 37                	jmp    802699 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802662:	83 ec 0c             	sub    $0xc,%esp
  802665:	ff 75 08             	pushl  0x8(%ebp)
  802668:	e8 a3 04 00 00       	call   802b10 <alloc_block_BF>
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802673:	eb 24                	jmp    802699 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802675:	83 ec 0c             	sub    $0xc,%esp
  802678:	ff 75 08             	pushl  0x8(%ebp)
  80267b:	e8 ef 06 00 00       	call   802d6f <alloc_block_WF>
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802686:	eb 11                	jmp    802699 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	68 18 42 80 00       	push   $0x804218
  802690:	e8 1b e5 ff ff       	call   800bb0 <cprintf>
  802695:	83 c4 10             	add    $0x10,%esp
		break;
  802698:	90                   	nop
	}
	return va;
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8026a4:	83 ec 0c             	sub    $0xc,%esp
  8026a7:	68 38 42 80 00       	push   $0x804238
  8026ac:	e8 ff e4 ff ff       	call   800bb0 <cprintf>
  8026b1:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	68 63 42 80 00       	push   $0x804263
  8026bc:	e8 ef e4 ff ff       	call   800bb0 <cprintf>
  8026c1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ca:	eb 26                	jmp    8026f2 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8a 40 04             	mov    0x4(%eax),%al
  8026d2:	0f b6 d0             	movzbl %al,%edx
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	83 ec 04             	sub    $0x4,%esp
  8026dd:	52                   	push   %edx
  8026de:	50                   	push   %eax
  8026df:	68 7b 42 80 00       	push   $0x80427b
  8026e4:	e8 c7 e4 ff ff       	call   800bb0 <cprintf>
  8026e9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f6:	74 08                	je     802700 <print_blocks_list+0x62>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 08             	mov    0x8(%eax),%eax
  8026fe:	eb 05                	jmp    802705 <print_blocks_list+0x67>
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
  802705:	89 45 10             	mov    %eax,0x10(%ebp)
  802708:	8b 45 10             	mov    0x10(%ebp),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	75 bd                	jne    8026cc <print_blocks_list+0x2e>
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	75 b7                	jne    8026cc <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	68 38 42 80 00       	push   $0x804238
  80271d:	e8 8e e4 ff ff       	call   800bb0 <cprintf>
  802722:	83 c4 10             	add    $0x10,%esp

}
  802725:	90                   	nop
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  80272e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802732:	0f 84 a1 00 00 00    	je     8027d9 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802738:	c7 05 30 50 80 00 01 	movl   $0x1,0x805030
  80273f:	00 00 00 
	LIST_INIT(&list);
  802742:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802749:	00 00 00 
  80274c:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  802753:	00 00 00 
  802756:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  80275d:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 55 0c             	mov    0xc(%ebp),%edx
  802773:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802779:	75 14                	jne    80278f <initialize_dynamic_allocator+0x67>
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	68 94 42 80 00       	push   $0x804294
  802783:	6a 64                	push   $0x64
  802785:	68 b7 42 80 00       	push   $0x8042b7
  80278a:	e8 64 e1 ff ff       	call   8008f3 <_panic>
  80278f:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	89 50 0c             	mov    %edx,0xc(%eax)
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	74 0d                	je     8027b2 <initialize_dynamic_allocator+0x8a>
  8027a5:	a1 44 51 90 00       	mov    0x905144,%eax
  8027aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ad:	89 50 08             	mov    %edx,0x8(%eax)
  8027b0:	eb 08                	jmp    8027ba <initialize_dynamic_allocator+0x92>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	a3 40 51 90 00       	mov    %eax,0x905140
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	a3 44 51 90 00       	mov    %eax,0x905144
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027cc:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8027d1:	40                   	inc    %eax
  8027d2:	a3 4c 51 90 00       	mov    %eax,0x90514c
  8027d7:	eb 01                	jmp    8027da <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8027d9:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8027e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e6:	75 0a                	jne    8027f2 <alloc_block_FF+0x16>
	{
		return NULL;
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ed:	e9 1c 03 00 00       	jmp    802b0e <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8027f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	75 40                	jne    80283b <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	83 c0 10             	add    $0x10,%eax
  802801:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	50                   	push   %eax
  80280b:	e8 bb f3 ff ff       	call   801bcb <sbrk>
  802810:	83 c4 10             	add    $0x10,%esp
  802813:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802816:	83 ec 0c             	sub    $0xc,%esp
  802819:	6a 00                	push   $0x0
  80281b:	e8 ab f3 ff ff       	call   801bcb <sbrk>
  802820:	83 c4 10             	add    $0x10,%esp
  802823:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802829:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80282c:	83 ec 08             	sub    $0x8,%esp
  80282f:	50                   	push   %eax
  802830:	ff 75 ec             	pushl  -0x14(%ebp)
  802833:	e8 f0 fe ff ff       	call   802728 <initialize_dynamic_allocator>
  802838:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  80283b:	a1 40 51 90 00       	mov    0x905140,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	e9 1e 01 00 00       	jmp    802966 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	8d 50 10             	lea    0x10(%eax),%edx
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	39 c2                	cmp    %eax,%edx
  802855:	75 1c                	jne    802873 <alloc_block_FF+0x97>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8a 40 04             	mov    0x4(%eax),%al
  80285d:	3c 01                	cmp    $0x1,%al
  80285f:	75 12                	jne    802873 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	83 c0 10             	add    $0x10,%eax
  80286e:	e9 9b 02 00 00       	jmp    802b0e <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	8d 50 10             	lea    0x10(%eax),%edx
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	39 c2                	cmp    %eax,%edx
  802880:	0f 83 d8 00 00 00    	jae    80295e <alloc_block_FF+0x182>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8a 40 04             	mov    0x4(%eax),%al
  80288c:	3c 01                	cmp    $0x1,%al
  80288e:	0f 85 ca 00 00 00    	jne    80295e <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	2b 45 08             	sub    0x8(%ebp),%eax
  80289c:	83 e8 10             	sub    $0x10,%eax
  80289f:	83 f8 0f             	cmp    $0xf,%eax
  8028a2:	0f 86 a4 00 00 00    	jbe    80294c <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  8028a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	01 d0                	add    %edx,%eax
  8028b0:	83 c0 10             	add    $0x10,%eax
  8028b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028be:	8d 50 f0             	lea    -0x10(%eax),%edx
  8028c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c4:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  8028c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c9:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8028cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d1:	74 06                	je     8028d9 <alloc_block_FF+0xfd>
  8028d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8028d7:	75 17                	jne    8028f0 <alloc_block_FF+0x114>
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	68 d0 42 80 00       	push   $0x8042d0
  8028e1:	68 8f 00 00 00       	push   $0x8f
  8028e6:	68 b7 42 80 00       	push   $0x8042b7
  8028eb:	e8 03 e0 ff ff       	call   8008f3 <_panic>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 50 08             	mov    0x8(%eax),%edx
  8028f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028f9:	89 50 08             	mov    %edx,0x8(%eax)
  8028fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ff:	8b 40 08             	mov    0x8(%eax),%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	74 0c                	je     802912 <alloc_block_FF+0x136>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 40 08             	mov    0x8(%eax),%eax
  80290c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80290f:	89 50 0c             	mov    %edx,0xc(%eax)
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802918:	89 50 08             	mov    %edx,0x8(%eax)
  80291b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80291e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802921:	89 50 0c             	mov    %edx,0xc(%eax)
  802924:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802927:	8b 40 08             	mov    0x8(%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	75 08                	jne    802936 <alloc_block_FF+0x15a>
  80292e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802931:	a3 44 51 90 00       	mov    %eax,0x905144
  802936:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80293b:	40                   	inc    %eax
  80293c:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	8d 50 10             	lea    0x10(%eax),%edx
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	83 c0 10             	add    $0x10,%eax
  802959:	e9 b0 01 00 00       	jmp    802b0e <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  80295e:	a1 48 51 90 00       	mov    0x905148,%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	74 08                	je     802974 <alloc_block_FF+0x198>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 08             	mov    0x8(%eax),%eax
  802972:	eb 05                	jmp    802979 <alloc_block_FF+0x19d>
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
  802979:	a3 48 51 90 00       	mov    %eax,0x905148
  80297e:	a1 48 51 90 00       	mov    0x905148,%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	0f 85 bd fe ff ff    	jne    802848 <alloc_block_FF+0x6c>
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	0f 85 b3 fe ff ff    	jne    802848 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	83 c0 10             	add    $0x10,%eax
  80299b:	83 ec 0c             	sub    $0xc,%esp
  80299e:	50                   	push   %eax
  80299f:	e8 27 f2 ff ff       	call   801bcb <sbrk>
  8029a4:	83 c4 10             	add    $0x10,%esp
  8029a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  8029aa:	83 ec 0c             	sub    $0xc,%esp
  8029ad:	6a 00                	push   $0x0
  8029af:	e8 17 f2 ff ff       	call   801bcb <sbrk>
  8029b4:	83 c4 10             	add    $0x10,%esp
  8029b7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  8029ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c0:	29 c2                	sub    %eax,%edx
  8029c2:	89 d0                	mov    %edx,%eax
  8029c4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  8029c7:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8029cb:	0f 84 38 01 00 00    	je     802b09 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  8029d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8029d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029db:	75 17                	jne    8029f4 <alloc_block_FF+0x218>
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	68 94 42 80 00       	push   $0x804294
  8029e5:	68 9f 00 00 00       	push   $0x9f
  8029ea:	68 b7 42 80 00       	push   $0x8042b7
  8029ef:	e8 ff de ff ff       	call   8008f3 <_panic>
  8029f4:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8029fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fd:	89 50 0c             	mov    %edx,0xc(%eax)
  802a00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a03:	8b 40 0c             	mov    0xc(%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	74 0d                	je     802a17 <alloc_block_FF+0x23b>
  802a0a:	a1 44 51 90 00       	mov    0x905144,%eax
  802a0f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a12:	89 50 08             	mov    %edx,0x8(%eax)
  802a15:	eb 08                	jmp    802a1f <alloc_block_FF+0x243>
  802a17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1a:	a3 40 51 90 00       	mov    %eax,0x905140
  802a1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a22:	a3 44 51 90 00       	mov    %eax,0x905144
  802a27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a31:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802a36:	40                   	inc    %eax
  802a37:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	8d 50 10             	lea    0x10(%eax),%edx
  802a42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a45:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a4a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802a4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a51:	2b 45 08             	sub    0x8(%ebp),%eax
  802a54:	83 f8 10             	cmp    $0x10,%eax
  802a57:	0f 84 a4 00 00 00    	je     802b01 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802a5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a60:	2b 45 08             	sub    0x8(%ebp),%eax
  802a63:	83 e8 10             	sub    $0x10,%eax
  802a66:	83 f8 0f             	cmp    $0xf,%eax
  802a69:	0f 86 8a 00 00 00    	jbe    802af9 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802a6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	83 c0 10             	add    $0x10,%eax
  802a7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802a7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a81:	75 17                	jne    802a9a <alloc_block_FF+0x2be>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 94 42 80 00       	push   $0x804294
  802a8b:	68 a7 00 00 00       	push   $0xa7
  802a90:	68 b7 42 80 00       	push   $0x8042b7
  802a95:	e8 59 de ff ff       	call   8008f3 <_panic>
  802a9a:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802aa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa3:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0d                	je     802abd <alloc_block_FF+0x2e1>
  802ab0:	a1 44 51 90 00       	mov    0x905144,%eax
  802ab5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab8:	89 50 08             	mov    %edx,0x8(%eax)
  802abb:	eb 08                	jmp    802ac5 <alloc_block_FF+0x2e9>
  802abd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ac0:	a3 40 51 90 00       	mov    %eax,0x905140
  802ac5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ac8:	a3 44 51 90 00       	mov    %eax,0x905144
  802acd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ad0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ad7:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae5:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae8:	8d 50 f0             	lea    -0x10(%eax),%edx
  802aeb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aee:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802af0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802af3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802af7:	eb 08                	jmp    802b01 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802afc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802aff:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802b01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b04:	83 c0 10             	add    $0x10,%eax
  802b07:	eb 05                	jmp    802b0e <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802b0e:	c9                   	leave  
  802b0f:	c3                   	ret    

00802b10 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b10:	55                   	push   %ebp
  802b11:	89 e5                	mov    %esp,%ebp
  802b13:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802b16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802b1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b21:	75 0a                	jne    802b2d <alloc_block_BF+0x1d>
	{
		return NULL;
  802b23:	b8 00 00 00 00       	mov    $0x0,%eax
  802b28:	e9 40 02 00 00       	jmp    802d6d <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802b2d:	a1 40 51 90 00       	mov    0x905140,%eax
  802b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b35:	eb 66                	jmp    802b9d <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8a 40 04             	mov    0x4(%eax),%al
  802b3d:	3c 01                	cmp    $0x1,%al
  802b3f:	75 21                	jne    802b62 <alloc_block_BF+0x52>
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	8d 50 10             	lea    0x10(%eax),%edx
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	39 c2                	cmp    %eax,%edx
  802b4e:	75 12                	jne    802b62 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	83 c0 10             	add    $0x10,%eax
  802b5d:	e9 0b 02 00 00       	jmp    802d6d <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8a 40 04             	mov    0x4(%eax),%al
  802b68:	3c 01                	cmp    $0x1,%al
  802b6a:	75 29                	jne    802b95 <alloc_block_BF+0x85>
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	8d 50 10             	lea    0x10(%eax),%edx
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	39 c2                	cmp    %eax,%edx
  802b79:	77 1a                	ja     802b95 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7f:	74 0e                	je     802b8f <alloc_block_BF+0x7f>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 10                	mov    (%eax),%edx
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 00                	mov    (%eax),%eax
  802b8b:	39 c2                	cmp    %eax,%edx
  802b8d:	73 06                	jae    802b95 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802b95:	a1 48 51 90 00       	mov    0x905148,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	74 08                	je     802bab <alloc_block_BF+0x9b>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 40 08             	mov    0x8(%eax),%eax
  802ba9:	eb 05                	jmp    802bb0 <alloc_block_BF+0xa0>
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb0:	a3 48 51 90 00       	mov    %eax,0x905148
  802bb5:	a1 48 51 90 00       	mov    0x905148,%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	0f 85 75 ff ff ff    	jne    802b37 <alloc_block_BF+0x27>
  802bc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc6:	0f 85 6b ff ff ff    	jne    802b37 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802bcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd0:	0f 84 f8 00 00 00    	je     802cce <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	8d 50 10             	lea    0x10(%eax),%edx
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	39 c2                	cmp    %eax,%edx
  802be3:	0f 87 e5 00 00 00    	ja     802cce <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf1:	83 e8 10             	sub    $0x10,%eax
  802bf4:	83 f8 0f             	cmp    $0xf,%eax
  802bf7:	0f 86 bf 00 00 00    	jbe    802cbc <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	83 c0 10             	add    $0x10,%eax
  802c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	2b 45 08             	sub    0x8(%ebp),%eax
  802c1c:	8d 50 f0             	lea    -0x10(%eax),%edx
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2f:	74 06                	je     802c37 <alloc_block_BF+0x127>
  802c31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c35:	75 17                	jne    802c4e <alloc_block_BF+0x13e>
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 d0 42 80 00       	push   $0x8042d0
  802c3f:	68 e3 00 00 00       	push   $0xe3
  802c44:	68 b7 42 80 00       	push   $0x8042b7
  802c49:	e8 a5 dc ff ff       	call   8008f3 <_panic>
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 50 08             	mov    0x8(%eax),%edx
  802c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c57:	89 50 08             	mov    %edx,0x8(%eax)
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 0c                	je     802c70 <alloc_block_BF+0x160>
  802c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c67:	8b 40 08             	mov    0x8(%eax),%eax
  802c6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6d:	89 50 0c             	mov    %edx,0xc(%eax)
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c76:	89 50 08             	mov    %edx,0x8(%eax)
  802c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7f:	89 50 0c             	mov    %edx,0xc(%eax)
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	8b 40 08             	mov    0x8(%eax),%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	75 08                	jne    802c94 <alloc_block_BF+0x184>
  802c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8f:	a3 44 51 90 00       	mov    %eax,0x905144
  802c94:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802c99:	40                   	inc    %eax
  802c9a:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	8d 50 10             	lea    0x10(%eax),%edx
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cad:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	83 c0 10             	add    $0x10,%eax
  802cb7:	e9 b1 00 00 00       	jmp    802d6d <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	83 c0 10             	add    $0x10,%eax
  802cc9:	e9 9f 00 00 00       	jmp    802d6d <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	83 c0 10             	add    $0x10,%eax
  802cd4:	83 ec 0c             	sub    $0xc,%esp
  802cd7:	50                   	push   %eax
  802cd8:	e8 ee ee ff ff       	call   801bcb <sbrk>
  802cdd:	83 c4 10             	add    $0x10,%esp
  802ce0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802ce3:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802ce7:	74 7f                	je     802d68 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802ce9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ced:	75 17                	jne    802d06 <alloc_block_BF+0x1f6>
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 94 42 80 00       	push   $0x804294
  802cf7:	68 f6 00 00 00       	push   $0xf6
  802cfc:	68 b7 42 80 00       	push   $0x8042b7
  802d01:	e8 ed db ff ff       	call   8008f3 <_panic>
  802d06:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0f:	89 50 0c             	mov    %edx,0xc(%eax)
  802d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <alloc_block_BF+0x219>
  802d1c:	a1 44 51 90 00       	mov    0x905144,%eax
  802d21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d24:	89 50 08             	mov    %edx,0x8(%eax)
  802d27:	eb 08                	jmp    802d31 <alloc_block_BF+0x221>
  802d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2c:	a3 40 51 90 00       	mov    %eax,0x905140
  802d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d34:	a3 44 51 90 00       	mov    %eax,0x905144
  802d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d43:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	8d 50 10             	lea    0x10(%eax),%edx
  802d54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d57:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d63:	83 c0 10             	add    $0x10,%eax
  802d66:	eb 05                	jmp    802d6d <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
  802d72:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 04 43 80 00       	push   $0x804304
  802d7d:	68 07 01 00 00       	push   $0x107
  802d82:	68 b7 42 80 00       	push   $0x8042b7
  802d87:	e8 67 db ff ff       	call   8008f3 <_panic>

00802d8c <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802d8c:	55                   	push   %ebp
  802d8d:	89 e5                	mov    %esp,%ebp
  802d8f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	68 2c 43 80 00       	push   $0x80432c
  802d9a:	68 0f 01 00 00       	push   $0x10f
  802d9f:	68 b7 42 80 00       	push   $0x8042b7
  802da4:	e8 4a db ff ff       	call   8008f3 <_panic>

00802da9 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802da9:	55                   	push   %ebp
  802daa:	89 e5                	mov    %esp,%ebp
  802dac:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802daf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db3:	0f 84 ee 05 00 00    	je     8033a7 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	83 e8 10             	sub    $0x10,%eax
  802dbf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802dc2:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802dc6:	a1 40 51 90 00       	mov    0x905140,%eax
  802dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802dce:	eb 16                	jmp    802de6 <free_block+0x3d>
	{
		if (block_pointer == it)
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dd6:	75 06                	jne    802dde <free_block+0x35>
		{
			flagx = 1;
  802dd8:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802ddc:	eb 2f                	jmp    802e0d <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802dde:	a1 48 51 90 00       	mov    0x905148,%eax
  802de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802de6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dea:	74 08                	je     802df4 <free_block+0x4b>
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	8b 40 08             	mov    0x8(%eax),%eax
  802df2:	eb 05                	jmp    802df9 <free_block+0x50>
  802df4:	b8 00 00 00 00       	mov    $0x0,%eax
  802df9:	a3 48 51 90 00       	mov    %eax,0x905148
  802dfe:	a1 48 51 90 00       	mov    0x905148,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	75 c9                	jne    802dd0 <free_block+0x27>
  802e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0b:	75 c3                	jne    802dd0 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802e0d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802e11:	0f 84 93 05 00 00    	je     8033aa <free_block+0x601>
		return;
	if (va == NULL)
  802e17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1b:	0f 84 8c 05 00 00    	je     8033ad <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e24:	8b 40 0c             	mov    0xc(%eax),%eax
  802e27:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	8b 40 08             	mov    0x8(%eax),%eax
  802e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802e33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e37:	75 12                	jne    802e4b <free_block+0xa2>
  802e39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e3d:	75 0c                	jne    802e4b <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e46:	e9 63 05 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802e4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e4f:	0f 85 ca 00 00 00    	jne    802f1f <free_block+0x176>
  802e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e58:	8a 40 04             	mov    0x4(%eax),%al
  802e5b:	3c 01                	cmp    $0x1,%al
  802e5d:	0f 85 bc 00 00 00    	jne    802f1f <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e66:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6d:	8b 10                	mov    (%eax),%edx
  802e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	01 c2                	add    %eax,%edx
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e87:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802e8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e8f:	75 17                	jne    802ea8 <free_block+0xff>
  802e91:	83 ec 04             	sub    $0x4,%esp
  802e94:	68 52 43 80 00       	push   $0x804352
  802e99:	68 3c 01 00 00       	push   $0x13c
  802e9e:	68 b7 42 80 00       	push   $0x8042b7
  802ea3:	e8 4b da ff ff       	call   8008f3 <_panic>
  802ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eab:	8b 40 08             	mov    0x8(%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 11                	je     802ec3 <free_block+0x11a>
  802eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ebb:	8b 52 0c             	mov    0xc(%edx),%edx
  802ebe:	89 50 0c             	mov    %edx,0xc(%eax)
  802ec1:	eb 0b                	jmp    802ece <free_block+0x125>
  802ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	a3 44 51 90 00       	mov    %eax,0x905144
  802ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	74 11                	je     802ee9 <free_block+0x140>
  802ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802edb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ede:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ee1:	8b 52 08             	mov    0x8(%edx),%edx
  802ee4:	89 50 08             	mov    %edx,0x8(%eax)
  802ee7:	eb 0b                	jmp    802ef4 <free_block+0x14b>
  802ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eec:	8b 40 08             	mov    0x8(%eax),%eax
  802eef:	a3 40 51 90 00       	mov    %eax,0x905140
  802ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f08:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802f0d:	48                   	dec    %eax
  802f0e:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802f13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802f1a:	e9 8f 04 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f23:	75 16                	jne    802f3b <free_block+0x192>
  802f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f28:	8a 40 04             	mov    0x4(%eax),%al
  802f2b:	84 c0                	test   %al,%al
  802f2d:	75 0c                	jne    802f3b <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802f36:	e9 73 04 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802f3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f3f:	0f 85 c3 00 00 00    	jne    803008 <free_block+0x25f>
  802f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f48:	8a 40 04             	mov    0x4(%eax),%al
  802f4b:	3c 01                	cmp    $0x1,%al
  802f4d:	0f 85 b5 00 00 00    	jne    803008 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802f53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f56:	8b 10                	mov    (%eax),%edx
  802f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	01 c2                	add    %eax,%edx
  802f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f62:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f70:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802f74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f78:	75 17                	jne    802f91 <free_block+0x1e8>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 52 43 80 00       	push   $0x804352
  802f82:	68 49 01 00 00       	push   $0x149
  802f87:	68 b7 42 80 00       	push   $0x8042b7
  802f8c:	e8 62 d9 ff ff       	call   8008f3 <_panic>
  802f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f94:	8b 40 08             	mov    0x8(%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 11                	je     802fac <free_block+0x203>
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	8b 40 08             	mov    0x8(%eax),%eax
  802fa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fa4:	8b 52 0c             	mov    0xc(%edx),%edx
  802fa7:	89 50 0c             	mov    %edx,0xc(%eax)
  802faa:	eb 0b                	jmp    802fb7 <free_block+0x20e>
  802fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb2:	a3 44 51 90 00       	mov    %eax,0x905144
  802fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fba:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 11                	je     802fd2 <free_block+0x229>
  802fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fca:	8b 52 08             	mov    0x8(%edx),%edx
  802fcd:	89 50 08             	mov    %edx,0x8(%eax)
  802fd0:	eb 0b                	jmp    802fdd <free_block+0x234>
  802fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd5:	8b 40 08             	mov    0x8(%eax),%eax
  802fd8:	a3 40 51 90 00       	mov    %eax,0x905140
  802fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ff1:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ff6:	48                   	dec    %eax
  802ff7:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802ffc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803003:	e9 a6 03 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  803008:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80300c:	75 16                	jne    803024 <free_block+0x27b>
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	8a 40 04             	mov    0x4(%eax),%al
  803014:	84 c0                	test   %al,%al
  803016:	75 0c                	jne    803024 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80301f:	e9 8a 03 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  803024:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803028:	0f 84 81 01 00 00    	je     8031af <free_block+0x406>
  80302e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803032:	0f 84 77 01 00 00    	je     8031af <free_block+0x406>
  803038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303b:	8a 40 04             	mov    0x4(%eax),%al
  80303e:	3c 01                	cmp    $0x1,%al
  803040:	0f 85 69 01 00 00    	jne    8031af <free_block+0x406>
  803046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803049:	8a 40 04             	mov    0x4(%eax),%al
  80304c:	3c 01                	cmp    $0x1,%al
  80304e:	0f 85 5b 01 00 00    	jne    8031af <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	8b 10                	mov    (%eax),%edx
  803059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305c:	8b 08                	mov    (%eax),%ecx
  80305e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	01 c8                	add    %ecx,%eax
  803065:	01 c2                	add    %eax,%edx
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80306c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803078:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80307c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80308c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803090:	75 17                	jne    8030a9 <free_block+0x300>
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	68 52 43 80 00       	push   $0x804352
  80309a:	68 59 01 00 00       	push   $0x159
  80309f:	68 b7 42 80 00       	push   $0x8042b7
  8030a4:	e8 4a d8 ff ff       	call   8008f3 <_panic>
  8030a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ac:	8b 40 08             	mov    0x8(%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	74 11                	je     8030c4 <free_block+0x31b>
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8030bf:	89 50 0c             	mov    %edx,0xc(%eax)
  8030c2:	eb 0b                	jmp    8030cf <free_block+0x326>
  8030c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ca:	a3 44 51 90 00       	mov    %eax,0x905144
  8030cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	74 11                	je     8030ea <free_block+0x341>
  8030d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e2:	8b 52 08             	mov    0x8(%edx),%edx
  8030e5:	89 50 08             	mov    %edx,0x8(%eax)
  8030e8:	eb 0b                	jmp    8030f5 <free_block+0x34c>
  8030ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ed:	8b 40 08             	mov    0x8(%eax),%eax
  8030f0:	a3 40 51 90 00       	mov    %eax,0x905140
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803102:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803109:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80310e:	48                   	dec    %eax
  80310f:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  803114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803118:	75 17                	jne    803131 <free_block+0x388>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 52 43 80 00       	push   $0x804352
  803122:	68 5a 01 00 00       	push   $0x15a
  803127:	68 b7 42 80 00       	push   $0x8042b7
  80312c:	e8 c2 d7 ff ff       	call   8008f3 <_panic>
  803131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803134:	8b 40 08             	mov    0x8(%eax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	74 11                	je     80314c <free_block+0x3a3>
  80313b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313e:	8b 40 08             	mov    0x8(%eax),%eax
  803141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803144:	8b 52 0c             	mov    0xc(%edx),%edx
  803147:	89 50 0c             	mov    %edx,0xc(%eax)
  80314a:	eb 0b                	jmp    803157 <free_block+0x3ae>
  80314c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	a3 44 51 90 00       	mov    %eax,0x905144
  803157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315a:	8b 40 0c             	mov    0xc(%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 11                	je     803172 <free_block+0x3c9>
  803161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803164:	8b 40 0c             	mov    0xc(%eax),%eax
  803167:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80316a:	8b 52 08             	mov    0x8(%edx),%edx
  80316d:	89 50 08             	mov    %edx,0x8(%eax)
  803170:	eb 0b                	jmp    80317d <free_block+0x3d4>
  803172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803175:	8b 40 08             	mov    0x8(%eax),%eax
  803178:	a3 40 51 90 00       	mov    %eax,0x905140
  80317d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803180:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803191:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803196:	48                   	dec    %eax
  803197:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80319c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  8031a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8031aa:	e9 ff 01 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  8031af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031b3:	0f 84 db 00 00 00    	je     803294 <free_block+0x4eb>
  8031b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031bd:	0f 84 d1 00 00 00    	je     803294 <free_block+0x4eb>
  8031c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c6:	8a 40 04             	mov    0x4(%eax),%al
  8031c9:	84 c0                	test   %al,%al
  8031cb:	0f 85 c3 00 00 00    	jne    803294 <free_block+0x4eb>
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	8a 40 04             	mov    0x4(%eax),%al
  8031d7:	3c 01                	cmp    $0x1,%al
  8031d9:	0f 85 b5 00 00 00    	jne    803294 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 10                	mov    (%eax),%edx
  8031e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	01 c2                	add    %eax,%edx
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8031f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803200:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803204:	75 17                	jne    80321d <free_block+0x474>
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	68 52 43 80 00       	push   $0x804352
  80320e:	68 64 01 00 00       	push   $0x164
  803213:	68 b7 42 80 00       	push   $0x8042b7
  803218:	e8 d6 d6 ff ff       	call   8008f3 <_panic>
  80321d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803220:	8b 40 08             	mov    0x8(%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 11                	je     803238 <free_block+0x48f>
  803227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322a:	8b 40 08             	mov    0x8(%eax),%eax
  80322d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803230:	8b 52 0c             	mov    0xc(%edx),%edx
  803233:	89 50 0c             	mov    %edx,0xc(%eax)
  803236:	eb 0b                	jmp    803243 <free_block+0x49a>
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	a3 44 51 90 00       	mov    %eax,0x905144
  803243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803246:	8b 40 0c             	mov    0xc(%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 11                	je     80325e <free_block+0x4b5>
  80324d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803250:	8b 40 0c             	mov    0xc(%eax),%eax
  803253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803256:	8b 52 08             	mov    0x8(%edx),%edx
  803259:	89 50 08             	mov    %edx,0x8(%eax)
  80325c:	eb 0b                	jmp    803269 <free_block+0x4c0>
  80325e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803261:	8b 40 08             	mov    0x8(%eax),%eax
  803264:	a3 40 51 90 00       	mov    %eax,0x905140
  803269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803276:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80327d:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803282:	48                   	dec    %eax
  803283:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803288:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80328f:	e9 1a 01 00 00       	jmp    8033ae <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803294:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803298:	0f 84 df 00 00 00    	je     80337d <free_block+0x5d4>
  80329e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a2:	0f 84 d5 00 00 00    	je     80337d <free_block+0x5d4>
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	8a 40 04             	mov    0x4(%eax),%al
  8032ae:	3c 01                	cmp    $0x1,%al
  8032b0:	0f 85 c7 00 00 00    	jne    80337d <free_block+0x5d4>
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8a 40 04             	mov    0x4(%eax),%al
  8032bc:	84 c0                	test   %al,%al
  8032be:	0f 85 b9 00 00 00    	jne    80337d <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  8032c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c7:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ce:	8b 10                	mov    (%eax),%edx
  8032d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	01 c2                	add    %eax,%edx
  8032d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032da:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8032dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8032ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032f0:	75 17                	jne    803309 <free_block+0x560>
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	68 52 43 80 00       	push   $0x804352
  8032fa:	68 6e 01 00 00       	push   $0x16e
  8032ff:	68 b7 42 80 00       	push   $0x8042b7
  803304:	e8 ea d5 ff ff       	call   8008f3 <_panic>
  803309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330c:	8b 40 08             	mov    0x8(%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 11                	je     803324 <free_block+0x57b>
  803313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803316:	8b 40 08             	mov    0x8(%eax),%eax
  803319:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331c:	8b 52 0c             	mov    0xc(%edx),%edx
  80331f:	89 50 0c             	mov    %edx,0xc(%eax)
  803322:	eb 0b                	jmp    80332f <free_block+0x586>
  803324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803327:	8b 40 0c             	mov    0xc(%eax),%eax
  80332a:	a3 44 51 90 00       	mov    %eax,0x905144
  80332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803332:	8b 40 0c             	mov    0xc(%eax),%eax
  803335:	85 c0                	test   %eax,%eax
  803337:	74 11                	je     80334a <free_block+0x5a1>
  803339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333c:	8b 40 0c             	mov    0xc(%eax),%eax
  80333f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803342:	8b 52 08             	mov    0x8(%edx),%edx
  803345:	89 50 08             	mov    %edx,0x8(%eax)
  803348:	eb 0b                	jmp    803355 <free_block+0x5ac>
  80334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334d:	8b 40 08             	mov    0x8(%eax),%eax
  803350:	a3 40 51 90 00       	mov    %eax,0x905140
  803355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803358:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803362:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803369:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80336e:	48                   	dec    %eax
  80336f:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803374:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  80337b:	eb 31                	jmp    8033ae <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  80337d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803381:	74 2b                	je     8033ae <free_block+0x605>
  803383:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803387:	74 25                	je     8033ae <free_block+0x605>
  803389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338c:	8a 40 04             	mov    0x4(%eax),%al
  80338f:	84 c0                	test   %al,%al
  803391:	75 1b                	jne    8033ae <free_block+0x605>
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	8a 40 04             	mov    0x4(%eax),%al
  803399:	84 c0                	test   %al,%al
  80339b:	75 11                	jne    8033ae <free_block+0x605>
	{
		block_pointer->is_free = 1;
  80339d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8033a4:	90                   	nop
  8033a5:	eb 07                	jmp    8033ae <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  8033a7:	90                   	nop
  8033a8:	eb 04                	jmp    8033ae <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  8033aa:	90                   	nop
  8033ab:	eb 01                	jmp    8033ae <free_block+0x605>
	if (va == NULL)
		return;
  8033ad:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
  8033b3:	57                   	push   %edi
  8033b4:	56                   	push   %esi
  8033b5:	53                   	push   %ebx
  8033b6:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  8033b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bd:	75 19                	jne    8033d8 <realloc_block_FF+0x28>
  8033bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033c3:	74 13                	je     8033d8 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	ff 75 0c             	pushl  0xc(%ebp)
  8033cb:	e8 0c f4 ff ff       	call   8027dc <alloc_block_FF>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	e9 84 03 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  8033d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033dc:	75 3b                	jne    803419 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  8033de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e2:	75 17                	jne    8033fb <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  8033e4:	83 ec 0c             	sub    $0xc,%esp
  8033e7:	6a 00                	push   $0x0
  8033e9:	e8 ee f3 ff ff       	call   8027dc <alloc_block_FF>
  8033ee:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f6:	e9 61 03 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  8033fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ff:	74 18                	je     803419 <realloc_block_FF+0x69>
		{
			free_block(va);
  803401:	83 ec 0c             	sub    $0xc,%esp
  803404:	ff 75 08             	pushl  0x8(%ebp)
  803407:	e8 9d f9 ff ff       	call   802da9 <free_block>
  80340c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80340f:	b8 00 00 00 00       	mov    $0x0,%eax
  803414:	e9 43 03 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  803419:	a1 40 51 90 00       	mov    0x905140,%eax
  80341e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803421:	e9 02 03 00 00       	jmp    803728 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	83 e8 10             	sub    $0x10,%eax
  80342c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80342f:	0f 85 eb 02 00 00    	jne    803720 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80343d:	83 c2 10             	add    $0x10,%edx
  803440:	39 d0                	cmp    %edx,%eax
  803442:	75 08                	jne    80344c <realloc_block_FF+0x9c>
			{
				return va;
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	e9 10 03 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  80344c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803454:	0f 83 e0 01 00 00    	jae    80363a <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  80345a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345d:	8b 40 08             	mov    0x8(%eax),%eax
  803460:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  803463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803466:	8a 40 04             	mov    0x4(%eax),%al
  803469:	3c 01                	cmp    $0x1,%al
  80346b:	0f 85 06 01 00 00    	jne    803577 <realloc_block_FF+0x1c7>
  803471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803474:	8b 10                	mov    (%eax),%edx
  803476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80347e:	29 c1                	sub    %eax,%ecx
  803480:	89 c8                	mov    %ecx,%eax
  803482:	39 c2                	cmp    %eax,%edx
  803484:	0f 86 ed 00 00 00    	jbe    803577 <realloc_block_FF+0x1c7>
  80348a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80348e:	0f 84 e3 00 00 00    	je     803577 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  803494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803497:	8b 10                	mov    (%eax),%edx
  803499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034a1:	01 d0                	add    %edx,%eax
  8034a3:	83 f8 0f             	cmp    $0xf,%eax
  8034a6:	0f 86 b5 00 00 00    	jbe    803561 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  8034ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b2:	01 d0                	add    %edx,%eax
  8034b4:	83 c0 10             	add    $0x10,%eax
  8034b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  8034ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  8034c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8034ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034ce:	74 06                	je     8034d6 <realloc_block_FF+0x126>
  8034d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034d4:	75 17                	jne    8034ed <realloc_block_FF+0x13d>
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	68 d0 42 80 00       	push   $0x8042d0
  8034de:	68 ad 01 00 00       	push   $0x1ad
  8034e3:	68 b7 42 80 00       	push   $0x8042b7
  8034e8:	e8 06 d4 ff ff       	call   8008f3 <_panic>
  8034ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f0:	8b 50 08             	mov    0x8(%eax),%edx
  8034f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f6:	89 50 08             	mov    %edx,0x8(%eax)
  8034f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034fc:	8b 40 08             	mov    0x8(%eax),%eax
  8034ff:	85 c0                	test   %eax,%eax
  803501:	74 0c                	je     80350f <realloc_block_FF+0x15f>
  803503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803506:	8b 40 08             	mov    0x8(%eax),%eax
  803509:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80350c:	89 50 0c             	mov    %edx,0xc(%eax)
  80350f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803512:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803515:	89 50 08             	mov    %edx,0x8(%eax)
  803518:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80351e:	89 50 0c             	mov    %edx,0xc(%eax)
  803521:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803524:	8b 40 08             	mov    0x8(%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	75 08                	jne    803533 <realloc_block_FF+0x183>
  80352b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352e:	a3 44 51 90 00       	mov    %eax,0x905144
  803533:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803538:	40                   	inc    %eax
  803539:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  80353e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  803547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  80354e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803551:	8d 50 10             	lea    0x10(%eax),%edx
  803554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803557:	89 10                	mov    %edx,(%eax)
						return va;
  803559:	8b 45 08             	mov    0x8(%ebp),%eax
  80355c:	e9 fb 01 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  803561:	8b 45 0c             	mov    0xc(%ebp),%eax
  803564:	8d 50 10             	lea    0x10(%eax),%edx
  803567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356a:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  80356c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356f:	83 c0 10             	add    $0x10,%eax
  803572:	e9 e5 01 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357a:	8a 40 04             	mov    0x4(%eax),%al
  80357d:	3c 01                	cmp    $0x1,%al
  80357f:	75 59                	jne    8035da <realloc_block_FF+0x22a>
  803581:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803584:	8b 10                	mov    (%eax),%edx
  803586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80358e:	29 c1                	sub    %eax,%ecx
  803590:	89 c8                	mov    %ecx,%eax
  803592:	39 c2                	cmp    %eax,%edx
  803594:	75 44                	jne    8035da <realloc_block_FF+0x22a>
  803596:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80359a:	74 3e                	je     8035da <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  80359c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359f:	8b 40 08             	mov    0x8(%eax),%eax
  8035a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  8035a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035ab:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  8035ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b4:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  8035b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  8035c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  8035c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ca:	8d 50 10             	lea    0x10(%eax),%edx
  8035cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d0:	89 10                	mov    %edx,(%eax)
					return va;
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	e9 82 01 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  8035da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035dd:	8a 40 04             	mov    0x4(%eax),%al
  8035e0:	84 c0                	test   %al,%al
  8035e2:	74 0a                	je     8035ee <realloc_block_FF+0x23e>
  8035e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035e8:	0f 85 32 01 00 00    	jne    803720 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  8035ee:	83 ec 0c             	sub    $0xc,%esp
  8035f1:	ff 75 0c             	pushl  0xc(%ebp)
  8035f4:	e8 e3 f1 ff ff       	call   8027dc <alloc_block_FF>
  8035f9:	83 c4 10             	add    $0x10,%esp
  8035fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  8035ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803603:	74 2b                	je     803630 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  803605:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	89 c3                	mov    %eax,%ebx
  80360d:	b8 04 00 00 00       	mov    $0x4,%eax
  803612:	89 d7                	mov    %edx,%edi
  803614:	89 de                	mov    %ebx,%esi
  803616:	89 c1                	mov    %eax,%ecx
  803618:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  80361a:	83 ec 0c             	sub    $0xc,%esp
  80361d:	ff 75 08             	pushl  0x8(%ebp)
  803620:	e8 84 f7 ff ff       	call   802da9 <free_block>
  803625:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362b:	e9 2c 01 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  803630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803635:	e9 22 01 00 00       	jmp    80375c <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  80363a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803642:	0f 86 d8 00 00 00    	jbe    803720 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364b:	8b 00                	mov    (%eax),%eax
  80364d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803650:	83 f8 0f             	cmp    $0xf,%eax
  803653:	0f 86 b4 00 00 00    	jbe    80370d <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803659:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365f:	01 d0                	add    %edx,%eax
  803661:	83 c0 10             	add    $0x10,%eax
  803664:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80366f:	8d 50 f0             	lea    -0x10(%eax),%edx
  803672:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803675:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803677:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80367b:	74 06                	je     803683 <realloc_block_FF+0x2d3>
  80367d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803681:	75 17                	jne    80369a <realloc_block_FF+0x2ea>
  803683:	83 ec 04             	sub    $0x4,%esp
  803686:	68 d0 42 80 00       	push   $0x8042d0
  80368b:	68 dd 01 00 00       	push   $0x1dd
  803690:	68 b7 42 80 00       	push   $0x8042b7
  803695:	e8 59 d2 ff ff       	call   8008f3 <_panic>
  80369a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369d:	8b 50 08             	mov    0x8(%eax),%edx
  8036a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036a3:	89 50 08             	mov    %edx,0x8(%eax)
  8036a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036a9:	8b 40 08             	mov    0x8(%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 0c                	je     8036bc <realloc_block_FF+0x30c>
  8036b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b3:	8b 40 08             	mov    0x8(%eax),%eax
  8036b6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8036b9:	89 50 0c             	mov    %edx,0xc(%eax)
  8036bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8036c2:	89 50 08             	mov    %edx,0x8(%eax)
  8036c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8036ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036d1:	8b 40 08             	mov    0x8(%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	75 08                	jne    8036e0 <realloc_block_FF+0x330>
  8036d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036db:	a3 44 51 90 00       	mov    %eax,0x905144
  8036e0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8036e5:	40                   	inc    %eax
  8036e6:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  8036eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036ee:	83 c0 10             	add    $0x10,%eax
  8036f1:	83 ec 0c             	sub    $0xc,%esp
  8036f4:	50                   	push   %eax
  8036f5:	e8 af f6 ff ff       	call   802da9 <free_block>
  8036fa:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  8036fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803700:	8d 50 10             	lea    0x10(%eax),%edx
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	89 10                	mov    %edx,(%eax)
					return va;
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	eb 4f                	jmp    80375c <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  80370d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803710:	8d 50 10             	lea    0x10(%eax),%edx
  803713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803716:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371b:	83 c0 10             	add    $0x10,%eax
  80371e:	eb 3c                	jmp    80375c <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803720:	a1 48 51 90 00       	mov    0x905148,%eax
  803725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80372c:	74 08                	je     803736 <realloc_block_FF+0x386>
  80372e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803731:	8b 40 08             	mov    0x8(%eax),%eax
  803734:	eb 05                	jmp    80373b <realloc_block_FF+0x38b>
  803736:	b8 00 00 00 00       	mov    $0x0,%eax
  80373b:	a3 48 51 90 00       	mov    %eax,0x905148
  803740:	a1 48 51 90 00       	mov    0x905148,%eax
  803745:	85 c0                	test   %eax,%eax
  803747:	0f 85 d9 fc ff ff    	jne    803426 <realloc_block_FF+0x76>
  80374d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803751:	0f 85 cf fc ff ff    	jne    803426 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80375c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80375f:	5b                   	pop    %ebx
  803760:	5e                   	pop    %esi
  803761:	5f                   	pop    %edi
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    

00803764 <__udivdi3>:
  803764:	55                   	push   %ebp
  803765:	57                   	push   %edi
  803766:	56                   	push   %esi
  803767:	53                   	push   %ebx
  803768:	83 ec 1c             	sub    $0x1c,%esp
  80376b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80376f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803773:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803777:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80377b:	89 ca                	mov    %ecx,%edx
  80377d:	89 f8                	mov    %edi,%eax
  80377f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803783:	85 f6                	test   %esi,%esi
  803785:	75 2d                	jne    8037b4 <__udivdi3+0x50>
  803787:	39 cf                	cmp    %ecx,%edi
  803789:	77 65                	ja     8037f0 <__udivdi3+0x8c>
  80378b:	89 fd                	mov    %edi,%ebp
  80378d:	85 ff                	test   %edi,%edi
  80378f:	75 0b                	jne    80379c <__udivdi3+0x38>
  803791:	b8 01 00 00 00       	mov    $0x1,%eax
  803796:	31 d2                	xor    %edx,%edx
  803798:	f7 f7                	div    %edi
  80379a:	89 c5                	mov    %eax,%ebp
  80379c:	31 d2                	xor    %edx,%edx
  80379e:	89 c8                	mov    %ecx,%eax
  8037a0:	f7 f5                	div    %ebp
  8037a2:	89 c1                	mov    %eax,%ecx
  8037a4:	89 d8                	mov    %ebx,%eax
  8037a6:	f7 f5                	div    %ebp
  8037a8:	89 cf                	mov    %ecx,%edi
  8037aa:	89 fa                	mov    %edi,%edx
  8037ac:	83 c4 1c             	add    $0x1c,%esp
  8037af:	5b                   	pop    %ebx
  8037b0:	5e                   	pop    %esi
  8037b1:	5f                   	pop    %edi
  8037b2:	5d                   	pop    %ebp
  8037b3:	c3                   	ret    
  8037b4:	39 ce                	cmp    %ecx,%esi
  8037b6:	77 28                	ja     8037e0 <__udivdi3+0x7c>
  8037b8:	0f bd fe             	bsr    %esi,%edi
  8037bb:	83 f7 1f             	xor    $0x1f,%edi
  8037be:	75 40                	jne    803800 <__udivdi3+0x9c>
  8037c0:	39 ce                	cmp    %ecx,%esi
  8037c2:	72 0a                	jb     8037ce <__udivdi3+0x6a>
  8037c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037c8:	0f 87 9e 00 00 00    	ja     80386c <__udivdi3+0x108>
  8037ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8037d3:	89 fa                	mov    %edi,%edx
  8037d5:	83 c4 1c             	add    $0x1c,%esp
  8037d8:	5b                   	pop    %ebx
  8037d9:	5e                   	pop    %esi
  8037da:	5f                   	pop    %edi
  8037db:	5d                   	pop    %ebp
  8037dc:	c3                   	ret    
  8037dd:	8d 76 00             	lea    0x0(%esi),%esi
  8037e0:	31 ff                	xor    %edi,%edi
  8037e2:	31 c0                	xor    %eax,%eax
  8037e4:	89 fa                	mov    %edi,%edx
  8037e6:	83 c4 1c             	add    $0x1c,%esp
  8037e9:	5b                   	pop    %ebx
  8037ea:	5e                   	pop    %esi
  8037eb:	5f                   	pop    %edi
  8037ec:	5d                   	pop    %ebp
  8037ed:	c3                   	ret    
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	89 d8                	mov    %ebx,%eax
  8037f2:	f7 f7                	div    %edi
  8037f4:	31 ff                	xor    %edi,%edi
  8037f6:	89 fa                	mov    %edi,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	bd 20 00 00 00       	mov    $0x20,%ebp
  803805:	89 eb                	mov    %ebp,%ebx
  803807:	29 fb                	sub    %edi,%ebx
  803809:	89 f9                	mov    %edi,%ecx
  80380b:	d3 e6                	shl    %cl,%esi
  80380d:	89 c5                	mov    %eax,%ebp
  80380f:	88 d9                	mov    %bl,%cl
  803811:	d3 ed                	shr    %cl,%ebp
  803813:	89 e9                	mov    %ebp,%ecx
  803815:	09 f1                	or     %esi,%ecx
  803817:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80381b:	89 f9                	mov    %edi,%ecx
  80381d:	d3 e0                	shl    %cl,%eax
  80381f:	89 c5                	mov    %eax,%ebp
  803821:	89 d6                	mov    %edx,%esi
  803823:	88 d9                	mov    %bl,%cl
  803825:	d3 ee                	shr    %cl,%esi
  803827:	89 f9                	mov    %edi,%ecx
  803829:	d3 e2                	shl    %cl,%edx
  80382b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80382f:	88 d9                	mov    %bl,%cl
  803831:	d3 e8                	shr    %cl,%eax
  803833:	09 c2                	or     %eax,%edx
  803835:	89 d0                	mov    %edx,%eax
  803837:	89 f2                	mov    %esi,%edx
  803839:	f7 74 24 0c          	divl   0xc(%esp)
  80383d:	89 d6                	mov    %edx,%esi
  80383f:	89 c3                	mov    %eax,%ebx
  803841:	f7 e5                	mul    %ebp
  803843:	39 d6                	cmp    %edx,%esi
  803845:	72 19                	jb     803860 <__udivdi3+0xfc>
  803847:	74 0b                	je     803854 <__udivdi3+0xf0>
  803849:	89 d8                	mov    %ebx,%eax
  80384b:	31 ff                	xor    %edi,%edi
  80384d:	e9 58 ff ff ff       	jmp    8037aa <__udivdi3+0x46>
  803852:	66 90                	xchg   %ax,%ax
  803854:	8b 54 24 08          	mov    0x8(%esp),%edx
  803858:	89 f9                	mov    %edi,%ecx
  80385a:	d3 e2                	shl    %cl,%edx
  80385c:	39 c2                	cmp    %eax,%edx
  80385e:	73 e9                	jae    803849 <__udivdi3+0xe5>
  803860:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803863:	31 ff                	xor    %edi,%edi
  803865:	e9 40 ff ff ff       	jmp    8037aa <__udivdi3+0x46>
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	31 c0                	xor    %eax,%eax
  80386e:	e9 37 ff ff ff       	jmp    8037aa <__udivdi3+0x46>
  803873:	90                   	nop

00803874 <__umoddi3>:
  803874:	55                   	push   %ebp
  803875:	57                   	push   %edi
  803876:	56                   	push   %esi
  803877:	53                   	push   %ebx
  803878:	83 ec 1c             	sub    $0x1c,%esp
  80387b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80387f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803883:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803887:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80388b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80388f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803893:	89 f3                	mov    %esi,%ebx
  803895:	89 fa                	mov    %edi,%edx
  803897:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80389b:	89 34 24             	mov    %esi,(%esp)
  80389e:	85 c0                	test   %eax,%eax
  8038a0:	75 1a                	jne    8038bc <__umoddi3+0x48>
  8038a2:	39 f7                	cmp    %esi,%edi
  8038a4:	0f 86 a2 00 00 00    	jbe    80394c <__umoddi3+0xd8>
  8038aa:	89 c8                	mov    %ecx,%eax
  8038ac:	89 f2                	mov    %esi,%edx
  8038ae:	f7 f7                	div    %edi
  8038b0:	89 d0                	mov    %edx,%eax
  8038b2:	31 d2                	xor    %edx,%edx
  8038b4:	83 c4 1c             	add    $0x1c,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5f                   	pop    %edi
  8038ba:	5d                   	pop    %ebp
  8038bb:	c3                   	ret    
  8038bc:	39 f0                	cmp    %esi,%eax
  8038be:	0f 87 ac 00 00 00    	ja     803970 <__umoddi3+0xfc>
  8038c4:	0f bd e8             	bsr    %eax,%ebp
  8038c7:	83 f5 1f             	xor    $0x1f,%ebp
  8038ca:	0f 84 ac 00 00 00    	je     80397c <__umoddi3+0x108>
  8038d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8038d5:	29 ef                	sub    %ebp,%edi
  8038d7:	89 fe                	mov    %edi,%esi
  8038d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038dd:	89 e9                	mov    %ebp,%ecx
  8038df:	d3 e0                	shl    %cl,%eax
  8038e1:	89 d7                	mov    %edx,%edi
  8038e3:	89 f1                	mov    %esi,%ecx
  8038e5:	d3 ef                	shr    %cl,%edi
  8038e7:	09 c7                	or     %eax,%edi
  8038e9:	89 e9                	mov    %ebp,%ecx
  8038eb:	d3 e2                	shl    %cl,%edx
  8038ed:	89 14 24             	mov    %edx,(%esp)
  8038f0:	89 d8                	mov    %ebx,%eax
  8038f2:	d3 e0                	shl    %cl,%eax
  8038f4:	89 c2                	mov    %eax,%edx
  8038f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038fa:	d3 e0                	shl    %cl,%eax
  8038fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803900:	8b 44 24 08          	mov    0x8(%esp),%eax
  803904:	89 f1                	mov    %esi,%ecx
  803906:	d3 e8                	shr    %cl,%eax
  803908:	09 d0                	or     %edx,%eax
  80390a:	d3 eb                	shr    %cl,%ebx
  80390c:	89 da                	mov    %ebx,%edx
  80390e:	f7 f7                	div    %edi
  803910:	89 d3                	mov    %edx,%ebx
  803912:	f7 24 24             	mull   (%esp)
  803915:	89 c6                	mov    %eax,%esi
  803917:	89 d1                	mov    %edx,%ecx
  803919:	39 d3                	cmp    %edx,%ebx
  80391b:	0f 82 87 00 00 00    	jb     8039a8 <__umoddi3+0x134>
  803921:	0f 84 91 00 00 00    	je     8039b8 <__umoddi3+0x144>
  803927:	8b 54 24 04          	mov    0x4(%esp),%edx
  80392b:	29 f2                	sub    %esi,%edx
  80392d:	19 cb                	sbb    %ecx,%ebx
  80392f:	89 d8                	mov    %ebx,%eax
  803931:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803935:	d3 e0                	shl    %cl,%eax
  803937:	89 e9                	mov    %ebp,%ecx
  803939:	d3 ea                	shr    %cl,%edx
  80393b:	09 d0                	or     %edx,%eax
  80393d:	89 e9                	mov    %ebp,%ecx
  80393f:	d3 eb                	shr    %cl,%ebx
  803941:	89 da                	mov    %ebx,%edx
  803943:	83 c4 1c             	add    $0x1c,%esp
  803946:	5b                   	pop    %ebx
  803947:	5e                   	pop    %esi
  803948:	5f                   	pop    %edi
  803949:	5d                   	pop    %ebp
  80394a:	c3                   	ret    
  80394b:	90                   	nop
  80394c:	89 fd                	mov    %edi,%ebp
  80394e:	85 ff                	test   %edi,%edi
  803950:	75 0b                	jne    80395d <__umoddi3+0xe9>
  803952:	b8 01 00 00 00       	mov    $0x1,%eax
  803957:	31 d2                	xor    %edx,%edx
  803959:	f7 f7                	div    %edi
  80395b:	89 c5                	mov    %eax,%ebp
  80395d:	89 f0                	mov    %esi,%eax
  80395f:	31 d2                	xor    %edx,%edx
  803961:	f7 f5                	div    %ebp
  803963:	89 c8                	mov    %ecx,%eax
  803965:	f7 f5                	div    %ebp
  803967:	89 d0                	mov    %edx,%eax
  803969:	e9 44 ff ff ff       	jmp    8038b2 <__umoddi3+0x3e>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	89 c8                	mov    %ecx,%eax
  803972:	89 f2                	mov    %esi,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	3b 04 24             	cmp    (%esp),%eax
  80397f:	72 06                	jb     803987 <__umoddi3+0x113>
  803981:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803985:	77 0f                	ja     803996 <__umoddi3+0x122>
  803987:	89 f2                	mov    %esi,%edx
  803989:	29 f9                	sub    %edi,%ecx
  80398b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80398f:	89 14 24             	mov    %edx,(%esp)
  803992:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803996:	8b 44 24 04          	mov    0x4(%esp),%eax
  80399a:	8b 14 24             	mov    (%esp),%edx
  80399d:	83 c4 1c             	add    $0x1c,%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	2b 04 24             	sub    (%esp),%eax
  8039ab:	19 fa                	sbb    %edi,%edx
  8039ad:	89 d1                	mov    %edx,%ecx
  8039af:	89 c6                	mov    %eax,%esi
  8039b1:	e9 71 ff ff ff       	jmp    803927 <__umoddi3+0xb3>
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039bc:	72 ea                	jb     8039a8 <__umoddi3+0x134>
  8039be:	89 d9                	mov    %ebx,%ecx
  8039c0:	e9 62 ff ff ff       	jmp    803927 <__umoddi3+0xb3>