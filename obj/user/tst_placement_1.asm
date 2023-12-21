
obj/user/tst_placement_1:     file format elf32-i386


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
  800031:	e8 7c 03 00 00       	call   8003b2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 74 00 00 01    	sub    $0x1000074,%esp
	int freePages = sys_calculate_free_frames();
  800042:	e8 3e 16 00 00       	call   801685 <sys_calculate_free_frames>
  800047:	89 45 ec             	mov    %eax,-0x14(%ebp)
	char arr[PAGE_SIZE*1024*4];

	//uint32 actual_active_list[17] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[17] ;
	{
		actual_active_list[0] = 0xedbfd000;
  80004a:	c7 85 94 ff ff fe 00 	movl   $0xedbfd000,-0x100006c(%ebp)
  800051:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  800054:	c7 85 98 ff ff fe 00 	movl   $0xeebfd000,-0x1000068(%ebp)
  80005b:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  80005e:	c7 85 9c ff ff fe 00 	movl   $0x803000,-0x1000064(%ebp)
  800065:	30 80 00 
		actual_active_list[3] = 0x802000;
  800068:	c7 85 a0 ff ff fe 00 	movl   $0x802000,-0x1000060(%ebp)
  80006f:	20 80 00 
		actual_active_list[4] = 0x801000;
  800072:	c7 85 a4 ff ff fe 00 	movl   $0x801000,-0x100005c(%ebp)
  800079:	10 80 00 
		actual_active_list[5] = 0x800000;
  80007c:	c7 85 a8 ff ff fe 00 	movl   $0x800000,-0x1000058(%ebp)
  800083:	00 80 00 
		actual_active_list[6] = 0x205000;
  800086:	c7 85 ac ff ff fe 00 	movl   $0x205000,-0x1000054(%ebp)
  80008d:	50 20 00 
		actual_active_list[7] = 0x204000;
  800090:	c7 85 b0 ff ff fe 00 	movl   $0x204000,-0x1000050(%ebp)
  800097:	40 20 00 
		actual_active_list[8] = 0x203000;
  80009a:	c7 85 b4 ff ff fe 00 	movl   $0x203000,-0x100004c(%ebp)
  8000a1:	30 20 00 
		actual_active_list[9] = 0x202000;
  8000a4:	c7 85 b8 ff ff fe 00 	movl   $0x202000,-0x1000048(%ebp)
  8000ab:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000ae:	c7 85 bc ff ff fe 00 	movl   $0x201000,-0x1000044(%ebp)
  8000b5:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b8:	c7 85 c0 ff ff fe 00 	movl   $0x200000,-0x1000040(%ebp)
  8000bf:	00 20 00 
	}
	uint32 actual_second_list[2] = {};
  8000c2:	c7 85 8c ff ff fe 00 	movl   $0x0,-0x1000074(%ebp)
  8000c9:	00 00 00 
  8000cc:	c7 85 90 ff ff fe 00 	movl   $0x0,-0x1000070(%ebp)
  8000d3:	00 00 00 

	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	6a 0c                	push   $0xc
  8000da:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000e7:	50                   	push   %eax
  8000e8:	e8 73 1a 00 00       	call   801b60 <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(check == 0)
  8000f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 e0 1e 80 00       	push   $0x801ee0
  800101:	6a 26                	push   $0x26
  800103:	68 62 1f 80 00       	push   $0x801f62
  800108:	e8 d3 03 00 00       	call   8004e0 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 be 15 00 00       	call   8016d0 <sys_pf_calculate_allocated_pages>
  800112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i=0;
  800115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80011c:	eb 11                	jmp    80012f <_main+0xf7>
	{
		arr[i] = 'A';
  80011e:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	c6 00 41             	movb   $0x41,(%eax)
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80012c:	ff 45 f4             	incl   -0xc(%ebp)
  80012f:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800136:	7e e6                	jle    80011e <_main+0xe6>
	{
		arr[i] = 'A';
	}
	cprintf("1. free frames = %d\n", sys_calculate_free_frames());
  800138:	e8 48 15 00 00       	call   801685 <sys_calculate_free_frames>
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	50                   	push   %eax
  800141:	68 79 1f 80 00       	push   $0x801f79
  800146:	e8 52 06 00 00       	call   80079d <cprintf>
  80014b:	83 c4 10             	add    $0x10,%esp

	i=PAGE_SIZE*1024;
  80014e:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800155:	eb 11                	jmp    800168 <_main+0x130>
	{
		arr[i] = 'A';
  800157:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  80015d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
	cprintf("1. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800165:	ff 45 f4             	incl   -0xc(%ebp)
  800168:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80016f:	7e e6                	jle    800157 <_main+0x11f>
	{
		arr[i] = 'A';
	}
	cprintf("2. free frames = %d\n", sys_calculate_free_frames());
  800171:	e8 0f 15 00 00       	call   801685 <sys_calculate_free_frames>
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	50                   	push   %eax
  80017a:	68 8e 1f 80 00       	push   $0x801f8e
  80017f:	e8 19 06 00 00       	call   80079d <cprintf>
  800184:	83 c4 10             	add    $0x10,%esp

	i=PAGE_SIZE*1024*2;
  800187:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80018e:	eb 11                	jmp    8001a1 <_main+0x169>
	{
		arr[i] = 'A';
  800190:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
	cprintf("2. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80019e:	ff 45 f4             	incl   -0xc(%ebp)
  8001a1:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  8001a8:	7e e6                	jle    800190 <_main+0x158>
	{
		arr[i] = 'A';
	}
	cprintf("3. free frames = %d\n", sys_calculate_free_frames());
  8001aa:	e8 d6 14 00 00       	call   801685 <sys_calculate_free_frames>
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	50                   	push   %eax
  8001b3:	68 a3 1f 80 00       	push   $0x801fa3
  8001b8:	e8 e0 05 00 00       	call   80079d <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp


	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	68 b8 1f 80 00       	push   $0x801fb8
  8001c8:	e8 d0 05 00 00       	call   80079d <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] != 'A')  panic("PLACEMENT of stack page failed");
  8001d0:	8a 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%al
  8001d6:	3c 41                	cmp    $0x41,%al
  8001d8:	74 14                	je     8001ee <_main+0x1b6>
  8001da:	83 ec 04             	sub    $0x4,%esp
  8001dd:	68 e8 1f 80 00       	push   $0x801fe8
  8001e2:	6a 43                	push   $0x43
  8001e4:	68 62 1f 80 00       	push   $0x801f62
  8001e9:	e8 f2 02 00 00       	call   8004e0 <_panic>
		if( arr[PAGE_SIZE] != 'A')  panic("PLACEMENT of stack page failed");
  8001ee:	8a 85 d8 0f 00 ff    	mov    -0xfff028(%ebp),%al
  8001f4:	3c 41                	cmp    $0x41,%al
  8001f6:	74 14                	je     80020c <_main+0x1d4>
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	68 e8 1f 80 00       	push   $0x801fe8
  800200:	6a 44                	push   $0x44
  800202:	68 62 1f 80 00       	push   $0x801f62
  800207:	e8 d4 02 00 00       	call   8004e0 <_panic>

		if( arr[PAGE_SIZE*1024] != 'A')  panic("PLACEMENT of stack page failed");
  80020c:	8a 85 d8 ff 3f ff    	mov    -0xc00028(%ebp),%al
  800212:	3c 41                	cmp    $0x41,%al
  800214:	74 14                	je     80022a <_main+0x1f2>
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	68 e8 1f 80 00       	push   $0x801fe8
  80021e:	6a 46                	push   $0x46
  800220:	68 62 1f 80 00       	push   $0x801f62
  800225:	e8 b6 02 00 00       	call   8004e0 <_panic>
		if( arr[PAGE_SIZE*1025] != 'A')  panic("PLACEMENT of stack page failed");
  80022a:	8a 85 d8 0f 40 ff    	mov    -0xbff028(%ebp),%al
  800230:	3c 41                	cmp    $0x41,%al
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 e8 1f 80 00       	push   $0x801fe8
  80023c:	6a 47                	push   $0x47
  80023e:	68 62 1f 80 00       	push   $0x801f62
  800243:	e8 98 02 00 00       	call   8004e0 <_panic>

		if( arr[PAGE_SIZE*1024*2] != 'A')  panic("PLACEMENT of stack page failed");
  800248:	8a 85 d8 ff 7f ff    	mov    -0x800028(%ebp),%al
  80024e:	3c 41                	cmp    $0x41,%al
  800250:	74 14                	je     800266 <_main+0x22e>
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	68 e8 1f 80 00       	push   $0x801fe8
  80025a:	6a 49                	push   $0x49
  80025c:	68 62 1f 80 00       	push   $0x801f62
  800261:	e8 7a 02 00 00       	call   8004e0 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] != 'A')  panic("PLACEMENT of stack page failed");
  800266:	8a 85 d8 0f 80 ff    	mov    -0x7ff028(%ebp),%al
  80026c:	3c 41                	cmp    $0x41,%al
  80026e:	74 14                	je     800284 <_main+0x24c>
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	68 e8 1f 80 00       	push   $0x801fe8
  800278:	6a 4a                	push   $0x4a
  80027a:	68 62 1f 80 00       	push   $0x801f62
  80027f:	e8 5c 02 00 00       	call   8004e0 <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages should NOT written to Page File until it's replaced");
  800284:	e8 47 14 00 00       	call   8016d0 <sys_pf_calculate_allocated_pages>
  800289:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 08 20 80 00       	push   $0x802008
  800296:	6a 4c                	push   $0x4c
  800298:	68 62 1f 80 00       	push   $0x801f62
  80029d:	e8 3e 02 00 00       	call   8004e0 <_panic>

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  8002a2:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  8002a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8002ac:	e8 d4 13 00 00       	call   801685 <sys_calculate_free_frames>
  8002b1:	29 c3                	sub    %eax,%ebx
  8002b3:	89 d8                	mov    %ebx,%eax
  8002b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;

		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
  8002b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002be:	74 1a                	je     8002da <_main+0x2a2>
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c9:	68 4c 20 80 00       	push   $0x80204c
  8002ce:	6a 52                	push   $0x52
  8002d0:	68 62 1f 80 00       	push   $0x801f62
  8002d5:	e8 06 02 00 00       	call   8004e0 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	68 88 20 80 00       	push   $0x802088
  8002e2:	e8 b6 04 00 00       	call   80079d <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp

	for (int i=16;i>4;i--)
  8002ea:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
  8002f1:	eb 1a                	jmp    80030d <_main+0x2d5>
		actual_active_list[i]=actual_active_list[i-5];
  8002f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f6:	83 e8 05             	sub    $0x5,%eax
  8002f9:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  800300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800303:	89 94 85 94 ff ff fe 	mov    %edx,-0x100006c(%ebp,%eax,4)

		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	for (int i=16;i>4;i--)
  80030a:	ff 4d f0             	decl   -0x10(%ebp)
  80030d:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  800311:	7f e0                	jg     8002f3 <_main+0x2bb>
		actual_active_list[i]=actual_active_list[i-5];

	actual_active_list[0]=0xee3fe000;
  800313:	c7 85 94 ff ff fe 00 	movl   $0xee3fe000,-0x100006c(%ebp)
  80031a:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  80031d:	c7 85 98 ff ff fe 00 	movl   $0xee3fd000,-0x1000068(%ebp)
  800324:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  800327:	c7 85 9c ff ff fe 00 	movl   $0xedffe000,-0x1000064(%ebp)
  80032e:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  800331:	c7 85 a0 ff ff fe 00 	movl   $0xedffd000,-0x1000060(%ebp)
  800338:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  80033b:	c7 85 a4 ff ff fe 00 	movl   $0xedbfe000,-0x100005c(%ebp)
  800342:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 bc 20 80 00       	push   $0x8020bc
  80034d:	e8 4b 04 00 00       	call   80079d <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  800355:	6a 00                	push   $0x0
  800357:	6a 11                	push   $0x11
  800359:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  80035f:	50                   	push   %eax
  800360:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	e8 f4 17 00 00       	call   801b60 <sys_check_LRU_lists>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if(check == 0)
  800372:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800376:	75 14                	jne    80038c <_main+0x354>
				panic("LRU lists entries are not correct, check your logic again!!");
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 e4 20 80 00       	push   $0x8020e4
  800380:	6a 63                	push   $0x63
  800382:	68 62 1f 80 00       	push   $0x801f62
  800387:	e8 54 01 00 00       	call   8004e0 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	68 20 21 80 00       	push   $0x802120
  800394:	e8 04 04 00 00       	call   80079d <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed successfully!!\n\n\n");
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	68 58 21 80 00       	push   $0x802158
  8003a4:	e8 f4 03 00 00       	call   80079d <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	return;
  8003ac:	90                   	nop
}
  8003ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003b8:	e8 53 15 00 00       	call   801910 <sys_getenvindex>
  8003bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c3:	89 d0                	mov    %edx,%eax
  8003c5:	01 c0                	add    %eax,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	c1 e0 06             	shl    $0x6,%eax
  8003cc:	29 d0                	sub    %edx,%eax
  8003ce:	c1 e0 03             	shl    $0x3,%eax
  8003d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003d6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8a 40 68             	mov    0x68(%eax),%al
  8003e3:	84 c0                	test   %al,%al
  8003e5:	74 0d                	je     8003f4 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	83 c0 68             	add    $0x68,%eax
  8003ef:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003f8:	7e 0a                	jle    800404 <libmain+0x52>
		binaryname = argv[0];
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 08             	pushl  0x8(%ebp)
  80040d:	e8 26 fc ff ff       	call   800038 <_main>
  800412:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800415:	e8 03 13 00 00       	call   80171d <sys_disable_interrupt>
	cprintf("**************************************\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 c4 21 80 00       	push   $0x8021c4
  800422:	e8 76 03 00 00       	call   80079d <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80042a:	a1 20 30 80 00       	mov    0x803020,%eax
  80042f:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800435:	a1 20 30 80 00       	mov    0x803020,%eax
  80043a:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	52                   	push   %edx
  800444:	50                   	push   %eax
  800445:	68 ec 21 80 00       	push   $0x8021ec
  80044a:	e8 4e 03 00 00       	call   80079d <cprintf>
  80044f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800452:	a1 20 30 80 00       	mov    0x803020,%eax
  800457:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80045d:	a1 20 30 80 00       	mov    0x803020,%eax
  800462:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800468:	a1 20 30 80 00       	mov    0x803020,%eax
  80046d:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800473:	51                   	push   %ecx
  800474:	52                   	push   %edx
  800475:	50                   	push   %eax
  800476:	68 14 22 80 00       	push   $0x802214
  80047b:	e8 1d 03 00 00       	call   80079d <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800483:	a1 20 30 80 00       	mov    0x803020,%eax
  800488:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	50                   	push   %eax
  800492:	68 6c 22 80 00       	push   $0x80226c
  800497:	e8 01 03 00 00       	call   80079d <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80049f:	83 ec 0c             	sub    $0xc,%esp
  8004a2:	68 c4 21 80 00       	push   $0x8021c4
  8004a7:	e8 f1 02 00 00       	call   80079d <cprintf>
  8004ac:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004af:	e8 83 12 00 00       	call   801737 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004b4:	e8 19 00 00 00       	call   8004d2 <exit>
}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004c2:	83 ec 0c             	sub    $0xc,%esp
  8004c5:	6a 00                	push   $0x0
  8004c7:	e8 10 14 00 00       	call   8018dc <sys_destroy_env>
  8004cc:	83 c4 10             	add    $0x10,%esp
}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <exit>:

void
exit(void)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004d8:	e8 65 14 00 00       	call   801942 <sys_exit_env>
}
  8004dd:	90                   	nop
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8004e9:	83 c0 04             	add    $0x4,%eax
  8004ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ef:	a1 18 31 80 00       	mov    0x803118,%eax
  8004f4:	85 c0                	test   %eax,%eax
  8004f6:	74 16                	je     80050e <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004f8:	a1 18 31 80 00       	mov    0x803118,%eax
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	50                   	push   %eax
  800501:	68 80 22 80 00       	push   $0x802280
  800506:	e8 92 02 00 00       	call   80079d <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80050e:	a1 00 30 80 00       	mov    0x803000,%eax
  800513:	ff 75 0c             	pushl  0xc(%ebp)
  800516:	ff 75 08             	pushl  0x8(%ebp)
  800519:	50                   	push   %eax
  80051a:	68 85 22 80 00       	push   $0x802285
  80051f:	e8 79 02 00 00       	call   80079d <cprintf>
  800524:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800527:	8b 45 10             	mov    0x10(%ebp),%eax
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 f4             	pushl  -0xc(%ebp)
  800530:	50                   	push   %eax
  800531:	e8 fc 01 00 00       	call   800732 <vcprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	6a 00                	push   $0x0
  80053e:	68 a1 22 80 00       	push   $0x8022a1
  800543:	e8 ea 01 00 00       	call   800732 <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80054b:	e8 82 ff ff ff       	call   8004d2 <exit>

	// should not return here
	while (1) ;
  800550:	eb fe                	jmp    800550 <_panic+0x70>

00800552 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800558:	a1 20 30 80 00       	mov    0x803020,%eax
  80055d:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	39 c2                	cmp    %eax,%edx
  800568:	74 14                	je     80057e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80056a:	83 ec 04             	sub    $0x4,%esp
  80056d:	68 a4 22 80 00       	push   $0x8022a4
  800572:	6a 26                	push   $0x26
  800574:	68 f0 22 80 00       	push   $0x8022f0
  800579:	e8 62 ff ff ff       	call   8004e0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80057e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80058c:	e9 c5 00 00 00       	jmp    800656 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800594:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	01 d0                	add    %edx,%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	85 c0                	test   %eax,%eax
  8005a4:	75 08                	jne    8005ae <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005a6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005a9:	e9 a5 00 00 00       	jmp    800653 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005bc:	eb 69                	jmp    800627 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005be:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c3:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8005c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005cc:	89 d0                	mov    %edx,%eax
  8005ce:	01 c0                	add    %eax,%eax
  8005d0:	01 d0                	add    %edx,%eax
  8005d2:	c1 e0 03             	shl    $0x3,%eax
  8005d5:	01 c8                	add    %ecx,%eax
  8005d7:	8a 40 04             	mov    0x4(%eax),%al
  8005da:	84 c0                	test   %al,%al
  8005dc:	75 46                	jne    800624 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005de:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e3:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8005e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	01 c0                	add    %eax,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	c1 e0 03             	shl    $0x3,%eax
  8005f5:	01 c8                	add    %ecx,%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800604:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800609:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	01 c8                	add    %ecx,%eax
  800615:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800617:	39 c2                	cmp    %eax,%edx
  800619:	75 09                	jne    800624 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80061b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800622:	eb 15                	jmp    800639 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800624:	ff 45 e8             	incl   -0x18(%ebp)
  800627:	a1 20 30 80 00       	mov    0x803020,%eax
  80062c:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800635:	39 c2                	cmp    %eax,%edx
  800637:	77 85                	ja     8005be <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800639:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80063d:	75 14                	jne    800653 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80063f:	83 ec 04             	sub    $0x4,%esp
  800642:	68 fc 22 80 00       	push   $0x8022fc
  800647:	6a 3a                	push   $0x3a
  800649:	68 f0 22 80 00       	push   $0x8022f0
  80064e:	e8 8d fe ff ff       	call   8004e0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800653:	ff 45 f0             	incl   -0x10(%ebp)
  800656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800659:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80065c:	0f 8c 2f ff ff ff    	jl     800591 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800662:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800669:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800670:	eb 26                	jmp    800698 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800672:	a1 20 30 80 00       	mov    0x803020,%eax
  800677:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80067d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800680:	89 d0                	mov    %edx,%eax
  800682:	01 c0                	add    %eax,%eax
  800684:	01 d0                	add    %edx,%eax
  800686:	c1 e0 03             	shl    $0x3,%eax
  800689:	01 c8                	add    %ecx,%eax
  80068b:	8a 40 04             	mov    0x4(%eax),%al
  80068e:	3c 01                	cmp    $0x1,%al
  800690:	75 03                	jne    800695 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800692:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800695:	ff 45 e0             	incl   -0x20(%ebp)
  800698:	a1 20 30 80 00       	mov    0x803020,%eax
  80069d:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8006a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	77 c8                	ja     800672 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b0:	74 14                	je     8006c6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	68 50 23 80 00       	push   $0x802350
  8006ba:	6a 44                	push   $0x44
  8006bc:	68 f0 22 80 00       	push   $0x8022f0
  8006c1:	e8 1a fe ff ff       	call   8004e0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006c6:	90                   	nop
  8006c7:	c9                   	leave  
  8006c8:	c3                   	ret    

008006c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8006d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006da:	89 0a                	mov    %ecx,(%edx)
  8006dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8006df:	88 d1                	mov    %dl,%cl
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f2:	75 2c                	jne    800720 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006f4:	a0 24 30 80 00       	mov    0x803024,%al
  8006f9:	0f b6 c0             	movzbl %al,%eax
  8006fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ff:	8b 12                	mov    (%edx),%edx
  800701:	89 d1                	mov    %edx,%ecx
  800703:	8b 55 0c             	mov    0xc(%ebp),%edx
  800706:	83 c2 08             	add    $0x8,%edx
  800709:	83 ec 04             	sub    $0x4,%esp
  80070c:	50                   	push   %eax
  80070d:	51                   	push   %ecx
  80070e:	52                   	push   %edx
  80070f:	e8 b0 0e 00 00       	call   8015c4 <sys_cputs>
  800714:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	8b 40 04             	mov    0x4(%eax),%eax
  800726:	8d 50 01             	lea    0x1(%eax),%edx
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80072f:	90                   	nop
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80073b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800742:	00 00 00 
	b.cnt = 0;
  800745:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80074c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	ff 75 08             	pushl  0x8(%ebp)
  800755:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075b:	50                   	push   %eax
  80075c:	68 c9 06 80 00       	push   $0x8006c9
  800761:	e8 11 02 00 00       	call   800977 <vprintfmt>
  800766:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800769:	a0 24 30 80 00       	mov    0x803024,%al
  80076e:	0f b6 c0             	movzbl %al,%eax
  800771:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800777:	83 ec 04             	sub    $0x4,%esp
  80077a:	50                   	push   %eax
  80077b:	52                   	push   %edx
  80077c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	50                   	push   %eax
  800786:	e8 39 0e 00 00       	call   8015c4 <sys_cputs>
  80078b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80078e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800795:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <cprintf>:

int cprintf(const char *fmt, ...) {
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	e8 73 ff ff ff       	call   800732 <vcprintf>
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d0:	e8 48 0f 00 00       	call   80171d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e4:	50                   	push   %eax
  8007e5:	e8 48 ff ff ff       	call   800732 <vcprintf>
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f0:	e8 42 0f 00 00       	call   801737 <sys_enable_interrupt>
	return cnt;
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	83 ec 14             	sub    $0x14,%esp
  800801:	8b 45 10             	mov    0x10(%ebp),%eax
  800804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080d:	8b 45 18             	mov    0x18(%ebp),%eax
  800810:	ba 00 00 00 00       	mov    $0x0,%edx
  800815:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800818:	77 55                	ja     80086f <printnum+0x75>
  80081a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081d:	72 05                	jb     800824 <printnum+0x2a>
  80081f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800822:	77 4b                	ja     80086f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800824:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800827:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80082a:	8b 45 18             	mov    0x18(%ebp),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	52                   	push   %edx
  800833:	50                   	push   %eax
  800834:	ff 75 f4             	pushl  -0xc(%ebp)
  800837:	ff 75 f0             	pushl  -0x10(%ebp)
  80083a:	e8 29 14 00 00       	call   801c68 <__udivdi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	ff 75 20             	pushl  0x20(%ebp)
  800848:	53                   	push   %ebx
  800849:	ff 75 18             	pushl  0x18(%ebp)
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	e8 a1 ff ff ff       	call   8007fa <printnum>
  800859:	83 c4 20             	add    $0x20,%esp
  80085c:	eb 1a                	jmp    800878 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 20             	pushl  0x20(%ebp)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086f:	ff 4d 1c             	decl   0x1c(%ebp)
  800872:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800876:	7f e6                	jg     80085e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800878:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800886:	53                   	push   %ebx
  800887:	51                   	push   %ecx
  800888:	52                   	push   %edx
  800889:	50                   	push   %eax
  80088a:	e8 e9 14 00 00       	call   801d78 <__umoddi3>
  80088f:	83 c4 10             	add    $0x10,%esp
  800892:	05 b4 25 80 00       	add    $0x8025b4,%eax
  800897:	8a 00                	mov    (%eax),%al
  800899:	0f be c0             	movsbl %al,%eax
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	50                   	push   %eax
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
}
  8008ab:	90                   	nop
  8008ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b8:	7e 1c                	jle    8008d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	8d 50 08             	lea    0x8(%eax),%edx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	89 10                	mov    %edx,(%eax)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	83 e8 08             	sub    $0x8,%eax
  8008cf:	8b 50 04             	mov    0x4(%eax),%edx
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	eb 40                	jmp    800916 <getuint+0x65>
	else if (lflag)
  8008d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008da:	74 1e                	je     8008fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8d 50 04             	lea    0x4(%eax),%edx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	89 10                	mov    %edx,(%eax)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	eb 1c                	jmp    800916 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	8d 50 04             	lea    0x4(%eax),%edx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 10                	mov    %edx,(%eax)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	83 e8 04             	sub    $0x4,%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091f:	7e 1c                	jle    80093d <getint+0x25>
		return va_arg(*ap, long long);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	8d 50 08             	lea    0x8(%eax),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 10                	mov    %edx,(%eax)
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	83 e8 08             	sub    $0x8,%eax
  800936:	8b 50 04             	mov    0x4(%eax),%edx
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	eb 38                	jmp    800975 <getint+0x5d>
	else if (lflag)
  80093d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800941:	74 1a                	je     80095d <getint+0x45>
		return va_arg(*ap, long);
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	8d 50 04             	lea    0x4(%eax),%edx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	89 10                	mov    %edx,(%eax)
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	83 e8 04             	sub    $0x4,%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	99                   	cltd   
  80095b:	eb 18                	jmp    800975 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	8d 50 04             	lea    0x4(%eax),%edx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	89 10                	mov    %edx,(%eax)
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	83 e8 04             	sub    $0x4,%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	99                   	cltd   
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	56                   	push   %esi
  80097b:	53                   	push   %ebx
  80097c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097f:	eb 17                	jmp    800998 <vprintfmt+0x21>
			if (ch == '\0')
  800981:	85 db                	test   %ebx,%ebx
  800983:	0f 84 af 03 00 00    	je     800d38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800998:	8b 45 10             	mov    0x10(%ebp),%eax
  80099b:	8d 50 01             	lea    0x1(%eax),%edx
  80099e:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a1:	8a 00                	mov    (%eax),%al
  8009a3:	0f b6 d8             	movzbl %al,%ebx
  8009a6:	83 fb 25             	cmp    $0x25,%ebx
  8009a9:	75 d6                	jne    800981 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	0f b6 d8             	movzbl %al,%ebx
  8009d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009dc:	83 f8 55             	cmp    $0x55,%eax
  8009df:	0f 87 2b 03 00 00    	ja     800d10 <vprintfmt+0x399>
  8009e5:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  8009ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f2:	eb d7                	jmp    8009cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f8:	eb d1                	jmp    8009cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a04:	89 d0                	mov    %edx,%eax
  800a06:	c1 e0 02             	shl    $0x2,%eax
  800a09:	01 d0                	add    %edx,%eax
  800a0b:	01 c0                	add    %eax,%eax
  800a0d:	01 d8                	add    %ebx,%eax
  800a0f:	83 e8 30             	sub    $0x30,%eax
  800a12:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a15:	8b 45 10             	mov    0x10(%ebp),%eax
  800a18:	8a 00                	mov    (%eax),%al
  800a1a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a20:	7e 3e                	jle    800a60 <vprintfmt+0xe9>
  800a22:	83 fb 39             	cmp    $0x39,%ebx
  800a25:	7f 39                	jg     800a60 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a27:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a2a:	eb d5                	jmp    800a01 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	83 c0 04             	add    $0x4,%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 e8 04             	sub    $0x4,%eax
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a40:	eb 1f                	jmp    800a61 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a46:	79 83                	jns    8009cb <vprintfmt+0x54>
				width = 0;
  800a48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4f:	e9 77 ff ff ff       	jmp    8009cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a54:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5b:	e9 6b ff ff ff       	jmp    8009cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a60:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a65:	0f 89 60 ff ff ff    	jns    8009cb <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a71:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a78:	e9 4e ff ff ff       	jmp    8009cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a80:	e9 46 ff ff ff       	jmp    8009cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 c0 04             	add    $0x4,%eax
  800a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 e8 04             	sub    $0x4,%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	50                   	push   %eax
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			break;
  800aa5:	e9 89 02 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 c0 04             	add    $0x4,%eax
  800ab0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 e8 04             	sub    $0x4,%eax
  800ab9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	79 02                	jns    800ac1 <vprintfmt+0x14a>
				err = -err;
  800abf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac1:	83 fb 64             	cmp    $0x64,%ebx
  800ac4:	7f 0b                	jg     800ad1 <vprintfmt+0x15a>
  800ac6:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800acd:	85 f6                	test   %esi,%esi
  800acf:	75 19                	jne    800aea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad1:	53                   	push   %ebx
  800ad2:	68 c5 25 80 00       	push   $0x8025c5
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 5e 02 00 00       	call   800d40 <printfmt>
  800ae2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae5:	e9 49 02 00 00       	jmp    800d33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aea:	56                   	push   %esi
  800aeb:	68 ce 25 80 00       	push   $0x8025ce
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	ff 75 08             	pushl  0x8(%ebp)
  800af6:	e8 45 02 00 00       	call   800d40 <printfmt>
  800afb:	83 c4 10             	add    $0x10,%esp
			break;
  800afe:	e9 30 02 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b03:	8b 45 14             	mov    0x14(%ebp),%eax
  800b06:	83 c0 04             	add    $0x4,%eax
  800b09:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 e8 04             	sub    $0x4,%eax
  800b12:	8b 30                	mov    (%eax),%esi
  800b14:	85 f6                	test   %esi,%esi
  800b16:	75 05                	jne    800b1d <vprintfmt+0x1a6>
				p = "(null)";
  800b18:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b21:	7e 6d                	jle    800b90 <vprintfmt+0x219>
  800b23:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b27:	74 67                	je     800b90 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	50                   	push   %eax
  800b30:	56                   	push   %esi
  800b31:	e8 0c 03 00 00       	call   800e42 <strnlen>
  800b36:	83 c4 10             	add    $0x10,%esp
  800b39:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3c:	eb 16                	jmp    800b54 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	50                   	push   %eax
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b51:	ff 4d e4             	decl   -0x1c(%ebp)
  800b54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b58:	7f e4                	jg     800b3e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5a:	eb 34                	jmp    800b90 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b60:	74 1c                	je     800b7e <vprintfmt+0x207>
  800b62:	83 fb 1f             	cmp    $0x1f,%ebx
  800b65:	7e 05                	jle    800b6c <vprintfmt+0x1f5>
  800b67:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6a:	7e 12                	jle    800b7e <vprintfmt+0x207>
					putch('?', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 3f                	push   $0x3f
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	eb 0f                	jmp    800b8d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	53                   	push   %ebx
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
  800b8a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b90:	89 f0                	mov    %esi,%eax
  800b92:	8d 70 01             	lea    0x1(%eax),%esi
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	0f be d8             	movsbl %al,%ebx
  800b9a:	85 db                	test   %ebx,%ebx
  800b9c:	74 24                	je     800bc2 <vprintfmt+0x24b>
  800b9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba2:	78 b8                	js     800b5c <vprintfmt+0x1e5>
  800ba4:	ff 4d e0             	decl   -0x20(%ebp)
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	79 af                	jns    800b5c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bad:	eb 13                	jmp    800bc2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	6a 20                	push   $0x20
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	ff d0                	call   *%eax
  800bbc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc6:	7f e7                	jg     800baf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc8:	e9 66 01 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd6:	50                   	push   %eax
  800bd7:	e8 3c fd ff ff       	call   800918 <getint>
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800beb:	85 d2                	test   %edx,%edx
  800bed:	79 23                	jns    800c12 <vprintfmt+0x29b>
				putch('-', putdat);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	6a 2d                	push   $0x2d
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	ff d0                	call   *%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c05:	f7 d8                	neg    %eax
  800c07:	83 d2 00             	adc    $0x0,%edx
  800c0a:	f7 da                	neg    %edx
  800c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c19:	e9 bc 00 00 00       	jmp    800cda <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 e8             	pushl  -0x18(%ebp)
  800c24:	8d 45 14             	lea    0x14(%ebp),%eax
  800c27:	50                   	push   %eax
  800c28:	e8 84 fc ff ff       	call   8008b1 <getuint>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3d:	e9 98 00 00 00       	jmp    800cda <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	6a 58                	push   $0x58
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	6a 58                	push   $0x58
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 58                	push   $0x58
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			break;
  800c72:	e9 bc 00 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	6a 30                	push   $0x30
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 78                	push   $0x78
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb9:	eb 1f                	jmp    800cda <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc4:	50                   	push   %eax
  800cc5:	e8 e7 fb ff ff       	call   8008b1 <getuint>
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cda:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce1:	83 ec 04             	sub    $0x4,%esp
  800ce4:	52                   	push   %edx
  800ce5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce8:	50                   	push   %eax
  800ce9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cec:	ff 75 f0             	pushl  -0x10(%ebp)
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 00 fb ff ff       	call   8007fa <printnum>
  800cfa:	83 c4 20             	add    $0x20,%esp
			break;
  800cfd:	eb 34                	jmp    800d33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	53                   	push   %ebx
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	ff d0                	call   *%eax
  800d0b:	83 c4 10             	add    $0x10,%esp
			break;
  800d0e:	eb 23                	jmp    800d33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	6a 25                	push   $0x25
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff d0                	call   *%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	eb 03                	jmp    800d28 <vprintfmt+0x3b1>
  800d25:	ff 4d 10             	decl   0x10(%ebp)
  800d28:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2b:	48                   	dec    %eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	3c 25                	cmp    $0x25,%al
  800d30:	75 f3                	jne    800d25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d32:	90                   	nop
		}
	}
  800d33:	e9 47 fc ff ff       	jmp    80097f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d46:	8d 45 10             	lea    0x10(%ebp),%eax
  800d49:	83 c0 04             	add    $0x4,%eax
  800d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	ff 75 f4             	pushl  -0xc(%ebp)
  800d55:	50                   	push   %eax
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	ff 75 08             	pushl  0x8(%ebp)
  800d5c:	e8 16 fc ff ff       	call   800977 <vprintfmt>
  800d61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d64:	90                   	nop
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8b 40 08             	mov    0x8(%eax),%eax
  800d70:	8d 50 01             	lea    0x1(%eax),%edx
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	8b 10                	mov    (%eax),%edx
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 40 04             	mov    0x4(%eax),%eax
  800d84:	39 c2                	cmp    %eax,%edx
  800d86:	73 12                	jae    800d9a <sprintputch+0x33>
		*b->buf++ = ch;
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d93:	89 0a                	mov    %ecx,(%edx)
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	88 10                	mov    %dl,(%eax)
}
  800d9a:	90                   	nop
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	01 d0                	add    %edx,%eax
  800db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc2:	74 06                	je     800dca <vsnprintf+0x2d>
  800dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc8:	7f 07                	jg     800dd1 <vsnprintf+0x34>
		return -E_INVAL;
  800dca:	b8 03 00 00 00       	mov    $0x3,%eax
  800dcf:	eb 20                	jmp    800df1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd1:	ff 75 14             	pushl  0x14(%ebp)
  800dd4:	ff 75 10             	pushl  0x10(%ebp)
  800dd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dda:	50                   	push   %eax
  800ddb:	68 67 0d 80 00       	push   $0x800d67
  800de0:	e8 92 fb ff ff       	call   800977 <vprintfmt>
  800de5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800deb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e02:	8b 45 10             	mov    0x10(%ebp),%eax
  800e05:	ff 75 f4             	pushl  -0xc(%ebp)
  800e08:	50                   	push   %eax
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	ff 75 08             	pushl  0x8(%ebp)
  800e0f:	e8 89 ff ff ff       	call   800d9d <vsnprintf>
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2c:	eb 06                	jmp    800e34 <strlen+0x15>
		n++;
  800e2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	84 c0                	test   %al,%al
  800e3b:	75 f1                	jne    800e2e <strlen+0xf>
		n++;
	return n;
  800e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 09                	jmp    800e5a <strnlen+0x18>
		n++;
  800e51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e54:	ff 45 08             	incl   0x8(%ebp)
  800e57:	ff 4d 0c             	decl   0xc(%ebp)
  800e5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5e:	74 09                	je     800e69 <strnlen+0x27>
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e8                	jne    800e51 <strnlen+0xf>
		n++;
	return n;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e7a:	90                   	nop
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8d 50 01             	lea    0x1(%eax),%edx
  800e81:	89 55 08             	mov    %edx,0x8(%ebp)
  800e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8d:	8a 12                	mov    (%edx),%dl
  800e8f:	88 10                	mov    %dl,(%eax)
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	84 c0                	test   %al,%al
  800e95:	75 e4                	jne    800e7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eaf:	eb 1f                	jmp    800ed0 <strncpy+0x34>
		*dst++ = *src;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8d 50 01             	lea    0x1(%eax),%edx
  800eb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebd:	8a 12                	mov    (%edx),%dl
  800ebf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	74 03                	je     800ecd <strncpy+0x31>
			src++;
  800eca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ecd:	ff 45 fc             	incl   -0x4(%ebp)
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed6:	72 d9                	jb     800eb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ee9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eed:	74 30                	je     800f1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eef:	eb 16                	jmp    800f07 <strlcpy+0x2a>
			*dst++ = *src++;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8d 50 01             	lea    0x1(%eax),%edx
  800ef7:	89 55 08             	mov    %edx,0x8(%ebp)
  800efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f03:	8a 12                	mov    (%edx),%dl
  800f05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f07:	ff 4d 10             	decl   0x10(%ebp)
  800f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0e:	74 09                	je     800f19 <strlcpy+0x3c>
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	84 c0                	test   %al,%al
  800f17:	75 d8                	jne    800ef1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	29 c2                	sub    %eax,%edx
  800f27:	89 d0                	mov    %edx,%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f2e:	eb 06                	jmp    800f36 <strcmp+0xb>
		p++, q++;
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	84 c0                	test   %al,%al
  800f3d:	74 0e                	je     800f4d <strcmp+0x22>
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 10                	mov    (%eax),%dl
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	38 c2                	cmp    %al,%dl
  800f4b:	74 e3                	je     800f30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	0f b6 d0             	movzbl %al,%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f b6 c0             	movzbl %al,%eax
  800f5d:	29 c2                	sub    %eax,%edx
  800f5f:	89 d0                	mov    %edx,%eax
}
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f66:	eb 09                	jmp    800f71 <strncmp+0xe>
		n--, p++, q++;
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 17                	je     800f8e <strncmp+0x2b>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	84 c0                	test   %al,%al
  800f7e:	74 0e                	je     800f8e <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 10                	mov    (%eax),%dl
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	38 c2                	cmp    %al,%dl
  800f8c:	74 da                	je     800f68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	75 07                	jne    800f9b <strncmp+0x38>
		return 0;
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	eb 14                	jmp    800faf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	0f b6 d0             	movzbl %al,%edx
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 c0             	movzbl %al,%eax
  800fab:	29 c2                	sub    %eax,%edx
  800fad:	89 d0                	mov    %edx,%eax
}
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbd:	eb 12                	jmp    800fd1 <strchr+0x20>
		if (*s == c)
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc7:	75 05                	jne    800fce <strchr+0x1d>
			return (char *) s;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	eb 11                	jmp    800fdf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fce:	ff 45 08             	incl   0x8(%ebp)
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	84 c0                	test   %al,%al
  800fd8:	75 e5                	jne    800fbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 04             	sub    $0x4,%esp
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fed:	eb 0d                	jmp    800ffc <strfind+0x1b>
		if (*s == c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff7:	74 0e                	je     801007 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ff9:	ff 45 08             	incl   0x8(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	75 ea                	jne    800fef <strfind+0xe>
  801005:	eb 01                	jmp    801008 <strfind+0x27>
		if (*s == c)
			break;
  801007:	90                   	nop
	return (char *) s;
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80101f:	eb 0e                	jmp    80102f <memset+0x22>
		*p++ = c;
  801021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801024:	8d 50 01             	lea    0x1(%eax),%edx
  801027:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80102a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80102f:	ff 4d f8             	decl   -0x8(%ebp)
  801032:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801036:	79 e9                	jns    801021 <memset+0x14>
		*p++ = c;

	return v;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80104f:	eb 16                	jmp    801067 <memcpy+0x2a>
		*d++ = *s++;
  801051:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801054:	8d 50 01             	lea    0x1(%eax),%edx
  801057:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801060:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801063:	8a 12                	mov    (%edx),%dl
  801065:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 dd                	jne    801051 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80108b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801091:	73 50                	jae    8010e3 <memmove+0x6a>
  801093:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109e:	76 43                	jbe    8010e3 <memmove+0x6a>
		s += n;
  8010a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ac:	eb 10                	jmp    8010be <memmove+0x45>
			*--d = *--s;
  8010ae:	ff 4d f8             	decl   -0x8(%ebp)
  8010b1:	ff 4d fc             	decl   -0x4(%ebp)
  8010b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b7:	8a 10                	mov    (%eax),%dl
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 e3                	jne    8010ae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010cb:	eb 23                	jmp    8010f0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010dc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010df:	8a 12                	mov    (%edx),%dl
  8010e1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 dd                	jne    8010cd <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801107:	eb 2a                	jmp    801133 <memcmp+0x3e>
		if (*s1 != *s2)
  801109:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 16                	je     80112d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
  80112b:	eb 18                	jmp    801145 <memcmp+0x50>
		s1++, s2++;
  80112d:	ff 45 fc             	incl   -0x4(%ebp)
  801130:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	8d 50 ff             	lea    -0x1(%eax),%edx
  801139:	89 55 10             	mov    %edx,0x10(%ebp)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	75 c9                	jne    801109 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    

00801147 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80114d:	8b 55 08             	mov    0x8(%ebp),%edx
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	01 d0                	add    %edx,%eax
  801155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801158:	eb 15                	jmp    80116f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f b6 d0             	movzbl %al,%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	0f b6 c0             	movzbl %al,%eax
  801168:	39 c2                	cmp    %eax,%edx
  80116a:	74 0d                	je     801179 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80116c:	ff 45 08             	incl   0x8(%ebp)
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801175:	72 e3                	jb     80115a <memfind+0x13>
  801177:	eb 01                	jmp    80117a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801179:	90                   	nop
	return (void *) s;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80118c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801193:	eb 03                	jmp    801198 <strtol+0x19>
		s++;
  801195:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 20                	cmp    $0x20,%al
  80119f:	74 f4                	je     801195 <strtol+0x16>
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 09                	cmp    $0x9,%al
  8011a8:	74 eb                	je     801195 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 2b                	cmp    $0x2b,%al
  8011b1:	75 05                	jne    8011b8 <strtol+0x39>
		s++;
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	eb 13                	jmp    8011cb <strtol+0x4c>
	else if (*s == '-')
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 2d                	cmp    $0x2d,%al
  8011bf:	75 0a                	jne    8011cb <strtol+0x4c>
		s++, neg = 1;
  8011c1:	ff 45 08             	incl   0x8(%ebp)
  8011c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cf:	74 06                	je     8011d7 <strtol+0x58>
  8011d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011d5:	75 20                	jne    8011f7 <strtol+0x78>
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 30                	cmp    $0x30,%al
  8011de:	75 17                	jne    8011f7 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	40                   	inc    %eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 78                	cmp    $0x78,%al
  8011e8:	75 0d                	jne    8011f7 <strtol+0x78>
		s += 2, base = 16;
  8011ea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011f5:	eb 28                	jmp    80121f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fb:	75 15                	jne    801212 <strtol+0x93>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 30                	cmp    $0x30,%al
  801204:	75 0c                	jne    801212 <strtol+0x93>
		s++, base = 8;
  801206:	ff 45 08             	incl   0x8(%ebp)
  801209:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801210:	eb 0d                	jmp    80121f <strtol+0xa0>
	else if (base == 0)
  801212:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801216:	75 07                	jne    80121f <strtol+0xa0>
		base = 10;
  801218:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 2f                	cmp    $0x2f,%al
  801226:	7e 19                	jle    801241 <strtol+0xc2>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 39                	cmp    $0x39,%al
  80122f:	7f 10                	jg     801241 <strtol+0xc2>
			dig = *s - '0';
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	0f be c0             	movsbl %al,%eax
  801239:	83 e8 30             	sub    $0x30,%eax
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123f:	eb 42                	jmp    801283 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	3c 60                	cmp    $0x60,%al
  801248:	7e 19                	jle    801263 <strtol+0xe4>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 7a                	cmp    $0x7a,%al
  801251:	7f 10                	jg     801263 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f be c0             	movsbl %al,%eax
  80125b:	83 e8 57             	sub    $0x57,%eax
  80125e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801261:	eb 20                	jmp    801283 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 40                	cmp    $0x40,%al
  80126a:	7e 39                	jle    8012a5 <strtol+0x126>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 5a                	cmp    $0x5a,%al
  801273:	7f 30                	jg     8012a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	83 e8 37             	sub    $0x37,%eax
  801280:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801286:	3b 45 10             	cmp    0x10(%ebp),%eax
  801289:	7d 19                	jge    8012a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801291:	0f af 45 10          	imul   0x10(%ebp),%eax
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80129f:	e9 7b ff ff ff       	jmp    80121f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a9:	74 08                	je     8012b3 <strtol+0x134>
		*endptr = (char *) s;
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012b7:	74 07                	je     8012c0 <strtol+0x141>
  8012b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bc:	f7 d8                	neg    %eax
  8012be:	eb 03                	jmp    8012c3 <strtol+0x144>
  8012c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012dd:	79 13                	jns    8012f2 <ltostr+0x2d>
	{
		neg = 1;
  8012df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012fa:	99                   	cltd   
  8012fb:	f7 f9                	idiv   %ecx
  8012fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801303:	8d 50 01             	lea    0x1(%eax),%edx
  801306:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801309:	89 c2                	mov    %eax,%edx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801313:	83 c2 30             	add    $0x30,%edx
  801316:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801318:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801320:	f7 e9                	imul   %ecx
  801322:	c1 fa 02             	sar    $0x2,%edx
  801325:	89 c8                	mov    %ecx,%eax
  801327:	c1 f8 1f             	sar    $0x1f,%eax
  80132a:	29 c2                	sub    %eax,%edx
  80132c:	89 d0                	mov    %edx,%eax
  80132e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801331:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801334:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801339:	f7 e9                	imul   %ecx
  80133b:	c1 fa 02             	sar    $0x2,%edx
  80133e:	89 c8                	mov    %ecx,%eax
  801340:	c1 f8 1f             	sar    $0x1f,%eax
  801343:	29 c2                	sub    %eax,%edx
  801345:	89 d0                	mov    %edx,%eax
  801347:	c1 e0 02             	shl    $0x2,%eax
  80134a:	01 d0                	add    %edx,%eax
  80134c:	01 c0                	add    %eax,%eax
  80134e:	29 c1                	sub    %eax,%ecx
  801350:	89 ca                	mov    %ecx,%edx
  801352:	85 d2                	test   %edx,%edx
  801354:	75 9c                	jne    8012f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801356:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801360:	48                   	dec    %eax
  801361:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801364:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801368:	74 3d                	je     8013a7 <ltostr+0xe2>
		start = 1 ;
  80136a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801371:	eb 34                	jmp    8013a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801383:	8b 45 0c             	mov    0xc(%ebp),%eax
  801386:	01 c2                	add    %eax,%edx
  801388:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80138b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138e:	01 c8                	add    %ecx,%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801394:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	01 c2                	add    %eax,%edx
  80139c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80139f:	88 02                	mov    %al,(%edx)
		start++ ;
  8013a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ad:	7c c4                	jl     801373 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b5:	01 d0                	add    %edx,%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ba:	90                   	nop
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013c3:	ff 75 08             	pushl  0x8(%ebp)
  8013c6:	e8 54 fa ff ff       	call   800e1f <strlen>
  8013cb:	83 c4 04             	add    $0x4,%esp
  8013ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	e8 46 fa ff ff       	call   800e1f <strlen>
  8013d9:	83 c4 04             	add    $0x4,%esp
  8013dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 17                	jmp    801406 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f5:	01 c2                	add    %eax,%edx
  8013f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801403:	ff 45 fc             	incl   -0x4(%ebp)
  801406:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801409:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80140c:	7c e1                	jl     8013ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80140e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801415:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80141c:	eb 1f                	jmp    80143d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80141e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801421:	8d 50 01             	lea    0x1(%eax),%edx
  801424:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801427:	89 c2                	mov    %eax,%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 c2                	add    %eax,%edx
  80142e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 c8                	add    %ecx,%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80143a:	ff 45 f8             	incl   -0x8(%ebp)
  80143d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801440:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801443:	7c d9                	jl     80141e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	c6 00 00             	movb   $0x0,(%eax)
}
  801450:	90                   	nop
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	01 d0                	add    %edx,%eax
  801470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801476:	eb 0c                	jmp    801484 <strsplit+0x31>
			*string++ = 0;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8d 50 01             	lea    0x1(%eax),%edx
  80147e:	89 55 08             	mov    %edx,0x8(%ebp)
  801481:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	84 c0                	test   %al,%al
  80148b:	74 18                	je     8014a5 <strsplit+0x52>
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	0f be c0             	movsbl %al,%eax
  801495:	50                   	push   %eax
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	e8 13 fb ff ff       	call   800fb1 <strchr>
  80149e:	83 c4 08             	add    $0x8,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	75 d3                	jne    801478 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	84 c0                	test   %al,%al
  8014ac:	74 5a                	je     801508 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b1:	8b 00                	mov    (%eax),%eax
  8014b3:	83 f8 0f             	cmp    $0xf,%eax
  8014b6:	75 07                	jne    8014bf <strsplit+0x6c>
		{
			return 0;
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	eb 66                	jmp    801525 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c2:	8b 00                	mov    (%eax),%eax
  8014c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014ca:	89 0a                	mov    %ecx,(%edx)
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 c2                	add    %eax,%edx
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014dd:	eb 03                	jmp    8014e2 <strsplit+0x8f>
			string++;
  8014df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	84 c0                	test   %al,%al
  8014e9:	74 8b                	je     801476 <strsplit+0x23>
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	0f be c0             	movsbl %al,%eax
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	e8 b5 fa ff ff       	call   800fb1 <strchr>
  8014fc:	83 c4 08             	add    $0x8,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 dc                	je     8014df <strsplit+0x8c>
			string++;
	}
  801503:	e9 6e ff ff ff       	jmp    801476 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801508:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	8b 00                	mov    (%eax),%eax
  80150e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801520:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80152d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801534:	eb 4c                	jmp    801582 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801536:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	01 d0                	add    %edx,%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	3c 40                	cmp    $0x40,%al
  801542:	7e 27                	jle    80156b <str2lower+0x44>
  801544:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	3c 5a                	cmp    $0x5a,%al
  801550:	7f 19                	jg     80156b <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801552:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	01 d0                	add    %edx,%eax
  80155a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80155d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801560:	01 ca                	add    %ecx,%edx
  801562:	8a 12                	mov    (%edx),%dl
  801564:	83 c2 20             	add    $0x20,%edx
  801567:	88 10                	mov    %dl,(%eax)
  801569:	eb 14                	jmp    80157f <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80156b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	01 c2                	add    %eax,%edx
  801573:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801576:	8b 45 0c             	mov    0xc(%ebp),%eax
  801579:	01 c8                	add    %ecx,%eax
  80157b:	8a 00                	mov    (%eax),%al
  80157d:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80157f:	ff 45 fc             	incl   -0x4(%ebp)
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	e8 95 f8 ff ff       	call   800e1f <strlen>
  80158a:	83 c4 04             	add    $0x4,%esp
  80158d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801590:	7f a4                	jg     801536 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801592:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	57                   	push   %edi
  80159d:	56                   	push   %esi
  80159e:	53                   	push   %ebx
  80159f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015b4:	cd 30                	int    $0x30
  8015b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5f                   	pop    %edi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	52                   	push   %edx
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	6a 00                	push   $0x0
  8015e2:	e8 b2 ff ff ff       	call   801599 <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	90                   	nop
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 01                	push   $0x1
  8015fc:	e8 98 ff ff ff       	call   801599 <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801609:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	52                   	push   %edx
  801616:	50                   	push   %eax
  801617:	6a 05                	push   $0x5
  801619:	e8 7b ff ff ff       	call   801599 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801628:	8b 75 18             	mov    0x18(%ebp),%esi
  80162b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	51                   	push   %ecx
  80163a:	52                   	push   %edx
  80163b:	50                   	push   %eax
  80163c:	6a 06                	push   $0x6
  80163e:	e8 56 ff ff ff       	call   801599 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801649:	5b                   	pop    %ebx
  80164a:	5e                   	pop    %esi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    

0080164d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801650:	8b 55 0c             	mov    0xc(%ebp),%edx
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	52                   	push   %edx
  80165d:	50                   	push   %eax
  80165e:	6a 07                	push   $0x7
  801660:	e8 34 ff ff ff       	call   801599 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	ff 75 08             	pushl  0x8(%ebp)
  801679:	6a 08                	push   $0x8
  80167b:	e8 19 ff ff ff       	call   801599 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 09                	push   $0x9
  801694:	e8 00 ff ff ff       	call   801599 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 0a                	push   $0xa
  8016ad:	e8 e7 fe ff ff       	call   801599 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 0b                	push   $0xb
  8016c6:	e8 ce fe ff ff       	call   801599 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 0c                	push   $0xc
  8016df:	e8 b5 fe ff ff       	call   801599 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 08             	pushl  0x8(%ebp)
  8016f7:	6a 0d                	push   $0xd
  8016f9:	e8 9b fe ff ff       	call   801599 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 0e                	push   $0xe
  801712:	e8 82 fe ff ff       	call   801599 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	90                   	nop
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 11                	push   $0x11
  80172c:	e8 68 fe ff ff       	call   801599 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	90                   	nop
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 12                	push   $0x12
  801746:	e8 4e fe ff ff       	call   801599 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_cputc>:


void
sys_cputc(const char c)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	50                   	push   %eax
  80176a:	6a 13                	push   $0x13
  80176c:	e8 28 fe ff ff       	call   801599 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 14                	push   $0x14
  801786:	e8 0e fe ff ff       	call   801599 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	90                   	nop
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	50                   	push   %eax
  8017a1:	6a 15                	push   $0x15
  8017a3:	e8 f1 fd ff ff       	call   801599 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	52                   	push   %edx
  8017bd:	50                   	push   %eax
  8017be:	6a 18                	push   $0x18
  8017c0:	e8 d4 fd ff ff       	call   801599 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 16                	push   $0x16
  8017dd:	e8 b7 fd ff ff       	call   801599 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	90                   	nop
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 17                	push   $0x17
  8017fb:	e8 99 fd ff ff       	call   801599 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801812:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801815:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	51                   	push   %ecx
  80181f:	52                   	push   %edx
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	6a 19                	push   $0x19
  801826:	e8 6e fd ff ff       	call   801599 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801833:	8b 55 0c             	mov    0xc(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	52                   	push   %edx
  801840:	50                   	push   %eax
  801841:	6a 1a                	push   $0x1a
  801843:	e8 51 fd ff ff       	call   801599 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801850:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	51                   	push   %ecx
  80185e:	52                   	push   %edx
  80185f:	50                   	push   %eax
  801860:	6a 1b                	push   $0x1b
  801862:	e8 32 fd ff ff       	call   801599 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 1c                	push   $0x1c
  80187f:	e8 15 fd ff ff       	call   801599 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 1d                	push   $0x1d
  801898:	e8 fc fc ff ff       	call   801599 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	ff 75 14             	pushl  0x14(%ebp)
  8018ad:	ff 75 10             	pushl  0x10(%ebp)
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	50                   	push   %eax
  8018b4:	6a 1e                	push   $0x1e
  8018b6:	e8 de fc ff ff       	call   801599 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	50                   	push   %eax
  8018cf:	6a 1f                	push   $0x1f
  8018d1:	e8 c3 fc ff ff       	call   801599 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	90                   	nop
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	50                   	push   %eax
  8018eb:	6a 20                	push   $0x20
  8018ed:	e8 a7 fc ff ff       	call   801599 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 02                	push   $0x2
  801906:	e8 8e fc ff ff       	call   801599 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 03                	push   $0x3
  80191f:	e8 75 fc ff ff       	call   801599 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 04                	push   $0x4
  801938:	e8 5c fc ff ff       	call   801599 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_exit_env>:


void sys_exit_env(void)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 21                	push   $0x21
  801951:	e8 43 fc ff ff       	call   801599 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	90                   	nop
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801962:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801965:	8d 50 04             	lea    0x4(%eax),%edx
  801968:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 22                	push   $0x22
  801975:	e8 1f fc ff ff       	call   801599 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return result;
  80197d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801980:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	89 01                	mov    %eax,(%ecx)
  801988:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	c9                   	leave  
  80198f:	c2 04 00             	ret    $0x4

00801992 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 10                	push   $0x10
  8019a4:	e8 f0 fb ff ff       	call   801599 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_rcr2>:
uint32 sys_rcr2()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 23                	push   $0x23
  8019be:	e8 d6 fb ff ff       	call   801599 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	50                   	push   %eax
  8019e1:	6a 24                	push   $0x24
  8019e3:	e8 b1 fb ff ff       	call   801599 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <rsttst>:
void rsttst()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 26                	push   $0x26
  8019fd:	e8 97 fb ff ff       	call   801599 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a14:	8b 55 18             	mov    0x18(%ebp),%edx
  801a17:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	ff 75 10             	pushl  0x10(%ebp)
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	ff 75 08             	pushl  0x8(%ebp)
  801a26:	6a 25                	push   $0x25
  801a28:	e8 6c fb ff ff       	call   801599 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <chktst>:
void chktst(uint32 n)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 27                	push   $0x27
  801a43:	e8 51 fb ff ff       	call   801599 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <inctst>:

void inctst()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 28                	push   $0x28
  801a5d:	e8 37 fb ff ff       	call   801599 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
	return ;
  801a65:	90                   	nop
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <gettst>:
uint32 gettst()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 29                	push   $0x29
  801a77:	e8 1d fb ff ff       	call   801599 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 2a                	push   $0x2a
  801a93:	e8 01 fb ff ff       	call   801599 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
  801a9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a9e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aa2:	75 07                	jne    801aab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aa4:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa9:	eb 05                	jmp    801ab0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 2a                	push   $0x2a
  801ac4:	e8 d0 fa ff ff       	call   801599 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
  801acc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801acf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ad3:	75 07                	jne    801adc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ad5:	b8 01 00 00 00       	mov    $0x1,%eax
  801ada:	eb 05                	jmp    801ae1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801adc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 2a                	push   $0x2a
  801af5:	e8 9f fa ff ff       	call   801599 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
  801afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b00:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b04:	75 07                	jne    801b0d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b06:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0b:	eb 05                	jmp    801b12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 2a                	push   $0x2a
  801b26:	e8 6e fa ff ff       	call   801599 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b31:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b35:	75 07                	jne    801b3e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b37:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3c:	eb 05                	jmp    801b43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 2b                	push   $0x2b
  801b55:	e8 3f fa ff ff       	call   801599 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	6a 00                	push   $0x0
  801b72:	53                   	push   %ebx
  801b73:	51                   	push   %ecx
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 2c                	push   $0x2c
  801b78:	e8 1c fa ff ff       	call   801599 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 2d                	push   $0x2d
  801b98:	e8 fc f9 ff ff       	call   801599 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ba5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	51                   	push   %ecx
  801bb1:	ff 75 10             	pushl  0x10(%ebp)
  801bb4:	52                   	push   %edx
  801bb5:	50                   	push   %eax
  801bb6:	6a 2e                	push   $0x2e
  801bb8:	e8 dc f9 ff ff       	call   801599 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 10             	pushl  0x10(%ebp)
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 0f                	push   $0xf
  801bd4:	e8 c0 f9 ff ff       	call   801599 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdc:	90                   	nop
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	50                   	push   %eax
  801bee:	6a 2f                	push   $0x2f
  801bf0:	e8 a4 f9 ff ff       	call   801599 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp

}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 30                	push   $0x30
  801c0b:	e8 89 f9 ff ff       	call   801599 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	6a 31                	push   $0x31
  801c27:	e8 6d f9 ff ff       	call   801599 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 32                	push   $0x32
  801c41:	e8 53 f9 ff ff       	call   801599 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	50                   	push   %eax
  801c5a:	6a 33                	push   $0x33
  801c5c:	e8 38 f9 ff ff       	call   801599 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    
  801c67:	90                   	nop

00801c68 <__udivdi3>:
  801c68:	55                   	push   %ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 1c             	sub    $0x1c,%esp
  801c6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7f:	89 ca                	mov    %ecx,%edx
  801c81:	89 f8                	mov    %edi,%eax
  801c83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c87:	85 f6                	test   %esi,%esi
  801c89:	75 2d                	jne    801cb8 <__udivdi3+0x50>
  801c8b:	39 cf                	cmp    %ecx,%edi
  801c8d:	77 65                	ja     801cf4 <__udivdi3+0x8c>
  801c8f:	89 fd                	mov    %edi,%ebp
  801c91:	85 ff                	test   %edi,%edi
  801c93:	75 0b                	jne    801ca0 <__udivdi3+0x38>
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	31 d2                	xor    %edx,%edx
  801c9c:	f7 f7                	div    %edi
  801c9e:	89 c5                	mov    %eax,%ebp
  801ca0:	31 d2                	xor    %edx,%edx
  801ca2:	89 c8                	mov    %ecx,%eax
  801ca4:	f7 f5                	div    %ebp
  801ca6:	89 c1                	mov    %eax,%ecx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	f7 f5                	div    %ebp
  801cac:	89 cf                	mov    %ecx,%edi
  801cae:	89 fa                	mov    %edi,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	77 28                	ja     801ce4 <__udivdi3+0x7c>
  801cbc:	0f bd fe             	bsr    %esi,%edi
  801cbf:	83 f7 1f             	xor    $0x1f,%edi
  801cc2:	75 40                	jne    801d04 <__udivdi3+0x9c>
  801cc4:	39 ce                	cmp    %ecx,%esi
  801cc6:	72 0a                	jb     801cd2 <__udivdi3+0x6a>
  801cc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ccc:	0f 87 9e 00 00 00    	ja     801d70 <__udivdi3+0x108>
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	89 fa                	mov    %edi,%edx
  801cd9:	83 c4 1c             	add    $0x1c,%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5f                   	pop    %edi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    
  801ce1:	8d 76 00             	lea    0x0(%esi),%esi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	31 c0                	xor    %eax,%eax
  801ce8:	89 fa                	mov    %edi,%edx
  801cea:	83 c4 1c             	add    $0x1c,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5e                   	pop    %esi
  801cef:	5f                   	pop    %edi
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	89 d8                	mov    %ebx,%eax
  801cf6:	f7 f7                	div    %edi
  801cf8:	31 ff                	xor    %edi,%edi
  801cfa:	89 fa                	mov    %edi,%edx
  801cfc:	83 c4 1c             	add    $0x1c,%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5f                   	pop    %edi
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    
  801d04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d09:	89 eb                	mov    %ebp,%ebx
  801d0b:	29 fb                	sub    %edi,%ebx
  801d0d:	89 f9                	mov    %edi,%ecx
  801d0f:	d3 e6                	shl    %cl,%esi
  801d11:	89 c5                	mov    %eax,%ebp
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ed                	shr    %cl,%ebp
  801d17:	89 e9                	mov    %ebp,%ecx
  801d19:	09 f1                	or     %esi,%ecx
  801d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e0                	shl    %cl,%eax
  801d23:	89 c5                	mov    %eax,%ebp
  801d25:	89 d6                	mov    %edx,%esi
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 ee                	shr    %cl,%esi
  801d2b:	89 f9                	mov    %edi,%ecx
  801d2d:	d3 e2                	shl    %cl,%edx
  801d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d33:	88 d9                	mov    %bl,%cl
  801d35:	d3 e8                	shr    %cl,%eax
  801d37:	09 c2                	or     %eax,%edx
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	89 f2                	mov    %esi,%edx
  801d3d:	f7 74 24 0c          	divl   0xc(%esp)
  801d41:	89 d6                	mov    %edx,%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	f7 e5                	mul    %ebp
  801d47:	39 d6                	cmp    %edx,%esi
  801d49:	72 19                	jb     801d64 <__udivdi3+0xfc>
  801d4b:	74 0b                	je     801d58 <__udivdi3+0xf0>
  801d4d:	89 d8                	mov    %ebx,%eax
  801d4f:	31 ff                	xor    %edi,%edi
  801d51:	e9 58 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d5c:	89 f9                	mov    %edi,%ecx
  801d5e:	d3 e2                	shl    %cl,%edx
  801d60:	39 c2                	cmp    %eax,%edx
  801d62:	73 e9                	jae    801d4d <__udivdi3+0xe5>
  801d64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d67:	31 ff                	xor    %edi,%edi
  801d69:	e9 40 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d6e:	66 90                	xchg   %ax,%ax
  801d70:	31 c0                	xor    %eax,%eax
  801d72:	e9 37 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d77:	90                   	nop

00801d78 <__umoddi3>:
  801d78:	55                   	push   %ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 1c             	sub    $0x1c,%esp
  801d7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d97:	89 f3                	mov    %esi,%ebx
  801d99:	89 fa                	mov    %edi,%edx
  801d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9f:	89 34 24             	mov    %esi,(%esp)
  801da2:	85 c0                	test   %eax,%eax
  801da4:	75 1a                	jne    801dc0 <__umoddi3+0x48>
  801da6:	39 f7                	cmp    %esi,%edi
  801da8:	0f 86 a2 00 00 00    	jbe    801e50 <__umoddi3+0xd8>
  801dae:	89 c8                	mov    %ecx,%eax
  801db0:	89 f2                	mov    %esi,%edx
  801db2:	f7 f7                	div    %edi
  801db4:	89 d0                	mov    %edx,%eax
  801db6:	31 d2                	xor    %edx,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	39 f0                	cmp    %esi,%eax
  801dc2:	0f 87 ac 00 00 00    	ja     801e74 <__umoddi3+0xfc>
  801dc8:	0f bd e8             	bsr    %eax,%ebp
  801dcb:	83 f5 1f             	xor    $0x1f,%ebp
  801dce:	0f 84 ac 00 00 00    	je     801e80 <__umoddi3+0x108>
  801dd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801dd9:	29 ef                	sub    %ebp,%edi
  801ddb:	89 fe                	mov    %edi,%esi
  801ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e0                	shl    %cl,%eax
  801de5:	89 d7                	mov    %edx,%edi
  801de7:	89 f1                	mov    %esi,%ecx
  801de9:	d3 ef                	shr    %cl,%edi
  801deb:	09 c7                	or     %eax,%edi
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 e2                	shl    %cl,%edx
  801df1:	89 14 24             	mov    %edx,(%esp)
  801df4:	89 d8                	mov    %ebx,%eax
  801df6:	d3 e0                	shl    %cl,%eax
  801df8:	89 c2                	mov    %eax,%edx
  801dfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfe:	d3 e0                	shl    %cl,%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e08:	89 f1                	mov    %esi,%ecx
  801e0a:	d3 e8                	shr    %cl,%eax
  801e0c:	09 d0                	or     %edx,%eax
  801e0e:	d3 eb                	shr    %cl,%ebx
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	f7 f7                	div    %edi
  801e14:	89 d3                	mov    %edx,%ebx
  801e16:	f7 24 24             	mull   (%esp)
  801e19:	89 c6                	mov    %eax,%esi
  801e1b:	89 d1                	mov    %edx,%ecx
  801e1d:	39 d3                	cmp    %edx,%ebx
  801e1f:	0f 82 87 00 00 00    	jb     801eac <__umoddi3+0x134>
  801e25:	0f 84 91 00 00 00    	je     801ebc <__umoddi3+0x144>
  801e2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e2f:	29 f2                	sub    %esi,%edx
  801e31:	19 cb                	sbb    %ecx,%ebx
  801e33:	89 d8                	mov    %ebx,%eax
  801e35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e39:	d3 e0                	shl    %cl,%eax
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	d3 ea                	shr    %cl,%edx
  801e3f:	09 d0                	or     %edx,%eax
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 eb                	shr    %cl,%ebx
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	83 c4 1c             	add    $0x1c,%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
  801e4f:	90                   	nop
  801e50:	89 fd                	mov    %edi,%ebp
  801e52:	85 ff                	test   %edi,%edi
  801e54:	75 0b                	jne    801e61 <__umoddi3+0xe9>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 f0                	mov    %esi,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 c8                	mov    %ecx,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	e9 44 ff ff ff       	jmp    801db6 <__umoddi3+0x3e>
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	89 c8                	mov    %ecx,%eax
  801e76:	89 f2                	mov    %esi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	3b 04 24             	cmp    (%esp),%eax
  801e83:	72 06                	jb     801e8b <__umoddi3+0x113>
  801e85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e89:	77 0f                	ja     801e9a <__umoddi3+0x122>
  801e8b:	89 f2                	mov    %esi,%edx
  801e8d:	29 f9                	sub    %edi,%ecx
  801e8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e93:	89 14 24             	mov    %edx,(%esp)
  801e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e9e:	8b 14 24             	mov    (%esp),%edx
  801ea1:	83 c4 1c             	add    $0x1c,%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    
  801ea9:	8d 76 00             	lea    0x0(%esi),%esi
  801eac:	2b 04 24             	sub    (%esp),%eax
  801eaf:	19 fa                	sbb    %edi,%edx
  801eb1:	89 d1                	mov    %edx,%ecx
  801eb3:	89 c6                	mov    %eax,%esi
  801eb5:	e9 71 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ec0:	72 ea                	jb     801eac <__umoddi3+0x134>
  801ec2:	89 d9                	mov    %ebx,%ecx
  801ec4:	e9 62 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
