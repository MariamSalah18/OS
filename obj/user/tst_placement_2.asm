
obj/user/tst_placement_2:     file format elf32-i386


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
  800031:	e8 72 03 00 00       	call   8003a8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>
extern uint32 initFreeFrames;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 80 00 00 01    	sub    $0x1000080,%esp
	int8 arr[PAGE_SIZE*1024*4];

	//uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[13] ;
	{
		actual_active_list[0] = 0xedbfd000;
  800043:	c7 85 9c ff ff fe 00 	movl   $0xedbfd000,-0x1000064(%ebp)
  80004a:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  80004d:	c7 85 a0 ff ff fe 00 	movl   $0xeebfd000,-0x1000060(%ebp)
  800054:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  800057:	c7 85 a4 ff ff fe 00 	movl   $0x803000,-0x100005c(%ebp)
  80005e:	30 80 00 
		actual_active_list[3] = 0x802000;
  800061:	c7 85 a8 ff ff fe 00 	movl   $0x802000,-0x1000058(%ebp)
  800068:	20 80 00 
		actual_active_list[4] = 0x801000;
  80006b:	c7 85 ac ff ff fe 00 	movl   $0x801000,-0x1000054(%ebp)
  800072:	10 80 00 
		actual_active_list[5] = 0x800000;
  800075:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  80007c:	00 80 00 
		actual_active_list[6] = 0x205000;
  80007f:	c7 85 b4 ff ff fe 00 	movl   $0x205000,-0x100004c(%ebp)
  800086:	50 20 00 
		actual_active_list[7] = 0x204000;
  800089:	c7 85 b8 ff ff fe 00 	movl   $0x204000,-0x1000048(%ebp)
  800090:	40 20 00 
		actual_active_list[8] = 0x203000;
  800093:	c7 85 bc ff ff fe 00 	movl   $0x203000,-0x1000044(%ebp)
  80009a:	30 20 00 
		actual_active_list[9] = 0x202000;
  80009d:	c7 85 c0 ff ff fe 00 	movl   $0x202000,-0x1000040(%ebp)
  8000a4:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000a7:	c7 85 c4 ff ff fe 00 	movl   $0x201000,-0x100003c(%ebp)
  8000ae:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b1:	c7 85 c8 ff ff fe 00 	movl   $0x200000,-0x1000038(%ebp)
  8000b8:	00 20 00 
	}
	uint32 actual_second_list[7] = {};
  8000bb:	8d 95 80 ff ff fe    	lea    -0x1000080(%ebp),%edx
  8000c1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000cf:	6a 00                	push   $0x0
  8000d1:	6a 0c                	push   $0xc
  8000d3:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 6e 1a 00 00       	call   801b54 <sys_check_LRU_lists>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(check == 0)
  8000ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000f0:	75 14                	jne    800106 <_main+0xce>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 c0 1e 80 00       	push   $0x801ec0
  8000fa:	6a 24                	push   $0x24
  8000fc:	68 42 1f 80 00       	push   $0x801f42
  800101:	e8 d0 03 00 00       	call   8004d6 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800106:	e8 b9 15 00 00       	call   8016c4 <sys_pf_calculate_allocated_pages>
  80010b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int freePages = sys_calculate_free_frames();
  80010e:	e8 66 15 00 00       	call   801679 <sys_calculate_free_frames>
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int i=0;
  800116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80011d:	eb 11                	jmp    800130 <_main+0xf8>
	{
		arr[i] = -1;
  80011f:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80012d:	ff 45 f4             	incl   -0xc(%ebp)
  800130:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800137:	7e e6                	jle    80011f <_main+0xe7>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800139:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800140:	eb 11                	jmp    800153 <_main+0x11b>
	{
		arr[i] = -1;
  800142:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800150:	ff 45 f4             	incl   -0xc(%ebp)
  800153:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80015a:	7e e6                	jle    800142 <_main+0x10a>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  80015c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800163:	eb 11                	jmp    800176 <_main+0x13e>
	{
		arr[i] = -1;
  800165:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  80016b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800173:	ff 45 f4             	incl   -0xc(%ebp)
  800176:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  80017d:	7e e6                	jle    800165 <_main+0x12d>
	{
		arr[i] = -1;
	}

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 5c 1f 80 00       	push   $0x801f5c
  800187:	e8 07 06 00 00       	call   800793 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  80018f:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  800195:	3c ff                	cmp    $0xff,%al
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 8c 1f 80 00       	push   $0x801f8c
  8001a1:	6a 3f                	push   $0x3f
  8001a3:	68 42 1f 80 00       	push   $0x801f42
  8001a8:	e8 29 03 00 00       	call   8004d6 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8001ad:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  8001b3:	3c ff                	cmp    $0xff,%al
  8001b5:	74 14                	je     8001cb <_main+0x193>
  8001b7:	83 ec 04             	sub    $0x4,%esp
  8001ba:	68 8c 1f 80 00       	push   $0x801f8c
  8001bf:	6a 40                	push   $0x40
  8001c1:	68 42 1f 80 00       	push   $0x801f42
  8001c6:	e8 0b 03 00 00       	call   8004d6 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8001cb:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8001d1:	3c ff                	cmp    $0xff,%al
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 8c 1f 80 00       	push   $0x801f8c
  8001dd:	6a 42                	push   $0x42
  8001df:	68 42 1f 80 00       	push   $0x801f42
  8001e4:	e8 ed 02 00 00       	call   8004d6 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8001e9:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  8001ef:	3c ff                	cmp    $0xff,%al
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 8c 1f 80 00       	push   $0x801f8c
  8001fb:	6a 43                	push   $0x43
  8001fd:	68 42 1f 80 00       	push   $0x801f42
  800202:	e8 cf 02 00 00       	call   8004d6 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  800207:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  80020d:	3c ff                	cmp    $0xff,%al
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 8c 1f 80 00       	push   $0x801f8c
  800219:	6a 45                	push   $0x45
  80021b:	68 42 1f 80 00       	push   $0x801f42
  800220:	e8 b1 02 00 00       	call   8004d6 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800225:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  80022b:	3c ff                	cmp    $0xff,%al
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 8c 1f 80 00       	push   $0x801f8c
  800237:	6a 46                	push   $0x46
  800239:	68 42 1f 80 00       	push   $0x801f42
  80023e:	e8 93 02 00 00       	call   8004d6 <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages should NOT written to Page File until it's replaced");
  800243:	e8 7c 14 00 00       	call   8016c4 <sys_pf_calculate_allocated_pages>
  800248:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80024b:	74 14                	je     800261 <_main+0x229>
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 ac 1f 80 00       	push   $0x801fac
  800255:	6a 49                	push   $0x49
  800257:	68 42 1f 80 00       	push   $0x801f42
  80025c:	e8 75 02 00 00       	call   8004d6 <_panic>

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800261:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  800268:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80026b:	e8 09 14 00 00       	call   801679 <sys_calculate_free_frames>
  800270:	29 c3                	sub    %eax,%ebx
  800272:	89 d8                	mov    %ebx,%eax
  800274:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
  800277:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80027d:	74 1a                	je     800299 <_main+0x261>
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d4             	pushl  -0x2c(%ebp)
  800285:	ff 75 d8             	pushl  -0x28(%ebp)
  800288:	68 f0 1f 80 00       	push   $0x801ff0
  80028d:	6a 4e                	push   $0x4e
  80028f:	68 42 1f 80 00       	push   $0x801f42
  800294:	e8 3d 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	68 2c 20 80 00       	push   $0x80202c
  8002a1:	e8 ed 04 00 00       	call   800793 <cprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp

	int j=0;
  8002a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (int i=3;i>=0;i--,j++)
  8002b0:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)
  8002b7:	eb 1f                	jmp    8002d8 <_main+0x2a0>
		actual_second_list[i]=actual_active_list[11-j];
  8002b9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002be:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8002c1:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	89 94 85 80 ff ff fe 	mov    %edx,-0x1000080(%ebp,%eax,4)
		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
  8002d2:	ff 4d ec             	decl   -0x14(%ebp)
  8002d5:	ff 45 f0             	incl   -0x10(%ebp)
  8002d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002dc:	79 db                	jns    8002b9 <_main+0x281>
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  8002de:	c7 45 e8 0c 00 00 00 	movl   $0xc,-0x18(%ebp)
  8002e5:	eb 1a                	jmp    800301 <_main+0x2c9>
		actual_active_list[i]=actual_active_list[i-5];
  8002e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ea:	83 e8 05             	sub    $0x5,%eax
  8002ed:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  8002f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f7:	89 94 85 9c ff ff fe 	mov    %edx,-0x1000064(%ebp,%eax,4)
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  8002fe:	ff 4d e8             	decl   -0x18(%ebp)
  800301:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  800305:	7f e0                	jg     8002e7 <_main+0x2af>
		actual_active_list[i]=actual_active_list[i-5];
	actual_active_list[0]=0xee3fe000;
  800307:	c7 85 9c ff ff fe 00 	movl   $0xee3fe000,-0x1000064(%ebp)
  80030e:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800311:	c7 85 a0 ff ff fe 00 	movl   $0xee3fd000,-0x1000060(%ebp)
  800318:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  80031b:	c7 85 a4 ff ff fe 00 	movl   $0xedffe000,-0x100005c(%ebp)
  800322:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  800325:	c7 85 a8 ff ff fe 00 	movl   $0xedffd000,-0x1000058(%ebp)
  80032c:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  80032f:	c7 85 ac ff ff fe 00 	movl   $0xedbfe000,-0x1000054(%ebp)
  800336:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 60 20 80 00       	push   $0x802060
  800341:	e8 4d 04 00 00       	call   800793 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800349:	6a 04                	push   $0x4
  80034b:	6a 0d                	push   $0xd
  80034d:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  80035a:	50                   	push   %eax
  80035b:	e8 f4 17 00 00       	call   801b54 <sys_check_LRU_lists>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if(check == 0)
  800366:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80036a:	75 14                	jne    800380 <_main+0x348>
			panic("LRU lists entries are not correct, check your logic again!!");
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	68 88 20 80 00       	push   $0x802088
  800374:	6a 61                	push   $0x61
  800376:	68 42 1f 80 00       	push   $0x801f42
  80037b:	e8 56 01 00 00       	call   8004d6 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	68 c4 20 80 00       	push   $0x8020c4
  800388:	e8 06 04 00 00       	call   800793 <cprintf>
  80038d:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT SECOND SCENARIO completed successfully!!\n\n\n");
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	68 fc 20 80 00       	push   $0x8020fc
  800398:	e8 f6 03 00 00       	call   800793 <cprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	return;
  8003a0:	90                   	nop
}
  8003a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003a4:	5b                   	pop    %ebx
  8003a5:	5f                   	pop    %edi
  8003a6:	5d                   	pop    %ebp
  8003a7:	c3                   	ret    

008003a8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003ae:	e8 51 15 00 00       	call   801904 <sys_getenvindex>
  8003b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b9:	89 d0                	mov    %edx,%eax
  8003bb:	01 c0                	add    %eax,%eax
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 06             	shl    $0x6,%eax
  8003c2:	29 d0                	sub    %edx,%eax
  8003c4:	c1 e0 03             	shl    $0x3,%eax
  8003c7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003cc:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d6:	8a 40 68             	mov    0x68(%eax),%al
  8003d9:	84 c0                	test   %al,%al
  8003db:	74 0d                	je     8003ea <libmain+0x42>
		binaryname = myEnv->prog_name;
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	83 c0 68             	add    $0x68,%eax
  8003e5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x52>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 01 13 00 00       	call   801711 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 6c 21 80 00       	push   $0x80216c
  800418:	e8 76 03 00 00       	call   800793 <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 30 80 00       	mov    0x803020,%eax
  800425:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 94 21 80 00       	push   $0x802194
  800440:	e8 4e 03 00 00       	call   800793 <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 30 80 00       	mov    0x803020,%eax
  80044d:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80045e:	a1 20 30 80 00       	mov    0x803020,%eax
  800463:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 bc 21 80 00       	push   $0x8021bc
  800471:	e8 1d 03 00 00       	call   800793 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 30 80 00       	mov    0x803020,%eax
  80047e:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 14 22 80 00       	push   $0x802214
  80048d:	e8 01 03 00 00       	call   800793 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 6c 21 80 00       	push   $0x80216c
  80049d:	e8 f1 02 00 00       	call   800793 <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 81 12 00 00       	call   80172b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 0e 14 00 00       	call   8018d0 <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 63 14 00 00       	call   801936 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 18 31 80 00       	mov    0x803118,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 18 31 80 00       	mov    0x803118,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 28 22 80 00       	push   $0x802228
  8004fc:	e8 92 02 00 00       	call   800793 <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 30 80 00       	mov    0x803000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 2d 22 80 00       	push   $0x80222d
  800515:	e8 79 02 00 00       	call   800793 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 fc 01 00 00       	call   800728 <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 49 22 80 00       	push   $0x802249
  800539:	e8 ea 01 00 00       	call   800728 <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 30 80 00       	mov    0x803020,%eax
  800553:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055c:	39 c2                	cmp    %eax,%edx
  80055e:	74 14                	je     800574 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800560:	83 ec 04             	sub    $0x4,%esp
  800563:	68 4c 22 80 00       	push   $0x80224c
  800568:	6a 26                	push   $0x26
  80056a:	68 98 22 80 00       	push   $0x802298
  80056f:	e8 62 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800574:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80057b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800582:	e9 c5 00 00 00       	jmp    80064c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	85 c0                	test   %eax,%eax
  80059a:	75 08                	jne    8005a4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80059c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059f:	e9 a5 00 00 00       	jmp    800649 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b2:	eb 69                	jmp    80061d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b9:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8005bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c2:	89 d0                	mov    %edx,%eax
  8005c4:	01 c0                	add    %eax,%eax
  8005c6:	01 d0                	add    %edx,%eax
  8005c8:	c1 e0 03             	shl    $0x3,%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8a 40 04             	mov    0x4(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	75 46                	jne    80061a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d9:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8005df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	01 c0                	add    %eax,%eax
  8005e6:	01 d0                	add    %edx,%eax
  8005e8:	c1 e0 03             	shl    $0x3,%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005fa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	01 c8                	add    %ecx,%eax
  80060b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	75 09                	jne    80061a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800611:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800618:	eb 15                	jmp    80062f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061a:	ff 45 e8             	incl   -0x18(%ebp)
  80061d:	a1 20 30 80 00       	mov    0x803020,%eax
  800622:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80062b:	39 c2                	cmp    %eax,%edx
  80062d:	77 85                	ja     8005b4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80062f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800633:	75 14                	jne    800649 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800635:	83 ec 04             	sub    $0x4,%esp
  800638:	68 a4 22 80 00       	push   $0x8022a4
  80063d:	6a 3a                	push   $0x3a
  80063f:	68 98 22 80 00       	push   $0x802298
  800644:	e8 8d fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800649:	ff 45 f0             	incl   -0x10(%ebp)
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800652:	0f 8c 2f ff ff ff    	jl     800587 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800658:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800666:	eb 26                	jmp    80068e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800668:	a1 20 30 80 00       	mov    0x803020,%eax
  80066d:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800673:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800676:	89 d0                	mov    %edx,%eax
  800678:	01 c0                	add    %eax,%eax
  80067a:	01 d0                	add    %edx,%eax
  80067c:	c1 e0 03             	shl    $0x3,%eax
  80067f:	01 c8                	add    %ecx,%eax
  800681:	8a 40 04             	mov    0x4(%eax),%al
  800684:	3c 01                	cmp    $0x1,%al
  800686:	75 03                	jne    80068b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800688:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e0             	incl   -0x20(%ebp)
  80068e:	a1 20 30 80 00       	mov    0x803020,%eax
  800693:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800699:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069c:	39 c2                	cmp    %eax,%edx
  80069e:	77 c8                	ja     800668 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006a6:	74 14                	je     8006bc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006a8:	83 ec 04             	sub    $0x4,%esp
  8006ab:	68 f8 22 80 00       	push   $0x8022f8
  8006b0:	6a 44                	push   $0x44
  8006b2:	68 98 22 80 00       	push   $0x802298
  8006b7:	e8 1a fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8006cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d0:	89 0a                	mov    %ecx,(%edx)
  8006d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d5:	88 d1                	mov    %dl,%cl
  8006d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006da:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006e8:	75 2c                	jne    800716 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006ea:	a0 24 30 80 00       	mov    0x803024,%al
  8006ef:	0f b6 c0             	movzbl %al,%eax
  8006f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f5:	8b 12                	mov    (%edx),%edx
  8006f7:	89 d1                	mov    %edx,%ecx
  8006f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fc:	83 c2 08             	add    $0x8,%edx
  8006ff:	83 ec 04             	sub    $0x4,%esp
  800702:	50                   	push   %eax
  800703:	51                   	push   %ecx
  800704:	52                   	push   %edx
  800705:	e8 ae 0e 00 00       	call   8015b8 <sys_cputs>
  80070a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	8b 40 04             	mov    0x4(%eax),%eax
  80071c:	8d 50 01             	lea    0x1(%eax),%edx
  80071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800722:	89 50 04             	mov    %edx,0x4(%eax)
}
  800725:	90                   	nop
  800726:	c9                   	leave  
  800727:	c3                   	ret    

00800728 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800731:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800738:	00 00 00 
	b.cnt = 0;
  80073b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800742:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800745:	ff 75 0c             	pushl  0xc(%ebp)
  800748:	ff 75 08             	pushl  0x8(%ebp)
  80074b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800751:	50                   	push   %eax
  800752:	68 bf 06 80 00       	push   $0x8006bf
  800757:	e8 11 02 00 00       	call   80096d <vprintfmt>
  80075c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80075f:	a0 24 30 80 00       	mov    0x803024,%al
  800764:	0f b6 c0             	movzbl %al,%eax
  800767:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	50                   	push   %eax
  800771:	52                   	push   %edx
  800772:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800778:	83 c0 08             	add    $0x8,%eax
  80077b:	50                   	push   %eax
  80077c:	e8 37 0e 00 00       	call   8015b8 <sys_cputs>
  800781:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800784:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80078b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <cprintf>:

int cprintf(const char *fmt, ...) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800799:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8007af:	50                   	push   %eax
  8007b0:	e8 73 ff ff ff       	call   800728 <vcprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007c6:	e8 46 0f 00 00       	call   801711 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007da:	50                   	push   %eax
  8007db:	e8 48 ff ff ff       	call   800728 <vcprintf>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007e6:	e8 40 0f 00 00       	call   80172b <sys_enable_interrupt>
	return cnt;
  8007eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	53                   	push   %ebx
  8007f4:	83 ec 14             	sub    $0x14,%esp
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800803:	8b 45 18             	mov    0x18(%ebp),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080e:	77 55                	ja     800865 <printnum+0x75>
  800810:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800813:	72 05                	jb     80081a <printnum+0x2a>
  800815:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800818:	77 4b                	ja     800865 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80081a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80081d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800820:	8b 45 18             	mov    0x18(%ebp),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	ff 75 f4             	pushl  -0xc(%ebp)
  80082d:	ff 75 f0             	pushl  -0x10(%ebp)
  800830:	e8 27 14 00 00       	call   801c5c <__udivdi3>
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	83 ec 04             	sub    $0x4,%esp
  80083b:	ff 75 20             	pushl  0x20(%ebp)
  80083e:	53                   	push   %ebx
  80083f:	ff 75 18             	pushl  0x18(%ebp)
  800842:	52                   	push   %edx
  800843:	50                   	push   %eax
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	ff 75 08             	pushl  0x8(%ebp)
  80084a:	e8 a1 ff ff ff       	call   8007f0 <printnum>
  80084f:	83 c4 20             	add    $0x20,%esp
  800852:	eb 1a                	jmp    80086e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 20             	pushl  0x20(%ebp)
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800865:	ff 4d 1c             	decl   0x1c(%ebp)
  800868:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80086c:	7f e6                	jg     800854 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80086e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800871:	bb 00 00 00 00       	mov    $0x0,%ebx
  800876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087c:	53                   	push   %ebx
  80087d:	51                   	push   %ecx
  80087e:	52                   	push   %edx
  80087f:	50                   	push   %eax
  800880:	e8 e7 14 00 00       	call   801d6c <__umoddi3>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	05 74 25 80 00       	add    $0x802574,%eax
  80088d:	8a 00                	mov    (%eax),%al
  80088f:	0f be c0             	movsbl %al,%eax
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	50                   	push   %eax
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
}
  8008a1:	90                   	nop
  8008a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a5:	c9                   	leave  
  8008a6:	c3                   	ret    

008008a7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ae:	7e 1c                	jle    8008cc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	8d 50 08             	lea    0x8(%eax),%edx
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	89 10                	mov    %edx,(%eax)
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 e8 08             	sub    $0x8,%eax
  8008c5:	8b 50 04             	mov    0x4(%eax),%edx
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	eb 40                	jmp    80090c <getuint+0x65>
	else if (lflag)
  8008cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d0:	74 1e                	je     8008f0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 04             	lea    0x4(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ee:	eb 1c                	jmp    80090c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	8d 50 04             	lea    0x4(%eax),%edx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	89 10                	mov    %edx,(%eax)
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800911:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800915:	7e 1c                	jle    800933 <getint+0x25>
		return va_arg(*ap, long long);
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8d 50 08             	lea    0x8(%eax),%edx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	89 10                	mov    %edx,(%eax)
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	83 e8 08             	sub    $0x8,%eax
  80092c:	8b 50 04             	mov    0x4(%eax),%edx
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	eb 38                	jmp    80096b <getint+0x5d>
	else if (lflag)
  800933:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800937:	74 1a                	je     800953 <getint+0x45>
		return va_arg(*ap, long);
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	8d 50 04             	lea    0x4(%eax),%edx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 10                	mov    %edx,(%eax)
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	99                   	cltd   
  800951:	eb 18                	jmp    80096b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	8d 50 04             	lea    0x4(%eax),%edx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 10                	mov    %edx,(%eax)
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	83 e8 04             	sub    $0x4,%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	99                   	cltd   
}
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	56                   	push   %esi
  800971:	53                   	push   %ebx
  800972:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800975:	eb 17                	jmp    80098e <vprintfmt+0x21>
			if (ch == '\0')
  800977:	85 db                	test   %ebx,%ebx
  800979:	0f 84 af 03 00 00    	je     800d2e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	53                   	push   %ebx
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098e:	8b 45 10             	mov    0x10(%ebp),%eax
  800991:	8d 50 01             	lea    0x1(%eax),%edx
  800994:	89 55 10             	mov    %edx,0x10(%ebp)
  800997:	8a 00                	mov    (%eax),%al
  800999:	0f b6 d8             	movzbl %al,%ebx
  80099c:	83 fb 25             	cmp    $0x25,%ebx
  80099f:	75 d6                	jne    800977 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c4:	8d 50 01             	lea    0x1(%eax),%edx
  8009c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	0f b6 d8             	movzbl %al,%ebx
  8009cf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d2:	83 f8 55             	cmp    $0x55,%eax
  8009d5:	0f 87 2b 03 00 00    	ja     800d06 <vprintfmt+0x399>
  8009db:	8b 04 85 98 25 80 00 	mov    0x802598(,%eax,4),%eax
  8009e2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009e4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e8:	eb d7                	jmp    8009c1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ea:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ee:	eb d1                	jmp    8009c1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009fa:	89 d0                	mov    %edx,%eax
  8009fc:	c1 e0 02             	shl    $0x2,%eax
  8009ff:	01 d0                	add    %edx,%eax
  800a01:	01 c0                	add    %eax,%eax
  800a03:	01 d8                	add    %ebx,%eax
  800a05:	83 e8 30             	sub    $0x30,%eax
  800a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a13:	83 fb 2f             	cmp    $0x2f,%ebx
  800a16:	7e 3e                	jle    800a56 <vprintfmt+0xe9>
  800a18:	83 fb 39             	cmp    $0x39,%ebx
  800a1b:	7f 39                	jg     800a56 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a20:	eb d5                	jmp    8009f7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 c0 04             	add    $0x4,%eax
  800a28:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 e8 04             	sub    $0x4,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a36:	eb 1f                	jmp    800a57 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3c:	79 83                	jns    8009c1 <vprintfmt+0x54>
				width = 0;
  800a3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a45:	e9 77 ff ff ff       	jmp    8009c1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a4a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a51:	e9 6b ff ff ff       	jmp    8009c1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a56:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	0f 89 60 ff ff ff    	jns    8009c1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a67:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a6e:	e9 4e ff ff ff       	jmp    8009c1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a73:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a76:	e9 46 ff ff ff       	jmp    8009c1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 c0 04             	add    $0x4,%eax
  800a81:	89 45 14             	mov    %eax,0x14(%ebp)
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	83 e8 04             	sub    $0x4,%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	50                   	push   %eax
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
			break;
  800a9b:	e9 89 02 00 00       	jmp    800d29 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 c0 04             	add    $0x4,%eax
  800aa6:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 e8 04             	sub    $0x4,%eax
  800aaf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab1:	85 db                	test   %ebx,%ebx
  800ab3:	79 02                	jns    800ab7 <vprintfmt+0x14a>
				err = -err;
  800ab5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab7:	83 fb 64             	cmp    $0x64,%ebx
  800aba:	7f 0b                	jg     800ac7 <vprintfmt+0x15a>
  800abc:	8b 34 9d e0 23 80 00 	mov    0x8023e0(,%ebx,4),%esi
  800ac3:	85 f6                	test   %esi,%esi
  800ac5:	75 19                	jne    800ae0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac7:	53                   	push   %ebx
  800ac8:	68 85 25 80 00       	push   $0x802585
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	ff 75 08             	pushl  0x8(%ebp)
  800ad3:	e8 5e 02 00 00       	call   800d36 <printfmt>
  800ad8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800adb:	e9 49 02 00 00       	jmp    800d29 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae0:	56                   	push   %esi
  800ae1:	68 8e 25 80 00       	push   $0x80258e
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	ff 75 08             	pushl  0x8(%ebp)
  800aec:	e8 45 02 00 00       	call   800d36 <printfmt>
  800af1:	83 c4 10             	add    $0x10,%esp
			break;
  800af4:	e9 30 02 00 00       	jmp    800d29 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 c0 04             	add    $0x4,%eax
  800aff:	89 45 14             	mov    %eax,0x14(%ebp)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 e8 04             	sub    $0x4,%eax
  800b08:	8b 30                	mov    (%eax),%esi
  800b0a:	85 f6                	test   %esi,%esi
  800b0c:	75 05                	jne    800b13 <vprintfmt+0x1a6>
				p = "(null)";
  800b0e:	be 91 25 80 00       	mov    $0x802591,%esi
			if (width > 0 && padc != '-')
  800b13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b17:	7e 6d                	jle    800b86 <vprintfmt+0x219>
  800b19:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b1d:	74 67                	je     800b86 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	50                   	push   %eax
  800b26:	56                   	push   %esi
  800b27:	e8 0c 03 00 00       	call   800e38 <strnlen>
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b32:	eb 16                	jmp    800b4a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b34:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	50                   	push   %eax
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b47:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4e:	7f e4                	jg     800b34 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b50:	eb 34                	jmp    800b86 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b52:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b56:	74 1c                	je     800b74 <vprintfmt+0x207>
  800b58:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5b:	7e 05                	jle    800b62 <vprintfmt+0x1f5>
  800b5d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b60:	7e 12                	jle    800b74 <vprintfmt+0x207>
					putch('?', putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	6a 3f                	push   $0x3f
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	ff d0                	call   *%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
  800b72:	eb 0f                	jmp    800b83 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	53                   	push   %ebx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b83:	ff 4d e4             	decl   -0x1c(%ebp)
  800b86:	89 f0                	mov    %esi,%eax
  800b88:	8d 70 01             	lea    0x1(%eax),%esi
  800b8b:	8a 00                	mov    (%eax),%al
  800b8d:	0f be d8             	movsbl %al,%ebx
  800b90:	85 db                	test   %ebx,%ebx
  800b92:	74 24                	je     800bb8 <vprintfmt+0x24b>
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	78 b8                	js     800b52 <vprintfmt+0x1e5>
  800b9a:	ff 4d e0             	decl   -0x20(%ebp)
  800b9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba1:	79 af                	jns    800b52 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba3:	eb 13                	jmp    800bb8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 20                	push   $0x20
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb5:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbc:	7f e7                	jg     800ba5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bbe:	e9 66 01 00 00       	jmp    800d29 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcc:	50                   	push   %eax
  800bcd:	e8 3c fd ff ff       	call   80090e <getint>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be1:	85 d2                	test   %edx,%edx
  800be3:	79 23                	jns    800c08 <vprintfmt+0x29b>
				putch('-', putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	6a 2d                	push   $0x2d
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfb:	f7 d8                	neg    %eax
  800bfd:	83 d2 00             	adc    $0x0,%edx
  800c00:	f7 da                	neg    %edx
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 bc 00 00 00       	jmp    800cd0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1d:	50                   	push   %eax
  800c1e:	e8 84 fc ff ff       	call   8008a7 <getuint>
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c33:	e9 98 00 00 00       	jmp    800cd0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	6a 58                	push   $0x58
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	ff d0                	call   *%eax
  800c45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c48:	83 ec 08             	sub    $0x8,%esp
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	6a 58                	push   $0x58
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	ff d0                	call   *%eax
  800c55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	6a 58                	push   $0x58
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	ff d0                	call   *%eax
  800c65:	83 c4 10             	add    $0x10,%esp
			break;
  800c68:	e9 bc 00 00 00       	jmp    800d29 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	6a 30                	push   $0x30
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	ff d0                	call   *%eax
  800c7a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	6a 78                	push   $0x78
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	ff d0                	call   *%eax
  800c8a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 14             	mov    %eax,0x14(%ebp)
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	83 e8 04             	sub    $0x4,%eax
  800c9c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800caf:	eb 1f                	jmp    800cd0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800cba:	50                   	push   %eax
  800cbb:	e8 e7 fb ff ff       	call   8008a7 <getuint>
  800cc0:	83 c4 10             	add    $0x10,%esp
  800cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd7:	83 ec 04             	sub    $0x4,%esp
  800cda:	52                   	push   %edx
  800cdb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cde:	50                   	push   %eax
  800cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	ff 75 08             	pushl  0x8(%ebp)
  800ceb:	e8 00 fb ff ff       	call   8007f0 <printnum>
  800cf0:	83 c4 20             	add    $0x20,%esp
			break;
  800cf3:	eb 34                	jmp    800d29 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	53                   	push   %ebx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	ff d0                	call   *%eax
  800d01:	83 c4 10             	add    $0x10,%esp
			break;
  800d04:	eb 23                	jmp    800d29 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	6a 25                	push   $0x25
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d16:	ff 4d 10             	decl   0x10(%ebp)
  800d19:	eb 03                	jmp    800d1e <vprintfmt+0x3b1>
  800d1b:	ff 4d 10             	decl   0x10(%ebp)
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	48                   	dec    %eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 25                	cmp    $0x25,%al
  800d26:	75 f3                	jne    800d1b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d28:	90                   	nop
		}
	}
  800d29:	e9 47 fc ff ff       	jmp    800975 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d2e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d3f:	83 c0 04             	add    $0x4,%eax
  800d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d45:	8b 45 10             	mov    0x10(%ebp),%eax
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	ff 75 08             	pushl  0x8(%ebp)
  800d52:	e8 16 fc ff ff       	call   80096d <vprintfmt>
  800d57:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d5a:	90                   	nop
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	8b 40 08             	mov    0x8(%eax),%eax
  800d66:	8d 50 01             	lea    0x1(%eax),%edx
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8b 10                	mov    (%eax),%edx
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8b 40 04             	mov    0x4(%eax),%eax
  800d7a:	39 c2                	cmp    %eax,%edx
  800d7c:	73 12                	jae    800d90 <sprintputch+0x33>
		*b->buf++ = ch;
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 48 01             	lea    0x1(%eax),%ecx
  800d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d89:	89 0a                	mov    %ecx,(%edx)
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	88 10                	mov    %dl,(%eax)
}
  800d90:	90                   	nop
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	01 d0                	add    %edx,%eax
  800daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db8:	74 06                	je     800dc0 <vsnprintf+0x2d>
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	7f 07                	jg     800dc7 <vsnprintf+0x34>
		return -E_INVAL;
  800dc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc5:	eb 20                	jmp    800de7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dc7:	ff 75 14             	pushl  0x14(%ebp)
  800dca:	ff 75 10             	pushl  0x10(%ebp)
  800dcd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd0:	50                   	push   %eax
  800dd1:	68 5d 0d 80 00       	push   $0x800d5d
  800dd6:	e8 92 fb ff ff       	call   80096d <vprintfmt>
  800ddb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800def:	8d 45 10             	lea    0x10(%ebp),%eax
  800df2:	83 c0 04             	add    $0x4,%eax
  800df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfe:	50                   	push   %eax
  800dff:	ff 75 0c             	pushl  0xc(%ebp)
  800e02:	ff 75 08             	pushl  0x8(%ebp)
  800e05:	e8 89 ff ff ff       	call   800d93 <vsnprintf>
  800e0a:	83 c4 10             	add    $0x10,%esp
  800e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e22:	eb 06                	jmp    800e2a <strlen+0x15>
		n++;
  800e24:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e27:	ff 45 08             	incl   0x8(%ebp)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	84 c0                	test   %al,%al
  800e31:	75 f1                	jne    800e24 <strlen+0xf>
		n++;
	return n;
  800e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

00800e38 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e45:	eb 09                	jmp    800e50 <strnlen+0x18>
		n++;
  800e47:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	ff 4d 0c             	decl   0xc(%ebp)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 09                	je     800e5f <strnlen+0x27>
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e8                	jne    800e47 <strnlen+0xf>
		n++;
	return n;
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e70:	90                   	nop
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8d 50 01             	lea    0x1(%eax),%edx
  800e77:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e83:	8a 12                	mov    (%edx),%dl
  800e85:	88 10                	mov    %dl,(%eax)
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 e4                	jne    800e71 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea5:	eb 1f                	jmp    800ec6 <strncpy+0x34>
		*dst++ = *src;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8d 50 01             	lea    0x1(%eax),%edx
  800ead:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	74 03                	je     800ec3 <strncpy+0x31>
			src++;
  800ec0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ecc:	72 d9                	jb     800ea7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee3:	74 30                	je     800f15 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ee5:	eb 16                	jmp    800efd <strlcpy+0x2a>
			*dst++ = *src++;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8d 50 01             	lea    0x1(%eax),%edx
  800eed:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef9:	8a 12                	mov    (%edx),%dl
  800efb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800efd:	ff 4d 10             	decl   0x10(%ebp)
  800f00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f04:	74 09                	je     800f0f <strlcpy+0x3c>
  800f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	84 c0                	test   %al,%al
  800f0d:	75 d8                	jne    800ee7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f24:	eb 06                	jmp    800f2c <strcmp+0xb>
		p++, q++;
  800f26:	ff 45 08             	incl   0x8(%ebp)
  800f29:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	74 0e                	je     800f43 <strcmp+0x22>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 e3                	je     800f26 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
}
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f5c:	eb 09                	jmp    800f67 <strncmp+0xe>
		n--, p++, q++;
  800f5e:	ff 4d 10             	decl   0x10(%ebp)
  800f61:	ff 45 08             	incl   0x8(%ebp)
  800f64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6b:	74 17                	je     800f84 <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	84 c0                	test   %al,%al
  800f74:	74 0e                	je     800f84 <strncmp+0x2b>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 10                	mov    (%eax),%dl
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	38 c2                	cmp    %al,%dl
  800f82:	74 da                	je     800f5e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strncmp+0x38>
		return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8f:	eb 14                	jmp    800fa5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	0f b6 d0             	movzbl %al,%edx
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 c0             	movzbl %al,%eax
  800fa1:	29 c2                	sub    %eax,%edx
  800fa3:	89 d0                	mov    %edx,%eax
}
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 04             	sub    $0x4,%esp
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb3:	eb 12                	jmp    800fc7 <strchr+0x20>
		if (*s == c)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fbd:	75 05                	jne    800fc4 <strchr+0x1d>
			return (char *) s;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	eb 11                	jmp    800fd5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fc4:	ff 45 08             	incl   0x8(%ebp)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	75 e5                	jne    800fb5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe3:	eb 0d                	jmp    800ff2 <strfind+0x1b>
		if (*s == c)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fed:	74 0e                	je     800ffd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fef:	ff 45 08             	incl   0x8(%ebp)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	84 c0                	test   %al,%al
  800ff9:	75 ea                	jne    800fe5 <strfind+0xe>
  800ffb:	eb 01                	jmp    800ffe <strfind+0x27>
		if (*s == c)
			break;
  800ffd:	90                   	nop
	return (char *) s;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801001:	c9                   	leave  
  801002:	c3                   	ret    

00801003 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80100f:	8b 45 10             	mov    0x10(%ebp),%eax
  801012:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801015:	eb 0e                	jmp    801025 <memset+0x22>
		*p++ = c;
  801017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101a:	8d 50 01             	lea    0x1(%eax),%edx
  80101d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801025:	ff 4d f8             	decl   -0x8(%ebp)
  801028:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80102c:	79 e9                	jns    801017 <memset+0x14>
		*p++ = c;

	return v;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801045:	eb 16                	jmp    80105d <memcpy+0x2a>
		*d++ = *s++;
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	8d 50 01             	lea    0x1(%eax),%edx
  80104d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801050:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801053:	8d 4a 01             	lea    0x1(%edx),%ecx
  801056:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801059:	8a 12                	mov    (%edx),%dl
  80105b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	8d 50 ff             	lea    -0x1(%eax),%edx
  801063:	89 55 10             	mov    %edx,0x10(%ebp)
  801066:	85 c0                	test   %eax,%eax
  801068:	75 dd                	jne    801047 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801087:	73 50                	jae    8010d9 <memmove+0x6a>
  801089:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	01 d0                	add    %edx,%eax
  801091:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801094:	76 43                	jbe    8010d9 <memmove+0x6a>
		s += n;
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a2:	eb 10                	jmp    8010b4 <memmove+0x45>
			*--d = *--s;
  8010a4:	ff 4d f8             	decl   -0x8(%ebp)
  8010a7:	ff 4d fc             	decl   -0x4(%ebp)
  8010aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ad:	8a 10                	mov    (%eax),%dl
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	75 e3                	jne    8010a4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010c1:	eb 23                	jmp    8010e6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c6:	8d 50 01             	lea    0x1(%eax),%edx
  8010c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d5:	8a 12                	mov    (%edx),%dl
  8010d7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010df:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	75 dd                	jne    8010c3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010fd:	eb 2a                	jmp    801129 <memcmp+0x3e>
		if (*s1 != *s2)
  8010ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801102:	8a 10                	mov    (%eax),%dl
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	38 c2                	cmp    %al,%dl
  80110b:	74 16                	je     801123 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f b6 d0             	movzbl %al,%edx
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	0f b6 c0             	movzbl %al,%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
  801121:	eb 18                	jmp    80113b <memcmp+0x50>
		s1++, s2++;
  801123:	ff 45 fc             	incl   -0x4(%ebp)
  801126:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112f:	89 55 10             	mov    %edx,0x10(%ebp)
  801132:	85 c0                	test   %eax,%eax
  801134:	75 c9                	jne    8010ff <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	01 d0                	add    %edx,%eax
  80114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80114e:	eb 15                	jmp    801165 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f b6 d0             	movzbl %al,%edx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	0f b6 c0             	movzbl %al,%eax
  80115e:	39 c2                	cmp    %eax,%edx
  801160:	74 0d                	je     80116f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801162:	ff 45 08             	incl   0x8(%ebp)
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80116b:	72 e3                	jb     801150 <memfind+0x13>
  80116d:	eb 01                	jmp    801170 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80116f:	90                   	nop
	return (void *) s;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801182:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801189:	eb 03                	jmp    80118e <strtol+0x19>
		s++;
  80118b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 20                	cmp    $0x20,%al
  801195:	74 f4                	je     80118b <strtol+0x16>
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 09                	cmp    $0x9,%al
  80119e:	74 eb                	je     80118b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 2b                	cmp    $0x2b,%al
  8011a7:	75 05                	jne    8011ae <strtol+0x39>
		s++;
  8011a9:	ff 45 08             	incl   0x8(%ebp)
  8011ac:	eb 13                	jmp    8011c1 <strtol+0x4c>
	else if (*s == '-')
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	3c 2d                	cmp    $0x2d,%al
  8011b5:	75 0a                	jne    8011c1 <strtol+0x4c>
		s++, neg = 1;
  8011b7:	ff 45 08             	incl   0x8(%ebp)
  8011ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c5:	74 06                	je     8011cd <strtol+0x58>
  8011c7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011cb:	75 20                	jne    8011ed <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	3c 30                	cmp    $0x30,%al
  8011d4:	75 17                	jne    8011ed <strtol+0x78>
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	40                   	inc    %eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 78                	cmp    $0x78,%al
  8011de:	75 0d                	jne    8011ed <strtol+0x78>
		s += 2, base = 16;
  8011e0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011e4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011eb:	eb 28                	jmp    801215 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f1:	75 15                	jne    801208 <strtol+0x93>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 30                	cmp    $0x30,%al
  8011fa:	75 0c                	jne    801208 <strtol+0x93>
		s++, base = 8;
  8011fc:	ff 45 08             	incl   0x8(%ebp)
  8011ff:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801206:	eb 0d                	jmp    801215 <strtol+0xa0>
	else if (base == 0)
  801208:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120c:	75 07                	jne    801215 <strtol+0xa0>
		base = 10;
  80120e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 2f                	cmp    $0x2f,%al
  80121c:	7e 19                	jle    801237 <strtol+0xc2>
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	3c 39                	cmp    $0x39,%al
  801225:	7f 10                	jg     801237 <strtol+0xc2>
			dig = *s - '0';
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	0f be c0             	movsbl %al,%eax
  80122f:	83 e8 30             	sub    $0x30,%eax
  801232:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801235:	eb 42                	jmp    801279 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 60                	cmp    $0x60,%al
  80123e:	7e 19                	jle    801259 <strtol+0xe4>
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	3c 7a                	cmp    $0x7a,%al
  801247:	7f 10                	jg     801259 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	0f be c0             	movsbl %al,%eax
  801251:	83 e8 57             	sub    $0x57,%eax
  801254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801257:	eb 20                	jmp    801279 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 40                	cmp    $0x40,%al
  801260:	7e 39                	jle    80129b <strtol+0x126>
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 5a                	cmp    $0x5a,%al
  801269:	7f 30                	jg     80129b <strtol+0x126>
			dig = *s - 'A' + 10;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	0f be c0             	movsbl %al,%eax
  801273:	83 e8 37             	sub    $0x37,%eax
  801276:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80127f:	7d 19                	jge    80129a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801281:	ff 45 08             	incl   0x8(%ebp)
  801284:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801287:	0f af 45 10          	imul   0x10(%ebp),%eax
  80128b:	89 c2                	mov    %eax,%edx
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	01 d0                	add    %edx,%eax
  801292:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801295:	e9 7b ff ff ff       	jmp    801215 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80129a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80129b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80129f:	74 08                	je     8012a9 <strtol+0x134>
		*endptr = (char *) s;
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ad:	74 07                	je     8012b6 <strtol+0x141>
  8012af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b2:	f7 d8                	neg    %eax
  8012b4:	eb 03                	jmp    8012b9 <strtol+0x144>
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <ltostr>:

void
ltostr(long value, char *str)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d3:	79 13                	jns    8012e8 <ltostr+0x2d>
	{
		neg = 1;
  8012d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012e2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012e5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012f0:	99                   	cltd   
  8012f1:	f7 f9                	idiv   %ecx
  8012f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f9:	8d 50 01             	lea    0x1(%eax),%edx
  8012fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ff:	89 c2                	mov    %eax,%edx
  801301:	8b 45 0c             	mov    0xc(%ebp),%eax
  801304:	01 d0                	add    %edx,%eax
  801306:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801309:	83 c2 30             	add    $0x30,%edx
  80130c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80130e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801311:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801316:	f7 e9                	imul   %ecx
  801318:	c1 fa 02             	sar    $0x2,%edx
  80131b:	89 c8                	mov    %ecx,%eax
  80131d:	c1 f8 1f             	sar    $0x1f,%eax
  801320:	29 c2                	sub    %eax,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801327:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80132f:	f7 e9                	imul   %ecx
  801331:	c1 fa 02             	sar    $0x2,%edx
  801334:	89 c8                	mov    %ecx,%eax
  801336:	c1 f8 1f             	sar    $0x1f,%eax
  801339:	29 c2                	sub    %eax,%edx
  80133b:	89 d0                	mov    %edx,%eax
  80133d:	c1 e0 02             	shl    $0x2,%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	01 c0                	add    %eax,%eax
  801344:	29 c1                	sub    %eax,%ecx
  801346:	89 ca                	mov    %ecx,%edx
  801348:	85 d2                	test   %edx,%edx
  80134a:	75 9c                	jne    8012e8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80134c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801353:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801356:	48                   	dec    %eax
  801357:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80135a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135e:	74 3d                	je     80139d <ltostr+0xe2>
		start = 1 ;
  801360:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801367:	eb 34                	jmp    80139d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	01 c2                	add    %eax,%edx
  80137e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	01 c8                	add    %ecx,%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80138a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	01 c2                	add    %eax,%edx
  801392:	8a 45 eb             	mov    -0x15(%ebp),%al
  801395:	88 02                	mov    %al,(%edx)
		start++ ;
  801397:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80139a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013a3:	7c c4                	jl     801369 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013b0:	90                   	nop
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 54 fa ff ff       	call   800e15 <strlen>
  8013c1:	83 c4 04             	add    $0x4,%esp
  8013c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013c7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ca:	e8 46 fa ff ff       	call   800e15 <strlen>
  8013cf:	83 c4 04             	add    $0x4,%esp
  8013d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e3:	eb 17                	jmp    8013fc <strcconcat+0x49>
		final[s] = str1[s] ;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 c2                	add    %eax,%edx
  8013ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	01 c8                	add    %ecx,%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f9:	ff 45 fc             	incl   -0x4(%ebp)
  8013fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801402:	7c e1                	jl     8013e5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801404:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80140b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801412:	eb 1f                	jmp    801433 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801414:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801417:	8d 50 01             	lea    0x1(%eax),%edx
  80141a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80141d:	89 c2                	mov    %eax,%edx
  80141f:	8b 45 10             	mov    0x10(%ebp),%eax
  801422:	01 c2                	add    %eax,%edx
  801424:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 c8                	add    %ecx,%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801430:	ff 45 f8             	incl   -0x8(%ebp)
  801433:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801436:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801439:	7c d9                	jl     801414 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80143b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143e:	8b 45 10             	mov    0x10(%ebp),%eax
  801441:	01 d0                	add    %edx,%eax
  801443:	c6 00 00             	movb   $0x0,(%eax)
}
  801446:	90                   	nop
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801455:	8b 45 14             	mov    0x14(%ebp),%eax
  801458:	8b 00                	mov    (%eax),%eax
  80145a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80146c:	eb 0c                	jmp    80147a <strsplit+0x31>
			*string++ = 0;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8d 50 01             	lea    0x1(%eax),%edx
  801474:	89 55 08             	mov    %edx,0x8(%ebp)
  801477:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	84 c0                	test   %al,%al
  801481:	74 18                	je     80149b <strsplit+0x52>
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	0f be c0             	movsbl %al,%eax
  80148b:	50                   	push   %eax
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	e8 13 fb ff ff       	call   800fa7 <strchr>
  801494:	83 c4 08             	add    $0x8,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	75 d3                	jne    80146e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	84 c0                	test   %al,%al
  8014a2:	74 5a                	je     8014fe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a7:	8b 00                	mov    (%eax),%eax
  8014a9:	83 f8 0f             	cmp    $0xf,%eax
  8014ac:	75 07                	jne    8014b5 <strsplit+0x6c>
		{
			return 0;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b3:	eb 66                	jmp    80151b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8014bd:	8b 55 14             	mov    0x14(%ebp),%edx
  8014c0:	89 0a                	mov    %ecx,(%edx)
  8014c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 c2                	add    %eax,%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014d3:	eb 03                	jmp    8014d8 <strsplit+0x8f>
			string++;
  8014d5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	84 c0                	test   %al,%al
  8014df:	74 8b                	je     80146c <strsplit+0x23>
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f be c0             	movsbl %al,%eax
  8014e9:	50                   	push   %eax
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	e8 b5 fa ff ff       	call   800fa7 <strchr>
  8014f2:	83 c4 08             	add    $0x8,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	74 dc                	je     8014d5 <strsplit+0x8c>
			string++;
	}
  8014f9:	e9 6e ff ff ff       	jmp    80146c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014fe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150b:	8b 45 10             	mov    0x10(%ebp),%eax
  80150e:	01 d0                	add    %edx,%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801516:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801523:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80152a:	eb 4c                	jmp    801578 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  80152c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801532:	01 d0                	add    %edx,%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	3c 40                	cmp    $0x40,%al
  801538:	7e 27                	jle    801561 <str2lower+0x44>
  80153a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801540:	01 d0                	add    %edx,%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 19                	jg     801561 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801548:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	01 d0                	add    %edx,%eax
  801550:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	01 ca                	add    %ecx,%edx
  801558:	8a 12                	mov    (%edx),%dl
  80155a:	83 c2 20             	add    $0x20,%edx
  80155d:	88 10                	mov    %dl,(%eax)
  80155f:	eb 14                	jmp    801575 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801561:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	01 c2                	add    %eax,%edx
  801569:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	01 c8                	add    %ecx,%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801575:	ff 45 fc             	incl   -0x4(%ebp)
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	e8 95 f8 ff ff       	call   800e15 <strlen>
  801580:	83 c4 04             	add    $0x4,%esp
  801583:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801586:	7f a4                	jg     80152c <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	57                   	push   %edi
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015a8:	cd 30                	int    $0x30
  8015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5f                   	pop    %edi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	52                   	push   %edx
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	50                   	push   %eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	e8 b2 ff ff ff       	call   80158d <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	90                   	nop
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 01                	push   $0x1
  8015f0:	e8 98 ff ff ff       	call   80158d <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	52                   	push   %edx
  80160a:	50                   	push   %eax
  80160b:	6a 05                	push   $0x5
  80160d:	e8 7b ff ff ff       	call   80158d <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80161c:	8b 75 18             	mov    0x18(%ebp),%esi
  80161f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801622:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
  80162d:	51                   	push   %ecx
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 06                	push   $0x6
  801632:	e8 56 ff ff ff       	call   80158d <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801644:	8b 55 0c             	mov    0xc(%ebp),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	52                   	push   %edx
  801651:	50                   	push   %eax
  801652:	6a 07                	push   $0x7
  801654:	e8 34 ff ff ff       	call   80158d <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	6a 08                	push   $0x8
  80166f:	e8 19 ff ff ff       	call   80158d <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 09                	push   $0x9
  801688:	e8 00 ff ff ff       	call   80158d <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 0a                	push   $0xa
  8016a1:	e8 e7 fe ff ff       	call   80158d <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 0b                	push   $0xb
  8016ba:	e8 ce fe ff ff       	call   80158d <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 0c                	push   $0xc
  8016d3:	e8 b5 fe ff ff       	call   80158d <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	6a 0d                	push   $0xd
  8016ed:	e8 9b fe ff ff       	call   80158d <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0e                	push   $0xe
  801706:	e8 82 fe ff ff       	call   80158d <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 11                	push   $0x11
  801720:	e8 68 fe ff ff       	call   80158d <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 12                	push   $0x12
  80173a:	e8 4e fe ff ff       	call   80158d <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_cputc>:


void
sys_cputc(const char c)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801751:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	50                   	push   %eax
  80175e:	6a 13                	push   $0x13
  801760:	e8 28 fe ff ff       	call   80158d <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	90                   	nop
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 14                	push   $0x14
  80177a:	e8 0e fe ff ff       	call   80158d <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	90                   	nop
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	50                   	push   %eax
  801795:	6a 15                	push   $0x15
  801797:	e8 f1 fd ff ff       	call   80158d <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 18                	push   $0x18
  8017b4:	e8 d4 fd ff ff       	call   80158d <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	52                   	push   %edx
  8017ce:	50                   	push   %eax
  8017cf:	6a 16                	push   $0x16
  8017d1:	e8 b7 fd ff ff       	call   80158d <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 17                	push   $0x17
  8017ef:	e8 99 fd ff ff       	call   80158d <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	8b 45 10             	mov    0x10(%ebp),%eax
  801803:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801806:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801809:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	51                   	push   %ecx
  801813:	52                   	push   %edx
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	50                   	push   %eax
  801818:	6a 19                	push   $0x19
  80181a:	e8 6e fd ff ff       	call   80158d <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	52                   	push   %edx
  801834:	50                   	push   %eax
  801835:	6a 1a                	push   $0x1a
  801837:	e8 51 fd ff ff       	call   80158d <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801844:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	51                   	push   %ecx
  801852:	52                   	push   %edx
  801853:	50                   	push   %eax
  801854:	6a 1b                	push   $0x1b
  801856:	e8 32 fd ff ff       	call   80158d <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 1c                	push   $0x1c
  801873:	e8 15 fd ff ff       	call   80158d <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 1d                	push   $0x1d
  80188c:	e8 fc fc ff ff       	call   80158d <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 14             	pushl  0x14(%ebp)
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	6a 1e                	push   $0x1e
  8018aa:	e8 de fc ff ff       	call   80158d <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	50                   	push   %eax
  8018c3:	6a 1f                	push   $0x1f
  8018c5:	e8 c3 fc ff ff       	call   80158d <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	50                   	push   %eax
  8018df:	6a 20                	push   $0x20
  8018e1:	e8 a7 fc ff ff       	call   80158d <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 02                	push   $0x2
  8018fa:	e8 8e fc ff ff       	call   80158d <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 03                	push   $0x3
  801913:	e8 75 fc ff ff       	call   80158d <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 04                	push   $0x4
  80192c:	e8 5c fc ff ff       	call   80158d <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_exit_env>:


void sys_exit_env(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 21                	push   $0x21
  801945:	e8 43 fc ff ff       	call   80158d <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	90                   	nop
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801956:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801959:	8d 50 04             	lea    0x4(%eax),%edx
  80195c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 22                	push   $0x22
  801969:	e8 1f fc ff ff       	call   80158d <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return result;
  801971:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801974:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801977:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197a:	89 01                	mov    %eax,(%ecx)
  80197c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	c9                   	leave  
  801983:	c2 04 00             	ret    $0x4

00801986 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 10             	pushl  0x10(%ebp)
  801990:	ff 75 0c             	pushl  0xc(%ebp)
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 10                	push   $0x10
  801998:	e8 f0 fb ff ff       	call   80158d <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 23                	push   $0x23
  8019b2:	e8 d6 fb ff ff       	call   80158d <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	50                   	push   %eax
  8019d5:	6a 24                	push   $0x24
  8019d7:	e8 b1 fb ff ff       	call   80158d <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <rsttst>:
void rsttst()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 26                	push   $0x26
  8019f1:	e8 97 fb ff ff       	call   80158d <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f9:	90                   	nop
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	8b 45 14             	mov    0x14(%ebp),%eax
  801a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a08:	8b 55 18             	mov    0x18(%ebp),%edx
  801a0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0f:	52                   	push   %edx
  801a10:	50                   	push   %eax
  801a11:	ff 75 10             	pushl  0x10(%ebp)
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 25                	push   $0x25
  801a1c:	e8 6c fb ff ff       	call   80158d <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
	return ;
  801a24:	90                   	nop
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <chktst>:
void chktst(uint32 n)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 27                	push   $0x27
  801a37:	e8 51 fb ff ff       	call   80158d <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <inctst>:

void inctst()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 28                	push   $0x28
  801a51:	e8 37 fb ff ff       	call   80158d <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
	return ;
  801a59:	90                   	nop
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <gettst>:
uint32 gettst()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 29                	push   $0x29
  801a6b:	e8 1d fb ff ff       	call   80158d <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 2a                	push   $0x2a
  801a87:	e8 01 fb ff ff       	call   80158d <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
  801a8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a92:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a96:	75 07                	jne    801a9f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a98:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9d:	eb 05                	jmp    801aa4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 2a                	push   $0x2a
  801ab8:	e8 d0 fa ff ff       	call   80158d <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
  801ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ac3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ac7:	75 07                	jne    801ad0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ace:	eb 05                	jmp    801ad5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 2a                	push   $0x2a
  801ae9:	e8 9f fa ff ff       	call   80158d <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
  801af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801af4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801af8:	75 07                	jne    801b01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801afa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aff:	eb 05                	jmp    801b06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 2a                	push   $0x2a
  801b1a:	e8 6e fa ff ff       	call   80158d <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
  801b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b25:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b29:	75 07                	jne    801b32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b30:	eb 05                	jmp    801b37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	ff 75 08             	pushl  0x8(%ebp)
  801b47:	6a 2b                	push   $0x2b
  801b49:	e8 3f fa ff ff       	call   80158d <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b51:	90                   	nop
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	53                   	push   %ebx
  801b67:	51                   	push   %ecx
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 2c                	push   $0x2c
  801b6c:	e8 1c fa ff ff       	call   80158d <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	6a 2d                	push   $0x2d
  801b8c:	e8 fc f9 ff ff       	call   80158d <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b99:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	51                   	push   %ecx
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 2e                	push   $0x2e
  801bac:	e8 dc f9 ff ff       	call   80158d <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 10             	pushl  0x10(%ebp)
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	6a 0f                	push   $0xf
  801bc8:	e8 c0 f9 ff ff       	call   80158d <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	50                   	push   %eax
  801be2:	6a 2f                	push   $0x2f
  801be4:	e8 a4 f9 ff ff       	call   80158d <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp

}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	6a 30                	push   $0x30
  801bff:	e8 89 f9 ff ff       	call   80158d <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
	return;
  801c07:	90                   	nop
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	6a 31                	push   $0x31
  801c1b:	e8 6d f9 ff ff       	call   80158d <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
	return;
  801c23:	90                   	nop
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 32                	push   $0x32
  801c35:	e8 53 f9 ff ff       	call   80158d <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	50                   	push   %eax
  801c4e:	6a 33                	push   $0x33
  801c50:	e8 38 f9 ff ff       	call   80158d <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    
  801c5b:	90                   	nop

00801c5c <__udivdi3>:
  801c5c:	55                   	push   %ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 1c             	sub    $0x1c,%esp
  801c63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c73:	89 ca                	mov    %ecx,%edx
  801c75:	89 f8                	mov    %edi,%eax
  801c77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c7b:	85 f6                	test   %esi,%esi
  801c7d:	75 2d                	jne    801cac <__udivdi3+0x50>
  801c7f:	39 cf                	cmp    %ecx,%edi
  801c81:	77 65                	ja     801ce8 <__udivdi3+0x8c>
  801c83:	89 fd                	mov    %edi,%ebp
  801c85:	85 ff                	test   %edi,%edi
  801c87:	75 0b                	jne    801c94 <__udivdi3+0x38>
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	f7 f7                	div    %edi
  801c92:	89 c5                	mov    %eax,%ebp
  801c94:	31 d2                	xor    %edx,%edx
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	f7 f5                	div    %ebp
  801c9a:	89 c1                	mov    %eax,%ecx
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	f7 f5                	div    %ebp
  801ca0:	89 cf                	mov    %ecx,%edi
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	39 ce                	cmp    %ecx,%esi
  801cae:	77 28                	ja     801cd8 <__udivdi3+0x7c>
  801cb0:	0f bd fe             	bsr    %esi,%edi
  801cb3:	83 f7 1f             	xor    $0x1f,%edi
  801cb6:	75 40                	jne    801cf8 <__udivdi3+0x9c>
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	72 0a                	jb     801cc6 <__udivdi3+0x6a>
  801cbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cc0:	0f 87 9e 00 00 00    	ja     801d64 <__udivdi3+0x108>
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	31 ff                	xor    %edi,%edi
  801cda:	31 c0                	xor    %eax,%eax
  801cdc:	89 fa                	mov    %edi,%edx
  801cde:	83 c4 1c             	add    $0x1c,%esp
  801ce1:	5b                   	pop    %ebx
  801ce2:	5e                   	pop    %esi
  801ce3:	5f                   	pop    %edi
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	89 d8                	mov    %ebx,%eax
  801cea:	f7 f7                	div    %edi
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	89 fa                	mov    %edi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cfd:	89 eb                	mov    %ebp,%ebx
  801cff:	29 fb                	sub    %edi,%ebx
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	d3 e6                	shl    %cl,%esi
  801d05:	89 c5                	mov    %eax,%ebp
  801d07:	88 d9                	mov    %bl,%cl
  801d09:	d3 ed                	shr    %cl,%ebp
  801d0b:	89 e9                	mov    %ebp,%ecx
  801d0d:	09 f1                	or     %esi,%ecx
  801d0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	d3 e0                	shl    %cl,%eax
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 ee                	shr    %cl,%esi
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e2                	shl    %cl,%edx
  801d23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 e8                	shr    %cl,%eax
  801d2b:	09 c2                	or     %eax,%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	89 f2                	mov    %esi,%edx
  801d31:	f7 74 24 0c          	divl   0xc(%esp)
  801d35:	89 d6                	mov    %edx,%esi
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	f7 e5                	mul    %ebp
  801d3b:	39 d6                	cmp    %edx,%esi
  801d3d:	72 19                	jb     801d58 <__udivdi3+0xfc>
  801d3f:	74 0b                	je     801d4c <__udivdi3+0xf0>
  801d41:	89 d8                	mov    %ebx,%eax
  801d43:	31 ff                	xor    %edi,%edi
  801d45:	e9 58 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d50:	89 f9                	mov    %edi,%ecx
  801d52:	d3 e2                	shl    %cl,%edx
  801d54:	39 c2                	cmp    %eax,%edx
  801d56:	73 e9                	jae    801d41 <__udivdi3+0xe5>
  801d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d5b:	31 ff                	xor    %edi,%edi
  801d5d:	e9 40 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d62:	66 90                	xchg   %ax,%ax
  801d64:	31 c0                	xor    %eax,%eax
  801d66:	e9 37 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d6b:	90                   	nop

00801d6c <__umoddi3>:
  801d6c:	55                   	push   %ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 1c             	sub    $0x1c,%esp
  801d73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d8b:	89 f3                	mov    %esi,%ebx
  801d8d:	89 fa                	mov    %edi,%edx
  801d8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d93:	89 34 24             	mov    %esi,(%esp)
  801d96:	85 c0                	test   %eax,%eax
  801d98:	75 1a                	jne    801db4 <__umoddi3+0x48>
  801d9a:	39 f7                	cmp    %esi,%edi
  801d9c:	0f 86 a2 00 00 00    	jbe    801e44 <__umoddi3+0xd8>
  801da2:	89 c8                	mov    %ecx,%eax
  801da4:	89 f2                	mov    %esi,%edx
  801da6:	f7 f7                	div    %edi
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	31 d2                	xor    %edx,%edx
  801dac:	83 c4 1c             	add    $0x1c,%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
  801db4:	39 f0                	cmp    %esi,%eax
  801db6:	0f 87 ac 00 00 00    	ja     801e68 <__umoddi3+0xfc>
  801dbc:	0f bd e8             	bsr    %eax,%ebp
  801dbf:	83 f5 1f             	xor    $0x1f,%ebp
  801dc2:	0f 84 ac 00 00 00    	je     801e74 <__umoddi3+0x108>
  801dc8:	bf 20 00 00 00       	mov    $0x20,%edi
  801dcd:	29 ef                	sub    %ebp,%edi
  801dcf:	89 fe                	mov    %edi,%esi
  801dd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dd5:	89 e9                	mov    %ebp,%ecx
  801dd7:	d3 e0                	shl    %cl,%eax
  801dd9:	89 d7                	mov    %edx,%edi
  801ddb:	89 f1                	mov    %esi,%ecx
  801ddd:	d3 ef                	shr    %cl,%edi
  801ddf:	09 c7                	or     %eax,%edi
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e2                	shl    %cl,%edx
  801de5:	89 14 24             	mov    %edx,(%esp)
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df2:	d3 e0                	shl    %cl,%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfc:	89 f1                	mov    %esi,%ecx
  801dfe:	d3 e8                	shr    %cl,%eax
  801e00:	09 d0                	or     %edx,%eax
  801e02:	d3 eb                	shr    %cl,%ebx
  801e04:	89 da                	mov    %ebx,%edx
  801e06:	f7 f7                	div    %edi
  801e08:	89 d3                	mov    %edx,%ebx
  801e0a:	f7 24 24             	mull   (%esp)
  801e0d:	89 c6                	mov    %eax,%esi
  801e0f:	89 d1                	mov    %edx,%ecx
  801e11:	39 d3                	cmp    %edx,%ebx
  801e13:	0f 82 87 00 00 00    	jb     801ea0 <__umoddi3+0x134>
  801e19:	0f 84 91 00 00 00    	je     801eb0 <__umoddi3+0x144>
  801e1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e23:	29 f2                	sub    %esi,%edx
  801e25:	19 cb                	sbb    %ecx,%ebx
  801e27:	89 d8                	mov    %ebx,%eax
  801e29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e2d:	d3 e0                	shl    %cl,%eax
  801e2f:	89 e9                	mov    %ebp,%ecx
  801e31:	d3 ea                	shr    %cl,%edx
  801e33:	09 d0                	or     %edx,%eax
  801e35:	89 e9                	mov    %ebp,%ecx
  801e37:	d3 eb                	shr    %cl,%ebx
  801e39:	89 da                	mov    %ebx,%edx
  801e3b:	83 c4 1c             	add    $0x1c,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5f                   	pop    %edi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
  801e43:	90                   	nop
  801e44:	89 fd                	mov    %edi,%ebp
  801e46:	85 ff                	test   %edi,%edi
  801e48:	75 0b                	jne    801e55 <__umoddi3+0xe9>
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f7                	div    %edi
  801e53:	89 c5                	mov    %eax,%ebp
  801e55:	89 f0                	mov    %esi,%eax
  801e57:	31 d2                	xor    %edx,%edx
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 c8                	mov    %ecx,%eax
  801e5d:	f7 f5                	div    %ebp
  801e5f:	89 d0                	mov    %edx,%eax
  801e61:	e9 44 ff ff ff       	jmp    801daa <__umoddi3+0x3e>
  801e66:	66 90                	xchg   %ax,%ax
  801e68:	89 c8                	mov    %ecx,%eax
  801e6a:	89 f2                	mov    %esi,%edx
  801e6c:	83 c4 1c             	add    $0x1c,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	3b 04 24             	cmp    (%esp),%eax
  801e77:	72 06                	jb     801e7f <__umoddi3+0x113>
  801e79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e7d:	77 0f                	ja     801e8e <__umoddi3+0x122>
  801e7f:	89 f2                	mov    %esi,%edx
  801e81:	29 f9                	sub    %edi,%ecx
  801e83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e87:	89 14 24             	mov    %edx,(%esp)
  801e8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e92:	8b 14 24             	mov    (%esp),%edx
  801e95:	83 c4 1c             	add    $0x1c,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	2b 04 24             	sub    (%esp),%eax
  801ea3:	19 fa                	sbb    %edi,%edx
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 c6                	mov    %eax,%esi
  801ea9:	e9 71 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
  801eae:	66 90                	xchg   %ax,%ax
  801eb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eb4:	72 ea                	jb     801ea0 <__umoddi3+0x134>
  801eb6:	89 d9                	mov    %ebx,%ecx
  801eb8:	e9 62 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
