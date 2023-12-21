
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 28 20 00 00       	call   80206e <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 39 80 00       	push   $0x8039a0
  80004e:	e8 33 0b 00 00       	call   800b86 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 39 80 00       	push   $0x8039a2
  80005e:	e8 23 0b 00 00       	call   800b86 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 39 80 00       	push   $0x8039b8
  80006e:	e8 13 0b 00 00       	call   800b86 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 39 80 00       	push   $0x8039a2
  80007e:	e8 03 0b 00 00       	call   800b86 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 39 80 00       	push   $0x8039a0
  80008e:	e8 f3 0a 00 00       	call   800b86 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 39 80 00       	push   $0x8039d0
  8000a5:	e8 5e 11 00 00       	call   801208 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 ae 16 00 00       	call   80176e <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 e2 1a 00 00       	call   801bb7 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f0 39 80 00       	push   $0x8039f0
  8000e3:	e8 9e 0a 00 00       	call   800b86 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 3a 80 00       	push   $0x803a12
  8000f3:	e8 8e 0a 00 00       	call   800b86 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 3a 80 00       	push   $0x803a20
  800103:	e8 7e 0a 00 00       	call   800b86 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 3a 80 00       	push   $0x803a2f
  800113:	e8 6e 0a 00 00       	call   800b86 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 3a 80 00       	push   $0x803a3f
  800123:	e8 5e 0a 00 00       	call   800b86 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 21 1f 00 00       	call   802088 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 92 1e 00 00       	call   80206e <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 3a 80 00       	push   $0x803a48
  8001e4:	e8 9d 09 00 00       	call   800b86 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 97 1e 00 00       	call   802088 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 7c 3a 80 00       	push   $0x803a7c
  800213:	6a 4a                	push   $0x4a
  800215:	68 9e 3a 80 00       	push   $0x803a9e
  80021a:	e8 aa 06 00 00       	call   8008c9 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 4a 1e 00 00       	call   80206e <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 b8 3a 80 00       	push   $0x803ab8
  80022c:	e8 55 09 00 00       	call   800b86 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ec 3a 80 00       	push   $0x803aec
  80023c:	e8 45 09 00 00       	call   800b86 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 20 3b 80 00       	push   $0x803b20
  80024c:	e8 35 09 00 00       	call   800b86 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 2f 1e 00 00       	call   802088 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 10 1e 00 00       	call   80206e <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 52 3b 80 00       	push   $0x803b52
  80026c:	e8 15 09 00 00       	call   800b86 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 d1 1d 00 00       	call   802088 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 a0 39 80 00       	push   $0x8039a0
  80044b:	e8 36 07 00 00       	call   800b86 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 70 3b 80 00       	push   $0x803b70
  80046d:	e8 14 07 00 00       	call   800b86 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 75 3b 80 00       	push   $0x803b75
  80049b:	e8 e6 06 00 00       	call   800b86 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 76 16 00 00       	call   801bb7 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 61 16 00 00       	call   801bb7 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 8e 19 00 00       	call   8020a2 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 49 19 00 00       	call   80206e <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 6a 19 00 00       	call   8020a2 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 48 19 00 00       	call   802088 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 e7 17 00 00       	call   801f3e <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 fe 18 00 00       	call   80206e <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 c0 17 00 00       	call   801f3e <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 fc 18 00 00       	call   802088 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 bb 1a 00 00       	call   802261 <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	01 c0                	add    %eax,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	c1 e0 06             	shl    $0x6,%eax
  8007b5:	29 d0                	sub    %edx,%eax
  8007b7:	c1 e0 03             	shl    $0x3,%eax
  8007ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007bf:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c9:	8a 40 68             	mov    0x68(%eax),%al
  8007cc:	84 c0                	test   %al,%al
  8007ce:	74 0d                	je     8007dd <libmain+0x42>
		binaryname = myEnv->prog_name;
  8007d0:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d5:	83 c0 68             	add    $0x68,%eax
  8007d8:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007e1:	7e 0a                	jle    8007ed <libmain+0x52>
		binaryname = argv[0];
  8007e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 3d f8 ff ff       	call   800038 <_main>
  8007fb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007fe:	e8 6b 18 00 00       	call   80206e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800803:	83 ec 0c             	sub    $0xc,%esp
  800806:	68 94 3b 80 00       	push   $0x803b94
  80080b:	e8 76 03 00 00       	call   800b86 <cprintf>
  800810:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800813:	a1 24 50 80 00       	mov    0x805024,%eax
  800818:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  80081e:	a1 24 50 80 00       	mov    0x805024,%eax
  800823:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	52                   	push   %edx
  80082d:	50                   	push   %eax
  80082e:	68 bc 3b 80 00       	push   $0x803bbc
  800833:	e8 4e 03 00 00       	call   800b86 <cprintf>
  800838:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80083b:	a1 24 50 80 00       	mov    0x805024,%eax
  800840:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800846:	a1 24 50 80 00       	mov    0x805024,%eax
  80084b:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800851:	a1 24 50 80 00       	mov    0x805024,%eax
  800856:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80085c:	51                   	push   %ecx
  80085d:	52                   	push   %edx
  80085e:	50                   	push   %eax
  80085f:	68 e4 3b 80 00       	push   $0x803be4
  800864:	e8 1d 03 00 00       	call   800b86 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	50                   	push   %eax
  80087b:	68 3c 3c 80 00       	push   $0x803c3c
  800880:	e8 01 03 00 00       	call   800b86 <cprintf>
  800885:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800888:	83 ec 0c             	sub    $0xc,%esp
  80088b:	68 94 3b 80 00       	push   $0x803b94
  800890:	e8 f1 02 00 00       	call   800b86 <cprintf>
  800895:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800898:	e8 eb 17 00 00       	call   802088 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80089d:	e8 19 00 00 00       	call   8008bb <exit>
}
  8008a2:	90                   	nop
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ab:	83 ec 0c             	sub    $0xc,%esp
  8008ae:	6a 00                	push   $0x0
  8008b0:	e8 78 19 00 00       	call   80222d <sys_destroy_env>
  8008b5:	83 c4 10             	add    $0x10,%esp
}
  8008b8:	90                   	nop
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <exit>:

void
exit(void)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008c1:	e8 cd 19 00 00       	call   802293 <sys_exit_env>
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008d8:	a1 18 51 80 00       	mov    0x805118,%eax
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	74 16                	je     8008f7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008e1:	a1 18 51 80 00       	mov    0x805118,%eax
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	50                   	push   %eax
  8008ea:	68 50 3c 80 00       	push   $0x803c50
  8008ef:	e8 92 02 00 00       	call   800b86 <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008f7:	a1 00 50 80 00       	mov    0x805000,%eax
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	ff 75 08             	pushl  0x8(%ebp)
  800902:	50                   	push   %eax
  800903:	68 55 3c 80 00       	push   $0x803c55
  800908:	e8 79 02 00 00       	call   800b86 <cprintf>
  80090d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800910:	8b 45 10             	mov    0x10(%ebp),%eax
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 f4             	pushl  -0xc(%ebp)
  800919:	50                   	push   %eax
  80091a:	e8 fc 01 00 00       	call   800b1b <vcprintf>
  80091f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	6a 00                	push   $0x0
  800927:	68 71 3c 80 00       	push   $0x803c71
  80092c:	e8 ea 01 00 00       	call   800b1b <vcprintf>
  800931:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800934:	e8 82 ff ff ff       	call   8008bb <exit>

	// should not return here
	while (1) ;
  800939:	eb fe                	jmp    800939 <_panic+0x70>

0080093b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800941:	a1 24 50 80 00       	mov    0x805024,%eax
  800946:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	39 c2                	cmp    %eax,%edx
  800951:	74 14                	je     800967 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800953:	83 ec 04             	sub    $0x4,%esp
  800956:	68 74 3c 80 00       	push   $0x803c74
  80095b:	6a 26                	push   $0x26
  80095d:	68 c0 3c 80 00       	push   $0x803cc0
  800962:	e8 62 ff ff ff       	call   8008c9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80096e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800975:	e9 c5 00 00 00       	jmp    800a3f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80097a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	01 d0                	add    %edx,%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	85 c0                	test   %eax,%eax
  80098d:	75 08                	jne    800997 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80098f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800992:	e9 a5 00 00 00       	jmp    800a3c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800997:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80099e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009a5:	eb 69                	jmp    800a10 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ac:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8009b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	01 c0                	add    %eax,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	c1 e0 03             	shl    $0x3,%eax
  8009be:	01 c8                	add    %ecx,%eax
  8009c0:	8a 40 04             	mov    0x4(%eax),%al
  8009c3:	84 c0                	test   %al,%al
  8009c5:	75 46                	jne    800a0d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009c7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009cc:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8009d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d5:	89 d0                	mov    %edx,%eax
  8009d7:	01 c0                	add    %eax,%eax
  8009d9:	01 d0                	add    %edx,%eax
  8009db:	c1 e0 03             	shl    $0x3,%eax
  8009de:	01 c8                	add    %ecx,%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ed:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	01 c8                	add    %ecx,%eax
  8009fe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a00:	39 c2                	cmp    %eax,%edx
  800a02:	75 09                	jne    800a0d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a04:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a0b:	eb 15                	jmp    800a22 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a0d:	ff 45 e8             	incl   -0x18(%ebp)
  800a10:	a1 24 50 80 00       	mov    0x805024,%eax
  800a15:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a1e:	39 c2                	cmp    %eax,%edx
  800a20:	77 85                	ja     8009a7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a26:	75 14                	jne    800a3c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	68 cc 3c 80 00       	push   $0x803ccc
  800a30:	6a 3a                	push   $0x3a
  800a32:	68 c0 3c 80 00       	push   $0x803cc0
  800a37:	e8 8d fe ff ff       	call   8008c9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a3c:	ff 45 f0             	incl   -0x10(%ebp)
  800a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a42:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a45:	0f 8c 2f ff ff ff    	jl     80097a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a59:	eb 26                	jmp    800a81 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a5b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a60:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800a66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a69:	89 d0                	mov    %edx,%eax
  800a6b:	01 c0                	add    %eax,%eax
  800a6d:	01 d0                	add    %edx,%eax
  800a6f:	c1 e0 03             	shl    $0x3,%eax
  800a72:	01 c8                	add    %ecx,%eax
  800a74:	8a 40 04             	mov    0x4(%eax),%al
  800a77:	3c 01                	cmp    $0x1,%al
  800a79:	75 03                	jne    800a7e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a7b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a7e:	ff 45 e0             	incl   -0x20(%ebp)
  800a81:	a1 24 50 80 00       	mov    0x805024,%eax
  800a86:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	77 c8                	ja     800a5b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a96:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a99:	74 14                	je     800aaf <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a9b:	83 ec 04             	sub    $0x4,%esp
  800a9e:	68 20 3d 80 00       	push   $0x803d20
  800aa3:	6a 44                	push   $0x44
  800aa5:	68 c0 3c 80 00       	push   $0x803cc0
  800aaa:	e8 1a fe ff ff       	call   8008c9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800aaf:	90                   	nop
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	89 0a                	mov    %ecx,(%edx)
  800ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac8:	88 d1                	mov    %dl,%cl
  800aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800adb:	75 2c                	jne    800b09 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800add:	a0 28 50 80 00       	mov    0x805028,%al
  800ae2:	0f b6 c0             	movzbl %al,%eax
  800ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae8:	8b 12                	mov    (%edx),%edx
  800aea:	89 d1                	mov    %edx,%ecx
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aef:	83 c2 08             	add    $0x8,%edx
  800af2:	83 ec 04             	sub    $0x4,%esp
  800af5:	50                   	push   %eax
  800af6:	51                   	push   %ecx
  800af7:	52                   	push   %edx
  800af8:	e8 18 14 00 00       	call   801f15 <sys_cputs>
  800afd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	8b 40 04             	mov    0x4(%eax),%eax
  800b0f:	8d 50 01             	lea    0x1(%eax),%edx
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b18:	90                   	nop
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b24:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b2b:	00 00 00 
	b.cnt = 0;
  800b2e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b35:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b44:	50                   	push   %eax
  800b45:	68 b2 0a 80 00       	push   $0x800ab2
  800b4a:	e8 11 02 00 00       	call   800d60 <vprintfmt>
  800b4f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b52:	a0 28 50 80 00       	mov    0x805028,%al
  800b57:	0f b6 c0             	movzbl %al,%eax
  800b5a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b60:	83 ec 04             	sub    $0x4,%esp
  800b63:	50                   	push   %eax
  800b64:	52                   	push   %edx
  800b65:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b6b:	83 c0 08             	add    $0x8,%eax
  800b6e:	50                   	push   %eax
  800b6f:	e8 a1 13 00 00       	call   801f15 <sys_cputs>
  800b74:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b77:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b7e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b8c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b93:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba2:	50                   	push   %eax
  800ba3:	e8 73 ff ff ff       	call   800b1b <vcprintf>
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bb9:	e8 b0 14 00 00       	call   80206e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bbe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcd:	50                   	push   %eax
  800bce:	e8 48 ff ff ff       	call   800b1b <vcprintf>
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bd9:	e8 aa 14 00 00       	call   802088 <sys_enable_interrupt>
	return cnt;
  800bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	53                   	push   %ebx
  800be7:	83 ec 14             	sub    $0x14,%esp
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bf6:	8b 45 18             	mov    0x18(%ebp),%eax
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c01:	77 55                	ja     800c58 <printnum+0x75>
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	72 05                	jb     800c0d <printnum+0x2a>
  800c08:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0b:	77 4b                	ja     800c58 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c0d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c10:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c13:	8b 45 18             	mov    0x18(%ebp),%eax
  800c16:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c20:	ff 75 f0             	pushl  -0x10(%ebp)
  800c23:	e8 f8 2a 00 00       	call   803720 <__udivdi3>
  800c28:	83 c4 10             	add    $0x10,%esp
  800c2b:	83 ec 04             	sub    $0x4,%esp
  800c2e:	ff 75 20             	pushl  0x20(%ebp)
  800c31:	53                   	push   %ebx
  800c32:	ff 75 18             	pushl  0x18(%ebp)
  800c35:	52                   	push   %edx
  800c36:	50                   	push   %eax
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	ff 75 08             	pushl  0x8(%ebp)
  800c3d:	e8 a1 ff ff ff       	call   800be3 <printnum>
  800c42:	83 c4 20             	add    $0x20,%esp
  800c45:	eb 1a                	jmp    800c61 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	ff 75 20             	pushl  0x20(%ebp)
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	ff d0                	call   *%eax
  800c55:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c58:	ff 4d 1c             	decl   0x1c(%ebp)
  800c5b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c5f:	7f e6                	jg     800c47 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c61:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6f:	53                   	push   %ebx
  800c70:	51                   	push   %ecx
  800c71:	52                   	push   %edx
  800c72:	50                   	push   %eax
  800c73:	e8 b8 2b 00 00       	call   803830 <__umoddi3>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	05 94 3f 80 00       	add    $0x803f94,%eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	0f be c0             	movsbl %al,%eax
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	50                   	push   %eax
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
}
  800c94:	90                   	nop
  800c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c9d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca1:	7e 1c                	jle    800cbf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	8d 50 08             	lea    0x8(%eax),%edx
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	89 10                	mov    %edx,(%eax)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	83 e8 08             	sub    $0x8,%eax
  800cb8:	8b 50 04             	mov    0x4(%eax),%edx
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	eb 40                	jmp    800cff <getuint+0x65>
	else if (lflag)
  800cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc3:	74 1e                	je     800ce3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	8d 50 04             	lea    0x4(%eax),%edx
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	89 10                	mov    %edx,(%eax)
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	83 e8 04             	sub    $0x4,%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce1:	eb 1c                	jmp    800cff <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8b 00                	mov    (%eax),%eax
  800ce8:	8d 50 04             	lea    0x4(%eax),%edx
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	89 10                	mov    %edx,(%eax)
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8b 00                	mov    (%eax),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d04:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d08:	7e 1c                	jle    800d26 <getint+0x25>
		return va_arg(*ap, long long);
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	8d 50 08             	lea    0x8(%eax),%edx
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	89 10                	mov    %edx,(%eax)
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8b 00                	mov    (%eax),%eax
  800d1c:	83 e8 08             	sub    $0x8,%eax
  800d1f:	8b 50 04             	mov    0x4(%eax),%edx
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	eb 38                	jmp    800d5e <getint+0x5d>
	else if (lflag)
  800d26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2a:	74 1a                	je     800d46 <getint+0x45>
		return va_arg(*ap, long);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	8d 50 04             	lea    0x4(%eax),%edx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 10                	mov    %edx,(%eax)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 e8 04             	sub    $0x4,%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	99                   	cltd   
  800d44:	eb 18                	jmp    800d5e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 50 04             	lea    0x4(%eax),%edx
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	89 10                	mov    %edx,(%eax)
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	83 e8 04             	sub    $0x4,%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	99                   	cltd   
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d68:	eb 17                	jmp    800d81 <vprintfmt+0x21>
			if (ch == '\0')
  800d6a:	85 db                	test   %ebx,%ebx
  800d6c:	0f 84 af 03 00 00    	je     801121 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 0c             	pushl  0xc(%ebp)
  800d78:	53                   	push   %ebx
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	0f b6 d8             	movzbl %al,%ebx
  800d8f:	83 fb 25             	cmp    $0x25,%ebx
  800d92:	75 d6                	jne    800d6a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d94:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d98:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d9f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800da6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f b6 d8             	movzbl %al,%ebx
  800dc2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dc5:	83 f8 55             	cmp    $0x55,%eax
  800dc8:	0f 87 2b 03 00 00    	ja     8010f9 <vprintfmt+0x399>
  800dce:	8b 04 85 b8 3f 80 00 	mov    0x803fb8(,%eax,4),%eax
  800dd5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800dd7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ddb:	eb d7                	jmp    800db4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ddd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de1:	eb d1                	jmp    800db4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ded:	89 d0                	mov    %edx,%eax
  800def:	c1 e0 02             	shl    $0x2,%eax
  800df2:	01 d0                	add    %edx,%eax
  800df4:	01 c0                	add    %eax,%eax
  800df6:	01 d8                	add    %ebx,%eax
  800df8:	83 e8 30             	sub    $0x30,%eax
  800dfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e06:	83 fb 2f             	cmp    $0x2f,%ebx
  800e09:	7e 3e                	jle    800e49 <vprintfmt+0xe9>
  800e0b:	83 fb 39             	cmp    $0x39,%ebx
  800e0e:	7f 39                	jg     800e49 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e10:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e13:	eb d5                	jmp    800dea <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e15:	8b 45 14             	mov    0x14(%ebp),%eax
  800e18:	83 c0 04             	add    $0x4,%eax
  800e1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e21:	83 e8 04             	sub    $0x4,%eax
  800e24:	8b 00                	mov    (%eax),%eax
  800e26:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e29:	eb 1f                	jmp    800e4a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2f:	79 83                	jns    800db4 <vprintfmt+0x54>
				width = 0;
  800e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e38:	e9 77 ff ff ff       	jmp    800db4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e3d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e44:	e9 6b ff ff ff       	jmp    800db4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e49:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e4e:	0f 89 60 ff ff ff    	jns    800db4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e61:	e9 4e ff ff ff       	jmp    800db4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e66:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e69:	e9 46 ff ff ff       	jmp    800db4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e71:	83 c0 04             	add    $0x4,%eax
  800e74:	89 45 14             	mov    %eax,0x14(%ebp)
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	83 e8 04             	sub    $0x4,%eax
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	50                   	push   %eax
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	ff d0                	call   *%eax
  800e8b:	83 c4 10             	add    $0x10,%esp
			break;
  800e8e:	e9 89 02 00 00       	jmp    80111c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e93:	8b 45 14             	mov    0x14(%ebp),%eax
  800e96:	83 c0 04             	add    $0x4,%eax
  800e99:	89 45 14             	mov    %eax,0x14(%ebp)
  800e9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9f:	83 e8 04             	sub    $0x4,%eax
  800ea2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea4:	85 db                	test   %ebx,%ebx
  800ea6:	79 02                	jns    800eaa <vprintfmt+0x14a>
				err = -err;
  800ea8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaa:	83 fb 64             	cmp    $0x64,%ebx
  800ead:	7f 0b                	jg     800eba <vprintfmt+0x15a>
  800eaf:	8b 34 9d 00 3e 80 00 	mov    0x803e00(,%ebx,4),%esi
  800eb6:	85 f6                	test   %esi,%esi
  800eb8:	75 19                	jne    800ed3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800eba:	53                   	push   %ebx
  800ebb:	68 a5 3f 80 00       	push   $0x803fa5
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	ff 75 08             	pushl  0x8(%ebp)
  800ec6:	e8 5e 02 00 00       	call   801129 <printfmt>
  800ecb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ece:	e9 49 02 00 00       	jmp    80111c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed3:	56                   	push   %esi
  800ed4:	68 ae 3f 80 00       	push   $0x803fae
  800ed9:	ff 75 0c             	pushl  0xc(%ebp)
  800edc:	ff 75 08             	pushl  0x8(%ebp)
  800edf:	e8 45 02 00 00       	call   801129 <printfmt>
  800ee4:	83 c4 10             	add    $0x10,%esp
			break;
  800ee7:	e9 30 02 00 00       	jmp    80111c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eec:	8b 45 14             	mov    0x14(%ebp),%eax
  800eef:	83 c0 04             	add    $0x4,%eax
  800ef2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef8:	83 e8 04             	sub    $0x4,%eax
  800efb:	8b 30                	mov    (%eax),%esi
  800efd:	85 f6                	test   %esi,%esi
  800eff:	75 05                	jne    800f06 <vprintfmt+0x1a6>
				p = "(null)";
  800f01:	be b1 3f 80 00       	mov    $0x803fb1,%esi
			if (width > 0 && padc != '-')
  800f06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0a:	7e 6d                	jle    800f79 <vprintfmt+0x219>
  800f0c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f10:	74 67                	je     800f79 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	50                   	push   %eax
  800f19:	56                   	push   %esi
  800f1a:	e8 12 05 00 00       	call   801431 <strnlen>
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f25:	eb 16                	jmp    800f3d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f27:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 0c             	pushl  0xc(%ebp)
  800f31:	50                   	push   %eax
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	ff d0                	call   *%eax
  800f37:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3a:	ff 4d e4             	decl   -0x1c(%ebp)
  800f3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f41:	7f e4                	jg     800f27 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f43:	eb 34                	jmp    800f79 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f49:	74 1c                	je     800f67 <vprintfmt+0x207>
  800f4b:	83 fb 1f             	cmp    $0x1f,%ebx
  800f4e:	7e 05                	jle    800f55 <vprintfmt+0x1f5>
  800f50:	83 fb 7e             	cmp    $0x7e,%ebx
  800f53:	7e 12                	jle    800f67 <vprintfmt+0x207>
					putch('?', putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	6a 3f                	push   $0x3f
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	ff d0                	call   *%eax
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	eb 0f                	jmp    800f76 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	ff 75 0c             	pushl  0xc(%ebp)
  800f6d:	53                   	push   %ebx
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	ff d0                	call   *%eax
  800f73:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f76:	ff 4d e4             	decl   -0x1c(%ebp)
  800f79:	89 f0                	mov    %esi,%eax
  800f7b:	8d 70 01             	lea    0x1(%eax),%esi
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f be d8             	movsbl %al,%ebx
  800f83:	85 db                	test   %ebx,%ebx
  800f85:	74 24                	je     800fab <vprintfmt+0x24b>
  800f87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f8b:	78 b8                	js     800f45 <vprintfmt+0x1e5>
  800f8d:	ff 4d e0             	decl   -0x20(%ebp)
  800f90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f94:	79 af                	jns    800f45 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f96:	eb 13                	jmp    800fab <vprintfmt+0x24b>
				putch(' ', putdat);
  800f98:	83 ec 08             	sub    $0x8,%esp
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	6a 20                	push   $0x20
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	ff d0                	call   *%eax
  800fa5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fa8:	ff 4d e4             	decl   -0x1c(%ebp)
  800fab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800faf:	7f e7                	jg     800f98 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb1:	e9 66 01 00 00       	jmp    80111c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fb6:	83 ec 08             	sub    $0x8,%esp
  800fb9:	ff 75 e8             	pushl  -0x18(%ebp)
  800fbc:	8d 45 14             	lea    0x14(%ebp),%eax
  800fbf:	50                   	push   %eax
  800fc0:	e8 3c fd ff ff       	call   800d01 <getint>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd4:	85 d2                	test   %edx,%edx
  800fd6:	79 23                	jns    800ffb <vprintfmt+0x29b>
				putch('-', putdat);
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 0c             	pushl  0xc(%ebp)
  800fde:	6a 2d                	push   $0x2d
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	ff d0                	call   *%eax
  800fe5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fee:	f7 d8                	neg    %eax
  800ff0:	83 d2 00             	adc    $0x0,%edx
  800ff3:	f7 da                	neg    %edx
  800ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ffb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801002:	e9 bc 00 00 00       	jmp    8010c3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 e8             	pushl  -0x18(%ebp)
  80100d:	8d 45 14             	lea    0x14(%ebp),%eax
  801010:	50                   	push   %eax
  801011:	e8 84 fc ff ff       	call   800c9a <getuint>
  801016:	83 c4 10             	add    $0x10,%esp
  801019:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80101f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801026:	e9 98 00 00 00       	jmp    8010c3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 58                	push   $0x58
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 58                	push   $0x58
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	ff 75 0c             	pushl  0xc(%ebp)
  801051:	6a 58                	push   $0x58
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	ff d0                	call   *%eax
  801058:	83 c4 10             	add    $0x10,%esp
			break;
  80105b:	e9 bc 00 00 00       	jmp    80111c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801060:	83 ec 08             	sub    $0x8,%esp
  801063:	ff 75 0c             	pushl  0xc(%ebp)
  801066:	6a 30                	push   $0x30
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	ff d0                	call   *%eax
  80106d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801070:	83 ec 08             	sub    $0x8,%esp
  801073:	ff 75 0c             	pushl  0xc(%ebp)
  801076:	6a 78                	push   $0x78
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	ff d0                	call   *%eax
  80107d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801080:	8b 45 14             	mov    0x14(%ebp),%eax
  801083:	83 c0 04             	add    $0x4,%eax
  801086:	89 45 14             	mov    %eax,0x14(%ebp)
  801089:	8b 45 14             	mov    0x14(%ebp),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801091:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801094:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80109b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a2:	eb 1f                	jmp    8010c3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8010aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	e8 e7 fb ff ff       	call   800c9a <getuint>
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	52                   	push   %edx
  8010ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8010d8:	ff 75 0c             	pushl  0xc(%ebp)
  8010db:	ff 75 08             	pushl  0x8(%ebp)
  8010de:	e8 00 fb ff ff       	call   800be3 <printnum>
  8010e3:	83 c4 20             	add    $0x20,%esp
			break;
  8010e6:	eb 34                	jmp    80111c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ee:	53                   	push   %ebx
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	ff d0                	call   *%eax
  8010f4:	83 c4 10             	add    $0x10,%esp
			break;
  8010f7:	eb 23                	jmp    80111c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	ff 75 0c             	pushl  0xc(%ebp)
  8010ff:	6a 25                	push   $0x25
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	ff d0                	call   *%eax
  801106:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801109:	ff 4d 10             	decl   0x10(%ebp)
  80110c:	eb 03                	jmp    801111 <vprintfmt+0x3b1>
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	48                   	dec    %eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	3c 25                	cmp    $0x25,%al
  801119:	75 f3                	jne    80110e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80111b:	90                   	nop
		}
	}
  80111c:	e9 47 fc ff ff       	jmp    800d68 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801121:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5d                   	pop    %ebp
  801128:	c3                   	ret    

00801129 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80112f:	8d 45 10             	lea    0x10(%ebp),%eax
  801132:	83 c0 04             	add    $0x4,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	ff 75 f4             	pushl  -0xc(%ebp)
  80113e:	50                   	push   %eax
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 16 fc ff ff       	call   800d60 <vprintfmt>
  80114a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80114d:	90                   	nop
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	8b 40 08             	mov    0x8(%eax),%eax
  801159:	8d 50 01             	lea    0x1(%eax),%edx
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	8b 10                	mov    (%eax),%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 40 04             	mov    0x4(%eax),%eax
  80116d:	39 c2                	cmp    %eax,%edx
  80116f:	73 12                	jae    801183 <sprintputch+0x33>
		*b->buf++ = ch;
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 48 01             	lea    0x1(%eax),%ecx
  801179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117c:	89 0a                	mov    %ecx,(%edx)
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	88 10                	mov    %dl,(%eax)
}
  801183:	90                   	nop
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8d 50 ff             	lea    -0x1(%eax),%edx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ab:	74 06                	je     8011b3 <vsnprintf+0x2d>
  8011ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b1:	7f 07                	jg     8011ba <vsnprintf+0x34>
		return -E_INVAL;
  8011b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8011b8:	eb 20                	jmp    8011da <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011ba:	ff 75 14             	pushl  0x14(%ebp)
  8011bd:	ff 75 10             	pushl  0x10(%ebp)
  8011c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c3:	50                   	push   %eax
  8011c4:	68 50 11 80 00       	push   $0x801150
  8011c9:	e8 92 fb ff ff       	call   800d60 <vprintfmt>
  8011ce:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8011e5:	83 c0 04             	add    $0x4,%eax
  8011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f1:	50                   	push   %eax
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	ff 75 08             	pushl  0x8(%ebp)
  8011f8:	e8 89 ff ff ff       	call   801186 <vsnprintf>
  8011fd:	83 c4 10             	add    $0x10,%esp
  801200:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801203:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80120e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801212:	74 13                	je     801227 <readline+0x1f>
		cprintf("%s", prompt);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 08             	pushl  0x8(%ebp)
  80121a:	68 10 41 80 00       	push   $0x804110
  80121f:	e8 62 f9 ff ff       	call   800b86 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	6a 00                	push   $0x0
  801233:	e8 59 f5 ff ff       	call   800791 <iscons>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80123e:	e8 00 f5 ff ff       	call   800743 <getchar>
  801243:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801246:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124a:	79 22                	jns    80126e <readline+0x66>
			if (c != -E_EOF)
  80124c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801250:	0f 84 ad 00 00 00    	je     801303 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801256:	83 ec 08             	sub    $0x8,%esp
  801259:	ff 75 ec             	pushl  -0x14(%ebp)
  80125c:	68 13 41 80 00       	push   $0x804113
  801261:	e8 20 f9 ff ff       	call   800b86 <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
			return;
  801269:	e9 95 00 00 00       	jmp    801303 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80126e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801272:	7e 34                	jle    8012a8 <readline+0xa0>
  801274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80127b:	7f 2b                	jg     8012a8 <readline+0xa0>
			if (echoing)
  80127d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801281:	74 0e                	je     801291 <readline+0x89>
				cputchar(c);
  801283:	83 ec 0c             	sub    $0xc,%esp
  801286:	ff 75 ec             	pushl  -0x14(%ebp)
  801289:	e8 6d f4 ff ff       	call   8006fb <cputchar>
  80128e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129a:	89 c2                	mov    %eax,%edx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a4:	88 10                	mov    %dl,(%eax)
  8012a6:	eb 56                	jmp    8012fe <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012a8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012ac:	75 1f                	jne    8012cd <readline+0xc5>
  8012ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b2:	7e 19                	jle    8012cd <readline+0xc5>
			if (echoing)
  8012b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b8:	74 0e                	je     8012c8 <readline+0xc0>
				cputchar(c);
  8012ba:	83 ec 0c             	sub    $0xc,%esp
  8012bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c0:	e8 36 f4 ff ff       	call   8006fb <cputchar>
  8012c5:	83 c4 10             	add    $0x10,%esp

			i--;
  8012c8:	ff 4d f4             	decl   -0xc(%ebp)
  8012cb:	eb 31                	jmp    8012fe <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012cd:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d1:	74 0a                	je     8012dd <readline+0xd5>
  8012d3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012d7:	0f 85 61 ff ff ff    	jne    80123e <readline+0x36>
			if (echoing)
  8012dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e1:	74 0e                	je     8012f1 <readline+0xe9>
				cputchar(c);
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e9:	e8 0d f4 ff ff       	call   8006fb <cputchar>
  8012ee:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	01 d0                	add    %edx,%eax
  8012f9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012fc:	eb 06                	jmp    801304 <readline+0xfc>
		}
	}
  8012fe:	e9 3b ff ff ff       	jmp    80123e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801303:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80130c:	e8 5d 0d 00 00       	call   80206e <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801315:	74 13                	je     80132a <atomic_readline+0x24>
		cprintf("%s", prompt);
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	68 10 41 80 00       	push   $0x804110
  801322:	e8 5f f8 ff ff       	call   800b86 <cprintf>
  801327:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	6a 00                	push   $0x0
  801336:	e8 56 f4 ff ff       	call   800791 <iscons>
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801341:	e8 fd f3 ff ff       	call   800743 <getchar>
  801346:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801349:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80134d:	79 23                	jns    801372 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80134f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801353:	74 13                	je     801368 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801355:	83 ec 08             	sub    $0x8,%esp
  801358:	ff 75 ec             	pushl  -0x14(%ebp)
  80135b:	68 13 41 80 00       	push   $0x804113
  801360:	e8 21 f8 ff ff       	call   800b86 <cprintf>
  801365:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801368:	e8 1b 0d 00 00       	call   802088 <sys_enable_interrupt>
			return;
  80136d:	e9 9a 00 00 00       	jmp    80140c <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801372:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801376:	7e 34                	jle    8013ac <atomic_readline+0xa6>
  801378:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80137f:	7f 2b                	jg     8013ac <atomic_readline+0xa6>
			if (echoing)
  801381:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801385:	74 0e                	je     801395 <atomic_readline+0x8f>
				cputchar(c);
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	ff 75 ec             	pushl  -0x14(%ebp)
  80138d:	e8 69 f3 ff ff       	call   8006fb <cputchar>
  801392:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801398:	8d 50 01             	lea    0x1(%eax),%edx
  80139b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80139e:	89 c2                	mov    %eax,%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a8:	88 10                	mov    %dl,(%eax)
  8013aa:	eb 5b                	jmp    801407 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013ac:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b0:	75 1f                	jne    8013d1 <atomic_readline+0xcb>
  8013b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013b6:	7e 19                	jle    8013d1 <atomic_readline+0xcb>
			if (echoing)
  8013b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013bc:	74 0e                	je     8013cc <atomic_readline+0xc6>
				cputchar(c);
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c4:	e8 32 f3 ff ff       	call   8006fb <cputchar>
  8013c9:	83 c4 10             	add    $0x10,%esp
			i--;
  8013cc:	ff 4d f4             	decl   -0xc(%ebp)
  8013cf:	eb 36                	jmp    801407 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013d5:	74 0a                	je     8013e1 <atomic_readline+0xdb>
  8013d7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013db:	0f 85 60 ff ff ff    	jne    801341 <atomic_readline+0x3b>
			if (echoing)
  8013e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013e5:	74 0e                	je     8013f5 <atomic_readline+0xef>
				cputchar(c);
  8013e7:	83 ec 0c             	sub    $0xc,%esp
  8013ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ed:	e8 09 f3 ff ff       	call   8006fb <cputchar>
  8013f2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801400:	e8 83 0c 00 00       	call   802088 <sys_enable_interrupt>
			return;
  801405:	eb 05                	jmp    80140c <atomic_readline+0x106>
		}
	}
  801407:	e9 35 ff ff ff       	jmp    801341 <atomic_readline+0x3b>
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 06                	jmp    801423 <strlen+0x15>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	84 c0                	test   %al,%al
  80142a:	75 f1                	jne    80141d <strlen+0xf>
		n++;
	return n;
  80142c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143e:	eb 09                	jmp    801449 <strnlen+0x18>
		n++;
  801440:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801443:	ff 45 08             	incl   0x8(%ebp)
  801446:	ff 4d 0c             	decl   0xc(%ebp)
  801449:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80144d:	74 09                	je     801458 <strnlen+0x27>
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	84 c0                	test   %al,%al
  801456:	75 e8                	jne    801440 <strnlen+0xf>
		n++;
	return n;
  801458:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801469:	90                   	nop
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8d 50 01             	lea    0x1(%eax),%edx
  801470:	89 55 08             	mov    %edx,0x8(%ebp)
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	8d 4a 01             	lea    0x1(%edx),%ecx
  801479:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80147c:	8a 12                	mov    (%edx),%dl
  80147e:	88 10                	mov    %dl,(%eax)
  801480:	8a 00                	mov    (%eax),%al
  801482:	84 c0                	test   %al,%al
  801484:	75 e4                	jne    80146a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801486:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801497:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80149e:	eb 1f                	jmp    8014bf <strncpy+0x34>
		*dst++ = *src;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8d 50 01             	lea    0x1(%eax),%edx
  8014a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ac:	8a 12                	mov    (%edx),%dl
  8014ae:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	84 c0                	test   %al,%al
  8014b7:	74 03                	je     8014bc <strncpy+0x31>
			src++;
  8014b9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014bc:	ff 45 fc             	incl   -0x4(%ebp)
  8014bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014c5:	72 d9                	jb     8014a0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014dc:	74 30                	je     80150e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014de:	eb 16                	jmp    8014f6 <strlcpy+0x2a>
			*dst++ = *src++;
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8d 50 01             	lea    0x1(%eax),%edx
  8014e6:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ef:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f2:	8a 12                	mov    (%edx),%dl
  8014f4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014f6:	ff 4d 10             	decl   0x10(%ebp)
  8014f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014fd:	74 09                	je     801508 <strlcpy+0x3c>
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	84 c0                	test   %al,%al
  801506:	75 d8                	jne    8014e0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801514:	29 c2                	sub    %eax,%edx
  801516:	89 d0                	mov    %edx,%eax
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80151d:	eb 06                	jmp    801525 <strcmp+0xb>
		p++, q++;
  80151f:	ff 45 08             	incl   0x8(%ebp)
  801522:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	74 0e                	je     80153c <strcmp+0x22>
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 10                	mov    (%eax),%dl
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	38 c2                	cmp    %al,%dl
  80153a:	74 e3                	je     80151f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	0f b6 d0             	movzbl %al,%edx
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f b6 c0             	movzbl %al,%eax
  80154c:	29 c2                	sub    %eax,%edx
  80154e:	89 d0                	mov    %edx,%eax
}
  801550:	5d                   	pop    %ebp
  801551:	c3                   	ret    

00801552 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801555:	eb 09                	jmp    801560 <strncmp+0xe>
		n--, p++, q++;
  801557:	ff 4d 10             	decl   0x10(%ebp)
  80155a:	ff 45 08             	incl   0x8(%ebp)
  80155d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801560:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801564:	74 17                	je     80157d <strncmp+0x2b>
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	84 c0                	test   %al,%al
  80156d:	74 0e                	je     80157d <strncmp+0x2b>
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 10                	mov    (%eax),%dl
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	38 c2                	cmp    %al,%dl
  80157b:	74 da                	je     801557 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80157d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801581:	75 07                	jne    80158a <strncmp+0x38>
		return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
  801588:	eb 14                	jmp    80159e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	0f b6 d0             	movzbl %al,%edx
  801592:	8b 45 0c             	mov    0xc(%ebp),%eax
  801595:	8a 00                	mov    (%eax),%al
  801597:	0f b6 c0             	movzbl %al,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
}
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015ac:	eb 12                	jmp    8015c0 <strchr+0x20>
		if (*s == c)
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b6:	75 05                	jne    8015bd <strchr+0x1d>
			return (char *) s;
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	eb 11                	jmp    8015ce <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	84 c0                	test   %al,%al
  8015c7:	75 e5                	jne    8015ae <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015dc:	eb 0d                	jmp    8015eb <strfind+0x1b>
		if (*s == c)
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8a 00                	mov    (%eax),%al
  8015e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e6:	74 0e                	je     8015f6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015e8:	ff 45 08             	incl   0x8(%ebp)
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	84 c0                	test   %al,%al
  8015f2:	75 ea                	jne    8015de <strfind+0xe>
  8015f4:	eb 01                	jmp    8015f7 <strfind+0x27>
		if (*s == c)
			break;
  8015f6:	90                   	nop
	return (char *) s;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801608:	8b 45 10             	mov    0x10(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80160e:	eb 0e                	jmp    80161e <memset+0x22>
		*p++ = c;
  801610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801613:	8d 50 01             	lea    0x1(%eax),%edx
  801616:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80161e:	ff 4d f8             	decl   -0x8(%ebp)
  801621:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801625:	79 e9                	jns    801610 <memset+0x14>
		*p++ = c;

	return v;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80163e:	eb 16                	jmp    801656 <memcpy+0x2a>
		*d++ = *s++;
  801640:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801643:	8d 50 01             	lea    0x1(%eax),%edx
  801646:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801649:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801652:	8a 12                	mov    (%edx),%dl
  801654:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165c:	89 55 10             	mov    %edx,0x10(%ebp)
  80165f:	85 c0                	test   %eax,%eax
  801661:	75 dd                	jne    801640 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80166e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801671:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801680:	73 50                	jae    8016d2 <memmove+0x6a>
  801682:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168d:	76 43                	jbe    8016d2 <memmove+0x6a>
		s += n;
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801695:	8b 45 10             	mov    0x10(%ebp),%eax
  801698:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80169b:	eb 10                	jmp    8016ad <memmove+0x45>
			*--d = *--s;
  80169d:	ff 4d f8             	decl   -0x8(%ebp)
  8016a0:	ff 4d fc             	decl   -0x4(%ebp)
  8016a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a6:	8a 10                	mov    (%eax),%dl
  8016a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ab:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	75 e3                	jne    80169d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016ba:	eb 23                	jmp    8016df <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bf:	8d 50 01             	lea    0x1(%eax),%edx
  8016c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016cb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ce:	8a 12                	mov    (%edx),%dl
  8016d0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	75 dd                	jne    8016bc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016f6:	eb 2a                	jmp    801722 <memcmp+0x3e>
		if (*s1 != *s2)
  8016f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016fb:	8a 10                	mov    (%eax),%dl
  8016fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	38 c2                	cmp    %al,%dl
  801704:	74 16                	je     80171c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801706:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	0f b6 d0             	movzbl %al,%edx
  80170e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 c0             	movzbl %al,%eax
  801716:	29 c2                	sub    %eax,%edx
  801718:	89 d0                	mov    %edx,%eax
  80171a:	eb 18                	jmp    801734 <memcmp+0x50>
		s1++, s2++;
  80171c:	ff 45 fc             	incl   -0x4(%ebp)
  80171f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801722:	8b 45 10             	mov    0x10(%ebp),%eax
  801725:	8d 50 ff             	lea    -0x1(%eax),%edx
  801728:	89 55 10             	mov    %edx,0x10(%ebp)
  80172b:	85 c0                	test   %eax,%eax
  80172d:	75 c9                	jne    8016f8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80173c:	8b 55 08             	mov    0x8(%ebp),%edx
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801747:	eb 15                	jmp    80175e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	0f b6 d0             	movzbl %al,%edx
  801751:	8b 45 0c             	mov    0xc(%ebp),%eax
  801754:	0f b6 c0             	movzbl %al,%eax
  801757:	39 c2                	cmp    %eax,%edx
  801759:	74 0d                	je     801768 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80175b:	ff 45 08             	incl   0x8(%ebp)
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801764:	72 e3                	jb     801749 <memfind+0x13>
  801766:	eb 01                	jmp    801769 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801768:	90                   	nop
	return (void *) s;
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80177b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801782:	eb 03                	jmp    801787 <strtol+0x19>
		s++;
  801784:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8a 00                	mov    (%eax),%al
  80178c:	3c 20                	cmp    $0x20,%al
  80178e:	74 f4                	je     801784 <strtol+0x16>
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	3c 09                	cmp    $0x9,%al
  801797:	74 eb                	je     801784 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	3c 2b                	cmp    $0x2b,%al
  8017a0:	75 05                	jne    8017a7 <strtol+0x39>
		s++;
  8017a2:	ff 45 08             	incl   0x8(%ebp)
  8017a5:	eb 13                	jmp    8017ba <strtol+0x4c>
	else if (*s == '-')
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	3c 2d                	cmp    $0x2d,%al
  8017ae:	75 0a                	jne    8017ba <strtol+0x4c>
		s++, neg = 1;
  8017b0:	ff 45 08             	incl   0x8(%ebp)
  8017b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017be:	74 06                	je     8017c6 <strtol+0x58>
  8017c0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c4:	75 20                	jne    8017e6 <strtol+0x78>
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	3c 30                	cmp    $0x30,%al
  8017cd:	75 17                	jne    8017e6 <strtol+0x78>
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	40                   	inc    %eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	3c 78                	cmp    $0x78,%al
  8017d7:	75 0d                	jne    8017e6 <strtol+0x78>
		s += 2, base = 16;
  8017d9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017dd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e4:	eb 28                	jmp    80180e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ea:	75 15                	jne    801801 <strtol+0x93>
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	3c 30                	cmp    $0x30,%al
  8017f3:	75 0c                	jne    801801 <strtol+0x93>
		s++, base = 8;
  8017f5:	ff 45 08             	incl   0x8(%ebp)
  8017f8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ff:	eb 0d                	jmp    80180e <strtol+0xa0>
	else if (base == 0)
  801801:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801805:	75 07                	jne    80180e <strtol+0xa0>
		base = 10;
  801807:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	8a 00                	mov    (%eax),%al
  801813:	3c 2f                	cmp    $0x2f,%al
  801815:	7e 19                	jle    801830 <strtol+0xc2>
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	3c 39                	cmp    $0x39,%al
  80181e:	7f 10                	jg     801830 <strtol+0xc2>
			dig = *s - '0';
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	0f be c0             	movsbl %al,%eax
  801828:	83 e8 30             	sub    $0x30,%eax
  80182b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182e:	eb 42                	jmp    801872 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	8a 00                	mov    (%eax),%al
  801835:	3c 60                	cmp    $0x60,%al
  801837:	7e 19                	jle    801852 <strtol+0xe4>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	3c 7a                	cmp    $0x7a,%al
  801840:	7f 10                	jg     801852 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8a 00                	mov    (%eax),%al
  801847:	0f be c0             	movsbl %al,%eax
  80184a:	83 e8 57             	sub    $0x57,%eax
  80184d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801850:	eb 20                	jmp    801872 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	8a 00                	mov    (%eax),%al
  801857:	3c 40                	cmp    $0x40,%al
  801859:	7e 39                	jle    801894 <strtol+0x126>
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8a 00                	mov    (%eax),%al
  801860:	3c 5a                	cmp    $0x5a,%al
  801862:	7f 30                	jg     801894 <strtol+0x126>
			dig = *s - 'A' + 10;
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	8a 00                	mov    (%eax),%al
  801869:	0f be c0             	movsbl %al,%eax
  80186c:	83 e8 37             	sub    $0x37,%eax
  80186f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801875:	3b 45 10             	cmp    0x10(%ebp),%eax
  801878:	7d 19                	jge    801893 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187a:	ff 45 08             	incl   0x8(%ebp)
  80187d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801880:	0f af 45 10          	imul   0x10(%ebp),%eax
  801884:	89 c2                	mov    %eax,%edx
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	01 d0                	add    %edx,%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80188e:	e9 7b ff ff ff       	jmp    80180e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801893:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801898:	74 08                	je     8018a2 <strtol+0x134>
		*endptr = (char *) s;
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 07                	je     8018af <strtol+0x141>
  8018a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ab:	f7 d8                	neg    %eax
  8018ad:	eb 03                	jmp    8018b2 <strtol+0x144>
  8018af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018cc:	79 13                	jns    8018e1 <ltostr+0x2d>
	{
		neg = 1;
  8018ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018db:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018de:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018e9:	99                   	cltd   
  8018ea:	f7 f9                	idiv   %ecx
  8018ec:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f2:	8d 50 01             	lea    0x1(%eax),%edx
  8018f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018f8:	89 c2                	mov    %eax,%edx
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	01 d0                	add    %edx,%eax
  8018ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801902:	83 c2 30             	add    $0x30,%edx
  801905:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80190f:	f7 e9                	imul   %ecx
  801911:	c1 fa 02             	sar    $0x2,%edx
  801914:	89 c8                	mov    %ecx,%eax
  801916:	c1 f8 1f             	sar    $0x1f,%eax
  801919:	29 c2                	sub    %eax,%edx
  80191b:	89 d0                	mov    %edx,%eax
  80191d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801920:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801923:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801928:	f7 e9                	imul   %ecx
  80192a:	c1 fa 02             	sar    $0x2,%edx
  80192d:	89 c8                	mov    %ecx,%eax
  80192f:	c1 f8 1f             	sar    $0x1f,%eax
  801932:	29 c2                	sub    %eax,%edx
  801934:	89 d0                	mov    %edx,%eax
  801936:	c1 e0 02             	shl    $0x2,%eax
  801939:	01 d0                	add    %edx,%eax
  80193b:	01 c0                	add    %eax,%eax
  80193d:	29 c1                	sub    %eax,%ecx
  80193f:	89 ca                	mov    %ecx,%edx
  801941:	85 d2                	test   %edx,%edx
  801943:	75 9c                	jne    8018e1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80194c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194f:	48                   	dec    %eax
  801950:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801953:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801957:	74 3d                	je     801996 <ltostr+0xe2>
		start = 1 ;
  801959:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801960:	eb 34                	jmp    801996 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801965:	8b 45 0c             	mov    0xc(%ebp),%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	8a 00                	mov    (%eax),%al
  80196c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80196f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801972:	8b 45 0c             	mov    0xc(%ebp),%eax
  801975:	01 c2                	add    %eax,%edx
  801977:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197d:	01 c8                	add    %ecx,%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801983:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801986:	8b 45 0c             	mov    0xc(%ebp),%eax
  801989:	01 c2                	add    %eax,%edx
  80198b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80198e:	88 02                	mov    %al,(%edx)
		start++ ;
  801990:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801993:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801999:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199c:	7c c4                	jl     801962 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80199e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	e8 54 fa ff ff       	call   80140e <strlen>
  8019ba:	83 c4 04             	add    $0x4,%esp
  8019bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	e8 46 fa ff ff       	call   80140e <strlen>
  8019c8:	83 c4 04             	add    $0x4,%esp
  8019cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019dc:	eb 17                	jmp    8019f5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e4:	01 c2                	add    %eax,%edx
  8019e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	01 c8                	add    %ecx,%eax
  8019ee:	8a 00                	mov    (%eax),%al
  8019f0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f2:	ff 45 fc             	incl   -0x4(%ebp)
  8019f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019fb:	7c e1                	jl     8019de <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a0b:	eb 1f                	jmp    801a2c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a10:	8d 50 01             	lea    0x1(%eax),%edx
  801a13:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a16:	89 c2                	mov    %eax,%edx
  801a18:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1b:	01 c2                	add    %eax,%edx
  801a1d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a23:	01 c8                	add    %ecx,%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a29:	ff 45 f8             	incl   -0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a32:	7c d9                	jl     801a0d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c6 00 00             	movb   $0x0,(%eax)
}
  801a3f:	90                   	nop
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a45:	8b 45 14             	mov    0x14(%ebp),%eax
  801a48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a51:	8b 00                	mov    (%eax),%eax
  801a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a65:	eb 0c                	jmp    801a73 <strsplit+0x31>
			*string++ = 0;
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8d 50 01             	lea    0x1(%eax),%edx
  801a6d:	89 55 08             	mov    %edx,0x8(%ebp)
  801a70:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	8a 00                	mov    (%eax),%al
  801a78:	84 c0                	test   %al,%al
  801a7a:	74 18                	je     801a94 <strsplit+0x52>
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	8a 00                	mov    (%eax),%al
  801a81:	0f be c0             	movsbl %al,%eax
  801a84:	50                   	push   %eax
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	e8 13 fb ff ff       	call   8015a0 <strchr>
  801a8d:	83 c4 08             	add    $0x8,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	75 d3                	jne    801a67 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	84 c0                	test   %al,%al
  801a9b:	74 5a                	je     801af7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa0:	8b 00                	mov    (%eax),%eax
  801aa2:	83 f8 0f             	cmp    $0xf,%eax
  801aa5:	75 07                	jne    801aae <strsplit+0x6c>
		{
			return 0;
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aac:	eb 66                	jmp    801b14 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801aae:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab1:	8b 00                	mov    (%eax),%eax
  801ab3:	8d 48 01             	lea    0x1(%eax),%ecx
  801ab6:	8b 55 14             	mov    0x14(%ebp),%edx
  801ab9:	89 0a                	mov    %ecx,(%edx)
  801abb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac5:	01 c2                	add    %eax,%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801acc:	eb 03                	jmp    801ad1 <strsplit+0x8f>
			string++;
  801ace:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	8a 00                	mov    (%eax),%al
  801ad6:	84 c0                	test   %al,%al
  801ad8:	74 8b                	je     801a65 <strsplit+0x23>
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8a 00                	mov    (%eax),%al
  801adf:	0f be c0             	movsbl %al,%eax
  801ae2:	50                   	push   %eax
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	e8 b5 fa ff ff       	call   8015a0 <strchr>
  801aeb:	83 c4 08             	add    $0x8,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	74 dc                	je     801ace <strsplit+0x8c>
			string++;
	}
  801af2:	e9 6e ff ff ff       	jmp    801a65 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801af7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801af8:	8b 45 14             	mov    0x14(%ebp),%eax
  801afb:	8b 00                	mov    (%eax),%eax
  801afd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b04:	8b 45 10             	mov    0x10(%ebp),%eax
  801b07:	01 d0                	add    %edx,%eax
  801b09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b0f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801b1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b23:	eb 4c                	jmp    801b71 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801b25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2b:	01 d0                	add    %edx,%eax
  801b2d:	8a 00                	mov    (%eax),%al
  801b2f:	3c 40                	cmp    $0x40,%al
  801b31:	7e 27                	jle    801b5a <str2lower+0x44>
  801b33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	01 d0                	add    %edx,%eax
  801b3b:	8a 00                	mov    (%eax),%al
  801b3d:	3c 5a                	cmp    $0x5a,%al
  801b3f:	7f 19                	jg     801b5a <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801b41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	01 ca                	add    %ecx,%edx
  801b51:	8a 12                	mov    (%edx),%dl
  801b53:	83 c2 20             	add    $0x20,%edx
  801b56:	88 10                	mov    %dl,(%eax)
  801b58:	eb 14                	jmp    801b6e <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801b5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	01 c2                	add    %eax,%edx
  801b62:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b68:	01 c8                	add    %ecx,%eax
  801b6a:	8a 00                	mov    (%eax),%al
  801b6c:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801b6e:	ff 45 fc             	incl   -0x4(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	e8 95 f8 ff ff       	call   80140e <strlen>
  801b79:	83 c4 04             	add    $0x4,%esp
  801b7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b7f:	7f a4                	jg     801b25 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801b8b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b90:	85 c0                	test   %eax,%eax
  801b92:	74 0a                	je     801b9e <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b94:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b9b:	00 00 00 
	}
}
  801b9e:	90                   	nop
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    

00801ba1 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ba7:	83 ec 0c             	sub    $0xc,%esp
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	e8 7e 09 00 00       	call   802530 <sys_sbrk>
  801bb2:	83 c4 10             	add    $0x10,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bbd:	e8 c6 ff ff ff       	call   801b88 <InitializeUHeap>
	if (size == 0)
  801bc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bc6:	75 0a                	jne    801bd2 <malloc+0x1b>
		return NULL;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcd:	e9 3f 01 00 00       	jmp    801d11 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801bd2:	e8 ac 09 00 00       	call   802583 <sys_get_hard_limit>
  801bd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801bda:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801be9:	c1 e8 0c             	shr    $0xc,%eax
  801bec:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801bef:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bfc:	01 d0                	add    %edx,%eax
  801bfe:	48                   	dec    %eax
  801bff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c05:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0a:	f7 75 d8             	divl   -0x28(%ebp)
  801c0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c10:	29 d0                	sub    %edx,%eax
  801c12:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801c15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c18:	c1 e8 0c             	shr    $0xc,%eax
  801c1b:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c22:	75 0a                	jne    801c2e <malloc+0x77>
		return NULL;
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
  801c29:	e9 e3 00 00 00       	jmp    801d11 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801c2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c31:	05 00 00 00 80       	add    $0x80000000,%eax
  801c36:	c1 e8 0c             	shr    $0xc,%eax
  801c39:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c3e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c45:	77 19                	ja     801c60 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	e8 44 0b 00 00       	call   802796 <alloc_block_FF>
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801c58:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c5b:	e9 b1 00 00 00       	jmp    801d11 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801c60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c66:	eb 4d                	jmp    801cb5 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c6b:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c72:	84 c0                	test   %al,%al
  801c74:	75 27                	jne    801c9d <malloc+0xe6>
			{
				counter++;
  801c76:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801c79:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801c7d:	75 14                	jne    801c93 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c82:	05 00 00 08 00       	add    $0x80000,%eax
  801c87:	c1 e0 0c             	shl    $0xc,%eax
  801c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c96:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801c99:	75 17                	jne    801cb2 <malloc+0xfb>
				{
					break;
  801c9b:	eb 21                	jmp    801cbe <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ca0:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801ca7:	3c 01                	cmp    $0x1,%al
  801ca9:	75 07                	jne    801cb2 <malloc+0xfb>
			{
				counter = 0;
  801cab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801cb2:	ff 45 e8             	incl   -0x18(%ebp)
  801cb5:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801cbc:	76 aa                	jbe    801c68 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cc4:	75 46                	jne    801d0c <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801cc6:	83 ec 08             	sub    $0x8,%esp
  801cc9:	ff 75 d0             	pushl  -0x30(%ebp)
  801ccc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccf:	e8 93 08 00 00       	call   802567 <sys_allocate_user_mem>
  801cd4:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cda:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cdd:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cea:	eb 0e                	jmp    801cfa <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cef:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  801cf6:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801cf7:	ff 45 e4             	incl   -0x1c(%ebp)
  801cfa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d00:	01 d0                	add    %edx,%eax
  801d02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d05:	77 e5                	ja     801cec <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	eb 05                	jmp    801d11 <malloc+0x15a>
		}
	}

	return NULL;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801d19:	e8 65 08 00 00       	call   802583 <sys_get_hard_limit>
  801d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801d27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d2b:	0f 84 c1 00 00 00    	je     801df2 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d34:	85 c0                	test   %eax,%eax
  801d36:	79 1b                	jns    801d53 <free+0x40>
  801d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d3e:	73 13                	jae    801d53 <free+0x40>
    {
        free_block(virtual_address);
  801d40:	83 ec 0c             	sub    $0xc,%esp
  801d43:	ff 75 08             	pushl  0x8(%ebp)
  801d46:	e8 18 10 00 00       	call   802d63 <free_block>
  801d4b:	83 c4 10             	add    $0x10,%esp
    	return;
  801d4e:	e9 a6 00 00 00       	jmp    801df9 <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d56:	05 00 10 00 00       	add    $0x1000,%eax
  801d5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d5e:	0f 87 91 00 00 00    	ja     801df5 <free+0xe2>
  801d64:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d6b:	0f 87 84 00 00 00    	ja     801df5 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d74:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d85:	05 00 00 00 80       	add    $0x80000000,%eax
  801d8a:	c1 e8 0c             	shr    $0xc,%eax
  801d8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801d90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d93:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  801d9a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801d9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801da1:	74 55                	je     801df8 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da6:	c1 e8 0c             	shr    $0xc,%eax
  801da9:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801daf:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801db6:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc0:	eb 0e                	jmp    801dd0 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  801dcc:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801dcd:	ff 45 f4             	incl   -0xc(%ebp)
  801dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd6:	01 c2                	add    %eax,%edx
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	39 c2                	cmp    %eax,%edx
  801ddd:	77 e3                	ja     801dc2 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801ddf:	83 ec 08             	sub    $0x8,%esp
  801de2:	ff 75 e0             	pushl  -0x20(%ebp)
  801de5:	ff 75 ec             	pushl  -0x14(%ebp)
  801de8:	e8 5e 07 00 00       	call   80254b <sys_free_user_mem>
  801ded:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801df0:	eb 07                	jmp    801df9 <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801df2:	90                   	nop
  801df3:	eb 04                	jmp    801df9 <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801df5:	90                   	nop
  801df6:	eb 01                	jmp    801df9 <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801df8:	90                   	nop
    else
     {
    	return;
      }

}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 18             	sub    $0x18,%esp
  801e01:	8b 45 10             	mov    0x10(%ebp),%eax
  801e04:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e07:	e8 7c fd ff ff       	call   801b88 <InitializeUHeap>
	if (size == 0)
  801e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e10:	75 07                	jne    801e19 <smalloc+0x1e>
		return NULL;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
  801e17:	eb 17                	jmp    801e30 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801e19:	83 ec 04             	sub    $0x4,%esp
  801e1c:	68 24 41 80 00       	push   $0x804124
  801e21:	68 ad 00 00 00       	push   $0xad
  801e26:	68 4a 41 80 00       	push   $0x80414a
  801e2b:	e8 99 ea ff ff       	call   8008c9 <_panic>
	return NULL;
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e38:	e8 4b fd ff ff       	call   801b88 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	68 58 41 80 00       	push   $0x804158
  801e45:	68 ba 00 00 00       	push   $0xba
  801e4a:	68 4a 41 80 00       	push   $0x80414a
  801e4f:	e8 75 ea ff ff       	call   8008c9 <_panic>

00801e54 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e5a:	e8 29 fd ff ff       	call   801b88 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	68 7c 41 80 00       	push   $0x80417c
  801e67:	68 d8 00 00 00       	push   $0xd8
  801e6c:	68 4a 41 80 00       	push   $0x80414a
  801e71:	e8 53 ea ff ff       	call   8008c9 <_panic>

00801e76 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	68 a4 41 80 00       	push   $0x8041a4
  801e84:	68 ea 00 00 00       	push   $0xea
  801e89:	68 4a 41 80 00       	push   $0x80414a
  801e8e:	e8 36 ea ff ff       	call   8008c9 <_panic>

00801e93 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	68 c8 41 80 00       	push   $0x8041c8
  801ea1:	68 f2 00 00 00       	push   $0xf2
  801ea6:	68 4a 41 80 00       	push   $0x80414a
  801eab:	e8 19 ea ff ff       	call   8008c9 <_panic>

00801eb0 <shrink>:

}
void shrink(uint32 newSize) {
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	68 c8 41 80 00       	push   $0x8041c8
  801ebe:	68 f6 00 00 00       	push   $0xf6
  801ec3:	68 4a 41 80 00       	push   $0x80414a
  801ec8:	e8 fc e9 ff ff       	call   8008c9 <_panic>

00801ecd <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed3:	83 ec 04             	sub    $0x4,%esp
  801ed6:	68 c8 41 80 00       	push   $0x8041c8
  801edb:	68 fa 00 00 00       	push   $0xfa
  801ee0:	68 4a 41 80 00       	push   $0x80414a
  801ee5:	e8 df e9 ff ff       	call   8008c9 <_panic>

00801eea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	57                   	push   %edi
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801efc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f02:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f05:	cd 30                	int    $0x30
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    

00801f15 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f21:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	50                   	push   %eax
  801f31:	6a 00                	push   $0x0
  801f33:	e8 b2 ff ff ff       	call   801eea <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	90                   	nop
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_cgetc>:

int
sys_cgetc(void)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 01                	push   $0x1
  801f4d:	e8 98 ff ff ff       	call   801eea <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	6a 05                	push   $0x5
  801f6a:	e8 7b ff ff ff       	call   801eea <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f79:	8b 75 18             	mov    0x18(%ebp),%esi
  801f7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	56                   	push   %esi
  801f89:	53                   	push   %ebx
  801f8a:	51                   	push   %ecx
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	6a 06                	push   $0x6
  801f8f:	e8 56 ff ff ff       	call   801eea <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5e                   	pop    %esi
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	6a 07                	push   $0x7
  801fb1:	e8 34 ff ff ff       	call   801eea <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	ff 75 08             	pushl  0x8(%ebp)
  801fca:	6a 08                	push   $0x8
  801fcc:	e8 19 ff ff ff       	call   801eea <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 09                	push   $0x9
  801fe5:	e8 00 ff ff ff       	call   801eea <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 0a                	push   $0xa
  801ffe:	e8 e7 fe ff ff       	call   801eea <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 0b                	push   $0xb
  802017:	e8 ce fe ff ff       	call   801eea <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 0c                	push   $0xc
  802030:	e8 b5 fe ff ff       	call   801eea <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	ff 75 08             	pushl  0x8(%ebp)
  802048:	6a 0d                	push   $0xd
  80204a:	e8 9b fe ff ff       	call   801eea <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 0e                	push   $0xe
  802063:	e8 82 fe ff ff       	call   801eea <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	90                   	nop
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 11                	push   $0x11
  80207d:	e8 68 fe ff ff       	call   801eea <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	90                   	nop
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 12                	push   $0x12
  802097:	e8 4e fe ff ff       	call   801eea <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
}
  80209f:	90                   	nop
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	50                   	push   %eax
  8020bb:	6a 13                	push   $0x13
  8020bd:	e8 28 fe ff ff       	call   801eea <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	90                   	nop
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 14                	push   $0x14
  8020d7:	e8 0e fe ff ff       	call   801eea <syscall>
  8020dc:	83 c4 18             	add    $0x18,%esp
}
  8020df:	90                   	nop
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	ff 75 0c             	pushl  0xc(%ebp)
  8020f1:	50                   	push   %eax
  8020f2:	6a 15                	push   $0x15
  8020f4:	e8 f1 fd ff ff       	call   801eea <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	52                   	push   %edx
  80210e:	50                   	push   %eax
  80210f:	6a 18                	push   $0x18
  802111:	e8 d4 fd ff ff       	call   801eea <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80211e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	52                   	push   %edx
  80212b:	50                   	push   %eax
  80212c:	6a 16                	push   $0x16
  80212e:	e8 b7 fd ff ff       	call   801eea <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80213c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 17                	push   $0x17
  80214c:	e8 99 fd ff ff       	call   801eea <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	90                   	nop
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	8b 45 10             	mov    0x10(%ebp),%eax
  802160:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802163:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802166:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	51                   	push   %ecx
  802170:	52                   	push   %edx
  802171:	ff 75 0c             	pushl  0xc(%ebp)
  802174:	50                   	push   %eax
  802175:	6a 19                	push   $0x19
  802177:	e8 6e fd ff ff       	call   801eea <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	52                   	push   %edx
  802191:	50                   	push   %eax
  802192:	6a 1a                	push   $0x1a
  802194:	e8 51 fd ff ff       	call   801eea <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	51                   	push   %ecx
  8021af:	52                   	push   %edx
  8021b0:	50                   	push   %eax
  8021b1:	6a 1b                	push   $0x1b
  8021b3:	e8 32 fd ff ff       	call   801eea <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	52                   	push   %edx
  8021cd:	50                   	push   %eax
  8021ce:	6a 1c                	push   $0x1c
  8021d0:	e8 15 fd ff ff       	call   801eea <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 1d                	push   $0x1d
  8021e9:	e8 fc fc ff ff       	call   801eea <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	ff 75 14             	pushl  0x14(%ebp)
  8021fe:	ff 75 10             	pushl  0x10(%ebp)
  802201:	ff 75 0c             	pushl  0xc(%ebp)
  802204:	50                   	push   %eax
  802205:	6a 1e                	push   $0x1e
  802207:	e8 de fc ff ff       	call   801eea <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	50                   	push   %eax
  802220:	6a 1f                	push   $0x1f
  802222:	e8 c3 fc ff ff       	call   801eea <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	90                   	nop
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	50                   	push   %eax
  80223c:	6a 20                	push   $0x20
  80223e:	e8 a7 fc ff ff       	call   801eea <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 02                	push   $0x2
  802257:	e8 8e fc ff ff       	call   801eea <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 03                	push   $0x3
  802270:	e8 75 fc ff ff       	call   801eea <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 04                	push   $0x4
  802289:	e8 5c fc ff ff       	call   801eea <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_exit_env>:


void sys_exit_env(void)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 21                	push   $0x21
  8022a2:	e8 43 fc ff ff       	call   801eea <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b6:	8d 50 04             	lea    0x4(%eax),%edx
  8022b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	52                   	push   %edx
  8022c3:	50                   	push   %eax
  8022c4:	6a 22                	push   $0x22
  8022c6:	e8 1f fc ff ff       	call   801eea <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022d7:	89 01                	mov    %eax,(%ecx)
  8022d9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	c9                   	leave  
  8022e0:	c2 04 00             	ret    $0x4

008022e3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	ff 75 10             	pushl  0x10(%ebp)
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	ff 75 08             	pushl  0x8(%ebp)
  8022f3:	6a 10                	push   $0x10
  8022f5:	e8 f0 fb ff ff       	call   801eea <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fd:	90                   	nop
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_rcr2>:
uint32 sys_rcr2()
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 23                	push   $0x23
  80230f:	e8 d6 fb ff ff       	call   801eea <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802325:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	50                   	push   %eax
  802332:	6a 24                	push   $0x24
  802334:	e8 b1 fb ff ff       	call   801eea <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
	return ;
  80233c:	90                   	nop
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <rsttst>:
void rsttst()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 26                	push   $0x26
  80234e:	e8 97 fb ff ff       	call   801eea <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
	return ;
  802356:	90                   	nop
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	8b 45 14             	mov    0x14(%ebp),%eax
  802362:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802365:	8b 55 18             	mov    0x18(%ebp),%edx
  802368:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80236c:	52                   	push   %edx
  80236d:	50                   	push   %eax
  80236e:	ff 75 10             	pushl  0x10(%ebp)
  802371:	ff 75 0c             	pushl  0xc(%ebp)
  802374:	ff 75 08             	pushl  0x8(%ebp)
  802377:	6a 25                	push   $0x25
  802379:	e8 6c fb ff ff       	call   801eea <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
	return ;
  802381:	90                   	nop
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <chktst>:
void chktst(uint32 n)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	ff 75 08             	pushl  0x8(%ebp)
  802392:	6a 27                	push   $0x27
  802394:	e8 51 fb ff ff       	call   801eea <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
	return ;
  80239c:	90                   	nop
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <inctst>:

void inctst()
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 28                	push   $0x28
  8023ae:	e8 37 fb ff ff       	call   801eea <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b6:	90                   	nop
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <gettst>:
uint32 gettst()
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 29                	push   $0x29
  8023c8:	e8 1d fb ff ff       	call   801eea <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 2a                	push   $0x2a
  8023e4:	e8 01 fb ff ff       	call   801eea <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
  8023ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023ef:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023f3:	75 07                	jne    8023fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fa:	eb 05                	jmp    802401 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 2a                	push   $0x2a
  802415:	e8 d0 fa ff ff       	call   801eea <syscall>
  80241a:	83 c4 18             	add    $0x18,%esp
  80241d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802420:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802424:	75 07                	jne    80242d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802426:	b8 01 00 00 00       	mov    $0x1,%eax
  80242b:	eb 05                	jmp    802432 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 2a                	push   $0x2a
  802446:	e8 9f fa ff ff       	call   801eea <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
  80244e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802451:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802455:	75 07                	jne    80245e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802457:	b8 01 00 00 00       	mov    $0x1,%eax
  80245c:	eb 05                	jmp    802463 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 2a                	push   $0x2a
  802477:	e8 6e fa ff ff       	call   801eea <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
  80247f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802482:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802486:	75 07                	jne    80248f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802488:	b8 01 00 00 00       	mov    $0x1,%eax
  80248d:	eb 05                	jmp    802494 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	ff 75 08             	pushl  0x8(%ebp)
  8024a4:	6a 2b                	push   $0x2b
  8024a6:	e8 3f fa ff ff       	call   801eea <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ae:	90                   	nop
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	6a 00                	push   $0x0
  8024c3:	53                   	push   %ebx
  8024c4:	51                   	push   %ecx
  8024c5:	52                   	push   %edx
  8024c6:	50                   	push   %eax
  8024c7:	6a 2c                	push   $0x2c
  8024c9:	e8 1c fa ff ff       	call   801eea <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
}
  8024d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	52                   	push   %edx
  8024e6:	50                   	push   %eax
  8024e7:	6a 2d                	push   $0x2d
  8024e9:	e8 fc f9 ff ff       	call   801eea <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	51                   	push   %ecx
  802502:	ff 75 10             	pushl  0x10(%ebp)
  802505:	52                   	push   %edx
  802506:	50                   	push   %eax
  802507:	6a 2e                	push   $0x2e
  802509:	e8 dc f9 ff ff       	call   801eea <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	ff 75 10             	pushl  0x10(%ebp)
  80251d:	ff 75 0c             	pushl  0xc(%ebp)
  802520:	ff 75 08             	pushl  0x8(%ebp)
  802523:	6a 0f                	push   $0xf
  802525:	e8 c0 f9 ff ff       	call   801eea <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
	return ;
  80252d:	90                   	nop
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	50                   	push   %eax
  80253f:	6a 2f                	push   $0x2f
  802541:	e8 a4 f9 ff ff       	call   801eea <syscall>
  802546:	83 c4 18             	add    $0x18,%esp

}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	ff 75 0c             	pushl  0xc(%ebp)
  802557:	ff 75 08             	pushl  0x8(%ebp)
  80255a:	6a 30                	push   $0x30
  80255c:	e8 89 f9 ff ff       	call   801eea <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
	return;
  802564:	90                   	nop
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	ff 75 0c             	pushl  0xc(%ebp)
  802573:	ff 75 08             	pushl  0x8(%ebp)
  802576:	6a 31                	push   $0x31
  802578:	e8 6d f9 ff ff       	call   801eea <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
	return;
  802580:	90                   	nop
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 32                	push   $0x32
  802592:	e8 53 f9 ff ff       	call   801eea <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	83 e8 10             	sub    $0x10,%eax
  8025a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  8025ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	83 e8 10             	sub    $0x10,%eax
  8025be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  8025c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c4:	8a 40 04             	mov    0x4(%eax),%al
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d9:	83 f8 02             	cmp    $0x2,%eax
  8025dc:	74 2b                	je     802609 <alloc_block+0x40>
  8025de:	83 f8 02             	cmp    $0x2,%eax
  8025e1:	7f 07                	jg     8025ea <alloc_block+0x21>
  8025e3:	83 f8 01             	cmp    $0x1,%eax
  8025e6:	74 0e                	je     8025f6 <alloc_block+0x2d>
  8025e8:	eb 58                	jmp    802642 <alloc_block+0x79>
  8025ea:	83 f8 03             	cmp    $0x3,%eax
  8025ed:	74 2d                	je     80261c <alloc_block+0x53>
  8025ef:	83 f8 04             	cmp    $0x4,%eax
  8025f2:	74 3b                	je     80262f <alloc_block+0x66>
  8025f4:	eb 4c                	jmp    802642 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	ff 75 08             	pushl  0x8(%ebp)
  8025fc:	e8 95 01 00 00       	call   802796 <alloc_block_FF>
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802607:	eb 4a                	jmp    802653 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802609:	83 ec 0c             	sub    $0xc,%esp
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	e8 32 07 00 00       	call   802d46 <alloc_block_NF>
  802614:	83 c4 10             	add    $0x10,%esp
  802617:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80261a:	eb 37                	jmp    802653 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80261c:	83 ec 0c             	sub    $0xc,%esp
  80261f:	ff 75 08             	pushl  0x8(%ebp)
  802622:	e8 a3 04 00 00       	call   802aca <alloc_block_BF>
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80262d:	eb 24                	jmp    802653 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	ff 75 08             	pushl  0x8(%ebp)
  802635:	e8 ef 06 00 00       	call   802d29 <alloc_block_WF>
  80263a:	83 c4 10             	add    $0x10,%esp
  80263d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802640:	eb 11                	jmp    802653 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	68 d8 41 80 00       	push   $0x8041d8
  80264a:	e8 37 e5 ff ff       	call   800b86 <cprintf>
  80264f:	83 c4 10             	add    $0x10,%esp
		break;
  802652:	90                   	nop
	}
	return va;
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	68 f8 41 80 00       	push   $0x8041f8
  802666:	e8 1b e5 ff ff       	call   800b86 <cprintf>
  80266b:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  80266e:	83 ec 0c             	sub    $0xc,%esp
  802671:	68 23 42 80 00       	push   $0x804223
  802676:	e8 0b e5 ff ff       	call   800b86 <cprintf>
  80267b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80267e:	8b 45 08             	mov    0x8(%ebp),%eax
  802681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802684:	eb 26                	jmp    8026ac <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8a 40 04             	mov    0x4(%eax),%al
  80268c:	0f b6 d0             	movzbl %al,%edx
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	83 ec 04             	sub    $0x4,%esp
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	68 3b 42 80 00       	push   $0x80423b
  80269e:	e8 e3 e4 ff ff       	call   800b86 <cprintf>
  8026a3:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b0:	74 08                	je     8026ba <print_blocks_list+0x62>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 08             	mov    0x8(%eax),%eax
  8026b8:	eb 05                	jmp    8026bf <print_blocks_list+0x67>
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	89 45 10             	mov    %eax,0x10(%ebp)
  8026c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	75 bd                	jne    802686 <print_blocks_list+0x2e>
  8026c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cd:	75 b7                	jne    802686 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	68 f8 41 80 00       	push   $0x8041f8
  8026d7:	e8 aa e4 ff ff       	call   800b86 <cprintf>
  8026dc:	83 c4 10             	add    $0x10,%esp

}
  8026df:	90                   	nop
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  8026e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026ec:	0f 84 a1 00 00 00    	je     802793 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  8026f2:	c7 05 30 50 80 00 01 	movl   $0x1,0x805030
  8026f9:	00 00 00 
	LIST_INIT(&list);
  8026fc:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802703:	00 00 00 
  802706:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  80270d:	00 00 00 
  802710:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802717:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272d:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  80272f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802733:	75 14                	jne    802749 <initialize_dynamic_allocator+0x67>
  802735:	83 ec 04             	sub    $0x4,%esp
  802738:	68 54 42 80 00       	push   $0x804254
  80273d:	6a 64                	push   $0x64
  80273f:	68 77 42 80 00       	push   $0x804277
  802744:	e8 80 e1 ff ff       	call   8008c9 <_panic>
  802749:	8b 15 44 51 90 00    	mov    0x905144,%edx
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	89 50 0c             	mov    %edx,0xc(%eax)
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 0c             	mov    0xc(%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	74 0d                	je     80276c <initialize_dynamic_allocator+0x8a>
  80275f:	a1 44 51 90 00       	mov    0x905144,%eax
  802764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802767:	89 50 08             	mov    %edx,0x8(%eax)
  80276a:	eb 08                	jmp    802774 <initialize_dynamic_allocator+0x92>
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	a3 40 51 90 00       	mov    %eax,0x905140
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	a3 44 51 90 00       	mov    %eax,0x905144
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802786:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80278b:	40                   	inc    %eax
  80278c:	a3 4c 51 90 00       	mov    %eax,0x90514c
  802791:	eb 01                	jmp    802794 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802793:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  80279c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027a0:	75 0a                	jne    8027ac <alloc_block_FF+0x16>
	{
		return NULL;
  8027a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a7:	e9 1c 03 00 00       	jmp    802ac8 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8027ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	75 40                	jne    8027f5 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	83 c0 10             	add    $0x10,%eax
  8027bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	83 ec 0c             	sub    $0xc,%esp
  8027c4:	50                   	push   %eax
  8027c5:	e8 d7 f3 ff ff       	call   801ba1 <sbrk>
  8027ca:	83 c4 10             	add    $0x10,%esp
  8027cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  8027d0:	83 ec 0c             	sub    $0xc,%esp
  8027d3:	6a 00                	push   $0x0
  8027d5:	e8 c7 f3 ff ff       	call   801ba1 <sbrk>
  8027da:	83 c4 10             	add    $0x10,%esp
  8027dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8027e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8027e6:	83 ec 08             	sub    $0x8,%esp
  8027e9:	50                   	push   %eax
  8027ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8027ed:	e8 f0 fe ff ff       	call   8026e2 <initialize_dynamic_allocator>
  8027f2:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8027f5:	a1 40 51 90 00       	mov    0x905140,%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	e9 1e 01 00 00       	jmp    802920 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	8d 50 10             	lea    0x10(%eax),%edx
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 00                	mov    (%eax),%eax
  80280d:	39 c2                	cmp    %eax,%edx
  80280f:	75 1c                	jne    80282d <alloc_block_FF+0x97>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8a 40 04             	mov    0x4(%eax),%al
  802817:	3c 01                	cmp    $0x1,%al
  802819:	75 12                	jne    80282d <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	83 c0 10             	add    $0x10,%eax
  802828:	e9 9b 02 00 00       	jmp    802ac8 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  80282d:	8b 45 08             	mov    0x8(%ebp),%eax
  802830:	8d 50 10             	lea    0x10(%eax),%edx
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	39 c2                	cmp    %eax,%edx
  80283a:	0f 83 d8 00 00 00    	jae    802918 <alloc_block_FF+0x182>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8a 40 04             	mov    0x4(%eax),%al
  802846:	3c 01                	cmp    $0x1,%al
  802848:	0f 85 ca 00 00 00    	jne    802918 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	2b 45 08             	sub    0x8(%ebp),%eax
  802856:	83 e8 10             	sub    $0x10,%eax
  802859:	83 f8 0f             	cmp    $0xf,%eax
  80285c:	0f 86 a4 00 00 00    	jbe    802906 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	01 d0                	add    %edx,%eax
  80286a:	83 c0 10             	add    $0x10,%eax
  80286d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	2b 45 08             	sub    0x8(%ebp),%eax
  802878:	8d 50 f0             	lea    -0x10(%eax),%edx
  80287b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80287e:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802880:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802883:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288b:	74 06                	je     802893 <alloc_block_FF+0xfd>
  80288d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_FF+0x114>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 90 42 80 00       	push   $0x804290
  80289b:	68 8f 00 00 00       	push   $0x8f
  8028a0:	68 77 42 80 00       	push   $0x804277
  8028a5:	e8 1f e0 ff ff       	call   8008c9 <_panic>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 50 08             	mov    0x8(%eax),%edx
  8028b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028b3:	89 50 08             	mov    %edx,0x8(%eax)
  8028b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028b9:	8b 40 08             	mov    0x8(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0c                	je     8028cc <alloc_block_FF+0x136>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 08             	mov    0x8(%eax),%eax
  8028c6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028d2:	89 50 08             	mov    %edx,0x8(%eax)
  8028d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028db:	89 50 0c             	mov    %edx,0xc(%eax)
  8028de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e1:	8b 40 08             	mov    0x8(%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	75 08                	jne    8028f0 <alloc_block_FF+0x15a>
  8028e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028eb:	a3 44 51 90 00       	mov    %eax,0x905144
  8028f0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8028f5:	40                   	inc    %eax
  8028f6:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	8d 50 10             	lea    0x10(%eax),%edx
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	83 c0 10             	add    $0x10,%eax
  802913:	e9 b0 01 00 00       	jmp    802ac8 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802918:	a1 48 51 90 00       	mov    0x905148,%eax
  80291d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802920:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802924:	74 08                	je     80292e <alloc_block_FF+0x198>
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 08             	mov    0x8(%eax),%eax
  80292c:	eb 05                	jmp    802933 <alloc_block_FF+0x19d>
  80292e:	b8 00 00 00 00       	mov    $0x0,%eax
  802933:	a3 48 51 90 00       	mov    %eax,0x905148
  802938:	a1 48 51 90 00       	mov    0x905148,%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	0f 85 bd fe ff ff    	jne    802802 <alloc_block_FF+0x6c>
  802945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802949:	0f 85 b3 fe ff ff    	jne    802802 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	83 c0 10             	add    $0x10,%eax
  802955:	83 ec 0c             	sub    $0xc,%esp
  802958:	50                   	push   %eax
  802959:	e8 43 f2 ff ff       	call   801ba1 <sbrk>
  80295e:	83 c4 10             	add    $0x10,%esp
  802961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	6a 00                	push   $0x0
  802969:	e8 33 f2 ff ff       	call   801ba1 <sbrk>
  80296e:	83 c4 10             	add    $0x10,%esp
  802971:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802974:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297a:	29 c2                	sub    %eax,%edx
  80297c:	89 d0                	mov    %edx,%eax
  80297e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802981:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802985:	0f 84 38 01 00 00    	je     802ac3 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  80298b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  802991:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802995:	75 17                	jne    8029ae <alloc_block_FF+0x218>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 54 42 80 00       	push   $0x804254
  80299f:	68 9f 00 00 00       	push   $0x9f
  8029a4:	68 77 42 80 00       	push   $0x804277
  8029a9:	e8 1b df ff ff       	call   8008c9 <_panic>
  8029ae:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8029b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8029ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 0d                	je     8029d1 <alloc_block_FF+0x23b>
  8029c4:	a1 44 51 90 00       	mov    0x905144,%eax
  8029c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029cc:	89 50 08             	mov    %edx,0x8(%eax)
  8029cf:	eb 08                	jmp    8029d9 <alloc_block_FF+0x243>
  8029d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029d4:	a3 40 51 90 00       	mov    %eax,0x905140
  8029d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029dc:	a3 44 51 90 00       	mov    %eax,0x905144
  8029e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029eb:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8029f0:	40                   	inc    %eax
  8029f1:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	8d 50 10             	lea    0x10(%eax),%edx
  8029fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ff:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802a01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a04:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802a08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0e:	83 f8 10             	cmp    $0x10,%eax
  802a11:	0f 84 a4 00 00 00    	je     802abb <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802a17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1d:	83 e8 10             	sub    $0x10,%eax
  802a20:	83 f8 0f             	cmp    $0xf,%eax
  802a23:	0f 86 8a 00 00 00    	jbe    802ab3 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802a29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2f:	01 d0                	add    %edx,%eax
  802a31:	83 c0 10             	add    $0x10,%eax
  802a34:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802a37:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a3b:	75 17                	jne    802a54 <alloc_block_FF+0x2be>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 54 42 80 00       	push   $0x804254
  802a45:	68 a7 00 00 00       	push   $0xa7
  802a4a:	68 77 42 80 00       	push   $0x804277
  802a4f:	e8 75 de ff ff       	call   8008c9 <_panic>
  802a54:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802a5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a5d:	89 50 0c             	mov    %edx,0xc(%eax)
  802a60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a63:	8b 40 0c             	mov    0xc(%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 0d                	je     802a77 <alloc_block_FF+0x2e1>
  802a6a:	a1 44 51 90 00       	mov    0x905144,%eax
  802a6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a72:	89 50 08             	mov    %edx,0x8(%eax)
  802a75:	eb 08                	jmp    802a7f <alloc_block_FF+0x2e9>
  802a77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a7a:	a3 40 51 90 00       	mov    %eax,0x905140
  802a7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a82:	a3 44 51 90 00       	mov    %eax,0x905144
  802a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a91:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802a96:	40                   	inc    %eax
  802a97:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802a9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a9f:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa2:	8d 50 f0             	lea    -0x10(%eax),%edx
  802aa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa8:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802aaa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aad:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802ab1:	eb 08                	jmp    802abb <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802ab3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ab6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802abb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802abe:	83 c0 10             	add    $0x10,%eax
  802ac1:	eb 05                	jmp    802ac8 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802ac8:	c9                   	leave  
  802ac9:	c3                   	ret    

00802aca <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802aca:	55                   	push   %ebp
  802acb:	89 e5                	mov    %esp,%ebp
  802acd:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802ad0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802ad7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802adb:	75 0a                	jne    802ae7 <alloc_block_BF+0x1d>
	{
		return NULL;
  802add:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae2:	e9 40 02 00 00       	jmp    802d27 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802ae7:	a1 40 51 90 00       	mov    0x905140,%eax
  802aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aef:	eb 66                	jmp    802b57 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8a 40 04             	mov    0x4(%eax),%al
  802af7:	3c 01                	cmp    $0x1,%al
  802af9:	75 21                	jne    802b1c <alloc_block_BF+0x52>
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8d 50 10             	lea    0x10(%eax),%edx
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	39 c2                	cmp    %eax,%edx
  802b08:	75 12                	jne    802b1c <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	83 c0 10             	add    $0x10,%eax
  802b17:	e9 0b 02 00 00       	jmp    802d27 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8a 40 04             	mov    0x4(%eax),%al
  802b22:	3c 01                	cmp    $0x1,%al
  802b24:	75 29                	jne    802b4f <alloc_block_BF+0x85>
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	8d 50 10             	lea    0x10(%eax),%edx
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	39 c2                	cmp    %eax,%edx
  802b33:	77 1a                	ja     802b4f <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802b35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b39:	74 0e                	je     802b49 <alloc_block_BF+0x7f>
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 10                	mov    (%eax),%edx
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	39 c2                	cmp    %eax,%edx
  802b47:	73 06                	jae    802b4f <alloc_block_BF+0x85>
			{
				BF = iterator;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802b4f:	a1 48 51 90 00       	mov    0x905148,%eax
  802b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5b:	74 08                	je     802b65 <alloc_block_BF+0x9b>
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	eb 05                	jmp    802b6a <alloc_block_BF+0xa0>
  802b65:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6a:	a3 48 51 90 00       	mov    %eax,0x905148
  802b6f:	a1 48 51 90 00       	mov    0x905148,%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	0f 85 75 ff ff ff    	jne    802af1 <alloc_block_BF+0x27>
  802b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b80:	0f 85 6b ff ff ff    	jne    802af1 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802b86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8a:	0f 84 f8 00 00 00    	je     802c88 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	8d 50 10             	lea    0x10(%eax),%edx
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	39 c2                	cmp    %eax,%edx
  802b9d:	0f 87 e5 00 00 00    	ja     802c88 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	2b 45 08             	sub    0x8(%ebp),%eax
  802bab:	83 e8 10             	sub    $0x10,%eax
  802bae:	83 f8 0f             	cmp    $0xf,%eax
  802bb1:	0f 86 bf 00 00 00    	jbe    802c76 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	01 d0                	add    %edx,%eax
  802bbf:	83 c0 10             	add    $0x10,%eax
  802bc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd6:	8d 50 f0             	lea    -0x10(%eax),%edx
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be1:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be9:	74 06                	je     802bf1 <alloc_block_BF+0x127>
  802beb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bef:	75 17                	jne    802c08 <alloc_block_BF+0x13e>
  802bf1:	83 ec 04             	sub    $0x4,%esp
  802bf4:	68 90 42 80 00       	push   $0x804290
  802bf9:	68 e3 00 00 00       	push   $0xe3
  802bfe:	68 77 42 80 00       	push   $0x804277
  802c03:	e8 c1 dc ff ff       	call   8008c9 <_panic>
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	8b 50 08             	mov    0x8(%eax),%edx
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	89 50 08             	mov    %edx,0x8(%eax)
  802c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c17:	8b 40 08             	mov    0x8(%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 0c                	je     802c2a <alloc_block_BF+0x160>
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c27:	89 50 0c             	mov    %edx,0xc(%eax)
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c30:	89 50 08             	mov    %edx,0x8(%eax)
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c39:	89 50 0c             	mov    %edx,0xc(%eax)
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	8b 40 08             	mov    0x8(%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	75 08                	jne    802c4e <alloc_block_BF+0x184>
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	a3 44 51 90 00       	mov    %eax,0x905144
  802c4e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802c53:	40                   	inc    %eax
  802c54:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8d 50 10             	lea    0x10(%eax),%edx
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c67:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	83 c0 10             	add    $0x10,%eax
  802c71:	e9 b1 00 00 00       	jmp    802d27 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	83 c0 10             	add    $0x10,%eax
  802c83:	e9 9f 00 00 00       	jmp    802d27 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	83 c0 10             	add    $0x10,%eax
  802c8e:	83 ec 0c             	sub    $0xc,%esp
  802c91:	50                   	push   %eax
  802c92:	e8 0a ef ff ff       	call   801ba1 <sbrk>
  802c97:	83 c4 10             	add    $0x10,%esp
  802c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802c9d:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802ca1:	74 7f                	je     802d22 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802ca3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ca7:	75 17                	jne    802cc0 <alloc_block_BF+0x1f6>
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	68 54 42 80 00       	push   $0x804254
  802cb1:	68 f6 00 00 00       	push   $0xf6
  802cb6:	68 77 42 80 00       	push   $0x804277
  802cbb:	e8 09 dc ff ff       	call   8008c9 <_panic>
  802cc0:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc9:	89 50 0c             	mov    %edx,0xc(%eax)
  802ccc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0d                	je     802ce3 <alloc_block_BF+0x219>
  802cd6:	a1 44 51 90 00       	mov    0x905144,%eax
  802cdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cde:	89 50 08             	mov    %edx,0x8(%eax)
  802ce1:	eb 08                	jmp    802ceb <alloc_block_BF+0x221>
  802ce3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce6:	a3 40 51 90 00       	mov    %eax,0x905140
  802ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cee:	a3 44 51 90 00       	mov    %eax,0x905144
  802cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cfd:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d02:	40                   	inc    %eax
  802d03:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8d 50 10             	lea    0x10(%eax),%edx
  802d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d11:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d16:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1d:	83 c0 10             	add    $0x10,%eax
  802d20:	eb 05                	jmp    802d27 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 c4 42 80 00       	push   $0x8042c4
  802d37:	68 07 01 00 00       	push   $0x107
  802d3c:	68 77 42 80 00       	push   $0x804277
  802d41:	e8 83 db ff ff       	call   8008c9 <_panic>

00802d46 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802d46:	55                   	push   %ebp
  802d47:	89 e5                	mov    %esp,%ebp
  802d49:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802d4c:	83 ec 04             	sub    $0x4,%esp
  802d4f:	68 ec 42 80 00       	push   $0x8042ec
  802d54:	68 0f 01 00 00       	push   $0x10f
  802d59:	68 77 42 80 00       	push   $0x804277
  802d5e:	e8 66 db ff ff       	call   8008c9 <_panic>

00802d63 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6d:	0f 84 ee 05 00 00    	je     803361 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	83 e8 10             	sub    $0x10,%eax
  802d79:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802d7c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802d80:	a1 40 51 90 00       	mov    0x905140,%eax
  802d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d88:	eb 16                	jmp    802da0 <free_block+0x3d>
	{
		if (block_pointer == it)
  802d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d90:	75 06                	jne    802d98 <free_block+0x35>
		{
			flagx = 1;
  802d92:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802d96:	eb 2f                	jmp    802dc7 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802d98:	a1 48 51 90 00       	mov    0x905148,%eax
  802d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802da0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da4:	74 08                	je     802dae <free_block+0x4b>
  802da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da9:	8b 40 08             	mov    0x8(%eax),%eax
  802dac:	eb 05                	jmp    802db3 <free_block+0x50>
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	a3 48 51 90 00       	mov    %eax,0x905148
  802db8:	a1 48 51 90 00       	mov    0x905148,%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	75 c9                	jne    802d8a <free_block+0x27>
  802dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc5:	75 c3                	jne    802d8a <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802dc7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802dcb:	0f 84 93 05 00 00    	je     803364 <free_block+0x601>
		return;
	if (va == NULL)
  802dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd5:	0f 84 8c 05 00 00    	je     803367 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de7:	8b 40 08             	mov    0x8(%eax),%eax
  802dea:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802ded:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802df1:	75 12                	jne    802e05 <free_block+0xa2>
  802df3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802df7:	75 0c                	jne    802e05 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e00:	e9 63 05 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802e05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e09:	0f 85 ca 00 00 00    	jne    802ed9 <free_block+0x176>
  802e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e12:	8a 40 04             	mov    0x4(%eax),%al
  802e15:	3c 01                	cmp    $0x1,%al
  802e17:	0f 85 bc 00 00 00    	jne    802ed9 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e20:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e27:	8b 10                	mov    (%eax),%edx
  802e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e33:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e41:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802e45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e49:	75 17                	jne    802e62 <free_block+0xff>
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	68 12 43 80 00       	push   $0x804312
  802e53:	68 3c 01 00 00       	push   $0x13c
  802e58:	68 77 42 80 00       	push   $0x804277
  802e5d:	e8 67 da ff ff       	call   8008c9 <_panic>
  802e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 11                	je     802e7d <free_block+0x11a>
  802e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e75:	8b 52 0c             	mov    0xc(%edx),%edx
  802e78:	89 50 0c             	mov    %edx,0xc(%eax)
  802e7b:	eb 0b                	jmp    802e88 <free_block+0x125>
  802e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	a3 44 51 90 00       	mov    %eax,0x905144
  802e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 11                	je     802ea3 <free_block+0x140>
  802e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e95:	8b 40 0c             	mov    0xc(%eax),%eax
  802e98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e9b:	8b 52 08             	mov    0x8(%edx),%edx
  802e9e:	89 50 08             	mov    %edx,0x8(%eax)
  802ea1:	eb 0b                	jmp    802eae <free_block+0x14b>
  802ea3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	a3 40 51 90 00       	mov    %eax,0x905140
  802eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ec2:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ec7:	48                   	dec    %eax
  802ec8:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802ecd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802ed4:	e9 8f 04 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802ed9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802edd:	75 16                	jne    802ef5 <free_block+0x192>
  802edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee2:	8a 40 04             	mov    0x4(%eax),%al
  802ee5:	84 c0                	test   %al,%al
  802ee7:	75 0c                	jne    802ef5 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802ef0:	e9 73 04 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802ef5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ef9:	0f 85 c3 00 00 00    	jne    802fc2 <free_block+0x25f>
  802eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f02:	8a 40 04             	mov    0x4(%eax),%al
  802f05:	3c 01                	cmp    $0x1,%al
  802f07:	0f 85 b5 00 00 00    	jne    802fc2 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f10:	8b 10                	mov    (%eax),%edx
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	01 c2                	add    %eax,%edx
  802f19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1c:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802f2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f32:	75 17                	jne    802f4b <free_block+0x1e8>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 12 43 80 00       	push   $0x804312
  802f3c:	68 49 01 00 00       	push   $0x149
  802f41:	68 77 42 80 00       	push   $0x804277
  802f46:	e8 7e d9 ff ff       	call   8008c9 <_panic>
  802f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4e:	8b 40 08             	mov    0x8(%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 11                	je     802f66 <free_block+0x203>
  802f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f5e:	8b 52 0c             	mov    0xc(%edx),%edx
  802f61:	89 50 0c             	mov    %edx,0xc(%eax)
  802f64:	eb 0b                	jmp    802f71 <free_block+0x20e>
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	a3 44 51 90 00       	mov    %eax,0x905144
  802f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 11                	je     802f8c <free_block+0x229>
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f84:	8b 52 08             	mov    0x8(%edx),%edx
  802f87:	89 50 08             	mov    %edx,0x8(%eax)
  802f8a:	eb 0b                	jmp    802f97 <free_block+0x234>
  802f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8f:	8b 40 08             	mov    0x8(%eax),%eax
  802f92:	a3 40 51 90 00       	mov    %eax,0x905140
  802f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fab:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802fb0:	48                   	dec    %eax
  802fb1:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802fb6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802fbd:	e9 a6 03 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802fc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fc6:	75 16                	jne    802fde <free_block+0x27b>
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	8a 40 04             	mov    0x4(%eax),%al
  802fce:	84 c0                	test   %al,%al
  802fd0:	75 0c                	jne    802fde <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802fd9:	e9 8a 03 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802fde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fe2:	0f 84 81 01 00 00    	je     803169 <free_block+0x406>
  802fe8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fec:	0f 84 77 01 00 00    	je     803169 <free_block+0x406>
  802ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff5:	8a 40 04             	mov    0x4(%eax),%al
  802ff8:	3c 01                	cmp    $0x1,%al
  802ffa:	0f 85 69 01 00 00    	jne    803169 <free_block+0x406>
  803000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803003:	8a 40 04             	mov    0x4(%eax),%al
  803006:	3c 01                	cmp    $0x1,%al
  803008:	0f 85 5b 01 00 00    	jne    803169 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	8b 10                	mov    (%eax),%edx
  803013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803016:	8b 08                	mov    (%eax),%ecx
  803018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	01 c8                	add    %ecx,%eax
  80301f:	01 c2                	add    %eax,%edx
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803029:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80302f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803032:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  803036:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803042:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803046:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80304a:	75 17                	jne    803063 <free_block+0x300>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 12 43 80 00       	push   $0x804312
  803054:	68 59 01 00 00       	push   $0x159
  803059:	68 77 42 80 00       	push   $0x804277
  80305e:	e8 66 d8 ff ff       	call   8008c9 <_panic>
  803063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803066:	8b 40 08             	mov    0x8(%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 11                	je     80307e <free_block+0x31b>
  80306d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803070:	8b 40 08             	mov    0x8(%eax),%eax
  803073:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803076:	8b 52 0c             	mov    0xc(%edx),%edx
  803079:	89 50 0c             	mov    %edx,0xc(%eax)
  80307c:	eb 0b                	jmp    803089 <free_block+0x326>
  80307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803081:	8b 40 0c             	mov    0xc(%eax),%eax
  803084:	a3 44 51 90 00       	mov    %eax,0x905144
  803089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308c:	8b 40 0c             	mov    0xc(%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 11                	je     8030a4 <free_block+0x341>
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80309c:	8b 52 08             	mov    0x8(%edx),%edx
  80309f:	89 50 08             	mov    %edx,0x8(%eax)
  8030a2:	eb 0b                	jmp    8030af <free_block+0x34c>
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	8b 40 08             	mov    0x8(%eax),%eax
  8030aa:	a3 40 51 90 00       	mov    %eax,0x905140
  8030af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030c3:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8030c8:	48                   	dec    %eax
  8030c9:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  8030ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030d2:	75 17                	jne    8030eb <free_block+0x388>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 12 43 80 00       	push   $0x804312
  8030dc:	68 5a 01 00 00       	push   $0x15a
  8030e1:	68 77 42 80 00       	push   $0x804277
  8030e6:	e8 de d7 ff ff       	call   8008c9 <_panic>
  8030eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ee:	8b 40 08             	mov    0x8(%eax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	74 11                	je     803106 <free_block+0x3a3>
  8030f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f8:	8b 40 08             	mov    0x8(%eax),%eax
  8030fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030fe:	8b 52 0c             	mov    0xc(%edx),%edx
  803101:	89 50 0c             	mov    %edx,0xc(%eax)
  803104:	eb 0b                	jmp    803111 <free_block+0x3ae>
  803106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803109:	8b 40 0c             	mov    0xc(%eax),%eax
  80310c:	a3 44 51 90 00       	mov    %eax,0x905144
  803111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803114:	8b 40 0c             	mov    0xc(%eax),%eax
  803117:	85 c0                	test   %eax,%eax
  803119:	74 11                	je     80312c <free_block+0x3c9>
  80311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311e:	8b 40 0c             	mov    0xc(%eax),%eax
  803121:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803124:	8b 52 08             	mov    0x8(%edx),%edx
  803127:	89 50 08             	mov    %edx,0x8(%eax)
  80312a:	eb 0b                	jmp    803137 <free_block+0x3d4>
  80312c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312f:	8b 40 08             	mov    0x8(%eax),%eax
  803132:	a3 40 51 90 00       	mov    %eax,0x905140
  803137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803144:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80314b:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803150:	48                   	dec    %eax
  803151:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803156:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  80315d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803164:	e9 ff 01 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803169:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80316d:	0f 84 db 00 00 00    	je     80324e <free_block+0x4eb>
  803173:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803177:	0f 84 d1 00 00 00    	je     80324e <free_block+0x4eb>
  80317d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803180:	8a 40 04             	mov    0x4(%eax),%al
  803183:	84 c0                	test   %al,%al
  803185:	0f 85 c3 00 00 00    	jne    80324e <free_block+0x4eb>
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8a 40 04             	mov    0x4(%eax),%al
  803191:	3c 01                	cmp    $0x1,%al
  803193:	0f 85 b5 00 00 00    	jne    80324e <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  803199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319c:	8b 10                	mov    (%eax),%edx
  80319e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	01 c2                	add    %eax,%edx
  8031a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a8:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8031aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8031b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8031ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031be:	75 17                	jne    8031d7 <free_block+0x474>
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	68 12 43 80 00       	push   $0x804312
  8031c8:	68 64 01 00 00       	push   $0x164
  8031cd:	68 77 42 80 00       	push   $0x804277
  8031d2:	e8 f2 d6 ff ff       	call   8008c9 <_panic>
  8031d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031da:	8b 40 08             	mov    0x8(%eax),%eax
  8031dd:	85 c0                	test   %eax,%eax
  8031df:	74 11                	je     8031f2 <free_block+0x48f>
  8031e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031ea:	8b 52 0c             	mov    0xc(%edx),%edx
  8031ed:	89 50 0c             	mov    %edx,0xc(%eax)
  8031f0:	eb 0b                	jmp    8031fd <free_block+0x49a>
  8031f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f8:	a3 44 51 90 00       	mov    %eax,0x905144
  8031fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803200:	8b 40 0c             	mov    0xc(%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 11                	je     803218 <free_block+0x4b5>
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	8b 40 0c             	mov    0xc(%eax),%eax
  80320d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803210:	8b 52 08             	mov    0x8(%edx),%edx
  803213:	89 50 08             	mov    %edx,0x8(%eax)
  803216:	eb 0b                	jmp    803223 <free_block+0x4c0>
  803218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321b:	8b 40 08             	mov    0x8(%eax),%eax
  80321e:	a3 40 51 90 00       	mov    %eax,0x905140
  803223:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803226:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80322d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803230:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803237:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80323c:	48                   	dec    %eax
  80323d:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803242:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803249:	e9 1a 01 00 00       	jmp    803368 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  80324e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803252:	0f 84 df 00 00 00    	je     803337 <free_block+0x5d4>
  803258:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80325c:	0f 84 d5 00 00 00    	je     803337 <free_block+0x5d4>
  803262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803265:	8a 40 04             	mov    0x4(%eax),%al
  803268:	3c 01                	cmp    $0x1,%al
  80326a:	0f 85 c7 00 00 00    	jne    803337 <free_block+0x5d4>
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	8a 40 04             	mov    0x4(%eax),%al
  803276:	84 c0                	test   %al,%al
  803278:	0f 85 b9 00 00 00    	jne    803337 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  80327e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803281:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803288:	8b 10                	mov    (%eax),%edx
  80328a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	01 c2                	add    %eax,%edx
  803291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803294:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80329f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8032a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032aa:	75 17                	jne    8032c3 <free_block+0x560>
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 12 43 80 00       	push   $0x804312
  8032b4:	68 6e 01 00 00       	push   $0x16e
  8032b9:	68 77 42 80 00       	push   $0x804277
  8032be:	e8 06 d6 ff ff       	call   8008c9 <_panic>
  8032c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c6:	8b 40 08             	mov    0x8(%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 11                	je     8032de <free_block+0x57b>
  8032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d0:	8b 40 08             	mov    0x8(%eax),%eax
  8032d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032d6:	8b 52 0c             	mov    0xc(%edx),%edx
  8032d9:	89 50 0c             	mov    %edx,0xc(%eax)
  8032dc:	eb 0b                	jmp    8032e9 <free_block+0x586>
  8032de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e4:	a3 44 51 90 00       	mov    %eax,0x905144
  8032e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	74 11                	je     803304 <free_block+0x5a1>
  8032f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032fc:	8b 52 08             	mov    0x8(%edx),%edx
  8032ff:	89 50 08             	mov    %edx,0x8(%eax)
  803302:	eb 0b                	jmp    80330f <free_block+0x5ac>
  803304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803307:	8b 40 08             	mov    0x8(%eax),%eax
  80330a:	a3 40 51 90 00       	mov    %eax,0x905140
  80330f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803312:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803323:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803328:	48                   	dec    %eax
  803329:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80332e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803335:	eb 31                	jmp    803368 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803337:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80333b:	74 2b                	je     803368 <free_block+0x605>
  80333d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803341:	74 25                	je     803368 <free_block+0x605>
  803343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803346:	8a 40 04             	mov    0x4(%eax),%al
  803349:	84 c0                	test   %al,%al
  80334b:	75 1b                	jne    803368 <free_block+0x605>
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8a 40 04             	mov    0x4(%eax),%al
  803353:	84 c0                	test   %al,%al
  803355:	75 11                	jne    803368 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80335e:	90                   	nop
  80335f:	eb 07                	jmp    803368 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803361:	90                   	nop
  803362:	eb 04                	jmp    803368 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803364:	90                   	nop
  803365:	eb 01                	jmp    803368 <free_block+0x605>
	if (va == NULL)
		return;
  803367:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803368:	c9                   	leave  
  803369:	c3                   	ret    

0080336a <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  80336a:	55                   	push   %ebp
  80336b:	89 e5                	mov    %esp,%ebp
  80336d:	57                   	push   %edi
  80336e:	56                   	push   %esi
  80336f:	53                   	push   %ebx
  803370:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803373:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803377:	75 19                	jne    803392 <realloc_block_FF+0x28>
  803379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80337d:	74 13                	je     803392 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  80337f:	83 ec 0c             	sub    $0xc,%esp
  803382:	ff 75 0c             	pushl  0xc(%ebp)
  803385:	e8 0c f4 ff ff       	call   802796 <alloc_block_FF>
  80338a:	83 c4 10             	add    $0x10,%esp
  80338d:	e9 84 03 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  803392:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803396:	75 3b                	jne    8033d3 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  803398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339c:	75 17                	jne    8033b5 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	6a 00                	push   $0x0
  8033a3:	e8 ee f3 ff ff       	call   802796 <alloc_block_FF>
  8033a8:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b0:	e9 61 03 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  8033b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b9:	74 18                	je     8033d3 <realloc_block_FF+0x69>
		{
			free_block(va);
  8033bb:	83 ec 0c             	sub    $0xc,%esp
  8033be:	ff 75 08             	pushl  0x8(%ebp)
  8033c1:	e8 9d f9 ff ff       	call   802d63 <free_block>
  8033c6:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ce:	e9 43 03 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  8033d3:	a1 40 51 90 00       	mov    0x905140,%eax
  8033d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8033db:	e9 02 03 00 00       	jmp    8036e2 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	83 e8 10             	sub    $0x10,%eax
  8033e6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033e9:	0f 85 eb 02 00 00    	jne    8036da <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033f7:	83 c2 10             	add    $0x10,%edx
  8033fa:	39 d0                	cmp    %edx,%eax
  8033fc:	75 08                	jne    803406 <realloc_block_FF+0x9c>
			{
				return va;
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	e9 10 03 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80340e:	0f 83 e0 01 00 00    	jae    8035f4 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803417:	8b 40 08             	mov    0x8(%eax),%eax
  80341a:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  80341d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803420:	8a 40 04             	mov    0x4(%eax),%al
  803423:	3c 01                	cmp    $0x1,%al
  803425:	0f 85 06 01 00 00    	jne    803531 <realloc_block_FF+0x1c7>
  80342b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342e:	8b 10                	mov    (%eax),%edx
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803438:	29 c1                	sub    %eax,%ecx
  80343a:	89 c8                	mov    %ecx,%eax
  80343c:	39 c2                	cmp    %eax,%edx
  80343e:	0f 86 ed 00 00 00    	jbe    803531 <realloc_block_FF+0x1c7>
  803444:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803448:	0f 84 e3 00 00 00    	je     803531 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  80344e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803451:	8b 10                	mov    (%eax),%edx
  803453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	2b 45 0c             	sub    0xc(%ebp),%eax
  80345b:	01 d0                	add    %edx,%eax
  80345d:	83 f8 0f             	cmp    $0xf,%eax
  803460:	0f 86 b5 00 00 00    	jbe    80351b <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803466:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346c:	01 d0                	add    %edx,%eax
  80346e:	83 c0 10             	add    $0x10,%eax
  803471:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803474:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  80347d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803480:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803484:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803488:	74 06                	je     803490 <realloc_block_FF+0x126>
  80348a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80348e:	75 17                	jne    8034a7 <realloc_block_FF+0x13d>
  803490:	83 ec 04             	sub    $0x4,%esp
  803493:	68 90 42 80 00       	push   $0x804290
  803498:	68 ad 01 00 00       	push   $0x1ad
  80349d:	68 77 42 80 00       	push   $0x804277
  8034a2:	e8 22 d4 ff ff       	call   8008c9 <_panic>
  8034a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034aa:	8b 50 08             	mov    0x8(%eax),%edx
  8034ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b0:	89 50 08             	mov    %edx,0x8(%eax)
  8034b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b6:	8b 40 08             	mov    0x8(%eax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	74 0c                	je     8034c9 <realloc_block_FF+0x15f>
  8034bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c0:	8b 40 08             	mov    0x8(%eax),%eax
  8034c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034cf:	89 50 08             	mov    %edx,0x8(%eax)
  8034d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034d8:	89 50 0c             	mov    %edx,0xc(%eax)
  8034db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034de:	8b 40 08             	mov    0x8(%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	75 08                	jne    8034ed <realloc_block_FF+0x183>
  8034e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e8:	a3 44 51 90 00       	mov    %eax,0x905144
  8034ed:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8034f2:	40                   	inc    %eax
  8034f3:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  8034f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  803501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803504:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  803508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350b:	8d 50 10             	lea    0x10(%eax),%edx
  80350e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803511:	89 10                	mov    %edx,(%eax)
						return va;
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	e9 fb 01 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  80351b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351e:	8d 50 10             	lea    0x10(%eax),%edx
  803521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803524:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  803526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803529:	83 c0 10             	add    $0x10,%eax
  80352c:	e9 e5 01 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803531:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803534:	8a 40 04             	mov    0x4(%eax),%al
  803537:	3c 01                	cmp    $0x1,%al
  803539:	75 59                	jne    803594 <realloc_block_FF+0x22a>
  80353b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80353e:	8b 10                	mov    (%eax),%edx
  803540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803543:	8b 00                	mov    (%eax),%eax
  803545:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803548:	29 c1                	sub    %eax,%ecx
  80354a:	89 c8                	mov    %ecx,%eax
  80354c:	39 c2                	cmp    %eax,%edx
  80354e:	75 44                	jne    803594 <realloc_block_FF+0x22a>
  803550:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803554:	74 3e                	je     803594 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803559:	8b 40 08             	mov    0x8(%eax),%eax
  80355c:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  80355f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803562:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803565:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803568:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80356b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356e:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  80357a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803581:	8b 45 0c             	mov    0xc(%ebp),%eax
  803584:	8d 50 10             	lea    0x10(%eax),%edx
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	89 10                	mov    %edx,(%eax)
					return va;
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	e9 82 01 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803597:	8a 40 04             	mov    0x4(%eax),%al
  80359a:	84 c0                	test   %al,%al
  80359c:	74 0a                	je     8035a8 <realloc_block_FF+0x23e>
  80359e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035a2:	0f 85 32 01 00 00    	jne    8036da <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  8035a8:	83 ec 0c             	sub    $0xc,%esp
  8035ab:	ff 75 0c             	pushl  0xc(%ebp)
  8035ae:	e8 e3 f1 ff ff       	call   802796 <alloc_block_FF>
  8035b3:	83 c4 10             	add    $0x10,%esp
  8035b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  8035b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035bd:	74 2b                	je     8035ea <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  8035bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	89 c3                	mov    %eax,%ebx
  8035c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8035cc:	89 d7                	mov    %edx,%edi
  8035ce:	89 de                	mov    %ebx,%esi
  8035d0:	89 c1                	mov    %eax,%ecx
  8035d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  8035d4:	83 ec 0c             	sub    $0xc,%esp
  8035d7:	ff 75 08             	pushl  0x8(%ebp)
  8035da:	e8 84 f7 ff ff       	call   802d63 <free_block>
  8035df:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  8035e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e5:	e9 2c 01 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  8035ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8035ef:	e9 22 01 00 00       	jmp    803716 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  8035f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f7:	8b 00                	mov    (%eax),%eax
  8035f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035fc:	0f 86 d8 00 00 00    	jbe    8036da <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	2b 45 0c             	sub    0xc(%ebp),%eax
  80360a:	83 f8 0f             	cmp    $0xf,%eax
  80360d:	0f 86 b4 00 00 00    	jbe    8036c7 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803613:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803616:	8b 45 0c             	mov    0xc(%ebp),%eax
  803619:	01 d0                	add    %edx,%eax
  80361b:	83 c0 10             	add    $0x10,%eax
  80361e:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	2b 45 0c             	sub    0xc(%ebp),%eax
  803629:	8d 50 f0             	lea    -0x10(%eax),%edx
  80362c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80362f:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803631:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803635:	74 06                	je     80363d <realloc_block_FF+0x2d3>
  803637:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80363b:	75 17                	jne    803654 <realloc_block_FF+0x2ea>
  80363d:	83 ec 04             	sub    $0x4,%esp
  803640:	68 90 42 80 00       	push   $0x804290
  803645:	68 dd 01 00 00       	push   $0x1dd
  80364a:	68 77 42 80 00       	push   $0x804277
  80364f:	e8 75 d2 ff ff       	call   8008c9 <_panic>
  803654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803657:	8b 50 08             	mov    0x8(%eax),%edx
  80365a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80365d:	89 50 08             	mov    %edx,0x8(%eax)
  803660:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803663:	8b 40 08             	mov    0x8(%eax),%eax
  803666:	85 c0                	test   %eax,%eax
  803668:	74 0c                	je     803676 <realloc_block_FF+0x30c>
  80366a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366d:	8b 40 08             	mov    0x8(%eax),%eax
  803670:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803673:	89 50 0c             	mov    %edx,0xc(%eax)
  803676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803679:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80367c:	89 50 08             	mov    %edx,0x8(%eax)
  80367f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803685:	89 50 0c             	mov    %edx,0xc(%eax)
  803688:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80368b:	8b 40 08             	mov    0x8(%eax),%eax
  80368e:	85 c0                	test   %eax,%eax
  803690:	75 08                	jne    80369a <realloc_block_FF+0x330>
  803692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803695:	a3 44 51 90 00       	mov    %eax,0x905144
  80369a:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80369f:	40                   	inc    %eax
  8036a0:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  8036a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036a8:	83 c0 10             	add    $0x10,%eax
  8036ab:	83 ec 0c             	sub    $0xc,%esp
  8036ae:	50                   	push   %eax
  8036af:	e8 af f6 ff ff       	call   802d63 <free_block>
  8036b4:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  8036b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ba:	8d 50 10             	lea    0x10(%eax),%edx
  8036bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c0:	89 10                	mov    %edx,(%eax)
					return va;
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	eb 4f                	jmp    803716 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  8036c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ca:	8d 50 10             	lea    0x10(%eax),%edx
  8036cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d0:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  8036d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d5:	83 c0 10             	add    $0x10,%eax
  8036d8:	eb 3c                	jmp    803716 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  8036da:	a1 48 51 90 00       	mov    0x905148,%eax
  8036df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8036e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036e6:	74 08                	je     8036f0 <realloc_block_FF+0x386>
  8036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036eb:	8b 40 08             	mov    0x8(%eax),%eax
  8036ee:	eb 05                	jmp    8036f5 <realloc_block_FF+0x38b>
  8036f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f5:	a3 48 51 90 00       	mov    %eax,0x905148
  8036fa:	a1 48 51 90 00       	mov    0x905148,%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	0f 85 d9 fc ff ff    	jne    8033e0 <realloc_block_FF+0x76>
  803707:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80370b:	0f 85 cf fc ff ff    	jne    8033e0 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803716:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803719:	5b                   	pop    %ebx
  80371a:	5e                   	pop    %esi
  80371b:	5f                   	pop    %edi
  80371c:	5d                   	pop    %ebp
  80371d:	c3                   	ret    
  80371e:	66 90                	xchg   %ax,%ax

00803720 <__udivdi3>:
  803720:	55                   	push   %ebp
  803721:	57                   	push   %edi
  803722:	56                   	push   %esi
  803723:	53                   	push   %ebx
  803724:	83 ec 1c             	sub    $0x1c,%esp
  803727:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80372b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80372f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803733:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803737:	89 ca                	mov    %ecx,%edx
  803739:	89 f8                	mov    %edi,%eax
  80373b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80373f:	85 f6                	test   %esi,%esi
  803741:	75 2d                	jne    803770 <__udivdi3+0x50>
  803743:	39 cf                	cmp    %ecx,%edi
  803745:	77 65                	ja     8037ac <__udivdi3+0x8c>
  803747:	89 fd                	mov    %edi,%ebp
  803749:	85 ff                	test   %edi,%edi
  80374b:	75 0b                	jne    803758 <__udivdi3+0x38>
  80374d:	b8 01 00 00 00       	mov    $0x1,%eax
  803752:	31 d2                	xor    %edx,%edx
  803754:	f7 f7                	div    %edi
  803756:	89 c5                	mov    %eax,%ebp
  803758:	31 d2                	xor    %edx,%edx
  80375a:	89 c8                	mov    %ecx,%eax
  80375c:	f7 f5                	div    %ebp
  80375e:	89 c1                	mov    %eax,%ecx
  803760:	89 d8                	mov    %ebx,%eax
  803762:	f7 f5                	div    %ebp
  803764:	89 cf                	mov    %ecx,%edi
  803766:	89 fa                	mov    %edi,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	39 ce                	cmp    %ecx,%esi
  803772:	77 28                	ja     80379c <__udivdi3+0x7c>
  803774:	0f bd fe             	bsr    %esi,%edi
  803777:	83 f7 1f             	xor    $0x1f,%edi
  80377a:	75 40                	jne    8037bc <__udivdi3+0x9c>
  80377c:	39 ce                	cmp    %ecx,%esi
  80377e:	72 0a                	jb     80378a <__udivdi3+0x6a>
  803780:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803784:	0f 87 9e 00 00 00    	ja     803828 <__udivdi3+0x108>
  80378a:	b8 01 00 00 00       	mov    $0x1,%eax
  80378f:	89 fa                	mov    %edi,%edx
  803791:	83 c4 1c             	add    $0x1c,%esp
  803794:	5b                   	pop    %ebx
  803795:	5e                   	pop    %esi
  803796:	5f                   	pop    %edi
  803797:	5d                   	pop    %ebp
  803798:	c3                   	ret    
  803799:	8d 76 00             	lea    0x0(%esi),%esi
  80379c:	31 ff                	xor    %edi,%edi
  80379e:	31 c0                	xor    %eax,%eax
  8037a0:	89 fa                	mov    %edi,%edx
  8037a2:	83 c4 1c             	add    $0x1c,%esp
  8037a5:	5b                   	pop    %ebx
  8037a6:	5e                   	pop    %esi
  8037a7:	5f                   	pop    %edi
  8037a8:	5d                   	pop    %ebp
  8037a9:	c3                   	ret    
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	89 d8                	mov    %ebx,%eax
  8037ae:	f7 f7                	div    %edi
  8037b0:	31 ff                	xor    %edi,%edi
  8037b2:	89 fa                	mov    %edi,%edx
  8037b4:	83 c4 1c             	add    $0x1c,%esp
  8037b7:	5b                   	pop    %ebx
  8037b8:	5e                   	pop    %esi
  8037b9:	5f                   	pop    %edi
  8037ba:	5d                   	pop    %ebp
  8037bb:	c3                   	ret    
  8037bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037c1:	89 eb                	mov    %ebp,%ebx
  8037c3:	29 fb                	sub    %edi,%ebx
  8037c5:	89 f9                	mov    %edi,%ecx
  8037c7:	d3 e6                	shl    %cl,%esi
  8037c9:	89 c5                	mov    %eax,%ebp
  8037cb:	88 d9                	mov    %bl,%cl
  8037cd:	d3 ed                	shr    %cl,%ebp
  8037cf:	89 e9                	mov    %ebp,%ecx
  8037d1:	09 f1                	or     %esi,%ecx
  8037d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037d7:	89 f9                	mov    %edi,%ecx
  8037d9:	d3 e0                	shl    %cl,%eax
  8037db:	89 c5                	mov    %eax,%ebp
  8037dd:	89 d6                	mov    %edx,%esi
  8037df:	88 d9                	mov    %bl,%cl
  8037e1:	d3 ee                	shr    %cl,%esi
  8037e3:	89 f9                	mov    %edi,%ecx
  8037e5:	d3 e2                	shl    %cl,%edx
  8037e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037eb:	88 d9                	mov    %bl,%cl
  8037ed:	d3 e8                	shr    %cl,%eax
  8037ef:	09 c2                	or     %eax,%edx
  8037f1:	89 d0                	mov    %edx,%eax
  8037f3:	89 f2                	mov    %esi,%edx
  8037f5:	f7 74 24 0c          	divl   0xc(%esp)
  8037f9:	89 d6                	mov    %edx,%esi
  8037fb:	89 c3                	mov    %eax,%ebx
  8037fd:	f7 e5                	mul    %ebp
  8037ff:	39 d6                	cmp    %edx,%esi
  803801:	72 19                	jb     80381c <__udivdi3+0xfc>
  803803:	74 0b                	je     803810 <__udivdi3+0xf0>
  803805:	89 d8                	mov    %ebx,%eax
  803807:	31 ff                	xor    %edi,%edi
  803809:	e9 58 ff ff ff       	jmp    803766 <__udivdi3+0x46>
  80380e:	66 90                	xchg   %ax,%ax
  803810:	8b 54 24 08          	mov    0x8(%esp),%edx
  803814:	89 f9                	mov    %edi,%ecx
  803816:	d3 e2                	shl    %cl,%edx
  803818:	39 c2                	cmp    %eax,%edx
  80381a:	73 e9                	jae    803805 <__udivdi3+0xe5>
  80381c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80381f:	31 ff                	xor    %edi,%edi
  803821:	e9 40 ff ff ff       	jmp    803766 <__udivdi3+0x46>
  803826:	66 90                	xchg   %ax,%ax
  803828:	31 c0                	xor    %eax,%eax
  80382a:	e9 37 ff ff ff       	jmp    803766 <__udivdi3+0x46>
  80382f:	90                   	nop

00803830 <__umoddi3>:
  803830:	55                   	push   %ebp
  803831:	57                   	push   %edi
  803832:	56                   	push   %esi
  803833:	53                   	push   %ebx
  803834:	83 ec 1c             	sub    $0x1c,%esp
  803837:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80383b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80383f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803843:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803847:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80384b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80384f:	89 f3                	mov    %esi,%ebx
  803851:	89 fa                	mov    %edi,%edx
  803853:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803857:	89 34 24             	mov    %esi,(%esp)
  80385a:	85 c0                	test   %eax,%eax
  80385c:	75 1a                	jne    803878 <__umoddi3+0x48>
  80385e:	39 f7                	cmp    %esi,%edi
  803860:	0f 86 a2 00 00 00    	jbe    803908 <__umoddi3+0xd8>
  803866:	89 c8                	mov    %ecx,%eax
  803868:	89 f2                	mov    %esi,%edx
  80386a:	f7 f7                	div    %edi
  80386c:	89 d0                	mov    %edx,%eax
  80386e:	31 d2                	xor    %edx,%edx
  803870:	83 c4 1c             	add    $0x1c,%esp
  803873:	5b                   	pop    %ebx
  803874:	5e                   	pop    %esi
  803875:	5f                   	pop    %edi
  803876:	5d                   	pop    %ebp
  803877:	c3                   	ret    
  803878:	39 f0                	cmp    %esi,%eax
  80387a:	0f 87 ac 00 00 00    	ja     80392c <__umoddi3+0xfc>
  803880:	0f bd e8             	bsr    %eax,%ebp
  803883:	83 f5 1f             	xor    $0x1f,%ebp
  803886:	0f 84 ac 00 00 00    	je     803938 <__umoddi3+0x108>
  80388c:	bf 20 00 00 00       	mov    $0x20,%edi
  803891:	29 ef                	sub    %ebp,%edi
  803893:	89 fe                	mov    %edi,%esi
  803895:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803899:	89 e9                	mov    %ebp,%ecx
  80389b:	d3 e0                	shl    %cl,%eax
  80389d:	89 d7                	mov    %edx,%edi
  80389f:	89 f1                	mov    %esi,%ecx
  8038a1:	d3 ef                	shr    %cl,%edi
  8038a3:	09 c7                	or     %eax,%edi
  8038a5:	89 e9                	mov    %ebp,%ecx
  8038a7:	d3 e2                	shl    %cl,%edx
  8038a9:	89 14 24             	mov    %edx,(%esp)
  8038ac:	89 d8                	mov    %ebx,%eax
  8038ae:	d3 e0                	shl    %cl,%eax
  8038b0:	89 c2                	mov    %eax,%edx
  8038b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b6:	d3 e0                	shl    %cl,%eax
  8038b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038c0:	89 f1                	mov    %esi,%ecx
  8038c2:	d3 e8                	shr    %cl,%eax
  8038c4:	09 d0                	or     %edx,%eax
  8038c6:	d3 eb                	shr    %cl,%ebx
  8038c8:	89 da                	mov    %ebx,%edx
  8038ca:	f7 f7                	div    %edi
  8038cc:	89 d3                	mov    %edx,%ebx
  8038ce:	f7 24 24             	mull   (%esp)
  8038d1:	89 c6                	mov    %eax,%esi
  8038d3:	89 d1                	mov    %edx,%ecx
  8038d5:	39 d3                	cmp    %edx,%ebx
  8038d7:	0f 82 87 00 00 00    	jb     803964 <__umoddi3+0x134>
  8038dd:	0f 84 91 00 00 00    	je     803974 <__umoddi3+0x144>
  8038e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038e7:	29 f2                	sub    %esi,%edx
  8038e9:	19 cb                	sbb    %ecx,%ebx
  8038eb:	89 d8                	mov    %ebx,%eax
  8038ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038f1:	d3 e0                	shl    %cl,%eax
  8038f3:	89 e9                	mov    %ebp,%ecx
  8038f5:	d3 ea                	shr    %cl,%edx
  8038f7:	09 d0                	or     %edx,%eax
  8038f9:	89 e9                	mov    %ebp,%ecx
  8038fb:	d3 eb                	shr    %cl,%ebx
  8038fd:	89 da                	mov    %ebx,%edx
  8038ff:	83 c4 1c             	add    $0x1c,%esp
  803902:	5b                   	pop    %ebx
  803903:	5e                   	pop    %esi
  803904:	5f                   	pop    %edi
  803905:	5d                   	pop    %ebp
  803906:	c3                   	ret    
  803907:	90                   	nop
  803908:	89 fd                	mov    %edi,%ebp
  80390a:	85 ff                	test   %edi,%edi
  80390c:	75 0b                	jne    803919 <__umoddi3+0xe9>
  80390e:	b8 01 00 00 00       	mov    $0x1,%eax
  803913:	31 d2                	xor    %edx,%edx
  803915:	f7 f7                	div    %edi
  803917:	89 c5                	mov    %eax,%ebp
  803919:	89 f0                	mov    %esi,%eax
  80391b:	31 d2                	xor    %edx,%edx
  80391d:	f7 f5                	div    %ebp
  80391f:	89 c8                	mov    %ecx,%eax
  803921:	f7 f5                	div    %ebp
  803923:	89 d0                	mov    %edx,%eax
  803925:	e9 44 ff ff ff       	jmp    80386e <__umoddi3+0x3e>
  80392a:	66 90                	xchg   %ax,%ax
  80392c:	89 c8                	mov    %ecx,%eax
  80392e:	89 f2                	mov    %esi,%edx
  803930:	83 c4 1c             	add    $0x1c,%esp
  803933:	5b                   	pop    %ebx
  803934:	5e                   	pop    %esi
  803935:	5f                   	pop    %edi
  803936:	5d                   	pop    %ebp
  803937:	c3                   	ret    
  803938:	3b 04 24             	cmp    (%esp),%eax
  80393b:	72 06                	jb     803943 <__umoddi3+0x113>
  80393d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803941:	77 0f                	ja     803952 <__umoddi3+0x122>
  803943:	89 f2                	mov    %esi,%edx
  803945:	29 f9                	sub    %edi,%ecx
  803947:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80394b:	89 14 24             	mov    %edx,(%esp)
  80394e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803952:	8b 44 24 04          	mov    0x4(%esp),%eax
  803956:	8b 14 24             	mov    (%esp),%edx
  803959:	83 c4 1c             	add    $0x1c,%esp
  80395c:	5b                   	pop    %ebx
  80395d:	5e                   	pop    %esi
  80395e:	5f                   	pop    %edi
  80395f:	5d                   	pop    %ebp
  803960:	c3                   	ret    
  803961:	8d 76 00             	lea    0x0(%esi),%esi
  803964:	2b 04 24             	sub    (%esp),%eax
  803967:	19 fa                	sbb    %edi,%edx
  803969:	89 d1                	mov    %edx,%ecx
  80396b:	89 c6                	mov    %eax,%esi
  80396d:	e9 71 ff ff ff       	jmp    8038e3 <__umoddi3+0xb3>
  803972:	66 90                	xchg   %ax,%ax
  803974:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803978:	72 ea                	jb     803964 <__umoddi3+0x134>
  80397a:	89 d9                	mov    %ebx,%ecx
  80397c:	e9 62 ff ff ff       	jmp    8038e3 <__umoddi3+0xb3>
