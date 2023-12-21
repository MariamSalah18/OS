
obj/user/tu_sbrk:     file format elf32-i386


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
  800031:	e8 35 07 00 00       	call   80076b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	uint32 kilo = 1024;
  80003e:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	uint32 returned_break;
	int freeFrames;
	int usedDiskPages;
	int WsSize;
	uint32 expectedVAs[5] =
  800045:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
  80004c:	c7 45 b8 00 10 00 80 	movl   $0x80001000,-0x48(%ebp)
	{USER_HEAP_START, \
			USER_HEAP_START + PAGE_SIZE, \
			(USER_HEAP_START + (2*PAGE_SIZE) - 2*kilo), \
  800053:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	29 d0                	sub    %edx,%eax
  80005d:	01 c0                	add    %eax,%eax
  80005f:	2d 00 e0 ff 7f       	sub    $0x7fffe000,%eax
	uint32 kilo = 1024;
	uint32 returned_break;
	int freeFrames;
	int usedDiskPages;
	int WsSize;
	uint32 expectedVAs[5] =
  800064:	89 45 bc             	mov    %eax,-0x44(%ebp)
	{USER_HEAP_START, \
			USER_HEAP_START + PAGE_SIZE, \
			(USER_HEAP_START + (2*PAGE_SIZE) - 2*kilo), \
			((USER_HEAP_START + PAGE_SIZE) - kilo), \
  800067:	b8 00 10 00 80       	mov    $0x80001000,%eax
  80006c:	2b 45 ec             	sub    -0x14(%ebp),%eax
	uint32 kilo = 1024;
	uint32 returned_break;
	int freeFrames;
	int usedDiskPages;
	int WsSize;
	uint32 expectedVAs[5] =
  80006f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800072:	c7 45 c4 00 30 00 80 	movl   $0x80003000,-0x3c(%ebp)
			USER_HEAP_START + PAGE_SIZE, \
			(USER_HEAP_START + (2*PAGE_SIZE) - 2*kilo), \
			((USER_HEAP_START + PAGE_SIZE) - kilo), \
			(USER_HEAP_START + 3*PAGE_SIZE), \
	};
	uint32 expectedWSPagesDeleted = {USER_HEAP_START};
  800079:	c7 45 e8 00 00 00 80 	movl   $0x80000000,-0x18(%ebp)
	int old_eval = 0;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int eval = 0;
  800087:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int found;

	uint32* int_arr2;
	bool is_correct = 1;
  80008e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP A: checking increment with +ve value [increment from aligned segment break] ... \n");
  800095:	83 ec 0c             	sub    $0xc,%esp
  800098:	68 80 37 80 00       	push   $0x803780
  80009d:	e8 cb 08 00 00       	call   80096d <cprintf>
  8000a2:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = (int)sys_calculate_free_frames();
  8000a5:	e8 0d 1b 00 00       	call   801bb7 <sys_calculate_free_frames>
  8000aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000ad:	e8 50 1b 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  8000b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		WsSize = LIST_SIZE(&(myEnv->page_WS_list));
  8000b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ba:	8b 80 d8 00 00 00    	mov    0xd8(%eax),%eax
  8000c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32* int_arr = malloc(512 * sizeof(uint32));
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 00 08 00 00       	push   $0x800
  8000cb:	e8 c8 16 00 00       	call   801798 <malloc>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int_arr[0] = 500;
  8000d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000d9:	c7 00 f4 01 00 00    	movl   $0x1f4,(%eax)
		if (((uint32)int_arr - sizeOfMetaData())!=expectedVAs[0])
  8000df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000e2:	8d 50 f0             	lea    -0x10(%eax),%edx
  8000e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8000e8:	39 c2                	cmp    %eax,%edx
  8000ea:	74 22                	je     80010e <_main+0xd6>
		{ is_correct = 0; cprintf("Wrong returned break: Expected: %x, Actual: %x\n", expectedVAs[0], ((uint32)int_arr - sizeOfMetaData()));}
  8000ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000f6:	8d 50 f0             	lea    -0x10(%eax),%edx
  8000f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	52                   	push   %edx
  800100:	50                   	push   %eax
  800101:	68 d8 37 80 00       	push   $0x8037d8
  800106:	e8 62 08 00 00       	call   80096d <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

		if ((freeFrames - (int)sys_calculate_free_frames())!=2) /* Two frames were allocated for page table creation + first page for block allocator*/
  80010e:	e8 a4 1a 00 00       	call   801bb7 <sys_calculate_free_frames>
  800113:	89 c2                	mov    %eax,%edx
  800115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800118:	29 d0                	sub    %edx,%eax
  80011a:	83 f8 02             	cmp    $0x2,%eax
  80011d:	74 26                	je     800145 <_main+0x10d>
		{ is_correct = 0; cprintf("Wrong free frames count: allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", 1, (freeFrames - (int)sys_calculate_free_frames()));}
  80011f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800126:	e8 8c 1a 00 00       	call   801bb7 <sys_calculate_free_frames>
  80012b:	89 c2                	mov    %eax,%edx
  80012d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800130:	29 d0                	sub    %edx,%eax
  800132:	83 ec 04             	sub    $0x4,%esp
  800135:	50                   	push   %eax
  800136:	6a 01                	push   $0x1
  800138:	68 08 38 80 00       	push   $0x803808
  80013d:	e8 2b 08 00 00       	call   80096d <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp

		if (sys_pf_calculate_allocated_pages()!=usedDiskPages)
  800145:	e8 b8 1a 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  80014a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80014d:	74 26                	je     800175 <_main+0x13d>
		{ is_correct = 0; cprintf("Wrong free page file pages count: allocated page file size incorrect. Expected Difference = %d, Actual = %d\n", 0, (usedDiskPages - sys_pf_calculate_allocated_pages()));}
  80014f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800156:	e8 a7 1a 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  80015b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80015e:	29 c2                	sub    %eax,%edx
  800160:	89 d0                	mov    %edx,%eax
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	50                   	push   %eax
  800166:	6a 00                	push   $0x0
  800168:	68 6c 38 80 00       	push   $0x80386c
  80016d:	e8 fb 07 00 00       	call   80096d <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp

		if ((LIST_SIZE(&(myEnv->page_WS_list)) - WsSize)!=1) /* Page fault were occurred when we try to initialize the first block in the block allocator */
  800175:	a1 20 50 80 00       	mov    0x805020,%eax
  80017a:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  800180:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800183:	29 c2                	sub    %eax,%edx
  800185:	89 d0                	mov    %edx,%eax
  800187:	83 f8 01             	cmp    $0x1,%eax
  80018a:	74 17                	je     8001a3 <_main+0x16b>
		{ is_correct = 0; cprintf("Wrong size for WS size: new page(s) was/were added to the working set while it/they should NOT be written");}
  80018c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 dc 38 80 00       	push   $0x8038dc
  80019b:	e8 cd 07 00 00       	call   80096d <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  8001a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001a7:	74 12                	je     8001bb <_main+0x183>
			cprintf("STEP A PASSED: checking increment with +ve value [increment from aligned segment break] works!\n\n\n");
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	68 48 39 80 00       	push   $0x803948
  8001b1:	e8 b7 07 00 00       	call   80096d <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	eb 10                	jmp    8001cb <_main+0x193>
		else
			cprintf("STEP A finished with problems\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 ac 39 80 00       	push   $0x8039ac
  8001c3:	e8 a5 07 00 00       	call   80096d <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
		old_eval = eval;
  8001cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}
	if (is_correct)
  8001d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d5:	74 04                	je     8001db <_main+0x1a3>
	{
		eval += 20;
  8001d7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	is_correct = 1;
  8001db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	/*******************************************************************/
	/*******************************************************************/

	cprintf("STEP B: checking increment with zero value ... \n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 cc 39 80 00       	push   $0x8039cc
  8001ea:	e8 7e 07 00 00       	call   80096d <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = (int)sys_calculate_free_frames();
  8001f2:	e8 c0 19 00 00       	call   801bb7 <sys_calculate_free_frames>
  8001f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fa:	e8 03 1a 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		WsSize = LIST_SIZE(&(myEnv->page_WS_list));
  800202:	a1 20 50 80 00       	mov    0x805020,%eax
  800207:	8b 80 d8 00 00 00    	mov    0xd8(%eax),%eax
  80020d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		returned_break = (uint32)sys_sbrk(0);
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	6a 00                	push   $0x0
  800215:	e8 f7 1e 00 00       	call   802111 <sys_sbrk>
  80021a:	83 c4 10             	add    $0x10,%esp
  80021d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (returned_break!=expectedVAs[1])
  800220:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800223:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800226:	74 1e                	je     800246 <_main+0x20e>
		{ is_correct = 0; cprintf("Wrong returned break: Expected: %x, Actual: %x\n", expectedVAs[1], returned_break);}
  800228:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80022f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	ff 75 d0             	pushl  -0x30(%ebp)
  800238:	50                   	push   %eax
  800239:	68 d8 37 80 00       	push   $0x8037d8
  80023e:	e8 2a 07 00 00       	call   80096d <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  800246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80024a:	74 12                	je     80025e <_main+0x226>
			cprintf("STEP B PASSED: checking increment with zero value works!\n\n\n");
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	68 00 3a 80 00       	push   $0x803a00
  800254:	e8 14 07 00 00       	call   80096d <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	eb 10                	jmp    80026e <_main+0x236>
		else
			cprintf("STEP B finished with problems\n");
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	68 3c 3a 80 00       	push   $0x803a3c
  800266:	e8 02 07 00 00       	call   80096d <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
		old_eval = eval;
  80026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800271:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}
	if (is_correct)
  800274:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800278:	74 04                	je     80027e <_main+0x246>
	{
		eval += 5;
  80027a:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
	}
	is_correct = 1;
  80027e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	/*******************************************************************/
	/*******************************************************************/

	cprintf("STEP C: checking increment with -ve value [No de-allocation case] ... \n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 5c 3a 80 00       	push   $0x803a5c
  80028d:	e8 db 06 00 00       	call   80096d <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
	{
		int_arr2 = malloc(512 * sizeof(uint32));
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 00 08 00 00       	push   $0x800
  80029d:	e8 f6 14 00 00       	call   801798 <malloc>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// Accessing to arr to make page fault and handle it
		int_arr2[32] = 300;
  8002a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002ab:	83 e8 80             	sub    $0xffffff80,%eax
  8002ae:	c7 00 2c 01 00 00    	movl   $0x12c,(%eax)
		freeFrames = (int)sys_calculate_free_frames();
  8002b4:	e8 fe 18 00 00       	call   801bb7 <sys_calculate_free_frames>
  8002b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002bc:	e8 41 19 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  8002c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		WsSize = LIST_SIZE(&(myEnv->page_WS_list));
  8002c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c9:	8b 80 d8 00 00 00    	mov    0xd8(%eax),%eax
  8002cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_sbrk(-2*kilo);
  8002d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	29 d0                	sub    %edx,%eax
  8002dc:	01 c0                	add    %eax,%eax
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	e8 2a 1e 00 00       	call   802111 <sys_sbrk>
  8002e7:	83 c4 10             	add    $0x10,%esp
		returned_break = (uint32)sys_sbrk(0);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	6a 00                	push   $0x0
  8002ef:	e8 1d 1e 00 00       	call   802111 <sys_sbrk>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (returned_break!=expectedVAs[2])
  8002fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002fd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800300:	74 1e                	je     800320 <_main+0x2e8>
		{ is_correct = 0; cprintf("Wrong returned break: Expected: %x, Actual: %x\n", expectedVAs[2], returned_break);}
  800302:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800309:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	ff 75 d0             	pushl  -0x30(%ebp)
  800312:	50                   	push   %eax
  800313:	68 d8 37 80 00       	push   $0x8037d8
  800318:	e8 50 06 00 00       	call   80096d <cprintf>
  80031d:	83 c4 10             	add    $0x10,%esp

		if ((int)sys_calculate_free_frames()!=freeFrames)
  800320:	e8 92 18 00 00       	call   801bb7 <sys_calculate_free_frames>
  800325:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800328:	74 26                	je     800350 <_main+0x318>
		{ is_correct = 0; cprintf("Wrong free frames count: allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", 0, (freeFrames - (int)sys_calculate_free_frames()));}
  80032a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800331:	e8 81 18 00 00       	call   801bb7 <sys_calculate_free_frames>
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033b:	29 d0                	sub    %edx,%eax
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	50                   	push   %eax
  800341:	6a 00                	push   $0x0
  800343:	68 08 38 80 00       	push   $0x803808
  800348:	e8 20 06 00 00       	call   80096d <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp

		if (sys_pf_calculate_allocated_pages()!=usedDiskPages)
  800350:	e8 ad 18 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  800355:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800358:	74 26                	je     800380 <_main+0x348>
		{ is_correct = 0; cprintf("Wrong free page file pages count: allocated page file size incorrect. Expected Difference = %d, Actual = %d\n", 0, (usedDiskPages - sys_pf_calculate_allocated_pages()));}
  80035a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800361:	e8 9c 18 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  800366:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800369:	29 c2                	sub    %eax,%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	83 ec 04             	sub    $0x4,%esp
  800370:	50                   	push   %eax
  800371:	6a 00                	push   $0x0
  800373:	68 6c 38 80 00       	push   $0x80386c
  800378:	e8 f0 05 00 00       	call   80096d <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp

		if (LIST_SIZE(&(myEnv->page_WS_list))!=WsSize)
  800380:	a1 20 50 80 00       	mov    0x805020,%eax
  800385:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  80038b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80038e:	39 c2                	cmp    %eax,%edx
  800390:	74 17                	je     8003a9 <_main+0x371>
		{ is_correct = 0; cprintf("Wrong size for WS size: new page(s) was/were added to the working set while it/they should NOT be written");}
  800392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	68 dc 38 80 00       	push   $0x8038dc
  8003a1:	e8 c7 05 00 00       	call   80096d <cprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp

		uint32 MentToFound [2] = {USER_HEAP_START, USER_HEAP_START + PAGE_SIZE};
  8003a9:	c7 45 ac 00 00 00 80 	movl   $0x80000000,-0x54(%ebp)
  8003b0:	c7 45 b0 00 10 00 80 	movl   $0x80001000,-0x50(%ebp)
		found = sys_check_WS_list(MentToFound, 2, 0, 2);
  8003b7:	6a 02                	push   $0x2
  8003b9:	6a 00                	push   $0x0
  8003bb:	6a 02                	push   $0x2
  8003bd:	8d 45 ac             	lea    -0x54(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	e8 0e 1d 00 00       	call   8020d4 <sys_check_WS_list>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!found)
  8003cc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003d0:	75 17                	jne    8003e9 <_main+0x3b1>
		{ is_correct = 0; cprintf("Unexpected page were removed from working set\n");}
  8003d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	68 a4 3a 80 00       	push   $0x803aa4
  8003e1:	e8 87 05 00 00       	call   80096d <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  8003e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003ed:	74 12                	je     800401 <_main+0x3c9>
			cprintf("STEP C PASSED: checking increment with -ve value [No de-allocation case] works!\n\n\n");
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	68 d4 3a 80 00       	push   $0x803ad4
  8003f7:	e8 71 05 00 00       	call   80096d <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	eb 10                	jmp    800411 <_main+0x3d9>
		else
			cprintf("STEP C finished with problems\n");
  800401:	83 ec 0c             	sub    $0xc,%esp
  800404:	68 28 3b 80 00       	push   $0x803b28
  800409:	e8 5f 05 00 00       	call   80096d <cprintf>
  80040e:	83 c4 10             	add    $0x10,%esp
		old_eval = eval;
  800411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}
	if (is_correct)
  800417:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80041b:	74 04                	je     800421 <_main+0x3e9>
	{
		eval += 25;
  80041d:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	}
	is_correct = 1;
  800421:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	/*******************************************************************/
	/*******************************************************************/

	cprintf("STEP D: checking increment with -ve value [De-allocation case] ... \n");
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	68 48 3b 80 00       	push   $0x803b48
  800430:	e8 38 05 00 00       	call   80096d <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = (int)sys_calculate_free_frames();
  800438:	e8 7a 17 00 00       	call   801bb7 <sys_calculate_free_frames>
  80043d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(int_arr2) ; //free the allocated 2KB first
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	ff 75 cc             	pushl  -0x34(%ebp)
  800446:	e8 a9 14 00 00       	call   8018f4 <free>
  80044b:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_calculate_free_frames()-freeFrames)!=0) /* Free frames should not be affected since the free() doesn't remove from memory */
  80044e:	e8 64 17 00 00       	call   801bb7 <sys_calculate_free_frames>
  800453:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800456:	74 22                	je     80047a <_main+0x442>
		{ is_correct = 0; cprintf("Wrong free frames count: allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", 1, ((int)sys_calculate_free_frames() - freeFrames));}
  800458:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80045f:	e8 53 17 00 00       	call   801bb7 <sys_calculate_free_frames>
  800464:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	50                   	push   %eax
  80046b:	6a 01                	push   $0x1
  80046d:	68 08 38 80 00       	push   $0x803808
  800472:	e8 f6 04 00 00       	call   80096d <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp

		freeFrames = (int)sys_calculate_free_frames();
  80047a:	e8 38 17 00 00       	call   801bb7 <sys_calculate_free_frames>
  80047f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800482:	e8 7b 17 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  800487:	89 45 dc             	mov    %eax,-0x24(%ebp)
		WsSize = LIST_SIZE(&(myEnv->page_WS_list));
  80048a:	a1 20 50 80 00       	mov    0x805020,%eax
  80048f:	8b 80 d8 00 00 00    	mov    0xd8(%eax),%eax
  800495:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_sbrk(-3*kilo);
  800498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049b:	89 c2                	mov    %eax,%edx
  80049d:	01 d2                	add    %edx,%edx
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	f7 d8                	neg    %eax
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	50                   	push   %eax
  8004a7:	e8 65 1c 00 00       	call   802111 <sys_sbrk>
  8004ac:	83 c4 10             	add    $0x10,%esp
		returned_break = (uint32)sys_sbrk(0);
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	6a 00                	push   $0x0
  8004b4:	e8 58 1c 00 00       	call   802111 <sys_sbrk>
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (returned_break!=expectedVAs[3])
  8004bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004c2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004c5:	74 1e                	je     8004e5 <_main+0x4ad>
		{ is_correct = 0; cprintf("Wrong returned break: Expected: %x, Actual: %x\n", expectedVAs[3], returned_break);}
  8004c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004d1:	83 ec 04             	sub    $0x4,%esp
  8004d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	68 d8 37 80 00       	push   $0x8037d8
  8004dd:	e8 8b 04 00 00       	call   80096d <cprintf>
  8004e2:	83 c4 10             	add    $0x10,%esp

		if (((int)sys_calculate_free_frames()-freeFrames)!=1) /* Free frames increased by one due to crossing the page boundary */
  8004e5:	e8 cd 16 00 00       	call   801bb7 <sys_calculate_free_frames>
  8004ea:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004ed:	83 f8 01             	cmp    $0x1,%eax
  8004f0:	74 22                	je     800514 <_main+0x4dc>
		{ is_correct = 0; cprintf("Wrong free frames count: allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", 1, ((int)sys_calculate_free_frames() - freeFrames));}
  8004f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004f9:	e8 b9 16 00 00       	call   801bb7 <sys_calculate_free_frames>
  8004fe:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	50                   	push   %eax
  800505:	6a 01                	push   $0x1
  800507:	68 08 38 80 00       	push   $0x803808
  80050c:	e8 5c 04 00 00       	call   80096d <cprintf>
  800511:	83 c4 10             	add    $0x10,%esp

		if (sys_pf_calculate_allocated_pages()!=usedDiskPages)
  800514:	e8 e9 16 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  800519:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80051c:	74 26                	je     800544 <_main+0x50c>
		{ is_correct = 0; cprintf("Wrong free page file pages count: allocated page file size incorrect. Expected Difference = %d, Actual = %d\n", 0, (usedDiskPages - sys_pf_calculate_allocated_pages()));}
  80051e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800525:	e8 d8 16 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  80052a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80052d:	29 c2                	sub    %eax,%edx
  80052f:	89 d0                	mov    %edx,%eax
  800531:	83 ec 04             	sub    $0x4,%esp
  800534:	50                   	push   %eax
  800535:	6a 00                	push   $0x0
  800537:	68 6c 38 80 00       	push   $0x80386c
  80053c:	e8 2c 04 00 00       	call   80096d <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

		if (WsSize - LIST_SIZE(&(myEnv->page_WS_list))!=1)
  800544:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800547:	a1 20 50 80 00       	mov    0x805020,%eax
  80054c:	8b 80 d8 00 00 00    	mov    0xd8(%eax),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	83 f8 01             	cmp    $0x1,%eax
  800559:	74 17                	je     800572 <_main+0x53a>
		{ is_correct = 0; cprintf("Wrong size for WS size: removed page(s) was/were not removed from the working set");}
  80055b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800562:	83 ec 0c             	sub    $0xc,%esp
  800565:	68 90 3b 80 00       	push   $0x803b90
  80056a:	e8 fe 03 00 00       	call   80096d <cprintf>
  80056f:	83 c4 10             	add    $0x10,%esp

		uint32 MentToFound2 [1] = {USER_HEAP_START + PAGE_SIZE};
  800572:	c7 45 a8 00 10 00 80 	movl   $0x80001000,-0x58(%ebp)
		found = sys_check_WS_list(MentToFound2, 1, 0, 2);
  800579:	6a 02                	push   $0x2
  80057b:	6a 00                	push   $0x0
  80057d:	6a 01                	push   $0x1
  80057f:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800582:	50                   	push   %eax
  800583:	e8 4c 1b 00 00       	call   8020d4 <sys_check_WS_list>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (found)
  80058e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800592:	74 17                	je     8005ab <_main+0x573>
		{ is_correct = 0; cprintf("Unexpected page should be removed from the working set but it's NOT\n");}
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	83 ec 0c             	sub    $0xc,%esp
  80059e:	68 e4 3b 80 00       	push   $0x803be4
  8005a3:	e8 c5 03 00 00       	call   80096d <cprintf>
  8005a8:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  8005ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005af:	74 12                	je     8005c3 <_main+0x58b>
			cprintf("STEP D PASSED: checking increment with -ve value [De-allocation case] works!\n\n\n");
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	68 2c 3c 80 00       	push   $0x803c2c
  8005b9:	e8 af 03 00 00       	call   80096d <cprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	eb 10                	jmp    8005d3 <_main+0x59b>
		else
			cprintf("STEP D finished with problems\n");
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	68 7c 3c 80 00       	push   $0x803c7c
  8005cb:	e8 9d 03 00 00       	call   80096d <cprintf>
  8005d0:	83 c4 10             	add    $0x10,%esp
		old_eval = eval;
  8005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}
	if (is_correct)
  8005d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005dd:	74 04                	je     8005e3 <_main+0x5ab>
	{
		eval += 25;
  8005df:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	}
	is_correct = 1;
  8005e3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	/*******************************************************************/
	/*******************************************************************/
	cprintf("STEP E: checking increment with +ve value ... \n");
  8005ea:	83 ec 0c             	sub    $0xc,%esp
  8005ed:	68 9c 3c 80 00       	push   $0x803c9c
  8005f2:	e8 76 03 00 00       	call   80096d <cprintf>
  8005f7:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = (int)sys_calculate_free_frames();
  8005fa:	e8 b8 15 00 00       	call   801bb7 <sys_calculate_free_frames>
  8005ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800602:	e8 fb 15 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  800607:	89 45 dc             	mov    %eax,-0x24(%ebp)
		WsSize = LIST_SIZE(&(myEnv->page_WS_list));
  80060a:	a1 20 50 80 00       	mov    0x805020,%eax
  80060f:	8b 80 d8 00 00 00    	mov    0xd8(%eax),%eax
  800615:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_sbrk(512);
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	68 00 02 00 00       	push   $0x200
  800620:	e8 ec 1a 00 00       	call   802111 <sys_sbrk>
  800625:	83 c4 10             	add    $0x10,%esp
		returned_break = (uint32)sys_sbrk(0);
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	6a 00                	push   $0x0
  80062d:	e8 df 1a 00 00       	call   802111 <sys_sbrk>
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (returned_break!=expectedVAs[1])
  800638:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80063b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80063e:	74 1e                	je     80065e <_main+0x626>
		{ is_correct = 0; cprintf("Wrong returned break: Expected: %x, Actual: %x\n", expectedVAs[1], returned_break);}
  800640:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800647:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80064a:	83 ec 04             	sub    $0x4,%esp
  80064d:	ff 75 d0             	pushl  -0x30(%ebp)
  800650:	50                   	push   %eax
  800651:	68 d8 37 80 00       	push   $0x8037d8
  800656:	e8 12 03 00 00       	call   80096d <cprintf>
  80065b:	83 c4 10             	add    $0x10,%esp

		if (((int)sys_calculate_free_frames()-freeFrames)!=0)
  80065e:	e8 54 15 00 00       	call   801bb7 <sys_calculate_free_frames>
  800663:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800666:	74 22                	je     80068a <_main+0x652>
		{ is_correct = 0; cprintf("Wrong free frames count: allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", 0, ((int)sys_calculate_free_frames() - freeFrames));}
  800668:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066f:	e8 43 15 00 00       	call   801bb7 <sys_calculate_free_frames>
  800674:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800677:	83 ec 04             	sub    $0x4,%esp
  80067a:	50                   	push   %eax
  80067b:	6a 00                	push   $0x0
  80067d:	68 08 38 80 00       	push   $0x803808
  800682:	e8 e6 02 00 00       	call   80096d <cprintf>
  800687:	83 c4 10             	add    $0x10,%esp

		if (sys_pf_calculate_allocated_pages()!=usedDiskPages)
  80068a:	e8 73 15 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  80068f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800692:	74 26                	je     8006ba <_main+0x682>
		{ is_correct = 0; cprintf("Wrong free page file pages count: allocated page file size incorrect. Expected Difference = %d, Actual = %d\n", 0, (usedDiskPages - sys_pf_calculate_allocated_pages()));}
  800694:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80069b:	e8 62 15 00 00       	call   801c02 <sys_pf_calculate_allocated_pages>
  8006a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006a3:	29 c2                	sub    %eax,%edx
  8006a5:	89 d0                	mov    %edx,%eax
  8006a7:	83 ec 04             	sub    $0x4,%esp
  8006aa:	50                   	push   %eax
  8006ab:	6a 00                	push   $0x0
  8006ad:	68 6c 38 80 00       	push   $0x80386c
  8006b2:	e8 b6 02 00 00       	call   80096d <cprintf>
  8006b7:	83 c4 10             	add    $0x10,%esp

		if ((WsSize - LIST_SIZE(&(myEnv->page_WS_list)))!=0)
  8006ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8006bf:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  8006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c8:	39 c2                	cmp    %eax,%edx
  8006ca:	74 17                	je     8006e3 <_main+0x6ab>
		{ is_correct = 0; cprintf("Wrong size for WS size: new page(s) was/were added to the working set while it/they should NOT be written");}
  8006cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006d3:	83 ec 0c             	sub    $0xc,%esp
  8006d6:	68 dc 38 80 00       	push   $0x8038dc
  8006db:	e8 8d 02 00 00       	call   80096d <cprintf>
  8006e0:	83 c4 10             	add    $0x10,%esp

		uint32 MentToFound2 [1] = {USER_HEAP_START + PAGE_SIZE};
  8006e3:	c7 45 a4 00 10 00 80 	movl   $0x80001000,-0x5c(%ebp)

		found = sys_check_WS_list(MentToFound2, 1, 0, 2);
  8006ea:	6a 02                	push   $0x2
  8006ec:	6a 00                	push   $0x0
  8006ee:	6a 01                	push   $0x1
  8006f0:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	e8 db 19 00 00       	call   8020d4 <sys_check_WS_list>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (found)
  8006ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800703:	74 17                	je     80071c <_main+0x6e4>
		{ is_correct = 0; cprintf("Unexpected page shouldn't be written into the working set but it has been written\n");}
  800705:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80070c:	83 ec 0c             	sub    $0xc,%esp
  80070f:	68 cc 3c 80 00       	push   $0x803ccc
  800714:	e8 54 02 00 00       	call   80096d <cprintf>
  800719:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  80071c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800720:	74 12                	je     800734 <_main+0x6fc>
			cprintf("STEP E PASSED: checking increment with +ve value works!\n\n\n");
  800722:	83 ec 0c             	sub    $0xc,%esp
  800725:	68 20 3d 80 00       	push   $0x803d20
  80072a:	e8 3e 02 00 00       	call   80096d <cprintf>
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	eb 10                	jmp    800744 <_main+0x70c>
		else
			cprintf("STEP E finished with problems\n");
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 5c 3d 80 00       	push   $0x803d5c
  80073c:	e8 2c 02 00 00       	call   80096d <cprintf>
  800741:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  800744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800748:	74 04                	je     80074e <_main+0x716>
	{
		eval += 25;
  80074a:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	}
	is_correct = 1;
  80074e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	/*******************************************************************/
	/*******************************************************************/

	//cprintf("test user heap sbrk is finished. Evaluation = %d%\n", eval);
	cprintf("[AUTO_GR@DING_PARTIAL]%d\n", eval);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 f4             	pushl  -0xc(%ebp)
  80075b:	68 7b 3d 80 00       	push   $0x803d7b
  800760:	e8 08 02 00 00       	call   80096d <cprintf>
  800765:	83 c4 10             	add    $0x10,%esp

	return;
  800768:	90                   	nop
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800771:	e8 cc 16 00 00       	call   801e42 <sys_getenvindex>
  800776:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077c:	89 d0                	mov    %edx,%eax
  80077e:	01 c0                	add    %eax,%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	c1 e0 06             	shl    $0x6,%eax
  800785:	29 d0                	sub    %edx,%eax
  800787:	c1 e0 03             	shl    $0x3,%eax
  80078a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800794:	a1 20 50 80 00       	mov    0x805020,%eax
  800799:	8a 40 68             	mov    0x68(%eax),%al
  80079c:	84 c0                	test   %al,%al
  80079e:	74 0d                	je     8007ad <libmain+0x42>
		binaryname = myEnv->prog_name;
  8007a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a5:	83 c0 68             	add    $0x68,%eax
  8007a8:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b1:	7e 0a                	jle    8007bd <libmain+0x52>
		binaryname = argv[0];
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	ff 75 08             	pushl  0x8(%ebp)
  8007c6:	e8 6d f8 ff ff       	call   800038 <_main>
  8007cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007ce:	e8 7c 14 00 00       	call   801c4f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d3:	83 ec 0c             	sub    $0xc,%esp
  8007d6:	68 b0 3d 80 00       	push   $0x803db0
  8007db:	e8 8d 01 00 00       	call   80096d <cprintf>
  8007e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8007e8:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8007ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f3:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	68 d8 3d 80 00       	push   $0x803dd8
  800803:	e8 65 01 00 00       	call   80096d <cprintf>
  800808:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080b:	a1 20 50 80 00       	mov    0x805020,%eax
  800810:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800816:	a1 20 50 80 00       	mov    0x805020,%eax
  80081b:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800821:	a1 20 50 80 00       	mov    0x805020,%eax
  800826:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80082c:	51                   	push   %ecx
  80082d:	52                   	push   %edx
  80082e:	50                   	push   %eax
  80082f:	68 00 3e 80 00       	push   $0x803e00
  800834:	e8 34 01 00 00       	call   80096d <cprintf>
  800839:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80083c:	a1 20 50 80 00       	mov    0x805020,%eax
  800841:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	50                   	push   %eax
  80084b:	68 58 3e 80 00       	push   $0x803e58
  800850:	e8 18 01 00 00       	call   80096d <cprintf>
  800855:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800858:	83 ec 0c             	sub    $0xc,%esp
  80085b:	68 b0 3d 80 00       	push   $0x803db0
  800860:	e8 08 01 00 00       	call   80096d <cprintf>
  800865:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800868:	e8 fc 13 00 00       	call   801c69 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80086d:	e8 19 00 00 00       	call   80088b <exit>
}
  800872:	90                   	nop
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087b:	83 ec 0c             	sub    $0xc,%esp
  80087e:	6a 00                	push   $0x0
  800880:	e8 89 15 00 00       	call   801e0e <sys_destroy_env>
  800885:	83 c4 10             	add    $0x10,%esp
}
  800888:	90                   	nop
  800889:	c9                   	leave  
  80088a:	c3                   	ret    

0080088b <exit>:

void
exit(void)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800891:	e8 de 15 00 00       	call   801e74 <sys_exit_env>
}
  800896:	90                   	nop
  800897:	c9                   	leave  
  800898:	c3                   	ret    

00800899 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80089f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	89 0a                	mov    %ecx,(%edx)
  8008ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8008af:	88 d1                	mov    %dl,%cl
  8008b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008c2:	75 2c                	jne    8008f0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008c4:	a0 24 50 80 00       	mov    0x805024,%al
  8008c9:	0f b6 c0             	movzbl %al,%eax
  8008cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cf:	8b 12                	mov    (%edx),%edx
  8008d1:	89 d1                	mov    %edx,%ecx
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	83 c2 08             	add    $0x8,%edx
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	50                   	push   %eax
  8008dd:	51                   	push   %ecx
  8008de:	52                   	push   %edx
  8008df:	e8 12 12 00 00       	call   801af6 <sys_cputs>
  8008e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f3:	8b 40 04             	mov    0x4(%eax),%eax
  8008f6:	8d 50 01             	lea    0x1(%eax),%edx
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008ff:	90                   	nop
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80090b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800912:	00 00 00 
	b.cnt = 0;
  800915:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80091c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	ff 75 08             	pushl  0x8(%ebp)
  800925:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	68 99 08 80 00       	push   $0x800899
  800931:	e8 11 02 00 00       	call   800b47 <vprintfmt>
  800936:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800939:	a0 24 50 80 00       	mov    0x805024,%al
  80093e:	0f b6 c0             	movzbl %al,%eax
  800941:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800947:	83 ec 04             	sub    $0x4,%esp
  80094a:	50                   	push   %eax
  80094b:	52                   	push   %edx
  80094c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800952:	83 c0 08             	add    $0x8,%eax
  800955:	50                   	push   %eax
  800956:	e8 9b 11 00 00       	call   801af6 <sys_cputs>
  80095b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80095e:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800965:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <cprintf>:

int cprintf(const char *fmt, ...) {
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800973:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80097a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80097d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 f4             	pushl  -0xc(%ebp)
  800989:	50                   	push   %eax
  80098a:	e8 73 ff ff ff       	call   800902 <vcprintf>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009a0:	e8 aa 12 00 00       	call   801c4f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b4:	50                   	push   %eax
  8009b5:	e8 48 ff ff ff       	call   800902 <vcprintf>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009c0:	e8 a4 12 00 00       	call   801c69 <sys_enable_interrupt>
	return cnt;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	83 ec 14             	sub    $0x14,%esp
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e8:	77 55                	ja     800a3f <printnum+0x75>
  8009ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009ed:	72 05                	jb     8009f4 <printnum+0x2a>
  8009ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009f2:	77 4b                	ja     800a3f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8009fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800a02:	52                   	push   %edx
  800a03:	50                   	push   %eax
  800a04:	ff 75 f4             	pushl  -0xc(%ebp)
  800a07:	ff 75 f0             	pushl  -0x10(%ebp)
  800a0a:	e8 f5 2a 00 00       	call   803504 <__udivdi3>
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	83 ec 04             	sub    $0x4,%esp
  800a15:	ff 75 20             	pushl  0x20(%ebp)
  800a18:	53                   	push   %ebx
  800a19:	ff 75 18             	pushl  0x18(%ebp)
  800a1c:	52                   	push   %edx
  800a1d:	50                   	push   %eax
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	ff 75 08             	pushl  0x8(%ebp)
  800a24:	e8 a1 ff ff ff       	call   8009ca <printnum>
  800a29:	83 c4 20             	add    $0x20,%esp
  800a2c:	eb 1a                	jmp    800a48 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	ff 75 20             	pushl  0x20(%ebp)
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a3f:	ff 4d 1c             	decl   0x1c(%ebp)
  800a42:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a46:	7f e6                	jg     800a2e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a48:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a56:	53                   	push   %ebx
  800a57:	51                   	push   %ecx
  800a58:	52                   	push   %edx
  800a59:	50                   	push   %eax
  800a5a:	e8 b5 2b 00 00       	call   803614 <__umoddi3>
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	05 94 40 80 00       	add    $0x804094,%eax
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f be c0             	movsbl %al,%eax
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	50                   	push   %eax
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
}
  800a7b:	90                   	nop
  800a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a84:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a88:	7e 1c                	jle    800aa6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 00                	mov    (%eax),%eax
  800a8f:	8d 50 08             	lea    0x8(%eax),%edx
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	89 10                	mov    %edx,(%eax)
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 00                	mov    (%eax),%eax
  800a9c:	83 e8 08             	sub    $0x8,%eax
  800a9f:	8b 50 04             	mov    0x4(%eax),%edx
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	eb 40                	jmp    800ae6 <getuint+0x65>
	else if (lflag)
  800aa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aaa:	74 1e                	je     800aca <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8b 00                	mov    (%eax),%eax
  800ab1:	8d 50 04             	lea    0x4(%eax),%edx
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	89 10                	mov    %edx,(%eax)
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	83 e8 04             	sub    $0x4,%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	eb 1c                	jmp    800ae6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 00                	mov    (%eax),%eax
  800acf:	8d 50 04             	lea    0x4(%eax),%edx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	89 10                	mov    %edx,(%eax)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8b 00                	mov    (%eax),%eax
  800adc:	83 e8 04             	sub    $0x4,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aeb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aef:	7e 1c                	jle    800b0d <getint+0x25>
		return va_arg(*ap, long long);
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	8d 50 08             	lea    0x8(%eax),%edx
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	89 10                	mov    %edx,(%eax)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	83 e8 08             	sub    $0x8,%eax
  800b06:	8b 50 04             	mov    0x4(%eax),%edx
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	eb 38                	jmp    800b45 <getint+0x5d>
	else if (lflag)
  800b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b11:	74 1a                	je     800b2d <getint+0x45>
		return va_arg(*ap, long);
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	8d 50 04             	lea    0x4(%eax),%edx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	89 10                	mov    %edx,(%eax)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	83 e8 04             	sub    $0x4,%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	99                   	cltd   
  800b2b:	eb 18                	jmp    800b45 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	8d 50 04             	lea    0x4(%eax),%edx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 10                	mov    %edx,(%eax)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	83 e8 04             	sub    $0x4,%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	99                   	cltd   
}
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
  800b4c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4f:	eb 17                	jmp    800b68 <vprintfmt+0x21>
			if (ch == '\0')
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	0f 84 af 03 00 00    	je     800f08 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	53                   	push   %ebx
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b68:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6b:	8d 50 01             	lea    0x1(%eax),%edx
  800b6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	0f b6 d8             	movzbl %al,%ebx
  800b76:	83 fb 25             	cmp    $0x25,%ebx
  800b79:	75 d6                	jne    800b51 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b7b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b7f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b8d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ba1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	0f b6 d8             	movzbl %al,%ebx
  800ba9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bac:	83 f8 55             	cmp    $0x55,%eax
  800baf:	0f 87 2b 03 00 00    	ja     800ee0 <vprintfmt+0x399>
  800bb5:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
  800bbc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bbe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d7                	jmp    800b9b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc8:	eb d1                	jmp    800b9b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bd4:	89 d0                	mov    %edx,%eax
  800bd6:	c1 e0 02             	shl    $0x2,%eax
  800bd9:	01 d0                	add    %edx,%eax
  800bdb:	01 c0                	add    %eax,%eax
  800bdd:	01 d8                	add    %ebx,%eax
  800bdf:	83 e8 30             	sub    $0x30,%eax
  800be2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800be5:	8b 45 10             	mov    0x10(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bed:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf0:	7e 3e                	jle    800c30 <vprintfmt+0xe9>
  800bf2:	83 fb 39             	cmp    $0x39,%ebx
  800bf5:	7f 39                	jg     800c30 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bfa:	eb d5                	jmp    800bd1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	83 c0 04             	add    $0x4,%eax
  800c02:	89 45 14             	mov    %eax,0x14(%ebp)
  800c05:	8b 45 14             	mov    0x14(%ebp),%eax
  800c08:	83 e8 04             	sub    $0x4,%eax
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c10:	eb 1f                	jmp    800c31 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c16:	79 83                	jns    800b9b <vprintfmt+0x54>
				width = 0;
  800c18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c1f:	e9 77 ff ff ff       	jmp    800b9b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c24:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c2b:	e9 6b ff ff ff       	jmp    800b9b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c30:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c35:	0f 89 60 ff ff ff    	jns    800b9b <vprintfmt+0x54>
				width = precision, precision = -1;
  800c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c48:	e9 4e ff ff ff       	jmp    800b9b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c4d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c50:	e9 46 ff ff ff       	jmp    800b9b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	50                   	push   %eax
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			break;
  800c75:	e9 89 02 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 14             	mov    %eax,0x14(%ebp)
  800c83:	8b 45 14             	mov    0x14(%ebp),%eax
  800c86:	83 e8 04             	sub    $0x4,%eax
  800c89:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c8b:	85 db                	test   %ebx,%ebx
  800c8d:	79 02                	jns    800c91 <vprintfmt+0x14a>
				err = -err;
  800c8f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c91:	83 fb 64             	cmp    $0x64,%ebx
  800c94:	7f 0b                	jg     800ca1 <vprintfmt+0x15a>
  800c96:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800c9d:	85 f6                	test   %esi,%esi
  800c9f:	75 19                	jne    800cba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ca1:	53                   	push   %ebx
  800ca2:	68 a5 40 80 00       	push   $0x8040a5
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	ff 75 08             	pushl  0x8(%ebp)
  800cad:	e8 5e 02 00 00       	call   800f10 <printfmt>
  800cb2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cb5:	e9 49 02 00 00       	jmp    800f03 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cba:	56                   	push   %esi
  800cbb:	68 ae 40 80 00       	push   $0x8040ae
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	ff 75 08             	pushl  0x8(%ebp)
  800cc6:	e8 45 02 00 00       	call   800f10 <printfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp
			break;
  800cce:	e9 30 02 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd6:	83 c0 04             	add    $0x4,%eax
  800cd9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	83 e8 04             	sub    $0x4,%eax
  800ce2:	8b 30                	mov    (%eax),%esi
  800ce4:	85 f6                	test   %esi,%esi
  800ce6:	75 05                	jne    800ced <vprintfmt+0x1a6>
				p = "(null)";
  800ce8:	be b1 40 80 00       	mov    $0x8040b1,%esi
			if (width > 0 && padc != '-')
  800ced:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf1:	7e 6d                	jle    800d60 <vprintfmt+0x219>
  800cf3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf7:	74 67                	je     800d60 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	50                   	push   %eax
  800d00:	56                   	push   %esi
  800d01:	e8 0c 03 00 00       	call   801012 <strnlen>
  800d06:	83 c4 10             	add    $0x10,%esp
  800d09:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d0c:	eb 16                	jmp    800d24 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d0e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	50                   	push   %eax
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	ff 4d e4             	decl   -0x1c(%ebp)
  800d24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d28:	7f e4                	jg     800d0e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2a:	eb 34                	jmp    800d60 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d30:	74 1c                	je     800d4e <vprintfmt+0x207>
  800d32:	83 fb 1f             	cmp    $0x1f,%ebx
  800d35:	7e 05                	jle    800d3c <vprintfmt+0x1f5>
  800d37:	83 fb 7e             	cmp    $0x7e,%ebx
  800d3a:	7e 12                	jle    800d4e <vprintfmt+0x207>
					putch('?', putdat);
  800d3c:	83 ec 08             	sub    $0x8,%esp
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	6a 3f                	push   $0x3f
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
  800d4c:	eb 0f                	jmp    800d5d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d4e:	83 ec 08             	sub    $0x8,%esp
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	53                   	push   %ebx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d5d:	ff 4d e4             	decl   -0x1c(%ebp)
  800d60:	89 f0                	mov    %esi,%eax
  800d62:	8d 70 01             	lea    0x1(%eax),%esi
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f be d8             	movsbl %al,%ebx
  800d6a:	85 db                	test   %ebx,%ebx
  800d6c:	74 24                	je     800d92 <vprintfmt+0x24b>
  800d6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d72:	78 b8                	js     800d2c <vprintfmt+0x1e5>
  800d74:	ff 4d e0             	decl   -0x20(%ebp)
  800d77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d7b:	79 af                	jns    800d2c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7d:	eb 13                	jmp    800d92 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	6a 20                	push   $0x20
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	ff d0                	call   *%eax
  800d8c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d8f:	ff 4d e4             	decl   -0x1c(%ebp)
  800d92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d96:	7f e7                	jg     800d7f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d98:	e9 66 01 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d9d:	83 ec 08             	sub    $0x8,%esp
  800da0:	ff 75 e8             	pushl  -0x18(%ebp)
  800da3:	8d 45 14             	lea    0x14(%ebp),%eax
  800da6:	50                   	push   %eax
  800da7:	e8 3c fd ff ff       	call   800ae8 <getint>
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbb:	85 d2                	test   %edx,%edx
  800dbd:	79 23                	jns    800de2 <vprintfmt+0x29b>
				putch('-', putdat);
  800dbf:	83 ec 08             	sub    $0x8,%esp
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	6a 2d                	push   $0x2d
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	ff d0                	call   *%eax
  800dcc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd5:	f7 d8                	neg    %eax
  800dd7:	83 d2 00             	adc    $0x0,%edx
  800dda:	f7 da                	neg    %edx
  800ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800de2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de9:	e9 bc 00 00 00       	jmp    800eaa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 e8             	pushl  -0x18(%ebp)
  800df4:	8d 45 14             	lea    0x14(%ebp),%eax
  800df7:	50                   	push   %eax
  800df8:	e8 84 fc ff ff       	call   800a81 <getuint>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e06:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e0d:	e9 98 00 00 00       	jmp    800eaa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e12:	83 ec 08             	sub    $0x8,%esp
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	6a 58                	push   $0x58
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	ff d0                	call   *%eax
  800e1f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	6a 58                	push   $0x58
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	ff d0                	call   *%eax
  800e2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	6a 58                	push   $0x58
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	ff d0                	call   *%eax
  800e3f:	83 c4 10             	add    $0x10,%esp
			break;
  800e42:	e9 bc 00 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 0c             	pushl  0xc(%ebp)
  800e4d:	6a 30                	push   $0x30
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	ff d0                	call   *%eax
  800e54:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 78                	push   $0x78
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 c0 04             	add    $0x4,%eax
  800e6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e70:	8b 45 14             	mov    0x14(%ebp),%eax
  800e73:	83 e8 04             	sub    $0x4,%eax
  800e76:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e82:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e89:	eb 1f                	jmp    800eaa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e8b:	83 ec 08             	sub    $0x8,%esp
  800e8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e91:	8d 45 14             	lea    0x14(%ebp),%eax
  800e94:	50                   	push   %eax
  800e95:	e8 e7 fb ff ff       	call   800a81 <getuint>
  800e9a:	83 c4 10             	add    $0x10,%esp
  800e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ea3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eaa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	83 ec 04             	sub    $0x4,%esp
  800eb4:	52                   	push   %edx
  800eb5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb8:	50                   	push   %eax
  800eb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebc:	ff 75 f0             	pushl  -0x10(%ebp)
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	e8 00 fb ff ff       	call   8009ca <printnum>
  800eca:	83 c4 20             	add    $0x20,%esp
			break;
  800ecd:	eb 34                	jmp    800f03 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	ff 75 0c             	pushl  0xc(%ebp)
  800ed5:	53                   	push   %ebx
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	ff d0                	call   *%eax
  800edb:	83 c4 10             	add    $0x10,%esp
			break;
  800ede:	eb 23                	jmp    800f03 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	ff 75 0c             	pushl  0xc(%ebp)
  800ee6:	6a 25                	push   $0x25
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	ff d0                	call   *%eax
  800eed:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef0:	ff 4d 10             	decl   0x10(%ebp)
  800ef3:	eb 03                	jmp    800ef8 <vprintfmt+0x3b1>
  800ef5:	ff 4d 10             	decl   0x10(%ebp)
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	48                   	dec    %eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 25                	cmp    $0x25,%al
  800f00:	75 f3                	jne    800ef5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f02:	90                   	nop
		}
	}
  800f03:	e9 47 fc ff ff       	jmp    800b4f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f08:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f16:	8d 45 10             	lea    0x10(%ebp),%eax
  800f19:	83 c0 04             	add    $0x4,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	ff 75 f4             	pushl  -0xc(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 0c             	pushl  0xc(%ebp)
  800f29:	ff 75 08             	pushl  0x8(%ebp)
  800f2c:	e8 16 fc ff ff       	call   800b47 <vprintfmt>
  800f31:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f34:	90                   	nop
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8b 40 08             	mov    0x8(%eax),%eax
  800f40:	8d 50 01             	lea    0x1(%eax),%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	8b 10                	mov    (%eax),%edx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8b 40 04             	mov    0x4(%eax),%eax
  800f54:	39 c2                	cmp    %eax,%edx
  800f56:	73 12                	jae    800f6a <sprintputch+0x33>
		*b->buf++ = ch;
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	8b 00                	mov    (%eax),%eax
  800f5d:	8d 48 01             	lea    0x1(%eax),%ecx
  800f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f63:	89 0a                	mov    %ecx,(%edx)
  800f65:	8b 55 08             	mov    0x8(%ebp),%edx
  800f68:	88 10                	mov    %dl,(%eax)
}
  800f6a:	90                   	nop
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	01 d0                	add    %edx,%eax
  800f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f92:	74 06                	je     800f9a <vsnprintf+0x2d>
  800f94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f98:	7f 07                	jg     800fa1 <vsnprintf+0x34>
		return -E_INVAL;
  800f9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800f9f:	eb 20                	jmp    800fc1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fa1:	ff 75 14             	pushl  0x14(%ebp)
  800fa4:	ff 75 10             	pushl  0x10(%ebp)
  800fa7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800faa:	50                   	push   %eax
  800fab:	68 37 0f 80 00       	push   $0x800f37
  800fb0:	e8 92 fb ff ff       	call   800b47 <vprintfmt>
  800fb5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    

00800fc3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd8:	50                   	push   %eax
  800fd9:	ff 75 0c             	pushl  0xc(%ebp)
  800fdc:	ff 75 08             	pushl  0x8(%ebp)
  800fdf:	e8 89 ff ff ff       	call   800f6d <vsnprintf>
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ffc:	eb 06                	jmp    801004 <strlen+0x15>
		n++;
  800ffe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	84 c0                	test   %al,%al
  80100b:	75 f1                	jne    800ffe <strlen+0xf>
		n++;
	return n;
  80100d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101f:	eb 09                	jmp    80102a <strnlen+0x18>
		n++;
  801021:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	ff 4d 0c             	decl   0xc(%ebp)
  80102a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102e:	74 09                	je     801039 <strnlen+0x27>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	84 c0                	test   %al,%al
  801037:	75 e8                	jne    801021 <strnlen+0xf>
		n++;
	return n;
  801039:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80104a:	90                   	nop
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8d 50 01             	lea    0x1(%eax),%edx
  801051:	89 55 08             	mov    %edx,0x8(%ebp)
  801054:	8b 55 0c             	mov    0xc(%ebp),%edx
  801057:	8d 4a 01             	lea    0x1(%edx),%ecx
  80105a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80105d:	8a 12                	mov    (%edx),%dl
  80105f:	88 10                	mov    %dl,(%eax)
  801061:	8a 00                	mov    (%eax),%al
  801063:	84 c0                	test   %al,%al
  801065:	75 e4                	jne    80104b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107f:	eb 1f                	jmp    8010a0 <strncpy+0x34>
		*dst++ = *src;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8d 50 01             	lea    0x1(%eax),%edx
  801087:	89 55 08             	mov    %edx,0x8(%ebp)
  80108a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108d:	8a 12                	mov    (%edx),%dl
  80108f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	84 c0                	test   %al,%al
  801098:	74 03                	je     80109d <strncpy+0x31>
			src++;
  80109a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80109d:	ff 45 fc             	incl   -0x4(%ebp)
  8010a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a6:	72 d9                	jb     801081 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	74 30                	je     8010ef <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010bf:	eb 16                	jmp    8010d7 <strlcpy+0x2a>
			*dst++ = *src++;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8d 50 01             	lea    0x1(%eax),%edx
  8010c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d3:	8a 12                	mov    (%edx),%dl
  8010d5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d7:	ff 4d 10             	decl   0x10(%ebp)
  8010da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010de:	74 09                	je     8010e9 <strlcpy+0x3c>
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 d8                	jne    8010c1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	29 c2                	sub    %eax,%edx
  8010f7:	89 d0                	mov    %edx,%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010fe:	eb 06                	jmp    801106 <strcmp+0xb>
		p++, q++;
  801100:	ff 45 08             	incl   0x8(%ebp)
  801103:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	84 c0                	test   %al,%al
  80110d:	74 0e                	je     80111d <strcmp+0x22>
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 10                	mov    (%eax),%dl
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	38 c2                	cmp    %al,%dl
  80111b:	74 e3                	je     801100 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f b6 d0             	movzbl %al,%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	0f b6 c0             	movzbl %al,%eax
  80112d:	29 c2                	sub    %eax,%edx
  80112f:	89 d0                	mov    %edx,%eax
}
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801136:	eb 09                	jmp    801141 <strncmp+0xe>
		n--, p++, q++;
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	ff 45 08             	incl   0x8(%ebp)
  80113e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801145:	74 17                	je     80115e <strncmp+0x2b>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	84 c0                	test   %al,%al
  80114e:	74 0e                	je     80115e <strncmp+0x2b>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 10                	mov    (%eax),%dl
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	38 c2                	cmp    %al,%dl
  80115c:	74 da                	je     801138 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80115e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801162:	75 07                	jne    80116b <strncmp+0x38>
		return 0;
  801164:	b8 00 00 00 00       	mov    $0x0,%eax
  801169:	eb 14                	jmp    80117f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	0f b6 d0             	movzbl %al,%edx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	29 c2                	sub    %eax,%edx
  80117d:	89 d0                	mov    %edx,%eax
}
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	83 ec 04             	sub    $0x4,%esp
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80118d:	eb 12                	jmp    8011a1 <strchr+0x20>
		if (*s == c)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801197:	75 05                	jne    80119e <strchr+0x1d>
			return (char *) s;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	eb 11                	jmp    8011af <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	84 c0                	test   %al,%al
  8011a8:	75 e5                	jne    80118f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011bd:	eb 0d                	jmp    8011cc <strfind+0x1b>
		if (*s == c)
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c7:	74 0e                	je     8011d7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c9:	ff 45 08             	incl   0x8(%ebp)
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	84 c0                	test   %al,%al
  8011d3:	75 ea                	jne    8011bf <strfind+0xe>
  8011d5:	eb 01                	jmp    8011d8 <strfind+0x27>
		if (*s == c)
			break;
  8011d7:	90                   	nop
	return (char *) s;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011ef:	eb 0e                	jmp    8011ff <memset+0x22>
		*p++ = c;
  8011f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f4:	8d 50 01             	lea    0x1(%eax),%edx
  8011f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011ff:	ff 4d f8             	decl   -0x8(%ebp)
  801202:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801206:	79 e9                	jns    8011f1 <memset+0x14>
		*p++ = c;

	return v;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80121f:	eb 16                	jmp    801237 <memcpy+0x2a>
		*d++ = *s++;
  801221:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801224:	8d 50 01             	lea    0x1(%eax),%edx
  801227:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801230:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801233:	8a 12                	mov    (%edx),%dl
  801235:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801237:	8b 45 10             	mov    0x10(%ebp),%eax
  80123a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123d:	89 55 10             	mov    %edx,0x10(%ebp)
  801240:	85 c0                	test   %eax,%eax
  801242:	75 dd                	jne    801221 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801261:	73 50                	jae    8012b3 <memmove+0x6a>
  801263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80126e:	76 43                	jbe    8012b3 <memmove+0x6a>
		s += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801276:	8b 45 10             	mov    0x10(%ebp),%eax
  801279:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80127c:	eb 10                	jmp    80128e <memmove+0x45>
			*--d = *--s;
  80127e:	ff 4d f8             	decl   -0x8(%ebp)
  801281:	ff 4d fc             	decl   -0x4(%ebp)
  801284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801287:	8a 10                	mov    (%eax),%dl
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	8d 50 ff             	lea    -0x1(%eax),%edx
  801294:	89 55 10             	mov    %edx,0x10(%ebp)
  801297:	85 c0                	test   %eax,%eax
  801299:	75 e3                	jne    80127e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80129b:	eb 23                	jmp    8012c0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80129d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a0:	8d 50 01             	lea    0x1(%eax),%edx
  8012a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012af:	8a 12                	mov    (%edx),%dl
  8012b1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	75 dd                	jne    80129d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d7:	eb 2a                	jmp    801303 <memcmp+0x3e>
		if (*s1 != *s2)
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dc:	8a 10                	mov    (%eax),%dl
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	38 c2                	cmp    %al,%dl
  8012e5:	74 16                	je     8012fd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	0f b6 d0             	movzbl %al,%edx
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	0f b6 c0             	movzbl %al,%eax
  8012f7:	29 c2                	sub    %eax,%edx
  8012f9:	89 d0                	mov    %edx,%eax
  8012fb:	eb 18                	jmp    801315 <memcmp+0x50>
		s1++, s2++;
  8012fd:	ff 45 fc             	incl   -0x4(%ebp)
  801300:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	8d 50 ff             	lea    -0x1(%eax),%edx
  801309:	89 55 10             	mov    %edx,0x10(%ebp)
  80130c:	85 c0                	test   %eax,%eax
  80130e:	75 c9                	jne    8012d9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80131d:	8b 55 08             	mov    0x8(%ebp),%edx
  801320:	8b 45 10             	mov    0x10(%ebp),%eax
  801323:	01 d0                	add    %edx,%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801328:	eb 15                	jmp    80133f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	0f b6 d0             	movzbl %al,%edx
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	0f b6 c0             	movzbl %al,%eax
  801338:	39 c2                	cmp    %eax,%edx
  80133a:	74 0d                	je     801349 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80133c:	ff 45 08             	incl   0x8(%ebp)
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801345:	72 e3                	jb     80132a <memfind+0x13>
  801347:	eb 01                	jmp    80134a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801349:	90                   	nop
	return (void *) s;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801355:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80135c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801363:	eb 03                	jmp    801368 <strtol+0x19>
		s++;
  801365:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	3c 20                	cmp    $0x20,%al
  80136f:	74 f4                	je     801365 <strtol+0x16>
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	3c 09                	cmp    $0x9,%al
  801378:	74 eb                	je     801365 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	3c 2b                	cmp    $0x2b,%al
  801381:	75 05                	jne    801388 <strtol+0x39>
		s++;
  801383:	ff 45 08             	incl   0x8(%ebp)
  801386:	eb 13                	jmp    80139b <strtol+0x4c>
	else if (*s == '-')
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	3c 2d                	cmp    $0x2d,%al
  80138f:	75 0a                	jne    80139b <strtol+0x4c>
		s++, neg = 1;
  801391:	ff 45 08             	incl   0x8(%ebp)
  801394:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80139b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139f:	74 06                	je     8013a7 <strtol+0x58>
  8013a1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013a5:	75 20                	jne    8013c7 <strtol+0x78>
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	3c 30                	cmp    $0x30,%al
  8013ae:	75 17                	jne    8013c7 <strtol+0x78>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	40                   	inc    %eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 78                	cmp    $0x78,%al
  8013b8:	75 0d                	jne    8013c7 <strtol+0x78>
		s += 2, base = 16;
  8013ba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013be:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013c5:	eb 28                	jmp    8013ef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cb:	75 15                	jne    8013e2 <strtol+0x93>
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 30                	cmp    $0x30,%al
  8013d4:	75 0c                	jne    8013e2 <strtol+0x93>
		s++, base = 8;
  8013d6:	ff 45 08             	incl   0x8(%ebp)
  8013d9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013e0:	eb 0d                	jmp    8013ef <strtol+0xa0>
	else if (base == 0)
  8013e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e6:	75 07                	jne    8013ef <strtol+0xa0>
		base = 10;
  8013e8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	3c 2f                	cmp    $0x2f,%al
  8013f6:	7e 19                	jle    801411 <strtol+0xc2>
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	3c 39                	cmp    $0x39,%al
  8013ff:	7f 10                	jg     801411 <strtol+0xc2>
			dig = *s - '0';
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	0f be c0             	movsbl %al,%eax
  801409:	83 e8 30             	sub    $0x30,%eax
  80140c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140f:	eb 42                	jmp    801453 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 60                	cmp    $0x60,%al
  801418:	7e 19                	jle    801433 <strtol+0xe4>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 7a                	cmp    $0x7a,%al
  801421:	7f 10                	jg     801433 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	0f be c0             	movsbl %al,%eax
  80142b:	83 e8 57             	sub    $0x57,%eax
  80142e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801431:	eb 20                	jmp    801453 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	3c 40                	cmp    $0x40,%al
  80143a:	7e 39                	jle    801475 <strtol+0x126>
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3c 5a                	cmp    $0x5a,%al
  801443:	7f 30                	jg     801475 <strtol+0x126>
			dig = *s - 'A' + 10;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be c0             	movsbl %al,%eax
  80144d:	83 e8 37             	sub    $0x37,%eax
  801450:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801456:	3b 45 10             	cmp    0x10(%ebp),%eax
  801459:	7d 19                	jge    801474 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80145b:	ff 45 08             	incl   0x8(%ebp)
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801461:	0f af 45 10          	imul   0x10(%ebp),%eax
  801465:	89 c2                	mov    %eax,%edx
  801467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146a:	01 d0                	add    %edx,%eax
  80146c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80146f:	e9 7b ff ff ff       	jmp    8013ef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801474:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801479:	74 08                	je     801483 <strtol+0x134>
		*endptr = (char *) s;
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8b 55 08             	mov    0x8(%ebp),%edx
  801481:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801483:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801487:	74 07                	je     801490 <strtol+0x141>
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148c:	f7 d8                	neg    %eax
  80148e:	eb 03                	jmp    801493 <strtol+0x144>
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <ltostr>:

void
ltostr(long value, char *str)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80149b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ad:	79 13                	jns    8014c2 <ltostr+0x2d>
	{
		neg = 1;
  8014af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014bc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014bf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ca:	99                   	cltd   
  8014cb:	f7 f9                	idiv   %ecx
  8014cd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d3:	8d 50 01             	lea    0x1(%eax),%edx
  8014d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d9:	89 c2                	mov    %eax,%edx
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	01 d0                	add    %edx,%eax
  8014e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014e3:	83 c2 30             	add    $0x30,%edx
  8014e6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014f0:	f7 e9                	imul   %ecx
  8014f2:	c1 fa 02             	sar    $0x2,%edx
  8014f5:	89 c8                	mov    %ecx,%eax
  8014f7:	c1 f8 1f             	sar    $0x1f,%eax
  8014fa:	29 c2                	sub    %eax,%edx
  8014fc:	89 d0                	mov    %edx,%eax
  8014fe:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801501:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801504:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801509:	f7 e9                	imul   %ecx
  80150b:	c1 fa 02             	sar    $0x2,%edx
  80150e:	89 c8                	mov    %ecx,%eax
  801510:	c1 f8 1f             	sar    $0x1f,%eax
  801513:	29 c2                	sub    %eax,%edx
  801515:	89 d0                	mov    %edx,%eax
  801517:	c1 e0 02             	shl    $0x2,%eax
  80151a:	01 d0                	add    %edx,%eax
  80151c:	01 c0                	add    %eax,%eax
  80151e:	29 c1                	sub    %eax,%ecx
  801520:	89 ca                	mov    %ecx,%edx
  801522:	85 d2                	test   %edx,%edx
  801524:	75 9c                	jne    8014c2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801530:	48                   	dec    %eax
  801531:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801534:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801538:	74 3d                	je     801577 <ltostr+0xe2>
		start = 1 ;
  80153a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801541:	eb 34                	jmp    801577 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 45 0c             	mov    0xc(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	01 c2                	add    %eax,%edx
  801558:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80155b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155e:	01 c8                	add    %ecx,%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	01 c2                	add    %eax,%edx
  80156c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80156f:	88 02                	mov    %al,(%edx)
		start++ ;
  801571:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801574:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80157d:	7c c4                	jl     801543 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80157f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 54 fa ff ff       	call   800fef <strlen>
  80159b:	83 c4 04             	add    $0x4,%esp
  80159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	e8 46 fa ff ff       	call   800fef <strlen>
  8015a9:	83 c4 04             	add    $0x4,%esp
  8015ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015bd:	eb 17                	jmp    8015d6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	01 c2                	add    %eax,%edx
  8015c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	01 c8                	add    %ecx,%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015d3:	ff 45 fc             	incl   -0x4(%ebp)
  8015d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015dc:	7c e1                	jl     8015bf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ec:	eb 1f                	jmp    80160d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f1:	8d 50 01             	lea    0x1(%eax),%edx
  8015f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fc:	01 c2                	add    %eax,%edx
  8015fe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	01 c8                	add    %ecx,%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80160a:	ff 45 f8             	incl   -0x8(%ebp)
  80160d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801610:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801613:	7c d9                	jl     8015ee <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	c6 00 00             	movb   $0x0,(%eax)
}
  801620:	90                   	nop
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801626:	8b 45 14             	mov    0x14(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80162f:	8b 45 14             	mov    0x14(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801646:	eb 0c                	jmp    801654 <strsplit+0x31>
			*string++ = 0;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8d 50 01             	lea    0x1(%eax),%edx
  80164e:	89 55 08             	mov    %edx,0x8(%ebp)
  801651:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	84 c0                	test   %al,%al
  80165b:	74 18                	je     801675 <strsplit+0x52>
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	50                   	push   %eax
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	e8 13 fb ff ff       	call   801181 <strchr>
  80166e:	83 c4 08             	add    $0x8,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	75 d3                	jne    801648 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	84 c0                	test   %al,%al
  80167c:	74 5a                	je     8016d8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80167e:	8b 45 14             	mov    0x14(%ebp),%eax
  801681:	8b 00                	mov    (%eax),%eax
  801683:	83 f8 0f             	cmp    $0xf,%eax
  801686:	75 07                	jne    80168f <strsplit+0x6c>
		{
			return 0;
  801688:	b8 00 00 00 00       	mov    $0x0,%eax
  80168d:	eb 66                	jmp    8016f5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80168f:	8b 45 14             	mov    0x14(%ebp),%eax
  801692:	8b 00                	mov    (%eax),%eax
  801694:	8d 48 01             	lea    0x1(%eax),%ecx
  801697:	8b 55 14             	mov    0x14(%ebp),%edx
  80169a:	89 0a                	mov    %ecx,(%edx)
  80169c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a6:	01 c2                	add    %eax,%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ad:	eb 03                	jmp    8016b2 <strsplit+0x8f>
			string++;
  8016af:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	84 c0                	test   %al,%al
  8016b9:	74 8b                	je     801646 <strsplit+0x23>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f be c0             	movsbl %al,%eax
  8016c3:	50                   	push   %eax
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	e8 b5 fa ff ff       	call   801181 <strchr>
  8016cc:	83 c4 08             	add    $0x8,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	74 dc                	je     8016af <strsplit+0x8c>
			string++;
	}
  8016d3:	e9 6e ff ff ff       	jmp    801646 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dc:	8b 00                	mov    (%eax),%eax
  8016de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8016fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801704:	eb 4c                	jmp    801752 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801706:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	01 d0                	add    %edx,%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	3c 40                	cmp    $0x40,%al
  801712:	7e 27                	jle    80173b <str2lower+0x44>
  801714:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	01 d0                	add    %edx,%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3c 5a                	cmp    $0x5a,%al
  801720:	7f 19                	jg     80173b <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801722:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	01 d0                	add    %edx,%eax
  80172a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80172d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801730:	01 ca                	add    %ecx,%edx
  801732:	8a 12                	mov    (%edx),%dl
  801734:	83 c2 20             	add    $0x20,%edx
  801737:	88 10                	mov    %dl,(%eax)
  801739:	eb 14                	jmp    80174f <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80173b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	01 c2                	add    %eax,%edx
  801743:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	01 c8                	add    %ecx,%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80174f:	ff 45 fc             	incl   -0x4(%ebp)
  801752:	ff 75 0c             	pushl  0xc(%ebp)
  801755:	e8 95 f8 ff ff       	call   800fef <strlen>
  80175a:	83 c4 04             	add    $0x4,%esp
  80175d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801760:	7f a4                	jg     801706 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  80176c:	a1 04 50 80 00       	mov    0x805004,%eax
  801771:	85 c0                	test   %eax,%eax
  801773:	74 0a                	je     80177f <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801775:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80177c:	00 00 00 
	}
}
  80177f:	90                   	nop
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	e8 7e 09 00 00       	call   802111 <sys_sbrk>
  801793:	83 c4 10             	add    $0x10,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80179e:	e8 c6 ff ff ff       	call   801769 <InitializeUHeap>
	if (size == 0)
  8017a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017a7:	75 0a                	jne    8017b3 <malloc+0x1b>
		return NULL;
  8017a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ae:	e9 3f 01 00 00       	jmp    8018f2 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8017b3:	e8 ac 09 00 00       	call   802164 <sys_get_hard_limit>
  8017b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  8017bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  8017c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c5:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8017ca:	c1 e8 0c             	shr    $0xc,%eax
  8017cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  8017d0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8017d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	48                   	dec    %eax
  8017e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8017e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	f7 75 d8             	divl   -0x28(%ebp)
  8017ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017f1:	29 d0                	sub    %edx,%eax
  8017f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  8017f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017f9:	c1 e8 0c             	shr    $0xc,%eax
  8017fc:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  8017ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801803:	75 0a                	jne    80180f <malloc+0x77>
		return NULL;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
  80180a:	e9 e3 00 00 00       	jmp    8018f2 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  80180f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801812:	05 00 00 00 80       	add    $0x80000000,%eax
  801817:	c1 e8 0c             	shr    $0xc,%eax
  80181a:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80181f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801826:	77 19                	ja     801841 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	e8 60 0b 00 00       	call   802393 <alloc_block_FF>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801839:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80183c:	e9 b1 00 00 00       	jmp    8018f2 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801841:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801844:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801847:	eb 4d                	jmp    801896 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184c:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801853:	84 c0                	test   %al,%al
  801855:	75 27                	jne    80187e <malloc+0xe6>
			{
				counter++;
  801857:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  80185a:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80185e:	75 14                	jne    801874 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801860:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801863:	05 00 00 08 00       	add    $0x80000,%eax
  801868:	c1 e0 0c             	shl    $0xc,%eax
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  80186e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801871:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801877:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80187a:	75 17                	jne    801893 <malloc+0xfb>
				{
					break;
  80187c:	eb 21                	jmp    80189f <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  80187e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801881:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801888:	3c 01                	cmp    $0x1,%al
  80188a:	75 07                	jne    801893 <malloc+0xfb>
			{
				counter = 0;
  80188c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801893:	ff 45 e8             	incl   -0x18(%ebp)
  801896:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  80189d:	76 aa                	jbe    801849 <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  80189f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a2:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8018a5:	75 46                	jne    8018ed <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8018ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b0:	e8 93 08 00 00       	call   802148 <sys_allocate_user_mem>
  8018b5:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  8018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8018be:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8018c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018cb:	eb 0e                	jmp    8018db <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  8018cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d0:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  8018d7:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  8018d8:	ff 45 e4             	incl   -0x1c(%ebp)
  8018db:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8018de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e1:	01 d0                	add    %edx,%eax
  8018e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018e6:	77 e5                	ja     8018cd <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  8018e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018eb:	eb 05                	jmp    8018f2 <malloc+0x15a>
		}
	}

	return NULL;
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  8018fa:	e8 65 08 00 00       	call   802164 <sys_get_hard_limit>
  8018ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801908:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80190c:	0f 84 c1 00 00 00    	je     8019d3 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801915:	85 c0                	test   %eax,%eax
  801917:	79 1b                	jns    801934 <free+0x40>
  801919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80191f:	73 13                	jae    801934 <free+0x40>
    {
        free_block(virtual_address);
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 34 10 00 00       	call   802960 <free_block>
  80192c:	83 c4 10             	add    $0x10,%esp
    	return;
  80192f:	e9 a6 00 00 00       	jmp    8019da <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	05 00 10 00 00       	add    $0x1000,%eax
  80193c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80193f:	0f 87 91 00 00 00    	ja     8019d6 <free+0xe2>
  801945:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80194c:	0f 87 84 00 00 00    	ja     8019d6 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801955:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801960:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801966:	05 00 00 00 80       	add    $0x80000000,%eax
  80196b:	c1 e8 0c             	shr    $0xc,%eax
  80196e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801971:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801974:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  80197b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  80197e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801982:	74 55                	je     8019d9 <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801987:	c1 e8 0c             	shr    $0xc,%eax
  80198a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  80198d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801990:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801997:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  80199b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80199e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019a1:	eb 0e                	jmp    8019b1 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  8019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a6:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  8019ad:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  8019ae:	ff 45 f4             	incl   -0xc(%ebp)
  8019b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019b7:	01 c2                	add    %eax,%edx
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	77 e3                	ja     8019a3 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  8019c0:	83 ec 08             	sub    $0x8,%esp
  8019c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8019c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8019c9:	e8 5e 07 00 00       	call   80212c <sys_free_user_mem>
  8019ce:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  8019d1:	eb 07                	jmp    8019da <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  8019d3:	90                   	nop
  8019d4:	eb 04                	jmp    8019da <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  8019d6:	90                   	nop
  8019d7:	eb 01                	jmp    8019da <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  8019d9:	90                   	nop
    else
     {
    	return;
      }

}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 18             	sub    $0x18,%esp
  8019e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019e8:	e8 7c fd ff ff       	call   801769 <InitializeUHeap>
	if (size == 0)
  8019ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f1:	75 07                	jne    8019fa <smalloc+0x1e>
		return NULL;
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f8:	eb 17                	jmp    801a11 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	68 10 42 80 00       	push   $0x804210
  801a02:	68 ad 00 00 00       	push   $0xad
  801a07:	68 36 42 80 00       	push   $0x804236
  801a0c:	e8 0a 19 00 00       	call   80331b <_panic>
	return NULL;
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a19:	e8 4b fd ff ff       	call   801769 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	68 44 42 80 00       	push   $0x804244
  801a26:	68 ba 00 00 00       	push   $0xba
  801a2b:	68 36 42 80 00       	push   $0x804236
  801a30:	e8 e6 18 00 00       	call   80331b <_panic>

00801a35 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a3b:	e8 29 fd ff ff       	call   801769 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 68 42 80 00       	push   $0x804268
  801a48:	68 d8 00 00 00       	push   $0xd8
  801a4d:	68 36 42 80 00       	push   $0x804236
  801a52:	e8 c4 18 00 00       	call   80331b <_panic>

00801a57 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	68 90 42 80 00       	push   $0x804290
  801a65:	68 ea 00 00 00       	push   $0xea
  801a6a:	68 36 42 80 00       	push   $0x804236
  801a6f:	e8 a7 18 00 00       	call   80331b <_panic>

00801a74 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	68 b4 42 80 00       	push   $0x8042b4
  801a82:	68 f2 00 00 00       	push   $0xf2
  801a87:	68 36 42 80 00       	push   $0x804236
  801a8c:	e8 8a 18 00 00       	call   80331b <_panic>

00801a91 <shrink>:

}
void shrink(uint32 newSize) {
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 b4 42 80 00       	push   $0x8042b4
  801a9f:	68 f6 00 00 00       	push   $0xf6
  801aa4:	68 36 42 80 00       	push   $0x804236
  801aa9:	e8 6d 18 00 00       	call   80331b <_panic>

00801aae <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	68 b4 42 80 00       	push   $0x8042b4
  801abc:	68 fa 00 00 00       	push   $0xfa
  801ac1:	68 36 42 80 00       	push   $0x804236
  801ac6:	e8 50 18 00 00       	call   80331b <_panic>

00801acb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	57                   	push   %edi
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ada:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801add:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ae3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ae6:	cd 30                	int    $0x30
  801ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5f                   	pop    %edi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	8b 45 10             	mov    0x10(%ebp),%eax
  801aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	52                   	push   %edx
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	6a 00                	push   $0x0
  801b14:	e8 b2 ff ff ff       	call   801acb <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	90                   	nop
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 01                	push   $0x1
  801b2e:	e8 98 ff ff ff       	call   801acb <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	52                   	push   %edx
  801b48:	50                   	push   %eax
  801b49:	6a 05                	push   $0x5
  801b4b:	e8 7b ff ff ff       	call   801acb <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b5a:	8b 75 18             	mov    0x18(%ebp),%esi
  801b5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	56                   	push   %esi
  801b6a:	53                   	push   %ebx
  801b6b:	51                   	push   %ecx
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 06                	push   $0x6
  801b70:	e8 56 ff ff ff       	call   801acb <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 07                	push   $0x7
  801b92:	e8 34 ff ff ff       	call   801acb <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	ff 75 08             	pushl  0x8(%ebp)
  801bab:	6a 08                	push   $0x8
  801bad:	e8 19 ff ff ff       	call   801acb <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 09                	push   $0x9
  801bc6:	e8 00 ff ff ff       	call   801acb <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 0a                	push   $0xa
  801bdf:	e8 e7 fe ff ff       	call   801acb <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 0b                	push   $0xb
  801bf8:	e8 ce fe ff ff       	call   801acb <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 0c                	push   $0xc
  801c11:	e8 b5 fe ff ff       	call   801acb <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	ff 75 08             	pushl  0x8(%ebp)
  801c29:	6a 0d                	push   $0xd
  801c2b:	e8 9b fe ff ff       	call   801acb <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 0e                	push   $0xe
  801c44:	e8 82 fe ff ff       	call   801acb <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 11                	push   $0x11
  801c5e:	e8 68 fe ff ff       	call   801acb <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 12                	push   $0x12
  801c78:	e8 4e fe ff ff       	call   801acb <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	90                   	nop
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c8f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	50                   	push   %eax
  801c9c:	6a 13                	push   $0x13
  801c9e:	e8 28 fe ff ff       	call   801acb <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	90                   	nop
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 14                	push   $0x14
  801cb8:	e8 0e fe ff ff       	call   801acb <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	50                   	push   %eax
  801cd3:	6a 15                	push   $0x15
  801cd5:	e8 f1 fd ff ff       	call   801acb <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	6a 18                	push   $0x18
  801cf2:	e8 d4 fd ff ff       	call   801acb <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 16                	push   $0x16
  801d0f:	e8 b7 fd ff ff       	call   801acb <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	90                   	nop
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	52                   	push   %edx
  801d2a:	50                   	push   %eax
  801d2b:	6a 17                	push   $0x17
  801d2d:	e8 99 fd ff ff       	call   801acb <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	90                   	nop
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d41:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d44:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d47:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	6a 00                	push   $0x0
  801d50:	51                   	push   %ecx
  801d51:	52                   	push   %edx
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	50                   	push   %eax
  801d56:	6a 19                	push   $0x19
  801d58:	e8 6e fd ff ff       	call   801acb <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	6a 1a                	push   $0x1a
  801d75:	e8 51 fd ff ff       	call   801acb <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	51                   	push   %ecx
  801d90:	52                   	push   %edx
  801d91:	50                   	push   %eax
  801d92:	6a 1b                	push   $0x1b
  801d94:	e8 32 fd ff ff       	call   801acb <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	52                   	push   %edx
  801dae:	50                   	push   %eax
  801daf:	6a 1c                	push   $0x1c
  801db1:	e8 15 fd ff ff       	call   801acb <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 1d                	push   $0x1d
  801dca:	e8 fc fc ff ff       	call   801acb <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	ff 75 14             	pushl  0x14(%ebp)
  801ddf:	ff 75 10             	pushl  0x10(%ebp)
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	50                   	push   %eax
  801de6:	6a 1e                	push   $0x1e
  801de8:	e8 de fc ff ff       	call   801acb <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	50                   	push   %eax
  801e01:	6a 1f                	push   $0x1f
  801e03:	e8 c3 fc ff ff       	call   801acb <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	90                   	nop
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	50                   	push   %eax
  801e1d:	6a 20                	push   $0x20
  801e1f:	e8 a7 fc ff ff       	call   801acb <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 02                	push   $0x2
  801e38:	e8 8e fc ff ff       	call   801acb <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 03                	push   $0x3
  801e51:	e8 75 fc ff ff       	call   801acb <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 04                	push   $0x4
  801e6a:	e8 5c fc ff ff       	call   801acb <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_exit_env>:


void sys_exit_env(void)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 21                	push   $0x21
  801e83:	e8 43 fc ff ff       	call   801acb <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	90                   	nop
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e94:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e97:	8d 50 04             	lea    0x4(%eax),%edx
  801e9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	52                   	push   %edx
  801ea4:	50                   	push   %eax
  801ea5:	6a 22                	push   $0x22
  801ea7:	e8 1f fc ff ff       	call   801acb <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return result;
  801eaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eb8:	89 01                	mov    %eax,(%ecx)
  801eba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	c9                   	leave  
  801ec1:	c2 04 00             	ret    $0x4

00801ec4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	ff 75 10             	pushl  0x10(%ebp)
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	ff 75 08             	pushl  0x8(%ebp)
  801ed4:	6a 10                	push   $0x10
  801ed6:	e8 f0 fb ff ff       	call   801acb <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ede:	90                   	nop
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 23                	push   $0x23
  801ef0:	e8 d6 fb ff ff       	call   801acb <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f06:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	50                   	push   %eax
  801f13:	6a 24                	push   $0x24
  801f15:	e8 b1 fb ff ff       	call   801acb <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1d:	90                   	nop
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <rsttst>:
void rsttst()
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 26                	push   $0x26
  801f2f:	e8 97 fb ff ff       	call   801acb <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
	return ;
  801f37:	90                   	nop
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	8b 45 14             	mov    0x14(%ebp),%eax
  801f43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f46:	8b 55 18             	mov    0x18(%ebp),%edx
  801f49:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	ff 75 10             	pushl  0x10(%ebp)
  801f52:	ff 75 0c             	pushl  0xc(%ebp)
  801f55:	ff 75 08             	pushl  0x8(%ebp)
  801f58:	6a 25                	push   $0x25
  801f5a:	e8 6c fb ff ff       	call   801acb <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f62:	90                   	nop
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <chktst>:
void chktst(uint32 n)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	ff 75 08             	pushl  0x8(%ebp)
  801f73:	6a 27                	push   $0x27
  801f75:	e8 51 fb ff ff       	call   801acb <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <inctst>:

void inctst()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 28                	push   $0x28
  801f8f:	e8 37 fb ff ff       	call   801acb <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
	return ;
  801f97:	90                   	nop
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <gettst>:
uint32 gettst()
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 29                	push   $0x29
  801fa9:	e8 1d fb ff ff       	call   801acb <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 2a                	push   $0x2a
  801fc5:	e8 01 fb ff ff       	call   801acb <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
  801fcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fd0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fd4:	75 07                	jne    801fdd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdb:	eb 05                	jmp    801fe2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 2a                	push   $0x2a
  801ff6:	e8 d0 fa ff ff       	call   801acb <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
  801ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802001:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802005:	75 07                	jne    80200e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802007:	b8 01 00 00 00       	mov    $0x1,%eax
  80200c:	eb 05                	jmp    802013 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 2a                	push   $0x2a
  802027:	e8 9f fa ff ff       	call   801acb <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
  80202f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802032:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802036:	75 07                	jne    80203f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802038:	b8 01 00 00 00       	mov    $0x1,%eax
  80203d:	eb 05                	jmp    802044 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 2a                	push   $0x2a
  802058:	e8 6e fa ff ff       	call   801acb <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
  802060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802063:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802067:	75 07                	jne    802070 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802069:	b8 01 00 00 00       	mov    $0x1,%eax
  80206e:	eb 05                	jmp    802075 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	ff 75 08             	pushl  0x8(%ebp)
  802085:	6a 2b                	push   $0x2b
  802087:	e8 3f fa ff ff       	call   801acb <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
	return ;
  80208f:	90                   	nop
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802096:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802099:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80209c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	53                   	push   %ebx
  8020a5:	51                   	push   %ecx
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 2c                	push   $0x2c
  8020aa:	e8 1c fa ff ff       	call   801acb <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	52                   	push   %edx
  8020c7:	50                   	push   %eax
  8020c8:	6a 2d                	push   $0x2d
  8020ca:	e8 fc f9 ff ff       	call   801acb <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8020d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	6a 00                	push   $0x0
  8020e2:	51                   	push   %ecx
  8020e3:	ff 75 10             	pushl  0x10(%ebp)
  8020e6:	52                   	push   %edx
  8020e7:	50                   	push   %eax
  8020e8:	6a 2e                	push   $0x2e
  8020ea:	e8 dc f9 ff ff       	call   801acb <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	ff 75 10             	pushl  0x10(%ebp)
  8020fe:	ff 75 0c             	pushl  0xc(%ebp)
  802101:	ff 75 08             	pushl  0x8(%ebp)
  802104:	6a 0f                	push   $0xf
  802106:	e8 c0 f9 ff ff       	call   801acb <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
	return ;
  80210e:	90                   	nop
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	50                   	push   %eax
  802120:	6a 2f                	push   $0x2f
  802122:	e8 a4 f9 ff ff       	call   801acb <syscall>
  802127:	83 c4 18             	add    $0x18,%esp

}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	ff 75 08             	pushl  0x8(%ebp)
  80213b:	6a 30                	push   $0x30
  80213d:	e8 89 f9 ff ff       	call   801acb <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
	return;
  802145:	90                   	nop
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	ff 75 08             	pushl  0x8(%ebp)
  802157:	6a 31                	push   $0x31
  802159:	e8 6d f9 ff ff       	call   801acb <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
	return;
  802161:	90                   	nop
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 32                	push   $0x32
  802173:	e8 53 f9 ff ff       	call   801acb <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	50                   	push   %eax
  80218c:	6a 33                	push   $0x33
  80218e:	e8 38 f9 ff ff       	call   801acb <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	90                   	nop
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	83 e8 10             	sub    $0x10,%eax
  8021a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  8021a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ab:	8b 00                	mov    (%eax),%eax
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	83 e8 10             	sub    $0x10,%eax
  8021bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  8021be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c1:	8a 40 04             	mov    0x4(%eax),%al
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8021cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8021d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d6:	83 f8 02             	cmp    $0x2,%eax
  8021d9:	74 2b                	je     802206 <alloc_block+0x40>
  8021db:	83 f8 02             	cmp    $0x2,%eax
  8021de:	7f 07                	jg     8021e7 <alloc_block+0x21>
  8021e0:	83 f8 01             	cmp    $0x1,%eax
  8021e3:	74 0e                	je     8021f3 <alloc_block+0x2d>
  8021e5:	eb 58                	jmp    80223f <alloc_block+0x79>
  8021e7:	83 f8 03             	cmp    $0x3,%eax
  8021ea:	74 2d                	je     802219 <alloc_block+0x53>
  8021ec:	83 f8 04             	cmp    $0x4,%eax
  8021ef:	74 3b                	je     80222c <alloc_block+0x66>
  8021f1:	eb 4c                	jmp    80223f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	ff 75 08             	pushl  0x8(%ebp)
  8021f9:	e8 95 01 00 00       	call   802393 <alloc_block_FF>
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802204:	eb 4a                	jmp    802250 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802206:	83 ec 0c             	sub    $0xc,%esp
  802209:	ff 75 08             	pushl  0x8(%ebp)
  80220c:	e8 32 07 00 00       	call   802943 <alloc_block_NF>
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802217:	eb 37                	jmp    802250 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 a3 04 00 00       	call   8026c7 <alloc_block_BF>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80222a:	eb 24                	jmp    802250 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	ff 75 08             	pushl  0x8(%ebp)
  802232:	e8 ef 06 00 00       	call   802926 <alloc_block_WF>
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80223d:	eb 11                	jmp    802250 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	68 c4 42 80 00       	push   $0x8042c4
  802247:	e8 21 e7 ff ff       	call   80096d <cprintf>
  80224c:	83 c4 10             	add    $0x10,%esp
		break;
  80224f:	90                   	nop
	}
	return va;
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  80225b:	83 ec 0c             	sub    $0xc,%esp
  80225e:	68 e4 42 80 00       	push   $0x8042e4
  802263:	e8 05 e7 ff ff       	call   80096d <cprintf>
  802268:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  80226b:	83 ec 0c             	sub    $0xc,%esp
  80226e:	68 0f 43 80 00       	push   $0x80430f
  802273:	e8 f5 e6 ff ff       	call   80096d <cprintf>
  802278:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	eb 26                	jmp    8022a9 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8a 40 04             	mov    0x4(%eax),%al
  802289:	0f b6 d0             	movzbl %al,%edx
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 00                	mov    (%eax),%eax
  802291:	83 ec 04             	sub    $0x4,%esp
  802294:	52                   	push   %edx
  802295:	50                   	push   %eax
  802296:	68 27 43 80 00       	push   $0x804327
  80229b:	e8 cd e6 ff ff       	call   80096d <cprintf>
  8022a0:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ad:	74 08                	je     8022b7 <print_blocks_list+0x62>
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 08             	mov    0x8(%eax),%eax
  8022b5:	eb 05                	jmp    8022bc <print_blocks_list+0x67>
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	89 45 10             	mov    %eax,0x10(%ebp)
  8022bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	75 bd                	jne    802283 <print_blocks_list+0x2e>
  8022c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ca:	75 b7                	jne    802283 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  8022cc:	83 ec 0c             	sub    $0xc,%esp
  8022cf:	68 e4 42 80 00       	push   $0x8042e4
  8022d4:	e8 94 e6 ff ff       	call   80096d <cprintf>
  8022d9:	83 c4 10             	add    $0x10,%esp

}
  8022dc:	90                   	nop
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  8022e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022e9:	0f 84 a1 00 00 00    	je     802390 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  8022ef:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  8022f6:	00 00 00 
	LIST_INIT(&list);
  8022f9:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802300:	00 00 00 
  802303:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  80230a:	00 00 00 
  80230d:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802314:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232a:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  80232c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802330:	75 14                	jne    802346 <initialize_dynamic_allocator+0x67>
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 40 43 80 00       	push   $0x804340
  80233a:	6a 64                	push   $0x64
  80233c:	68 63 43 80 00       	push   $0x804363
  802341:	e8 d5 0f 00 00       	call   80331b <_panic>
  802346:	8b 15 44 51 90 00    	mov    0x905144,%edx
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	89 50 0c             	mov    %edx,0xc(%eax)
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 40 0c             	mov    0xc(%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	74 0d                	je     802369 <initialize_dynamic_allocator+0x8a>
  80235c:	a1 44 51 90 00       	mov    0x905144,%eax
  802361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802364:	89 50 08             	mov    %edx,0x8(%eax)
  802367:	eb 08                	jmp    802371 <initialize_dynamic_allocator+0x92>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	a3 40 51 90 00       	mov    %eax,0x905140
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	a3 44 51 90 00       	mov    %eax,0x905144
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802383:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802388:	40                   	inc    %eax
  802389:	a3 4c 51 90 00       	mov    %eax,0x90514c
  80238e:	eb 01                	jmp    802391 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  802390:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  802399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239d:	75 0a                	jne    8023a9 <alloc_block_FF+0x16>
	{
		return NULL;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a4:	e9 1c 03 00 00       	jmp    8026c5 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8023a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	75 40                	jne    8023f2 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	83 c0 10             	add    $0x10,%eax
  8023b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8023bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023be:	83 ec 0c             	sub    $0xc,%esp
  8023c1:	50                   	push   %eax
  8023c2:	e8 bb f3 ff ff       	call   801782 <sbrk>
  8023c7:	83 c4 10             	add    $0x10,%esp
  8023ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  8023cd:	83 ec 0c             	sub    $0xc,%esp
  8023d0:	6a 00                	push   $0x0
  8023d2:	e8 ab f3 ff ff       	call   801782 <sbrk>
  8023d7:	83 c4 10             	add    $0x10,%esp
  8023da:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8023dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8023e3:	83 ec 08             	sub    $0x8,%esp
  8023e6:	50                   	push   %eax
  8023e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8023ea:	e8 f0 fe ff ff       	call   8022df <initialize_dynamic_allocator>
  8023ef:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  8023f2:	a1 40 51 90 00       	mov    0x905140,%eax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fa:	e9 1e 01 00 00       	jmp    80251d <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8d 50 10             	lea    0x10(%eax),%edx
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	39 c2                	cmp    %eax,%edx
  80240c:	75 1c                	jne    80242a <alloc_block_FF+0x97>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8a 40 04             	mov    0x4(%eax),%al
  802414:	3c 01                	cmp    $0x1,%al
  802416:	75 12                	jne    80242a <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	83 c0 10             	add    $0x10,%eax
  802425:	e9 9b 02 00 00       	jmp    8026c5 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	8d 50 10             	lea    0x10(%eax),%edx
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	39 c2                	cmp    %eax,%edx
  802437:	0f 83 d8 00 00 00    	jae    802515 <alloc_block_FF+0x182>
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8a 40 04             	mov    0x4(%eax),%al
  802443:	3c 01                	cmp    $0x1,%al
  802445:	0f 85 ca 00 00 00    	jne    802515 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	2b 45 08             	sub    0x8(%ebp),%eax
  802453:	83 e8 10             	sub    $0x10,%eax
  802456:	83 f8 0f             	cmp    $0xf,%eax
  802459:	0f 86 a4 00 00 00    	jbe    802503 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  80245f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	01 d0                	add    %edx,%eax
  802467:	83 c0 10             	add    $0x10,%eax
  80246a:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	2b 45 08             	sub    0x8(%ebp),%eax
  802475:	8d 50 f0             	lea    -0x10(%eax),%edx
  802478:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80247b:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  80247d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802480:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802488:	74 06                	je     802490 <alloc_block_FF+0xfd>
  80248a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80248e:	75 17                	jne    8024a7 <alloc_block_FF+0x114>
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 7c 43 80 00       	push   $0x80437c
  802498:	68 8f 00 00 00       	push   $0x8f
  80249d:	68 63 43 80 00       	push   $0x804363
  8024a2:	e8 74 0e 00 00       	call   80331b <_panic>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 50 08             	mov    0x8(%eax),%edx
  8024ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b0:	89 50 08             	mov    %edx,0x8(%eax)
  8024b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b6:	8b 40 08             	mov    0x8(%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 0c                	je     8024c9 <alloc_block_FF+0x136>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 08             	mov    0x8(%eax),%eax
  8024c3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8024c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8024cf:	89 50 08             	mov    %edx,0x8(%eax)
  8024d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d8:	89 50 0c             	mov    %edx,0xc(%eax)
  8024db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024de:	8b 40 08             	mov    0x8(%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	75 08                	jne    8024ed <alloc_block_FF+0x15a>
  8024e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e8:	a3 44 51 90 00       	mov    %eax,0x905144
  8024ed:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8024f2:	40                   	inc    %eax
  8024f3:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	8d 50 10             	lea    0x10(%eax),%edx
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	83 c0 10             	add    $0x10,%eax
  802510:	e9 b0 01 00 00       	jmp    8026c5 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802515:	a1 48 51 90 00       	mov    0x905148,%eax
  80251a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802521:	74 08                	je     80252b <alloc_block_FF+0x198>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 08             	mov    0x8(%eax),%eax
  802529:	eb 05                	jmp    802530 <alloc_block_FF+0x19d>
  80252b:	b8 00 00 00 00       	mov    $0x0,%eax
  802530:	a3 48 51 90 00       	mov    %eax,0x905148
  802535:	a1 48 51 90 00       	mov    0x905148,%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	0f 85 bd fe ff ff    	jne    8023ff <alloc_block_FF+0x6c>
  802542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802546:	0f 85 b3 fe ff ff    	jne    8023ff <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	83 c0 10             	add    $0x10,%eax
  802552:	83 ec 0c             	sub    $0xc,%esp
  802555:	50                   	push   %eax
  802556:	e8 27 f2 ff ff       	call   801782 <sbrk>
  80255b:	83 c4 10             	add    $0x10,%esp
  80255e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802561:	83 ec 0c             	sub    $0xc,%esp
  802564:	6a 00                	push   $0x0
  802566:	e8 17 f2 ff ff       	call   801782 <sbrk>
  80256b:	83 c4 10             	add    $0x10,%esp
  80256e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802571:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802577:	29 c2                	sub    %eax,%edx
  802579:	89 d0                	mov    %edx,%eax
  80257b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  80257e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802582:	0f 84 38 01 00 00    	je     8026c0 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  802588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  80258e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802592:	75 17                	jne    8025ab <alloc_block_FF+0x218>
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 40 43 80 00       	push   $0x804340
  80259c:	68 9f 00 00 00       	push   $0x9f
  8025a1:	68 63 43 80 00       	push   $0x804363
  8025a6:	e8 70 0d 00 00       	call   80331b <_panic>
  8025ab:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8025b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025b4:	89 50 0c             	mov    %edx,0xc(%eax)
  8025b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0d                	je     8025ce <alloc_block_FF+0x23b>
  8025c1:	a1 44 51 90 00       	mov    0x905144,%eax
  8025c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025c9:	89 50 08             	mov    %edx,0x8(%eax)
  8025cc:	eb 08                	jmp    8025d6 <alloc_block_FF+0x243>
  8025ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025d1:	a3 40 51 90 00       	mov    %eax,0x905140
  8025d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025d9:	a3 44 51 90 00       	mov    %eax,0x905144
  8025de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025e8:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8025ed:	40                   	inc    %eax
  8025ee:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	8d 50 10             	lea    0x10(%eax),%edx
  8025f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025fc:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  8025fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802601:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802605:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802608:	2b 45 08             	sub    0x8(%ebp),%eax
  80260b:	83 f8 10             	cmp    $0x10,%eax
  80260e:	0f 84 a4 00 00 00    	je     8026b8 <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802614:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802617:	2b 45 08             	sub    0x8(%ebp),%eax
  80261a:	83 e8 10             	sub    $0x10,%eax
  80261d:	83 f8 0f             	cmp    $0xf,%eax
  802620:	0f 86 8a 00 00 00    	jbe    8026b0 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802626:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	01 d0                	add    %edx,%eax
  80262e:	83 c0 10             	add    $0x10,%eax
  802631:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802634:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802638:	75 17                	jne    802651 <alloc_block_FF+0x2be>
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	68 40 43 80 00       	push   $0x804340
  802642:	68 a7 00 00 00       	push   $0xa7
  802647:	68 63 43 80 00       	push   $0x804363
  80264c:	e8 ca 0c 00 00       	call   80331b <_panic>
  802651:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802657:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80265a:	89 50 0c             	mov    %edx,0xc(%eax)
  80265d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	85 c0                	test   %eax,%eax
  802665:	74 0d                	je     802674 <alloc_block_FF+0x2e1>
  802667:	a1 44 51 90 00       	mov    0x905144,%eax
  80266c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80266f:	89 50 08             	mov    %edx,0x8(%eax)
  802672:	eb 08                	jmp    80267c <alloc_block_FF+0x2e9>
  802674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802677:	a3 40 51 90 00       	mov    %eax,0x905140
  80267c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267f:	a3 44 51 90 00       	mov    %eax,0x905144
  802684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802687:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80268e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802693:	40                   	inc    %eax
  802694:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80269c:	2b 45 08             	sub    0x8(%ebp),%eax
  80269f:	8d 50 f0             	lea    -0x10(%eax),%edx
  8026a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a5:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  8026a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026aa:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  8026ae:	eb 08                	jmp    8026b8 <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  8026b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026b6:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  8026b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026bb:	83 c0 10             	add    $0x10,%eax
  8026be:	eb 05                	jmp    8026c5 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  8026cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  8026d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d8:	75 0a                	jne    8026e4 <alloc_block_BF+0x1d>
	{
		return NULL;
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	e9 40 02 00 00       	jmp    802924 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  8026e4:	a1 40 51 90 00       	mov    0x905140,%eax
  8026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ec:	eb 66                	jmp    802754 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8a 40 04             	mov    0x4(%eax),%al
  8026f4:	3c 01                	cmp    $0x1,%al
  8026f6:	75 21                	jne    802719 <alloc_block_BF+0x52>
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	8d 50 10             	lea    0x10(%eax),%edx
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	39 c2                	cmp    %eax,%edx
  802705:	75 12                	jne    802719 <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	83 c0 10             	add    $0x10,%eax
  802714:	e9 0b 02 00 00       	jmp    802924 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8a 40 04             	mov    0x4(%eax),%al
  80271f:	3c 01                	cmp    $0x1,%al
  802721:	75 29                	jne    80274c <alloc_block_BF+0x85>
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	8d 50 10             	lea    0x10(%eax),%edx
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	39 c2                	cmp    %eax,%edx
  802730:	77 1a                	ja     80274c <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802732:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802736:	74 0e                	je     802746 <alloc_block_BF+0x7f>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 10                	mov    (%eax),%edx
  80273d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	39 c2                	cmp    %eax,%edx
  802744:	73 06                	jae    80274c <alloc_block_BF+0x85>
			{
				BF = iterator;
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  80274c:	a1 48 51 90 00       	mov    0x905148,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	74 08                	je     802762 <alloc_block_BF+0x9b>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 08             	mov    0x8(%eax),%eax
  802760:	eb 05                	jmp    802767 <alloc_block_BF+0xa0>
  802762:	b8 00 00 00 00       	mov    $0x0,%eax
  802767:	a3 48 51 90 00       	mov    %eax,0x905148
  80276c:	a1 48 51 90 00       	mov    0x905148,%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	0f 85 75 ff ff ff    	jne    8026ee <alloc_block_BF+0x27>
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	0f 85 6b ff ff ff    	jne    8026ee <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802783:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802787:	0f 84 f8 00 00 00    	je     802885 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	8d 50 10             	lea    0x10(%eax),%edx
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	39 c2                	cmp    %eax,%edx
  80279a:	0f 87 e5 00 00 00    	ja     802885 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a8:	83 e8 10             	sub    $0x10,%eax
  8027ab:	83 f8 0f             	cmp    $0xf,%eax
  8027ae:	0f 86 bf 00 00 00    	jbe    802873 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  8027b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	83 c0 10             	add    $0x10,%eax
  8027bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  8027c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d3:	8d 50 f0             	lea    -0x10(%eax),%edx
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  8027e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e6:	74 06                	je     8027ee <alloc_block_BF+0x127>
  8027e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ec:	75 17                	jne    802805 <alloc_block_BF+0x13e>
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 7c 43 80 00       	push   $0x80437c
  8027f6:	68 e3 00 00 00       	push   $0xe3
  8027fb:	68 63 43 80 00       	push   $0x804363
  802800:	e8 16 0b 00 00       	call   80331b <_panic>
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 50 08             	mov    0x8(%eax),%edx
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	89 50 08             	mov    %edx,0x8(%eax)
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 40 08             	mov    0x8(%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0c                	je     802827 <alloc_block_BF+0x160>
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	8b 40 08             	mov    0x8(%eax),%eax
  802821:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802824:	89 50 0c             	mov    %edx,0xc(%eax)
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282d:	89 50 08             	mov    %edx,0x8(%eax)
  802830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802833:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802836:	89 50 0c             	mov    %edx,0xc(%eax)
  802839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283c:	8b 40 08             	mov    0x8(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	75 08                	jne    80284b <alloc_block_BF+0x184>
  802843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802846:	a3 44 51 90 00       	mov    %eax,0x905144
  80284b:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802850:	40                   	inc    %eax
  802851:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	8d 50 10             	lea    0x10(%eax),%edx
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	83 c0 10             	add    $0x10,%eax
  80286e:	e9 b1 00 00 00       	jmp    802924 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	83 c0 10             	add    $0x10,%eax
  802880:	e9 9f 00 00 00       	jmp    802924 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	83 c0 10             	add    $0x10,%eax
  80288b:	83 ec 0c             	sub    $0xc,%esp
  80288e:	50                   	push   %eax
  80288f:	e8 ee ee ff ff       	call   801782 <sbrk>
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  80289a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80289e:	74 7f                	je     80291f <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  8028a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a4:	75 17                	jne    8028bd <alloc_block_BF+0x1f6>
  8028a6:	83 ec 04             	sub    $0x4,%esp
  8028a9:	68 40 43 80 00       	push   $0x804340
  8028ae:	68 f6 00 00 00       	push   $0xf6
  8028b3:	68 63 43 80 00       	push   $0x804363
  8028b8:	e8 5e 0a 00 00       	call   80331b <_panic>
  8028bd:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8028c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8028c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 0d                	je     8028e0 <alloc_block_BF+0x219>
  8028d3:	a1 44 51 90 00       	mov    0x905144,%eax
  8028d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028db:	89 50 08             	mov    %edx,0x8(%eax)
  8028de:	eb 08                	jmp    8028e8 <alloc_block_BF+0x221>
  8028e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e3:	a3 40 51 90 00       	mov    %eax,0x905140
  8028e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028eb:	a3 44 51 90 00       	mov    %eax,0x905144
  8028f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028fa:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8028ff:	40                   	inc    %eax
  802900:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	8d 50 10             	lea    0x10(%eax),%edx
  80290b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290e:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802910:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802913:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291a:	83 c0 10             	add    $0x10,%eax
  80291d:	eb 05                	jmp    802924 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  80291f:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	68 b0 43 80 00       	push   $0x8043b0
  802934:	68 07 01 00 00       	push   $0x107
  802939:	68 63 43 80 00       	push   $0x804363
  80293e:	e8 d8 09 00 00       	call   80331b <_panic>

00802943 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
  802946:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802949:	83 ec 04             	sub    $0x4,%esp
  80294c:	68 d8 43 80 00       	push   $0x8043d8
  802951:	68 0f 01 00 00       	push   $0x10f
  802956:	68 63 43 80 00       	push   $0x804363
  80295b:	e8 bb 09 00 00       	call   80331b <_panic>

00802960 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802966:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296a:	0f 84 ee 05 00 00    	je     802f5e <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	83 e8 10             	sub    $0x10,%eax
  802976:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802979:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  80297d:	a1 40 51 90 00       	mov    0x905140,%eax
  802982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802985:	eb 16                	jmp    80299d <free_block+0x3d>
	{
		if (block_pointer == it)
  802987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80298d:	75 06                	jne    802995 <free_block+0x35>
		{
			flagx = 1;
  80298f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802993:	eb 2f                	jmp    8029c4 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802995:	a1 48 51 90 00       	mov    0x905148,%eax
  80299a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80299d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a1:	74 08                	je     8029ab <free_block+0x4b>
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	8b 40 08             	mov    0x8(%eax),%eax
  8029a9:	eb 05                	jmp    8029b0 <free_block+0x50>
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	a3 48 51 90 00       	mov    %eax,0x905148
  8029b5:	a1 48 51 90 00       	mov    0x905148,%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	75 c9                	jne    802987 <free_block+0x27>
  8029be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c2:	75 c3                	jne    802987 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  8029c4:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8029c8:	0f 84 93 05 00 00    	je     802f61 <free_block+0x601>
		return;
	if (va == NULL)
  8029ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d2:	0f 84 8c 05 00 00    	je     802f64 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  8029d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	8b 40 08             	mov    0x8(%eax),%eax
  8029e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  8029ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ee:	75 12                	jne    802a02 <free_block+0xa2>
  8029f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029f4:	75 0c                	jne    802a02 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  8029f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  8029fd:	e9 63 05 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802a02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a06:	0f 85 ca 00 00 00    	jne    802ad6 <free_block+0x176>
  802a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0f:	8a 40 04             	mov    0x4(%eax),%al
  802a12:	3c 01                	cmp    $0x1,%al
  802a14:	0f 85 bc 00 00 00    	jne    802ad6 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a24:	8b 10                	mov    (%eax),%edx
  802a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	01 c2                	add    %eax,%edx
  802a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a30:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802a42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a46:	75 17                	jne    802a5f <free_block+0xff>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 fe 43 80 00       	push   $0x8043fe
  802a50:	68 3c 01 00 00       	push   $0x13c
  802a55:	68 63 43 80 00       	push   $0x804363
  802a5a:	e8 bc 08 00 00       	call   80331b <_panic>
  802a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 11                	je     802a7a <free_block+0x11a>
  802a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6c:	8b 40 08             	mov    0x8(%eax),%eax
  802a6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a72:	8b 52 0c             	mov    0xc(%edx),%edx
  802a75:	89 50 0c             	mov    %edx,0xc(%eax)
  802a78:	eb 0b                	jmp    802a85 <free_block+0x125>
  802a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a80:	a3 44 51 90 00       	mov    %eax,0x905144
  802a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a88:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 11                	je     802aa0 <free_block+0x140>
  802a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a98:	8b 52 08             	mov    0x8(%edx),%edx
  802a9b:	89 50 08             	mov    %edx,0x8(%eax)
  802a9e:	eb 0b                	jmp    802aab <free_block+0x14b>
  802aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa3:	8b 40 08             	mov    0x8(%eax),%eax
  802aa6:	a3 40 51 90 00       	mov    %eax,0x905140
  802aab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802abf:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ac4:	48                   	dec    %eax
  802ac5:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802aca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802ad1:	e9 8f 04 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802ad6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ada:	75 16                	jne    802af2 <free_block+0x192>
  802adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802adf:	8a 40 04             	mov    0x4(%eax),%al
  802ae2:	84 c0                	test   %al,%al
  802ae4:	75 0c                	jne    802af2 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802aed:	e9 73 04 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802af2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802af6:	0f 85 c3 00 00 00    	jne    802bbf <free_block+0x25f>
  802afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aff:	8a 40 04             	mov    0x4(%eax),%al
  802b02:	3c 01                	cmp    $0x1,%al
  802b04:	0f 85 b5 00 00 00    	jne    802bbf <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	8b 10                	mov    (%eax),%edx
  802b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	01 c2                	add    %eax,%edx
  802b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b19:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b2f:	75 17                	jne    802b48 <free_block+0x1e8>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 fe 43 80 00       	push   $0x8043fe
  802b39:	68 49 01 00 00       	push   $0x149
  802b3e:	68 63 43 80 00       	push   $0x804363
  802b43:	e8 d3 07 00 00       	call   80331b <_panic>
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 40 08             	mov    0x8(%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 11                	je     802b63 <free_block+0x203>
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 40 08             	mov    0x8(%eax),%eax
  802b58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5b:	8b 52 0c             	mov    0xc(%edx),%edx
  802b5e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b61:	eb 0b                	jmp    802b6e <free_block+0x20e>
  802b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b66:	8b 40 0c             	mov    0xc(%eax),%eax
  802b69:	a3 44 51 90 00       	mov    %eax,0x905144
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 11                	je     802b89 <free_block+0x229>
  802b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b81:	8b 52 08             	mov    0x8(%edx),%edx
  802b84:	89 50 08             	mov    %edx,0x8(%eax)
  802b87:	eb 0b                	jmp    802b94 <free_block+0x234>
  802b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	a3 40 51 90 00       	mov    %eax,0x905140
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ba8:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802bad:	48                   	dec    %eax
  802bae:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802bb3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802bba:	e9 a6 03 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802bbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bc3:	75 16                	jne    802bdb <free_block+0x27b>
  802bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc8:	8a 40 04             	mov    0x4(%eax),%al
  802bcb:	84 c0                	test   %al,%al
  802bcd:	75 0c                	jne    802bdb <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802bd6:	e9 8a 03 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802bdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bdf:	0f 84 81 01 00 00    	je     802d66 <free_block+0x406>
  802be5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802be9:	0f 84 77 01 00 00    	je     802d66 <free_block+0x406>
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	8a 40 04             	mov    0x4(%eax),%al
  802bf5:	3c 01                	cmp    $0x1,%al
  802bf7:	0f 85 69 01 00 00    	jne    802d66 <free_block+0x406>
  802bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c00:	8a 40 04             	mov    0x4(%eax),%al
  802c03:	3c 01                	cmp    $0x1,%al
  802c05:	0f 85 5b 01 00 00    	jne    802d66 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	8b 10                	mov    (%eax),%edx
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	8b 08                	mov    (%eax),%ecx
  802c15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	01 c8                	add    %ecx,%eax
  802c1c:	01 c2                	add    %eax,%edx
  802c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c21:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802c43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c47:	75 17                	jne    802c60 <free_block+0x300>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 fe 43 80 00       	push   $0x8043fe
  802c51:	68 59 01 00 00       	push   $0x159
  802c56:	68 63 43 80 00       	push   $0x804363
  802c5b:	e8 bb 06 00 00       	call   80331b <_panic>
  802c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c63:	8b 40 08             	mov    0x8(%eax),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	74 11                	je     802c7b <free_block+0x31b>
  802c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6d:	8b 40 08             	mov    0x8(%eax),%eax
  802c70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c73:	8b 52 0c             	mov    0xc(%edx),%edx
  802c76:	89 50 0c             	mov    %edx,0xc(%eax)
  802c79:	eb 0b                	jmp    802c86 <free_block+0x326>
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	a3 44 51 90 00       	mov    %eax,0x905144
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 11                	je     802ca1 <free_block+0x341>
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	8b 40 0c             	mov    0xc(%eax),%eax
  802c96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c99:	8b 52 08             	mov    0x8(%edx),%edx
  802c9c:	89 50 08             	mov    %edx,0x8(%eax)
  802c9f:	eb 0b                	jmp    802cac <free_block+0x34c>
  802ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca4:	8b 40 08             	mov    0x8(%eax),%eax
  802ca7:	a3 40 51 90 00       	mov    %eax,0x905140
  802cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802caf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cc0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802cc5:	48                   	dec    %eax
  802cc6:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  802ccb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ccf:	75 17                	jne    802ce8 <free_block+0x388>
  802cd1:	83 ec 04             	sub    $0x4,%esp
  802cd4:	68 fe 43 80 00       	push   $0x8043fe
  802cd9:	68 5a 01 00 00       	push   $0x15a
  802cde:	68 63 43 80 00       	push   $0x804363
  802ce3:	e8 33 06 00 00       	call   80331b <_panic>
  802ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ceb:	8b 40 08             	mov    0x8(%eax),%eax
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	74 11                	je     802d03 <free_block+0x3a3>
  802cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf5:	8b 40 08             	mov    0x8(%eax),%eax
  802cf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cfb:	8b 52 0c             	mov    0xc(%edx),%edx
  802cfe:	89 50 0c             	mov    %edx,0xc(%eax)
  802d01:	eb 0b                	jmp    802d0e <free_block+0x3ae>
  802d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d06:	8b 40 0c             	mov    0xc(%eax),%eax
  802d09:	a3 44 51 90 00       	mov    %eax,0x905144
  802d0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d11:	8b 40 0c             	mov    0xc(%eax),%eax
  802d14:	85 c0                	test   %eax,%eax
  802d16:	74 11                	je     802d29 <free_block+0x3c9>
  802d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d21:	8b 52 08             	mov    0x8(%edx),%edx
  802d24:	89 50 08             	mov    %edx,0x8(%eax)
  802d27:	eb 0b                	jmp    802d34 <free_block+0x3d4>
  802d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2c:	8b 40 08             	mov    0x8(%eax),%eax
  802d2f:	a3 40 51 90 00       	mov    %eax,0x905140
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d48:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d4d:	48                   	dec    %eax
  802d4e:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802d53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  802d5a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802d61:	e9 ff 01 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  802d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d6a:	0f 84 db 00 00 00    	je     802e4b <free_block+0x4eb>
  802d70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d74:	0f 84 d1 00 00 00    	je     802e4b <free_block+0x4eb>
  802d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7d:	8a 40 04             	mov    0x4(%eax),%al
  802d80:	84 c0                	test   %al,%al
  802d82:	0f 85 c3 00 00 00    	jne    802e4b <free_block+0x4eb>
  802d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8b:	8a 40 04             	mov    0x4(%eax),%al
  802d8e:	3c 01                	cmp    $0x1,%al
  802d90:	0f 85 b5 00 00 00    	jne    802e4b <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  802d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d99:	8b 10                	mov    (%eax),%edx
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	01 c2                	add    %eax,%edx
  802da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da5:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802db7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dbb:	75 17                	jne    802dd4 <free_block+0x474>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 fe 43 80 00       	push   $0x8043fe
  802dc5:	68 64 01 00 00       	push   $0x164
  802dca:	68 63 43 80 00       	push   $0x804363
  802dcf:	e8 47 05 00 00       	call   80331b <_panic>
  802dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd7:	8b 40 08             	mov    0x8(%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 11                	je     802def <free_block+0x48f>
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 40 08             	mov    0x8(%eax),%eax
  802de4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de7:	8b 52 0c             	mov    0xc(%edx),%edx
  802dea:	89 50 0c             	mov    %edx,0xc(%eax)
  802ded:	eb 0b                	jmp    802dfa <free_block+0x49a>
  802def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df2:	8b 40 0c             	mov    0xc(%eax),%eax
  802df5:	a3 44 51 90 00       	mov    %eax,0x905144
  802dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 11                	je     802e15 <free_block+0x4b5>
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e0d:	8b 52 08             	mov    0x8(%edx),%edx
  802e10:	89 50 08             	mov    %edx,0x8(%eax)
  802e13:	eb 0b                	jmp    802e20 <free_block+0x4c0>
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	8b 40 08             	mov    0x8(%eax),%eax
  802e1b:	a3 40 51 90 00       	mov    %eax,0x905140
  802e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e34:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802e39:	48                   	dec    %eax
  802e3a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802e3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802e46:	e9 1a 01 00 00       	jmp    802f65 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  802e4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e4f:	0f 84 df 00 00 00    	je     802f34 <free_block+0x5d4>
  802e55:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e59:	0f 84 d5 00 00 00    	je     802f34 <free_block+0x5d4>
  802e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e62:	8a 40 04             	mov    0x4(%eax),%al
  802e65:	3c 01                	cmp    $0x1,%al
  802e67:	0f 85 c7 00 00 00    	jne    802f34 <free_block+0x5d4>
  802e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e70:	8a 40 04             	mov    0x4(%eax),%al
  802e73:	84 c0                	test   %al,%al
  802e75:	0f 85 b9 00 00 00    	jne    802f34 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  802e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e85:	8b 10                	mov    (%eax),%edx
  802e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	01 c2                	add    %eax,%edx
  802e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e91:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802ea3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ea7:	75 17                	jne    802ec0 <free_block+0x560>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 fe 43 80 00       	push   $0x8043fe
  802eb1:	68 6e 01 00 00       	push   $0x16e
  802eb6:	68 63 43 80 00       	push   $0x804363
  802ebb:	e8 5b 04 00 00       	call   80331b <_panic>
  802ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 11                	je     802edb <free_block+0x57b>
  802eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecd:	8b 40 08             	mov    0x8(%eax),%eax
  802ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ed3:	8b 52 0c             	mov    0xc(%edx),%edx
  802ed6:	89 50 0c             	mov    %edx,0xc(%eax)
  802ed9:	eb 0b                	jmp    802ee6 <free_block+0x586>
  802edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ede:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee1:	a3 44 51 90 00       	mov    %eax,0x905144
  802ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 11                	je     802f01 <free_block+0x5a1>
  802ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ef9:	8b 52 08             	mov    0x8(%edx),%edx
  802efc:	89 50 08             	mov    %edx,0x8(%eax)
  802eff:	eb 0b                	jmp    802f0c <free_block+0x5ac>
  802f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f04:	8b 40 08             	mov    0x8(%eax),%eax
  802f07:	a3 40 51 90 00       	mov    %eax,0x905140
  802f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f20:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802f25:	48                   	dec    %eax
  802f26:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802f2b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802f32:	eb 31                	jmp    802f65 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  802f34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f38:	74 2b                	je     802f65 <free_block+0x605>
  802f3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3e:	74 25                	je     802f65 <free_block+0x605>
  802f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f43:	8a 40 04             	mov    0x4(%eax),%al
  802f46:	84 c0                	test   %al,%al
  802f48:	75 1b                	jne    802f65 <free_block+0x605>
  802f4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4d:	8a 40 04             	mov    0x4(%eax),%al
  802f50:	84 c0                	test   %al,%al
  802f52:	75 11                	jne    802f65 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  802f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f57:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802f5b:	90                   	nop
  802f5c:	eb 07                	jmp    802f65 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  802f5e:	90                   	nop
  802f5f:	eb 04                	jmp    802f65 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  802f61:	90                   	nop
  802f62:	eb 01                	jmp    802f65 <free_block+0x605>
	if (va == NULL)
		return;
  802f64:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  802f65:	c9                   	leave  
  802f66:	c3                   	ret    

00802f67 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  802f67:	55                   	push   %ebp
  802f68:	89 e5                	mov    %esp,%ebp
  802f6a:	57                   	push   %edi
  802f6b:	56                   	push   %esi
  802f6c:	53                   	push   %ebx
  802f6d:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  802f70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f74:	75 19                	jne    802f8f <realloc_block_FF+0x28>
  802f76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f7a:	74 13                	je     802f8f <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  802f7c:	83 ec 0c             	sub    $0xc,%esp
  802f7f:	ff 75 0c             	pushl  0xc(%ebp)
  802f82:	e8 0c f4 ff ff       	call   802393 <alloc_block_FF>
  802f87:	83 c4 10             	add    $0x10,%esp
  802f8a:	e9 84 03 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  802f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f93:	75 3b                	jne    802fd0 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  802f95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f99:	75 17                	jne    802fb2 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  802f9b:	83 ec 0c             	sub    $0xc,%esp
  802f9e:	6a 00                	push   $0x0
  802fa0:	e8 ee f3 ff ff       	call   802393 <alloc_block_FF>
  802fa5:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fad:	e9 61 03 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  802fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb6:	74 18                	je     802fd0 <realloc_block_FF+0x69>
		{
			free_block(va);
  802fb8:	83 ec 0c             	sub    $0xc,%esp
  802fbb:	ff 75 08             	pushl  0x8(%ebp)
  802fbe:	e8 9d f9 ff ff       	call   802960 <free_block>
  802fc3:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcb:	e9 43 03 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  802fd0:	a1 40 51 90 00       	mov    0x905140,%eax
  802fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802fd8:	e9 02 03 00 00       	jmp    8032df <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	83 e8 10             	sub    $0x10,%eax
  802fe3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fe6:	0f 85 eb 02 00 00    	jne    8032d7 <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff4:	83 c2 10             	add    $0x10,%edx
  802ff7:	39 d0                	cmp    %edx,%eax
  802ff9:	75 08                	jne    803003 <realloc_block_FF+0x9c>
			{
				return va;
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	e9 10 03 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  803003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80300b:	0f 83 e0 01 00 00    	jae    8031f1 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  80301a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301d:	8a 40 04             	mov    0x4(%eax),%al
  803020:	3c 01                	cmp    $0x1,%al
  803022:	0f 85 06 01 00 00    	jne    80312e <realloc_block_FF+0x1c7>
  803028:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302b:	8b 10                	mov    (%eax),%edx
  80302d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803035:	29 c1                	sub    %eax,%ecx
  803037:	89 c8                	mov    %ecx,%eax
  803039:	39 c2                	cmp    %eax,%edx
  80303b:	0f 86 ed 00 00 00    	jbe    80312e <realloc_block_FF+0x1c7>
  803041:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803045:	0f 84 e3 00 00 00    	je     80312e <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  80304b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304e:	8b 10                	mov    (%eax),%edx
  803050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	2b 45 0c             	sub    0xc(%ebp),%eax
  803058:	01 d0                	add    %edx,%eax
  80305a:	83 f8 0f             	cmp    $0xf,%eax
  80305d:	0f 86 b5 00 00 00    	jbe    803118 <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803063:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803066:	8b 45 0c             	mov    0xc(%ebp),%eax
  803069:	01 d0                	add    %edx,%eax
  80306b:	83 c0 10             	add    $0x10,%eax
  80306e:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803071:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803074:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  80307a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803081:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803085:	74 06                	je     80308d <realloc_block_FF+0x126>
  803087:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80308b:	75 17                	jne    8030a4 <realloc_block_FF+0x13d>
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 7c 43 80 00       	push   $0x80437c
  803095:	68 ad 01 00 00       	push   $0x1ad
  80309a:	68 63 43 80 00       	push   $0x804363
  80309f:	e8 77 02 00 00       	call   80331b <_panic>
  8030a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a7:	8b 50 08             	mov    0x8(%eax),%edx
  8030aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ad:	89 50 08             	mov    %edx,0x8(%eax)
  8030b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b3:	8b 40 08             	mov    0x8(%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0c                	je     8030c6 <realloc_block_FF+0x15f>
  8030ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bd:	8b 40 08             	mov    0x8(%eax),%eax
  8030c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030c3:	89 50 0c             	mov    %edx,0xc(%eax)
  8030c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cc:	89 50 08             	mov    %edx,0x8(%eax)
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030d5:	89 50 0c             	mov    %edx,0xc(%eax)
  8030d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030db:	8b 40 08             	mov    0x8(%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	75 08                	jne    8030ea <realloc_block_FF+0x183>
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	a3 44 51 90 00       	mov    %eax,0x905144
  8030ea:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8030ef:	40                   	inc    %eax
  8030f0:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  8030f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  8030fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803101:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  803105:	8b 45 0c             	mov    0xc(%ebp),%eax
  803108:	8d 50 10             	lea    0x10(%eax),%edx
  80310b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310e:	89 10                	mov    %edx,(%eax)
						return va;
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	e9 fb 01 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  803118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311b:	8d 50 10             	lea    0x10(%eax),%edx
  80311e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803121:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  803123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803126:	83 c0 10             	add    $0x10,%eax
  803129:	e9 e5 01 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  80312e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803131:	8a 40 04             	mov    0x4(%eax),%al
  803134:	3c 01                	cmp    $0x1,%al
  803136:	75 59                	jne    803191 <realloc_block_FF+0x22a>
  803138:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313b:	8b 10                	mov    (%eax),%edx
  80313d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803145:	29 c1                	sub    %eax,%ecx
  803147:	89 c8                	mov    %ecx,%eax
  803149:	39 c2                	cmp    %eax,%edx
  80314b:	75 44                	jne    803191 <realloc_block_FF+0x22a>
  80314d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803151:	74 3e                	je     803191 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  80315c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803162:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803165:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803168:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80316b:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  80316e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  803177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  80317e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803181:	8d 50 10             	lea    0x10(%eax),%edx
  803184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803187:	89 10                	mov    %edx,(%eax)
					return va;
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	e9 82 01 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803191:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803194:	8a 40 04             	mov    0x4(%eax),%al
  803197:	84 c0                	test   %al,%al
  803199:	74 0a                	je     8031a5 <realloc_block_FF+0x23e>
  80319b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80319f:	0f 85 32 01 00 00    	jne    8032d7 <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  8031a5:	83 ec 0c             	sub    $0xc,%esp
  8031a8:	ff 75 0c             	pushl  0xc(%ebp)
  8031ab:	e8 e3 f1 ff ff       	call   802393 <alloc_block_FF>
  8031b0:	83 c4 10             	add    $0x10,%esp
  8031b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  8031b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031ba:	74 2b                	je     8031e7 <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  8031bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 c3                	mov    %eax,%ebx
  8031c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8031c9:	89 d7                	mov    %edx,%edi
  8031cb:	89 de                	mov    %ebx,%esi
  8031cd:	89 c1                	mov    %eax,%ecx
  8031cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  8031d1:	83 ec 0c             	sub    $0xc,%esp
  8031d4:	ff 75 08             	pushl  0x8(%ebp)
  8031d7:	e8 84 f7 ff ff       	call   802960 <free_block>
  8031dc:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  8031df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e2:	e9 2c 01 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  8031e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8031ec:	e9 22 01 00 00       	jmp    803313 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  8031f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031f9:	0f 86 d8 00 00 00    	jbe    8032d7 <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  8031ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	2b 45 0c             	sub    0xc(%ebp),%eax
  803207:	83 f8 0f             	cmp    $0xf,%eax
  80320a:	0f 86 b4 00 00 00    	jbe    8032c4 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803210:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803213:	8b 45 0c             	mov    0xc(%ebp),%eax
  803216:	01 d0                	add    %edx,%eax
  803218:	83 c0 10             	add    $0x10,%eax
  80321b:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  80321e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	2b 45 0c             	sub    0xc(%ebp),%eax
  803226:	8d 50 f0             	lea    -0x10(%eax),%edx
  803229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80322c:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  80322e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803232:	74 06                	je     80323a <realloc_block_FF+0x2d3>
  803234:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803238:	75 17                	jne    803251 <realloc_block_FF+0x2ea>
  80323a:	83 ec 04             	sub    $0x4,%esp
  80323d:	68 7c 43 80 00       	push   $0x80437c
  803242:	68 dd 01 00 00       	push   $0x1dd
  803247:	68 63 43 80 00       	push   $0x804363
  80324c:	e8 ca 00 00 00       	call   80331b <_panic>
  803251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803254:	8b 50 08             	mov    0x8(%eax),%edx
  803257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80325a:	89 50 08             	mov    %edx,0x8(%eax)
  80325d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803260:	8b 40 08             	mov    0x8(%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0c                	je     803273 <realloc_block_FF+0x30c>
  803267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326a:	8b 40 08             	mov    0x8(%eax),%eax
  80326d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803270:	89 50 0c             	mov    %edx,0xc(%eax)
  803273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803276:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803279:	89 50 08             	mov    %edx,0x8(%eax)
  80327c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80327f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803282:	89 50 0c             	mov    %edx,0xc(%eax)
  803285:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803288:	8b 40 08             	mov    0x8(%eax),%eax
  80328b:	85 c0                	test   %eax,%eax
  80328d:	75 08                	jne    803297 <realloc_block_FF+0x330>
  80328f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803292:	a3 44 51 90 00       	mov    %eax,0x905144
  803297:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80329c:	40                   	inc    %eax
  80329d:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  8032a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032a5:	83 c0 10             	add    $0x10,%eax
  8032a8:	83 ec 0c             	sub    $0xc,%esp
  8032ab:	50                   	push   %eax
  8032ac:	e8 af f6 ff ff       	call   802960 <free_block>
  8032b1:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  8032b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b7:	8d 50 10             	lea    0x10(%eax),%edx
  8032ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bd:	89 10                	mov    %edx,(%eax)
					return va;
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	eb 4f                	jmp    803313 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  8032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c7:	8d 50 10             	lea    0x10(%eax),%edx
  8032ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cd:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  8032cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d2:	83 c0 10             	add    $0x10,%eax
  8032d5:	eb 3c                	jmp    803313 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  8032d7:	a1 48 51 90 00       	mov    0x905148,%eax
  8032dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8032df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032e3:	74 08                	je     8032ed <realloc_block_FF+0x386>
  8032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e8:	8b 40 08             	mov    0x8(%eax),%eax
  8032eb:	eb 05                	jmp    8032f2 <realloc_block_FF+0x38b>
  8032ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f2:	a3 48 51 90 00       	mov    %eax,0x905148
  8032f7:	a1 48 51 90 00       	mov    0x905148,%eax
  8032fc:	85 c0                	test   %eax,%eax
  8032fe:	0f 85 d9 fc ff ff    	jne    802fdd <realloc_block_FF+0x76>
  803304:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803308:	0f 85 cf fc ff ff    	jne    802fdd <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  80330e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803313:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803316:	5b                   	pop    %ebx
  803317:	5e                   	pop    %esi
  803318:	5f                   	pop    %edi
  803319:	5d                   	pop    %ebp
  80331a:	c3                   	ret    

0080331b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80331b:	55                   	push   %ebp
  80331c:	89 e5                	mov    %esp,%ebp
  80331e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803321:	8d 45 10             	lea    0x10(%ebp),%eax
  803324:	83 c0 04             	add    $0x4,%eax
  803327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80332a:	a1 50 51 90 00       	mov    0x905150,%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 16                	je     803349 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803333:	a1 50 51 90 00       	mov    0x905150,%eax
  803338:	83 ec 08             	sub    $0x8,%esp
  80333b:	50                   	push   %eax
  80333c:	68 1c 44 80 00       	push   $0x80441c
  803341:	e8 27 d6 ff ff       	call   80096d <cprintf>
  803346:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803349:	a1 00 50 80 00       	mov    0x805000,%eax
  80334e:	ff 75 0c             	pushl  0xc(%ebp)
  803351:	ff 75 08             	pushl  0x8(%ebp)
  803354:	50                   	push   %eax
  803355:	68 21 44 80 00       	push   $0x804421
  80335a:	e8 0e d6 ff ff       	call   80096d <cprintf>
  80335f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803362:	8b 45 10             	mov    0x10(%ebp),%eax
  803365:	83 ec 08             	sub    $0x8,%esp
  803368:	ff 75 f4             	pushl  -0xc(%ebp)
  80336b:	50                   	push   %eax
  80336c:	e8 91 d5 ff ff       	call   800902 <vcprintf>
  803371:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803374:	83 ec 08             	sub    $0x8,%esp
  803377:	6a 00                	push   $0x0
  803379:	68 3d 44 80 00       	push   $0x80443d
  80337e:	e8 7f d5 ff ff       	call   800902 <vcprintf>
  803383:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803386:	e8 00 d5 ff ff       	call   80088b <exit>

	// should not return here
	while (1) ;
  80338b:	eb fe                	jmp    80338b <_panic+0x70>

0080338d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80338d:	55                   	push   %ebp
  80338e:	89 e5                	mov    %esp,%ebp
  803390:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803393:	a1 20 50 80 00       	mov    0x805020,%eax
  803398:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80339e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a1:	39 c2                	cmp    %eax,%edx
  8033a3:	74 14                	je     8033b9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	68 40 44 80 00       	push   $0x804440
  8033ad:	6a 26                	push   $0x26
  8033af:	68 8c 44 80 00       	push   $0x80448c
  8033b4:	e8 62 ff ff ff       	call   80331b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8033b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8033c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8033c7:	e9 c5 00 00 00       	jmp    803491 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	01 d0                	add    %edx,%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	75 08                	jne    8033e9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8033e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8033e4:	e9 a5 00 00 00       	jmp    80348e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8033e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033f7:	eb 69                	jmp    803462 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8033f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8033fe:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  803404:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803407:	89 d0                	mov    %edx,%eax
  803409:	01 c0                	add    %eax,%eax
  80340b:	01 d0                	add    %edx,%eax
  80340d:	c1 e0 03             	shl    $0x3,%eax
  803410:	01 c8                	add    %ecx,%eax
  803412:	8a 40 04             	mov    0x4(%eax),%al
  803415:	84 c0                	test   %al,%al
  803417:	75 46                	jne    80345f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803419:	a1 20 50 80 00       	mov    0x805020,%eax
  80341e:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  803424:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803427:	89 d0                	mov    %edx,%eax
  803429:	01 c0                	add    %eax,%eax
  80342b:	01 d0                	add    %edx,%eax
  80342d:	c1 e0 03             	shl    $0x3,%eax
  803430:	01 c8                	add    %ecx,%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80343a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80343f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803444:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	01 c8                	add    %ecx,%eax
  803450:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803452:	39 c2                	cmp    %eax,%edx
  803454:	75 09                	jne    80345f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803456:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80345d:	eb 15                	jmp    803474 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80345f:	ff 45 e8             	incl   -0x18(%ebp)
  803462:	a1 20 50 80 00       	mov    0x805020,%eax
  803467:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	39 c2                	cmp    %eax,%edx
  803472:	77 85                	ja     8033f9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803478:	75 14                	jne    80348e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	68 98 44 80 00       	push   $0x804498
  803482:	6a 3a                	push   $0x3a
  803484:	68 8c 44 80 00       	push   $0x80448c
  803489:	e8 8d fe ff ff       	call   80331b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80348e:	ff 45 f0             	incl   -0x10(%ebp)
  803491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803494:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803497:	0f 8c 2f ff ff ff    	jl     8033cc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80349d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034a4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8034ab:	eb 26                	jmp    8034d3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8034ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8034b2:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8034b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034bb:	89 d0                	mov    %edx,%eax
  8034bd:	01 c0                	add    %eax,%eax
  8034bf:	01 d0                	add    %edx,%eax
  8034c1:	c1 e0 03             	shl    $0x3,%eax
  8034c4:	01 c8                	add    %ecx,%eax
  8034c6:	8a 40 04             	mov    0x4(%eax),%al
  8034c9:	3c 01                	cmp    $0x1,%al
  8034cb:	75 03                	jne    8034d0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8034cd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034d0:	ff 45 e0             	incl   -0x20(%ebp)
  8034d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8034d8:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8034de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e1:	39 c2                	cmp    %eax,%edx
  8034e3:	77 c8                	ja     8034ad <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034eb:	74 14                	je     803501 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8034ed:	83 ec 04             	sub    $0x4,%esp
  8034f0:	68 ec 44 80 00       	push   $0x8044ec
  8034f5:	6a 44                	push   $0x44
  8034f7:	68 8c 44 80 00       	push   $0x80448c
  8034fc:	e8 1a fe ff ff       	call   80331b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803501:	90                   	nop
  803502:	c9                   	leave  
  803503:	c3                   	ret    

00803504 <__udivdi3>:
  803504:	55                   	push   %ebp
  803505:	57                   	push   %edi
  803506:	56                   	push   %esi
  803507:	53                   	push   %ebx
  803508:	83 ec 1c             	sub    $0x1c,%esp
  80350b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80350f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803517:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80351b:	89 ca                	mov    %ecx,%edx
  80351d:	89 f8                	mov    %edi,%eax
  80351f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803523:	85 f6                	test   %esi,%esi
  803525:	75 2d                	jne    803554 <__udivdi3+0x50>
  803527:	39 cf                	cmp    %ecx,%edi
  803529:	77 65                	ja     803590 <__udivdi3+0x8c>
  80352b:	89 fd                	mov    %edi,%ebp
  80352d:	85 ff                	test   %edi,%edi
  80352f:	75 0b                	jne    80353c <__udivdi3+0x38>
  803531:	b8 01 00 00 00       	mov    $0x1,%eax
  803536:	31 d2                	xor    %edx,%edx
  803538:	f7 f7                	div    %edi
  80353a:	89 c5                	mov    %eax,%ebp
  80353c:	31 d2                	xor    %edx,%edx
  80353e:	89 c8                	mov    %ecx,%eax
  803540:	f7 f5                	div    %ebp
  803542:	89 c1                	mov    %eax,%ecx
  803544:	89 d8                	mov    %ebx,%eax
  803546:	f7 f5                	div    %ebp
  803548:	89 cf                	mov    %ecx,%edi
  80354a:	89 fa                	mov    %edi,%edx
  80354c:	83 c4 1c             	add    $0x1c,%esp
  80354f:	5b                   	pop    %ebx
  803550:	5e                   	pop    %esi
  803551:	5f                   	pop    %edi
  803552:	5d                   	pop    %ebp
  803553:	c3                   	ret    
  803554:	39 ce                	cmp    %ecx,%esi
  803556:	77 28                	ja     803580 <__udivdi3+0x7c>
  803558:	0f bd fe             	bsr    %esi,%edi
  80355b:	83 f7 1f             	xor    $0x1f,%edi
  80355e:	75 40                	jne    8035a0 <__udivdi3+0x9c>
  803560:	39 ce                	cmp    %ecx,%esi
  803562:	72 0a                	jb     80356e <__udivdi3+0x6a>
  803564:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803568:	0f 87 9e 00 00 00    	ja     80360c <__udivdi3+0x108>
  80356e:	b8 01 00 00 00       	mov    $0x1,%eax
  803573:	89 fa                	mov    %edi,%edx
  803575:	83 c4 1c             	add    $0x1c,%esp
  803578:	5b                   	pop    %ebx
  803579:	5e                   	pop    %esi
  80357a:	5f                   	pop    %edi
  80357b:	5d                   	pop    %ebp
  80357c:	c3                   	ret    
  80357d:	8d 76 00             	lea    0x0(%esi),%esi
  803580:	31 ff                	xor    %edi,%edi
  803582:	31 c0                	xor    %eax,%eax
  803584:	89 fa                	mov    %edi,%edx
  803586:	83 c4 1c             	add    $0x1c,%esp
  803589:	5b                   	pop    %ebx
  80358a:	5e                   	pop    %esi
  80358b:	5f                   	pop    %edi
  80358c:	5d                   	pop    %ebp
  80358d:	c3                   	ret    
  80358e:	66 90                	xchg   %ax,%ax
  803590:	89 d8                	mov    %ebx,%eax
  803592:	f7 f7                	div    %edi
  803594:	31 ff                	xor    %edi,%edi
  803596:	89 fa                	mov    %edi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035a5:	89 eb                	mov    %ebp,%ebx
  8035a7:	29 fb                	sub    %edi,%ebx
  8035a9:	89 f9                	mov    %edi,%ecx
  8035ab:	d3 e6                	shl    %cl,%esi
  8035ad:	89 c5                	mov    %eax,%ebp
  8035af:	88 d9                	mov    %bl,%cl
  8035b1:	d3 ed                	shr    %cl,%ebp
  8035b3:	89 e9                	mov    %ebp,%ecx
  8035b5:	09 f1                	or     %esi,%ecx
  8035b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035bb:	89 f9                	mov    %edi,%ecx
  8035bd:	d3 e0                	shl    %cl,%eax
  8035bf:	89 c5                	mov    %eax,%ebp
  8035c1:	89 d6                	mov    %edx,%esi
  8035c3:	88 d9                	mov    %bl,%cl
  8035c5:	d3 ee                	shr    %cl,%esi
  8035c7:	89 f9                	mov    %edi,%ecx
  8035c9:	d3 e2                	shl    %cl,%edx
  8035cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035cf:	88 d9                	mov    %bl,%cl
  8035d1:	d3 e8                	shr    %cl,%eax
  8035d3:	09 c2                	or     %eax,%edx
  8035d5:	89 d0                	mov    %edx,%eax
  8035d7:	89 f2                	mov    %esi,%edx
  8035d9:	f7 74 24 0c          	divl   0xc(%esp)
  8035dd:	89 d6                	mov    %edx,%esi
  8035df:	89 c3                	mov    %eax,%ebx
  8035e1:	f7 e5                	mul    %ebp
  8035e3:	39 d6                	cmp    %edx,%esi
  8035e5:	72 19                	jb     803600 <__udivdi3+0xfc>
  8035e7:	74 0b                	je     8035f4 <__udivdi3+0xf0>
  8035e9:	89 d8                	mov    %ebx,%eax
  8035eb:	31 ff                	xor    %edi,%edi
  8035ed:	e9 58 ff ff ff       	jmp    80354a <__udivdi3+0x46>
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035f8:	89 f9                	mov    %edi,%ecx
  8035fa:	d3 e2                	shl    %cl,%edx
  8035fc:	39 c2                	cmp    %eax,%edx
  8035fe:	73 e9                	jae    8035e9 <__udivdi3+0xe5>
  803600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803603:	31 ff                	xor    %edi,%edi
  803605:	e9 40 ff ff ff       	jmp    80354a <__udivdi3+0x46>
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	31 c0                	xor    %eax,%eax
  80360e:	e9 37 ff ff ff       	jmp    80354a <__udivdi3+0x46>
  803613:	90                   	nop

00803614 <__umoddi3>:
  803614:	55                   	push   %ebp
  803615:	57                   	push   %edi
  803616:	56                   	push   %esi
  803617:	53                   	push   %ebx
  803618:	83 ec 1c             	sub    $0x1c,%esp
  80361b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80361f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803627:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80362b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80362f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803633:	89 f3                	mov    %esi,%ebx
  803635:	89 fa                	mov    %edi,%edx
  803637:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363b:	89 34 24             	mov    %esi,(%esp)
  80363e:	85 c0                	test   %eax,%eax
  803640:	75 1a                	jne    80365c <__umoddi3+0x48>
  803642:	39 f7                	cmp    %esi,%edi
  803644:	0f 86 a2 00 00 00    	jbe    8036ec <__umoddi3+0xd8>
  80364a:	89 c8                	mov    %ecx,%eax
  80364c:	89 f2                	mov    %esi,%edx
  80364e:	f7 f7                	div    %edi
  803650:	89 d0                	mov    %edx,%eax
  803652:	31 d2                	xor    %edx,%edx
  803654:	83 c4 1c             	add    $0x1c,%esp
  803657:	5b                   	pop    %ebx
  803658:	5e                   	pop    %esi
  803659:	5f                   	pop    %edi
  80365a:	5d                   	pop    %ebp
  80365b:	c3                   	ret    
  80365c:	39 f0                	cmp    %esi,%eax
  80365e:	0f 87 ac 00 00 00    	ja     803710 <__umoddi3+0xfc>
  803664:	0f bd e8             	bsr    %eax,%ebp
  803667:	83 f5 1f             	xor    $0x1f,%ebp
  80366a:	0f 84 ac 00 00 00    	je     80371c <__umoddi3+0x108>
  803670:	bf 20 00 00 00       	mov    $0x20,%edi
  803675:	29 ef                	sub    %ebp,%edi
  803677:	89 fe                	mov    %edi,%esi
  803679:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 e0                	shl    %cl,%eax
  803681:	89 d7                	mov    %edx,%edi
  803683:	89 f1                	mov    %esi,%ecx
  803685:	d3 ef                	shr    %cl,%edi
  803687:	09 c7                	or     %eax,%edi
  803689:	89 e9                	mov    %ebp,%ecx
  80368b:	d3 e2                	shl    %cl,%edx
  80368d:	89 14 24             	mov    %edx,(%esp)
  803690:	89 d8                	mov    %ebx,%eax
  803692:	d3 e0                	shl    %cl,%eax
  803694:	89 c2                	mov    %eax,%edx
  803696:	8b 44 24 08          	mov    0x8(%esp),%eax
  80369a:	d3 e0                	shl    %cl,%eax
  80369c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036a4:	89 f1                	mov    %esi,%ecx
  8036a6:	d3 e8                	shr    %cl,%eax
  8036a8:	09 d0                	or     %edx,%eax
  8036aa:	d3 eb                	shr    %cl,%ebx
  8036ac:	89 da                	mov    %ebx,%edx
  8036ae:	f7 f7                	div    %edi
  8036b0:	89 d3                	mov    %edx,%ebx
  8036b2:	f7 24 24             	mull   (%esp)
  8036b5:	89 c6                	mov    %eax,%esi
  8036b7:	89 d1                	mov    %edx,%ecx
  8036b9:	39 d3                	cmp    %edx,%ebx
  8036bb:	0f 82 87 00 00 00    	jb     803748 <__umoddi3+0x134>
  8036c1:	0f 84 91 00 00 00    	je     803758 <__umoddi3+0x144>
  8036c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036cb:	29 f2                	sub    %esi,%edx
  8036cd:	19 cb                	sbb    %ecx,%ebx
  8036cf:	89 d8                	mov    %ebx,%eax
  8036d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036d5:	d3 e0                	shl    %cl,%eax
  8036d7:	89 e9                	mov    %ebp,%ecx
  8036d9:	d3 ea                	shr    %cl,%edx
  8036db:	09 d0                	or     %edx,%eax
  8036dd:	89 e9                	mov    %ebp,%ecx
  8036df:	d3 eb                	shr    %cl,%ebx
  8036e1:	89 da                	mov    %ebx,%edx
  8036e3:	83 c4 1c             	add    $0x1c,%esp
  8036e6:	5b                   	pop    %ebx
  8036e7:	5e                   	pop    %esi
  8036e8:	5f                   	pop    %edi
  8036e9:	5d                   	pop    %ebp
  8036ea:	c3                   	ret    
  8036eb:	90                   	nop
  8036ec:	89 fd                	mov    %edi,%ebp
  8036ee:	85 ff                	test   %edi,%edi
  8036f0:	75 0b                	jne    8036fd <__umoddi3+0xe9>
  8036f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f7:	31 d2                	xor    %edx,%edx
  8036f9:	f7 f7                	div    %edi
  8036fb:	89 c5                	mov    %eax,%ebp
  8036fd:	89 f0                	mov    %esi,%eax
  8036ff:	31 d2                	xor    %edx,%edx
  803701:	f7 f5                	div    %ebp
  803703:	89 c8                	mov    %ecx,%eax
  803705:	f7 f5                	div    %ebp
  803707:	89 d0                	mov    %edx,%eax
  803709:	e9 44 ff ff ff       	jmp    803652 <__umoddi3+0x3e>
  80370e:	66 90                	xchg   %ax,%ax
  803710:	89 c8                	mov    %ecx,%eax
  803712:	89 f2                	mov    %esi,%edx
  803714:	83 c4 1c             	add    $0x1c,%esp
  803717:	5b                   	pop    %ebx
  803718:	5e                   	pop    %esi
  803719:	5f                   	pop    %edi
  80371a:	5d                   	pop    %ebp
  80371b:	c3                   	ret    
  80371c:	3b 04 24             	cmp    (%esp),%eax
  80371f:	72 06                	jb     803727 <__umoddi3+0x113>
  803721:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803725:	77 0f                	ja     803736 <__umoddi3+0x122>
  803727:	89 f2                	mov    %esi,%edx
  803729:	29 f9                	sub    %edi,%ecx
  80372b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80372f:	89 14 24             	mov    %edx,(%esp)
  803732:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803736:	8b 44 24 04          	mov    0x4(%esp),%eax
  80373a:	8b 14 24             	mov    (%esp),%edx
  80373d:	83 c4 1c             	add    $0x1c,%esp
  803740:	5b                   	pop    %ebx
  803741:	5e                   	pop    %esi
  803742:	5f                   	pop    %edi
  803743:	5d                   	pop    %ebp
  803744:	c3                   	ret    
  803745:	8d 76 00             	lea    0x0(%esi),%esi
  803748:	2b 04 24             	sub    (%esp),%eax
  80374b:	19 fa                	sbb    %edi,%edx
  80374d:	89 d1                	mov    %edx,%ecx
  80374f:	89 c6                	mov    %eax,%esi
  803751:	e9 71 ff ff ff       	jmp    8036c7 <__umoddi3+0xb3>
  803756:	66 90                	xchg   %ax,%ax
  803758:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80375c:	72 ea                	jb     803748 <__umoddi3+0x134>
  80375e:	89 d9                	mov    %ebx,%ecx
  803760:	e9 62 ff ff ff       	jmp    8036c7 <__umoddi3+0xb3>
