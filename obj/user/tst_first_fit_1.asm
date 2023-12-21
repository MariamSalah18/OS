
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
  800045:	e8 41 24 00 00       	call   80248b <sys_set_uheap_strategy>
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
  80006a:	68 a0 39 80 00       	push   $0x8039a0
  80006f:	6a 15                	push   $0x15
  800071:	68 bc 39 80 00       	push   $0x8039bc
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
  8000a1:	e8 25 1f 00 00       	call   801fcb <sys_calculate_free_frames>
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000a9:	e8 68 1f 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8000ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	50                   	push   %eax
  8000bb:	e8 ec 1a 00 00       	call   801bac <malloc>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8000c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000cc:	74 14                	je     8000e2 <_main+0xaa>
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	68 d4 39 80 00       	push   $0x8039d4
  8000d6:	6a 26                	push   $0x26
  8000d8:	68 bc 39 80 00       	push   $0x8039bc
  8000dd:	e8 e2 09 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8000e2:	e8 2f 1f 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8000e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ea:	74 14                	je     800100 <_main+0xc8>
  8000ec:	83 ec 04             	sub    $0x4,%esp
  8000ef:	68 04 3a 80 00       	push   $0x803a04
  8000f4:	6a 28                	push   $0x28
  8000f6:	68 bc 39 80 00       	push   $0x8039bc
  8000fb:	e8 c4 09 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800100:	e8 c6 1e 00 00       	call   801fcb <sys_calculate_free_frames>
  800105:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800108:	e8 09 1f 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80010d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800113:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	50                   	push   %eax
  80011a:	e8 8d 1a 00 00       	call   801bac <malloc>
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
  800139:	68 d4 39 80 00       	push   $0x8039d4
  80013e:	6a 2e                	push   $0x2e
  800140:	68 bc 39 80 00       	push   $0x8039bc
  800145:	e8 7a 09 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014a:	e8 c7 1e 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80014f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800152:	74 14                	je     800168 <_main+0x130>
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	68 04 3a 80 00       	push   $0x803a04
  80015c:	6a 30                	push   $0x30
  80015e:	68 bc 39 80 00       	push   $0x8039bc
  800163:	e8 5c 09 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800168:	e8 5e 1e 00 00       	call   801fcb <sys_calculate_free_frames>
  80016d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800170:	e8 a1 1e 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	e8 25 1a 00 00       	call   801bac <malloc>
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
  8001a5:	68 d4 39 80 00       	push   $0x8039d4
  8001aa:	6a 36                	push   $0x36
  8001ac:	68 bc 39 80 00       	push   $0x8039bc
  8001b1:	e8 0e 09 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 5b 1e 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 04 3a 80 00       	push   $0x803a04
  8001c8:	6a 38                	push   $0x38
  8001ca:	68 bc 39 80 00       	push   $0x8039bc
  8001cf:	e8 f0 08 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001d4:	e8 f2 1d 00 00       	call   801fcb <sys_calculate_free_frames>
  8001d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dc:	e8 35 1e 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8001e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	50                   	push   %eax
  8001ee:	e8 b9 19 00 00       	call   801bac <malloc>
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
  800215:	68 d4 39 80 00       	push   $0x8039d4
  80021a:	6a 3e                	push   $0x3e
  80021c:	68 bc 39 80 00       	push   $0x8039bc
  800221:	e8 9e 08 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800226:	e8 eb 1d 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80022b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80022e:	74 14                	je     800244 <_main+0x20c>
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	68 04 3a 80 00       	push   $0x803a04
  800238:	6a 40                	push   $0x40
  80023a:	68 bc 39 80 00       	push   $0x8039bc
  80023f:	e8 80 08 00 00       	call   800ac4 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800244:	e8 82 1d 00 00       	call   801fcb <sys_calculate_free_frames>
  800249:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024c:	e8 c5 1d 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800257:	01 c0                	add    %eax,%eax
  800259:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 47 19 00 00       	call   801bac <malloc>
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
  800284:	68 d4 39 80 00       	push   $0x8039d4
  800289:	6a 46                	push   $0x46
  80028b:	68 bc 39 80 00       	push   $0x8039bc
  800290:	e8 2f 08 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800295:	e8 7c 1d 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80029a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80029d:	74 14                	je     8002b3 <_main+0x27b>
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	68 04 3a 80 00       	push   $0x803a04
  8002a7:	6a 48                	push   $0x48
  8002a9:	68 bc 39 80 00       	push   $0x8039bc
  8002ae:	e8 11 08 00 00       	call   800ac4 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002b3:	e8 13 1d 00 00       	call   801fcb <sys_calculate_free_frames>
  8002b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002bb:	e8 56 1d 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c6:	01 c0                	add    %eax,%eax
  8002c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	e8 d8 18 00 00       	call   801bac <malloc>
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
  8002f8:	68 d4 39 80 00       	push   $0x8039d4
  8002fd:	6a 4e                	push   $0x4e
  8002ff:	68 bc 39 80 00       	push   $0x8039bc
  800304:	e8 bb 07 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800309:	e8 08 1d 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80030e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800311:	74 14                	je     800327 <_main+0x2ef>
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	68 04 3a 80 00       	push   $0x803a04
  80031b:	6a 50                	push   $0x50
  80031d:	68 bc 39 80 00       	push   $0x8039bc
  800322:	e8 9d 07 00 00       	call   800ac4 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800327:	e8 9f 1c 00 00       	call   801fcb <sys_calculate_free_frames>
  80032c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032f:	e8 e2 1c 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800334:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033a:	89 c2                	mov    %eax,%edx
  80033c:	01 d2                	add    %edx,%edx
  80033e:	01 d0                	add    %edx,%eax
  800340:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800343:	83 ec 0c             	sub    $0xc,%esp
  800346:	50                   	push   %eax
  800347:	e8 60 18 00 00       	call   801bac <malloc>
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
  80036b:	68 d4 39 80 00       	push   $0x8039d4
  800370:	6a 56                	push   $0x56
  800372:	68 bc 39 80 00       	push   $0x8039bc
  800377:	e8 48 07 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80037c:	e8 95 1c 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800381:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 04 3a 80 00       	push   $0x803a04
  80038e:	6a 58                	push   $0x58
  800390:	68 bc 39 80 00       	push   $0x8039bc
  800395:	e8 2a 07 00 00       	call   800ac4 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80039a:	e8 2c 1c 00 00       	call   801fcb <sys_calculate_free_frames>
  80039f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a2:	e8 6f 1c 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8003a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ad:	89 c2                	mov    %eax,%edx
  8003af:	01 d2                	add    %edx,%edx
  8003b1:	01 d0                	add    %edx,%eax
  8003b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	50                   	push   %eax
  8003ba:	e8 ed 17 00 00       	call   801bac <malloc>
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
  8003e6:	68 d4 39 80 00       	push   $0x8039d4
  8003eb:	6a 5e                	push   $0x5e
  8003ed:	68 bc 39 80 00       	push   $0x8039bc
  8003f2:	e8 cd 06 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003f7:	e8 1a 1c 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8003fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003ff:	74 14                	je     800415 <_main+0x3dd>
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	68 04 3a 80 00       	push   $0x803a04
  800409:	6a 60                	push   $0x60
  80040b:	68 bc 39 80 00       	push   $0x8039bc
  800410:	e8 af 06 00 00       	call   800ac4 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800415:	e8 b1 1b 00 00       	call   801fcb <sys_calculate_free_frames>
  80041a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80041d:	e8 f4 1b 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  800425:	8b 45 98             	mov    -0x68(%ebp),%eax
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	50                   	push   %eax
  80042c:	e8 d7 18 00 00       	call   801d08 <free>
  800431:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800434:	e8 dd 1b 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800439:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043c:	74 14                	je     800452 <_main+0x41a>
  80043e:	83 ec 04             	sub    $0x4,%esp
  800441:	68 21 3a 80 00       	push   $0x803a21
  800446:	6a 6a                	push   $0x6a
  800448:	68 bc 39 80 00       	push   $0x8039bc
  80044d:	e8 72 06 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800452:	e8 74 1b 00 00       	call   801fcb <sys_calculate_free_frames>
  800457:	89 c2                	mov    %eax,%edx
  800459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045c:	39 c2                	cmp    %eax,%edx
  80045e:	74 14                	je     800474 <_main+0x43c>
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	68 38 3a 80 00       	push   $0x803a38
  800468:	6a 6b                	push   $0x6b
  80046a:	68 bc 39 80 00       	push   $0x8039bc
  80046f:	e8 50 06 00 00       	call   800ac4 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800474:	e8 52 1b 00 00       	call   801fcb <sys_calculate_free_frames>
  800479:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047c:	e8 95 1b 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800484:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800487:	83 ec 0c             	sub    $0xc,%esp
  80048a:	50                   	push   %eax
  80048b:	e8 78 18 00 00       	call   801d08 <free>
  800490:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800493:	e8 7e 1b 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 21 3a 80 00       	push   $0x803a21
  8004a5:	6a 72                	push   $0x72
  8004a7:	68 bc 39 80 00       	push   $0x8039bc
  8004ac:	e8 13 06 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8004b1:	e8 15 1b 00 00       	call   801fcb <sys_calculate_free_frames>
  8004b6:	89 c2                	mov    %eax,%edx
  8004b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	74 14                	je     8004d3 <_main+0x49b>
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 38 3a 80 00       	push   $0x803a38
  8004c7:	6a 73                	push   $0x73
  8004c9:	68 bc 39 80 00       	push   $0x8039bc
  8004ce:	e8 f1 05 00 00       	call   800ac4 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d3:	e8 f3 1a 00 00       	call   801fcb <sys_calculate_free_frames>
  8004d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004db:	e8 36 1b 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8004e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8004e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	50                   	push   %eax
  8004ea:	e8 19 18 00 00       	call   801d08 <free>
  8004ef:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004f2:	e8 1f 1b 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	74 14                	je     800510 <_main+0x4d8>
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	68 21 3a 80 00       	push   $0x803a21
  800504:	6a 7a                	push   $0x7a
  800506:	68 bc 39 80 00       	push   $0x8039bc
  80050b:	e8 b4 05 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800510:	e8 b6 1a 00 00       	call   801fcb <sys_calculate_free_frames>
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80051a:	39 c2                	cmp    %eax,%edx
  80051c:	74 14                	je     800532 <_main+0x4fa>
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	68 38 3a 80 00       	push   $0x803a38
  800526:	6a 7b                	push   $0x7b
  800528:	68 bc 39 80 00       	push   $0x8039bc
  80052d:	e8 92 05 00 00       	call   800ac4 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800532:	e8 94 1a 00 00       	call   801fcb <sys_calculate_free_frames>
  800537:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80053a:	e8 d7 1a 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80053f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800545:	89 d0                	mov    %edx,%eax
  800547:	c1 e0 09             	shl    $0x9,%eax
  80054a:	29 d0                	sub    %edx,%eax
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	50                   	push   %eax
  800550:	e8 57 16 00 00       	call   801bac <malloc>
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
  80056f:	68 d4 39 80 00       	push   $0x8039d4
  800574:	68 84 00 00 00       	push   $0x84
  800579:	68 bc 39 80 00       	push   $0x8039bc
  80057e:	e8 41 05 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800583:	e8 8e 1a 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800588:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80058b:	74 17                	je     8005a4 <_main+0x56c>
  80058d:	83 ec 04             	sub    $0x4,%esp
  800590:	68 04 3a 80 00       	push   $0x803a04
  800595:	68 86 00 00 00       	push   $0x86
  80059a:	68 bc 39 80 00       	push   $0x8039bc
  80059f:	e8 20 05 00 00       	call   800ac4 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  8005a4:	e8 22 1a 00 00       	call   801fcb <sys_calculate_free_frames>
  8005a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ac:	e8 65 1a 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8005b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8005b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8005ba:	83 ec 0c             	sub    $0xc,%esp
  8005bd:	50                   	push   %eax
  8005be:	e8 e9 15 00 00       	call   801bac <malloc>
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
  8005e2:	68 d4 39 80 00       	push   $0x8039d4
  8005e7:	68 8c 00 00 00       	push   $0x8c
  8005ec:	68 bc 39 80 00       	push   $0x8039bc
  8005f1:	e8 ce 04 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8005f6:	e8 1b 1a 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8005fb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005fe:	74 17                	je     800617 <_main+0x5df>
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 04 3a 80 00       	push   $0x803a04
  800608:	68 8e 00 00 00       	push   $0x8e
  80060d:	68 bc 39 80 00       	push   $0x8039bc
  800612:	e8 ad 04 00 00       	call   800ac4 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800617:	e8 af 19 00 00       	call   801fcb <sys_calculate_free_frames>
  80061c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061f:	e8 f2 19 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800627:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80062a:	89 d0                	mov    %edx,%eax
  80062c:	c1 e0 08             	shl    $0x8,%eax
  80062f:	29 d0                	sub    %edx,%eax
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	50                   	push   %eax
  800635:	e8 72 15 00 00       	call   801bac <malloc>
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
  80065c:	68 d4 39 80 00       	push   $0x8039d4
  800661:	68 94 00 00 00       	push   $0x94
  800666:	68 bc 39 80 00       	push   $0x8039bc
  80066b:	e8 54 04 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800670:	e8 a1 19 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800675:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800678:	74 17                	je     800691 <_main+0x659>
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	68 04 3a 80 00       	push   $0x803a04
  800682:	68 96 00 00 00       	push   $0x96
  800687:	68 bc 39 80 00       	push   $0x8039bc
  80068c:	e8 33 04 00 00       	call   800ac4 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800691:	e8 35 19 00 00       	call   801fcb <sys_calculate_free_frames>
  800696:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800699:	e8 78 19 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a4:	01 c0                	add    %eax,%eax
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	50                   	push   %eax
  8006aa:	e8 fd 14 00 00       	call   801bac <malloc>
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
  8006ce:	68 d4 39 80 00       	push   $0x8039d4
  8006d3:	68 9c 00 00 00       	push   $0x9c
  8006d8:	68 bc 39 80 00       	push   $0x8039bc
  8006dd:	e8 e2 03 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e2:	e8 2f 19 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8006e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006ea:	74 17                	je     800703 <_main+0x6cb>
  8006ec:	83 ec 04             	sub    $0x4,%esp
  8006ef:	68 04 3a 80 00       	push   $0x803a04
  8006f4:	68 9e 00 00 00       	push   $0x9e
  8006f9:	68 bc 39 80 00       	push   $0x8039bc
  8006fe:	e8 c1 03 00 00       	call   800ac4 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800703:	e8 c3 18 00 00       	call   801fcb <sys_calculate_free_frames>
  800708:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80070b:	e8 06 19 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800716:	c1 e0 02             	shl    $0x2,%eax
  800719:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80071c:	83 ec 0c             	sub    $0xc,%esp
  80071f:	50                   	push   %eax
  800720:	e8 87 14 00 00       	call   801bac <malloc>
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
  80074d:	68 d4 39 80 00       	push   $0x8039d4
  800752:	68 a4 00 00 00       	push   $0xa4
  800757:	68 bc 39 80 00       	push   $0x8039bc
  80075c:	e8 63 03 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800761:	e8 b0 18 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800766:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800769:	74 17                	je     800782 <_main+0x74a>
  80076b:	83 ec 04             	sub    $0x4,%esp
  80076e:	68 04 3a 80 00       	push   $0x803a04
  800773:	68 a6 00 00 00       	push   $0xa6
  800778:	68 bc 39 80 00       	push   $0x8039bc
  80077d:	e8 42 03 00 00       	call   800ac4 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800782:	e8 44 18 00 00       	call   801fcb <sys_calculate_free_frames>
  800787:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80078a:	e8 87 18 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80078f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[2]);
  800792:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 6a 15 00 00       	call   801d08 <free>
  80079e:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8007a1:	e8 70 18 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8007a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007a9:	74 17                	je     8007c2 <_main+0x78a>
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	68 21 3a 80 00       	push   $0x803a21
  8007b3:	68 b0 00 00 00       	push   $0xb0
  8007b8:	68 bc 39 80 00       	push   $0x8039bc
  8007bd:	e8 02 03 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8007c2:	e8 04 18 00 00       	call   801fcb <sys_calculate_free_frames>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007cc:	39 c2                	cmp    %eax,%edx
  8007ce:	74 17                	je     8007e7 <_main+0x7af>
  8007d0:	83 ec 04             	sub    $0x4,%esp
  8007d3:	68 38 3a 80 00       	push   $0x803a38
  8007d8:	68 b1 00 00 00       	push   $0xb1
  8007dd:	68 bc 39 80 00       	push   $0x8039bc
  8007e2:	e8 dd 02 00 00       	call   800ac4 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 df 17 00 00       	call   801fcb <sys_calculate_free_frames>
  8007ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 22 18 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  8007f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 05 15 00 00       	call   801d08 <free>
  800803:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800806:	e8 0b 18 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80080b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80080e:	74 17                	je     800827 <_main+0x7ef>
  800810:	83 ec 04             	sub    $0x4,%esp
  800813:	68 21 3a 80 00       	push   $0x803a21
  800818:	68 b8 00 00 00       	push   $0xb8
  80081d:	68 bc 39 80 00       	push   $0x8039bc
  800822:	e8 9d 02 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800827:	e8 9f 17 00 00       	call   801fcb <sys_calculate_free_frames>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800831:	39 c2                	cmp    %eax,%edx
  800833:	74 17                	je     80084c <_main+0x814>
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	68 38 3a 80 00       	push   $0x803a38
  80083d:	68 b9 00 00 00       	push   $0xb9
  800842:	68 bc 39 80 00       	push   $0x8039bc
  800847:	e8 78 02 00 00       	call   800ac4 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  80084c:	e8 7a 17 00 00       	call   801fcb <sys_calculate_free_frames>
  800851:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800854:	e8 bd 17 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[3]);
  80085c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80085f:	83 ec 0c             	sub    $0xc,%esp
  800862:	50                   	push   %eax
  800863:	e8 a0 14 00 00       	call   801d08 <free>
  800868:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80086b:	e8 a6 17 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  800870:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800873:	74 17                	je     80088c <_main+0x854>
  800875:	83 ec 04             	sub    $0x4,%esp
  800878:	68 21 3a 80 00       	push   $0x803a21
  80087d:	68 c0 00 00 00       	push   $0xc0
  800882:	68 bc 39 80 00       	push   $0x8039bc
  800887:	e8 38 02 00 00       	call   800ac4 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80088c:	e8 3a 17 00 00       	call   801fcb <sys_calculate_free_frames>
  800891:	89 c2                	mov    %eax,%edx
  800893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800896:	39 c2                	cmp    %eax,%edx
  800898:	74 17                	je     8008b1 <_main+0x879>
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	68 38 3a 80 00       	push   $0x803a38
  8008a2:	68 c1 00 00 00       	push   $0xc1
  8008a7:	68 bc 39 80 00       	push   $0x8039bc
  8008ac:	e8 13 02 00 00       	call   800ac4 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8008b1:	e8 15 17 00 00       	call   801fcb <sys_calculate_free_frames>
  8008b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008b9:	e8 58 17 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
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
  8008d8:	e8 cf 12 00 00       	call   801bac <malloc>
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
  800906:	68 d4 39 80 00       	push   $0x8039d4
  80090b:	68 cb 00 00 00       	push   $0xcb
  800910:	68 bc 39 80 00       	push   $0x8039bc
  800915:	e8 aa 01 00 00       	call   800ac4 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80091a:	e8 f7 16 00 00       	call   802016 <sys_pf_calculate_allocated_pages>
  80091f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800922:	74 17                	je     80093b <_main+0x903>
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 04 3a 80 00       	push   $0x803a04
  80092c:	68 cd 00 00 00       	push   $0xcd
  800931:	68 bc 39 80 00       	push   $0x8039bc
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
  800955:	e8 52 12 00 00       	call   801bac <malloc>
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  800960:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800963:	85 c0                	test   %eax,%eax
  800965:	74 17                	je     80097e <_main+0x946>
  800967:	83 ec 04             	sub    $0x4,%esp
  80096a:	68 48 3a 80 00       	push   $0x803a48
  80096f:	68 d6 00 00 00       	push   $0xd6
  800974:	68 bc 39 80 00       	push   $0x8039bc
  800979:	e8 46 01 00 00       	call   800ac4 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT (1) [PAGE ALLOCATOR] completed successfully.\n");
  80097e:	83 ec 0c             	sub    $0xc,%esp
  800981:	68 ac 3a 80 00       	push   $0x803aac
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
  80099c:	e8 b5 18 00 00       	call   802256 <sys_getenvindex>
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
  8009f9:	e8 65 16 00 00       	call   802063 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009fe:	83 ec 0c             	sub    $0xc,%esp
  800a01:	68 14 3b 80 00       	push   $0x803b14
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
  800a29:	68 3c 3b 80 00       	push   $0x803b3c
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
  800a5a:	68 64 3b 80 00       	push   $0x803b64
  800a5f:	e8 1d 03 00 00       	call   800d81 <cprintf>
  800a64:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a67:	a1 20 50 80 00       	mov    0x805020,%eax
  800a6c:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	50                   	push   %eax
  800a76:	68 bc 3b 80 00       	push   $0x803bbc
  800a7b:	e8 01 03 00 00       	call   800d81 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	68 14 3b 80 00       	push   $0x803b14
  800a8b:	e8 f1 02 00 00       	call   800d81 <cprintf>
  800a90:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a93:	e8 e5 15 00 00       	call   80207d <sys_enable_interrupt>

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
  800aab:	e8 72 17 00 00       	call   802222 <sys_destroy_env>
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
  800abc:	e8 c7 17 00 00       	call   802288 <sys_exit_env>
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
  800ae5:	68 d0 3b 80 00       	push   $0x803bd0
  800aea:	e8 92 02 00 00       	call   800d81 <cprintf>
  800aef:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800af2:	a1 00 50 80 00       	mov    0x805000,%eax
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	50                   	push   %eax
  800afe:	68 d5 3b 80 00       	push   $0x803bd5
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
  800b22:	68 f1 3b 80 00       	push   $0x803bf1
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
  800b51:	68 f4 3b 80 00       	push   $0x803bf4
  800b56:	6a 26                	push   $0x26
  800b58:	68 40 3c 80 00       	push   $0x803c40
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
  800c26:	68 4c 3c 80 00       	push   $0x803c4c
  800c2b:	6a 3a                	push   $0x3a
  800c2d:	68 40 3c 80 00       	push   $0x803c40
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
  800c99:	68 a0 3c 80 00       	push   $0x803ca0
  800c9e:	6a 44                	push   $0x44
  800ca0:	68 40 3c 80 00       	push   $0x803c40
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
  800cf3:	e8 12 12 00 00       	call   801f0a <sys_cputs>
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
  800d6a:	e8 9b 11 00 00       	call   801f0a <sys_cputs>
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
  800db4:	e8 aa 12 00 00       	call   802063 <sys_disable_interrupt>
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
  800dd4:	e8 a4 12 00 00       	call   80207d <sys_enable_interrupt>
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
  800e1e:	e8 0d 29 00 00       	call   803730 <__udivdi3>
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
  800e6e:	e8 cd 29 00 00       	call   803840 <__umoddi3>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	05 14 3f 80 00       	add    $0x803f14,%eax
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
  800fc9:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
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
  8010aa:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  8010b1:	85 f6                	test   %esi,%esi
  8010b3:	75 19                	jne    8010ce <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010b5:	53                   	push   %ebx
  8010b6:	68 25 3f 80 00       	push   $0x803f25
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
  8010cf:	68 2e 3f 80 00       	push   $0x803f2e
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
  8010fc:	be 31 3f 80 00       	mov    $0x803f31,%esi
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
	return NULL;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <InitializeUHeap>:
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap() {
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	if (FirstTimeFlag) {
  801b80:	a1 04 50 80 00       	mov    0x805004,%eax
  801b85:	85 c0                	test   %eax,%eax
  801b87:	74 0a                	je     801b93 <InitializeUHeap+0x16>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b90:	00 00 00 
	}
}
  801b93:	90                   	nop
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    

00801b96 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b9c:	83 ec 0c             	sub    $0xc,%esp
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	e8 7e 09 00 00       	call   802525 <sys_sbrk>
  801ba7:	83 c4 10             	add    $0x10,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <malloc>:
uint32 user_free_space;
uint32 block_pages;
int temp = 0;

void* malloc(uint32 size)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb2:	e8 c6 ff ff ff       	call   801b7d <InitializeUHeap>
	if (size == 0)
  801bb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bbb:	75 0a                	jne    801bc7 <malloc+0x1b>
		return NULL;
  801bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc2:	e9 3f 01 00 00       	jmp    801d06 <malloc+0x15a>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801bc7:	e8 ac 09 00 00       	call   802578 <sys_get_hard_limit>
  801bcc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 start_add;
	uint32 start_index;
	uint32 counter = 0;
  801bcf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 alloc_start = (((hard_limit + PAGE_SIZE) - USER_HEAP_START))/ PAGE_SIZE;
  801bd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801bde:	c1 e8 0c             	shr    $0xc,%eax
  801be1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
  801be4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801beb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	48                   	dec    %eax
  801bf4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801bf7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	f7 75 d8             	divl   -0x28(%ebp)
  801c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c05:	29 d0                	sub    %edx,%eax
  801c07:	89 45 d0             	mov    %eax,-0x30(%ebp)
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
  801c0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c0d:	c1 e8 0c             	shr    $0xc,%eax
  801c10:	89 45 cc             	mov    %eax,-0x34(%ebp)

	if (size == 0)
  801c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c17:	75 0a                	jne    801c23 <malloc+0x77>
		return NULL;
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1e:	e9 e3 00 00 00       	jmp    801d06 <malloc+0x15a>
	block_pages = (hard_limit- USER_HEAP_START) / PAGE_SIZE;
  801c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c26:	05 00 00 00 80       	add    $0x80000000,%eax
  801c2b:	c1 e8 0c             	shr    $0xc,%eax
  801c2e:	a3 20 51 80 00       	mov    %eax,0x805120

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c33:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c3a:	77 19                	ja     801c55 <malloc+0xa9>
	{
		uint32 add= (uint32)alloc_block_FF(size);
  801c3c:	83 ec 0c             	sub    $0xc,%esp
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	e8 60 0b 00 00       	call   8027a7 <alloc_block_FF>
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
	//	sys_allocate_user_mem(add, roundedUp_size);
		return (void*)add;
  801c4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c50:	e9 b1 00 00 00       	jmp    801d06 <malloc+0x15a>
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801c55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c5b:	eb 4d                	jmp    801caa <malloc+0xfe>
		{
			if (userArr[i].is_allocated == 0)
  801c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c60:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c67:	84 c0                	test   %al,%al
  801c69:	75 27                	jne    801c92 <malloc+0xe6>
			{
				counter++;
  801c6b:	ff 45 ec             	incl   -0x14(%ebp)

				if (counter == 1)
  801c6e:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801c72:	75 14                	jne    801c88 <malloc+0xdc>
				{
					start_add = (i*PAGE_SIZE)+USER_HEAP_START;
  801c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c77:	05 00 00 08 00       	add    $0x80000,%eax
  801c7c:	c1 e0 0c             	shl    $0xc,%eax
  801c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start_index=i;
  801c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
				}
				if (counter == number_of_pages)
  801c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8b:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801c8e:	75 17                	jne    801ca7 <malloc+0xfb>
				{
					break;
  801c90:	eb 21                	jmp    801cb3 <malloc+0x107>
				}
			}
			else if (userArr[i].is_allocated == 1)
  801c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c95:	8a 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%al
  801c9c:	3c 01                	cmp    $0x1,%al
  801c9e:	75 07                	jne    801ca7 <malloc+0xfb>
			{
				counter = 0;
  801ca0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return (void*)add;
	}

	else
	{
		for (uint32 i = alloc_start; i < NUM_OF_UHEAP_PAGES; i++)
  801ca7:	ff 45 e8             	incl   -0x18(%ebp)
  801caa:	81 7d e8 ff ff 01 00 	cmpl   $0x1ffff,-0x18(%ebp)
  801cb1:	76 aa                	jbe    801c5d <malloc+0xb1>
			else if (userArr[i].is_allocated == 1)
			{
				counter = 0;
			}
		}
		if (counter == number_of_pages)
  801cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb6:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801cb9:	75 46                	jne    801d01 <malloc+0x155>
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
  801cbb:	83 ec 08             	sub    $0x8,%esp
  801cbe:	ff 75 d0             	pushl  -0x30(%ebp)
  801cc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc4:	e8 93 08 00 00       	call   80255c <sys_allocate_user_mem>
  801cc9:	83 c4 10             	add    $0x10,%esp
	     	//update array
			userArr[start_index].Size=roundedUp_size;
  801ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cd2:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cdf:	eb 0e                	jmp    801cef <malloc+0x143>
			{
				userArr[i].is_allocated=1;
  801ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ce4:	c6 04 c5 40 51 80 00 	movb   $0x1,0x805140(,%eax,8)
  801ceb:	01 
		if (counter == number_of_pages)
		{
			sys_allocate_user_mem(start_add,roundedUp_size);
	     	//update array
			userArr[start_index].Size=roundedUp_size;
			for (uint32 i = start_index; i <number_of_pages+start_index ; i++)
  801cec:	ff 45 e4             	incl   -0x1c(%ebp)
  801cef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cfa:	77 e5                	ja     801ce1 <malloc+0x135>
			{
				userArr[i].is_allocated=1;
			}

			return (void*)start_add;
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	eb 05                	jmp    801d06 <malloc+0x15a>
		}
	}

	return NULL;
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS2 - #15] [2] USER HEAP - free() [User Side]

	uint32 hard_limit=sys_get_hard_limit();
  801d0e:	e8 65 08 00 00       	call   802578 <sys_get_hard_limit>
  801d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 va_cast=(uint32)virtual_address;
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
  801d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d20:	0f 84 c1 00 00 00    	je     801de7 <free+0xdf>
    	  return;

    if(va_cast >= USER_HEAP_START && va_cast < hard_limit) //block  allocator start-limit
  801d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	79 1b                	jns    801d48 <free+0x40>
  801d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d33:	73 13                	jae    801d48 <free+0x40>
    {
        free_block(virtual_address);
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	ff 75 08             	pushl  0x8(%ebp)
  801d3b:	e8 34 10 00 00       	call   802d74 <free_block>
  801d40:	83 c4 10             	add    $0x10,%esp
    	return;
  801d43:	e9 a6 00 00 00       	jmp    801dee <free+0xe6>
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
  801d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4b:	05 00 10 00 00       	add    $0x1000,%eax
  801d50:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d53:	0f 87 91 00 00 00    	ja     801dea <free+0xe2>
  801d59:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d60:	0f 87 84 00 00 00    	ja     801dea <free+0xe2>
    {
    	  va_cast=ROUNDDOWN(va_cast,PAGE_SIZE);
  801d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d69:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
  801d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7a:	05 00 00 00 80       	add    $0x80000000,%eax
  801d7f:	c1 e8 0c             	shr    $0xc,%eax
  801d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	  sz =userArr[index].Size;
  801d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d88:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  801d8f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    if (sz==0)
  801d92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d96:	74 55                	je     801ded <free+0xe5>
     {
    	return;
     }

	numPages=sz/PAGE_SIZE; //no of pages to deallocate
  801d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9b:	c1 e8 0c             	shr    $0xc,%eax
  801d9e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//edit array
	userArr[index].Size=0;
  801da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da4:	c7 04 c5 44 51 80 00 	movl   $0x0,0x805144(,%eax,8)
  801dab:	00 00 00 00 
	for(int i=index;i<numPages+index;i++)
  801daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db5:	eb 0e                	jmp    801dc5 <free+0xbd>
	{
		userArr[i].is_allocated=0;
  801db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dba:	c6 04 c5 40 51 80 00 	movb   $0x0,0x805140(,%eax,8)
  801dc1:	00 

	numPages=sz/PAGE_SIZE; //no of pages to deallocate

	//edit array
	userArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
  801dc2:	ff 45 f4             	incl   -0xc(%ebp)
  801dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcb:	01 c2                	add    %eax,%edx
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	39 c2                	cmp    %eax,%edx
  801dd2:	77 e3                	ja     801db7 <free+0xaf>
	{
		userArr[i].is_allocated=0;
	}

	sys_free_user_mem(va_cast,sz);
  801dd4:	83 ec 08             	sub    $0x8,%esp
  801dd7:	ff 75 e0             	pushl  -0x20(%ebp)
  801dda:	ff 75 ec             	pushl  -0x14(%ebp)
  801ddd:	e8 5e 07 00 00       	call   802540 <sys_free_user_mem>
  801de2:	83 c4 10             	add    $0x10,%esp
        free_block(virtual_address);
    	return;
    }

    else if(va_cast >= (hard_limit+PAGE_SIZE) && va_cast < USER_HEAP_MAX) //page allocator  limit+page - user max
    {
  801de5:	eb 07                	jmp    801dee <free+0xe6>
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;
    if(virtual_address==NULL)
    	  return;
  801de7:	90                   	nop
  801de8:	eb 04                	jmp    801dee <free+0xe6>
	sys_free_user_mem(va_cast,sz);
    }

    else
     {
    	return;
  801dea:	90                   	nop
  801deb:	eb 01                	jmp    801dee <free+0xe6>
    	  uint32 index=(va_cast-USER_HEAP_START)/PAGE_SIZE;
    	  sz =userArr[index].Size;

    if (sz==0)
     {
    	return;
  801ded:	90                   	nop
    else
     {
    	return;
      }

}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 18             	sub    $0x18,%esp
  801df6:	8b 45 10             	mov    0x10(%ebp),%eax
  801df9:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dfc:	e8 7c fd ff ff       	call   801b7d <InitializeUHeap>
	if (size == 0)
  801e01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e05:	75 07                	jne    801e0e <smalloc+0x1e>
		return NULL;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	eb 17                	jmp    801e25 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	68 90 40 80 00       	push   $0x804090
  801e16:	68 ad 00 00 00       	push   $0xad
  801e1b:	68 b6 40 80 00       	push   $0x8040b6
  801e20:	e8 9f ec ff ff       	call   800ac4 <_panic>
	return NULL;
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2d:	e8 4b fd ff ff       	call   801b7d <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e32:	83 ec 04             	sub    $0x4,%esp
  801e35:	68 c4 40 80 00       	push   $0x8040c4
  801e3a:	68 ba 00 00 00       	push   $0xba
  801e3f:	68 b6 40 80 00       	push   $0x8040b6
  801e44:	e8 7b ec ff ff       	call   800ac4 <_panic>

00801e49 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4f:	e8 29 fd ff ff       	call   801b7d <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	68 e8 40 80 00       	push   $0x8040e8
  801e5c:	68 d8 00 00 00       	push   $0xd8
  801e61:	68 b6 40 80 00       	push   $0x8040b6
  801e66:	e8 59 ec ff ff       	call   800ac4 <_panic>

00801e6b <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 10 41 80 00       	push   $0x804110
  801e79:	68 ea 00 00 00       	push   $0xea
  801e7e:	68 b6 40 80 00       	push   $0x8040b6
  801e83:	e8 3c ec ff ff       	call   800ac4 <_panic>

00801e88 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	68 34 41 80 00       	push   $0x804134
  801e96:	68 f2 00 00 00       	push   $0xf2
  801e9b:	68 b6 40 80 00       	push   $0x8040b6
  801ea0:	e8 1f ec ff ff       	call   800ac4 <_panic>

00801ea5 <shrink>:

}
void shrink(uint32 newSize) {
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	68 34 41 80 00       	push   $0x804134
  801eb3:	68 f6 00 00 00       	push   $0xf6
  801eb8:	68 b6 40 80 00       	push   $0x8040b6
  801ebd:	e8 02 ec ff ff       	call   800ac4 <_panic>

00801ec2 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	68 34 41 80 00       	push   $0x804134
  801ed0:	68 fa 00 00 00       	push   $0xfa
  801ed5:	68 b6 40 80 00       	push   $0x8040b6
  801eda:	e8 e5 eb ff ff       	call   800ac4 <_panic>

00801edf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	57                   	push   %edi
  801ee3:	56                   	push   %esi
  801ee4:	53                   	push   %ebx
  801ee5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801efa:	cd 30                	int    $0x30
  801efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    

00801f0a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	8b 45 10             	mov    0x10(%ebp),%eax
  801f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f16:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	52                   	push   %edx
  801f22:	ff 75 0c             	pushl  0xc(%ebp)
  801f25:	50                   	push   %eax
  801f26:	6a 00                	push   $0x0
  801f28:	e8 b2 ff ff ff       	call   801edf <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 01                	push   $0x1
  801f42:	e8 98 ff ff ff       	call   801edf <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	52                   	push   %edx
  801f5c:	50                   	push   %eax
  801f5d:	6a 05                	push   $0x5
  801f5f:	e8 7b ff ff ff       	call   801edf <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f6e:	8b 75 18             	mov    0x18(%ebp),%esi
  801f71:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	56                   	push   %esi
  801f7e:	53                   	push   %ebx
  801f7f:	51                   	push   %ecx
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	6a 06                	push   $0x6
  801f84:	e8 56 ff ff ff       	call   801edf <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    

00801f93 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	52                   	push   %edx
  801fa3:	50                   	push   %eax
  801fa4:	6a 07                	push   $0x7
  801fa6:	e8 34 ff ff ff       	call   801edf <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	6a 08                	push   $0x8
  801fc1:	e8 19 ff ff ff       	call   801edf <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 09                	push   $0x9
  801fda:	e8 00 ff ff ff       	call   801edf <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 0a                	push   $0xa
  801ff3:	e8 e7 fe ff ff       	call   801edf <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 0b                	push   $0xb
  80200c:	e8 ce fe ff ff       	call   801edf <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 0c                	push   $0xc
  802025:	e8 b5 fe ff ff       	call   801edf <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 08             	pushl  0x8(%ebp)
  80203d:	6a 0d                	push   $0xd
  80203f:	e8 9b fe ff ff       	call   801edf <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 0e                	push   $0xe
  802058:	e8 82 fe ff ff       	call   801edf <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	90                   	nop
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 11                	push   $0x11
  802072:	e8 68 fe ff ff       	call   801edf <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	90                   	nop
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 12                	push   $0x12
  80208c:	e8 4e fe ff ff       	call   801edf <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	90                   	nop
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_cputc>:


void
sys_cputc(const char c)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	50                   	push   %eax
  8020b0:	6a 13                	push   $0x13
  8020b2:	e8 28 fe ff ff       	call   801edf <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	90                   	nop
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 14                	push   $0x14
  8020cc:	e8 0e fe ff ff       	call   801edf <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	ff 75 0c             	pushl  0xc(%ebp)
  8020e6:	50                   	push   %eax
  8020e7:	6a 15                	push   $0x15
  8020e9:	e8 f1 fd ff ff       	call   801edf <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	52                   	push   %edx
  802103:	50                   	push   %eax
  802104:	6a 18                	push   $0x18
  802106:	e8 d4 fd ff ff       	call   801edf <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802113:	8b 55 0c             	mov    0xc(%ebp),%edx
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	52                   	push   %edx
  802120:	50                   	push   %eax
  802121:	6a 16                	push   $0x16
  802123:	e8 b7 fd ff ff       	call   801edf <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	90                   	nop
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	52                   	push   %edx
  80213e:	50                   	push   %eax
  80213f:	6a 17                	push   $0x17
  802141:	e8 99 fd ff ff       	call   801edf <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	90                   	nop
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	8b 45 10             	mov    0x10(%ebp),%eax
  802155:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802158:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80215b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	51                   	push   %ecx
  802165:	52                   	push   %edx
  802166:	ff 75 0c             	pushl  0xc(%ebp)
  802169:	50                   	push   %eax
  80216a:	6a 19                	push   $0x19
  80216c:	e8 6e fd ff ff       	call   801edf <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	52                   	push   %edx
  802186:	50                   	push   %eax
  802187:	6a 1a                	push   $0x1a
  802189:	e8 51 fd ff ff       	call   801edf <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802196:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	51                   	push   %ecx
  8021a4:	52                   	push   %edx
  8021a5:	50                   	push   %eax
  8021a6:	6a 1b                	push   $0x1b
  8021a8:	e8 32 fd ff ff       	call   801edf <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 1c                	push   $0x1c
  8021c5:	e8 15 fd ff ff       	call   801edf <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 1d                	push   $0x1d
  8021de:	e8 fc fc ff ff       	call   801edf <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	6a 00                	push   $0x0
  8021f0:	ff 75 14             	pushl  0x14(%ebp)
  8021f3:	ff 75 10             	pushl  0x10(%ebp)
  8021f6:	ff 75 0c             	pushl  0xc(%ebp)
  8021f9:	50                   	push   %eax
  8021fa:	6a 1e                	push   $0x1e
  8021fc:	e8 de fc ff ff       	call   801edf <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	50                   	push   %eax
  802215:	6a 1f                	push   $0x1f
  802217:	e8 c3 fc ff ff       	call   801edf <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
}
  80221f:	90                   	nop
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	50                   	push   %eax
  802231:	6a 20                	push   $0x20
  802233:	e8 a7 fc ff ff       	call   801edf <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 02                	push   $0x2
  80224c:	e8 8e fc ff ff       	call   801edf <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 03                	push   $0x3
  802265:	e8 75 fc ff ff       	call   801edf <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 04                	push   $0x4
  80227e:	e8 5c fc ff ff       	call   801edf <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_exit_env>:


void sys_exit_env(void)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 21                	push   $0x21
  802297:	e8 43 fc ff ff       	call   801edf <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	90                   	nop
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ab:	8d 50 04             	lea    0x4(%eax),%edx
  8022ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	52                   	push   %edx
  8022b8:	50                   	push   %eax
  8022b9:	6a 22                	push   $0x22
  8022bb:	e8 1f fc ff ff       	call   801edf <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022cc:	89 01                	mov    %eax,(%ecx)
  8022ce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	c9                   	leave  
  8022d5:	c2 04 00             	ret    $0x4

008022d8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	ff 75 10             	pushl  0x10(%ebp)
  8022e2:	ff 75 0c             	pushl  0xc(%ebp)
  8022e5:	ff 75 08             	pushl  0x8(%ebp)
  8022e8:	6a 10                	push   $0x10
  8022ea:	e8 f0 fb ff ff       	call   801edf <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f2:	90                   	nop
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 23                	push   $0x23
  802304:	e8 d6 fb ff ff       	call   801edf <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80231a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	50                   	push   %eax
  802327:	6a 24                	push   $0x24
  802329:	e8 b1 fb ff ff       	call   801edf <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
	return ;
  802331:	90                   	nop
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <rsttst>:
void rsttst()
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 26                	push   $0x26
  802343:	e8 97 fb ff ff       	call   801edf <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
	return ;
  80234b:	90                   	nop
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	8b 45 14             	mov    0x14(%ebp),%eax
  802357:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80235a:	8b 55 18             	mov    0x18(%ebp),%edx
  80235d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802361:	52                   	push   %edx
  802362:	50                   	push   %eax
  802363:	ff 75 10             	pushl  0x10(%ebp)
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 25                	push   $0x25
  80236e:	e8 6c fb ff ff       	call   801edf <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return ;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <chktst>:
void chktst(uint32 n)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	ff 75 08             	pushl  0x8(%ebp)
  802387:	6a 27                	push   $0x27
  802389:	e8 51 fb ff ff       	call   801edf <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
	return ;
  802391:	90                   	nop
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <inctst>:

void inctst()
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 28                	push   $0x28
  8023a3:	e8 37 fb ff ff       	call   801edf <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ab:	90                   	nop
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <gettst>:
uint32 gettst()
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 29                	push   $0x29
  8023bd:	e8 1d fb ff ff       	call   801edf <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 2a                	push   $0x2a
  8023d9:	e8 01 fb ff ff       	call   801edf <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
  8023e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023e4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023e8:	75 07                	jne    8023f1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ef:	eb 05                	jmp    8023f6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 2a                	push   $0x2a
  80240a:	e8 d0 fa ff ff       	call   801edf <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
  802412:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802415:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802419:	75 07                	jne    802422 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80241b:	b8 01 00 00 00       	mov    $0x1,%eax
  802420:	eb 05                	jmp    802427 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 2a                	push   $0x2a
  80243b:	e8 9f fa ff ff       	call   801edf <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
  802443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802446:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80244a:	75 07                	jne    802453 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80244c:	b8 01 00 00 00       	mov    $0x1,%eax
  802451:	eb 05                	jmp    802458 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 2a                	push   $0x2a
  80246c:	e8 6e fa ff ff       	call   801edf <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
  802474:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802477:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80247b:	75 07                	jne    802484 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	eb 05                	jmp    802489 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	ff 75 08             	pushl  0x8(%ebp)
  802499:	6a 2b                	push   $0x2b
  80249b:	e8 3f fa ff ff       	call   801edf <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a3:	90                   	nop
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	6a 00                	push   $0x0
  8024b8:	53                   	push   %ebx
  8024b9:	51                   	push   %ecx
  8024ba:	52                   	push   %edx
  8024bb:	50                   	push   %eax
  8024bc:	6a 2c                	push   $0x2c
  8024be:	e8 1c fa ff ff       	call   801edf <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	52                   	push   %edx
  8024db:	50                   	push   %eax
  8024dc:	6a 2d                	push   $0x2d
  8024de:	e8 fc f9 ff ff       	call   801edf <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024eb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	51                   	push   %ecx
  8024f7:	ff 75 10             	pushl  0x10(%ebp)
  8024fa:	52                   	push   %edx
  8024fb:	50                   	push   %eax
  8024fc:	6a 2e                	push   $0x2e
  8024fe:	e8 dc f9 ff ff       	call   801edf <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	ff 75 10             	pushl  0x10(%ebp)
  802512:	ff 75 0c             	pushl  0xc(%ebp)
  802515:	ff 75 08             	pushl  0x8(%ebp)
  802518:	6a 0f                	push   $0xf
  80251a:	e8 c0 f9 ff ff       	call   801edf <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
	return ;
  802522:	90                   	nop
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	50                   	push   %eax
  802534:	6a 2f                	push   $0x2f
  802536:	e8 a4 f9 ff ff       	call   801edf <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp

}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	ff 75 0c             	pushl  0xc(%ebp)
  80254c:	ff 75 08             	pushl  0x8(%ebp)
  80254f:	6a 30                	push   $0x30
  802551:	e8 89 f9 ff ff       	call   801edf <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
	return;
  802559:	90                   	nop
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	ff 75 0c             	pushl  0xc(%ebp)
  802568:	ff 75 08             	pushl  0x8(%ebp)
  80256b:	6a 31                	push   $0x31
  80256d:	e8 6d f9 ff ff       	call   801edf <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
	return;
  802575:	90                   	nop
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 32                	push   $0x32
  802587:	e8 53 f9 ff ff       	call   801edf <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	50                   	push   %eax
  8025a0:	6a 33                	push   $0x33
  8025a2:	e8 38 f9 ff ff       	call   801edf <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
}
  8025aa:	90                   	nop
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	83 e8 10             	sub    $0x10,%eax
  8025b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size;
  8025bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	83 e8 10             	sub    $0x10,%eax
  8025cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free;
  8025d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d5:	8a 40 04             	mov    0x4(%eax),%al
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ea:	83 f8 02             	cmp    $0x2,%eax
  8025ed:	74 2b                	je     80261a <alloc_block+0x40>
  8025ef:	83 f8 02             	cmp    $0x2,%eax
  8025f2:	7f 07                	jg     8025fb <alloc_block+0x21>
  8025f4:	83 f8 01             	cmp    $0x1,%eax
  8025f7:	74 0e                	je     802607 <alloc_block+0x2d>
  8025f9:	eb 58                	jmp    802653 <alloc_block+0x79>
  8025fb:	83 f8 03             	cmp    $0x3,%eax
  8025fe:	74 2d                	je     80262d <alloc_block+0x53>
  802600:	83 f8 04             	cmp    $0x4,%eax
  802603:	74 3b                	je     802640 <alloc_block+0x66>
  802605:	eb 4c                	jmp    802653 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	ff 75 08             	pushl  0x8(%ebp)
  80260d:	e8 95 01 00 00       	call   8027a7 <alloc_block_FF>
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802618:	eb 4a                	jmp    802664 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	ff 75 08             	pushl  0x8(%ebp)
  802620:	e8 32 07 00 00       	call   802d57 <alloc_block_NF>
  802625:	83 c4 10             	add    $0x10,%esp
  802628:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80262b:	eb 37                	jmp    802664 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80262d:	83 ec 0c             	sub    $0xc,%esp
  802630:	ff 75 08             	pushl  0x8(%ebp)
  802633:	e8 a3 04 00 00       	call   802adb <alloc_block_BF>
  802638:	83 c4 10             	add    $0x10,%esp
  80263b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80263e:	eb 24                	jmp    802664 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802640:	83 ec 0c             	sub    $0xc,%esp
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	e8 ef 06 00 00       	call   802d3a <alloc_block_WF>
  80264b:	83 c4 10             	add    $0x10,%esp
  80264e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802651:	eb 11                	jmp    802664 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802653:	83 ec 0c             	sub    $0xc,%esp
  802656:	68 44 41 80 00       	push   $0x804144
  80265b:	e8 21 e7 ff ff       	call   800d81 <cprintf>
  802660:	83 c4 10             	add    $0x10,%esp
		break;
  802663:	90                   	nop
	}
	return va;
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	68 64 41 80 00       	push   $0x804164
  802677:	e8 05 e7 ff ff       	call   800d81 <cprintf>
  80267c:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
  80267f:	83 ec 0c             	sub    $0xc,%esp
  802682:	68 8f 41 80 00       	push   $0x80418f
  802687:	e8 f5 e6 ff ff       	call   800d81 <cprintf>
  80268c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802695:	eb 26                	jmp    8026bd <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8a 40 04             	mov    0x4(%eax),%al
  80269d:	0f b6 d0             	movzbl %al,%edx
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	52                   	push   %edx
  8026a9:	50                   	push   %eax
  8026aa:	68 a7 41 80 00       	push   $0x8041a7
  8026af:	e8 cd e6 ff ff       	call   800d81 <cprintf>
  8026b4:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c1:	74 08                	je     8026cb <print_blocks_list+0x62>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 08             	mov    0x8(%eax),%eax
  8026c9:	eb 05                	jmp    8026d0 <print_blocks_list+0x67>
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	89 45 10             	mov    %eax,0x10(%ebp)
  8026d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	75 bd                	jne    802697 <print_blocks_list+0x2e>
  8026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026de:	75 b7                	jne    802697 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	68 64 41 80 00       	push   $0x804164
  8026e8:	e8 94 e6 ff ff       	call   800d81 <cprintf>
  8026ed:	83 c4 10             	add    $0x10,%esp

}
  8026f0:	90                   	nop
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
  8026f6:	83 ec 18             	sub    $0x18,%esp
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
  8026f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026fd:	0f 84 a1 00 00 00    	je     8027a4 <initialize_dynamic_allocator+0xb1>
		return;
	is_initialized=1;
  802703:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  80270a:	00 00 00 
	LIST_INIT(&list);
  80270d:	c7 05 40 51 90 00 00 	movl   $0x0,0x905140
  802714:	00 00 00 
  802717:	c7 05 44 51 90 00 00 	movl   $0x0,0x905144
  80271e:	00 00 00 
  802721:	c7 05 4c 51 90 00 00 	movl   $0x0,0x90514c
  802728:	00 00 00 
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	blk->is_free = 1;
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	blk->size = initSizeOfAllocatedSpace;
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273e:	89 10                	mov    %edx,(%eax)
	LIST_INSERT_TAIL(&list, blk);
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	75 14                	jne    80275a <initialize_dynamic_allocator+0x67>
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	68 c0 41 80 00       	push   $0x8041c0
  80274e:	6a 64                	push   $0x64
  802750:	68 e3 41 80 00       	push   $0x8041e3
  802755:	e8 6a e3 ff ff       	call   800ac4 <_panic>
  80275a:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	89 50 0c             	mov    %edx,0xc(%eax)
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 0c             	mov    0xc(%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 0d                	je     80277d <initialize_dynamic_allocator+0x8a>
  802770:	a1 44 51 90 00       	mov    0x905144,%eax
  802775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802778:	89 50 08             	mov    %edx,0x8(%eax)
  80277b:	eb 08                	jmp    802785 <initialize_dynamic_allocator+0x92>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	a3 40 51 90 00       	mov    %eax,0x905140
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	a3 44 51 90 00       	mov    %eax,0x905144
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802797:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80279c:	40                   	inc    %eax
  80279d:	a3 4c 51 90 00       	mov    %eax,0x90514c
  8027a2:	eb 01                	jmp    8027a5 <initialize_dynamic_allocator+0xb2>
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
  8027a4:	90                   	nop
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 38             	sub    $0x38,%esp

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
  8027ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b1:	75 0a                	jne    8027bd <alloc_block_FF+0x16>
	{
		return NULL;
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b8:	e9 1c 03 00 00       	jmp    802ad9 <alloc_block_FF+0x332>
	}
	if (!is_initialized)
  8027bd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	75 40                	jne    802806 <alloc_block_FF+0x5f>
	{
	uint32 required_size = size + sizeOfMetaData();
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	83 c0 10             	add    $0x10,%eax
  8027cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 da_start = (uint32)sbrk(required_size);
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	83 ec 0c             	sub    $0xc,%esp
  8027d5:	50                   	push   %eax
  8027d6:	e8 bb f3 ff ff       	call   801b96 <sbrk>
  8027db:	83 c4 10             	add    $0x10,%esp
  8027de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
  8027e1:	83 ec 0c             	sub    $0xc,%esp
  8027e4:	6a 00                	push   $0x0
  8027e6:	e8 ab f3 ff ff       	call   801b96 <sbrk>
  8027eb:	83 c4 10             	add    $0x10,%esp
  8027ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	initialize_dynamic_allocator(da_start, da_break - da_start);
  8027f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8027f7:	83 ec 08             	sub    $0x8,%esp
  8027fa:	50                   	push   %eax
  8027fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8027fe:	e8 f0 fe ff ff       	call   8026f3 <initialize_dynamic_allocator>
  802803:	83 c4 10             	add    $0x10,%esp
	}

	LIST_FOREACH(iterator, &list)
  802806:	a1 40 51 90 00       	mov    0x905140,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	e9 1e 01 00 00       	jmp    802931 <alloc_block_FF+0x18a>
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	8d 50 10             	lea    0x10(%eax),%edx
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	39 c2                	cmp    %eax,%edx
  802820:	75 1c                	jne    80283e <alloc_block_FF+0x97>
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8a 40 04             	mov    0x4(%eax),%al
  802828:	3c 01                	cmp    $0x1,%al
  80282a:	75 12                	jne    80283e <alloc_block_FF+0x97>
		{
			iterator->is_free = 0;
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator+1;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	83 c0 10             	add    $0x10,%eax
  802839:	e9 9b 02 00 00       	jmp    802ad9 <alloc_block_FF+0x332>
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	8d 50 10             	lea    0x10(%eax),%edx
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	39 c2                	cmp    %eax,%edx
  80284b:	0f 83 d8 00 00 00    	jae    802929 <alloc_block_FF+0x182>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8a 40 04             	mov    0x4(%eax),%al
  802857:	3c 01                	cmp    $0x1,%al
  802859:	0f 85 ca 00 00 00    	jne    802929 <alloc_block_FF+0x182>
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 00                	mov    (%eax),%eax
  802864:	2b 45 08             	sub    0x8(%ebp),%eax
  802867:	83 e8 10             	sub    $0x10,%eax
  80286a:	83 f8 0f             	cmp    $0xf,%eax
  80286d:	0f 86 a4 00 00 00    	jbe    802917 <alloc_block_FF+0x170>
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
  802873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	83 c0 10             	add    $0x10,%eax
  80287e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	2b 45 08             	sub    0x8(%ebp),%eax
  802889:	8d 50 f0             	lea    -0x10(%eax),%edx
  80288c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80288f:	89 10                	mov    %edx,(%eax)
			newBlockAfterSplit->is_free=1;
  802891:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802894:	c6 40 04 01          	movb   $0x1,0x4(%eax)

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  802898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289c:	74 06                	je     8028a4 <alloc_block_FF+0xfd>
  80289e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8028a2:	75 17                	jne    8028bb <alloc_block_FF+0x114>
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	68 fc 41 80 00       	push   $0x8041fc
  8028ac:	68 8f 00 00 00       	push   $0x8f
  8028b1:	68 e3 41 80 00       	push   $0x8041e3
  8028b6:	e8 09 e2 ff ff       	call   800ac4 <_panic>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 50 08             	mov    0x8(%eax),%edx
  8028c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c4:	89 50 08             	mov    %edx,0x8(%eax)
  8028c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ca:	8b 40 08             	mov    0x8(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 0c                	je     8028dd <alloc_block_FF+0x136>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 08             	mov    0x8(%eax),%eax
  8028d7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028da:	89 50 0c             	mov    %edx,0xc(%eax)
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028e3:	89 50 08             	mov    %edx,0x8(%eax)
  8028e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ec:	89 50 0c             	mov    %edx,0xc(%eax)
  8028ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	75 08                	jne    802901 <alloc_block_FF+0x15a>
  8028f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028fc:	a3 44 51 90 00       	mov    %eax,0x905144
  802901:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802906:	40                   	inc    %eax
  802907:	a3 4c 51 90 00       	mov    %eax,0x90514c
		    iterator->size = size + sizeOfMetaData();
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8d 50 10             	lea    0x10(%eax),%edx
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	89 10                	mov    %edx,(%eax)

			}
			iterator->is_free =0;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		    return iterator+1;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	83 c0 10             	add    $0x10,%eax
  802924:	e9 b0 01 00 00       	jmp    802ad9 <alloc_block_FF+0x332>
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
  802929:	a1 48 51 90 00       	mov    0x905148,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	74 08                	je     80293f <alloc_block_FF+0x198>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 40 08             	mov    0x8(%eax),%eax
  80293d:	eb 05                	jmp    802944 <alloc_block_FF+0x19d>
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	a3 48 51 90 00       	mov    %eax,0x905148
  802949:	a1 48 51 90 00       	mov    0x905148,%eax
  80294e:	85 c0                	test   %eax,%eax
  802950:	0f 85 bd fe ff ff    	jne    802813 <alloc_block_FF+0x6c>
  802956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295a:	0f 85 b3 fe ff ff    	jne    802813 <alloc_block_FF+0x6c>
			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	83 c0 10             	add    $0x10,%eax
  802966:	83 ec 0c             	sub    $0xc,%esp
  802969:	50                   	push   %eax
  80296a:	e8 27 f2 ff ff       	call   801b96 <sbrk>
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void* newbrk = sbrk(0);
  802975:	83 ec 0c             	sub    $0xc,%esp
  802978:	6a 00                	push   $0x0
  80297a:	e8 17 f2 ff ff       	call   801b96 <sbrk>
  80297f:	83 c4 10             	add    $0x10,%esp
  802982:	89 45 e0             	mov    %eax,-0x20(%ebp)

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);
  802985:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298b:	29 c2                	sub    %eax,%edx
  80298d:	89 d0                	mov    %edx,%eax
  80298f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if( oldbrk != (void*)-1)
  802992:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802996:	0f 84 38 01 00 00    	je     802ad4 <alloc_block_FF+0x32d>
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
  80299c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			LIST_INSERT_TAIL(&list, newBlock);
  8029a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029a6:	75 17                	jne    8029bf <alloc_block_FF+0x218>
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	68 c0 41 80 00       	push   $0x8041c0
  8029b0:	68 9f 00 00 00       	push   $0x9f
  8029b5:	68 e3 41 80 00       	push   $0x8041e3
  8029ba:	e8 05 e1 ff ff       	call   800ac4 <_panic>
  8029bf:	8b 15 44 51 90 00    	mov    0x905144,%edx
  8029c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c8:	89 50 0c             	mov    %edx,0xc(%eax)
  8029cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	74 0d                	je     8029e2 <alloc_block_FF+0x23b>
  8029d5:	a1 44 51 90 00       	mov    0x905144,%eax
  8029da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029dd:	89 50 08             	mov    %edx,0x8(%eax)
  8029e0:	eb 08                	jmp    8029ea <alloc_block_FF+0x243>
  8029e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e5:	a3 40 51 90 00       	mov    %eax,0x905140
  8029ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ed:	a3 44 51 90 00       	mov    %eax,0x905144
  8029f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029fc:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802a01:	40                   	inc    %eax
  802a02:	a3 4c 51 90 00       	mov    %eax,0x90514c
			newBlock->size = size + sizeOfMetaData();
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	8d 50 10             	lea    0x10(%eax),%edx
  802a0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a10:	89 10                	mov    %edx,(%eax)
			newBlock->is_free = 0;
  802a12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a15:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			if(brksz -(size + sizeOfMetaData()) != 0)
  802a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a1c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1f:	83 f8 10             	cmp    $0x10,%eax
  802a22:	0f 84 a4 00 00 00    	je     802acc <alloc_block_FF+0x325>
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
  802a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2e:	83 e8 10             	sub    $0x10,%eax
  802a31:	83 f8 0f             	cmp    $0xf,%eax
  802a34:	0f 86 8a 00 00 00    	jbe    802ac4 <alloc_block_FF+0x31d>
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
  802a3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	01 d0                	add    %edx,%eax
  802a42:	83 c0 10             	add    $0x10,%eax
  802a45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
  802a48:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a4c:	75 17                	jne    802a65 <alloc_block_FF+0x2be>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 c0 41 80 00       	push   $0x8041c0
  802a56:	68 a7 00 00 00       	push   $0xa7
  802a5b:	68 e3 41 80 00       	push   $0x8041e3
  802a60:	e8 5f e0 ff ff       	call   800ac4 <_panic>
  802a65:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802a6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a6e:	89 50 0c             	mov    %edx,0xc(%eax)
  802a71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	74 0d                	je     802a88 <alloc_block_FF+0x2e1>
  802a7b:	a1 44 51 90 00       	mov    0x905144,%eax
  802a80:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a83:	89 50 08             	mov    %edx,0x8(%eax)
  802a86:	eb 08                	jmp    802a90 <alloc_block_FF+0x2e9>
  802a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a8b:	a3 40 51 90 00       	mov    %eax,0x905140
  802a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a93:	a3 44 51 90 00       	mov    %eax,0x905144
  802a98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802aa2:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802aa7:	40                   	inc    %eax
  802aa8:	a3 4c 51 90 00       	mov    %eax,0x90514c
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
  802aad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ab0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab3:	8d 50 f0             	lea    -0x10(%eax),%edx
  802ab6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ab9:	89 10                	mov    %edx,(%eax)
					newBlockAfterbrk->is_free = 1;
  802abb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802abe:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802ac2:	eb 08                	jmp    802acc <alloc_block_FF+0x325>
				}
				else
				{
					newBlock->size= brksz;
  802ac4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802aca:	89 10                	mov    %edx,(%eax)
				}

			}

			return newBlock+1;
  802acc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802acf:	83 c0 10             	add    $0x10,%eax
  802ad2:	eb 05                	jmp    802ad9 <alloc_block_FF+0x332>
		}
		else
		{
			return NULL;
  802ad4:	b8 00 00 00 00       	mov    $0x0,%eax
		}


	return NULL;
}
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 18             	sub    $0x18,%esp
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;
  802ae1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (size == 0)
  802ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aec:	75 0a                	jne    802af8 <alloc_block_BF+0x1d>
	{
		return NULL;
  802aee:	b8 00 00 00 00       	mov    $0x0,%eax
  802af3:	e9 40 02 00 00       	jmp    802d38 <alloc_block_BF+0x25d>
	}

	LIST_FOREACH(iterator, &list)
  802af8:	a1 40 51 90 00       	mov    0x905140,%eax
  802afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b00:	eb 66                	jmp    802b68 <alloc_block_BF+0x8d>
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8a 40 04             	mov    0x4(%eax),%al
  802b08:	3c 01                	cmp    $0x1,%al
  802b0a:	75 21                	jne    802b2d <alloc_block_BF+0x52>
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	8d 50 10             	lea    0x10(%eax),%edx
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	39 c2                	cmp    %eax,%edx
  802b19:	75 12                	jne    802b2d <alloc_block_BF+0x52>
		{
			iterator->is_free = 0;
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			return iterator + 1;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	83 c0 10             	add    $0x10,%eax
  802b28:	e9 0b 02 00 00       	jmp    802d38 <alloc_block_BF+0x25d>
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8a 40 04             	mov    0x4(%eax),%al
  802b33:	3c 01                	cmp    $0x1,%al
  802b35:	75 29                	jne    802b60 <alloc_block_BF+0x85>
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	8d 50 10             	lea    0x10(%eax),%edx
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	39 c2                	cmp    %eax,%edx
  802b44:	77 1a                	ja     802b60 <alloc_block_BF+0x85>
		{
			if (BF == NULL || iterator->size < BF->size)
  802b46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4a:	74 0e                	je     802b5a <alloc_block_BF+0x7f>
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 10                	mov    (%eax),%edx
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	39 c2                	cmp    %eax,%edx
  802b58:	73 06                	jae    802b60 <alloc_block_BF+0x85>
			{
				BF = iterator;
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
  802b60:	a1 48 51 90 00       	mov    0x905148,%eax
  802b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6c:	74 08                	je     802b76 <alloc_block_BF+0x9b>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	eb 05                	jmp    802b7b <alloc_block_BF+0xa0>
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7b:	a3 48 51 90 00       	mov    %eax,0x905148
  802b80:	a1 48 51 90 00       	mov    0x905148,%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	0f 85 75 ff ff ff    	jne    802b02 <alloc_block_BF+0x27>
  802b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b91:	0f 85 6b ff ff ff    	jne    802b02 <alloc_block_BF+0x27>
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
  802b97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9b:	0f 84 f8 00 00 00    	je     802c99 <alloc_block_BF+0x1be>
	{
		if (size + sizeOfMetaData() <= BF->size)
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8d 50 10             	lea    0x10(%eax),%edx
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	39 c2                	cmp    %eax,%edx
  802bae:	0f 87 e5 00 00 00    	ja     802c99 <alloc_block_BF+0x1be>
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
  802bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbc:	83 e8 10             	sub    $0x10,%eax
  802bbf:	83 f8 0f             	cmp    $0xf,%eax
  802bc2:	0f 86 bf 00 00 00    	jbe    802c87 <alloc_block_BF+0x1ac>
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
  802bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	01 d0                	add    %edx,%eax
  802bd0:	83 c0 10             	add    $0x10,%eax
  802bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				newBlockAfterSplit->size = 0;
  802bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	2b 45 08             	sub    0x8(%ebp),%eax
  802be7:	8d 50 f0             	lea    -0x10(%eax),%edx
  802bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bed:	89 10                	mov    %edx,(%eax)
				newBlockAfterSplit->is_free = 1;
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);
  802bf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfa:	74 06                	je     802c02 <alloc_block_BF+0x127>
  802bfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c00:	75 17                	jne    802c19 <alloc_block_BF+0x13e>
  802c02:	83 ec 04             	sub    $0x4,%esp
  802c05:	68 fc 41 80 00       	push   $0x8041fc
  802c0a:	68 e3 00 00 00       	push   $0xe3
  802c0f:	68 e3 41 80 00       	push   $0x8041e3
  802c14:	e8 ab de ff ff       	call   800ac4 <_panic>
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	8b 50 08             	mov    0x8(%eax),%edx
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	89 50 08             	mov    %edx,0x8(%eax)
  802c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c28:	8b 40 08             	mov    0x8(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 0c                	je     802c3b <alloc_block_BF+0x160>
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	8b 40 08             	mov    0x8(%eax),%eax
  802c35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c38:	89 50 0c             	mov    %edx,0xc(%eax)
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c41:	89 50 08             	mov    %edx,0x8(%eax)
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4a:	89 50 0c             	mov    %edx,0xc(%eax)
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 08             	mov    0x8(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	75 08                	jne    802c5f <alloc_block_BF+0x184>
  802c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5a:	a3 44 51 90 00       	mov    %eax,0x905144
  802c5f:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802c64:	40                   	inc    %eax
  802c65:	a3 4c 51 90 00       	mov    %eax,0x90514c

				BF->size = size + sizeOfMetaData();
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8d 50 10             	lea    0x10(%eax),%edx
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	89 10                	mov    %edx,(%eax)
				BF->is_free = 0;
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	c6 40 04 00          	movb   $0x0,0x4(%eax)

				return BF + 1;
  802c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7f:	83 c0 10             	add    $0x10,%eax
  802c82:	e9 b1 00 00 00       	jmp    802d38 <alloc_block_BF+0x25d>
			}
			else
			{
				BF->is_free = 0;
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				return BF + 1;
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	83 c0 10             	add    $0x10,%eax
  802c94:	e9 9f 00 00 00       	jmp    802d38 <alloc_block_BF+0x25d>
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	83 c0 10             	add    $0x10,%eax
  802c9f:	83 ec 0c             	sub    $0xc,%esp
  802ca2:	50                   	push   %eax
  802ca3:	e8 ee ee ff ff       	call   801b96 <sbrk>
  802ca8:	83 c4 10             	add    $0x10,%esp
  802cab:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (newBlock != (void*) -1)
  802cae:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802cb2:	74 7f                	je     802d33 <alloc_block_BF+0x258>
	{
		LIST_INSERT_TAIL(&list, newBlock);
  802cb4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cb8:	75 17                	jne    802cd1 <alloc_block_BF+0x1f6>
  802cba:	83 ec 04             	sub    $0x4,%esp
  802cbd:	68 c0 41 80 00       	push   $0x8041c0
  802cc2:	68 f6 00 00 00       	push   $0xf6
  802cc7:	68 e3 41 80 00       	push   $0x8041e3
  802ccc:	e8 f3 dd ff ff       	call   800ac4 <_panic>
  802cd1:	8b 15 44 51 90 00    	mov    0x905144,%edx
  802cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cda:	89 50 0c             	mov    %edx,0xc(%eax)
  802cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0d                	je     802cf4 <alloc_block_BF+0x219>
  802ce7:	a1 44 51 90 00       	mov    0x905144,%eax
  802cec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cef:	89 50 08             	mov    %edx,0x8(%eax)
  802cf2:	eb 08                	jmp    802cfc <alloc_block_BF+0x221>
  802cf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf7:	a3 40 51 90 00       	mov    %eax,0x905140
  802cfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cff:	a3 44 51 90 00       	mov    %eax,0x905144
  802d04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d0e:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802d13:	40                   	inc    %eax
  802d14:	a3 4c 51 90 00       	mov    %eax,0x90514c
		newBlock->size = size + sizeOfMetaData();
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	8d 50 10             	lea    0x10(%eax),%edx
  802d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d22:	89 10                	mov    %edx,(%eax)
		newBlock->is_free = 0;
  802d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d27:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return newBlock + 1;
  802d2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2e:	83 c0 10             	add    $0x10,%eax
  802d31:	eb 05                	jmp    802d38 <alloc_block_BF+0x25d>
	}
	else
	{
		return NULL;
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	return NULL;
}
  802d38:	c9                   	leave  
  802d39:	c3                   	ret    

00802d3a <alloc_block_WF>:

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
  802d3a:	55                   	push   %ebp
  802d3b:	89 e5                	mov    %esp,%ebp
  802d3d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802d40:	83 ec 04             	sub    $0x4,%esp
  802d43:	68 30 42 80 00       	push   $0x804230
  802d48:	68 07 01 00 00       	push   $0x107
  802d4d:	68 e3 41 80 00       	push   $0x8041e3
  802d52:	e8 6d dd ff ff       	call   800ac4 <_panic>

00802d57 <alloc_block_NF>:
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
  802d57:	55                   	push   %ebp
  802d58:	89 e5                	mov    %esp,%ebp
  802d5a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	68 58 42 80 00       	push   $0x804258
  802d65:	68 0f 01 00 00       	push   $0x10f
  802d6a:	68 e3 41 80 00       	push   $0x8041e3
  802d6f:	e8 50 dd ff ff       	call   800ac4 <_panic>

00802d74 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d74:	55                   	push   %ebp
  802d75:	89 e5                	mov    %esp,%ebp
  802d77:	83 ec 28             	sub    $0x28,%esp


	if (va == NULL)
  802d7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7e:	0f 84 ee 05 00 00    	je     803372 <free_block+0x5fe>
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	83 e8 10             	sub    $0x10,%eax
  802d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint8 flagx = 0;
  802d8d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802d91:	a1 40 51 90 00       	mov    0x905140,%eax
  802d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d99:	eb 16                	jmp    802db1 <free_block+0x3d>
	{
		if (block_pointer == it)
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802da1:	75 06                	jne    802da9 <free_block+0x35>
		{
			flagx = 1;
  802da3:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
			break;
  802da7:	eb 2f                	jmp    802dd8 <free_block+0x64>

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
  802da9:	a1 48 51 90 00       	mov    0x905148,%eax
  802dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802db1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db5:	74 08                	je     802dbf <free_block+0x4b>
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 40 08             	mov    0x8(%eax),%eax
  802dbd:	eb 05                	jmp    802dc4 <free_block+0x50>
  802dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc4:	a3 48 51 90 00       	mov    %eax,0x905148
  802dc9:	a1 48 51 90 00       	mov    0x905148,%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	75 c9                	jne    802d9b <free_block+0x27>
  802dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd6:	75 c3                	jne    802d9b <free_block+0x27>
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
  802dd8:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  802ddc:	0f 84 93 05 00 00    	je     803375 <free_block+0x601>
		return;
	if (va == NULL)
  802de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de6:	0f 84 8c 05 00 00    	je     803378 <free_block+0x604>
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
  802dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802def:	8b 40 0c             	mov    0xc(%eax),%eax
  802df2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 40 08             	mov    0x8(%eax),%eax
  802dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (prev_block == NULL && next_block == NULL) //only block in list 1
  802dfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e02:	75 12                	jne    802e16 <free_block+0xa2>
  802e04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e08:	75 0c                	jne    802e16 <free_block+0xa2>
	{
		block_pointer->is_free = 1;
  802e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802e11:	e9 63 05 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
  802e16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e1a:	0f 85 ca 00 00 00    	jne    802eea <free_block+0x176>
  802e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e23:	8a 40 04             	mov    0x4(%eax),%al
  802e26:	3c 01                	cmp    $0x1,%al
  802e28:	0f 85 bc 00 00 00    	jne    802eea <free_block+0x176>
	{
		block_pointer->is_free = 1;
  802e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e31:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  802e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e38:	8b 10                	mov    (%eax),%edx
  802e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	01 c2                	add    %eax,%edx
  802e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e44:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  802e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  802e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e52:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  802e56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e5a:	75 17                	jne    802e73 <free_block+0xff>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 7e 42 80 00       	push   $0x80427e
  802e64:	68 3c 01 00 00       	push   $0x13c
  802e69:	68 e3 41 80 00       	push   $0x8041e3
  802e6e:	e8 51 dc ff ff       	call   800ac4 <_panic>
  802e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e76:	8b 40 08             	mov    0x8(%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 11                	je     802e8e <free_block+0x11a>
  802e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e80:	8b 40 08             	mov    0x8(%eax),%eax
  802e83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e86:	8b 52 0c             	mov    0xc(%edx),%edx
  802e89:	89 50 0c             	mov    %edx,0xc(%eax)
  802e8c:	eb 0b                	jmp    802e99 <free_block+0x125>
  802e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e91:	8b 40 0c             	mov    0xc(%eax),%eax
  802e94:	a3 44 51 90 00       	mov    %eax,0x905144
  802e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 11                	je     802eb4 <free_block+0x140>
  802ea3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eac:	8b 52 08             	mov    0x8(%edx),%edx
  802eaf:	89 50 08             	mov    %edx,0x8(%eax)
  802eb2:	eb 0b                	jmp    802ebf <free_block+0x14b>
  802eb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb7:	8b 40 08             	mov    0x8(%eax),%eax
  802eba:	a3 40 51 90 00       	mov    %eax,0x905140
  802ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ed3:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802ed8:	48                   	dec    %eax
  802ed9:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  802ede:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  802ee5:	e9 8f 04 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
  802eea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eee:	75 16                	jne    802f06 <free_block+0x192>
  802ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef3:	8a 40 04             	mov    0x4(%eax),%al
  802ef6:	84 c0                	test   %al,%al
  802ef8:	75 0c                	jne    802f06 <free_block+0x192>
	{
		block_pointer->is_free = 1;
  802efa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efd:	c6 40 04 01          	movb   $0x1,0x4(%eax)
  802f01:	e9 73 04 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
  802f06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f0a:	0f 85 c3 00 00 00    	jne    802fd3 <free_block+0x25f>
  802f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f13:	8a 40 04             	mov    0x4(%eax),%al
  802f16:	3c 01                	cmp    $0x1,%al
  802f18:	0f 85 b5 00 00 00    	jne    802fd3 <free_block+0x25f>
	{
		prev_block->size += block_pointer->size;
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 10                	mov    (%eax),%edx
  802f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	01 c2                	add    %eax,%edx
  802f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2d:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  802f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  802f3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f43:	75 17                	jne    802f5c <free_block+0x1e8>
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	68 7e 42 80 00       	push   $0x80427e
  802f4d:	68 49 01 00 00       	push   $0x149
  802f52:	68 e3 41 80 00       	push   $0x8041e3
  802f57:	e8 68 db ff ff       	call   800ac4 <_panic>
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	8b 40 08             	mov    0x8(%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 11                	je     802f77 <free_block+0x203>
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	8b 40 08             	mov    0x8(%eax),%eax
  802f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6f:	8b 52 0c             	mov    0xc(%edx),%edx
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
  802f75:	eb 0b                	jmp    802f82 <free_block+0x20e>
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7d:	a3 44 51 90 00       	mov    %eax,0x905144
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 11                	je     802f9d <free_block+0x229>
  802f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f95:	8b 52 08             	mov    0x8(%edx),%edx
  802f98:	89 50 08             	mov    %edx,0x8(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <free_block+0x234>
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	8b 40 08             	mov    0x8(%eax),%eax
  802fa3:	a3 40 51 90 00       	mov    %eax,0x905140
  802fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fbc:	a1 4c 51 90 00       	mov    0x90514c,%eax
  802fc1:	48                   	dec    %eax
  802fc2:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  802fc7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  802fce:	e9 a6 03 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
  802fd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fd7:	75 16                	jne    802fef <free_block+0x27b>
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	8a 40 04             	mov    0x4(%eax),%al
  802fdf:	84 c0                	test   %al,%al
  802fe1:	75 0c                	jne    802fef <free_block+0x27b>
	{
		block_pointer->is_free = 1;
  802fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  802fea:	e9 8a 03 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
  802fef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ff3:	0f 84 81 01 00 00    	je     80317a <free_block+0x406>
  802ff9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffd:	0f 84 77 01 00 00    	je     80317a <free_block+0x406>
  803003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803006:	8a 40 04             	mov    0x4(%eax),%al
  803009:	3c 01                	cmp    $0x1,%al
  80300b:	0f 85 69 01 00 00    	jne    80317a <free_block+0x406>
  803011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803014:	8a 40 04             	mov    0x4(%eax),%al
  803017:	3c 01                	cmp    $0x1,%al
  803019:	0f 85 5b 01 00 00    	jne    80317a <free_block+0x406>
	{
		prev_block->size += (block_pointer->size + next_block->size);
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	8b 10                	mov    (%eax),%edx
  803024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803027:	8b 08                	mov    (%eax),%ecx
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	01 c8                	add    %ecx,%eax
  803030:	01 c2                	add    %eax,%edx
  803032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803035:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  803037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  803040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803043:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		block_pointer->size = 0;
  803047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  803050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803053:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  803057:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80305b:	75 17                	jne    803074 <free_block+0x300>
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	68 7e 42 80 00       	push   $0x80427e
  803065:	68 59 01 00 00       	push   $0x159
  80306a:	68 e3 41 80 00       	push   $0x8041e3
  80306f:	e8 50 da ff ff       	call   800ac4 <_panic>
  803074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803077:	8b 40 08             	mov    0x8(%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 11                	je     80308f <free_block+0x31b>
  80307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803081:	8b 40 08             	mov    0x8(%eax),%eax
  803084:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803087:	8b 52 0c             	mov    0xc(%edx),%edx
  80308a:	89 50 0c             	mov    %edx,0xc(%eax)
  80308d:	eb 0b                	jmp    80309a <free_block+0x326>
  80308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	a3 44 51 90 00       	mov    %eax,0x905144
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 11                	je     8030b5 <free_block+0x341>
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ad:	8b 52 08             	mov    0x8(%edx),%edx
  8030b0:	89 50 08             	mov    %edx,0x8(%eax)
  8030b3:	eb 0b                	jmp    8030c0 <free_block+0x34c>
  8030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b8:	8b 40 08             	mov    0x8(%eax),%eax
  8030bb:	a3 40 51 90 00       	mov    %eax,0x905140
  8030c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030d4:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8030d9:	48                   	dec    %eax
  8030da:	a3 4c 51 90 00       	mov    %eax,0x90514c
		LIST_REMOVE(&list, next_block);
  8030df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030e3:	75 17                	jne    8030fc <free_block+0x388>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 7e 42 80 00       	push   $0x80427e
  8030ed:	68 5a 01 00 00       	push   $0x15a
  8030f2:	68 e3 41 80 00       	push   $0x8041e3
  8030f7:	e8 c8 d9 ff ff       	call   800ac4 <_panic>
  8030fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ff:	8b 40 08             	mov    0x8(%eax),%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	74 11                	je     803117 <free_block+0x3a3>
  803106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80310f:	8b 52 0c             	mov    0xc(%edx),%edx
  803112:	89 50 0c             	mov    %edx,0xc(%eax)
  803115:	eb 0b                	jmp    803122 <free_block+0x3ae>
  803117:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311a:	8b 40 0c             	mov    0xc(%eax),%eax
  80311d:	a3 44 51 90 00       	mov    %eax,0x905144
  803122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803125:	8b 40 0c             	mov    0xc(%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 11                	je     80313d <free_block+0x3c9>
  80312c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312f:	8b 40 0c             	mov    0xc(%eax),%eax
  803132:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803135:	8b 52 08             	mov    0x8(%edx),%edx
  803138:	89 50 08             	mov    %edx,0x8(%eax)
  80313b:	eb 0b                	jmp    803148 <free_block+0x3d4>
  80313d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803140:	8b 40 08             	mov    0x8(%eax),%eax
  803143:	a3 40 51 90 00       	mov    %eax,0x905140
  803148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803155:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80315c:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803161:	48                   	dec    %eax
  803162:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  803167:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		block_pointer = 0;
  80316e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  803175:	e9 ff 01 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
  80317a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317e:	0f 84 db 00 00 00    	je     80325f <free_block+0x4eb>
  803184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803188:	0f 84 d1 00 00 00    	je     80325f <free_block+0x4eb>
  80318e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803191:	8a 40 04             	mov    0x4(%eax),%al
  803194:	84 c0                	test   %al,%al
  803196:	0f 85 c3 00 00 00    	jne    80325f <free_block+0x4eb>
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8a 40 04             	mov    0x4(%eax),%al
  8031a2:	3c 01                	cmp    $0x1,%al
  8031a4:	0f 85 b5 00 00 00    	jne    80325f <free_block+0x4eb>
	{
		prev_block->size += block_pointer->size;
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 10                	mov    (%eax),%edx
  8031af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	01 c2                	add    %eax,%edx
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	89 10                	mov    %edx,(%eax)
		block_pointer->size = 0;
  8031bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block_pointer->is_free = 0;
  8031c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, block_pointer);
  8031cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031cf:	75 17                	jne    8031e8 <free_block+0x474>
  8031d1:	83 ec 04             	sub    $0x4,%esp
  8031d4:	68 7e 42 80 00       	push   $0x80427e
  8031d9:	68 64 01 00 00       	push   $0x164
  8031de:	68 e3 41 80 00       	push   $0x8041e3
  8031e3:	e8 dc d8 ff ff       	call   800ac4 <_panic>
  8031e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031eb:	8b 40 08             	mov    0x8(%eax),%eax
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	74 11                	je     803203 <free_block+0x48f>
  8031f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f5:	8b 40 08             	mov    0x8(%eax),%eax
  8031f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8031fe:	89 50 0c             	mov    %edx,0xc(%eax)
  803201:	eb 0b                	jmp    80320e <free_block+0x49a>
  803203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803206:	8b 40 0c             	mov    0xc(%eax),%eax
  803209:	a3 44 51 90 00       	mov    %eax,0x905144
  80320e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803211:	8b 40 0c             	mov    0xc(%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 11                	je     803229 <free_block+0x4b5>
  803218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321b:	8b 40 0c             	mov    0xc(%eax),%eax
  80321e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803221:	8b 52 08             	mov    0x8(%edx),%edx
  803224:	89 50 08             	mov    %edx,0x8(%eax)
  803227:	eb 0b                	jmp    803234 <free_block+0x4c0>
  803229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322c:	8b 40 08             	mov    0x8(%eax),%eax
  80322f:	a3 40 51 90 00       	mov    %eax,0x905140
  803234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803237:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803248:	a1 4c 51 90 00       	mov    0x90514c,%eax
  80324d:	48                   	dec    %eax
  80324e:	a3 4c 51 90 00       	mov    %eax,0x90514c
		block_pointer = 0;
  803253:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		return;
  80325a:	e9 1a 01 00 00       	jmp    803379 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
  80325f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803263:	0f 84 df 00 00 00    	je     803348 <free_block+0x5d4>
  803269:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326d:	0f 84 d5 00 00 00    	je     803348 <free_block+0x5d4>
  803273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803276:	8a 40 04             	mov    0x4(%eax),%al
  803279:	3c 01                	cmp    $0x1,%al
  80327b:	0f 85 c7 00 00 00    	jne    803348 <free_block+0x5d4>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8a 40 04             	mov    0x4(%eax),%al
  803287:	84 c0                	test   %al,%al
  803289:	0f 85 b9 00 00 00    	jne    803348 <free_block+0x5d4>
	{
		block_pointer->is_free = 1;
  80328f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803292:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		block_pointer->size += next_block->size;
  803296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803299:	8b 10                	mov    (%eax),%edx
  80329b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329e:	8b 00                	mov    (%eax),%eax
  8032a0:	01 c2                	add    %eax,%edx
  8032a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a5:	89 10                	mov    %edx,(%eax)
		next_block->size = 0;
  8032a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		next_block->is_free = 0;
  8032b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		LIST_REMOVE(&list, next_block);
  8032b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032bb:	75 17                	jne    8032d4 <free_block+0x560>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 7e 42 80 00       	push   $0x80427e
  8032c5:	68 6e 01 00 00       	push   $0x16e
  8032ca:	68 e3 41 80 00       	push   $0x8041e3
  8032cf:	e8 f0 d7 ff ff       	call   800ac4 <_panic>
  8032d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d7:	8b 40 08             	mov    0x8(%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 11                	je     8032ef <free_block+0x57b>
  8032de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e1:	8b 40 08             	mov    0x8(%eax),%eax
  8032e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8032ea:	89 50 0c             	mov    %edx,0xc(%eax)
  8032ed:	eb 0b                	jmp    8032fa <free_block+0x586>
  8032ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	a3 44 51 90 00       	mov    %eax,0x905144
  8032fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 11                	je     803315 <free_block+0x5a1>
  803304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803307:	8b 40 0c             	mov    0xc(%eax),%eax
  80330a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80330d:	8b 52 08             	mov    0x8(%edx),%edx
  803310:	89 50 08             	mov    %edx,0x8(%eax)
  803313:	eb 0b                	jmp    803320 <free_block+0x5ac>
  803315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803318:	8b 40 08             	mov    0x8(%eax),%eax
  80331b:	a3 40 51 90 00       	mov    %eax,0x905140
  803320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803323:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80332a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803334:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803339:	48                   	dec    %eax
  80333a:	a3 4c 51 90 00       	mov    %eax,0x90514c
		next_block = 0;
  80333f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		return;
  803346:	eb 31                	jmp    803379 <free_block+0x605>
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
  803348:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80334c:	74 2b                	je     803379 <free_block+0x605>
  80334e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803352:	74 25                	je     803379 <free_block+0x605>
  803354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803357:	8a 40 04             	mov    0x4(%eax),%al
  80335a:	84 c0                	test   %al,%al
  80335c:	75 1b                	jne    803379 <free_block+0x605>
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	8a 40 04             	mov    0x4(%eax),%al
  803364:	84 c0                	test   %al,%al
  803366:	75 11                	jne    803379 <free_block+0x605>
	{
		block_pointer->is_free = 1;
  803368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		return;
  80336f:	90                   	nop
  803370:	eb 07                	jmp    803379 <free_block+0x605>
void free_block(void *va)
{


	if (va == NULL)
		return;
  803372:	90                   	nop
  803373:	eb 04                	jmp    803379 <free_block+0x605>
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
  803375:	90                   	nop
  803376:	eb 01                	jmp    803379 <free_block+0x605>
	if (va == NULL)
		return;
  803378:	90                   	nop
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}
  803379:	c9                   	leave  
  80337a:	c3                   	ret    

0080337b <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
  80337b:	55                   	push   %ebp
  80337c:	89 e5                	mov    %esp,%ebp
  80337e:	57                   	push   %edi
  80337f:	56                   	push   %esi
  803380:	53                   	push   %ebx
  803381:	83 ec 2c             	sub    $0x2c,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
  803384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803388:	75 19                	jne    8033a3 <realloc_block_FF+0x28>
  80338a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80338e:	74 13                	je     8033a3 <realloc_block_FF+0x28>
	{
		return alloc_block_FF(new_size);
  803390:	83 ec 0c             	sub    $0xc,%esp
  803393:	ff 75 0c             	pushl  0xc(%ebp)
  803396:	e8 0c f4 ff ff       	call   8027a7 <alloc_block_FF>
  80339b:	83 c4 10             	add    $0x10,%esp
  80339e:	e9 84 03 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
	}

	if (new_size == 0)
  8033a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033a7:	75 3b                	jne    8033e4 <realloc_block_FF+0x69>
	{
		//(NULL,0)
		if (va == NULL)
  8033a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ad:	75 17                	jne    8033c6 <realloc_block_FF+0x4b>
		{
			alloc_block_FF(0);
  8033af:	83 ec 0c             	sub    $0xc,%esp
  8033b2:	6a 00                	push   $0x0
  8033b4:	e8 ee f3 ff ff       	call   8027a7 <alloc_block_FF>
  8033b9:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c1:	e9 61 03 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
		}
		//(va,0)
		else if (va != NULL)
  8033c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ca:	74 18                	je     8033e4 <realloc_block_FF+0x69>
		{
			free_block(va);
  8033cc:	83 ec 0c             	sub    $0xc,%esp
  8033cf:	ff 75 08             	pushl  0x8(%ebp)
  8033d2:	e8 9d f9 ff ff       	call   802d74 <free_block>
  8033d7:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8033da:	b8 00 00 00 00       	mov    $0x0,%eax
  8033df:	e9 43 03 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
		}
	}

	LIST_FOREACH(iterator, &list)
  8033e4:	a1 40 51 90 00       	mov    0x905140,%eax
  8033e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8033ec:	e9 02 03 00 00       	jmp    8036f3 <realloc_block_FF+0x378>
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	83 e8 10             	sub    $0x10,%eax
  8033f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033fa:	0f 85 eb 02 00 00    	jne    8036eb <realloc_block_FF+0x370>
		{
			if (iterator->size == new_size + sizeOfMetaData())
  803400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	8b 55 0c             	mov    0xc(%ebp),%edx
  803408:	83 c2 10             	add    $0x10,%edx
  80340b:	39 d0                	cmp    %edx,%eax
  80340d:	75 08                	jne    803417 <realloc_block_FF+0x9c>
			{
				return va;
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	e9 10 03 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
			}

			//new size > size
			if (new_size > iterator->size)
  803417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80341f:	0f 83 e0 01 00 00    	jae    803605 <realloc_block_FF+0x28a>
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);
  803425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803428:	8b 40 08             	mov    0x8(%eax),%eax
  80342b:	89 45 e0             	mov    %eax,-0x20(%ebp)

				//next block more than the needed size
				if (next->is_free == 1&& next->size>(new_size-iterator->size) && next!=NULL)
  80342e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803431:	8a 40 04             	mov    0x4(%eax),%al
  803434:	3c 01                	cmp    $0x1,%al
  803436:	0f 85 06 01 00 00    	jne    803542 <realloc_block_FF+0x1c7>
  80343c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343f:	8b 10                	mov    (%eax),%edx
  803441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803449:	29 c1                	sub    %eax,%ecx
  80344b:	89 c8                	mov    %ecx,%eax
  80344d:	39 c2                	cmp    %eax,%edx
  80344f:	0f 86 ed 00 00 00    	jbe    803542 <realloc_block_FF+0x1c7>
  803455:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803459:	0f 84 e3 00 00 00    	je     803542 <realloc_block_FF+0x1c7>
				{
					if (next->size - (new_size - iterator->size)>=sizeOfMetaData())
  80345f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803462:	8b 10                	mov    (%eax),%edx
  803464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	2b 45 0c             	sub    0xc(%ebp),%eax
  80346c:	01 d0                	add    %edx,%eax
  80346e:	83 f8 0f             	cmp    $0xf,%eax
  803471:	0f 86 b5 00 00 00    	jbe    80352c <realloc_block_FF+0x1b1>
					{
						struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *) ((uint32) iterator + new_size + sizeOfMetaData());
  803477:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347d:	01 d0                	add    %edx,%eax
  80347f:	83 c0 10             	add    $0x10,%eax
  803482:	89 45 dc             	mov    %eax,-0x24(%ebp)
						newBlockAfterSplit->size = 0;
  803485:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						newBlockAfterSplit->is_free = 1;
  80348e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803491:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803495:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803499:	74 06                	je     8034a1 <realloc_block_FF+0x126>
  80349b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80349f:	75 17                	jne    8034b8 <realloc_block_FF+0x13d>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 fc 41 80 00       	push   $0x8041fc
  8034a9:	68 ad 01 00 00       	push   $0x1ad
  8034ae:	68 e3 41 80 00       	push   $0x8041e3
  8034b3:	e8 0c d6 ff ff       	call   800ac4 <_panic>
  8034b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bb:	8b 50 08             	mov    0x8(%eax),%edx
  8034be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c1:	89 50 08             	mov    %edx,0x8(%eax)
  8034c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c7:	8b 40 08             	mov    0x8(%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0c                	je     8034da <realloc_block_FF+0x15f>
  8034ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d1:	8b 40 08             	mov    0x8(%eax),%eax
  8034d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034d7:	89 50 0c             	mov    %edx,0xc(%eax)
  8034da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034e0:	89 50 08             	mov    %edx,0x8(%eax)
  8034e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e9:	89 50 0c             	mov    %edx,0xc(%eax)
  8034ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ef:	8b 40 08             	mov    0x8(%eax),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	75 08                	jne    8034fe <realloc_block_FF+0x183>
  8034f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f9:	a3 44 51 90 00       	mov    %eax,0x905144
  8034fe:	a1 4c 51 90 00       	mov    0x90514c,%eax
  803503:	40                   	inc    %eax
  803504:	a3 4c 51 90 00       	mov    %eax,0x90514c
						next->size = 0;
  803509:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
						next->is_free = 0;
  803512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803515:	c6 40 04 00          	movb   $0x0,0x4(%eax)
						iterator->size = new_size + sizeOfMetaData();
  803519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351c:	8d 50 10             	lea    0x10(%eax),%edx
  80351f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803522:	89 10                	mov    %edx,(%eax)
						return va;
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	e9 fb 01 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
					}
					else
					{
						iterator->size = new_size + sizeOfMetaData();
  80352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352f:	8d 50 10             	lea    0x10(%eax),%edx
  803532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803535:	89 10                	mov    %edx,(%eax)
						return (iterator + 1);
  803537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353a:	83 c0 10             	add    $0x10,%eax
  80353d:	e9 e5 01 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
					}
				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
  803542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803545:	8a 40 04             	mov    0x4(%eax),%al
  803548:	3c 01                	cmp    $0x1,%al
  80354a:	75 59                	jne    8035a5 <realloc_block_FF+0x22a>
  80354c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354f:	8b 10                	mov    (%eax),%edx
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803559:	29 c1                	sub    %eax,%ecx
  80355b:	89 c8                	mov    %ecx,%eax
  80355d:	39 c2                	cmp    %eax,%edx
  80355f:	75 44                	jne    8035a5 <realloc_block_FF+0x22a>
  803561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803565:	74 3e                	je     8035a5 <realloc_block_FF+0x22a>
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
  803567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356a:	8b 40 08             	mov    0x8(%eax),%eax
  80356d:	89 45 d8             	mov    %eax,-0x28(%ebp)
					iterator->prev_next_info.le_next = after_next;
  803570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803573:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803576:	89 50 08             	mov    %edx,0x8(%eax)
					after_next->prev_next_info.le_prev = iterator;
  803579:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80357c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80357f:	89 50 0c             	mov    %edx,0xc(%eax)
					next->size = 0;
  803582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					next->is_free = 0;
  80358b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					iterator->size = new_size + sizeOfMetaData();
  803592:	8b 45 0c             	mov    0xc(%ebp),%eax
  803595:	8d 50 10             	lea    0x10(%eax),%edx
  803598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359b:	89 10                	mov    %edx,(%eax)
					return va;
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	e9 82 01 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
  8035a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a8:	8a 40 04             	mov    0x4(%eax),%al
  8035ab:	84 c0                	test   %al,%al
  8035ad:	74 0a                	je     8035b9 <realloc_block_FF+0x23e>
  8035af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035b3:	0f 85 32 01 00 00    	jne    8036eb <realloc_block_FF+0x370>
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
  8035b9:	83 ec 0c             	sub    $0xc,%esp
  8035bc:	ff 75 0c             	pushl  0xc(%ebp)
  8035bf:	e8 e3 f1 ff ff       	call   8027a7 <alloc_block_FF>
  8035c4:	83 c4 10             	add    $0x10,%esp
  8035c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					if (alloc_return != NULL)
  8035ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035ce:	74 2b                	je     8035fb <realloc_block_FF+0x280>
					{
						*(alloc_return) = *((struct BlockMetaData*)va);
  8035d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	89 c3                	mov    %eax,%ebx
  8035d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8035dd:	89 d7                	mov    %edx,%edi
  8035df:	89 de                	mov    %ebx,%esi
  8035e1:	89 c1                	mov    %eax,%ecx
  8035e3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						free_block(va);
  8035e5:	83 ec 0c             	sub    $0xc,%esp
  8035e8:	ff 75 08             	pushl  0x8(%ebp)
  8035eb:	e8 84 f7 ff ff       	call   802d74 <free_block>
  8035f0:	83 c4 10             	add    $0x10,%esp
						return alloc_return;
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	e9 2c 01 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
					}
					else
					{
						return ((void*) -1);
  8035fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803600:	e9 22 01 00 00       	jmp    803727 <realloc_block_FF+0x3ac>
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
  803605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803608:	8b 00                	mov    (%eax),%eax
  80360a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80360d:	0f 86 d8 00 00 00    	jbe    8036eb <realloc_block_FF+0x370>
			{
				if (iterator->size - new_size >= sizeOfMetaData())
  803613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	2b 45 0c             	sub    0xc(%ebp),%eax
  80361b:	83 f8 0f             	cmp    $0xf,%eax
  80361e:	0f 86 b4 00 00 00    	jbe    8036d8 <realloc_block_FF+0x35d>
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
  803624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362a:	01 d0                	add    %edx,%eax
  80362c:	83 c0 10             	add    $0x10,%eax
  80362f:	89 45 d0             	mov    %eax,-0x30(%ebp)
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
  803632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803635:	8b 00                	mov    (%eax),%eax
  803637:	2b 45 0c             	sub    0xc(%ebp),%eax
  80363a:	8d 50 f0             	lea    -0x10(%eax),%edx
  80363d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803640:	89 10                	mov    %edx,(%eax)
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
  803642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803646:	74 06                	je     80364e <realloc_block_FF+0x2d3>
  803648:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80364c:	75 17                	jne    803665 <realloc_block_FF+0x2ea>
  80364e:	83 ec 04             	sub    $0x4,%esp
  803651:	68 fc 41 80 00       	push   $0x8041fc
  803656:	68 dd 01 00 00       	push   $0x1dd
  80365b:	68 e3 41 80 00       	push   $0x8041e3
  803660:	e8 5f d4 ff ff       	call   800ac4 <_panic>
  803665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803668:	8b 50 08             	mov    0x8(%eax),%edx
  80366b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80366e:	89 50 08             	mov    %edx,0x8(%eax)
  803671:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803674:	8b 40 08             	mov    0x8(%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0c                	je     803687 <realloc_block_FF+0x30c>
  80367b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367e:	8b 40 08             	mov    0x8(%eax),%eax
  803681:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803684:	89 50 0c             	mov    %edx,0xc(%eax)
  803687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80368d:	89 50 08             	mov    %edx,0x8(%eax)
  803690:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803696:	89 50 0c             	mov    %edx,0xc(%eax)
  803699:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80369c:	8b 40 08             	mov    0x8(%eax),%eax
  80369f:	85 c0                	test   %eax,%eax
  8036a1:	75 08                	jne    8036ab <realloc_block_FF+0x330>
  8036a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036a6:	a3 44 51 90 00       	mov    %eax,0x905144
  8036ab:	a1 4c 51 90 00       	mov    0x90514c,%eax
  8036b0:	40                   	inc    %eax
  8036b1:	a3 4c 51 90 00       	mov    %eax,0x90514c
					free_block((void*) (newBlockAfterSplit + 1));
  8036b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036b9:	83 c0 10             	add    $0x10,%eax
  8036bc:	83 ec 0c             	sub    $0xc,%esp
  8036bf:	50                   	push   %eax
  8036c0:	e8 af f6 ff ff       	call   802d74 <free_block>
  8036c5:	83 c4 10             	add    $0x10,%esp
					iterator->size = new_size + sizeOfMetaData();
  8036c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cb:	8d 50 10             	lea    0x10(%eax),%edx
  8036ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d1:	89 10                	mov    %edx,(%eax)
					return va;
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	eb 4f                	jmp    803727 <realloc_block_FF+0x3ac>
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
  8036d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036db:	8d 50 10             	lea    0x10(%eax),%edx
  8036de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e1:	89 10                	mov    %edx,(%eax)
					return (iterator + 1);
  8036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e6:	83 c0 10             	add    $0x10,%eax
  8036e9:	eb 3c                	jmp    803727 <realloc_block_FF+0x3ac>
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
  8036eb:	a1 48 51 90 00       	mov    0x905148,%eax
  8036f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8036f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036f7:	74 08                	je     803701 <realloc_block_FF+0x386>
  8036f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fc:	8b 40 08             	mov    0x8(%eax),%eax
  8036ff:	eb 05                	jmp    803706 <realloc_block_FF+0x38b>
  803701:	b8 00 00 00 00       	mov    $0x0,%eax
  803706:	a3 48 51 90 00       	mov    %eax,0x905148
  80370b:	a1 48 51 90 00       	mov    0x905148,%eax
  803710:	85 c0                	test   %eax,%eax
  803712:	0f 85 d9 fc ff ff    	jne    8033f1 <realloc_block_FF+0x76>
  803718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80371c:	0f 85 cf fc ff ff    	jne    8033f1 <realloc_block_FF+0x76>
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
  803722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803727:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80372a:	5b                   	pop    %ebx
  80372b:	5e                   	pop    %esi
  80372c:	5f                   	pop    %edi
  80372d:	5d                   	pop    %ebp
  80372e:	c3                   	ret    
  80372f:	90                   	nop

00803730 <__udivdi3>:
  803730:	55                   	push   %ebp
  803731:	57                   	push   %edi
  803732:	56                   	push   %esi
  803733:	53                   	push   %ebx
  803734:	83 ec 1c             	sub    $0x1c,%esp
  803737:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80373b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80373f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803743:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803747:	89 ca                	mov    %ecx,%edx
  803749:	89 f8                	mov    %edi,%eax
  80374b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80374f:	85 f6                	test   %esi,%esi
  803751:	75 2d                	jne    803780 <__udivdi3+0x50>
  803753:	39 cf                	cmp    %ecx,%edi
  803755:	77 65                	ja     8037bc <__udivdi3+0x8c>
  803757:	89 fd                	mov    %edi,%ebp
  803759:	85 ff                	test   %edi,%edi
  80375b:	75 0b                	jne    803768 <__udivdi3+0x38>
  80375d:	b8 01 00 00 00       	mov    $0x1,%eax
  803762:	31 d2                	xor    %edx,%edx
  803764:	f7 f7                	div    %edi
  803766:	89 c5                	mov    %eax,%ebp
  803768:	31 d2                	xor    %edx,%edx
  80376a:	89 c8                	mov    %ecx,%eax
  80376c:	f7 f5                	div    %ebp
  80376e:	89 c1                	mov    %eax,%ecx
  803770:	89 d8                	mov    %ebx,%eax
  803772:	f7 f5                	div    %ebp
  803774:	89 cf                	mov    %ecx,%edi
  803776:	89 fa                	mov    %edi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	39 ce                	cmp    %ecx,%esi
  803782:	77 28                	ja     8037ac <__udivdi3+0x7c>
  803784:	0f bd fe             	bsr    %esi,%edi
  803787:	83 f7 1f             	xor    $0x1f,%edi
  80378a:	75 40                	jne    8037cc <__udivdi3+0x9c>
  80378c:	39 ce                	cmp    %ecx,%esi
  80378e:	72 0a                	jb     80379a <__udivdi3+0x6a>
  803790:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803794:	0f 87 9e 00 00 00    	ja     803838 <__udivdi3+0x108>
  80379a:	b8 01 00 00 00       	mov    $0x1,%eax
  80379f:	89 fa                	mov    %edi,%edx
  8037a1:	83 c4 1c             	add    $0x1c,%esp
  8037a4:	5b                   	pop    %ebx
  8037a5:	5e                   	pop    %esi
  8037a6:	5f                   	pop    %edi
  8037a7:	5d                   	pop    %ebp
  8037a8:	c3                   	ret    
  8037a9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ac:	31 ff                	xor    %edi,%edi
  8037ae:	31 c0                	xor    %eax,%eax
  8037b0:	89 fa                	mov    %edi,%edx
  8037b2:	83 c4 1c             	add    $0x1c,%esp
  8037b5:	5b                   	pop    %ebx
  8037b6:	5e                   	pop    %esi
  8037b7:	5f                   	pop    %edi
  8037b8:	5d                   	pop    %ebp
  8037b9:	c3                   	ret    
  8037ba:	66 90                	xchg   %ax,%ax
  8037bc:	89 d8                	mov    %ebx,%eax
  8037be:	f7 f7                	div    %edi
  8037c0:	31 ff                	xor    %edi,%edi
  8037c2:	89 fa                	mov    %edi,%edx
  8037c4:	83 c4 1c             	add    $0x1c,%esp
  8037c7:	5b                   	pop    %ebx
  8037c8:	5e                   	pop    %esi
  8037c9:	5f                   	pop    %edi
  8037ca:	5d                   	pop    %ebp
  8037cb:	c3                   	ret    
  8037cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037d1:	89 eb                	mov    %ebp,%ebx
  8037d3:	29 fb                	sub    %edi,%ebx
  8037d5:	89 f9                	mov    %edi,%ecx
  8037d7:	d3 e6                	shl    %cl,%esi
  8037d9:	89 c5                	mov    %eax,%ebp
  8037db:	88 d9                	mov    %bl,%cl
  8037dd:	d3 ed                	shr    %cl,%ebp
  8037df:	89 e9                	mov    %ebp,%ecx
  8037e1:	09 f1                	or     %esi,%ecx
  8037e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037e7:	89 f9                	mov    %edi,%ecx
  8037e9:	d3 e0                	shl    %cl,%eax
  8037eb:	89 c5                	mov    %eax,%ebp
  8037ed:	89 d6                	mov    %edx,%esi
  8037ef:	88 d9                	mov    %bl,%cl
  8037f1:	d3 ee                	shr    %cl,%esi
  8037f3:	89 f9                	mov    %edi,%ecx
  8037f5:	d3 e2                	shl    %cl,%edx
  8037f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037fb:	88 d9                	mov    %bl,%cl
  8037fd:	d3 e8                	shr    %cl,%eax
  8037ff:	09 c2                	or     %eax,%edx
  803801:	89 d0                	mov    %edx,%eax
  803803:	89 f2                	mov    %esi,%edx
  803805:	f7 74 24 0c          	divl   0xc(%esp)
  803809:	89 d6                	mov    %edx,%esi
  80380b:	89 c3                	mov    %eax,%ebx
  80380d:	f7 e5                	mul    %ebp
  80380f:	39 d6                	cmp    %edx,%esi
  803811:	72 19                	jb     80382c <__udivdi3+0xfc>
  803813:	74 0b                	je     803820 <__udivdi3+0xf0>
  803815:	89 d8                	mov    %ebx,%eax
  803817:	31 ff                	xor    %edi,%edi
  803819:	e9 58 ff ff ff       	jmp    803776 <__udivdi3+0x46>
  80381e:	66 90                	xchg   %ax,%ax
  803820:	8b 54 24 08          	mov    0x8(%esp),%edx
  803824:	89 f9                	mov    %edi,%ecx
  803826:	d3 e2                	shl    %cl,%edx
  803828:	39 c2                	cmp    %eax,%edx
  80382a:	73 e9                	jae    803815 <__udivdi3+0xe5>
  80382c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80382f:	31 ff                	xor    %edi,%edi
  803831:	e9 40 ff ff ff       	jmp    803776 <__udivdi3+0x46>
  803836:	66 90                	xchg   %ax,%ax
  803838:	31 c0                	xor    %eax,%eax
  80383a:	e9 37 ff ff ff       	jmp    803776 <__udivdi3+0x46>
  80383f:	90                   	nop

00803840 <__umoddi3>:
  803840:	55                   	push   %ebp
  803841:	57                   	push   %edi
  803842:	56                   	push   %esi
  803843:	53                   	push   %ebx
  803844:	83 ec 1c             	sub    $0x1c,%esp
  803847:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80384b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80384f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803853:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803857:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80385b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80385f:	89 f3                	mov    %esi,%ebx
  803861:	89 fa                	mov    %edi,%edx
  803863:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803867:	89 34 24             	mov    %esi,(%esp)
  80386a:	85 c0                	test   %eax,%eax
  80386c:	75 1a                	jne    803888 <__umoddi3+0x48>
  80386e:	39 f7                	cmp    %esi,%edi
  803870:	0f 86 a2 00 00 00    	jbe    803918 <__umoddi3+0xd8>
  803876:	89 c8                	mov    %ecx,%eax
  803878:	89 f2                	mov    %esi,%edx
  80387a:	f7 f7                	div    %edi
  80387c:	89 d0                	mov    %edx,%eax
  80387e:	31 d2                	xor    %edx,%edx
  803880:	83 c4 1c             	add    $0x1c,%esp
  803883:	5b                   	pop    %ebx
  803884:	5e                   	pop    %esi
  803885:	5f                   	pop    %edi
  803886:	5d                   	pop    %ebp
  803887:	c3                   	ret    
  803888:	39 f0                	cmp    %esi,%eax
  80388a:	0f 87 ac 00 00 00    	ja     80393c <__umoddi3+0xfc>
  803890:	0f bd e8             	bsr    %eax,%ebp
  803893:	83 f5 1f             	xor    $0x1f,%ebp
  803896:	0f 84 ac 00 00 00    	je     803948 <__umoddi3+0x108>
  80389c:	bf 20 00 00 00       	mov    $0x20,%edi
  8038a1:	29 ef                	sub    %ebp,%edi
  8038a3:	89 fe                	mov    %edi,%esi
  8038a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038a9:	89 e9                	mov    %ebp,%ecx
  8038ab:	d3 e0                	shl    %cl,%eax
  8038ad:	89 d7                	mov    %edx,%edi
  8038af:	89 f1                	mov    %esi,%ecx
  8038b1:	d3 ef                	shr    %cl,%edi
  8038b3:	09 c7                	or     %eax,%edi
  8038b5:	89 e9                	mov    %ebp,%ecx
  8038b7:	d3 e2                	shl    %cl,%edx
  8038b9:	89 14 24             	mov    %edx,(%esp)
  8038bc:	89 d8                	mov    %ebx,%eax
  8038be:	d3 e0                	shl    %cl,%eax
  8038c0:	89 c2                	mov    %eax,%edx
  8038c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038c6:	d3 e0                	shl    %cl,%eax
  8038c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d0:	89 f1                	mov    %esi,%ecx
  8038d2:	d3 e8                	shr    %cl,%eax
  8038d4:	09 d0                	or     %edx,%eax
  8038d6:	d3 eb                	shr    %cl,%ebx
  8038d8:	89 da                	mov    %ebx,%edx
  8038da:	f7 f7                	div    %edi
  8038dc:	89 d3                	mov    %edx,%ebx
  8038de:	f7 24 24             	mull   (%esp)
  8038e1:	89 c6                	mov    %eax,%esi
  8038e3:	89 d1                	mov    %edx,%ecx
  8038e5:	39 d3                	cmp    %edx,%ebx
  8038e7:	0f 82 87 00 00 00    	jb     803974 <__umoddi3+0x134>
  8038ed:	0f 84 91 00 00 00    	je     803984 <__umoddi3+0x144>
  8038f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038f7:	29 f2                	sub    %esi,%edx
  8038f9:	19 cb                	sbb    %ecx,%ebx
  8038fb:	89 d8                	mov    %ebx,%eax
  8038fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803901:	d3 e0                	shl    %cl,%eax
  803903:	89 e9                	mov    %ebp,%ecx
  803905:	d3 ea                	shr    %cl,%edx
  803907:	09 d0                	or     %edx,%eax
  803909:	89 e9                	mov    %ebp,%ecx
  80390b:	d3 eb                	shr    %cl,%ebx
  80390d:	89 da                	mov    %ebx,%edx
  80390f:	83 c4 1c             	add    $0x1c,%esp
  803912:	5b                   	pop    %ebx
  803913:	5e                   	pop    %esi
  803914:	5f                   	pop    %edi
  803915:	5d                   	pop    %ebp
  803916:	c3                   	ret    
  803917:	90                   	nop
  803918:	89 fd                	mov    %edi,%ebp
  80391a:	85 ff                	test   %edi,%edi
  80391c:	75 0b                	jne    803929 <__umoddi3+0xe9>
  80391e:	b8 01 00 00 00       	mov    $0x1,%eax
  803923:	31 d2                	xor    %edx,%edx
  803925:	f7 f7                	div    %edi
  803927:	89 c5                	mov    %eax,%ebp
  803929:	89 f0                	mov    %esi,%eax
  80392b:	31 d2                	xor    %edx,%edx
  80392d:	f7 f5                	div    %ebp
  80392f:	89 c8                	mov    %ecx,%eax
  803931:	f7 f5                	div    %ebp
  803933:	89 d0                	mov    %edx,%eax
  803935:	e9 44 ff ff ff       	jmp    80387e <__umoddi3+0x3e>
  80393a:	66 90                	xchg   %ax,%ax
  80393c:	89 c8                	mov    %ecx,%eax
  80393e:	89 f2                	mov    %esi,%edx
  803940:	83 c4 1c             	add    $0x1c,%esp
  803943:	5b                   	pop    %ebx
  803944:	5e                   	pop    %esi
  803945:	5f                   	pop    %edi
  803946:	5d                   	pop    %ebp
  803947:	c3                   	ret    
  803948:	3b 04 24             	cmp    (%esp),%eax
  80394b:	72 06                	jb     803953 <__umoddi3+0x113>
  80394d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803951:	77 0f                	ja     803962 <__umoddi3+0x122>
  803953:	89 f2                	mov    %esi,%edx
  803955:	29 f9                	sub    %edi,%ecx
  803957:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80395b:	89 14 24             	mov    %edx,(%esp)
  80395e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803962:	8b 44 24 04          	mov    0x4(%esp),%eax
  803966:	8b 14 24             	mov    (%esp),%edx
  803969:	83 c4 1c             	add    $0x1c,%esp
  80396c:	5b                   	pop    %ebx
  80396d:	5e                   	pop    %esi
  80396e:	5f                   	pop    %edi
  80396f:	5d                   	pop    %ebp
  803970:	c3                   	ret    
  803971:	8d 76 00             	lea    0x0(%esi),%esi
  803974:	2b 04 24             	sub    (%esp),%eax
  803977:	19 fa                	sbb    %edi,%edx
  803979:	89 d1                	mov    %edx,%ecx
  80397b:	89 c6                	mov    %eax,%esi
  80397d:	e9 71 ff ff ff       	jmp    8038f3 <__umoddi3+0xb3>
  803982:	66 90                	xchg   %ax,%ax
  803984:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803988:	72 ea                	jb     803974 <__umoddi3+0x134>
  80398a:	89 d9                	mov    %ebx,%ecx
  80398c:	e9 62 ff ff ff       	jmp    8038f3 <__umoddi3+0xb3>
