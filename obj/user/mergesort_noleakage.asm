
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
  800041:	e8 50 20 00 00       	call   802096 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 3a 80 00       	push   $0x803a40
  80004e:	e8 5d 0b 00 00       	call   800bb0 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 3a 80 00       	push   $0x803a42
  80005e:	e8 4d 0b 00 00       	call   800bb0 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 3a 80 00       	push   $0x803a58
  80006e:	e8 3d 0b 00 00       	call   800bb0 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 3a 80 00       	push   $0x803a42
  80007e:	e8 2d 0b 00 00       	call   800bb0 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 3a 80 00       	push   $0x803a40
  80008e:	e8 1d 0b 00 00       	call   800bb0 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 3a 80 00       	push   $0x803a70
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
  8000d0:	e8 0a 1b 00 00       	call   801bdf <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 3a 80 00       	push   $0x803a90
  8000e3:	e8 c8 0a 00 00       	call   800bb0 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 3a 80 00       	push   $0x803ab2
  8000f3:	e8 b8 0a 00 00       	call   800bb0 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 3a 80 00       	push   $0x803ac0
  800103:	e8 a8 0a 00 00       	call   800bb0 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 3a 80 00       	push   $0x803acf
  800113:	e8 98 0a 00 00       	call   800bb0 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 3a 80 00       	push   $0x803adf
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
  800162:	e8 49 1f 00 00       	call   8020b0 <sys_enable_interrupt>

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
  8001d7:	e8 ba 1e 00 00       	call   802096 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 3a 80 00       	push   $0x803ae8
  8001e4:	e8 c7 09 00 00       	call   800bb0 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 bf 1e 00 00       	call   8020b0 <sys_enable_interrupt>

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
  80020e:	68 1c 3b 80 00       	push   $0x803b1c
  800213:	6a 4a                	push   $0x4a
  800215:	68 3e 3b 80 00       	push   $0x803b3e
  80021a:	e8 d4 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 72 1e 00 00       	call   802096 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 5c 3b 80 00       	push   $0x803b5c
  80022c:	e8 7f 09 00 00       	call   800bb0 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 90 3b 80 00       	push   $0x803b90
  80023c:	e8 6f 09 00 00       	call   800bb0 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c4 3b 80 00       	push   $0x803bc4
  80024c:	e8 5f 09 00 00       	call   800bb0 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 57 1e 00 00       	call   8020b0 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 d7 1a 00 00       	call   801d3b <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 2a 1e 00 00       	call   802096 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 f6 3b 80 00       	push   $0x803bf6
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
  8002c0:	e8 eb 1d 00 00       	call   8020b0 <sys_enable_interrupt>

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
  800454:	68 40 3a 80 00       	push   $0x803a40
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
  800476:	68 14 3c 80 00       	push   $0x803c14
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
  8004a4:	68 19 3c 80 00       	push   $0x803c19
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
  80054a:	e8 90 16 00 00       	call   801bdf <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 7b 16 00 00       	call   801bdf <malloc>
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
  80070c:	e8 2a 16 00 00       	call   801d3b <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 1c 16 00 00       	call   801d3b <free>
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
  800739:	e8 8c 19 00 00       	call   8020ca <sys_cputc>
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
  80074a:	e8 47 19 00 00       	call   802096 <sys_disable_interrupt>
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
  80075d:	e8 68 19 00 00       	call   8020ca <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 46 19 00 00       	call   8020b0 <sys_enable_interrupt>
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
  80077c:	e8 e5 17 00 00       	call   801f66 <sys_cgetc>
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
  800795:	e8 fc 18 00 00       	call   802096 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 be 17 00 00       	call   801f66 <sys_cgetc>
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
  8007b1:	e8 fa 18 00 00       	call   8020b0 <sys_enable_interrupt>
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
  8007cb:	e8 b9 1a 00 00       	call   802289 <sys_getenvindex>
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
  800828:	e8 69 18 00 00       	call   802096 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 38 3c 80 00       	push   $0x803c38
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
  800858:	68 60 3c 80 00       	push   $0x803c60
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
  800889:	68 88 3c 80 00       	push   $0x803c88
  80088e:	e8 1d 03 00 00       	call   800bb0 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 e0 3c 80 00       	push   $0x803ce0
  8008aa:	e8 01 03 00 00       	call   800bb0 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 38 3c 80 00       	push   $0x803c38
  8008ba:	e8 f1 02 00 00       	call   800bb0 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 e9 17 00 00       	call   8020b0 <sys_enable_interrupt>

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
  8008da:	e8 76 19 00 00       	call   802255 <sys_destroy_env>
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
  8008eb:	e8 cb 19 00 00       	call   8022bb <sys_exit_env>
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
  800914:	68 f4 3c 80 00       	push   $0x803cf4
  800919:	e8 92 02 00 00       	call   800bb0 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 f9 3c 80 00       	push   $0x803cf9
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
  800951:	68 15 3d 80 00       	push   $0x803d15
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
  800980:	68 18 3d 80 00       	push   $0x803d18
  800985:	6a 26                	push   $0x26
  800987:	68 64 3d 80 00       	push   $0x803d64
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
  800a55:	68 70 3d 80 00       	push   $0x803d70
  800a5a:	6a 3a                	push   $0x3a
  800a5c:	68 64 3d 80 00       	push   $0x803d64
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
  800ac8:	68 c4 3d 80 00       	push   $0x803dc4
  800acd:	6a 44                	push   $0x44
  800acf:	68 64 3d 80 00       	push   $0x803d64
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
  800b22:	e8 16 14 00 00       	call   801f3d <sys_cputs>
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
  800b99:	e8 9f 13 00 00       	call   801f3d <sys_cputs>
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
  800be3:	e8 ae 14 00 00       	call   802096 <sys_disable_interrupt>
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
  800c03:	e8 a8 14 00 00       	call   8020b0 <sys_enable_interrupt>
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
  800c4d:	e8 6e 2b 00 00       	call   8037c0 <__udivdi3>
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
  800c9d:	e8 2e 2c 00 00       	call   8038d0 <__umoddi3>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	05 34 40 80 00       	add    $0x804034,%eax
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
  800df8:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
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
  800ed9:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  800ee0:	85 f6                	test   %esi,%esi
  800ee2:	75 19                	jne    800efd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee4:	53                   	push   %ebx
  800ee5:	68 45 40 80 00       	push   $0x804045
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
  800efe:	68 4e 40 80 00       	push   $0x80404e
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
  800f2b:	be 51 40 80 00       	mov    $0x804051,%esi
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
  801244:	68 b0 41 80 00       	push   $0x8041b0
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
  801286:	68 b3 41 80 00       	push   $0x8041b3
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
  801336:	e8 5b 0d 00 00       	call   802096 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  80133b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133f:	74 13                	je     801354 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	68 b0 41 80 00       	push   $0x8041b0
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
  801385:	68 b3 41 80 00       	push   $0x8041b3
  80138a:	e8 21 f8 ff ff       	call   800bb0 <cprintf>
  80138f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801392:	e8 19 0d 00 00       	call   8020b0 <sys_enable_interrupt>
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
  80142a:	e8 81 0c 00 00       	call   8020b0 <sys_enable_interrupt>
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
	return dst;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801bb3:	a1 04 50 80 00       	mov    0x805004,%eax
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	74 0a                	je     801bc6 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801bbc:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801bc3:	00 00 00 
	}
}
  801bc6:	90                   	nop
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	e8 7e 09 00 00       	call   802558 <sys_sbrk>
  801bda:	83 c4 10             	add    $0x10,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801be5:	e8 c6 ff ff ff       	call   801bb0 <InitializeUHeap>
	if (size == 0)
  801bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bee:	75 0a                	jne    801bfa <malloc+0x1b>
		return NULL;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf5:	e9 3f 01 00 00       	jmp    801d39 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801bfa:	e8 ac 09 00 00       	call   8025ab <sys_get_hard_limit>
  801bff:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801c02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801c11:	c1 e8 0c             	shr    $0xc,%eax
  801c14:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801c17:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c24:	01 d0                	add    %edx,%eax
  801c26:	48                   	dec    %eax
  801c27:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801c2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c32:	f7 75 d8             	divl   -0x28(%ebp)
  801c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c38:	29 d0                	sub    %edx,%eax
  801c3a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801c3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c40:	c1 e8 0c             	shr    $0xc,%eax
  801c43:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c4a:	75 0a                	jne    801c56 <malloc+0x77>
		return NULL;
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	e9 e3 00 00 00       	jmp    801d39 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c59:	05 00 00 00 80       	add    $0x80000000,%eax
  801c5e:	c1 e8 0c             	shr    $0xc,%eax
  801c61:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c66:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c6d:	77 19                	ja     801c88 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	e8 60 0b 00 00       	call   8027da <alloc_block_FF>
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801c80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c83:	e9 b1 00 00 00       	jmp    801d39 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801c88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c8e:	eb 4d                	jmp    801cdd <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c93:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c9a:	84 c0                	test   %al,%al
  801c9c:	75 27                	jne    801cc5 <malloc+0xe6>
			{
				counter++;
  801c9e:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801ca1:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801ca5:	75 14                	jne    801cbb <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801caa:	05 00 00 08 00       	add    $0x80000,%eax
  801caf:	c1 e0 0c             	shl    $0xc,%eax
  801cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbe:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cc1:	75 17                	jne    801cda <malloc+0xfb>
				{
					break;
  801cc3:	eb 21                	jmp    801ce6 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801cc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc8:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801ccf:	3c 01                	cmp    $0x1,%al
  801cd1:	75 07                	jne    801cda <malloc+0xfb>
			{
				counter = 0;
  801cd3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801cda:	ff 45 e8             	incl   -0x18(%ebp)
  801cdd:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801ce4:	76 aa                	jbe    801c90 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce9:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cec:	75 46                	jne    801d34 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801cee:	83 ec 08             	sub    $0x8,%esp
  801cf1:	ff 75 d0             	pushl  -0x30(%ebp)
  801cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf7:	e8 93 08 00 00       	call   80258f <sys_allocate_user_mem>
  801cfc:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801d05:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d12:	eb 0e                	jmp    801d22 <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801d14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d17:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  801d1e:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801d1f:	ff 45 e4             	incl   -0x1c(%ebp)
  801d22:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d2d:	77 e5                	ja     801d14 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	eb 05                	jmp    801d39 <malloc+0x15a>
		}
	}

	return NULL;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801d41:	e8 65 08 00 00       	call   8025ab <sys_get_hard_limit>
  801d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801d4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d53:	0f 84 c1 00 00 00    	je     801e1a <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	79 1b                	jns    801d7b <free+0x40>
  801d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d66:	73 13                	jae    801d7b <free+0x40>
    {
        free_block(virtual_address);
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	e8 34 10 00 00       	call   802da7 <free_block>
  801d73:	83 c4 10             	add    $0x10,%esp
    	return;
  801d76:	e9 a6 00 00 00       	jmp    801e21 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7e:	05 00 10 00 00       	add    $0x1000,%eax
  801d83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d86:	0f 87 91 00 00 00    	ja     801e1d <free+0xe2>
  801d8c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d93:	0f 87 84 00 00 00    	ja     801e1d <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dad:	05 00 00 00 80       	add    $0x80000000,%eax
  801db2:	c1 e8 0c             	shr    $0xc,%eax
  801db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbb:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  801dc2:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801dc5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dc9:	74 55                	je     801e20 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801dcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dce:	c1 e8 0c             	shr    $0xc,%eax
  801dd1:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd7:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801dde:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de8:	eb 0e                	jmp    801df8 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  801df4:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801df5:	ff 45 f4             	incl   -0xc(%ebp)
  801df8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dfe:	01 c2                	add    %eax,%edx
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	39 c2                	cmp    %eax,%edx
  801e05:	77 e3                	ja     801dea <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	ff 75 e0             	pushl  -0x20(%ebp)
  801e0d:	ff 75 ec             	pushl  -0x14(%ebp)
  801e10:	e8 5e 07 00 00       	call   802573 <sys_free_user_mem>
  801e15:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801e18:	eb 07                	jmp    801e21 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801e1a:	90                   	nop
  801e1b:	eb 04                	jmp    801e21 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801e1d:	90                   	nop
  801e1e:	eb 01                	jmp    801e21 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801e20:	90                   	nop
    else
     {
    	return;
      }

}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 18             	sub    $0x18,%esp
  801e29:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2f:	e8 7c fd ff ff       	call   801bb0 <InitializeUHeap>
	if (size == 0)
  801e34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e38:	75 07                	jne    801e41 <smalloc+0x1e>
		return NULL;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	eb 17                	jmp    801e58 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	68 c4 41 80 00       	push   $0x8041c4
  801e49:	68 ad 00 00 00       	push   $0xad
  801e4e:	68 ea 41 80 00       	push   $0x8041ea
  801e53:	e8 9b ea ff ff       	call   8008f3 <_panic>
	return NULL;
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e60:	e8 4b fd ff ff       	call   801bb0 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 f8 41 80 00       	push   $0x8041f8
  801e6d:	68 ba 00 00 00       	push   $0xba
  801e72:	68 ea 41 80 00       	push   $0x8041ea
  801e77:	e8 77 ea ff ff       	call   8008f3 <_panic>

00801e7c <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e82:	e8 29 fd ff ff       	call   801bb0 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	68 1c 42 80 00       	push   $0x80421c
  801e8f:	68 d8 00 00 00       	push   $0xd8
  801e94:	68 ea 41 80 00       	push   $0x8041ea
  801e99:	e8 55 ea ff ff       	call   8008f3 <_panic>

00801e9e <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	68 44 42 80 00       	push   $0x804244
  801eac:	68 ea 00 00 00       	push   $0xea
  801eb1:	68 ea 41 80 00       	push   $0x8041ea
  801eb6:	e8 38 ea ff ff       	call   8008f3 <_panic>

00801ebb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec1:	83 ec 04             	sub    $0x4,%esp
  801ec4:	68 68 42 80 00       	push   $0x804268
  801ec9:	68 f2 00 00 00       	push   $0xf2
  801ece:	68 ea 41 80 00       	push   $0x8041ea
  801ed3:	e8 1b ea ff ff       	call   8008f3 <_panic>

00801ed8 <shrink>:

}
void shrink(uint32 newSize) {
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	68 68 42 80 00       	push   $0x804268
  801ee6:	68 f6 00 00 00       	push   $0xf6
  801eeb:	68 ea 41 80 00       	push   $0x8041ea
  801ef0:	e8 fe e9 ff ff       	call   8008f3 <_panic>

00801ef5 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	68 68 42 80 00       	push   $0x804268
  801f03:	68 fa 00 00 00       	push   $0xfa
  801f08:	68 ea 41 80 00       	push   $0x8041ea
  801f0d:	e8 e1 e9 ff ff       	call   8008f3 <_panic>

00801f12 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	57                   	push   %edi
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f27:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f2a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f2d:	cd 30                	int    $0x30
  801f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5f                   	pop    %edi
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    

00801f3d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	8b 45 10             	mov    0x10(%ebp),%eax
  801f46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	52                   	push   %edx
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	50                   	push   %eax
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 b2 ff ff ff       	call   801f12 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	90                   	nop
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 01                	push   $0x1
  801f75:	e8 98 ff ff ff       	call   801f12 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	52                   	push   %edx
  801f8f:	50                   	push   %eax
  801f90:	6a 05                	push   $0x5
  801f92:	e8 7b ff ff ff       	call   801f12 <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	56                   	push   %esi
  801fa0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa1:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	56                   	push   %esi
  801fb1:	53                   	push   %ebx
  801fb2:	51                   	push   %ecx
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	6a 06                	push   $0x6
  801fb7:	e8 56 ff ff ff       	call   801f12 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    

00801fc6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	52                   	push   %edx
  801fd6:	50                   	push   %eax
  801fd7:	6a 07                	push   $0x7
  801fd9:	e8 34 ff ff ff       	call   801f12 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	6a 08                	push   $0x8
  801ff4:	e8 19 ff ff ff       	call   801f12 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 09                	push   $0x9
  80200d:	e8 00 ff ff ff       	call   801f12 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 0a                	push   $0xa
  802026:	e8 e7 fe ff ff       	call   801f12 <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 0b                	push   $0xb
  80203f:	e8 ce fe ff ff       	call   801f12 <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 0c                	push   $0xc
  802058:	e8 b5 fe ff ff       	call   801f12 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	6a 0d                	push   $0xd
  802072:	e8 9b fe ff ff       	call   801f12 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 0e                	push   $0xe
  80208b:	e8 82 fe ff ff       	call   801f12 <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	90                   	nop
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 11                	push   $0x11
  8020a5:	e8 68 fe ff ff       	call   801f12 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	90                   	nop
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 12                	push   $0x12
  8020bf:	e8 4e fe ff ff       	call   801f12 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	90                   	nop
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_cputc>:


void
sys_cputc(const char c)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 04             	sub    $0x4,%esp
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	50                   	push   %eax
  8020e3:	6a 13                	push   $0x13
  8020e5:	e8 28 fe ff ff       	call   801f12 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 14                	push   $0x14
  8020ff:	e8 0e fe ff ff       	call   801f12 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	90                   	nop
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	50                   	push   %eax
  80211a:	6a 15                	push   $0x15
  80211c:	e8 f1 fd ff ff       	call   801f12 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	6a 18                	push   $0x18
  802139:	e8 d4 fd ff ff       	call   801f12 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802146:	8b 55 0c             	mov    0xc(%ebp),%edx
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 16                	push   $0x16
  802156:	e8 b7 fd ff ff       	call   801f12 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	90                   	nop
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802164:	8b 55 0c             	mov    0xc(%ebp),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	6a 17                	push   $0x17
  802174:	e8 99 fd ff ff       	call   801f12 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	90                   	nop
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	8b 45 10             	mov    0x10(%ebp),%eax
  802188:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80218b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80218e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	51                   	push   %ecx
  802198:	52                   	push   %edx
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	50                   	push   %eax
  80219d:	6a 19                	push   $0x19
  80219f:	e8 6e fd ff ff       	call   801f12 <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	52                   	push   %edx
  8021b9:	50                   	push   %eax
  8021ba:	6a 1a                	push   $0x1a
  8021bc:	e8 51 fd ff ff       	call   801f12 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	51                   	push   %ecx
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 1b                	push   $0x1b
  8021db:	e8 32 fd ff ff       	call   801f12 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	52                   	push   %edx
  8021f5:	50                   	push   %eax
  8021f6:	6a 1c                	push   $0x1c
  8021f8:	e8 15 fd ff ff       	call   801f12 <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 1d                	push   $0x1d
  802211:	e8 fc fc ff ff       	call   801f12 <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	6a 00                	push   $0x0
  802223:	ff 75 14             	pushl  0x14(%ebp)
  802226:	ff 75 10             	pushl  0x10(%ebp)
  802229:	ff 75 0c             	pushl  0xc(%ebp)
  80222c:	50                   	push   %eax
  80222d:	6a 1e                	push   $0x1e
  80222f:	e8 de fc ff ff       	call   801f12 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	50                   	push   %eax
  802248:	6a 1f                	push   $0x1f
  80224a:	e8 c3 fc ff ff       	call   801f12 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	90                   	nop
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	50                   	push   %eax
  802264:	6a 20                	push   $0x20
  802266:	e8 a7 fc ff ff       	call   801f12 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 02                	push   $0x2
  80227f:	e8 8e fc ff ff       	call   801f12 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 03                	push   $0x3
  802298:	e8 75 fc ff ff       	call   801f12 <syscall>
  80229d:	83 c4 18             	add    $0x18,%esp
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 04                	push   $0x4
  8022b1:	e8 5c fc ff ff       	call   801f12 <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_exit_env>:


void sys_exit_env(void)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 21                	push   $0x21
  8022ca:	e8 43 fc ff ff       	call   801f12 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	90                   	nop
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022de:	8d 50 04             	lea    0x4(%eax),%edx
  8022e1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	52                   	push   %edx
  8022eb:	50                   	push   %eax
  8022ec:	6a 22                	push   $0x22
  8022ee:	e8 1f fc ff ff       	call   801f12 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
	return result;
  8022f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ff:	89 01                	mov    %eax,(%ecx)
  802301:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	c9                   	leave  
  802308:	c2 04 00             	ret    $0x4

0080230b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	ff 75 10             	pushl  0x10(%ebp)
  802315:	ff 75 0c             	pushl  0xc(%ebp)
  802318:	ff 75 08             	pushl  0x8(%ebp)
  80231b:	6a 10                	push   $0x10
  80231d:	e8 f0 fb ff ff       	call   801f12 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
	return ;
  802325:	90                   	nop
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_rcr2>:
uint32 sys_rcr2()
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 23                	push   $0x23
  802337:	e8 d6 fb ff ff       	call   801f12 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80234d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	50                   	push   %eax
  80235a:	6a 24                	push   $0x24
  80235c:	e8 b1 fb ff ff       	call   801f12 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
	return ;
  802364:	90                   	nop
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <rsttst>:
void rsttst()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 26                	push   $0x26
  802376:	e8 97 fb ff ff       	call   801f12 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
	return ;
  80237e:	90                   	nop
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	8b 45 14             	mov    0x14(%ebp),%eax
  80238a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80238d:	8b 55 18             	mov    0x18(%ebp),%edx
  802390:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802394:	52                   	push   %edx
  802395:	50                   	push   %eax
  802396:	ff 75 10             	pushl  0x10(%ebp)
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	ff 75 08             	pushl  0x8(%ebp)
  80239f:	6a 25                	push   $0x25
  8023a1:	e8 6c fb ff ff       	call   801f12 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <chktst>:
void chktst(uint32 n)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	ff 75 08             	pushl  0x8(%ebp)
  8023ba:	6a 27                	push   $0x27
  8023bc:	e8 51 fb ff ff       	call   801f12 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c4:	90                   	nop
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <inctst>:

void inctst()
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 28                	push   $0x28
  8023d6:	e8 37 fb ff ff       	call   801f12 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
	return ;
  8023de:	90                   	nop
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <gettst>:
uint32 gettst()
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 29                	push   $0x29
  8023f0:	e8 1d fb ff ff       	call   801f12 <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 2a                	push   $0x2a
  80240c:	e8 01 fb ff ff       	call   801f12 <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
  802414:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802417:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80241b:	75 07                	jne    802424 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80241d:	b8 01 00 00 00       	mov    $0x1,%eax
  802422:	eb 05                	jmp    802429 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 2a                	push   $0x2a
  80243d:	e8 d0 fa ff ff       	call   801f12 <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
  802445:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802448:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80244c:	75 07                	jne    802455 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	eb 05                	jmp    80245a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 2a                	push   $0x2a
  80246e:	e8 9f fa ff ff       	call   801f12 <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
  802476:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802479:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80247d:	75 07                	jne    802486 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80247f:	b8 01 00 00 00       	mov    $0x1,%eax
  802484:	eb 05                	jmp    80248b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 2a                	push   $0x2a
  80249f:	e8 6e fa ff ff       	call   801f12 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
  8024a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024aa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024ae:	75 07                	jne    8024b7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b5:	eb 05                	jmp    8024bc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	ff 75 08             	pushl  0x8(%ebp)
  8024cc:	6a 2b                	push   $0x2b
  8024ce:	e8 3f fa ff ff       	call   801f12 <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d6:	90                   	nop
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	6a 00                	push   $0x0
  8024eb:	53                   	push   %ebx
  8024ec:	51                   	push   %ecx
  8024ed:	52                   	push   %edx
  8024ee:	50                   	push   %eax
  8024ef:	6a 2c                	push   $0x2c
  8024f1:	e8 1c fa ff ff       	call   801f12 <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
}
  8024f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802501:	8b 55 0c             	mov    0xc(%ebp),%edx
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	52                   	push   %edx
  80250e:	50                   	push   %eax
  80250f:	6a 2d                	push   $0x2d
  802511:	e8 fc f9 ff ff       	call   801f12 <syscall>
  802516:	83 c4 18             	add    $0x18,%esp
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80251e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802521:	8b 55 0c             	mov    0xc(%ebp),%edx
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	6a 00                	push   $0x0
  802529:	51                   	push   %ecx
  80252a:	ff 75 10             	pushl  0x10(%ebp)
  80252d:	52                   	push   %edx
  80252e:	50                   	push   %eax
  80252f:	6a 2e                	push   $0x2e
  802531:	e8 dc f9 ff ff       	call   801f12 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	ff 75 10             	pushl  0x10(%ebp)
  802545:	ff 75 0c             	pushl  0xc(%ebp)
  802548:	ff 75 08             	pushl  0x8(%ebp)
  80254b:	6a 0f                	push   $0xf
  80254d:	e8 c0 f9 ff ff       	call   801f12 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
	return ;
  802555:	90                   	nop
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	50                   	push   %eax
  802567:	6a 2f                	push   $0x2f
  802569:	e8 a4 f9 ff ff       	call   801f12 <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp

}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	ff 75 0c             	pushl  0xc(%ebp)
  80257f:	ff 75 08             	pushl  0x8(%ebp)
  802582:	6a 30                	push   $0x30
  802584:	e8 89 f9 ff ff       	call   801f12 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
	return;
  80258c:	90                   	nop
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	ff 75 0c             	pushl  0xc(%ebp)
  80259b:	ff 75 08             	pushl  0x8(%ebp)
  80259e:	6a 31                	push   $0x31
  8025a0:	e8 6d f9 ff ff       	call   801f12 <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
	return;
  8025a8:	90                   	nop
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 32                	push   $0x32
  8025ba:	e8 53 f9 ff ff       	call   801f12 <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	50                   	push   %eax
  8025d3:	6a 33                	push   $0x33
  8025d5:	e8 38 f9 ff ff       	call   801f12 <syscall>
  8025da:	83 c4 18             	add    $0x18,%esp
}
  8025dd:	90                   	nop
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	83 e8 10             	sub    $0x10,%eax
  8025ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  8025ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	83 e8 10             	sub    $0x10,%eax
  802602:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  802605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802608:	8a 40 04             	mov    0x4(%eax),%al
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80261a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261d:	83 f8 02             	cmp    $0x2,%eax
  802620:	74 2b                	je     80264d <alloc_block+0x40>
  802622:	83 f8 02             	cmp    $0x2,%eax
  802625:	7f 07                	jg     80262e <alloc_block+0x21>
  802627:	83 f8 01             	cmp    $0x1,%eax
  80262a:	74 0e                	je     80263a <alloc_block+0x2d>
  80262c:	eb 58                	jmp    802686 <alloc_block+0x79>
  80262e:	83 f8 03             	cmp    $0x3,%eax
  802631:	74 2d                	je     802660 <alloc_block+0x53>
  802633:	83 f8 04             	cmp    $0x4,%eax
  802636:	74 3b                	je     802673 <alloc_block+0x66>
  802638:	eb 4c                	jmp    802686 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	ff 75 08             	pushl  0x8(%ebp)
  802640:	e8 95 01 00 00       	call   8027da <alloc_block_FF>
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264b:	eb 4a                	jmp    802697 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80264d:	83 ec 0c             	sub    $0xc,%esp
  802650:	ff 75 08             	pushl  0x8(%ebp)
  802653:	e8 32 07 00 00       	call   802d8a <alloc_block_NF>
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80265e:	eb 37                	jmp    802697 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802660:	83 ec 0c             	sub    $0xc,%esp
  802663:	ff 75 08             	pushl  0x8(%ebp)
  802666:	e8 a3 04 00 00       	call   802b0e <alloc_block_BF>
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802671:	eb 24                	jmp    802697 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	ff 75 08             	pushl  0x8(%ebp)
  802679:	e8 ef 06 00 00       	call   802d6d <alloc_block_WF>
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802684:	eb 11                	jmp    802697 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802686:	83 ec 0c             	sub    $0xc,%esp
  802689:	68 78 42 80 00       	push   $0x804278
  80268e:	e8 1d e5 ff ff       	call   800bb0 <cprintf>
  802693:	83 c4 10             	add    $0x10,%esp
		break;
  802696:	90                   	nop
	}
	return va;
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8026a2:	83 ec 0c             	sub    $0xc,%esp
  8026a5:	68 98 42 80 00       	push   $0x804298
  8026aa:	e8 01 e5 ff ff       	call   800bb0 <cprintf>
  8026af:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	68 c3 42 80 00       	push   $0x8042c3
  8026ba:	e8 f1 e4 ff ff       	call   800bb0 <cprintf>
  8026bf:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c8:	eb 26                	jmp    8026f0 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8a 40 04             	mov    0x4(%eax),%al
  8026d0:	0f b6 d0             	movzbl %al,%edx
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	83 ec 04             	sub    $0x4,%esp
  8026db:	52                   	push   %edx
  8026dc:	50                   	push   %eax
  8026dd:	68 db 42 80 00       	push   $0x8042db
  8026e2:	e8 c9 e4 ff ff       	call   800bb0 <cprintf>
  8026e7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f4:	74 08                	je     8026fe <print_blocks_list+0x62>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 08             	mov    0x8(%eax),%eax
  8026fc:	eb 05                	jmp    802703 <print_blocks_list+0x67>
  8026fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802703:	89 45 10             	mov    %eax,0x10(%ebp)
  802706:	8b 45 10             	mov    0x10(%ebp),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	75 bd                	jne    8026ca <print_blocks_list+0x2e>
  80270d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802711:	75 b7                	jne    8026ca <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  802713:	83 ec 0c             	sub    $0xc,%esp
  802716:	68 98 42 80 00       	push   $0x804298
  80271b:	e8 90 e4 ff ff       	call   800bb0 <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp

}
  802723:	90                   	nop
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  80272c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802730:	0f 84 a1 00 00 00    	je     8027d7 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802736:	c7 05 30 50 80 00 01 	movl   $0x1,0x805030
  80273d:	00 00 00 
	LIST_INIT(&list);
  802740:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802747:	00 00 00 
  80274a:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  802751:	00 00 00 
  802754:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  80275b:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802771:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802777:	75 14                	jne    80278d <initialize_dynamic_allocator+0x67>
  802779:	83 ec 04             	sub    $0x4,%esp
  80277c:	68 f4 42 80 00       	push   $0x8042f4
  802781:	6a 64                	push   $0x64
  802783:	68 17 43 80 00       	push   $0x804317
  802788:	e8 66 e1 ff ff       	call   8008f3 <_panic>
  80278d:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	89 50 0c             	mov    %edx,0xc(%eax)
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 0d                	je     8027b0 <initialize_dynamic_allocator+0x8a>
  8027a3:	a1 44 51 90 00       	mov    0x905144,%eax
  8027a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ab:	89 50 08             	mov    %edx,0x8(%eax)
  8027ae:	eb 08                	jmp    8027b8 <initialize_dynamic_allocator+0x92>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	a3 40 51 90 00       	mov    %eax,0x905140
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	a3 44 51 90 00       	mov    %eax,0x905144
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027ca:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8027cf:	40                   	inc    %eax
  8027d0:	a3 4c 51 90 00       	mov    %eax,0x90514c
  8027d5:	eb 01                	jmp    8027d8 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8027d7:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8027e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e4:	75 0a                	jne    8027f0 <alloc_block_FF+0x16>
	{
		return NULL;
  8027e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027eb:	e9 1c 03 00 00       	jmp    802b0c <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8027f0:	a1 30 50 80 00       	mov    0x805030,%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	75 40                	jne    802839 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	83 c0 10             	add    $0x10,%eax
  8027ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	50                   	push   %eax
  802809:	e8 bb f3 ff ff       	call   801bc9 <sbrk>
  80280e:	83 c4 10             	add    $0x10,%esp
  802811:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	6a 00                	push   $0x0
  802819:	e8 ab f3 ff ff       	call   801bc9 <sbrk>
  80281e:	83 c4 10             	add    $0x10,%esp
  802821:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  802824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802827:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80282a:	83 ec 08             	sub    $0x8,%esp
  80282d:	50                   	push   %eax
  80282e:	ff 75 ec             	pushl  -0x14(%ebp)
  802831:	e8 f0 fe ff ff       	call   802726 <initialize_dynamic_allocator>
  802836:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802839:	a1 40 51 90 00       	mov    0x905140,%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802841:	e9 1e 01 00 00       	jmp    802964 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	8d 50 10             	lea    0x10(%eax),%edx
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	39 c2                	cmp    %eax,%edx
  802853:	75 1c                	jne    802871 <alloc_block_FF+0x97>
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8a 40 04             	mov    0x4(%eax),%al
  80285b:	3c 01                	cmp    $0x1,%al
  80285d:	75 12                	jne    802871 <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	83 c0 10             	add    $0x10,%eax
  80286c:	e9 9b 02 00 00       	jmp    802b0c <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	8d 50 10             	lea    0x10(%eax),%edx
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	39 c2                	cmp    %eax,%edx
  80287e:	0f 83 d8 00 00 00    	jae    80295c <alloc_block_FF+0x182>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8a 40 04             	mov    0x4(%eax),%al
  80288a:	3c 01                	cmp    $0x1,%al
  80288c:	0f 85 ca 00 00 00    	jne    80295c <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	2b 45 08             	sub    0x8(%ebp),%eax
  80289a:	83 e8 10             	sub    $0x10,%eax
  80289d:	83 f8 0f             	cmp    $0xf,%eax
  8028a0:	0f 86 a4 00 00 00    	jbe    80294a <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  8028a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	01 d0                	add    %edx,%eax
  8028ae:	83 c0 10             	add    $0x10,%eax
  8028b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8028bc:	8d 50 f0             	lea    -0x10(%eax),%edx
  8028bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c2:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  8028c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c7:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8028cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cf:	74 06                	je     8028d7 <alloc_block_FF+0xfd>
  8028d1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8028d5:	75 17                	jne    8028ee <alloc_block_FF+0x114>
  8028d7:	83 ec 04             	sub    $0x4,%esp
  8028da:	68 30 43 80 00       	push   $0x804330
  8028df:	68 8f 00 00 00       	push   $0x8f
  8028e4:	68 17 43 80 00       	push   $0x804317
  8028e9:	e8 05 e0 ff ff       	call   8008f3 <_panic>
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 50 08             	mov    0x8(%eax),%edx
  8028f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028f7:	89 50 08             	mov    %edx,0x8(%eax)
  8028fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028fd:	8b 40 08             	mov    0x8(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0c                	je     802910 <alloc_block_FF+0x136>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 08             	mov    0x8(%eax),%eax
  80290a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80290d:	89 50 0c             	mov    %edx,0xc(%eax)
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802916:	89 50 08             	mov    %edx,0x8(%eax)
  802919:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80291c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291f:	89 50 0c             	mov    %edx,0xc(%eax)
  802922:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802925:	8b 40 08             	mov    0x8(%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	75 08                	jne    802934 <alloc_block_FF+0x15a>
  80292c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80292f:	a3 44 51 90 00       	mov    %eax,0x905144
  802934:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802939:	40                   	inc    %eax
  80293a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	8d 50 10             	lea    0x10(%eax),%edx
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	83 c0 10             	add    $0x10,%eax
  802957:	e9 b0 01 00 00       	jmp    802b0c <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  80295c:	a1 48 51 90 00       	mov    0x905148,%eax
  802961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802968:	74 08                	je     802972 <alloc_block_FF+0x198>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 40 08             	mov    0x8(%eax),%eax
  802970:	eb 05                	jmp    802977 <alloc_block_FF+0x19d>
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	a3 48 51 90 00       	mov    %eax,0x905148
  80297c:	a1 48 51 90 00       	mov    0x905148,%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	0f 85 bd fe ff ff    	jne    802846 <alloc_block_FF+0x6c>
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	0f 85 b3 fe ff ff    	jne    802846 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 c0 10             	add    $0x10,%eax
  802999:	83 ec 0c             	sub    $0xc,%esp
  80299c:	50                   	push   %eax
  80299d:	e8 27 f2 ff ff       	call   801bc9 <sbrk>
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  8029a8:	83 ec 0c             	sub    $0xc,%esp
  8029ab:	6a 00                	push   $0x0
  8029ad:	e8 17 f2 ff ff       	call   801bc9 <sbrk>
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  8029b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029be:	29 c2                	sub    %eax,%edx
  8029c0:	89 d0                	mov    %edx,%eax
  8029c2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  8029c5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8029c9:	0f 84 38 01 00 00    	je     802b07 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  8029cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8029d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029d9:	75 17                	jne    8029f2 <alloc_block_FF+0x218>
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	68 f4 42 80 00       	push   $0x8042f4
  8029e3:	68 9f 00 00 00       	push   $0x9f
  8029e8:	68 17 43 80 00       	push   $0x804317
  8029ed:	e8 01 df ff ff       	call   8008f3 <_panic>
  8029f2:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8029f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8029fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 0d                	je     802a15 <alloc_block_FF+0x23b>
  802a08:	a1 44 51 90 00       	mov    0x905144,%eax
  802a0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a10:	89 50 08             	mov    %edx,0x8(%eax)
  802a13:	eb 08                	jmp    802a1d <alloc_block_FF+0x243>
  802a15:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a18:	a3 40 51 90 00       	mov    %eax,0x905140
  802a1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a20:	a3 44 51 90 00       	mov    %eax,0x905144
  802a25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a2f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802a34:	40                   	inc    %eax
  802a35:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8d 50 10             	lea    0x10(%eax),%edx
  802a40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a43:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802a45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a48:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a4f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a52:	83 f8 10             	cmp    $0x10,%eax
  802a55:	0f 84 a4 00 00 00    	je     802aff <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802a5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a5e:	2b 45 08             	sub    0x8(%ebp),%eax
  802a61:	83 e8 10             	sub    $0x10,%eax
  802a64:	83 f8 0f             	cmp    $0xf,%eax
  802a67:	0f 86 8a 00 00 00    	jbe    802af7 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	01 d0                	add    %edx,%eax
  802a75:	83 c0 10             	add    $0x10,%eax
  802a78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802a7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a7f:	75 17                	jne    802a98 <alloc_block_FF+0x2be>
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 f4 42 80 00       	push   $0x8042f4
  802a89:	68 a7 00 00 00       	push   $0xa7
  802a8e:	68 17 43 80 00       	push   $0x804317
  802a93:	e8 5b de ff ff       	call   8008f3 <_panic>
  802a98:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802a9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa1:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0d                	je     802abb <alloc_block_FF+0x2e1>
  802aae:	a1 44 51 90 00       	mov    0x905144,%eax
  802ab3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab6:	89 50 08             	mov    %edx,0x8(%eax)
  802ab9:	eb 08                	jmp    802ac3 <alloc_block_FF+0x2e9>
  802abb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802abe:	a3 40 51 90 00       	mov    %eax,0x905140
  802ac3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ac6:	a3 44 51 90 00       	mov    %eax,0x905144
  802acb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ace:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ad5:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ada:	40                   	inc    %eax
  802adb:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802ae0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae6:	8d 50 f0             	lea    -0x10(%eax),%edx
  802ae9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aec:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802af1:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802af5:	eb 08                	jmp    802aff <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802afa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802afd:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802aff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b02:	83 c0 10             	add    $0x10,%eax
  802b05:	eb 05                	jmp    802b0c <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802b07:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802b0c:	c9                   	leave  
  802b0d:	c3                   	ret    

00802b0e <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b0e:	55                   	push   %ebp
  802b0f:	89 e5                	mov    %esp,%ebp
  802b11:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802b14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802b1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1f:	75 0a                	jne    802b2b <alloc_block_BF+0x1d>
	{
		return NULL;
  802b21:	b8 00 00 00 00       	mov    $0x0,%eax
  802b26:	e9 40 02 00 00       	jmp    802d6b <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802b2b:	a1 40 51 90 00       	mov    0x905140,%eax
  802b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b33:	eb 66                	jmp    802b9b <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8a 40 04             	mov    0x4(%eax),%al
  802b3b:	3c 01                	cmp    $0x1,%al
  802b3d:	75 21                	jne    802b60 <alloc_block_BF+0x52>
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	8d 50 10             	lea    0x10(%eax),%edx
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	39 c2                	cmp    %eax,%edx
  802b4c:	75 12                	jne    802b60 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	83 c0 10             	add    $0x10,%eax
  802b5b:	e9 0b 02 00 00       	jmp    802d6b <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8a 40 04             	mov    0x4(%eax),%al
  802b66:	3c 01                	cmp    $0x1,%al
  802b68:	75 29                	jne    802b93 <alloc_block_BF+0x85>
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	8d 50 10             	lea    0x10(%eax),%edx
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	39 c2                	cmp    %eax,%edx
  802b77:	77 1a                	ja     802b93 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802b79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7d:	74 0e                	je     802b8d <alloc_block_BF+0x7f>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 10                	mov    (%eax),%edx
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	39 c2                	cmp    %eax,%edx
  802b8b:	73 06                	jae    802b93 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802b93:	a1 48 51 90 00       	mov    0x905148,%eax
  802b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	74 08                	je     802ba9 <alloc_block_BF+0x9b>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 40 08             	mov    0x8(%eax),%eax
  802ba7:	eb 05                	jmp    802bae <alloc_block_BF+0xa0>
  802ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bae:	a3 48 51 90 00       	mov    %eax,0x905148
  802bb3:	a1 48 51 90 00       	mov    0x905148,%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	0f 85 75 ff ff ff    	jne    802b35 <alloc_block_BF+0x27>
  802bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc4:	0f 85 6b ff ff ff    	jne    802b35 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bce:	0f 84 f8 00 00 00    	je     802ccc <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8d 50 10             	lea    0x10(%eax),%edx
  802bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	39 c2                	cmp    %eax,%edx
  802be1:	0f 87 e5 00 00 00    	ja     802ccc <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	2b 45 08             	sub    0x8(%ebp),%eax
  802bef:	83 e8 10             	sub    $0x10,%eax
  802bf2:	83 f8 0f             	cmp    $0xf,%eax
  802bf5:	0f 86 bf 00 00 00    	jbe    802cba <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	01 d0                	add    %edx,%eax
  802c03:	83 c0 10             	add    $0x10,%eax
  802c06:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	2b 45 08             	sub    0x8(%ebp),%eax
  802c1a:	8d 50 f0             	lea    -0x10(%eax),%edx
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802c29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2d:	74 06                	je     802c35 <alloc_block_BF+0x127>
  802c2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c33:	75 17                	jne    802c4c <alloc_block_BF+0x13e>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 30 43 80 00       	push   $0x804330
  802c3d:	68 e3 00 00 00       	push   $0xe3
  802c42:	68 17 43 80 00       	push   $0x804317
  802c47:	e8 a7 dc ff ff       	call   8008f3 <_panic>
  802c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4f:	8b 50 08             	mov    0x8(%eax),%edx
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	89 50 08             	mov    %edx,0x8(%eax)
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	8b 40 08             	mov    0x8(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0c                	je     802c6e <alloc_block_BF+0x160>
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 08             	mov    0x8(%eax),%eax
  802c68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6b:	89 50 0c             	mov    %edx,0xc(%eax)
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c74:	89 50 08             	mov    %edx,0x8(%eax)
  802c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7d:	89 50 0c             	mov    %edx,0xc(%eax)
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	8b 40 08             	mov    0x8(%eax),%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	75 08                	jne    802c92 <alloc_block_BF+0x184>
  802c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8d:	a3 44 51 90 00       	mov    %eax,0x905144
  802c92:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802c97:	40                   	inc    %eax
  802c98:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8d 50 10             	lea    0x10(%eax),%edx
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	83 c0 10             	add    $0x10,%eax
  802cb5:	e9 b1 00 00 00       	jmp    802d6b <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	83 c0 10             	add    $0x10,%eax
  802cc7:	e9 9f 00 00 00       	jmp    802d6b <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	83 c0 10             	add    $0x10,%eax
  802cd2:	83 ec 0c             	sub    $0xc,%esp
  802cd5:	50                   	push   %eax
  802cd6:	e8 ee ee ff ff       	call   801bc9 <sbrk>
  802cdb:	83 c4 10             	add    $0x10,%esp
  802cde:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802ce1:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802ce5:	74 7f                	je     802d66 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802ce7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ceb:	75 17                	jne    802d04 <alloc_block_BF+0x1f6>
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	68 f4 42 80 00       	push   $0x8042f4
  802cf5:	68 f6 00 00 00       	push   $0xf6
  802cfa:	68 17 43 80 00       	push   $0x804317
  802cff:	e8 ef db ff ff       	call   8008f3 <_panic>
  802d04:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
  802d10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d13:	8b 40 0c             	mov    0xc(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0d                	je     802d27 <alloc_block_BF+0x219>
  802d1a:	a1 44 51 90 00       	mov    0x905144,%eax
  802d1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d22:	89 50 08             	mov    %edx,0x8(%eax)
  802d25:	eb 08                	jmp    802d2f <alloc_block_BF+0x221>
  802d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2a:	a3 40 51 90 00       	mov    %eax,0x905140
  802d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d32:	a3 44 51 90 00       	mov    %eax,0x905144
  802d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d41:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d46:	40                   	inc    %eax
  802d47:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8d 50 10             	lea    0x10(%eax),%edx
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d61:	83 c0 10             	add    $0x10,%eax
  802d64:	eb 05                	jmp    802d6b <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802d66:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802d6b:	c9                   	leave  
  802d6c:	c3                   	ret    

00802d6d <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
  802d70:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	68 64 43 80 00       	push   $0x804364
  802d7b:	68 07 01 00 00       	push   $0x107
  802d80:	68 17 43 80 00       	push   $0x804317
  802d85:	e8 69 db ff ff       	call   8008f3 <_panic>

00802d8a <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
  802d8d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802d90:	83 ec 04             	sub    $0x4,%esp
  802d93:	68 8c 43 80 00       	push   $0x80438c
  802d98:	68 0f 01 00 00       	push   $0x10f
  802d9d:	68 17 43 80 00       	push   $0x804317
  802da2:	e8 4c db ff ff       	call   8008f3 <_panic>

00802da7 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
  802daa:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802dad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db1:	0f 84 ee 05 00 00    	je     8033a5 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	83 e8 10             	sub    $0x10,%eax
  802dbd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802dc0:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802dc4:	a1 40 51 90 00       	mov    0x905140,%eax
  802dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802dcc:	eb 16                	jmp    802de4 <free_block+0x3d>
	{
		if (block_pointer == it)
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dd4:	75 06                	jne    802ddc <free_block+0x35>
		{
			flagx = 1;
  802dd6:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802dda:	eb 2f                	jmp    802e0b <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802ddc:	a1 48 51 90 00       	mov    0x905148,%eax
  802de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802de4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de8:	74 08                	je     802df2 <free_block+0x4b>
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	8b 40 08             	mov    0x8(%eax),%eax
  802df0:	eb 05                	jmp    802df7 <free_block+0x50>
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
  802df7:	a3 48 51 90 00       	mov    %eax,0x905148
  802dfc:	a1 48 51 90 00       	mov    0x905148,%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	75 c9                	jne    802dce <free_block+0x27>
  802e05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e09:	75 c3                	jne    802dce <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802e0b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802e0f:	0f 84 93 05 00 00    	je     8033a8 <free_block+0x601>
		return;
	if (va == NULL)
  802e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e19:	0f 84 8c 05 00 00    	je     8033ab <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e22:	8b 40 0c             	mov    0xc(%eax),%eax
  802e25:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2b:	8b 40 08             	mov    0x8(%eax),%eax
  802e2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802e31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e35:	75 12                	jne    802e49 <free_block+0xa2>
  802e37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e3b:	75 0c                	jne    802e49 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e44:	e9 63 05 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802e49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e4d:	0f 85 ca 00 00 00    	jne    802f1d <free_block+0x176>
  802e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e56:	8a 40 04             	mov    0x4(%eax),%al
  802e59:	3c 01                	cmp    $0x1,%al
  802e5b:	0f 85 bc 00 00 00    	jne    802f1d <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6b:	8b 10                	mov    (%eax),%edx
  802e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	01 c2                	add    %eax,%edx
  802e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e77:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e85:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802e89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e8d:	75 17                	jne    802ea6 <free_block+0xff>
  802e8f:	83 ec 04             	sub    $0x4,%esp
  802e92:	68 b2 43 80 00       	push   $0x8043b2
  802e97:	68 3c 01 00 00       	push   $0x13c
  802e9c:	68 17 43 80 00       	push   $0x804317
  802ea1:	e8 4d da ff ff       	call   8008f3 <_panic>
  802ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea9:	8b 40 08             	mov    0x8(%eax),%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	74 11                	je     802ec1 <free_block+0x11a>
  802eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb3:	8b 40 08             	mov    0x8(%eax),%eax
  802eb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eb9:	8b 52 0c             	mov    0xc(%edx),%edx
  802ebc:	89 50 0c             	mov    %edx,0xc(%eax)
  802ebf:	eb 0b                	jmp    802ecc <free_block+0x125>
  802ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec7:	a3 44 51 90 00       	mov    %eax,0x905144
  802ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	74 11                	je     802ee7 <free_block+0x140>
  802ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed9:	8b 40 0c             	mov    0xc(%eax),%eax
  802edc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802edf:	8b 52 08             	mov    0x8(%edx),%edx
  802ee2:	89 50 08             	mov    %edx,0x8(%eax)
  802ee5:	eb 0b                	jmp    802ef2 <free_block+0x14b>
  802ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	a3 40 51 90 00       	mov    %eax,0x905140
  802ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f06:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802f0b:	48                   	dec    %eax
  802f0c:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802f11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802f18:	e9 8f 04 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802f1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f21:	75 16                	jne    802f39 <free_block+0x192>
  802f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f26:	8a 40 04             	mov    0x4(%eax),%al
  802f29:	84 c0                	test   %al,%al
  802f2b:	75 0c                	jne    802f39 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f30:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802f34:	e9 73 04 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802f39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f3d:	0f 85 c3 00 00 00    	jne    803006 <free_block+0x25f>
  802f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f46:	8a 40 04             	mov    0x4(%eax),%al
  802f49:	3c 01                	cmp    $0x1,%al
  802f4b:	0f 85 b5 00 00 00    	jne    803006 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f54:	8b 10                	mov    (%eax),%edx
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	01 c2                	add    %eax,%edx
  802f5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f60:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802f72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f76:	75 17                	jne    802f8f <free_block+0x1e8>
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	68 b2 43 80 00       	push   $0x8043b2
  802f80:	68 49 01 00 00       	push   $0x149
  802f85:	68 17 43 80 00       	push   $0x804317
  802f8a:	e8 64 d9 ff ff       	call   8008f3 <_panic>
  802f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f92:	8b 40 08             	mov    0x8(%eax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	74 11                	je     802faa <free_block+0x203>
  802f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fa2:	8b 52 0c             	mov    0xc(%edx),%edx
  802fa5:	89 50 0c             	mov    %edx,0xc(%eax)
  802fa8:	eb 0b                	jmp    802fb5 <free_block+0x20e>
  802faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fad:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb0:	a3 44 51 90 00       	mov    %eax,0x905144
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbb:	85 c0                	test   %eax,%eax
  802fbd:	74 11                	je     802fd0 <free_block+0x229>
  802fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fc8:	8b 52 08             	mov    0x8(%edx),%edx
  802fcb:	89 50 08             	mov    %edx,0x8(%eax)
  802fce:	eb 0b                	jmp    802fdb <free_block+0x234>
  802fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd3:	8b 40 08             	mov    0x8(%eax),%eax
  802fd6:	a3 40 51 90 00       	mov    %eax,0x905140
  802fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fef:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ff4:	48                   	dec    %eax
  802ff5:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802ffa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803001:	e9 a6 03 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  803006:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80300a:	75 16                	jne    803022 <free_block+0x27b>
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	8a 40 04             	mov    0x4(%eax),%al
  803012:	84 c0                	test   %al,%al
  803014:	75 0c                	jne    803022 <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80301d:	e9 8a 03 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  803022:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803026:	0f 84 81 01 00 00    	je     8031ad <free_block+0x406>
  80302c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803030:	0f 84 77 01 00 00    	je     8031ad <free_block+0x406>
  803036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803039:	8a 40 04             	mov    0x4(%eax),%al
  80303c:	3c 01                	cmp    $0x1,%al
  80303e:	0f 85 69 01 00 00    	jne    8031ad <free_block+0x406>
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	8a 40 04             	mov    0x4(%eax),%al
  80304a:	3c 01                	cmp    $0x1,%al
  80304c:	0f 85 5b 01 00 00    	jne    8031ad <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 10                	mov    (%eax),%edx
  803057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305a:	8b 08                	mov    (%eax),%ecx
  80305c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	01 c8                	add    %ecx,%eax
  803063:	01 c2                	add    %eax,%edx
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  80306a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803076:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  80307a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803083:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803086:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  80308a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80308e:	75 17                	jne    8030a7 <free_block+0x300>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 b2 43 80 00       	push   $0x8043b2
  803098:	68 59 01 00 00       	push   $0x159
  80309d:	68 17 43 80 00       	push   $0x804317
  8030a2:	e8 4c d8 ff ff       	call   8008f3 <_panic>
  8030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030aa:	8b 40 08             	mov    0x8(%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 11                	je     8030c2 <free_block+0x31b>
  8030b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8030bd:	89 50 0c             	mov    %edx,0xc(%eax)
  8030c0:	eb 0b                	jmp    8030cd <free_block+0x326>
  8030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c8:	a3 44 51 90 00       	mov    %eax,0x905144
  8030cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 11                	je     8030e8 <free_block+0x341>
  8030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030da:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e0:	8b 52 08             	mov    0x8(%edx),%edx
  8030e3:	89 50 08             	mov    %edx,0x8(%eax)
  8030e6:	eb 0b                	jmp    8030f3 <free_block+0x34c>
  8030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030eb:	8b 40 08             	mov    0x8(%eax),%eax
  8030ee:	a3 40 51 90 00       	mov    %eax,0x905140
  8030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803100:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803107:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80310c:	48                   	dec    %eax
  80310d:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  803112:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803116:	75 17                	jne    80312f <free_block+0x388>
  803118:	83 ec 04             	sub    $0x4,%esp
  80311b:	68 b2 43 80 00       	push   $0x8043b2
  803120:	68 5a 01 00 00       	push   $0x15a
  803125:	68 17 43 80 00       	push   $0x804317
  80312a:	e8 c4 d7 ff ff       	call   8008f3 <_panic>
  80312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803132:	8b 40 08             	mov    0x8(%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	74 11                	je     80314a <free_block+0x3a3>
  803139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313c:	8b 40 08             	mov    0x8(%eax),%eax
  80313f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803142:	8b 52 0c             	mov    0xc(%edx),%edx
  803145:	89 50 0c             	mov    %edx,0xc(%eax)
  803148:	eb 0b                	jmp    803155 <free_block+0x3ae>
  80314a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314d:	8b 40 0c             	mov    0xc(%eax),%eax
  803150:	a3 44 51 90 00       	mov    %eax,0x905144
  803155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 11                	je     803170 <free_block+0x3c9>
  80315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803162:	8b 40 0c             	mov    0xc(%eax),%eax
  803165:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803168:	8b 52 08             	mov    0x8(%edx),%edx
  80316b:	89 50 08             	mov    %edx,0x8(%eax)
  80316e:	eb 0b                	jmp    80317b <free_block+0x3d4>
  803170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803173:	8b 40 08             	mov    0x8(%eax),%eax
  803176:	a3 40 51 90 00       	mov    %eax,0x905140
  80317b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803188:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80318f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803194:	48                   	dec    %eax
  803195:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80319a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  8031a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  8031a8:	e9 ff 01 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  8031ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031b1:	0f 84 db 00 00 00    	je     803292 <free_block+0x4eb>
  8031b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031bb:	0f 84 d1 00 00 00    	je     803292 <free_block+0x4eb>
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	8a 40 04             	mov    0x4(%eax),%al
  8031c7:	84 c0                	test   %al,%al
  8031c9:	0f 85 c3 00 00 00    	jne    803292 <free_block+0x4eb>
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8a 40 04             	mov    0x4(%eax),%al
  8031d5:	3c 01                	cmp    $0x1,%al
  8031d7:	0f 85 b5 00 00 00    	jne    803292 <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 10                	mov    (%eax),%edx
  8031e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	01 c2                	add    %eax,%edx
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8031ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fa:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8031fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803202:	75 17                	jne    80321b <free_block+0x474>
  803204:	83 ec 04             	sub    $0x4,%esp
  803207:	68 b2 43 80 00       	push   $0x8043b2
  80320c:	68 64 01 00 00       	push   $0x164
  803211:	68 17 43 80 00       	push   $0x804317
  803216:	e8 d8 d6 ff ff       	call   8008f3 <_panic>
  80321b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321e:	8b 40 08             	mov    0x8(%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 11                	je     803236 <free_block+0x48f>
  803225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803228:	8b 40 08             	mov    0x8(%eax),%eax
  80322b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80322e:	8b 52 0c             	mov    0xc(%edx),%edx
  803231:	89 50 0c             	mov    %edx,0xc(%eax)
  803234:	eb 0b                	jmp    803241 <free_block+0x49a>
  803236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803239:	8b 40 0c             	mov    0xc(%eax),%eax
  80323c:	a3 44 51 90 00       	mov    %eax,0x905144
  803241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803244:	8b 40 0c             	mov    0xc(%eax),%eax
  803247:	85 c0                	test   %eax,%eax
  803249:	74 11                	je     80325c <free_block+0x4b5>
  80324b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324e:	8b 40 0c             	mov    0xc(%eax),%eax
  803251:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803254:	8b 52 08             	mov    0x8(%edx),%edx
  803257:	89 50 08             	mov    %edx,0x8(%eax)
  80325a:	eb 0b                	jmp    803267 <free_block+0x4c0>
  80325c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325f:	8b 40 08             	mov    0x8(%eax),%eax
  803262:	a3 40 51 90 00       	mov    %eax,0x905140
  803267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803274:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80327b:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803280:	48                   	dec    %eax
  803281:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803286:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80328d:	e9 1a 01 00 00       	jmp    8033ac <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  803292:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803296:	0f 84 df 00 00 00    	je     80337b <free_block+0x5d4>
  80329c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a0:	0f 84 d5 00 00 00    	je     80337b <free_block+0x5d4>
  8032a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a9:	8a 40 04             	mov    0x4(%eax),%al
  8032ac:	3c 01                	cmp    $0x1,%al
  8032ae:	0f 85 c7 00 00 00    	jne    80337b <free_block+0x5d4>
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	8a 40 04             	mov    0x4(%eax),%al
  8032ba:	84 c0                	test   %al,%al
  8032bc:	0f 85 b9 00 00 00    	jne    80337b <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  8032c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cc:	8b 10                	mov    (%eax),%edx
  8032ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	01 c2                	add    %eax,%edx
  8032d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d8:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8032da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8032e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8032ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032ee:	75 17                	jne    803307 <free_block+0x560>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 b2 43 80 00       	push   $0x8043b2
  8032f8:	68 6e 01 00 00       	push   $0x16e
  8032fd:	68 17 43 80 00       	push   $0x804317
  803302:	e8 ec d5 ff ff       	call   8008f3 <_panic>
  803307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330a:	8b 40 08             	mov    0x8(%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 11                	je     803322 <free_block+0x57b>
  803311:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803314:	8b 40 08             	mov    0x8(%eax),%eax
  803317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331a:	8b 52 0c             	mov    0xc(%edx),%edx
  80331d:	89 50 0c             	mov    %edx,0xc(%eax)
  803320:	eb 0b                	jmp    80332d <free_block+0x586>
  803322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803325:	8b 40 0c             	mov    0xc(%eax),%eax
  803328:	a3 44 51 90 00       	mov    %eax,0x905144
  80332d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803330:	8b 40 0c             	mov    0xc(%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 11                	je     803348 <free_block+0x5a1>
  803337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333a:	8b 40 0c             	mov    0xc(%eax),%eax
  80333d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803340:	8b 52 08             	mov    0x8(%edx),%edx
  803343:	89 50 08             	mov    %edx,0x8(%eax)
  803346:	eb 0b                	jmp    803353 <free_block+0x5ac>
  803348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334b:	8b 40 08             	mov    0x8(%eax),%eax
  80334e:	a3 40 51 90 00       	mov    %eax,0x905140
  803353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803356:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80335d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803360:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803367:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80336c:	48                   	dec    %eax
  80336d:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803372:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803379:	eb 31                	jmp    8033ac <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  80337b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80337f:	74 2b                	je     8033ac <free_block+0x605>
  803381:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803385:	74 25                	je     8033ac <free_block+0x605>
  803387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338a:	8a 40 04             	mov    0x4(%eax),%al
  80338d:	84 c0                	test   %al,%al
  80338f:	75 1b                	jne    8033ac <free_block+0x605>
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	8a 40 04             	mov    0x4(%eax),%al
  803397:	84 c0                	test   %al,%al
  803399:	75 11                	jne    8033ac <free_block+0x605>
	{
		block_pointer->is_free = 1;
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8033a2:	90                   	nop
  8033a3:	eb 07                	jmp    8033ac <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  8033a5:	90                   	nop
  8033a6:	eb 04                	jmp    8033ac <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  8033a8:	90                   	nop
  8033a9:	eb 01                	jmp    8033ac <free_block+0x605>
	if (va == NULL)
		return;
  8033ab:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  8033ac:	c9                   	leave  
  8033ad:	c3                   	ret    

008033ae <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  8033ae:	55                   	push   %ebp
  8033af:	89 e5                	mov    %esp,%ebp
  8033b1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  8033b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b8:	75 19                	jne    8033d3 <realloc_block_FF+0x25>
  8033ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033be:	74 13                	je     8033d3 <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  8033c0:	83 ec 0c             	sub    $0xc,%esp
  8033c3:	ff 75 0c             	pushl  0xc(%ebp)
  8033c6:	e8 0f f4 ff ff       	call   8027da <alloc_block_FF>
  8033cb:	83 c4 10             	add    $0x10,%esp
  8033ce:	e9 ea 03 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  8033d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033d7:	75 3b                	jne    803414 <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  8033d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033dd:	75 17                	jne    8033f6 <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  8033df:	83 ec 0c             	sub    $0xc,%esp
  8033e2:	6a 00                	push   $0x0
  8033e4:	e8 f1 f3 ff ff       	call   8027da <alloc_block_FF>
  8033e9:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f1:	e9 c7 03 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  8033f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fa:	74 18                	je     803414 <realloc_block_FF+0x66>
		{
			free_block(va);
  8033fc:	83 ec 0c             	sub    $0xc,%esp
  8033ff:	ff 75 08             	pushl  0x8(%ebp)
  803402:	e8 a0 f9 ff ff       	call   802da7 <free_block>
  803407:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
  80340f:	e9 a9 03 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  803414:	a1 40 51 90 00       	mov    0x905140,%eax
  803419:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341c:	e9 68 03 00 00       	jmp    803789 <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	83 e8 10             	sub    $0x10,%eax
  803427:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80342a:	0f 85 51 03 00 00    	jne    803781 <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	8b 55 0c             	mov    0xc(%ebp),%edx
  803438:	83 c2 10             	add    $0x10,%edx
  80343b:	39 d0                	cmp    %edx,%eax
  80343d:	75 08                	jne    803447 <realloc_block_FF+0x99>
			{
				return va;
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	e9 76 03 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	8b 00                	mov    (%eax),%eax
  80344c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80344f:	0f 83 45 02 00 00    	jae    80369a <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803458:	8b 40 08             	mov    0x8(%eax),%eax
  80345b:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  80345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803461:	8a 40 04             	mov    0x4(%eax),%al
  803464:	3c 01                	cmp    $0x1,%al
  803466:	0f 85 6b 01 00 00    	jne    8035d7 <realloc_block_FF+0x229>
  80346c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803470:	0f 84 61 01 00 00    	je     8035d7 <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  803476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803479:	8b 10                	mov    (%eax),%edx
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803483:	29 c1                	sub    %eax,%ecx
  803485:	89 c8                	mov    %ecx,%eax
  803487:	39 c2                	cmp    %eax,%edx
  803489:	0f 86 e3 00 00 00    	jbe    803572 <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  80348f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803492:	8b 10                	mov    (%eax),%edx
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	2b 45 0c             	sub    0xc(%ebp),%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	83 f8 0f             	cmp    $0xf,%eax
  8034a1:	0f 86 b5 00 00 00    	jbe    80355c <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  8034a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ad:	01 d0                	add    %edx,%eax
  8034af:	83 c0 10             	add    $0x10,%eax
  8034b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  8034b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  8034be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c1:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  8034c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c9:	74 06                	je     8034d1 <realloc_block_FF+0x123>
  8034cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034cf:	75 17                	jne    8034e8 <realloc_block_FF+0x13a>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 30 43 80 00       	push   $0x804330
  8034d9:	68 ae 01 00 00       	push   $0x1ae
  8034de:	68 17 43 80 00       	push   $0x804317
  8034e3:	e8 0b d4 ff ff       	call   8008f3 <_panic>
  8034e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034eb:	8b 50 08             	mov    0x8(%eax),%edx
  8034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f1:	89 50 08             	mov    %edx,0x8(%eax)
  8034f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f7:	8b 40 08             	mov    0x8(%eax),%eax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	74 0c                	je     80350a <realloc_block_FF+0x15c>
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 40 08             	mov    0x8(%eax),%eax
  803504:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803507:	89 50 0c             	mov    %edx,0xc(%eax)
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803510:	89 50 08             	mov    %edx,0x8(%eax)
  803513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803519:	89 50 0c             	mov    %edx,0xc(%eax)
  80351c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351f:	8b 40 08             	mov    0x8(%eax),%eax
  803522:	85 c0                	test   %eax,%eax
  803524:	75 08                	jne    80352e <realloc_block_FF+0x180>
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	a3 44 51 90 00       	mov    %eax,0x905144
  80352e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803533:	40                   	inc    %eax
  803534:	a3 4c 51 90 00       	mov    %eax,0x90514c
							next->size = 0;
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  803542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803545:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  803549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354c:	8d 50 10             	lea    0x10(%eax),%edx
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	89 10                	mov    %edx,(%eax)
							return va;
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	e9 61 02 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  80355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355f:	8d 50 10             	lea    0x10(%eax),%edx
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	83 c0 10             	add    $0x10,%eax
  80356d:	e9 4b 02 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  803572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803575:	8b 10                	mov    (%eax),%edx
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80357f:	29 c1                	sub    %eax,%ecx
  803581:	89 c8                	mov    %ecx,%eax
  803583:	39 c2                	cmp    %eax,%edx
  803585:	0f 83 f5 01 00 00    	jae    803780 <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  80358b:	83 ec 0c             	sub    $0xc,%esp
  80358e:	ff 75 0c             	pushl  0xc(%ebp)
  803591:	e8 44 f2 ff ff       	call   8027da <alloc_block_FF>
  803596:	83 c4 10             	add    $0x10,%esp
  803599:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  80359c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035a0:	74 2d                	je     8035cf <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	50                   	push   %eax
  8035ab:	ff 75 08             	pushl  0x8(%ebp)
  8035ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8035b1:	e8 a0 e0 ff ff       	call   801656 <memcpy>
  8035b6:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  8035b9:	83 ec 0c             	sub    $0xc,%esp
  8035bc:	ff 75 08             	pushl  0x8(%ebp)
  8035bf:	e8 e3 f7 ff ff       	call   802da7 <free_block>
  8035c4:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  8035c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ca:	e9 ee 01 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	e9 e6 01 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  8035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035da:	8a 40 04             	mov    0x4(%eax),%al
  8035dd:	3c 01                	cmp    $0x1,%al
  8035df:	75 59                	jne    80363a <realloc_block_FF+0x28c>
  8035e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e4:	8b 10                	mov    (%eax),%edx
  8035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e9:	8b 00                	mov    (%eax),%eax
  8035eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8035ee:	29 c1                	sub    %eax,%ecx
  8035f0:	89 c8                	mov    %ecx,%eax
  8035f2:	39 c2                	cmp    %eax,%edx
  8035f4:	75 44                	jne    80363a <realloc_block_FF+0x28c>
  8035f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035fa:	74 3e                	je     80363a <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  8035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ff:	8b 40 08             	mov    0x8(%eax),%eax
  803602:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803608:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80360b:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  80360e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803614:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803623:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362a:	8d 50 10             	lea    0x10(%eax),%edx
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	89 10                	mov    %edx,(%eax)
					return va;
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	e9 83 01 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  80363a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363d:	8a 40 04             	mov    0x4(%eax),%al
  803640:	84 c0                	test   %al,%al
  803642:	74 0a                	je     80364e <realloc_block_FF+0x2a0>
  803644:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803648:	0f 85 33 01 00 00    	jne    803781 <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  80364e:	83 ec 0c             	sub    $0xc,%esp
  803651:	ff 75 0c             	pushl  0xc(%ebp)
  803654:	e8 81 f1 ff ff       	call   8027da <alloc_block_FF>
  803659:	83 c4 10             	add    $0x10,%esp
  80365c:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  80365f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803663:	74 2d                	je     803692 <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	83 ec 04             	sub    $0x4,%esp
  80366d:	50                   	push   %eax
  80366e:	ff 75 08             	pushl  0x8(%ebp)
  803671:	ff 75 e0             	pushl  -0x20(%ebp)
  803674:	e8 dd df ff ff       	call   801656 <memcpy>
  803679:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  80367c:	83 ec 0c             	sub    $0xc,%esp
  80367f:	ff 75 08             	pushl  0x8(%ebp)
  803682:	e8 20 f7 ff ff       	call   802da7 <free_block>
  803687:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  80368a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368d:	e9 2b 01 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	e9 23 01 00 00       	jmp    8037bd <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  80369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369d:	8b 00                	mov    (%eax),%eax
  80369f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036a2:	0f 86 d9 00 00 00    	jbe    803781 <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  8036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036b0:	83 f8 0f             	cmp    $0xf,%eax
  8036b3:	0f 86 b4 00 00 00    	jbe    80376d <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  8036b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	83 c0 10             	add    $0x10,%eax
  8036c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036cf:	8d 50 f0             	lea    -0x10(%eax),%edx
  8036d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d5:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8036d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036db:	74 06                	je     8036e3 <realloc_block_FF+0x335>
  8036dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036e1:	75 17                	jne    8036fa <realloc_block_FF+0x34c>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 30 43 80 00       	push   $0x804330
  8036eb:	68 ed 01 00 00       	push   $0x1ed
  8036f0:	68 17 43 80 00       	push   $0x804317
  8036f5:	e8 f9 d1 ff ff       	call   8008f3 <_panic>
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	8b 50 08             	mov    0x8(%eax),%edx
  803700:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803703:	89 50 08             	mov    %edx,0x8(%eax)
  803706:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803709:	8b 40 08             	mov    0x8(%eax),%eax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	74 0c                	je     80371c <realloc_block_FF+0x36e>
  803710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803713:	8b 40 08             	mov    0x8(%eax),%eax
  803716:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803719:	89 50 0c             	mov    %edx,0xc(%eax)
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803722:	89 50 08             	mov    %edx,0x8(%eax)
  803725:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80372b:	89 50 0c             	mov    %edx,0xc(%eax)
  80372e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803731:	8b 40 08             	mov    0x8(%eax),%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	75 08                	jne    803740 <realloc_block_FF+0x392>
  803738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373b:	a3 44 51 90 00       	mov    %eax,0x905144
  803740:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803745:	40                   	inc    %eax
  803746:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  80374b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374e:	83 c0 10             	add    $0x10,%eax
  803751:	83 ec 0c             	sub    $0xc,%esp
  803754:	50                   	push   %eax
  803755:	e8 4d f6 ff ff       	call   802da7 <free_block>
  80375a:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  80375d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803760:	8d 50 10             	lea    0x10(%eax),%edx
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	89 10                	mov    %edx,(%eax)
					return va;
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	eb 50                	jmp    8037bd <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  80376d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803770:	8d 50 10             	lea    0x10(%eax),%edx
  803773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803776:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	83 c0 10             	add    $0x10,%eax
  80377e:	eb 3d                	jmp    8037bd <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  803780:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  803781:	a1 48 51 90 00       	mov    0x905148,%eax
  803786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378d:	74 08                	je     803797 <realloc_block_FF+0x3e9>
  80378f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803792:	8b 40 08             	mov    0x8(%eax),%eax
  803795:	eb 05                	jmp    80379c <realloc_block_FF+0x3ee>
  803797:	b8 00 00 00 00       	mov    $0x0,%eax
  80379c:	a3 48 51 90 00       	mov    %eax,0x905148
  8037a1:	a1 48 51 90 00       	mov    0x905148,%eax
  8037a6:	85 c0                	test   %eax,%eax
  8037a8:	0f 85 73 fc ff ff    	jne    803421 <realloc_block_FF+0x73>
  8037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b2:	0f 85 69 fc ff ff    	jne    803421 <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  8037b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037bd:	c9                   	leave  
  8037be:	c3                   	ret    
  8037bf:	90                   	nop

008037c0 <__udivdi3>:
  8037c0:	55                   	push   %ebp
  8037c1:	57                   	push   %edi
  8037c2:	56                   	push   %esi
  8037c3:	53                   	push   %ebx
  8037c4:	83 ec 1c             	sub    $0x1c,%esp
  8037c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037d7:	89 ca                	mov    %ecx,%edx
  8037d9:	89 f8                	mov    %edi,%eax
  8037db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037df:	85 f6                	test   %esi,%esi
  8037e1:	75 2d                	jne    803810 <__udivdi3+0x50>
  8037e3:	39 cf                	cmp    %ecx,%edi
  8037e5:	77 65                	ja     80384c <__udivdi3+0x8c>
  8037e7:	89 fd                	mov    %edi,%ebp
  8037e9:	85 ff                	test   %edi,%edi
  8037eb:	75 0b                	jne    8037f8 <__udivdi3+0x38>
  8037ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f2:	31 d2                	xor    %edx,%edx
  8037f4:	f7 f7                	div    %edi
  8037f6:	89 c5                	mov    %eax,%ebp
  8037f8:	31 d2                	xor    %edx,%edx
  8037fa:	89 c8                	mov    %ecx,%eax
  8037fc:	f7 f5                	div    %ebp
  8037fe:	89 c1                	mov    %eax,%ecx
  803800:	89 d8                	mov    %ebx,%eax
  803802:	f7 f5                	div    %ebp
  803804:	89 cf                	mov    %ecx,%edi
  803806:	89 fa                	mov    %edi,%edx
  803808:	83 c4 1c             	add    $0x1c,%esp
  80380b:	5b                   	pop    %ebx
  80380c:	5e                   	pop    %esi
  80380d:	5f                   	pop    %edi
  80380e:	5d                   	pop    %ebp
  80380f:	c3                   	ret    
  803810:	39 ce                	cmp    %ecx,%esi
  803812:	77 28                	ja     80383c <__udivdi3+0x7c>
  803814:	0f bd fe             	bsr    %esi,%edi
  803817:	83 f7 1f             	xor    $0x1f,%edi
  80381a:	75 40                	jne    80385c <__udivdi3+0x9c>
  80381c:	39 ce                	cmp    %ecx,%esi
  80381e:	72 0a                	jb     80382a <__udivdi3+0x6a>
  803820:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803824:	0f 87 9e 00 00 00    	ja     8038c8 <__udivdi3+0x108>
  80382a:	b8 01 00 00 00       	mov    $0x1,%eax
  80382f:	89 fa                	mov    %edi,%edx
  803831:	83 c4 1c             	add    $0x1c,%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5f                   	pop    %edi
  803837:	5d                   	pop    %ebp
  803838:	c3                   	ret    
  803839:	8d 76 00             	lea    0x0(%esi),%esi
  80383c:	31 ff                	xor    %edi,%edi
  80383e:	31 c0                	xor    %eax,%eax
  803840:	89 fa                	mov    %edi,%edx
  803842:	83 c4 1c             	add    $0x1c,%esp
  803845:	5b                   	pop    %ebx
  803846:	5e                   	pop    %esi
  803847:	5f                   	pop    %edi
  803848:	5d                   	pop    %ebp
  803849:	c3                   	ret    
  80384a:	66 90                	xchg   %ax,%ax
  80384c:	89 d8                	mov    %ebx,%eax
  80384e:	f7 f7                	div    %edi
  803850:	31 ff                	xor    %edi,%edi
  803852:	89 fa                	mov    %edi,%edx
  803854:	83 c4 1c             	add    $0x1c,%esp
  803857:	5b                   	pop    %ebx
  803858:	5e                   	pop    %esi
  803859:	5f                   	pop    %edi
  80385a:	5d                   	pop    %ebp
  80385b:	c3                   	ret    
  80385c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803861:	89 eb                	mov    %ebp,%ebx
  803863:	29 fb                	sub    %edi,%ebx
  803865:	89 f9                	mov    %edi,%ecx
  803867:	d3 e6                	shl    %cl,%esi
  803869:	89 c5                	mov    %eax,%ebp
  80386b:	88 d9                	mov    %bl,%cl
  80386d:	d3 ed                	shr    %cl,%ebp
  80386f:	89 e9                	mov    %ebp,%ecx
  803871:	09 f1                	or     %esi,%ecx
  803873:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803877:	89 f9                	mov    %edi,%ecx
  803879:	d3 e0                	shl    %cl,%eax
  80387b:	89 c5                	mov    %eax,%ebp
  80387d:	89 d6                	mov    %edx,%esi
  80387f:	88 d9                	mov    %bl,%cl
  803881:	d3 ee                	shr    %cl,%esi
  803883:	89 f9                	mov    %edi,%ecx
  803885:	d3 e2                	shl    %cl,%edx
  803887:	8b 44 24 08          	mov    0x8(%esp),%eax
  80388b:	88 d9                	mov    %bl,%cl
  80388d:	d3 e8                	shr    %cl,%eax
  80388f:	09 c2                	or     %eax,%edx
  803891:	89 d0                	mov    %edx,%eax
  803893:	89 f2                	mov    %esi,%edx
  803895:	f7 74 24 0c          	divl   0xc(%esp)
  803899:	89 d6                	mov    %edx,%esi
  80389b:	89 c3                	mov    %eax,%ebx
  80389d:	f7 e5                	mul    %ebp
  80389f:	39 d6                	cmp    %edx,%esi
  8038a1:	72 19                	jb     8038bc <__udivdi3+0xfc>
  8038a3:	74 0b                	je     8038b0 <__udivdi3+0xf0>
  8038a5:	89 d8                	mov    %ebx,%eax
  8038a7:	31 ff                	xor    %edi,%edi
  8038a9:	e9 58 ff ff ff       	jmp    803806 <__udivdi3+0x46>
  8038ae:	66 90                	xchg   %ax,%ax
  8038b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038b4:	89 f9                	mov    %edi,%ecx
  8038b6:	d3 e2                	shl    %cl,%edx
  8038b8:	39 c2                	cmp    %eax,%edx
  8038ba:	73 e9                	jae    8038a5 <__udivdi3+0xe5>
  8038bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038bf:	31 ff                	xor    %edi,%edi
  8038c1:	e9 40 ff ff ff       	jmp    803806 <__udivdi3+0x46>
  8038c6:	66 90                	xchg   %ax,%ax
  8038c8:	31 c0                	xor    %eax,%eax
  8038ca:	e9 37 ff ff ff       	jmp    803806 <__udivdi3+0x46>
  8038cf:	90                   	nop

008038d0 <__umoddi3>:
  8038d0:	55                   	push   %ebp
  8038d1:	57                   	push   %edi
  8038d2:	56                   	push   %esi
  8038d3:	53                   	push   %ebx
  8038d4:	83 ec 1c             	sub    $0x1c,%esp
  8038d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ef:	89 f3                	mov    %esi,%ebx
  8038f1:	89 fa                	mov    %edi,%edx
  8038f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038f7:	89 34 24             	mov    %esi,(%esp)
  8038fa:	85 c0                	test   %eax,%eax
  8038fc:	75 1a                	jne    803918 <__umoddi3+0x48>
  8038fe:	39 f7                	cmp    %esi,%edi
  803900:	0f 86 a2 00 00 00    	jbe    8039a8 <__umoddi3+0xd8>
  803906:	89 c8                	mov    %ecx,%eax
  803908:	89 f2                	mov    %esi,%edx
  80390a:	f7 f7                	div    %edi
  80390c:	89 d0                	mov    %edx,%eax
  80390e:	31 d2                	xor    %edx,%edx
  803910:	83 c4 1c             	add    $0x1c,%esp
  803913:	5b                   	pop    %ebx
  803914:	5e                   	pop    %esi
  803915:	5f                   	pop    %edi
  803916:	5d                   	pop    %ebp
  803917:	c3                   	ret    
  803918:	39 f0                	cmp    %esi,%eax
  80391a:	0f 87 ac 00 00 00    	ja     8039cc <__umoddi3+0xfc>
  803920:	0f bd e8             	bsr    %eax,%ebp
  803923:	83 f5 1f             	xor    $0x1f,%ebp
  803926:	0f 84 ac 00 00 00    	je     8039d8 <__umoddi3+0x108>
  80392c:	bf 20 00 00 00       	mov    $0x20,%edi
  803931:	29 ef                	sub    %ebp,%edi
  803933:	89 fe                	mov    %edi,%esi
  803935:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803939:	89 e9                	mov    %ebp,%ecx
  80393b:	d3 e0                	shl    %cl,%eax
  80393d:	89 d7                	mov    %edx,%edi
  80393f:	89 f1                	mov    %esi,%ecx
  803941:	d3 ef                	shr    %cl,%edi
  803943:	09 c7                	or     %eax,%edi
  803945:	89 e9                	mov    %ebp,%ecx
  803947:	d3 e2                	shl    %cl,%edx
  803949:	89 14 24             	mov    %edx,(%esp)
  80394c:	89 d8                	mov    %ebx,%eax
  80394e:	d3 e0                	shl    %cl,%eax
  803950:	89 c2                	mov    %eax,%edx
  803952:	8b 44 24 08          	mov    0x8(%esp),%eax
  803956:	d3 e0                	shl    %cl,%eax
  803958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803960:	89 f1                	mov    %esi,%ecx
  803962:	d3 e8                	shr    %cl,%eax
  803964:	09 d0                	or     %edx,%eax
  803966:	d3 eb                	shr    %cl,%ebx
  803968:	89 da                	mov    %ebx,%edx
  80396a:	f7 f7                	div    %edi
  80396c:	89 d3                	mov    %edx,%ebx
  80396e:	f7 24 24             	mull   (%esp)
  803971:	89 c6                	mov    %eax,%esi
  803973:	89 d1                	mov    %edx,%ecx
  803975:	39 d3                	cmp    %edx,%ebx
  803977:	0f 82 87 00 00 00    	jb     803a04 <__umoddi3+0x134>
  80397d:	0f 84 91 00 00 00    	je     803a14 <__umoddi3+0x144>
  803983:	8b 54 24 04          	mov    0x4(%esp),%edx
  803987:	29 f2                	sub    %esi,%edx
  803989:	19 cb                	sbb    %ecx,%ebx
  80398b:	89 d8                	mov    %ebx,%eax
  80398d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803991:	d3 e0                	shl    %cl,%eax
  803993:	89 e9                	mov    %ebp,%ecx
  803995:	d3 ea                	shr    %cl,%edx
  803997:	09 d0                	or     %edx,%eax
  803999:	89 e9                	mov    %ebp,%ecx
  80399b:	d3 eb                	shr    %cl,%ebx
  80399d:	89 da                	mov    %ebx,%edx
  80399f:	83 c4 1c             	add    $0x1c,%esp
  8039a2:	5b                   	pop    %ebx
  8039a3:	5e                   	pop    %esi
  8039a4:	5f                   	pop    %edi
  8039a5:	5d                   	pop    %ebp
  8039a6:	c3                   	ret    
  8039a7:	90                   	nop
  8039a8:	89 fd                	mov    %edi,%ebp
  8039aa:	85 ff                	test   %edi,%edi
  8039ac:	75 0b                	jne    8039b9 <__umoddi3+0xe9>
  8039ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b3:	31 d2                	xor    %edx,%edx
  8039b5:	f7 f7                	div    %edi
  8039b7:	89 c5                	mov    %eax,%ebp
  8039b9:	89 f0                	mov    %esi,%eax
  8039bb:	31 d2                	xor    %edx,%edx
  8039bd:	f7 f5                	div    %ebp
  8039bf:	89 c8                	mov    %ecx,%eax
  8039c1:	f7 f5                	div    %ebp
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	e9 44 ff ff ff       	jmp    80390e <__umoddi3+0x3e>
  8039ca:	66 90                	xchg   %ax,%ax
  8039cc:	89 c8                	mov    %ecx,%eax
  8039ce:	89 f2                	mov    %esi,%edx
  8039d0:	83 c4 1c             	add    $0x1c,%esp
  8039d3:	5b                   	pop    %ebx
  8039d4:	5e                   	pop    %esi
  8039d5:	5f                   	pop    %edi
  8039d6:	5d                   	pop    %ebp
  8039d7:	c3                   	ret    
  8039d8:	3b 04 24             	cmp    (%esp),%eax
  8039db:	72 06                	jb     8039e3 <__umoddi3+0x113>
  8039dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039e1:	77 0f                	ja     8039f2 <__umoddi3+0x122>
  8039e3:	89 f2                	mov    %esi,%edx
  8039e5:	29 f9                	sub    %edi,%ecx
  8039e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039eb:	89 14 24             	mov    %edx,(%esp)
  8039ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039f6:	8b 14 24             	mov    (%esp),%edx
  8039f9:	83 c4 1c             	add    $0x1c,%esp
  8039fc:	5b                   	pop    %ebx
  8039fd:	5e                   	pop    %esi
  8039fe:	5f                   	pop    %edi
  8039ff:	5d                   	pop    %ebp
  803a00:	c3                   	ret    
  803a01:	8d 76 00             	lea    0x0(%esi),%esi
  803a04:	2b 04 24             	sub    (%esp),%eax
  803a07:	19 fa                	sbb    %edi,%edx
  803a09:	89 d1                	mov    %edx,%ecx
  803a0b:	89 c6                	mov    %eax,%esi
  803a0d:	e9 71 ff ff ff       	jmp    803983 <__umoddi3+0xb3>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a18:	72 ea                	jb     803a04 <__umoddi3+0x134>
  803a1a:	89 d9                	mov    %ebx,%ecx
  803a1c:	e9 62 ff ff ff       	jmp    803983 <__umoddi3+0xb3>
