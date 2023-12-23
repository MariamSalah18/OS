/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"
#include <inc/queue.h>
#include <kern/tests/utilities.h>

//extern void inctst();

/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va on the given page_directory
//	If the page table at any destination page in the range is not exist, it should create it
//	If ANY of the destination pages exists, deny the entire process and return -1. Otherwise, cut-paste the number of pages and return 0
//	ALL 12 permission bits of the destination should be TYPICAL to those of the source
//	The given addresses may be not aligned on 4 KB
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va,
		uint32 num_of_pages) {
	panic("cut_paste_pages() is not implemented yet...!!");

	return 0;
}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va on the given page_directory
//	Ranges DO NOT overlapped.
//	If ANY of the destination pages exists with READ ONLY permission, deny the entire process and return -1.
//	If the page table at any destination page in the range is not exist, it should create it
//	If ANY of the destination pages doesn't exist, create it with the following permissions then copy.
//	Otherwise, just copy!
//		1. WRITABLE permission
//		2. USER/SUPERVISOR permission must be SAME as the one of the source
//	The given range(s) may be not aligned on 4 KB
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va,
		uint32 size) {
	panic("copy_paste_chunk() is not implemented yet...!!");
	return 0;
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va on the given page_directory
//	Ranges DO NOT overlapped.
//	It should set the permissions of the second range by the given perms
//	If ANY of the destination pages exists, deny the entire process and return -1. Otherwise, share the required range and return 0
//	If the page table at any destination page in the range is not exist, it should create it
//	The given range(s) may be not aligned on 4 KB
int share_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va,
		uint32 size, uint32 perms) {
	panic("share_chunk() is not implemented yet...!!");
	return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate the given virtual range [<va>, <va> + <size>) in the given address space  <page_directory> with the given permissions <perms>.
//	If ANY of the destination pages exists, deny the entire process and return -1. Otherwise, allocate the required range and return 0
//	If the page table at any destination page in the range is not exist, it should create it
//	Allocation should be aligned on page boundary. However, the given range may be not aligned.
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms) {
	panic("allocate_chunk() is not implemented yet...!!");
	return 0;
}

//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva,
		uint32 *num_tables, uint32 *num_pages) {
	panic("calculate_allocated_space() is not implemented yet...!!");
}

//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
//This function should calculate the required number of pages for allocating and mapping the given range [start va, start va + size) (either for the pages themselves or for the page tables required for mapping)
//	Pages and/or page tables that are already exist in the range SHOULD NOT be counted.
//	The given range(s) may be not aligned on 4 KB
uint32 calculate_required_frames(uint32* page_directory, uint32 sva,
		uint32 size) {
	panic("calculate_required_frames() is not implemented yet...!!");
	return 0;
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================
//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	uint32* envptr_page_table = NULL;
	uint32 roundedUp_size = ROUNDUP(size, PAGE_SIZE);
	uint32 number_of_pages = roundedUp_size / PAGE_SIZE;
	uint32 *page_table_pointer;
	for (uint32 i = 0; i < number_of_pages; i++)
	{
		uint32 oring = 0x00000E00;
		uint32 *page_table_pointer;
		int ret = get_page_table(e->env_page_directory, virtual_address,&page_table_pointer);
		if (ret == TABLE_NOT_EXIST)
		{
			page_table_pointer = create_page_table(e->env_page_directory, virtual_address);
		}
		page_table_pointer[PTX(virtual_address)] = page_table_pointer[PTX(virtual_address)] | oring;
		virtual_address += PAGE_SIZE;

	}

}

void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{

	//TODO: [PROJECT'23.MS2 - #16] [2] USER HEAP - free_user_mem()
	if (isPageReplacmentAlgorithmFIFO())
	{
		 struct WorkingSetElement* temp;
		 struct WorkingSetElement* iter;
		 struct WorkingSetElement* move;
		 temp=e->page_last_WS_element;
		 uint32 size=LIST_SIZE(&(e->page_WS_list));
		 int iternum=1;
		 LIST_FOREACH(iter,&(e->page_WS_list))
		 {
			 if(temp==iter||iternum==size)
			 {
				 break;
			 }
			 move=iter;
			 LIST_REMOVE(&(e->page_WS_list),move);
			 LIST_INSERT_TAIL(&(e->page_WS_list),move);
			 iternum++;
		 }
		 e->page_last_WS_element=LIST_FIRST(&(e->page_WS_list));
	}

	uint32 numOfPages = size/ PAGE_SIZE;
	uint32 start_va =ROUNDDOWN(virtual_address,PAGE_SIZE);
	uint32 end_va = ROUNDUP(start_va+size,PAGE_SIZE	);
	for (int i = 0; i < numOfPages; i++)
	{
		uint32 *page_table_pointer;
	   get_page_table(e->env_page_directory, start_va, &page_table_pointer);
		if((page_table_pointer[PTX(start_va)]&PERM_PRESENT)==PERM_PRESENT)
		{
		unmap_frame(e->env_page_directory,start_va);
		uint32 *page_table_pointer;
		get_page_table(e->env_page_directory, start_va, &page_table_pointer);
		//entry
		//ws
		env_page_ws_invalidate(e, start_va);
		//page file
		pf_remove_env_page(e, start_va);

		}
		page_table_pointer[PTX(start_va)] = 0x00000000;
		tlb_invalidate(e->env_page_directory, (void *)start_va);
		start_va+=PAGE_SIZE;
	}

	return;
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address,
		uint32 size) {
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address,
		uint32 dst_virtual_address, uint32 size) {
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

