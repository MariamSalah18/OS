
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 60 09 00 00       	call   800996 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 2000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 3f 24 00 00       	call   802489 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 20 50 80 00       	mov    0x805020,%eax
  800052:	8b 90 d8 00 00 00    	mov    0xd8(%eax),%edx
  800058:	a1 20 50 80 00       	mov    0x805020,%eax
  80005d:	8b 80 e4 00 00 00    	mov    0xe4(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 00 3a 80 00       	push   $0x803a00
  80006f:	6a 15                	push   $0x15
  800071:	68 1c 3a 80 00       	push   $0x803a1c
  800076:	e8 49 0a 00 00       	call   800ac4 <_panic>
	}
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	int Mega = 1024*1024;
  800082:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800089:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  800090:	8d 55 94             	lea    -0x6c(%ebp),%edx
  800093:	b9 14 00 00 00       	mov    $0x14,%ecx
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	89 d7                	mov    %edx,%edi
  80009f:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate set of blocks
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000a1:	e8 23 1f 00 00       	call   801fc9 <sys_calculate_free_frames>
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000a9:	e8 66 1f 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8000ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	50                   	push   %eax
  8000bb:	e8 ea 1a 00 00       	call   801baa <malloc>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8000c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000cc:	74 14                	je     8000e2 <_main+0xaa>
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	68 34 3a 80 00       	push   $0x803a34
  8000d6:	6a 26                	push   $0x26
  8000d8:	68 1c 3a 80 00       	push   $0x803a1c
  8000dd:	e8 e2 09 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8000e2:	e8 2d 1f 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8000e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ea:	74 14                	je     800100 <_main+0xc8>
  8000ec:	83 ec 04             	sub    $0x4,%esp
  8000ef:	68 64 3a 80 00       	push   $0x803a64
  8000f4:	6a 28                	push   $0x28
  8000f6:	68 1c 3a 80 00       	push   $0x803a1c
  8000fb:	e8 c4 09 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800100:	e8 c4 1e 00 00       	call   801fc9 <sys_calculate_free_frames>
  800105:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800108:	e8 07 1f 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80010d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800113:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	50                   	push   %eax
  80011a:	e8 8b 1a 00 00       	call   801baa <malloc>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800125:	8b 45 98             	mov    -0x68(%ebp),%eax
  800128:	89 c1                	mov    %eax,%ecx
  80012a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80012d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800130:	01 d0                	add    %edx,%eax
  800132:	39 c1                	cmp    %eax,%ecx
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 34 3a 80 00       	push   $0x803a34
  80013e:	6a 2e                	push   $0x2e
  800140:	68 1c 3a 80 00       	push   $0x803a1c
  800145:	e8 7a 09 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014a:	e8 c5 1e 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80014f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800152:	74 14                	je     800168 <_main+0x130>
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	68 64 3a 80 00       	push   $0x803a64
  80015c:	6a 30                	push   $0x30
  80015e:	68 1c 3a 80 00       	push   $0x803a1c
  800163:	e8 5c 09 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800168:	e8 5c 1e 00 00       	call   801fc9 <sys_calculate_free_frames>
  80016d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800170:	e8 9f 1e 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	e8 23 1a 00 00       	call   801baa <malloc>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80018d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800195:	01 c0                	add    %eax,%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80019c:	01 c8                	add    %ecx,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 34 3a 80 00       	push   $0x803a34
  8001aa:	6a 36                	push   $0x36
  8001ac:	68 1c 3a 80 00       	push   $0x803a1c
  8001b1:	e8 0e 09 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 59 1e 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 64 3a 80 00       	push   $0x803a64
  8001c8:	6a 38                	push   $0x38
  8001ca:	68 1c 3a 80 00       	push   $0x803a1c
  8001cf:	e8 f0 08 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001d4:	e8 f0 1d 00 00       	call   801fc9 <sys_calculate_free_frames>
  8001d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dc:	e8 33 1e 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8001e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	50                   	push   %eax
  8001ee:	e8 b7 19 00 00       	call   801baa <malloc>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8001f9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8001fc:	89 c1                	mov    %eax,%ecx
  8001fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800201:	89 c2                	mov    %eax,%edx
  800203:	01 d2                	add    %edx,%edx
  800205:	01 d0                	add    %edx,%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80020c:	01 d0                	add    %edx,%eax
  80020e:	39 c1                	cmp    %eax,%ecx
  800210:	74 14                	je     800226 <_main+0x1ee>
  800212:	83 ec 04             	sub    $0x4,%esp
  800215:	68 34 3a 80 00       	push   $0x803a34
  80021a:	6a 3e                	push   $0x3e
  80021c:	68 1c 3a 80 00       	push   $0x803a1c
  800221:	e8 9e 08 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800226:	e8 e9 1d 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80022b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80022e:	74 14                	je     800244 <_main+0x20c>
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	68 64 3a 80 00       	push   $0x803a64
  800238:	6a 40                	push   $0x40
  80023a:	68 1c 3a 80 00       	push   $0x803a1c
  80023f:	e8 80 08 00 00       	call   800ac4 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800244:	e8 80 1d 00 00       	call   801fc9 <sys_calculate_free_frames>
  800249:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024c:	e8 c3 1d 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800257:	01 c0                	add    %eax,%eax
  800259:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 45 19 00 00       	call   801baa <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027b:	01 c8                	add    %ecx,%eax
  80027d:	39 c2                	cmp    %eax,%edx
  80027f:	74 14                	je     800295 <_main+0x25d>
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	68 34 3a 80 00       	push   $0x803a34
  800289:	6a 46                	push   $0x46
  80028b:	68 1c 3a 80 00       	push   $0x803a1c
  800290:	e8 2f 08 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800295:	e8 7a 1d 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80029a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80029d:	74 14                	je     8002b3 <_main+0x27b>
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	68 64 3a 80 00       	push   $0x803a64
  8002a7:	6a 48                	push   $0x48
  8002a9:	68 1c 3a 80 00       	push   $0x803a1c
  8002ae:	e8 11 08 00 00       	call   800ac4 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002b3:	e8 11 1d 00 00       	call   801fc9 <sys_calculate_free_frames>
  8002b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002bb:	e8 54 1d 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c6:	01 c0                	add    %eax,%eax
  8002c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	e8 d6 18 00 00       	call   801baa <malloc>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[5] != (pagealloc_start + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8002da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002dd:	89 c1                	mov    %eax,%ecx
  8002df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e2:	89 d0                	mov    %edx,%eax
  8002e4:	01 c0                	add    %eax,%eax
  8002e6:	01 d0                	add    %edx,%eax
  8002e8:	01 c0                	add    %eax,%eax
  8002ea:	89 c2                	mov    %eax,%edx
  8002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	39 c1                	cmp    %eax,%ecx
  8002f3:	74 14                	je     800309 <_main+0x2d1>
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 34 3a 80 00       	push   $0x803a34
  8002fd:	6a 4e                	push   $0x4e
  8002ff:	68 1c 3a 80 00       	push   $0x803a1c
  800304:	e8 bb 07 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800309:	e8 06 1d 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80030e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800311:	74 14                	je     800327 <_main+0x2ef>
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	68 64 3a 80 00       	push   $0x803a64
  80031b:	6a 50                	push   $0x50
  80031d:	68 1c 3a 80 00       	push   $0x803a1c
  800322:	e8 9d 07 00 00       	call   800ac4 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800327:	e8 9d 1c 00 00       	call   801fc9 <sys_calculate_free_frames>
  80032c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032f:	e8 e0 1c 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800334:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033a:	89 c2                	mov    %eax,%edx
  80033c:	01 d2                	add    %edx,%edx
  80033e:	01 d0                	add    %edx,%eax
  800340:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800343:	83 ec 0c             	sub    $0xc,%esp
  800346:	50                   	push   %eax
  800347:	e8 5e 18 00 00       	call   801baa <malloc>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800352:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800355:	89 c2                	mov    %eax,%edx
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035a:	c1 e0 03             	shl    $0x3,%eax
  80035d:	89 c1                	mov    %eax,%ecx
  80035f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	74 14                	je     80037c <_main+0x344>
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	68 34 3a 80 00       	push   $0x803a34
  800370:	6a 56                	push   $0x56
  800372:	68 1c 3a 80 00       	push   $0x803a1c
  800377:	e8 48 07 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80037c:	e8 93 1c 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800381:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 64 3a 80 00       	push   $0x803a64
  80038e:	6a 58                	push   $0x58
  800390:	68 1c 3a 80 00       	push   $0x803a1c
  800395:	e8 2a 07 00 00       	call   800ac4 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80039a:	e8 2a 1c 00 00       	call   801fc9 <sys_calculate_free_frames>
  80039f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a2:	e8 6d 1c 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8003a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ad:	89 c2                	mov    %eax,%edx
  8003af:	01 d2                	add    %edx,%edx
  8003b1:	01 d0                	add    %edx,%eax
  8003b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	50                   	push   %eax
  8003ba:	e8 eb 17 00 00       	call   801baa <malloc>
  8003bf:	83 c4 10             	add    $0x10,%esp
  8003c2:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[7] != (pagealloc_start + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8003c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003c8:	89 c1                	mov    %eax,%ecx
  8003ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8003cd:	89 d0                	mov    %edx,%eax
  8003cf:	c1 e0 02             	shl    $0x2,%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 34 3a 80 00       	push   $0x803a34
  8003eb:	6a 5e                	push   $0x5e
  8003ed:	68 1c 3a 80 00       	push   $0x803a1c
  8003f2:	e8 cd 06 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003f7:	e8 18 1c 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8003fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003ff:	74 14                	je     800415 <_main+0x3dd>
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	68 64 3a 80 00       	push   $0x803a64
  800409:	6a 60                	push   $0x60
  80040b:	68 1c 3a 80 00       	push   $0x803a1c
  800410:	e8 af 06 00 00       	call   800ac4 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800415:	e8 af 1b 00 00       	call   801fc9 <sys_calculate_free_frames>
  80041a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80041d:	e8 f2 1b 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  800425:	8b 45 98             	mov    -0x68(%ebp),%eax
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	50                   	push   %eax
  80042c:	e8 d5 18 00 00       	call   801d06 <free>
  800431:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800434:	e8 db 1b 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800439:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043c:	74 14                	je     800452 <_main+0x41a>
  80043e:	83 ec 04             	sub    $0x4,%esp
  800441:	68 81 3a 80 00       	push   $0x803a81
  800446:	6a 6a                	push   $0x6a
  800448:	68 1c 3a 80 00       	push   $0x803a1c
  80044d:	e8 72 06 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800452:	e8 72 1b 00 00       	call   801fc9 <sys_calculate_free_frames>
  800457:	89 c2                	mov    %eax,%edx
  800459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045c:	39 c2                	cmp    %eax,%edx
  80045e:	74 14                	je     800474 <_main+0x43c>
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	68 98 3a 80 00       	push   $0x803a98
  800468:	6a 6b                	push   $0x6b
  80046a:	68 1c 3a 80 00       	push   $0x803a1c
  80046f:	e8 50 06 00 00       	call   800ac4 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800474:	e8 50 1b 00 00       	call   801fc9 <sys_calculate_free_frames>
  800479:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047c:	e8 93 1b 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800484:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800487:	83 ec 0c             	sub    $0xc,%esp
  80048a:	50                   	push   %eax
  80048b:	e8 76 18 00 00       	call   801d06 <free>
  800490:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800493:	e8 7c 1b 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 81 3a 80 00       	push   $0x803a81
  8004a5:	6a 72                	push   $0x72
  8004a7:	68 1c 3a 80 00       	push   $0x803a1c
  8004ac:	e8 13 06 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8004b1:	e8 13 1b 00 00       	call   801fc9 <sys_calculate_free_frames>
  8004b6:	89 c2                	mov    %eax,%edx
  8004b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	74 14                	je     8004d3 <_main+0x49b>
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 98 3a 80 00       	push   $0x803a98
  8004c7:	6a 73                	push   $0x73
  8004c9:	68 1c 3a 80 00       	push   $0x803a1c
  8004ce:	e8 f1 05 00 00       	call   800ac4 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d3:	e8 f1 1a 00 00       	call   801fc9 <sys_calculate_free_frames>
  8004d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004db:	e8 34 1b 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8004e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8004e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	50                   	push   %eax
  8004ea:	e8 17 18 00 00       	call   801d06 <free>
  8004ef:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004f2:	e8 1d 1b 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	74 14                	je     800510 <_main+0x4d8>
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	68 81 3a 80 00       	push   $0x803a81
  800504:	6a 7a                	push   $0x7a
  800506:	68 1c 3a 80 00       	push   $0x803a1c
  80050b:	e8 b4 05 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800510:	e8 b4 1a 00 00       	call   801fc9 <sys_calculate_free_frames>
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80051a:	39 c2                	cmp    %eax,%edx
  80051c:	74 14                	je     800532 <_main+0x4fa>
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	68 98 3a 80 00       	push   $0x803a98
  800526:	6a 7b                	push   $0x7b
  800528:	68 1c 3a 80 00       	push   $0x803a1c
  80052d:	e8 92 05 00 00       	call   800ac4 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800532:	e8 92 1a 00 00       	call   801fc9 <sys_calculate_free_frames>
  800537:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80053a:	e8 d5 1a 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80053f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800545:	89 d0                	mov    %edx,%eax
  800547:	c1 e0 09             	shl    $0x9,%eax
  80054a:	29 d0                	sub    %edx,%eax
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	50                   	push   %eax
  800550:	e8 55 16 00 00       	call   801baa <malloc>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[8] != (pagealloc_start + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80055b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80055e:	89 c1                	mov    %eax,%ecx
  800560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	39 c1                	cmp    %eax,%ecx
  80056a:	74 17                	je     800583 <_main+0x54b>
  80056c:	83 ec 04             	sub    $0x4,%esp
  80056f:	68 34 3a 80 00       	push   $0x803a34
  800574:	68 84 00 00 00       	push   $0x84
  800579:	68 1c 3a 80 00       	push   $0x803a1c
  80057e:	e8 41 05 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800583:	e8 8c 1a 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800588:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80058b:	74 17                	je     8005a4 <_main+0x56c>
  80058d:	83 ec 04             	sub    $0x4,%esp
  800590:	68 64 3a 80 00       	push   $0x803a64
  800595:	68 86 00 00 00       	push   $0x86
  80059a:	68 1c 3a 80 00       	push   $0x803a1c
  80059f:	e8 20 05 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  8005a4:	e8 20 1a 00 00       	call   801fc9 <sys_calculate_free_frames>
  8005a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ac:	e8 63 1a 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8005b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8005b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8005ba:	83 ec 0c             	sub    $0xc,%esp
  8005bd:	50                   	push   %eax
  8005be:	e8 e7 15 00 00       	call   801baa <malloc>
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8005c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005cc:	89 c2                	mov    %eax,%edx
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d1:	c1 e0 02             	shl    $0x2,%eax
  8005d4:	89 c1                	mov    %eax,%ecx
  8005d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d9:	01 c8                	add    %ecx,%eax
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	74 17                	je     8005f6 <_main+0x5be>
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	68 34 3a 80 00       	push   $0x803a34
  8005e7:	68 8c 00 00 00       	push   $0x8c
  8005ec:	68 1c 3a 80 00       	push   $0x803a1c
  8005f1:	e8 ce 04 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8005f6:	e8 19 1a 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8005fb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005fe:	74 17                	je     800617 <_main+0x5df>
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 64 3a 80 00       	push   $0x803a64
  800608:	68 8e 00 00 00       	push   $0x8e
  80060d:	68 1c 3a 80 00       	push   $0x803a1c
  800612:	e8 ad 04 00 00       	call   800ac4 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800617:	e8 ad 19 00 00       	call   801fc9 <sys_calculate_free_frames>
  80061c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061f:	e8 f0 19 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800627:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80062a:	89 d0                	mov    %edx,%eax
  80062c:	c1 e0 08             	shl    $0x8,%eax
  80062f:	29 d0                	sub    %edx,%eax
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	50                   	push   %eax
  800635:	e8 70 15 00 00       	call   801baa <malloc>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[10] != (pagealloc_start + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800640:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800643:	89 c1                	mov    %eax,%ecx
  800645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064b:	01 c2                	add    %eax,%edx
  80064d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800650:	c1 e0 09             	shl    $0x9,%eax
  800653:	01 d0                	add    %edx,%eax
  800655:	39 c1                	cmp    %eax,%ecx
  800657:	74 17                	je     800670 <_main+0x638>
  800659:	83 ec 04             	sub    $0x4,%esp
  80065c:	68 34 3a 80 00       	push   $0x803a34
  800661:	68 94 00 00 00       	push   $0x94
  800666:	68 1c 3a 80 00       	push   $0x803a1c
  80066b:	e8 54 04 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800670:	e8 9f 19 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800675:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800678:	74 17                	je     800691 <_main+0x659>
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	68 64 3a 80 00       	push   $0x803a64
  800682:	68 96 00 00 00       	push   $0x96
  800687:	68 1c 3a 80 00       	push   $0x803a1c
  80068c:	e8 33 04 00 00       	call   800ac4 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800691:	e8 33 19 00 00       	call   801fc9 <sys_calculate_free_frames>
  800696:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800699:	e8 76 19 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a4:	01 c0                	add    %eax,%eax
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	50                   	push   %eax
  8006aa:	e8 fb 14 00 00       	call   801baa <malloc>
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[11] != (pagealloc_start + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8006b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006b8:	89 c2                	mov    %eax,%edx
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	c1 e0 03             	shl    $0x3,%eax
  8006c0:	89 c1                	mov    %eax,%ecx
  8006c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c5:	01 c8                	add    %ecx,%eax
  8006c7:	39 c2                	cmp    %eax,%edx
  8006c9:	74 17                	je     8006e2 <_main+0x6aa>
  8006cb:	83 ec 04             	sub    $0x4,%esp
  8006ce:	68 34 3a 80 00       	push   $0x803a34
  8006d3:	68 9c 00 00 00       	push   $0x9c
  8006d8:	68 1c 3a 80 00       	push   $0x803a1c
  8006dd:	e8 e2 03 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e2:	e8 2d 19 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8006e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006ea:	74 17                	je     800703 <_main+0x6cb>
  8006ec:	83 ec 04             	sub    $0x4,%esp
  8006ef:	68 64 3a 80 00       	push   $0x803a64
  8006f4:	68 9e 00 00 00       	push   $0x9e
  8006f9:	68 1c 3a 80 00       	push   $0x803a1c
  8006fe:	e8 c1 03 00 00       	call   800ac4 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800703:	e8 c1 18 00 00       	call   801fc9 <sys_calculate_free_frames>
  800708:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80070b:	e8 04 19 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800716:	c1 e0 02             	shl    $0x2,%eax
  800719:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80071c:	83 ec 0c             	sub    $0xc,%esp
  80071f:	50                   	push   %eax
  800720:	e8 85 14 00 00       	call   801baa <malloc>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80072b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80072e:	89 c1                	mov    %eax,%ecx
  800730:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800733:	89 d0                	mov    %edx,%eax
  800735:	01 c0                	add    %eax,%eax
  800737:	01 d0                	add    %edx,%eax
  800739:	01 c0                	add    %eax,%eax
  80073b:	01 d0                	add    %edx,%eax
  80073d:	01 c0                	add    %eax,%eax
  80073f:	89 c2                	mov    %eax,%edx
  800741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800744:	01 d0                	add    %edx,%eax
  800746:	39 c1                	cmp    %eax,%ecx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	83 ec 04             	sub    $0x4,%esp
  80074d:	68 34 3a 80 00       	push   $0x803a34
  800752:	68 a4 00 00 00       	push   $0xa4
  800757:	68 1c 3a 80 00       	push   $0x803a1c
  80075c:	e8 63 03 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800761:	e8 ae 18 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800766:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800769:	74 17                	je     800782 <_main+0x74a>
  80076b:	83 ec 04             	sub    $0x4,%esp
  80076e:	68 64 3a 80 00       	push   $0x803a64
  800773:	68 a6 00 00 00       	push   $0xa6
  800778:	68 1c 3a 80 00       	push   $0x803a1c
  80077d:	e8 42 03 00 00       	call   800ac4 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800782:	e8 42 18 00 00       	call   801fc9 <sys_calculate_free_frames>
  800787:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80078a:	e8 85 18 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80078f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[2]);
  800792:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 68 15 00 00       	call   801d06 <free>
  80079e:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8007a1:	e8 6e 18 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8007a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007a9:	74 17                	je     8007c2 <_main+0x78a>
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	68 81 3a 80 00       	push   $0x803a81
  8007b3:	68 b0 00 00 00       	push   $0xb0
  8007b8:	68 1c 3a 80 00       	push   $0x803a1c
  8007bd:	e8 02 03 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8007c2:	e8 02 18 00 00       	call   801fc9 <sys_calculate_free_frames>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007cc:	39 c2                	cmp    %eax,%edx
  8007ce:	74 17                	je     8007e7 <_main+0x7af>
  8007d0:	83 ec 04             	sub    $0x4,%esp
  8007d3:	68 98 3a 80 00       	push   $0x803a98
  8007d8:	68 b1 00 00 00       	push   $0xb1
  8007dd:	68 1c 3a 80 00       	push   $0x803a1c
  8007e2:	e8 dd 02 00 00       	call   800ac4 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 dd 17 00 00       	call   801fc9 <sys_calculate_free_frames>
  8007ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 20 18 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  8007f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 03 15 00 00       	call   801d06 <free>
  800803:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800806:	e8 09 18 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80080b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80080e:	74 17                	je     800827 <_main+0x7ef>
  800810:	83 ec 04             	sub    $0x4,%esp
  800813:	68 81 3a 80 00       	push   $0x803a81
  800818:	68 b8 00 00 00       	push   $0xb8
  80081d:	68 1c 3a 80 00       	push   $0x803a1c
  800822:	e8 9d 02 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800827:	e8 9d 17 00 00       	call   801fc9 <sys_calculate_free_frames>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800831:	39 c2                	cmp    %eax,%edx
  800833:	74 17                	je     80084c <_main+0x814>
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	68 98 3a 80 00       	push   $0x803a98
  80083d:	68 b9 00 00 00       	push   $0xb9
  800842:	68 1c 3a 80 00       	push   $0x803a1c
  800847:	e8 78 02 00 00       	call   800ac4 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  80084c:	e8 78 17 00 00       	call   801fc9 <sys_calculate_free_frames>
  800851:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800854:	e8 bb 17 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[3]);
  80085c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80085f:	83 ec 0c             	sub    $0xc,%esp
  800862:	50                   	push   %eax
  800863:	e8 9e 14 00 00       	call   801d06 <free>
  800868:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80086b:	e8 a4 17 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  800870:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800873:	74 17                	je     80088c <_main+0x854>
  800875:	83 ec 04             	sub    $0x4,%esp
  800878:	68 81 3a 80 00       	push   $0x803a81
  80087d:	68 c0 00 00 00       	push   $0xc0
  800882:	68 1c 3a 80 00       	push   $0x803a1c
  800887:	e8 38 02 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80088c:	e8 38 17 00 00       	call   801fc9 <sys_calculate_free_frames>
  800891:	89 c2                	mov    %eax,%edx
  800893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800896:	39 c2                	cmp    %eax,%edx
  800898:	74 17                	je     8008b1 <_main+0x879>
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	68 98 3a 80 00       	push   $0x803a98
  8008a2:	68 c1 00 00 00       	push   $0xc1
  8008a7:	68 1c 3a 80 00       	push   $0x803a1c
  8008ac:	e8 13 02 00 00       	call   800ac4 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8008b1:	e8 13 17 00 00       	call   801fc9 <sys_calculate_free_frames>
  8008b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008b9:	e8 56 17 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  8008be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  8008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c4:	c1 e0 06             	shl    $0x6,%eax
  8008c7:	89 c2                	mov    %eax,%edx
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	01 d0                	add    %edx,%eax
  8008ce:	c1 e0 02             	shl    $0x2,%eax
  8008d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	50                   	push   %eax
  8008d8:	e8 cd 12 00 00       	call   801baa <malloc>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  8008e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008e6:	89 c1                	mov    %eax,%ecx
  8008e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ee:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8008f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f4:	89 d0                	mov    %edx,%eax
  8008f6:	01 c0                	add    %eax,%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	c1 e0 08             	shl    $0x8,%eax
  8008fd:	01 d8                	add    %ebx,%eax
  8008ff:	39 c1                	cmp    %eax,%ecx
  800901:	74 17                	je     80091a <_main+0x8e2>
  800903:	83 ec 04             	sub    $0x4,%esp
  800906:	68 34 3a 80 00       	push   $0x803a34
  80090b:	68 cb 00 00 00       	push   $0xcb
  800910:	68 1c 3a 80 00       	push   $0x803a1c
  800915:	e8 aa 01 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80091a:	e8 f5 16 00 00       	call   802014 <sys_pf_calculate_allocated_pages>
  80091f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800922:	74 17                	je     80093b <_main+0x903>
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 64 3a 80 00       	push   $0x803a64
  80092c:	68 cd 00 00 00       	push   $0xcd
  800931:	68 1c 3a 80 00       	push   $0x803a1c
  800936:	e8 89 01 00 00       	call   800ac4 <_panic>
	//[6] Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - pagealloc_start - 18*Mega + 1));
  80093b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	c1 e0 03             	shl    $0x3,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	01 c0                	add    %eax,%eax
  800947:	f7 d8                	neg    %eax
  800949:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80094c:	2d ff ff ff 5f       	sub    $0x5fffffff,%eax
  800951:	83 ec 0c             	sub    $0xc,%esp
  800954:	50                   	push   %eax
  800955:	e8 50 12 00 00       	call   801baa <malloc>
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  800960:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800963:	85 c0                	test   %eax,%eax
  800965:	74 17                	je     80097e <_main+0x946>
  800967:	83 ec 04             	sub    $0x4,%esp
  80096a:	68 a8 3a 80 00       	push   $0x803aa8
  80096f:	68 d6 00 00 00       	push   $0xd6
  800974:	68 1c 3a 80 00       	push   $0x803a1c
  800979:	e8 46 01 00 00       	call   800ac4 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT (1) [PAGE ALLOCATOR] completed successfully.\n");
  80097e:	83 ec 0c             	sub    $0xc,%esp
  800981:	68 0c 3b 80 00       	push   $0x803b0c
  800986:	e8 f6 03 00 00       	call   800d81 <cprintf>
  80098b:	83 c4 10             	add    $0x10,%esp

	return;
  80098e:	90                   	nop
}
  80098f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800992:	5b                   	pop    %ebx
  800993:	5f                   	pop    %edi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80099c:	e8 b3 18 00 00       	call   802254 <sys_getenvindex>
  8009a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8009a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a7:	89 d0                	mov    %edx,%eax
  8009a9:	01 c0                	add    %eax,%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	c1 e0 06             	shl    $0x6,%eax
  8009b0:	29 d0                	sub    %edx,%eax
  8009b2:	c1 e0 03             	shl    $0x3,%eax
  8009b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009ba:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8009c4:	8a 40 68             	mov    0x68(%eax),%al
  8009c7:	84 c0                	test   %al,%al
  8009c9:	74 0d                	je     8009d8 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8009cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8009d0:	83 c0 68             	add    $0x68,%eax
  8009d3:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009dc:	7e 0a                	jle    8009e8 <libmain+0x52>
		binaryname = argv[0];
  8009de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	ff 75 08             	pushl  0x8(%ebp)
  8009f1:	e8 42 f6 ff ff       	call   800038 <_main>
  8009f6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009f9:	e8 63 16 00 00       	call   802061 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009fe:	83 ec 0c             	sub    $0xc,%esp
  800a01:	68 74 3b 80 00       	push   $0x803b74
  800a06:	e8 76 03 00 00       	call   800d81 <cprintf>
  800a0b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a0e:	a1 20 50 80 00       	mov    0x805020,%eax
  800a13:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800a19:	a1 20 50 80 00       	mov    0x805020,%eax
  800a1e:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800a24:	83 ec 04             	sub    $0x4,%esp
  800a27:	52                   	push   %edx
  800a28:	50                   	push   %eax
  800a29:	68 9c 3b 80 00       	push   $0x803b9c
  800a2e:	e8 4e 03 00 00       	call   800d81 <cprintf>
  800a33:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a36:	a1 20 50 80 00       	mov    0x805020,%eax
  800a3b:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800a41:	a1 20 50 80 00       	mov    0x805020,%eax
  800a46:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800a4c:	a1 20 50 80 00       	mov    0x805020,%eax
  800a51:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800a57:	51                   	push   %ecx
  800a58:	52                   	push   %edx
  800a59:	50                   	push   %eax
  800a5a:	68 c4 3b 80 00       	push   $0x803bc4
  800a5f:	e8 1d 03 00 00       	call   800d81 <cprintf>
  800a64:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a67:	a1 20 50 80 00       	mov    0x805020,%eax
  800a6c:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	50                   	push   %eax
  800a76:	68 1c 3c 80 00       	push   $0x803c1c
  800a7b:	e8 01 03 00 00       	call   800d81 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	68 74 3b 80 00       	push   $0x803b74
  800a8b:	e8 f1 02 00 00       	call   800d81 <cprintf>
  800a90:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a93:	e8 e3 15 00 00       	call   80207b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a98:	e8 19 00 00 00       	call   800ab6 <exit>
}
  800a9d:	90                   	nop
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800aa6:	83 ec 0c             	sub    $0xc,%esp
  800aa9:	6a 00                	push   $0x0
  800aab:	e8 70 17 00 00       	call   802220 <sys_destroy_env>
  800ab0:	83 c4 10             	add    $0x10,%esp
}
  800ab3:	90                   	nop
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <exit>:

void
exit(void)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800abc:	e8 c5 17 00 00       	call   802286 <sys_exit_env>
}
  800ac1:	90                   	nop
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800aca:	8d 45 10             	lea    0x10(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ad3:	a1 18 51 80 00       	mov    0x805118,%eax
  800ad8:	85 c0                	test   %eax,%eax
  800ada:	74 16                	je     800af2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800adc:	a1 18 51 80 00       	mov    0x805118,%eax
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	50                   	push   %eax
  800ae5:	68 30 3c 80 00       	push   $0x803c30
  800aea:	e8 92 02 00 00       	call   800d81 <cprintf>
  800aef:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800af2:	a1 00 50 80 00       	mov    0x805000,%eax
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	50                   	push   %eax
  800afe:	68 35 3c 80 00       	push   $0x803c35
  800b03:	e8 79 02 00 00       	call   800d81 <cprintf>
  800b08:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	50                   	push   %eax
  800b15:	e8 fc 01 00 00       	call   800d16 <vcprintf>
  800b1a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	6a 00                	push   $0x0
  800b22:	68 51 3c 80 00       	push   $0x803c51
  800b27:	e8 ea 01 00 00       	call   800d16 <vcprintf>
  800b2c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b2f:	e8 82 ff ff ff       	call   800ab6 <exit>

	// should not return here
	while (1) ;
  800b34:	eb fe                	jmp    800b34 <_panic+0x70>

00800b36 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b3c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b41:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	39 c2                	cmp    %eax,%edx
  800b4c:	74 14                	je     800b62 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b4e:	83 ec 04             	sub    $0x4,%esp
  800b51:	68 54 3c 80 00       	push   $0x803c54
  800b56:	6a 26                	push   $0x26
  800b58:	68 a0 3c 80 00       	push   $0x803ca0
  800b5d:	e8 62 ff ff ff       	call   800ac4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b70:	e9 c5 00 00 00       	jmp    800c3a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	01 d0                	add    %edx,%eax
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	85 c0                	test   %eax,%eax
  800b88:	75 08                	jne    800b92 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b8a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b8d:	e9 a5 00 00 00       	jmp    800c37 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b92:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b99:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ba0:	eb 69                	jmp    800c0b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ba2:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba7:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800bad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bb0:	89 d0                	mov    %edx,%eax
  800bb2:	01 c0                	add    %eax,%eax
  800bb4:	01 d0                	add    %edx,%eax
  800bb6:	c1 e0 03             	shl    $0x3,%eax
  800bb9:	01 c8                	add    %ecx,%eax
  800bbb:	8a 40 04             	mov    0x4(%eax),%al
  800bbe:	84 c0                	test   %al,%al
  800bc0:	75 46                	jne    800c08 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bc2:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc7:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800bcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bd0:	89 d0                	mov    %edx,%eax
  800bd2:	01 c0                	add    %eax,%eax
  800bd4:	01 d0                	add    %edx,%eax
  800bd6:	c1 e0 03             	shl    $0x3,%eax
  800bd9:	01 c8                	add    %ecx,%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800be0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800be3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800be8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	01 c8                	add    %ecx,%eax
  800bf9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bfb:	39 c2                	cmp    %eax,%edx
  800bfd:	75 09                	jne    800c08 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800bff:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800c06:	eb 15                	jmp    800c1d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c08:	ff 45 e8             	incl   -0x18(%ebp)
  800c0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800c10:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800c16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	77 85                	ja     800ba2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c21:	75 14                	jne    800c37 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800c23:	83 ec 04             	sub    $0x4,%esp
  800c26:	68 ac 3c 80 00       	push   $0x803cac
  800c2b:	6a 3a                	push   $0x3a
  800c2d:	68 a0 3c 80 00       	push   $0x803ca0
  800c32:	e8 8d fe ff ff       	call   800ac4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c37:	ff 45 f0             	incl   -0x10(%ebp)
  800c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c40:	0f 8c 2f ff ff ff    	jl     800b75 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c46:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c54:	eb 26                	jmp    800c7c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c56:	a1 20 50 80 00       	mov    0x805020,%eax
  800c5b:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800c61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c64:	89 d0                	mov    %edx,%eax
  800c66:	01 c0                	add    %eax,%eax
  800c68:	01 d0                	add    %edx,%eax
  800c6a:	c1 e0 03             	shl    $0x3,%eax
  800c6d:	01 c8                	add    %ecx,%eax
  800c6f:	8a 40 04             	mov    0x4(%eax),%al
  800c72:	3c 01                	cmp    $0x1,%al
  800c74:	75 03                	jne    800c79 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c76:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c79:	ff 45 e0             	incl   -0x20(%ebp)
  800c7c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c81:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800c87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c8a:	39 c2                	cmp    %eax,%edx
  800c8c:	77 c8                	ja     800c56 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c91:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c94:	74 14                	je     800caa <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 00 3d 80 00       	push   $0x803d00
  800c9e:	6a 44                	push   $0x44
  800ca0:	68 a0 3c 80 00       	push   $0x803ca0
  800ca5:	e8 1a fe ff ff       	call   800ac4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800caa:	90                   	nop
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	8d 48 01             	lea    0x1(%eax),%ecx
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbe:	89 0a                	mov    %ecx,(%edx)
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	88 d1                	mov    %dl,%cl
  800cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8b 00                	mov    (%eax),%eax
  800cd1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cd6:	75 2c                	jne    800d04 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cd8:	a0 24 50 80 00       	mov    0x805024,%al
  800cdd:	0f b6 c0             	movzbl %al,%eax
  800ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce3:	8b 12                	mov    (%edx),%edx
  800ce5:	89 d1                	mov    %edx,%ecx
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	83 c2 08             	add    $0x8,%edx
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	50                   	push   %eax
  800cf1:	51                   	push   %ecx
  800cf2:	52                   	push   %edx
  800cf3:	e8 10 12 00 00       	call   801f08 <sys_cputs>
  800cf8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	8b 40 04             	mov    0x4(%eax),%eax
  800d0a:	8d 50 01             	lea    0x1(%eax),%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d13:	90                   	nop
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d1f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d26:	00 00 00 
	b.cnt = 0;
  800d29:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d30:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	ff 75 08             	pushl  0x8(%ebp)
  800d39:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d3f:	50                   	push   %eax
  800d40:	68 ad 0c 80 00       	push   $0x800cad
  800d45:	e8 11 02 00 00       	call   800f5b <vprintfmt>
  800d4a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d4d:	a0 24 50 80 00       	mov    0x805024,%al
  800d52:	0f b6 c0             	movzbl %al,%eax
  800d55:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	50                   	push   %eax
  800d5f:	52                   	push   %edx
  800d60:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d66:	83 c0 08             	add    $0x8,%eax
  800d69:	50                   	push   %eax
  800d6a:	e8 99 11 00 00       	call   801f08 <sys_cputs>
  800d6f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d72:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d79:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d87:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9d:	50                   	push   %eax
  800d9e:	e8 73 ff ff ff       	call   800d16 <vcprintf>
  800da3:	83 c4 10             	add    $0x10,%esp
  800da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800db4:	e8 a8 12 00 00       	call   802061 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800db9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	83 ec 08             	sub    $0x8,%esp
  800dc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc8:	50                   	push   %eax
  800dc9:	e8 48 ff ff ff       	call   800d16 <vcprintf>
  800dce:	83 c4 10             	add    $0x10,%esp
  800dd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dd4:	e8 a2 12 00 00       	call   80207b <sys_enable_interrupt>
	return cnt;
  800dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	53                   	push   %ebx
  800de2:	83 ec 14             	sub    $0x14,%esp
  800de5:	8b 45 10             	mov    0x10(%ebp),%eax
  800de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800df1:	8b 45 18             	mov    0x18(%ebp),%eax
  800df4:	ba 00 00 00 00       	mov    $0x0,%edx
  800df9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800dfc:	77 55                	ja     800e53 <printnum+0x75>
  800dfe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e01:	72 05                	jb     800e08 <printnum+0x2a>
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	77 4b                	ja     800e53 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e08:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e0b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e0e:	8b 45 18             	mov    0x18(%ebp),%eax
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	52                   	push   %edx
  800e17:	50                   	push   %eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e1e:	e8 69 29 00 00       	call   80378c <__udivdi3>
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	83 ec 04             	sub    $0x4,%esp
  800e29:	ff 75 20             	pushl  0x20(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	ff 75 18             	pushl  0x18(%ebp)
  800e30:	52                   	push   %edx
  800e31:	50                   	push   %eax
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	ff 75 08             	pushl  0x8(%ebp)
  800e38:	e8 a1 ff ff ff       	call   800dde <printnum>
  800e3d:	83 c4 20             	add    $0x20,%esp
  800e40:	eb 1a                	jmp    800e5c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	ff 75 20             	pushl  0x20(%ebp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	ff d0                	call   *%eax
  800e50:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e53:	ff 4d 1c             	decl   0x1c(%ebp)
  800e56:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e5a:	7f e6                	jg     800e42 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e5c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6a:	53                   	push   %ebx
  800e6b:	51                   	push   %ecx
  800e6c:	52                   	push   %edx
  800e6d:	50                   	push   %eax
  800e6e:	e8 29 2a 00 00       	call   80389c <__umoddi3>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	05 74 3f 80 00       	add    $0x803f74,%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	0f be c0             	movsbl %al,%eax
  800e80:	83 ec 08             	sub    $0x8,%esp
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	50                   	push   %eax
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
}
  800e8f:	90                   	nop
  800e90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e98:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e9c:	7e 1c                	jle    800eba <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	8d 50 08             	lea    0x8(%eax),%edx
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	89 10                	mov    %edx,(%eax)
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	83 e8 08             	sub    $0x8,%eax
  800eb3:	8b 50 04             	mov    0x4(%eax),%edx
  800eb6:	8b 00                	mov    (%eax),%eax
  800eb8:	eb 40                	jmp    800efa <getuint+0x65>
	else if (lflag)
  800eba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebe:	74 1e                	je     800ede <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8b 00                	mov    (%eax),%eax
  800ec5:	8d 50 04             	lea    0x4(%eax),%edx
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 10                	mov    %edx,(%eax)
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8b 00                	mov    (%eax),%eax
  800ed2:	83 e8 04             	sub    $0x4,%eax
  800ed5:	8b 00                	mov    (%eax),%eax
  800ed7:	ba 00 00 00 00       	mov    $0x0,%edx
  800edc:	eb 1c                	jmp    800efa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8b 00                	mov    (%eax),%eax
  800ee3:	8d 50 04             	lea    0x4(%eax),%edx
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 10                	mov    %edx,(%eax)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8b 00                	mov    (%eax),%eax
  800ef0:	83 e8 04             	sub    $0x4,%eax
  800ef3:	8b 00                	mov    (%eax),%eax
  800ef5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800eff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f03:	7e 1c                	jle    800f21 <getint+0x25>
		return va_arg(*ap, long long);
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8b 00                	mov    (%eax),%eax
  800f0a:	8d 50 08             	lea    0x8(%eax),%edx
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	89 10                	mov    %edx,(%eax)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8b 00                	mov    (%eax),%eax
  800f17:	83 e8 08             	sub    $0x8,%eax
  800f1a:	8b 50 04             	mov    0x4(%eax),%edx
  800f1d:	8b 00                	mov    (%eax),%eax
  800f1f:	eb 38                	jmp    800f59 <getint+0x5d>
	else if (lflag)
  800f21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f25:	74 1a                	je     800f41 <getint+0x45>
		return va_arg(*ap, long);
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	8d 50 04             	lea    0x4(%eax),%edx
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 10                	mov    %edx,(%eax)
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8b 00                	mov    (%eax),%eax
  800f39:	83 e8 04             	sub    $0x4,%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	99                   	cltd   
  800f3f:	eb 18                	jmp    800f59 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8b 00                	mov    (%eax),%eax
  800f46:	8d 50 04             	lea    0x4(%eax),%edx
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	89 10                	mov    %edx,(%eax)
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8b 00                	mov    (%eax),%eax
  800f53:	83 e8 04             	sub    $0x4,%eax
  800f56:	8b 00                	mov    (%eax),%eax
  800f58:	99                   	cltd   
}
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f63:	eb 17                	jmp    800f7c <vprintfmt+0x21>
			if (ch == '\0')
  800f65:	85 db                	test   %ebx,%ebx
  800f67:	0f 84 af 03 00 00    	je     80131c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	53                   	push   %ebx
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	ff d0                	call   *%eax
  800f79:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	89 55 10             	mov    %edx,0x10(%ebp)
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	0f b6 d8             	movzbl %al,%ebx
  800f8a:	83 fb 25             	cmp    $0x25,%ebx
  800f8d:	75 d6                	jne    800f65 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f8f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f93:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f9a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800fa1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fa8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	8d 50 01             	lea    0x1(%eax),%edx
  800fb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f b6 d8             	movzbl %al,%ebx
  800fbd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fc0:	83 f8 55             	cmp    $0x55,%eax
  800fc3:	0f 87 2b 03 00 00    	ja     8012f4 <vprintfmt+0x399>
  800fc9:	8b 04 85 98 3f 80 00 	mov    0x803f98(,%eax,4),%eax
  800fd0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fd2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fd6:	eb d7                	jmp    800faf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fd8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fdc:	eb d1                	jmp    800faf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fde:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fe5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fe8:	89 d0                	mov    %edx,%eax
  800fea:	c1 e0 02             	shl    $0x2,%eax
  800fed:	01 d0                	add    %edx,%eax
  800fef:	01 c0                	add    %eax,%eax
  800ff1:	01 d8                	add    %ebx,%eax
  800ff3:	83 e8 30             	sub    $0x30,%eax
  800ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801001:	83 fb 2f             	cmp    $0x2f,%ebx
  801004:	7e 3e                	jle    801044 <vprintfmt+0xe9>
  801006:	83 fb 39             	cmp    $0x39,%ebx
  801009:	7f 39                	jg     801044 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80100b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80100e:	eb d5                	jmp    800fe5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801010:	8b 45 14             	mov    0x14(%ebp),%eax
  801013:	83 c0 04             	add    $0x4,%eax
  801016:	89 45 14             	mov    %eax,0x14(%ebp)
  801019:	8b 45 14             	mov    0x14(%ebp),%eax
  80101c:	83 e8 04             	sub    $0x4,%eax
  80101f:	8b 00                	mov    (%eax),%eax
  801021:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801024:	eb 1f                	jmp    801045 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801026:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80102a:	79 83                	jns    800faf <vprintfmt+0x54>
				width = 0;
  80102c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801033:	e9 77 ff ff ff       	jmp    800faf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801038:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80103f:	e9 6b ff ff ff       	jmp    800faf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801044:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801045:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801049:	0f 89 60 ff ff ff    	jns    800faf <vprintfmt+0x54>
				width = precision, precision = -1;
  80104f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801055:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80105c:	e9 4e ff ff ff       	jmp    800faf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801061:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801064:	e9 46 ff ff ff       	jmp    800faf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801069:	8b 45 14             	mov    0x14(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 14             	mov    %eax,0x14(%ebp)
  801072:	8b 45 14             	mov    0x14(%ebp),%eax
  801075:	83 e8 04             	sub    $0x4,%eax
  801078:	8b 00                	mov    (%eax),%eax
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	50                   	push   %eax
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	ff d0                	call   *%eax
  801086:	83 c4 10             	add    $0x10,%esp
			break;
  801089:	e9 89 02 00 00       	jmp    801317 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 c0 04             	add    $0x4,%eax
  801094:	89 45 14             	mov    %eax,0x14(%ebp)
  801097:	8b 45 14             	mov    0x14(%ebp),%eax
  80109a:	83 e8 04             	sub    $0x4,%eax
  80109d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80109f:	85 db                	test   %ebx,%ebx
  8010a1:	79 02                	jns    8010a5 <vprintfmt+0x14a>
				err = -err;
  8010a3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010a5:	83 fb 64             	cmp    $0x64,%ebx
  8010a8:	7f 0b                	jg     8010b5 <vprintfmt+0x15a>
  8010aa:	8b 34 9d e0 3d 80 00 	mov    0x803de0(,%ebx,4),%esi
  8010b1:	85 f6                	test   %esi,%esi
  8010b3:	75 19                	jne    8010ce <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010b5:	53                   	push   %ebx
  8010b6:	68 85 3f 80 00       	push   $0x803f85
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 5e 02 00 00       	call   801324 <printfmt>
  8010c6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010c9:	e9 49 02 00 00       	jmp    801317 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010ce:	56                   	push   %esi
  8010cf:	68 8e 3f 80 00       	push   $0x803f8e
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	ff 75 08             	pushl  0x8(%ebp)
  8010da:	e8 45 02 00 00       	call   801324 <printfmt>
  8010df:	83 c4 10             	add    $0x10,%esp
			break;
  8010e2:	e9 30 02 00 00       	jmp    801317 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	83 c0 04             	add    $0x4,%eax
  8010ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 30                	mov    (%eax),%esi
  8010f8:	85 f6                	test   %esi,%esi
  8010fa:	75 05                	jne    801101 <vprintfmt+0x1a6>
				p = "(null)";
  8010fc:	be 91 3f 80 00       	mov    $0x803f91,%esi
			if (width > 0 && padc != '-')
  801101:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801105:	7e 6d                	jle    801174 <vprintfmt+0x219>
  801107:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80110b:	74 67                	je     801174 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80110d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801110:	83 ec 08             	sub    $0x8,%esp
  801113:	50                   	push   %eax
  801114:	56                   	push   %esi
  801115:	e8 0c 03 00 00       	call   801426 <strnlen>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801120:	eb 16                	jmp    801138 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801122:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801126:	83 ec 08             	sub    $0x8,%esp
  801129:	ff 75 0c             	pushl  0xc(%ebp)
  80112c:	50                   	push   %eax
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	ff d0                	call   *%eax
  801132:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801135:	ff 4d e4             	decl   -0x1c(%ebp)
  801138:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80113c:	7f e4                	jg     801122 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80113e:	eb 34                	jmp    801174 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801140:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801144:	74 1c                	je     801162 <vprintfmt+0x207>
  801146:	83 fb 1f             	cmp    $0x1f,%ebx
  801149:	7e 05                	jle    801150 <vprintfmt+0x1f5>
  80114b:	83 fb 7e             	cmp    $0x7e,%ebx
  80114e:	7e 12                	jle    801162 <vprintfmt+0x207>
					putch('?', putdat);
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	6a 3f                	push   $0x3f
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	ff d0                	call   *%eax
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	eb 0f                	jmp    801171 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	ff 75 0c             	pushl  0xc(%ebp)
  801168:	53                   	push   %ebx
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	ff d0                	call   *%eax
  80116e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801171:	ff 4d e4             	decl   -0x1c(%ebp)
  801174:	89 f0                	mov    %esi,%eax
  801176:	8d 70 01             	lea    0x1(%eax),%esi
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be d8             	movsbl %al,%ebx
  80117e:	85 db                	test   %ebx,%ebx
  801180:	74 24                	je     8011a6 <vprintfmt+0x24b>
  801182:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801186:	78 b8                	js     801140 <vprintfmt+0x1e5>
  801188:	ff 4d e0             	decl   -0x20(%ebp)
  80118b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80118f:	79 af                	jns    801140 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801191:	eb 13                	jmp    8011a6 <vprintfmt+0x24b>
				putch(' ', putdat);
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	ff 75 0c             	pushl  0xc(%ebp)
  801199:	6a 20                	push   $0x20
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	ff d0                	call   *%eax
  8011a0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011a3:	ff 4d e4             	decl   -0x1c(%ebp)
  8011a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011aa:	7f e7                	jg     801193 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011ac:	e9 66 01 00 00       	jmp    801317 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8011b7:	8d 45 14             	lea    0x14(%ebp),%eax
  8011ba:	50                   	push   %eax
  8011bb:	e8 3c fd ff ff       	call   800efc <getint>
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	85 d2                	test   %edx,%edx
  8011d1:	79 23                	jns    8011f6 <vprintfmt+0x29b>
				putch('-', putdat);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	6a 2d                	push   $0x2d
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	ff d0                	call   *%eax
  8011e0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e9:	f7 d8                	neg    %eax
  8011eb:	83 d2 00             	adc    $0x0,%edx
  8011ee:	f7 da                	neg    %edx
  8011f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011fd:	e9 bc 00 00 00       	jmp    8012be <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801202:	83 ec 08             	sub    $0x8,%esp
  801205:	ff 75 e8             	pushl  -0x18(%ebp)
  801208:	8d 45 14             	lea    0x14(%ebp),%eax
  80120b:	50                   	push   %eax
  80120c:	e8 84 fc ff ff       	call   800e95 <getuint>
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801217:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80121a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801221:	e9 98 00 00 00       	jmp    8012be <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	ff 75 0c             	pushl  0xc(%ebp)
  80122c:	6a 58                	push   $0x58
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	ff d0                	call   *%eax
  801233:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801236:	83 ec 08             	sub    $0x8,%esp
  801239:	ff 75 0c             	pushl  0xc(%ebp)
  80123c:	6a 58                	push   $0x58
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	ff d0                	call   *%eax
  801243:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801246:	83 ec 08             	sub    $0x8,%esp
  801249:	ff 75 0c             	pushl  0xc(%ebp)
  80124c:	6a 58                	push   $0x58
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	ff d0                	call   *%eax
  801253:	83 c4 10             	add    $0x10,%esp
			break;
  801256:	e9 bc 00 00 00       	jmp    801317 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 0c             	pushl  0xc(%ebp)
  801261:	6a 30                	push   $0x30
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	ff d0                	call   *%eax
  801268:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	ff 75 0c             	pushl  0xc(%ebp)
  801271:	6a 78                	push   $0x78
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	ff d0                	call   *%eax
  801278:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	83 c0 04             	add    $0x4,%eax
  801281:	89 45 14             	mov    %eax,0x14(%ebp)
  801284:	8b 45 14             	mov    0x14(%ebp),%eax
  801287:	83 e8 04             	sub    $0x4,%eax
  80128a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80128c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80128f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801296:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80129d:	eb 1f                	jmp    8012be <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8012a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8012a8:	50                   	push   %eax
  8012a9:	e8 e7 fb ff ff       	call   800e95 <getuint>
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012b7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012be:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012c5:	83 ec 04             	sub    $0x4,%esp
  8012c8:	52                   	push   %edx
  8012c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 00 fb ff ff       	call   800dde <printnum>
  8012de:	83 c4 20             	add    $0x20,%esp
			break;
  8012e1:	eb 34                	jmp    801317 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	53                   	push   %ebx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	ff d0                	call   *%eax
  8012ef:	83 c4 10             	add    $0x10,%esp
			break;
  8012f2:	eb 23                	jmp    801317 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 0c             	pushl  0xc(%ebp)
  8012fa:	6a 25                	push   $0x25
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	ff d0                	call   *%eax
  801301:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801304:	ff 4d 10             	decl   0x10(%ebp)
  801307:	eb 03                	jmp    80130c <vprintfmt+0x3b1>
  801309:	ff 4d 10             	decl   0x10(%ebp)
  80130c:	8b 45 10             	mov    0x10(%ebp),%eax
  80130f:	48                   	dec    %eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	3c 25                	cmp    $0x25,%al
  801314:	75 f3                	jne    801309 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801316:	90                   	nop
		}
	}
  801317:	e9 47 fc ff ff       	jmp    800f63 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80131c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80131d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80132a:	8d 45 10             	lea    0x10(%ebp),%eax
  80132d:	83 c0 04             	add    $0x4,%eax
  801330:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	ff 75 f4             	pushl  -0xc(%ebp)
  801339:	50                   	push   %eax
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 16 fc ff ff       	call   800f5b <vprintfmt>
  801345:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801348:	90                   	nop
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8b 40 08             	mov    0x8(%eax),%eax
  801354:	8d 50 01             	lea    0x1(%eax),%edx
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	8b 10                	mov    (%eax),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	8b 40 04             	mov    0x4(%eax),%eax
  801368:	39 c2                	cmp    %eax,%edx
  80136a:	73 12                	jae    80137e <sprintputch+0x33>
		*b->buf++ = ch;
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	8d 48 01             	lea    0x1(%eax),%ecx
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	89 0a                	mov    %ecx,(%edx)
  801379:	8b 55 08             	mov    0x8(%ebp),%edx
  80137c:	88 10                	mov    %dl,(%eax)
}
  80137e:	90                   	nop
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    

00801381 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	8d 50 ff             	lea    -0x1(%eax),%edx
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	01 d0                	add    %edx,%eax
  801398:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80139b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a6:	74 06                	je     8013ae <vsnprintf+0x2d>
  8013a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ac:	7f 07                	jg     8013b5 <vsnprintf+0x34>
		return -E_INVAL;
  8013ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8013b3:	eb 20                	jmp    8013d5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013b5:	ff 75 14             	pushl  0x14(%ebp)
  8013b8:	ff 75 10             	pushl  0x10(%ebp)
  8013bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013be:	50                   	push   %eax
  8013bf:	68 4b 13 80 00       	push   $0x80134b
  8013c4:	e8 92 fb ff ff       	call   800f5b <vprintfmt>
  8013c9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8013e0:	83 c0 04             	add    $0x4,%eax
  8013e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ec:	50                   	push   %eax
  8013ed:	ff 75 0c             	pushl  0xc(%ebp)
  8013f0:	ff 75 08             	pushl  0x8(%ebp)
  8013f3:	e8 89 ff ff ff       	call   801381 <vsnprintf>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801409:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801410:	eb 06                	jmp    801418 <strlen+0x15>
		n++;
  801412:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801415:	ff 45 08             	incl   0x8(%ebp)
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	84 c0                	test   %al,%al
  80141f:	75 f1                	jne    801412 <strlen+0xf>
		n++;
	return n;
  801421:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80142c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801433:	eb 09                	jmp    80143e <strnlen+0x18>
		n++;
  801435:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801438:	ff 45 08             	incl   0x8(%ebp)
  80143b:	ff 4d 0c             	decl   0xc(%ebp)
  80143e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801442:	74 09                	je     80144d <strnlen+0x27>
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	84 c0                	test   %al,%al
  80144b:	75 e8                	jne    801435 <strnlen+0xf>
		n++;
	return n;
  80144d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80145e:	90                   	nop
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8d 50 01             	lea    0x1(%eax),%edx
  801465:	89 55 08             	mov    %edx,0x8(%ebp)
  801468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801471:	8a 12                	mov    (%edx),%dl
  801473:	88 10                	mov    %dl,(%eax)
  801475:	8a 00                	mov    (%eax),%al
  801477:	84 c0                	test   %al,%al
  801479:	75 e4                	jne    80145f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80147b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80148c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801493:	eb 1f                	jmp    8014b4 <strncpy+0x34>
		*dst++ = *src;
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8d 50 01             	lea    0x1(%eax),%edx
  80149b:	89 55 08             	mov    %edx,0x8(%ebp)
  80149e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a1:	8a 12                	mov    (%edx),%dl
  8014a3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	84 c0                	test   %al,%al
  8014ac:	74 03                	je     8014b1 <strncpy+0x31>
			src++;
  8014ae:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014b1:	ff 45 fc             	incl   -0x4(%ebp)
  8014b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ba:	72 d9                	jb     801495 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d1:	74 30                	je     801503 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014d3:	eb 16                	jmp    8014eb <strlcpy+0x2a>
			*dst++ = *src++;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8d 50 01             	lea    0x1(%eax),%edx
  8014db:	89 55 08             	mov    %edx,0x8(%ebp)
  8014de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014e7:	8a 12                	mov    (%edx),%dl
  8014e9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014eb:	ff 4d 10             	decl   0x10(%ebp)
  8014ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f2:	74 09                	je     8014fd <strlcpy+0x3c>
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	84 c0                	test   %al,%al
  8014fb:	75 d8                	jne    8014d5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801503:	8b 55 08             	mov    0x8(%ebp),%edx
  801506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801509:	29 c2                	sub    %eax,%edx
  80150b:	89 d0                	mov    %edx,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801512:	eb 06                	jmp    80151a <strcmp+0xb>
		p++, q++;
  801514:	ff 45 08             	incl   0x8(%ebp)
  801517:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	84 c0                	test   %al,%al
  801521:	74 0e                	je     801531 <strcmp+0x22>
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 10                	mov    (%eax),%dl
  801528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	38 c2                	cmp    %al,%dl
  80152f:	74 e3                	je     801514 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	0f b6 d0             	movzbl %al,%edx
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	0f b6 c0             	movzbl %al,%eax
  801541:	29 c2                	sub    %eax,%edx
  801543:	89 d0                	mov    %edx,%eax
}
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80154a:	eb 09                	jmp    801555 <strncmp+0xe>
		n--, p++, q++;
  80154c:	ff 4d 10             	decl   0x10(%ebp)
  80154f:	ff 45 08             	incl   0x8(%ebp)
  801552:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801555:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801559:	74 17                	je     801572 <strncmp+0x2b>
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	84 c0                	test   %al,%al
  801562:	74 0e                	je     801572 <strncmp+0x2b>
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 10                	mov    (%eax),%dl
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	38 c2                	cmp    %al,%dl
  801570:	74 da                	je     80154c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801572:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801576:	75 07                	jne    80157f <strncmp+0x38>
		return 0;
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
  80157d:	eb 14                	jmp    801593 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	0f b6 d0             	movzbl %al,%edx
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	0f b6 c0             	movzbl %al,%eax
  80158f:	29 c2                	sub    %eax,%edx
  801591:	89 d0                	mov    %edx,%eax
}
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a1:	eb 12                	jmp    8015b5 <strchr+0x20>
		if (*s == c)
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015ab:	75 05                	jne    8015b2 <strchr+0x1d>
			return (char *) s;
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	eb 11                	jmp    8015c3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015b2:	ff 45 08             	incl   0x8(%ebp)
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	8a 00                	mov    (%eax),%al
  8015ba:	84 c0                	test   %al,%al
  8015bc:	75 e5                	jne    8015a3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015d1:	eb 0d                	jmp    8015e0 <strfind+0x1b>
		if (*s == c)
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015db:	74 0e                	je     8015eb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015dd:	ff 45 08             	incl   0x8(%ebp)
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	8a 00                	mov    (%eax),%al
  8015e5:	84 c0                	test   %al,%al
  8015e7:	75 ea                	jne    8015d3 <strfind+0xe>
  8015e9:	eb 01                	jmp    8015ec <strfind+0x27>
		if (*s == c)
			break;
  8015eb:	90                   	nop
	return (char *) s;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801603:	eb 0e                	jmp    801613 <memset+0x22>
		*p++ = c;
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801608:	8d 50 01             	lea    0x1(%eax),%edx
  80160b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801613:	ff 4d f8             	decl   -0x8(%ebp)
  801616:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80161a:	79 e9                	jns    801605 <memset+0x14>
		*p++ = c;

	return v;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801633:	eb 16                	jmp    80164b <memcpy+0x2a>
		*d++ = *s++;
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	8d 50 01             	lea    0x1(%eax),%edx
  80163b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80163e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801641:	8d 4a 01             	lea    0x1(%edx),%ecx
  801644:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801647:	8a 12                	mov    (%edx),%dl
  801649:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80164b:	8b 45 10             	mov    0x10(%ebp),%eax
  80164e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801651:	89 55 10             	mov    %edx,0x10(%ebp)
  801654:	85 c0                	test   %eax,%eax
  801656:	75 dd                	jne    801635 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801663:	8b 45 0c             	mov    0xc(%ebp),%eax
  801666:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801672:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801675:	73 50                	jae    8016c7 <memmove+0x6a>
  801677:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167a:	8b 45 10             	mov    0x10(%ebp),%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801682:	76 43                	jbe    8016c7 <memmove+0x6a>
		s += n;
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801690:	eb 10                	jmp    8016a2 <memmove+0x45>
			*--d = *--s;
  801692:	ff 4d f8             	decl   -0x8(%ebp)
  801695:	ff 4d fc             	decl   -0x4(%ebp)
  801698:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169b:	8a 10                	mov    (%eax),%dl
  80169d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	75 e3                	jne    801692 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016af:	eb 23                	jmp    8016d4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	8d 50 01             	lea    0x1(%eax),%edx
  8016b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016c3:	8a 12                	mov    (%edx),%dl
  8016c5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	75 dd                	jne    8016b1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016eb:	eb 2a                	jmp    801717 <memcmp+0x3e>
		if (*s1 != *s2)
  8016ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f0:	8a 10                	mov    (%eax),%dl
  8016f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	38 c2                	cmp    %al,%dl
  8016f9:	74 16                	je     801711 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	0f b6 d0             	movzbl %al,%edx
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801706:	8a 00                	mov    (%eax),%al
  801708:	0f b6 c0             	movzbl %al,%eax
  80170b:	29 c2                	sub    %eax,%edx
  80170d:	89 d0                	mov    %edx,%eax
  80170f:	eb 18                	jmp    801729 <memcmp+0x50>
		s1++, s2++;
  801711:	ff 45 fc             	incl   -0x4(%ebp)
  801714:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801717:	8b 45 10             	mov    0x10(%ebp),%eax
  80171a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80171d:	89 55 10             	mov    %edx,0x10(%ebp)
  801720:	85 c0                	test   %eax,%eax
  801722:	75 c9                	jne    8016ed <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801731:	8b 55 08             	mov    0x8(%ebp),%edx
  801734:	8b 45 10             	mov    0x10(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80173c:	eb 15                	jmp    801753 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	0f b6 d0             	movzbl %al,%edx
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	0f b6 c0             	movzbl %al,%eax
  80174c:	39 c2                	cmp    %eax,%edx
  80174e:	74 0d                	je     80175d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801750:	ff 45 08             	incl   0x8(%ebp)
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801759:	72 e3                	jb     80173e <memfind+0x13>
  80175b:	eb 01                	jmp    80175e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80175d:	90                   	nop
	return (void *) s;
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801769:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801770:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801777:	eb 03                	jmp    80177c <strtol+0x19>
		s++;
  801779:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	3c 20                	cmp    $0x20,%al
  801783:	74 f4                	je     801779 <strtol+0x16>
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8a 00                	mov    (%eax),%al
  80178a:	3c 09                	cmp    $0x9,%al
  80178c:	74 eb                	je     801779 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	3c 2b                	cmp    $0x2b,%al
  801795:	75 05                	jne    80179c <strtol+0x39>
		s++;
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	eb 13                	jmp    8017af <strtol+0x4c>
	else if (*s == '-')
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	8a 00                	mov    (%eax),%al
  8017a1:	3c 2d                	cmp    $0x2d,%al
  8017a3:	75 0a                	jne    8017af <strtol+0x4c>
		s++, neg = 1;
  8017a5:	ff 45 08             	incl   0x8(%ebp)
  8017a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b3:	74 06                	je     8017bb <strtol+0x58>
  8017b5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017b9:	75 20                	jne    8017db <strtol+0x78>
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	3c 30                	cmp    $0x30,%al
  8017c2:	75 17                	jne    8017db <strtol+0x78>
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	40                   	inc    %eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	3c 78                	cmp    $0x78,%al
  8017cc:	75 0d                	jne    8017db <strtol+0x78>
		s += 2, base = 16;
  8017ce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017d2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017d9:	eb 28                	jmp    801803 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017df:	75 15                	jne    8017f6 <strtol+0x93>
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	3c 30                	cmp    $0x30,%al
  8017e8:	75 0c                	jne    8017f6 <strtol+0x93>
		s++, base = 8;
  8017ea:	ff 45 08             	incl   0x8(%ebp)
  8017ed:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017f4:	eb 0d                	jmp    801803 <strtol+0xa0>
	else if (base == 0)
  8017f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017fa:	75 07                	jne    801803 <strtol+0xa0>
		base = 10;
  8017fc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	3c 2f                	cmp    $0x2f,%al
  80180a:	7e 19                	jle    801825 <strtol+0xc2>
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3c 39                	cmp    $0x39,%al
  801813:	7f 10                	jg     801825 <strtol+0xc2>
			dig = *s - '0';
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	0f be c0             	movsbl %al,%eax
  80181d:	83 e8 30             	sub    $0x30,%eax
  801820:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801823:	eb 42                	jmp    801867 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	3c 60                	cmp    $0x60,%al
  80182c:	7e 19                	jle    801847 <strtol+0xe4>
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 7a                	cmp    $0x7a,%al
  801835:	7f 10                	jg     801847 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	0f be c0             	movsbl %al,%eax
  80183f:	83 e8 57             	sub    $0x57,%eax
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801845:	eb 20                	jmp    801867 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	3c 40                	cmp    $0x40,%al
  80184e:	7e 39                	jle    801889 <strtol+0x126>
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	3c 5a                	cmp    $0x5a,%al
  801857:	7f 30                	jg     801889 <strtol+0x126>
			dig = *s - 'A' + 10;
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	0f be c0             	movsbl %al,%eax
  801861:	83 e8 37             	sub    $0x37,%eax
  801864:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80186d:	7d 19                	jge    801888 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80186f:	ff 45 08             	incl   0x8(%ebp)
  801872:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801875:	0f af 45 10          	imul   0x10(%ebp),%eax
  801879:	89 c2                	mov    %eax,%edx
  80187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187e:	01 d0                	add    %edx,%eax
  801880:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801883:	e9 7b ff ff ff       	jmp    801803 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801888:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801889:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80188d:	74 08                	je     801897 <strtol+0x134>
		*endptr = (char *) s;
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8b 55 08             	mov    0x8(%ebp),%edx
  801895:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801897:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80189b:	74 07                	je     8018a4 <strtol+0x141>
  80189d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a0:	f7 d8                	neg    %eax
  8018a2:	eb 03                	jmp    8018a7 <strtol+0x144>
  8018a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c1:	79 13                	jns    8018d6 <ltostr+0x2d>
	{
		neg = 1;
  8018c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018d0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018d3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018de:	99                   	cltd   
  8018df:	f7 f9                	idiv   %ecx
  8018e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e7:	8d 50 01             	lea    0x1(%eax),%edx
  8018ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ed:	89 c2                	mov    %eax,%edx
  8018ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f7:	83 c2 30             	add    $0x30,%edx
  8018fa:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ff:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801904:	f7 e9                	imul   %ecx
  801906:	c1 fa 02             	sar    $0x2,%edx
  801909:	89 c8                	mov    %ecx,%eax
  80190b:	c1 f8 1f             	sar    $0x1f,%eax
  80190e:	29 c2                	sub    %eax,%edx
  801910:	89 d0                	mov    %edx,%eax
  801912:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801915:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801918:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80191d:	f7 e9                	imul   %ecx
  80191f:	c1 fa 02             	sar    $0x2,%edx
  801922:	89 c8                	mov    %ecx,%eax
  801924:	c1 f8 1f             	sar    $0x1f,%eax
  801927:	29 c2                	sub    %eax,%edx
  801929:	89 d0                	mov    %edx,%eax
  80192b:	c1 e0 02             	shl    $0x2,%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	01 c0                	add    %eax,%eax
  801932:	29 c1                	sub    %eax,%ecx
  801934:	89 ca                	mov    %ecx,%edx
  801936:	85 d2                	test   %edx,%edx
  801938:	75 9c                	jne    8018d6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80193a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801941:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801944:	48                   	dec    %eax
  801945:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801948:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80194c:	74 3d                	je     80198b <ltostr+0xe2>
		start = 1 ;
  80194e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801955:	eb 34                	jmp    80198b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	01 d0                	add    %edx,%eax
  80195f:	8a 00                	mov    (%eax),%al
  801961:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801978:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197e:	01 c2                	add    %eax,%edx
  801980:	8a 45 eb             	mov    -0x15(%ebp),%al
  801983:	88 02                	mov    %al,(%edx)
		start++ ;
  801985:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801988:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80198b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801991:	7c c4                	jl     801957 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801993:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801996:	8b 45 0c             	mov    0xc(%ebp),%eax
  801999:	01 d0                	add    %edx,%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80199e:	90                   	nop
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 54 fa ff ff       	call   801403 <strlen>
  8019af:	83 c4 04             	add    $0x4,%esp
  8019b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	e8 46 fa ff ff       	call   801403 <strlen>
  8019bd:	83 c4 04             	add    $0x4,%esp
  8019c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019d1:	eb 17                	jmp    8019ea <strcconcat+0x49>
		final[s] = str1[s] ;
  8019d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d9:	01 c2                	add    %eax,%edx
  8019db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	01 c8                	add    %ecx,%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019e7:	ff 45 fc             	incl   -0x4(%ebp)
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019f0:	7c e1                	jl     8019d3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a00:	eb 1f                	jmp    801a21 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a05:	8d 50 01             	lea    0x1(%eax),%edx
  801a08:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a0b:	89 c2                	mov    %eax,%edx
  801a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a10:	01 c2                	add    %eax,%edx
  801a12:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	01 c8                	add    %ecx,%eax
  801a1a:	8a 00                	mov    (%eax),%al
  801a1c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a1e:	ff 45 f8             	incl   -0x8(%ebp)
  801a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a27:	7c d9                	jl     801a02 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	c6 00 00             	movb   $0x0,(%eax)
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a52:	01 d0                	add    %edx,%eax
  801a54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a5a:	eb 0c                	jmp    801a68 <strsplit+0x31>
			*string++ = 0;
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8d 50 01             	lea    0x1(%eax),%edx
  801a62:	89 55 08             	mov    %edx,0x8(%ebp)
  801a65:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	8a 00                	mov    (%eax),%al
  801a6d:	84 c0                	test   %al,%al
  801a6f:	74 18                	je     801a89 <strsplit+0x52>
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	0f be c0             	movsbl %al,%eax
  801a79:	50                   	push   %eax
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	e8 13 fb ff ff       	call   801595 <strchr>
  801a82:	83 c4 08             	add    $0x8,%esp
  801a85:	85 c0                	test   %eax,%eax
  801a87:	75 d3                	jne    801a5c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	84 c0                	test   %al,%al
  801a90:	74 5a                	je     801aec <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	8b 00                	mov    (%eax),%eax
  801a97:	83 f8 0f             	cmp    $0xf,%eax
  801a9a:	75 07                	jne    801aa3 <strsplit+0x6c>
		{
			return 0;
  801a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa1:	eb 66                	jmp    801b09 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8b 00                	mov    (%eax),%eax
  801aa8:	8d 48 01             	lea    0x1(%eax),%ecx
  801aab:	8b 55 14             	mov    0x14(%ebp),%edx
  801aae:	89 0a                	mov    %ecx,(%edx)
  801ab0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aba:	01 c2                	add    %eax,%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ac1:	eb 03                	jmp    801ac6 <strsplit+0x8f>
			string++;
  801ac3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	8a 00                	mov    (%eax),%al
  801acb:	84 c0                	test   %al,%al
  801acd:	74 8b                	je     801a5a <strsplit+0x23>
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	8a 00                	mov    (%eax),%al
  801ad4:	0f be c0             	movsbl %al,%eax
  801ad7:	50                   	push   %eax
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	e8 b5 fa ff ff       	call   801595 <strchr>
  801ae0:	83 c4 08             	add    $0x8,%esp
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	74 dc                	je     801ac3 <strsplit+0x8c>
			string++;
	}
  801ae7:	e9 6e ff ff ff       	jmp    801a5a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801aec:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801aed:	8b 45 14             	mov    0x14(%ebp),%eax
  801af0:	8b 00                	mov    (%eax),%eax
  801af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	01 d0                	add    %edx,%eax
  801afe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b04:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801b11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b18:	eb 4c                	jmp    801b66 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801b1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b20:	01 d0                	add    %edx,%eax
  801b22:	8a 00                	mov    (%eax),%al
  801b24:	3c 40                	cmp    $0x40,%al
  801b26:	7e 27                	jle    801b4f <str2lower+0x44>
  801b28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	01 d0                	add    %edx,%eax
  801b30:	8a 00                	mov    (%eax),%al
  801b32:	3c 5a                	cmp    $0x5a,%al
  801b34:	7f 19                	jg     801b4f <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	01 ca                	add    %ecx,%edx
  801b46:	8a 12                	mov    (%edx),%dl
  801b48:	83 c2 20             	add    $0x20,%edx
  801b4b:	88 10                	mov    %dl,(%eax)
  801b4d:	eb 14                	jmp    801b63 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801b4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	01 c2                	add    %eax,%edx
  801b57:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	01 c8                	add    %ecx,%eax
  801b5f:	8a 00                	mov    (%eax),%al
  801b61:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801b63:	ff 45 fc             	incl   -0x4(%ebp)
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	e8 95 f8 ff ff       	call   801403 <strlen>
  801b6e:	83 c4 04             	add    $0x4,%esp
  801b71:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b74:	7f a4                	jg     801b1a <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801b7e:	a1 04 50 80 00       	mov    0x805004,%eax
  801b83:	85 c0                	test   %eax,%eax
  801b85:	74 0a                	je     801b91 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b87:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b8e:	00 00 00 
	}
}
  801b91:	90                   	nop
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    

00801b94 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b9a:	83 ec 0c             	sub    $0xc,%esp
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	e8 7e 09 00 00       	call   802523 <sys_sbrk>
  801ba5:	83 c4 10             	add    $0x10,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb0:	e8 c6 ff ff ff       	call   801b7b <InitializeUHeap>
	if (size == 0)
  801bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb9:	75 0a                	jne    801bc5 <malloc+0x1b>
		return NULL;
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc0:	e9 3f 01 00 00       	jmp    801d04 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801bc5:	e8 ac 09 00 00       	call   802576 <sys_get_hard_limit>
  801bca:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801bcd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801bd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801bdc:	c1 e8 0c             	shr    $0xc,%eax
  801bdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801be2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801be9:	8b 55 08             	mov    0x8(%ebp),%edx
  801bec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bef:	01 d0                	add    %edx,%eax
  801bf1:	48                   	dec    %eax
  801bf2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801bf5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfd:	f7 75 d8             	divl   -0x28(%ebp)
  801c00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c03:	29 d0                	sub    %edx,%eax
  801c05:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801c08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c0b:	c1 e8 0c             	shr    $0xc,%eax
  801c0e:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801c11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c15:	75 0a                	jne    801c21 <malloc+0x77>
		return NULL;
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1c:	e9 e3 00 00 00       	jmp    801d04 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801c21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c24:	05 00 00 00 80       	add    $0x80000000,%eax
  801c29:	c1 e8 0c             	shr    $0xc,%eax
  801c2c:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c31:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c38:	77 19                	ja     801c53 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	e8 60 0b 00 00       	call   8027a5 <alloc_block_FF>
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801c4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c4e:	e9 b1 00 00 00       	jmp    801d04 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801c53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c59:	eb 4d                	jmp    801ca8 <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801c5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c5e:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c65:	84 c0                	test   %al,%al
  801c67:	75 27                	jne    801c90 <malloc+0xe6>
			{
				counter++;
  801c69:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801c6c:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801c70:	75 14                	jne    801c86 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c75:	05 00 00 08 00       	add    $0x80000,%eax
  801c7a:	c1 e0 0c             	shl    $0xc,%eax
  801c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c89:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801c8c:	75 17                	jne    801ca5 <malloc+0xfb>
				{
					break;
  801c8e:	eb 21                	jmp    801cb1 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c93:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c9a:	3c 01                	cmp    $0x1,%al
  801c9c:	75 07                	jne    801ca5 <malloc+0xfb>
			{
				counter = 0;
  801c9e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801ca5:	ff 45 e8             	incl   -0x18(%ebp)
  801ca8:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801caf:	76 aa                	jbe    801c5b <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb4:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cb7:	75 46                	jne    801cff <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	ff 75 d0             	pushl  -0x30(%ebp)
  801cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc2:	e8 93 08 00 00       	call   80255a <sys_allocate_user_mem>
  801cc7:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cd0:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cdd:	eb 0e                	jmp    801ced <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ce2:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  801ce9:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801cea:	ff 45 e4             	incl   -0x1c(%ebp)
  801ced:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf3:	01 d0                	add    %edx,%eax
  801cf5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cf8:	77 e5                	ja     801cdf <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfd:	eb 05                	jmp    801d04 <malloc+0x15a>
		}
	}

	return NULL;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801d0c:	e8 65 08 00 00       	call   802576 <sys_get_hard_limit>
  801d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801d1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d1e:	0f 84 c1 00 00 00    	je     801de5 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d27:	85 c0                	test   %eax,%eax
  801d29:	79 1b                	jns    801d46 <free+0x40>
  801d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d31:	73 13                	jae    801d46 <free+0x40>
    {
        free_block(virtual_address);
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	e8 34 10 00 00       	call   802d72 <free_block>
  801d3e:	83 c4 10             	add    $0x10,%esp
    	return;
  801d41:	e9 a6 00 00 00       	jmp    801dec <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	05 00 10 00 00       	add    $0x1000,%eax
  801d4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d51:	0f 87 91 00 00 00    	ja     801de8 <free+0xe2>
  801d57:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d5e:	0f 87 84 00 00 00    	ja     801de8 <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d67:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d72:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d78:	05 00 00 00 80       	add    $0x80000000,%eax
  801d7d:	c1 e8 0c             	shr    $0xc,%eax
  801d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d86:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  801d8d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801d90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d94:	74 55                	je     801deb <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d99:	c1 e8 0c             	shr    $0xc,%eax
  801d9c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da2:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801da9:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db3:	eb 0e                	jmp    801dc3 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db8:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  801dbf:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801dc0:	ff 45 f4             	incl   -0xc(%ebp)
  801dc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dc9:	01 c2                	add    %eax,%edx
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	39 c2                	cmp    %eax,%edx
  801dd0:	77 e3                	ja     801db5 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801dd2:	83 ec 08             	sub    $0x8,%esp
  801dd5:	ff 75 e0             	pushl  -0x20(%ebp)
  801dd8:	ff 75 ec             	pushl  -0x14(%ebp)
  801ddb:	e8 5e 07 00 00       	call   80253e <sys_free_user_mem>
  801de0:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801de3:	eb 07                	jmp    801dec <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801de5:	90                   	nop
  801de6:	eb 04                	jmp    801dec <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801de8:	90                   	nop
  801de9:	eb 01                	jmp    801dec <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801deb:	90                   	nop
    else
     {
    	return;
      }

}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 18             	sub    $0x18,%esp
  801df4:	8b 45 10             	mov    0x10(%ebp),%eax
  801df7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dfa:	e8 7c fd ff ff       	call   801b7b <InitializeUHeap>
	if (size == 0)
  801dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e03:	75 07                	jne    801e0c <smalloc+0x1e>
		return NULL;
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0a:	eb 17                	jmp    801e23 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801e0c:	83 ec 04             	sub    $0x4,%esp
  801e0f:	68 f0 40 80 00       	push   $0x8040f0
  801e14:	68 ad 00 00 00       	push   $0xad
  801e19:	68 16 41 80 00       	push   $0x804116
  801e1e:	e8 a1 ec ff ff       	call   800ac4 <_panic>
	return NULL;
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2b:	e8 4b fd ff ff       	call   801b7b <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	68 24 41 80 00       	push   $0x804124
  801e38:	68 ba 00 00 00       	push   $0xba
  801e3d:	68 16 41 80 00       	push   $0x804116
  801e42:	e8 7d ec ff ff       	call   800ac4 <_panic>

00801e47 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4d:	e8 29 fd ff ff       	call   801b7b <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	68 48 41 80 00       	push   $0x804148
  801e5a:	68 d8 00 00 00       	push   $0xd8
  801e5f:	68 16 41 80 00       	push   $0x804116
  801e64:	e8 5b ec ff ff       	call   800ac4 <_panic>

00801e69 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	68 70 41 80 00       	push   $0x804170
  801e77:	68 ea 00 00 00       	push   $0xea
  801e7c:	68 16 41 80 00       	push   $0x804116
  801e81:	e8 3e ec ff ff       	call   800ac4 <_panic>

00801e86 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	68 94 41 80 00       	push   $0x804194
  801e94:	68 f2 00 00 00       	push   $0xf2
  801e99:	68 16 41 80 00       	push   $0x804116
  801e9e:	e8 21 ec ff ff       	call   800ac4 <_panic>

00801ea3 <shrink>:

}
void shrink(uint32 newSize) {
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	68 94 41 80 00       	push   $0x804194
  801eb1:	68 f6 00 00 00       	push   $0xf6
  801eb6:	68 16 41 80 00       	push   $0x804116
  801ebb:	e8 04 ec ff ff       	call   800ac4 <_panic>

00801ec0 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	68 94 41 80 00       	push   $0x804194
  801ece:	68 fa 00 00 00       	push   $0xfa
  801ed3:	68 16 41 80 00       	push   $0x804116
  801ed8:	e8 e7 eb ff ff       	call   800ac4 <_panic>

00801edd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	57                   	push   %edi
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
  801ee3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ef8:	cd 30                	int    $0x30
  801efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	5b                   	pop    %ebx
  801f04:	5e                   	pop    %esi
  801f05:	5f                   	pop    %edi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    

00801f08 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	52                   	push   %edx
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	50                   	push   %eax
  801f24:	6a 00                	push   $0x0
  801f26:	e8 b2 ff ff ff       	call   801edd <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 01                	push   $0x1
  801f40:	e8 98 ff ff ff       	call   801edd <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	52                   	push   %edx
  801f5a:	50                   	push   %eax
  801f5b:	6a 05                	push   $0x5
  801f5d:	e8 7b ff ff ff       	call   801edd <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f6c:	8b 75 18             	mov    0x18(%ebp),%esi
  801f6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	56                   	push   %esi
  801f7c:	53                   	push   %ebx
  801f7d:	51                   	push   %ecx
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 06                	push   $0x6
  801f82:	e8 56 ff ff ff       	call   801edd <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8d:	5b                   	pop    %ebx
  801f8e:	5e                   	pop    %esi
  801f8f:	5d                   	pop    %ebp
  801f90:	c3                   	ret    

00801f91 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	6a 07                	push   $0x7
  801fa4:	e8 34 ff ff ff       	call   801edd <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	6a 08                	push   $0x8
  801fbf:	e8 19 ff ff ff       	call   801edd <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 09                	push   $0x9
  801fd8:	e8 00 ff ff ff       	call   801edd <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 0a                	push   $0xa
  801ff1:	e8 e7 fe ff ff       	call   801edd <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 0b                	push   $0xb
  80200a:	e8 ce fe ff ff       	call   801edd <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 0c                	push   $0xc
  802023:	e8 b5 fe ff ff       	call   801edd <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	ff 75 08             	pushl  0x8(%ebp)
  80203b:	6a 0d                	push   $0xd
  80203d:	e8 9b fe ff ff       	call   801edd <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 0e                	push   $0xe
  802056:	e8 82 fe ff ff       	call   801edd <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	90                   	nop
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 11                	push   $0x11
  802070:	e8 68 fe ff ff       	call   801edd <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	90                   	nop
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 12                	push   $0x12
  80208a:	e8 4e fe ff ff       	call   801edd <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_cputc>:


void
sys_cputc(const char c)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	50                   	push   %eax
  8020ae:	6a 13                	push   $0x13
  8020b0:	e8 28 fe ff ff       	call   801edd <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	90                   	nop
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 14                	push   $0x14
  8020ca:	e8 0e fe ff ff       	call   801edd <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	50                   	push   %eax
  8020e5:	6a 15                	push   $0x15
  8020e7:	e8 f1 fd ff ff       	call   801edd <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 18                	push   $0x18
  802104:	e8 d4 fd ff ff       	call   801edd <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802111:	8b 55 0c             	mov    0xc(%ebp),%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	52                   	push   %edx
  80211e:	50                   	push   %eax
  80211f:	6a 16                	push   $0x16
  802121:	e8 b7 fd ff ff       	call   801edd <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	90                   	nop
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80212f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	52                   	push   %edx
  80213c:	50                   	push   %eax
  80213d:	6a 17                	push   $0x17
  80213f:	e8 99 fd ff ff       	call   801edd <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	90                   	nop
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	8b 45 10             	mov    0x10(%ebp),%eax
  802153:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802156:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802159:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	6a 00                	push   $0x0
  802162:	51                   	push   %ecx
  802163:	52                   	push   %edx
  802164:	ff 75 0c             	pushl  0xc(%ebp)
  802167:	50                   	push   %eax
  802168:	6a 19                	push   $0x19
  80216a:	e8 6e fd ff ff       	call   801edd <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	52                   	push   %edx
  802184:	50                   	push   %eax
  802185:	6a 1a                	push   $0x1a
  802187:	e8 51 fd ff ff       	call   801edd <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802194:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	51                   	push   %ecx
  8021a2:	52                   	push   %edx
  8021a3:	50                   	push   %eax
  8021a4:	6a 1b                	push   $0x1b
  8021a6:	e8 32 fd ff ff       	call   801edd <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	6a 1c                	push   $0x1c
  8021c3:	e8 15 fd ff ff       	call   801edd <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 1d                	push   $0x1d
  8021dc:	e8 fc fc ff ff       	call   801edd <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	ff 75 14             	pushl  0x14(%ebp)
  8021f1:	ff 75 10             	pushl  0x10(%ebp)
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	50                   	push   %eax
  8021f8:	6a 1e                	push   $0x1e
  8021fa:	e8 de fc ff ff       	call   801edd <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	50                   	push   %eax
  802213:	6a 1f                	push   $0x1f
  802215:	e8 c3 fc ff ff       	call   801edd <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	90                   	nop
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	50                   	push   %eax
  80222f:	6a 20                	push   $0x20
  802231:	e8 a7 fc ff ff       	call   801edd <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 02                	push   $0x2
  80224a:	e8 8e fc ff ff       	call   801edd <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 03                	push   $0x3
  802263:	e8 75 fc ff ff       	call   801edd <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 04                	push   $0x4
  80227c:	e8 5c fc ff ff       	call   801edd <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <sys_exit_env>:


void sys_exit_env(void)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 21                	push   $0x21
  802295:	e8 43 fc ff ff       	call   801edd <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	90                   	nop
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a9:	8d 50 04             	lea    0x4(%eax),%edx
  8022ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	52                   	push   %edx
  8022b6:	50                   	push   %eax
  8022b7:	6a 22                	push   $0x22
  8022b9:	e8 1f fc ff ff       	call   801edd <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ca:	89 01                	mov    %eax,(%ecx)
  8022cc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	c9                   	leave  
  8022d3:	c2 04 00             	ret    $0x4

008022d6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	ff 75 10             	pushl  0x10(%ebp)
  8022e0:	ff 75 0c             	pushl  0xc(%ebp)
  8022e3:	ff 75 08             	pushl  0x8(%ebp)
  8022e6:	6a 10                	push   $0x10
  8022e8:	e8 f0 fb ff ff       	call   801edd <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f0:	90                   	nop
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 23                	push   $0x23
  802302:	e8 d6 fb ff ff       	call   801edd <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802318:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	50                   	push   %eax
  802325:	6a 24                	push   $0x24
  802327:	e8 b1 fb ff ff       	call   801edd <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
	return ;
  80232f:	90                   	nop
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <rsttst>:
void rsttst()
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 26                	push   $0x26
  802341:	e8 97 fb ff ff       	call   801edd <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
	return ;
  802349:	90                   	nop
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	8b 45 14             	mov    0x14(%ebp),%eax
  802355:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802358:	8b 55 18             	mov    0x18(%ebp),%edx
  80235b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	ff 75 10             	pushl  0x10(%ebp)
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	ff 75 08             	pushl  0x8(%ebp)
  80236a:	6a 25                	push   $0x25
  80236c:	e8 6c fb ff ff       	call   801edd <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
	return ;
  802374:	90                   	nop
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <chktst>:
void chktst(uint32 n)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	6a 27                	push   $0x27
  802387:	e8 51 fb ff ff       	call   801edd <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
	return ;
  80238f:	90                   	nop
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <inctst>:

void inctst()
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 28                	push   $0x28
  8023a1:	e8 37 fb ff ff       	call   801edd <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <gettst>:
uint32 gettst()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 29                	push   $0x29
  8023bb:	e8 1d fb ff ff       	call   801edd <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 2a                	push   $0x2a
  8023d7:	e8 01 fb ff ff       	call   801edd <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
  8023df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023e2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023e6:	75 07                	jne    8023ef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ed:	eb 05                	jmp    8023f4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 2a                	push   $0x2a
  802408:	e8 d0 fa ff ff       	call   801edd <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
  802410:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802413:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802417:	75 07                	jne    802420 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
  80241e:	eb 05                	jmp    802425 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 2a                	push   $0x2a
  802439:	e8 9f fa ff ff       	call   801edd <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
  802441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802444:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802448:	75 07                	jne    802451 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	eb 05                	jmp    802456 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 2a                	push   $0x2a
  80246a:	e8 6e fa ff ff       	call   801edd <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
  802472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802475:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802479:	75 07                	jne    802482 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80247b:	b8 01 00 00 00       	mov    $0x1,%eax
  802480:	eb 05                	jmp    802487 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	ff 75 08             	pushl  0x8(%ebp)
  802497:	6a 2b                	push   $0x2b
  802499:	e8 3f fa ff ff       	call   801edd <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a1:	90                   	nop
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	6a 00                	push   $0x0
  8024b6:	53                   	push   %ebx
  8024b7:	51                   	push   %ecx
  8024b8:	52                   	push   %edx
  8024b9:	50                   	push   %eax
  8024ba:	6a 2c                	push   $0x2c
  8024bc:	e8 1c fa ff ff       	call   801edd <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
}
  8024c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	52                   	push   %edx
  8024d9:	50                   	push   %eax
  8024da:	6a 2d                	push   $0x2d
  8024dc:	e8 fc f9 ff ff       	call   801edd <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	6a 00                	push   $0x0
  8024f4:	51                   	push   %ecx
  8024f5:	ff 75 10             	pushl  0x10(%ebp)
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	6a 2e                	push   $0x2e
  8024fc:	e8 dc f9 ff ff       	call   801edd <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	ff 75 10             	pushl  0x10(%ebp)
  802510:	ff 75 0c             	pushl  0xc(%ebp)
  802513:	ff 75 08             	pushl  0x8(%ebp)
  802516:	6a 0f                	push   $0xf
  802518:	e8 c0 f9 ff ff       	call   801edd <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
	return ;
  802520:	90                   	nop
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	50                   	push   %eax
  802532:	6a 2f                	push   $0x2f
  802534:	e8 a4 f9 ff ff       	call   801edd <syscall>
  802539:	83 c4 18             	add    $0x18,%esp

}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	6a 30                	push   $0x30
  80254f:	e8 89 f9 ff ff       	call   801edd <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
	return;
  802557:	90                   	nop
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	ff 75 08             	pushl  0x8(%ebp)
  802569:	6a 31                	push   $0x31
  80256b:	e8 6d f9 ff ff       	call   801edd <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
	return;
  802573:	90                   	nop
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 32                	push   $0x32
  802585:	e8 53 f9 ff ff       	call   801edd <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	50                   	push   %eax
  80259e:	6a 33                	push   $0x33
  8025a0:	e8 38 f9 ff ff       	call   801edd <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	90                   	nop
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	83 e8 10             	sub    $0x10,%eax
  8025b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  8025ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	83 e8 10             	sub    $0x10,%eax
  8025cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  8025d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d3:	8a 40 04             	mov    0x4(%eax),%al
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e8:	83 f8 02             	cmp    $0x2,%eax
  8025eb:	74 2b                	je     802618 <alloc_block+0x40>
  8025ed:	83 f8 02             	cmp    $0x2,%eax
  8025f0:	7f 07                	jg     8025f9 <alloc_block+0x21>
  8025f2:	83 f8 01             	cmp    $0x1,%eax
  8025f5:	74 0e                	je     802605 <alloc_block+0x2d>
  8025f7:	eb 58                	jmp    802651 <alloc_block+0x79>
  8025f9:	83 f8 03             	cmp    $0x3,%eax
  8025fc:	74 2d                	je     80262b <alloc_block+0x53>
  8025fe:	83 f8 04             	cmp    $0x4,%eax
  802601:	74 3b                	je     80263e <alloc_block+0x66>
  802603:	eb 4c                	jmp    802651 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	ff 75 08             	pushl  0x8(%ebp)
  80260b:	e8 95 01 00 00       	call   8027a5 <alloc_block_FF>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802616:	eb 4a                	jmp    802662 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802618:	83 ec 0c             	sub    $0xc,%esp
  80261b:	ff 75 08             	pushl  0x8(%ebp)
  80261e:	e8 32 07 00 00       	call   802d55 <alloc_block_NF>
  802623:	83 c4 10             	add    $0x10,%esp
  802626:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802629:	eb 37                	jmp    802662 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80262b:	83 ec 0c             	sub    $0xc,%esp
  80262e:	ff 75 08             	pushl  0x8(%ebp)
  802631:	e8 a3 04 00 00       	call   802ad9 <alloc_block_BF>
  802636:	83 c4 10             	add    $0x10,%esp
  802639:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80263c:	eb 24                	jmp    802662 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80263e:	83 ec 0c             	sub    $0xc,%esp
  802641:	ff 75 08             	pushl  0x8(%ebp)
  802644:	e8 ef 06 00 00       	call   802d38 <alloc_block_WF>
  802649:	83 c4 10             	add    $0x10,%esp
  80264c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264f:	eb 11                	jmp    802662 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	68 a4 41 80 00       	push   $0x8041a4
  802659:	e8 23 e7 ff ff       	call   800d81 <cprintf>
  80265e:	83 c4 10             	add    $0x10,%esp
		break;
  802661:	90                   	nop
	}
	return va;
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  80266d:	83 ec 0c             	sub    $0xc,%esp
  802670:	68 c4 41 80 00       	push   $0x8041c4
  802675:	e8 07 e7 ff ff       	call   800d81 <cprintf>
  80267a:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  80267d:	83 ec 0c             	sub    $0xc,%esp
  802680:	68 ef 41 80 00       	push   $0x8041ef
  802685:	e8 f7 e6 ff ff       	call   800d81 <cprintf>
  80268a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802693:	eb 26                	jmp    8026bb <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8a 40 04             	mov    0x4(%eax),%al
  80269b:	0f b6 d0             	movzbl %al,%edx
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	52                   	push   %edx
  8026a7:	50                   	push   %eax
  8026a8:	68 07 42 80 00       	push   $0x804207
  8026ad:	e8 cf e6 ff ff       	call   800d81 <cprintf>
  8026b2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bf:	74 08                	je     8026c9 <print_blocks_list+0x62>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 40 08             	mov    0x8(%eax),%eax
  8026c7:	eb 05                	jmp    8026ce <print_blocks_list+0x67>
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	89 45 10             	mov    %eax,0x10(%ebp)
  8026d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	75 bd                	jne    802695 <print_blocks_list+0x2e>
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	75 b7                	jne    802695 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  8026de:	83 ec 0c             	sub    $0xc,%esp
  8026e1:	68 c4 41 80 00       	push   $0x8041c4
  8026e6:	e8 96 e6 ff ff       	call   800d81 <cprintf>
  8026eb:	83 c4 10             	add    $0x10,%esp

}
  8026ee:	90                   	nop
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  8026f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026fb:	0f 84 a1 00 00 00    	je     8027a2 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802701:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802708:	00 00 00 
	LIST_INIT(&list);
  80270b:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802712:	00 00 00 
  802715:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  80271c:	00 00 00 
  80271f:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802726:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273c:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  80273e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802742:	75 14                	jne    802758 <initialize_dynamic_allocator+0x67>
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	68 20 42 80 00       	push   $0x804220
  80274c:	6a 64                	push   $0x64
  80274e:	68 43 42 80 00       	push   $0x804243
  802753:	e8 6c e3 ff ff       	call   800ac4 <_panic>
  802758:	8b 15 44 51 90 00    	mov    0x905144,%edx
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	89 50 0c             	mov    %edx,0xc(%eax)
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 0c             	mov    0xc(%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 0d                	je     80277b <initialize_dynamic_allocator+0x8a>
  80276e:	a1 44 51 90 00       	mov    0x905144,%eax
  802773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802776:	89 50 08             	mov    %edx,0x8(%eax)
  802779:	eb 08                	jmp    802783 <initialize_dynamic_allocator+0x92>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	a3 40 51 90 00       	mov    %eax,0x905140
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	a3 44 51 90 00       	mov    %eax,0x905144
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802795:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80279a:	40                   	inc    %eax
  80279b:	a3 4c 51 90 00       	mov    %eax,0x90514c
  8027a0:	eb 01                	jmp    8027a3 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8027a2:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8027ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027af:	75 0a                	jne    8027bb <alloc_block_FF+0x16>
	{
		return NULL;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b6:	e9 1c 03 00 00       	jmp    802ad7 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8027bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	75 40                	jne    802804 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	83 c0 10             	add    $0x10,%eax
  8027ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	83 ec 0c             	sub    $0xc,%esp
  8027d3:	50                   	push   %eax
  8027d4:	e8 bb f3 ff ff       	call   801b94 <sbrk>
  8027d9:	83 c4 10             	add    $0x10,%esp
  8027dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	6a 00                	push   $0x0
  8027e4:	e8 ab f3 ff ff       	call   801b94 <sbrk>
  8027e9:	83 c4 10             	add    $0x10,%esp
  8027ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8027f5:	83 ec 08             	sub    $0x8,%esp
  8027f8:	50                   	push   %eax
  8027f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8027fc:	e8 f0 fe ff ff       	call   8026f1 <initialize_dynamic_allocator>
  802801:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802804:	a1 40 51 90 00       	mov    0x905140,%eax
  802809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280c:	e9 1e 01 00 00       	jmp    80292f <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	8d 50 10             	lea    0x10(%eax),%edx
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	39 c2                	cmp    %eax,%edx
  80281e:	75 1c                	jne    80283c <alloc_block_FF+0x97>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8a 40 04             	mov    0x4(%eax),%al
  802826:	3c 01                	cmp    $0x1,%al
  802828:	75 12                	jne    80283c <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	83 c0 10             	add    $0x10,%eax
  802837:	e9 9b 02 00 00       	jmp    802ad7 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	8d 50 10             	lea    0x10(%eax),%edx
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	39 c2                	cmp    %eax,%edx
  802849:	0f 83 d8 00 00 00    	jae    802927 <alloc_block_FF+0x182>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8a 40 04             	mov    0x4(%eax),%al
  802855:	3c 01                	cmp    $0x1,%al
  802857:	0f 85 ca 00 00 00    	jne    802927 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	2b 45 08             	sub    0x8(%ebp),%eax
  802865:	83 e8 10             	sub    $0x10,%eax
  802868:	83 f8 0f             	cmp    $0xf,%eax
  80286b:	0f 86 a4 00 00 00    	jbe    802915 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	01 d0                	add    %edx,%eax
  802879:	83 c0 10             	add    $0x10,%eax
  80287c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	2b 45 08             	sub    0x8(%ebp),%eax
  802887:	8d 50 f0             	lea    -0x10(%eax),%edx
  80288a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80288d:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  80288f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802892:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289a:	74 06                	je     8028a2 <alloc_block_FF+0xfd>
  80289c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8028a0:	75 17                	jne    8028b9 <alloc_block_FF+0x114>
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	68 5c 42 80 00       	push   $0x80425c
  8028aa:	68 8f 00 00 00       	push   $0x8f
  8028af:	68 43 42 80 00       	push   $0x804243
  8028b4:	e8 0b e2 ff ff       	call   800ac4 <_panic>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 50 08             	mov    0x8(%eax),%edx
  8028bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c2:	89 50 08             	mov    %edx,0x8(%eax)
  8028c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c8:	8b 40 08             	mov    0x8(%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	74 0c                	je     8028db <alloc_block_FF+0x136>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 08             	mov    0x8(%eax),%eax
  8028d5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028d8:	89 50 0c             	mov    %edx,0xc(%eax)
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028e1:	89 50 08             	mov    %edx,0x8(%eax)
  8028e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ea:	89 50 0c             	mov    %edx,0xc(%eax)
  8028ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028f0:	8b 40 08             	mov    0x8(%eax),%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	75 08                	jne    8028ff <alloc_block_FF+0x15a>
  8028f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028fa:	a3 44 51 90 00       	mov    %eax,0x905144
  8028ff:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802904:	40                   	inc    %eax
  802905:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	8d 50 10             	lea    0x10(%eax),%edx
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	83 c0 10             	add    $0x10,%eax
  802922:	e9 b0 01 00 00       	jmp    802ad7 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802927:	a1 48 51 90 00       	mov    0x905148,%eax
  80292c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	74 08                	je     80293d <alloc_block_FF+0x198>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	eb 05                	jmp    802942 <alloc_block_FF+0x19d>
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	a3 48 51 90 00       	mov    %eax,0x905148
  802947:	a1 48 51 90 00       	mov    0x905148,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 bd fe ff ff    	jne    802811 <alloc_block_FF+0x6c>
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	0f 85 b3 fe ff ff    	jne    802811 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	83 c0 10             	add    $0x10,%eax
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	50                   	push   %eax
  802968:	e8 27 f2 ff ff       	call   801b94 <sbrk>
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	6a 00                	push   $0x0
  802978:	e8 17 f2 ff ff       	call   801b94 <sbrk>
  80297d:	83 c4 10             	add    $0x10,%esp
  802980:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802983:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802989:	29 c2                	sub    %eax,%edx
  80298b:	89 d0                	mov    %edx,%eax
  80298d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802990:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802994:	0f 84 38 01 00 00    	je     802ad2 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  80299a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8029a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029a4:	75 17                	jne    8029bd <alloc_block_FF+0x218>
  8029a6:	83 ec 04             	sub    $0x4,%esp
  8029a9:	68 20 42 80 00       	push   $0x804220
  8029ae:	68 9f 00 00 00       	push   $0x9f
  8029b3:	68 43 42 80 00       	push   $0x804243
  8029b8:	e8 07 e1 ff ff       	call   800ac4 <_panic>
  8029bd:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8029c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8029c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 0d                	je     8029e0 <alloc_block_FF+0x23b>
  8029d3:	a1 44 51 90 00       	mov    0x905144,%eax
  8029d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029db:	89 50 08             	mov    %edx,0x8(%eax)
  8029de:	eb 08                	jmp    8029e8 <alloc_block_FF+0x243>
  8029e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e3:	a3 40 51 90 00       	mov    %eax,0x905140
  8029e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029eb:	a3 44 51 90 00       	mov    %eax,0x905144
  8029f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029fa:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8029ff:	40                   	inc    %eax
  802a00:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	8d 50 10             	lea    0x10(%eax),%edx
  802a0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a0e:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802a10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a13:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802a17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1d:	83 f8 10             	cmp    $0x10,%eax
  802a20:	0f 84 a4 00 00 00    	je     802aca <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a29:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2c:	83 e8 10             	sub    $0x10,%eax
  802a2f:	83 f8 0f             	cmp    $0xf,%eax
  802a32:	0f 86 8a 00 00 00    	jbe    802ac2 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802a38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	01 d0                	add    %edx,%eax
  802a40:	83 c0 10             	add    $0x10,%eax
  802a43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802a46:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a4a:	75 17                	jne    802a63 <alloc_block_FF+0x2be>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 20 42 80 00       	push   $0x804220
  802a54:	68 a7 00 00 00       	push   $0xa7
  802a59:	68 43 42 80 00       	push   $0x804243
  802a5e:	e8 61 e0 ff ff       	call   800ac4 <_panic>
  802a63:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802a69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a6c:	89 50 0c             	mov    %edx,0xc(%eax)
  802a6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a72:	8b 40 0c             	mov    0xc(%eax),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	74 0d                	je     802a86 <alloc_block_FF+0x2e1>
  802a79:	a1 44 51 90 00       	mov    0x905144,%eax
  802a7e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a81:	89 50 08             	mov    %edx,0x8(%eax)
  802a84:	eb 08                	jmp    802a8e <alloc_block_FF+0x2e9>
  802a86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a89:	a3 40 51 90 00       	mov    %eax,0x905140
  802a8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a91:	a3 44 51 90 00       	mov    %eax,0x905144
  802a96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802aa0:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802aa5:	40                   	inc    %eax
  802aa6:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aae:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab1:	8d 50 f0             	lea    -0x10(%eax),%edx
  802ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ab7:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802abc:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802ac0:	eb 08                	jmp    802aca <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802ac2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ac8:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802aca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802acd:	83 c0 10             	add    $0x10,%eax
  802ad0:	eb 05                	jmp    802ad7 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802adf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aea:	75 0a                	jne    802af6 <alloc_block_BF+0x1d>
	{
		return NULL;
  802aec:	b8 00 00 00 00       	mov    $0x0,%eax
  802af1:	e9 40 02 00 00       	jmp    802d36 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802af6:	a1 40 51 90 00       	mov    0x905140,%eax
  802afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afe:	eb 66                	jmp    802b66 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8a 40 04             	mov    0x4(%eax),%al
  802b06:	3c 01                	cmp    $0x1,%al
  802b08:	75 21                	jne    802b2b <alloc_block_BF+0x52>
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8d 50 10             	lea    0x10(%eax),%edx
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	39 c2                	cmp    %eax,%edx
  802b17:	75 12                	jne    802b2b <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	83 c0 10             	add    $0x10,%eax
  802b26:	e9 0b 02 00 00       	jmp    802d36 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8a 40 04             	mov    0x4(%eax),%al
  802b31:	3c 01                	cmp    $0x1,%al
  802b33:	75 29                	jne    802b5e <alloc_block_BF+0x85>
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8d 50 10             	lea    0x10(%eax),%edx
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	39 c2                	cmp    %eax,%edx
  802b42:	77 1a                	ja     802b5e <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b48:	74 0e                	je     802b58 <alloc_block_BF+0x7f>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 10                	mov    (%eax),%edx
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	39 c2                	cmp    %eax,%edx
  802b56:	73 06                	jae    802b5e <alloc_block_BF+0x85>
			{
				BF = iterator;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802b5e:	a1 48 51 90 00       	mov    0x905148,%eax
  802b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6a:	74 08                	je     802b74 <alloc_block_BF+0x9b>
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 08             	mov    0x8(%eax),%eax
  802b72:	eb 05                	jmp    802b79 <alloc_block_BF+0xa0>
  802b74:	b8 00 00 00 00       	mov    $0x0,%eax
  802b79:	a3 48 51 90 00       	mov    %eax,0x905148
  802b7e:	a1 48 51 90 00       	mov    0x905148,%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	0f 85 75 ff ff ff    	jne    802b00 <alloc_block_BF+0x27>
  802b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8f:	0f 85 6b ff ff ff    	jne    802b00 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802b95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b99:	0f 84 f8 00 00 00    	je     802c97 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8d 50 10             	lea    0x10(%eax),%edx
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	39 c2                	cmp    %eax,%edx
  802bac:	0f 87 e5 00 00 00    	ja     802c97 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bba:	83 e8 10             	sub    $0x10,%eax
  802bbd:	83 f8 0f             	cmp    $0xf,%eax
  802bc0:	0f 86 bf 00 00 00    	jbe    802c85 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802bc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	01 d0                	add    %edx,%eax
  802bce:	83 c0 10             	add    $0x10,%eax
  802bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	2b 45 08             	sub    0x8(%ebp),%eax
  802be5:	8d 50 f0             	lea    -0x10(%eax),%edx
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf8:	74 06                	je     802c00 <alloc_block_BF+0x127>
  802bfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bfe:	75 17                	jne    802c17 <alloc_block_BF+0x13e>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 5c 42 80 00       	push   $0x80425c
  802c08:	68 e3 00 00 00       	push   $0xe3
  802c0d:	68 43 42 80 00       	push   $0x804243
  802c12:	e8 ad de ff ff       	call   800ac4 <_panic>
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	89 50 08             	mov    %edx,0x8(%eax)
  802c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 0c                	je     802c39 <alloc_block_BF+0x160>
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 40 08             	mov    0x8(%eax),%eax
  802c33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c36:	89 50 0c             	mov    %edx,0xc(%eax)
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3f:	89 50 08             	mov    %edx,0x8(%eax)
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c48:	89 50 0c             	mov    %edx,0xc(%eax)
  802c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4e:	8b 40 08             	mov    0x8(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	75 08                	jne    802c5d <alloc_block_BF+0x184>
  802c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c58:	a3 44 51 90 00       	mov    %eax,0x905144
  802c5d:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802c62:	40                   	inc    %eax
  802c63:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8d 50 10             	lea    0x10(%eax),%edx
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	83 c0 10             	add    $0x10,%eax
  802c80:	e9 b1 00 00 00       	jmp    802d36 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	83 c0 10             	add    $0x10,%eax
  802c92:	e9 9f 00 00 00       	jmp    802d36 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	83 c0 10             	add    $0x10,%eax
  802c9d:	83 ec 0c             	sub    $0xc,%esp
  802ca0:	50                   	push   %eax
  802ca1:	e8 ee ee ff ff       	call   801b94 <sbrk>
  802ca6:	83 c4 10             	add    $0x10,%esp
  802ca9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802cac:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802cb0:	74 7f                	je     802d31 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802cb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cb6:	75 17                	jne    802ccf <alloc_block_BF+0x1f6>
  802cb8:	83 ec 04             	sub    $0x4,%esp
  802cbb:	68 20 42 80 00       	push   $0x804220
  802cc0:	68 f6 00 00 00       	push   $0xf6
  802cc5:	68 43 42 80 00       	push   $0x804243
  802cca:	e8 f5 dd ff ff       	call   800ac4 <_panic>
  802ccf:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd8:	89 50 0c             	mov    %edx,0xc(%eax)
  802cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cde:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	74 0d                	je     802cf2 <alloc_block_BF+0x219>
  802ce5:	a1 44 51 90 00       	mov    0x905144,%eax
  802cea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ced:	89 50 08             	mov    %edx,0x8(%eax)
  802cf0:	eb 08                	jmp    802cfa <alloc_block_BF+0x221>
  802cf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf5:	a3 40 51 90 00       	mov    %eax,0x905140
  802cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfd:	a3 44 51 90 00       	mov    %eax,0x905144
  802d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d0c:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d11:	40                   	inc    %eax
  802d12:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8d 50 10             	lea    0x10(%eax),%edx
  802d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d20:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d25:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2c:	83 c0 10             	add    $0x10,%eax
  802d2f:	eb 05                	jmp    802d36 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802d31:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802d36:	c9                   	leave  
  802d37:	c3                   	ret    

00802d38 <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802d38:	55                   	push   %ebp
  802d39:	89 e5                	mov    %esp,%ebp
  802d3b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 90 42 80 00       	push   $0x804290
  802d46:	68 07 01 00 00       	push   $0x107
  802d4b:	68 43 42 80 00       	push   $0x804243
  802d50:	e8 6f dd ff ff       	call   800ac4 <_panic>

00802d55 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
  802d58:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 b8 42 80 00       	push   $0x8042b8
  802d63:	68 0f 01 00 00       	push   $0x10f
  802d68:	68 43 42 80 00       	push   $0x804243
  802d6d:	e8 52 dd ff ff       	call   800ac4 <_panic>

00802d72 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d72:	55                   	push   %ebp
  802d73:	89 e5                	mov    %esp,%ebp
  802d75:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802d78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7c:	0f 84 ee 05 00 00    	je     803370 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	83 e8 10             	sub    $0x10,%eax
  802d88:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802d8b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802d8f:	a1 40 51 90 00       	mov    0x905140,%eax
  802d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d97:	eb 16                	jmp    802daf <free_block+0x3d>
	{
		if (block_pointer == it)
  802d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d9f:	75 06                	jne    802da7 <free_block+0x35>
		{
			flagx = 1;
  802da1:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802da5:	eb 2f                	jmp    802dd6 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802da7:	a1 48 51 90 00       	mov    0x905148,%eax
  802dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802daf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db3:	74 08                	je     802dbd <free_block+0x4b>
  802db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db8:	8b 40 08             	mov    0x8(%eax),%eax
  802dbb:	eb 05                	jmp    802dc2 <free_block+0x50>
  802dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc2:	a3 48 51 90 00       	mov    %eax,0x905148
  802dc7:	a1 48 51 90 00       	mov    0x905148,%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	75 c9                	jne    802d99 <free_block+0x27>
  802dd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd4:	75 c3                	jne    802d99 <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802dd6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802dda:	0f 84 93 05 00 00    	je     803373 <free_block+0x601>
		return;
	if (va == NULL)
  802de0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de4:	0f 84 8c 05 00 00    	je     803376 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 40 0c             	mov    0xc(%eax),%eax
  802df0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	8b 40 08             	mov    0x8(%eax),%eax
  802df9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802dfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e00:	75 12                	jne    802e14 <free_block+0xa2>
  802e02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e06:	75 0c                	jne    802e14 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e0f:	e9 63 05 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802e14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e18:	0f 85 ca 00 00 00    	jne    802ee8 <free_block+0x176>
  802e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e21:	8a 40 04             	mov    0x4(%eax),%al
  802e24:	3c 01                	cmp    $0x1,%al
  802e26:	0f 85 bc 00 00 00    	jne    802ee8 <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e36:	8b 10                	mov    (%eax),%edx
  802e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	01 c2                	add    %eax,%edx
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e50:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802e54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e58:	75 17                	jne    802e71 <free_block+0xff>
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 de 42 80 00       	push   $0x8042de
  802e62:	68 3c 01 00 00       	push   $0x13c
  802e67:	68 43 42 80 00       	push   $0x804243
  802e6c:	e8 53 dc ff ff       	call   800ac4 <_panic>
  802e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 11                	je     802e8c <free_block+0x11a>
  802e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7e:	8b 40 08             	mov    0x8(%eax),%eax
  802e81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e84:	8b 52 0c             	mov    0xc(%edx),%edx
  802e87:	89 50 0c             	mov    %edx,0xc(%eax)
  802e8a:	eb 0b                	jmp    802e97 <free_block+0x125>
  802e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e92:	a3 44 51 90 00       	mov    %eax,0x905144
  802e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	74 11                	je     802eb2 <free_block+0x140>
  802ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eaa:	8b 52 08             	mov    0x8(%edx),%edx
  802ead:	89 50 08             	mov    %edx,0x8(%eax)
  802eb0:	eb 0b                	jmp    802ebd <free_block+0x14b>
  802eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	a3 40 51 90 00       	mov    %eax,0x905140
  802ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ec7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ed1:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ed6:	48                   	dec    %eax
  802ed7:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802edc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802ee3:	e9 8f 04 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802ee8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eec:	75 16                	jne    802f04 <free_block+0x192>
  802eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef1:	8a 40 04             	mov    0x4(%eax),%al
  802ef4:	84 c0                	test   %al,%al
  802ef6:	75 0c                	jne    802f04 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802eff:	e9 73 04 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802f04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f08:	0f 85 c3 00 00 00    	jne    802fd1 <free_block+0x25f>
  802f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f11:	8a 40 04             	mov    0x4(%eax),%al
  802f14:	3c 01                	cmp    $0x1,%al
  802f16:	0f 85 b5 00 00 00    	jne    802fd1 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	8b 10                	mov    (%eax),%edx
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	01 c2                	add    %eax,%edx
  802f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2b:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802f3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f41:	75 17                	jne    802f5a <free_block+0x1e8>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 de 42 80 00       	push   $0x8042de
  802f4b:	68 49 01 00 00       	push   $0x149
  802f50:	68 43 42 80 00       	push   $0x804243
  802f55:	e8 6a db ff ff       	call   800ac4 <_panic>
  802f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5d:	8b 40 08             	mov    0x8(%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 11                	je     802f75 <free_block+0x203>
  802f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6d:	8b 52 0c             	mov    0xc(%edx),%edx
  802f70:	89 50 0c             	mov    %edx,0xc(%eax)
  802f73:	eb 0b                	jmp    802f80 <free_block+0x20e>
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7b:	a3 44 51 90 00       	mov    %eax,0x905144
  802f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f83:	8b 40 0c             	mov    0xc(%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 11                	je     802f9b <free_block+0x229>
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f93:	8b 52 08             	mov    0x8(%edx),%edx
  802f96:	89 50 08             	mov    %edx,0x8(%eax)
  802f99:	eb 0b                	jmp    802fa6 <free_block+0x234>
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	8b 40 08             	mov    0x8(%eax),%eax
  802fa1:	a3 40 51 90 00       	mov    %eax,0x905140
  802fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fba:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802fbf:	48                   	dec    %eax
  802fc0:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802fc5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802fcc:	e9 a6 03 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802fd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fd5:	75 16                	jne    802fed <free_block+0x27b>
  802fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fda:	8a 40 04             	mov    0x4(%eax),%al
  802fdd:	84 c0                	test   %al,%al
  802fdf:	75 0c                	jne    802fed <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802fe8:	e9 8a 03 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802fed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ff1:	0f 84 81 01 00 00    	je     803178 <free_block+0x406>
  802ff7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffb:	0f 84 77 01 00 00    	je     803178 <free_block+0x406>
  803001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803004:	8a 40 04             	mov    0x4(%eax),%al
  803007:	3c 01                	cmp    $0x1,%al
  803009:	0f 85 69 01 00 00    	jne    803178 <free_block+0x406>
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	8a 40 04             	mov    0x4(%eax),%al
  803015:	3c 01                	cmp    $0x1,%al
  803017:	0f 85 5b 01 00 00    	jne    803178 <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  80301d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803020:	8b 10                	mov    (%eax),%edx
  803022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803025:	8b 08                	mov    (%eax),%ecx
  803027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	01 c8                	add    %ecx,%eax
  80302e:	01 c2                	add    %eax,%edx
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  80303e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803041:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  803045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803048:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  80304e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803051:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803055:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803059:	75 17                	jne    803072 <free_block+0x300>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 de 42 80 00       	push   $0x8042de
  803063:	68 59 01 00 00       	push   $0x159
  803068:	68 43 42 80 00       	push   $0x804243
  80306d:	e8 52 da ff ff       	call   800ac4 <_panic>
  803072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803075:	8b 40 08             	mov    0x8(%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 11                	je     80308d <free_block+0x31b>
  80307c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307f:	8b 40 08             	mov    0x8(%eax),%eax
  803082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803085:	8b 52 0c             	mov    0xc(%edx),%edx
  803088:	89 50 0c             	mov    %edx,0xc(%eax)
  80308b:	eb 0b                	jmp    803098 <free_block+0x326>
  80308d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803090:	8b 40 0c             	mov    0xc(%eax),%eax
  803093:	a3 44 51 90 00       	mov    %eax,0x905144
  803098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309b:	8b 40 0c             	mov    0xc(%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 11                	je     8030b3 <free_block+0x341>
  8030a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ab:	8b 52 08             	mov    0x8(%edx),%edx
  8030ae:	89 50 08             	mov    %edx,0x8(%eax)
  8030b1:	eb 0b                	jmp    8030be <free_block+0x34c>
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	a3 40 51 90 00       	mov    %eax,0x905140
  8030be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030d2:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8030d7:	48                   	dec    %eax
  8030d8:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  8030dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030e1:	75 17                	jne    8030fa <free_block+0x388>
  8030e3:	83 ec 04             	sub    $0x4,%esp
  8030e6:	68 de 42 80 00       	push   $0x8042de
  8030eb:	68 5a 01 00 00       	push   $0x15a
  8030f0:	68 43 42 80 00       	push   $0x804243
  8030f5:	e8 ca d9 ff ff       	call   800ac4 <_panic>
  8030fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fd:	8b 40 08             	mov    0x8(%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 11                	je     803115 <free_block+0x3a3>
  803104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803107:	8b 40 08             	mov    0x8(%eax),%eax
  80310a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80310d:	8b 52 0c             	mov    0xc(%edx),%edx
  803110:	89 50 0c             	mov    %edx,0xc(%eax)
  803113:	eb 0b                	jmp    803120 <free_block+0x3ae>
  803115:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803118:	8b 40 0c             	mov    0xc(%eax),%eax
  80311b:	a3 44 51 90 00       	mov    %eax,0x905144
  803120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803123:	8b 40 0c             	mov    0xc(%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 11                	je     80313b <free_block+0x3c9>
  80312a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803133:	8b 52 08             	mov    0x8(%edx),%edx
  803136:	89 50 08             	mov    %edx,0x8(%eax)
  803139:	eb 0b                	jmp    803146 <free_block+0x3d4>
  80313b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313e:	8b 40 08             	mov    0x8(%eax),%eax
  803141:	a3 40 51 90 00       	mov    %eax,0x905140
  803146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803149:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803153:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80315a:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80315f:	48                   	dec    %eax
  803160:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803165:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  80316c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803173:	e9 ff 01 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  803178:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317c:	0f 84 db 00 00 00    	je     80325d <free_block+0x4eb>
  803182:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803186:	0f 84 d1 00 00 00    	je     80325d <free_block+0x4eb>
  80318c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318f:	8a 40 04             	mov    0x4(%eax),%al
  803192:	84 c0                	test   %al,%al
  803194:	0f 85 c3 00 00 00    	jne    80325d <free_block+0x4eb>
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	8a 40 04             	mov    0x4(%eax),%al
  8031a0:	3c 01                	cmp    $0x1,%al
  8031a2:	0f 85 b5 00 00 00    	jne    80325d <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	8b 10                	mov    (%eax),%edx
  8031ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	01 c2                	add    %eax,%edx
  8031b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b7:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8031b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8031c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8031c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031cd:	75 17                	jne    8031e6 <free_block+0x474>
  8031cf:	83 ec 04             	sub    $0x4,%esp
  8031d2:	68 de 42 80 00       	push   $0x8042de
  8031d7:	68 64 01 00 00       	push   $0x164
  8031dc:	68 43 42 80 00       	push   $0x804243
  8031e1:	e8 de d8 ff ff       	call   800ac4 <_panic>
  8031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 11                	je     803201 <free_block+0x48f>
  8031f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f3:	8b 40 08             	mov    0x8(%eax),%eax
  8031f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8031fc:	89 50 0c             	mov    %edx,0xc(%eax)
  8031ff:	eb 0b                	jmp    80320c <free_block+0x49a>
  803201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	a3 44 51 90 00       	mov    %eax,0x905144
  80320c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320f:	8b 40 0c             	mov    0xc(%eax),%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	74 11                	je     803227 <free_block+0x4b5>
  803216:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803219:	8b 40 0c             	mov    0xc(%eax),%eax
  80321c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80321f:	8b 52 08             	mov    0x8(%edx),%edx
  803222:	89 50 08             	mov    %edx,0x8(%eax)
  803225:	eb 0b                	jmp    803232 <free_block+0x4c0>
  803227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322a:	8b 40 08             	mov    0x8(%eax),%eax
  80322d:	a3 40 51 90 00       	mov    %eax,0x905140
  803232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803235:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803246:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80324b:	48                   	dec    %eax
  80324c:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803251:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803258:	e9 1a 01 00 00       	jmp    803377 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  80325d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803261:	0f 84 df 00 00 00    	je     803346 <free_block+0x5d4>
  803267:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326b:	0f 84 d5 00 00 00    	je     803346 <free_block+0x5d4>
  803271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803274:	8a 40 04             	mov    0x4(%eax),%al
  803277:	3c 01                	cmp    $0x1,%al
  803279:	0f 85 c7 00 00 00    	jne    803346 <free_block+0x5d4>
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	8a 40 04             	mov    0x4(%eax),%al
  803285:	84 c0                	test   %al,%al
  803287:	0f 85 b9 00 00 00    	jne    803346 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  80328d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803290:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803297:	8b 10                	mov    (%eax),%edx
  803299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	01 c2                	add    %eax,%edx
  8032a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a3:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8032a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8032ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8032b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032b9:	75 17                	jne    8032d2 <free_block+0x560>
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	68 de 42 80 00       	push   $0x8042de
  8032c3:	68 6e 01 00 00       	push   $0x16e
  8032c8:	68 43 42 80 00       	push   $0x804243
  8032cd:	e8 f2 d7 ff ff       	call   800ac4 <_panic>
  8032d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d5:	8b 40 08             	mov    0x8(%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 11                	je     8032ed <free_block+0x57b>
  8032dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032df:	8b 40 08             	mov    0x8(%eax),%eax
  8032e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8032e8:	89 50 0c             	mov    %edx,0xc(%eax)
  8032eb:	eb 0b                	jmp    8032f8 <free_block+0x586>
  8032ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f3:	a3 44 51 90 00       	mov    %eax,0x905144
  8032f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 11                	je     803313 <free_block+0x5a1>
  803302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803305:	8b 40 0c             	mov    0xc(%eax),%eax
  803308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80330b:	8b 52 08             	mov    0x8(%edx),%edx
  80330e:	89 50 08             	mov    %edx,0x8(%eax)
  803311:	eb 0b                	jmp    80331e <free_block+0x5ac>
  803313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803316:	8b 40 08             	mov    0x8(%eax),%eax
  803319:	a3 40 51 90 00       	mov    %eax,0x905140
  80331e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803321:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803332:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803337:	48                   	dec    %eax
  803338:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80333d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803344:	eb 31                	jmp    803377 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803346:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80334a:	74 2b                	je     803377 <free_block+0x605>
  80334c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803350:	74 25                	je     803377 <free_block+0x605>
  803352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803355:	8a 40 04             	mov    0x4(%eax),%al
  803358:	84 c0                	test   %al,%al
  80335a:	75 1b                	jne    803377 <free_block+0x605>
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	8a 40 04             	mov    0x4(%eax),%al
  803362:	84 c0                	test   %al,%al
  803364:	75 11                	jne    803377 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803369:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80336d:	90                   	nop
  80336e:	eb 07                	jmp    803377 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803370:	90                   	nop
  803371:	eb 04                	jmp    803377 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803373:	90                   	nop
  803374:	eb 01                	jmp    803377 <free_block+0x605>
	if (va == NULL)
		return;
  803376:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803377:	c9                   	leave  
  803378:	c3                   	ret    

00803379 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  803379:	55                   	push   %ebp
  80337a:	89 e5                	mov    %esp,%ebp
  80337c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  80337f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803383:	75 19                	jne    80339e <realloc_block_FF+0x25>
  803385:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803389:	74 13                	je     80339e <realloc_block_FF+0x25>
	{
		return alloc_block_FF(new_size);
  80338b:	83 ec 0c             	sub    $0xc,%esp
  80338e:	ff 75 0c             	pushl  0xc(%ebp)
  803391:	e8 0f f4 ff ff       	call   8027a5 <alloc_block_FF>
  803396:	83 c4 10             	add    $0x10,%esp
  803399:	e9 ea 03 00 00       	jmp    803788 <realloc_block_FF+0x40f>
	}

	if (new_size == 0)
  80339e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033a2:	75 3b                	jne    8033df <realloc_block_FF+0x66>
	{
		//(NULL,0)
		if (va == NULL)
  8033a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a8:	75 17                	jne    8033c1 <realloc_block_FF+0x48>
		{
			alloc_block_FF(0);
  8033aa:	83 ec 0c             	sub    $0xc,%esp
  8033ad:	6a 00                	push   $0x0
  8033af:	e8 f1 f3 ff ff       	call   8027a5 <alloc_block_FF>
  8033b4:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bc:	e9 c7 03 00 00       	jmp    803788 <realloc_block_FF+0x40f>
		}
		//(va,0)
		else if (va != NULL)
  8033c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c5:	74 18                	je     8033df <realloc_block_FF+0x66>
		{
			free_block(va);
  8033c7:	83 ec 0c             	sub    $0xc,%esp
  8033ca:	ff 75 08             	pushl  0x8(%ebp)
  8033cd:	e8 a0 f9 ff ff       	call   802d72 <free_block>
  8033d2:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	e9 a9 03 00 00       	jmp    803788 <realloc_block_FF+0x40f>
		}
	}

	LIST_FOREACH(iterator, &list)
  8033df:	a1 40 51 90 00       	mov    0x905140,%eax
  8033e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e7:	e9 68 03 00 00       	jmp    803754 <realloc_block_FF+0x3db>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	83 e8 10             	sub    $0x10,%eax
  8033f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033f5:	0f 85 51 03 00 00    	jne    80374c <realloc_block_FF+0x3d3>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  8033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	8b 55 0c             	mov    0xc(%ebp),%edx
  803403:	83 c2 10             	add    $0x10,%edx
  803406:	39 d0                	cmp    %edx,%eax
  803408:	75 08                	jne    803412 <realloc_block_FF+0x99>
			{
				return va;
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	e9 76 03 00 00       	jmp    803788 <realloc_block_FF+0x40f>
			}

			//new size > size
			if (new_size > iterator->size)
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80341a:	0f 83 45 02 00 00    	jae    803665 <realloc_block_FF+0x2ec>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 40 08             	mov    0x8(%eax),%eax
  803426:	89 45 f0             	mov    %eax,-0x10(%ebp)

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
  803429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342c:	8a 40 04             	mov    0x4(%eax),%al
  80342f:	3c 01                	cmp    $0x1,%al
  803431:	0f 85 6b 01 00 00    	jne    8035a2 <realloc_block_FF+0x229>
  803437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80343b:	0f 84 61 01 00 00    	je     8035a2 <realloc_block_FF+0x229>
					if (next->size > (new_size - iterator->size))
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803444:	8b 10                	mov    (%eax),%edx
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80344e:	29 c1                	sub    %eax,%ecx
  803450:	89 c8                	mov    %ecx,%eax
  803452:	39 c2                	cmp    %eax,%edx
  803454:	0f 86 e3 00 00 00    	jbe    80353d <realloc_block_FF+0x1c4>
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
  80345a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345d:	8b 10                	mov    (%eax),%edx
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	2b 45 0c             	sub    0xc(%ebp),%eax
  803467:	01 d0                	add    %edx,%eax
  803469:	83 f8 0f             	cmp    $0xf,%eax
  80346c:	0f 86 b5 00 00 00    	jbe    803527 <realloc_block_FF+0x1ae>
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
  803472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803475:	8b 45 0c             	mov    0xc(%ebp),%eax
  803478:	01 d0                	add    %edx,%eax
  80347a:	83 c0 10             	add    $0x10,%eax
  80347d:	89 45 e8             	mov    %eax,-0x18(%ebp)
							newBlockAfterSplit->size = 0;
  803480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803483:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							newBlockAfterSplit->is_free = 1;
  803489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
  803490:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803494:	74 06                	je     80349c <realloc_block_FF+0x123>
  803496:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80349a:	75 17                	jne    8034b3 <realloc_block_FF+0x13a>
  80349c:	83 ec 04             	sub    $0x4,%esp
  80349f:	68 5c 42 80 00       	push   $0x80425c
  8034a4:	68 ae 01 00 00       	push   $0x1ae
  8034a9:	68 43 42 80 00       	push   $0x804243
  8034ae:	e8 11 d6 ff ff       	call   800ac4 <_panic>
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 50 08             	mov    0x8(%eax),%edx
  8034b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bc:	89 50 08             	mov    %edx,0x8(%eax)
  8034bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c2:	8b 40 08             	mov    0x8(%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0c                	je     8034d5 <realloc_block_FF+0x15c>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 40 08             	mov    0x8(%eax),%eax
  8034cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d2:	89 50 0c             	mov    %edx,0xc(%eax)
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034db:	89 50 08             	mov    %edx,0x8(%eax)
  8034de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e4:	89 50 0c             	mov    %edx,0xc(%eax)
  8034e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ea:	8b 40 08             	mov    0x8(%eax),%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	75 08                	jne    8034f9 <realloc_block_FF+0x180>
  8034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f4:	a3 44 51 90 00       	mov    %eax,0x905144
  8034f9:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8034fe:	40                   	inc    %eax
  8034ff:	a3 4c 51 90 00       	mov    %eax,0x90514c
							next->size = 0;
  803504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
							next->is_free = 0;
  80350d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803510:	c6 40 04 00          	movb   $0x0,0x4(%eax)
							iterator->size = new_size + sizeOfMetaData();
  803514:	8b 45 0c             	mov    0xc(%ebp),%eax
  803517:	8d 50 10             	lea    0x10(%eax),%edx
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	89 10                	mov    %edx,(%eax)
							return va;
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	e9 61 02 00 00       	jmp    803788 <realloc_block_FF+0x40f>
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
  803527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352a:	8d 50 10             	lea    0x10(%eax),%edx
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	89 10                	mov    %edx,(%eax)
							return (iterator + 1);
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	83 c0 10             	add    $0x10,%eax
  803538:	e9 4b 02 00 00       	jmp    803788 <realloc_block_FF+0x40f>
						}
					}
					else if (next->size < (new_size - iterator->size)){
  80353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803540:	8b 10                	mov    (%eax),%edx
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80354a:	29 c1                	sub    %eax,%ecx
  80354c:	89 c8                	mov    %ecx,%eax
  80354e:	39 c2                	cmp    %eax,%edx
  803550:	0f 83 f5 01 00 00    	jae    80374b <realloc_block_FF+0x3d2>
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803556:	83 ec 0c             	sub    $0xc,%esp
  803559:	ff 75 0c             	pushl  0xc(%ebp)
  80355c:	e8 44 f2 ff ff       	call   8027a5 <alloc_block_FF>
  803561:	83 c4 10             	add    $0x10,%esp
  803564:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if (alloc_return != NULL)
  803567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80356b:	74 2d                	je     80359a <realloc_block_FF+0x221>
						{
							memcpy(alloc_return, va, iterator->size);
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	50                   	push   %eax
  803576:	ff 75 08             	pushl  0x8(%ebp)
  803579:	ff 75 ec             	pushl  -0x14(%ebp)
  80357c:	e8 a0 e0 ff ff       	call   801621 <memcpy>
  803581:	83 c4 10             	add    $0x10,%esp
							free_block(va);
  803584:	83 ec 0c             	sub    $0xc,%esp
  803587:	ff 75 08             	pushl  0x8(%ebp)
  80358a:	e8 e3 f7 ff ff       	call   802d72 <free_block>
  80358f:	83 c4 10             	add    $0x10,%esp
							return alloc_return;
  803592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803595:	e9 ee 01 00 00       	jmp    803788 <realloc_block_FF+0x40f>
						}
						else
						{
							return va;
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	e9 e6 01 00 00       	jmp    803788 <realloc_block_FF+0x40f>
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  8035a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a5:	8a 40 04             	mov    0x4(%eax),%al
  8035a8:	3c 01                	cmp    $0x1,%al
  8035aa:	75 59                	jne    803605 <realloc_block_FF+0x28c>
  8035ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035af:	8b 10                	mov    (%eax),%edx
  8035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8035b9:	29 c1                	sub    %eax,%ecx
  8035bb:	89 c8                	mov    %ecx,%eax
  8035bd:	39 c2                	cmp    %eax,%edx
  8035bf:	75 44                	jne    803605 <realloc_block_FF+0x28c>
  8035c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035c5:	74 3e                	je     803605 <realloc_block_FF+0x28c>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  8035c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ca:	8b 40 08             	mov    0x8(%eax),%eax
  8035cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					iterator->prev_next_info.le_next = after_next;
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d6:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  8035d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035df:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  8035e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  8035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ee:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  8035f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f5:	8d 50 10             	lea    0x10(%eax),%edx
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	89 10                	mov    %edx,(%eax)
					return va;
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	e9 83 01 00 00       	jmp    803788 <realloc_block_FF+0x40f>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  803605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803608:	8a 40 04             	mov    0x4(%eax),%al
  80360b:	84 c0                	test   %al,%al
  80360d:	74 0a                	je     803619 <realloc_block_FF+0x2a0>
  80360f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803613:	0f 85 33 01 00 00    	jne    80374c <realloc_block_FF+0x3d3>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  803619:	83 ec 0c             	sub    $0xc,%esp
  80361c:	ff 75 0c             	pushl  0xc(%ebp)
  80361f:	e8 81 f1 ff ff       	call   8027a5 <alloc_block_FF>
  803624:	83 c4 10             	add    $0x10,%esp
  803627:	89 45 e0             	mov    %eax,-0x20(%ebp)
					if (alloc_return != NULL)
  80362a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80362e:	74 2d                	je     80365d <realloc_block_FF+0x2e4>
					{
						memcpy(alloc_return, va, iterator->size);
  803630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	83 ec 04             	sub    $0x4,%esp
  803638:	50                   	push   %eax
  803639:	ff 75 08             	pushl  0x8(%ebp)
  80363c:	ff 75 e0             	pushl  -0x20(%ebp)
  80363f:	e8 dd df ff ff       	call   801621 <memcpy>
  803644:	83 c4 10             	add    $0x10,%esp
						free_block(va);
  803647:	83 ec 0c             	sub    $0xc,%esp
  80364a:	ff 75 08             	pushl  0x8(%ebp)
  80364d:	e8 20 f7 ff ff       	call   802d72 <free_block>
  803652:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  803655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803658:	e9 2b 01 00 00       	jmp    803788 <realloc_block_FF+0x40f>
					}
					else
					{
						return va;
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	e9 23 01 00 00       	jmp    803788 <realloc_block_FF+0x40f>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80366d:	0f 86 d9 00 00 00    	jbe    80374c <realloc_block_FF+0x3d3>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	8b 00                	mov    (%eax),%eax
  803678:	2b 45 0c             	sub    0xc(%ebp),%eax
  80367b:	83 f8 0f             	cmp    $0xf,%eax
  80367e:	0f 86 b4 00 00 00    	jbe    803738 <realloc_block_FF+0x3bf>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368a:	01 d0                	add    %edx,%eax
  80368c:	83 c0 10             	add    $0x10,%eax
  80368f:	89 45 dc             	mov    %eax,-0x24(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	2b 45 0c             	sub    0xc(%ebp),%eax
  80369a:	8d 50 f0             	lea    -0x10(%eax),%edx
  80369d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a0:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  8036a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a6:	74 06                	je     8036ae <realloc_block_FF+0x335>
  8036a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036ac:	75 17                	jne    8036c5 <realloc_block_FF+0x34c>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 5c 42 80 00       	push   $0x80425c
  8036b6:	68 ed 01 00 00       	push   $0x1ed
  8036bb:	68 43 42 80 00       	push   $0x804243
  8036c0:	e8 ff d3 ff ff       	call   800ac4 <_panic>
  8036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c8:	8b 50 08             	mov    0x8(%eax),%edx
  8036cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ce:	89 50 08             	mov    %edx,0x8(%eax)
  8036d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d4:	8b 40 08             	mov    0x8(%eax),%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 0c                	je     8036e7 <realloc_block_FF+0x36e>
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 40 08             	mov    0x8(%eax),%eax
  8036e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036e4:	89 50 0c             	mov    %edx,0xc(%eax)
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036ed:	89 50 08             	mov    %edx,0x8(%eax)
  8036f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f6:	89 50 0c             	mov    %edx,0xc(%eax)
  8036f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fc:	8b 40 08             	mov    0x8(%eax),%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	75 08                	jne    80370b <realloc_block_FF+0x392>
  803703:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803706:	a3 44 51 90 00       	mov    %eax,0x905144
  80370b:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803710:	40                   	inc    %eax
  803711:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  803716:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803719:	83 c0 10             	add    $0x10,%eax
  80371c:	83 ec 0c             	sub    $0xc,%esp
  80371f:	50                   	push   %eax
  803720:	e8 4d f6 ff ff       	call   802d72 <free_block>
  803725:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  803728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372b:	8d 50 10             	lea    0x10(%eax),%edx
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	89 10                	mov    %edx,(%eax)
					return va;
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	eb 50                	jmp    803788 <realloc_block_FF+0x40f>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  803738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373b:	8d 50 10             	lea    0x10(%eax),%edx
  80373e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803741:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	83 c0 10             	add    $0x10,%eax
  803749:	eb 3d                	jmp    803788 <realloc_block_FF+0x40f>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
  80374b:	90                   	nop
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  80374c:	a1 48 51 90 00       	mov    0x905148,%eax
  803751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803758:	74 08                	je     803762 <realloc_block_FF+0x3e9>
  80375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375d:	8b 40 08             	mov    0x8(%eax),%eax
  803760:	eb 05                	jmp    803767 <realloc_block_FF+0x3ee>
  803762:	b8 00 00 00 00       	mov    $0x0,%eax
  803767:	a3 48 51 90 00       	mov    %eax,0x905148
  80376c:	a1 48 51 90 00       	mov    0x905148,%eax
  803771:	85 c0                	test   %eax,%eax
  803773:	0f 85 73 fc ff ff    	jne    8033ec <realloc_block_FF+0x73>
  803779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377d:	0f 85 69 fc ff ff    	jne    8033ec <realloc_block_FF+0x73>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803788:	c9                   	leave  
  803789:	c3                   	ret    
  80378a:	66 90                	xchg   %ax,%ax

0080378c <__udivdi3>:
  80378c:	55                   	push   %ebp
  80378d:	57                   	push   %edi
  80378e:	56                   	push   %esi
  80378f:	53                   	push   %ebx
  803790:	83 ec 1c             	sub    $0x1c,%esp
  803793:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803797:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80379b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80379f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037a3:	89 ca                	mov    %ecx,%edx
  8037a5:	89 f8                	mov    %edi,%eax
  8037a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ab:	85 f6                	test   %esi,%esi
  8037ad:	75 2d                	jne    8037dc <__udivdi3+0x50>
  8037af:	39 cf                	cmp    %ecx,%edi
  8037b1:	77 65                	ja     803818 <__udivdi3+0x8c>
  8037b3:	89 fd                	mov    %edi,%ebp
  8037b5:	85 ff                	test   %edi,%edi
  8037b7:	75 0b                	jne    8037c4 <__udivdi3+0x38>
  8037b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037be:	31 d2                	xor    %edx,%edx
  8037c0:	f7 f7                	div    %edi
  8037c2:	89 c5                	mov    %eax,%ebp
  8037c4:	31 d2                	xor    %edx,%edx
  8037c6:	89 c8                	mov    %ecx,%eax
  8037c8:	f7 f5                	div    %ebp
  8037ca:	89 c1                	mov    %eax,%ecx
  8037cc:	89 d8                	mov    %ebx,%eax
  8037ce:	f7 f5                	div    %ebp
  8037d0:	89 cf                	mov    %ecx,%edi
  8037d2:	89 fa                	mov    %edi,%edx
  8037d4:	83 c4 1c             	add    $0x1c,%esp
  8037d7:	5b                   	pop    %ebx
  8037d8:	5e                   	pop    %esi
  8037d9:	5f                   	pop    %edi
  8037da:	5d                   	pop    %ebp
  8037db:	c3                   	ret    
  8037dc:	39 ce                	cmp    %ecx,%esi
  8037de:	77 28                	ja     803808 <__udivdi3+0x7c>
  8037e0:	0f bd fe             	bsr    %esi,%edi
  8037e3:	83 f7 1f             	xor    $0x1f,%edi
  8037e6:	75 40                	jne    803828 <__udivdi3+0x9c>
  8037e8:	39 ce                	cmp    %ecx,%esi
  8037ea:	72 0a                	jb     8037f6 <__udivdi3+0x6a>
  8037ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037f0:	0f 87 9e 00 00 00    	ja     803894 <__udivdi3+0x108>
  8037f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fb:	89 fa                	mov    %edi,%edx
  8037fd:	83 c4 1c             	add    $0x1c,%esp
  803800:	5b                   	pop    %ebx
  803801:	5e                   	pop    %esi
  803802:	5f                   	pop    %edi
  803803:	5d                   	pop    %ebp
  803804:	c3                   	ret    
  803805:	8d 76 00             	lea    0x0(%esi),%esi
  803808:	31 ff                	xor    %edi,%edi
  80380a:	31 c0                	xor    %eax,%eax
  80380c:	89 fa                	mov    %edi,%edx
  80380e:	83 c4 1c             	add    $0x1c,%esp
  803811:	5b                   	pop    %ebx
  803812:	5e                   	pop    %esi
  803813:	5f                   	pop    %edi
  803814:	5d                   	pop    %ebp
  803815:	c3                   	ret    
  803816:	66 90                	xchg   %ax,%ax
  803818:	89 d8                	mov    %ebx,%eax
  80381a:	f7 f7                	div    %edi
  80381c:	31 ff                	xor    %edi,%edi
  80381e:	89 fa                	mov    %edi,%edx
  803820:	83 c4 1c             	add    $0x1c,%esp
  803823:	5b                   	pop    %ebx
  803824:	5e                   	pop    %esi
  803825:	5f                   	pop    %edi
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    
  803828:	bd 20 00 00 00       	mov    $0x20,%ebp
  80382d:	89 eb                	mov    %ebp,%ebx
  80382f:	29 fb                	sub    %edi,%ebx
  803831:	89 f9                	mov    %edi,%ecx
  803833:	d3 e6                	shl    %cl,%esi
  803835:	89 c5                	mov    %eax,%ebp
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 ed                	shr    %cl,%ebp
  80383b:	89 e9                	mov    %ebp,%ecx
  80383d:	09 f1                	or     %esi,%ecx
  80383f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803843:	89 f9                	mov    %edi,%ecx
  803845:	d3 e0                	shl    %cl,%eax
  803847:	89 c5                	mov    %eax,%ebp
  803849:	89 d6                	mov    %edx,%esi
  80384b:	88 d9                	mov    %bl,%cl
  80384d:	d3 ee                	shr    %cl,%esi
  80384f:	89 f9                	mov    %edi,%ecx
  803851:	d3 e2                	shl    %cl,%edx
  803853:	8b 44 24 08          	mov    0x8(%esp),%eax
  803857:	88 d9                	mov    %bl,%cl
  803859:	d3 e8                	shr    %cl,%eax
  80385b:	09 c2                	or     %eax,%edx
  80385d:	89 d0                	mov    %edx,%eax
  80385f:	89 f2                	mov    %esi,%edx
  803861:	f7 74 24 0c          	divl   0xc(%esp)
  803865:	89 d6                	mov    %edx,%esi
  803867:	89 c3                	mov    %eax,%ebx
  803869:	f7 e5                	mul    %ebp
  80386b:	39 d6                	cmp    %edx,%esi
  80386d:	72 19                	jb     803888 <__udivdi3+0xfc>
  80386f:	74 0b                	je     80387c <__udivdi3+0xf0>
  803871:	89 d8                	mov    %ebx,%eax
  803873:	31 ff                	xor    %edi,%edi
  803875:	e9 58 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  80387a:	66 90                	xchg   %ax,%ax
  80387c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803880:	89 f9                	mov    %edi,%ecx
  803882:	d3 e2                	shl    %cl,%edx
  803884:	39 c2                	cmp    %eax,%edx
  803886:	73 e9                	jae    803871 <__udivdi3+0xe5>
  803888:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80388b:	31 ff                	xor    %edi,%edi
  80388d:	e9 40 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  803892:	66 90                	xchg   %ax,%ax
  803894:	31 c0                	xor    %eax,%eax
  803896:	e9 37 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  80389b:	90                   	nop

0080389c <__umoddi3>:
  80389c:	55                   	push   %ebp
  80389d:	57                   	push   %edi
  80389e:	56                   	push   %esi
  80389f:	53                   	push   %ebx
  8038a0:	83 ec 1c             	sub    $0x1c,%esp
  8038a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038bb:	89 f3                	mov    %esi,%ebx
  8038bd:	89 fa                	mov    %edi,%edx
  8038bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038c3:	89 34 24             	mov    %esi,(%esp)
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	75 1a                	jne    8038e4 <__umoddi3+0x48>
  8038ca:	39 f7                	cmp    %esi,%edi
  8038cc:	0f 86 a2 00 00 00    	jbe    803974 <__umoddi3+0xd8>
  8038d2:	89 c8                	mov    %ecx,%eax
  8038d4:	89 f2                	mov    %esi,%edx
  8038d6:	f7 f7                	div    %edi
  8038d8:	89 d0                	mov    %edx,%eax
  8038da:	31 d2                	xor    %edx,%edx
  8038dc:	83 c4 1c             	add    $0x1c,%esp
  8038df:	5b                   	pop    %ebx
  8038e0:	5e                   	pop    %esi
  8038e1:	5f                   	pop    %edi
  8038e2:	5d                   	pop    %ebp
  8038e3:	c3                   	ret    
  8038e4:	39 f0                	cmp    %esi,%eax
  8038e6:	0f 87 ac 00 00 00    	ja     803998 <__umoddi3+0xfc>
  8038ec:	0f bd e8             	bsr    %eax,%ebp
  8038ef:	83 f5 1f             	xor    $0x1f,%ebp
  8038f2:	0f 84 ac 00 00 00    	je     8039a4 <__umoddi3+0x108>
  8038f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038fd:	29 ef                	sub    %ebp,%edi
  8038ff:	89 fe                	mov    %edi,%esi
  803901:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803905:	89 e9                	mov    %ebp,%ecx
  803907:	d3 e0                	shl    %cl,%eax
  803909:	89 d7                	mov    %edx,%edi
  80390b:	89 f1                	mov    %esi,%ecx
  80390d:	d3 ef                	shr    %cl,%edi
  80390f:	09 c7                	or     %eax,%edi
  803911:	89 e9                	mov    %ebp,%ecx
  803913:	d3 e2                	shl    %cl,%edx
  803915:	89 14 24             	mov    %edx,(%esp)
  803918:	89 d8                	mov    %ebx,%eax
  80391a:	d3 e0                	shl    %cl,%eax
  80391c:	89 c2                	mov    %eax,%edx
  80391e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803922:	d3 e0                	shl    %cl,%eax
  803924:	89 44 24 04          	mov    %eax,0x4(%esp)
  803928:	8b 44 24 08          	mov    0x8(%esp),%eax
  80392c:	89 f1                	mov    %esi,%ecx
  80392e:	d3 e8                	shr    %cl,%eax
  803930:	09 d0                	or     %edx,%eax
  803932:	d3 eb                	shr    %cl,%ebx
  803934:	89 da                	mov    %ebx,%edx
  803936:	f7 f7                	div    %edi
  803938:	89 d3                	mov    %edx,%ebx
  80393a:	f7 24 24             	mull   (%esp)
  80393d:	89 c6                	mov    %eax,%esi
  80393f:	89 d1                	mov    %edx,%ecx
  803941:	39 d3                	cmp    %edx,%ebx
  803943:	0f 82 87 00 00 00    	jb     8039d0 <__umoddi3+0x134>
  803949:	0f 84 91 00 00 00    	je     8039e0 <__umoddi3+0x144>
  80394f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803953:	29 f2                	sub    %esi,%edx
  803955:	19 cb                	sbb    %ecx,%ebx
  803957:	89 d8                	mov    %ebx,%eax
  803959:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80395d:	d3 e0                	shl    %cl,%eax
  80395f:	89 e9                	mov    %ebp,%ecx
  803961:	d3 ea                	shr    %cl,%edx
  803963:	09 d0                	or     %edx,%eax
  803965:	89 e9                	mov    %ebp,%ecx
  803967:	d3 eb                	shr    %cl,%ebx
  803969:	89 da                	mov    %ebx,%edx
  80396b:	83 c4 1c             	add    $0x1c,%esp
  80396e:	5b                   	pop    %ebx
  80396f:	5e                   	pop    %esi
  803970:	5f                   	pop    %edi
  803971:	5d                   	pop    %ebp
  803972:	c3                   	ret    
  803973:	90                   	nop
  803974:	89 fd                	mov    %edi,%ebp
  803976:	85 ff                	test   %edi,%edi
  803978:	75 0b                	jne    803985 <__umoddi3+0xe9>
  80397a:	b8 01 00 00 00       	mov    $0x1,%eax
  80397f:	31 d2                	xor    %edx,%edx
  803981:	f7 f7                	div    %edi
  803983:	89 c5                	mov    %eax,%ebp
  803985:	89 f0                	mov    %esi,%eax
  803987:	31 d2                	xor    %edx,%edx
  803989:	f7 f5                	div    %ebp
  80398b:	89 c8                	mov    %ecx,%eax
  80398d:	f7 f5                	div    %ebp
  80398f:	89 d0                	mov    %edx,%eax
  803991:	e9 44 ff ff ff       	jmp    8038da <__umoddi3+0x3e>
  803996:	66 90                	xchg   %ax,%ax
  803998:	89 c8                	mov    %ecx,%eax
  80399a:	89 f2                	mov    %esi,%edx
  80399c:	83 c4 1c             	add    $0x1c,%esp
  80399f:	5b                   	pop    %ebx
  8039a0:	5e                   	pop    %esi
  8039a1:	5f                   	pop    %edi
  8039a2:	5d                   	pop    %ebp
  8039a3:	c3                   	ret    
  8039a4:	3b 04 24             	cmp    (%esp),%eax
  8039a7:	72 06                	jb     8039af <__umoddi3+0x113>
  8039a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039ad:	77 0f                	ja     8039be <__umoddi3+0x122>
  8039af:	89 f2                	mov    %esi,%edx
  8039b1:	29 f9                	sub    %edi,%ecx
  8039b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039b7:	89 14 24             	mov    %edx,(%esp)
  8039ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039c2:	8b 14 24             	mov    (%esp),%edx
  8039c5:	83 c4 1c             	add    $0x1c,%esp
  8039c8:	5b                   	pop    %ebx
  8039c9:	5e                   	pop    %esi
  8039ca:	5f                   	pop    %edi
  8039cb:	5d                   	pop    %ebp
  8039cc:	c3                   	ret    
  8039cd:	8d 76 00             	lea    0x0(%esi),%esi
  8039d0:	2b 04 24             	sub    (%esp),%eax
  8039d3:	19 fa                	sbb    %edi,%edx
  8039d5:	89 d1                	mov    %edx,%ecx
  8039d7:	89 c6                	mov    %eax,%esi
  8039d9:	e9 71 ff ff ff       	jmp    80394f <__umoddi3+0xb3>
  8039de:	66 90                	xchg   %ax,%ax
  8039e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039e4:	72 ea                	jb     8039d0 <__umoddi3+0x134>
  8039e6:	89 d9                	mov    %ebx,%ecx
  8039e8:	e9 62 ff ff ff       	jmp    80394f <__umoddi3+0xb3>
