/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include "../cpu/sched.h"
#include "../disk/pagefile_manager.h"
#include "../mem/memory_manager.h"

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE) {
	assert(
			LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE;
}
void setPageReplacmentAlgorithmCLOCK() {
	_PageRepAlgoType = PG_REP_CLOCK;
}
void setPageReplacmentAlgorithmFIFO() {
	_PageRepAlgoType = PG_REP_FIFO;
}
void setPageReplacmentAlgorithmModifiedCLOCK() {
	_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;
}
/*2018*/void setPageReplacmentAlgorithmDynamicLocal() {
	_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;
}
/*2021*/void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps) {
	_PageRepAlgoType = PG_REP_NchanceCLOCK;
	page_WS_max_sweeps = PageWSMaxSweeps;
}

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE) {
	return _PageRepAlgoType == LRU_TYPE ? 1 : 0;
}
uint32 isPageReplacmentAlgorithmCLOCK() {
	if (_PageRepAlgoType == PG_REP_CLOCK)
		return 1;
	return 0;
}
uint32 isPageReplacmentAlgorithmFIFO() {
	if (_PageRepAlgoType == PG_REP_FIFO)
		return 1;
	return 0;
}
uint32 isPageReplacmentAlgorithmModifiedCLOCK() {
	if (_PageRepAlgoType == PG_REP_MODIFIEDCLOCK)
		return 1;
	return 0;
}
/*2018*/uint32 isPageReplacmentAlgorithmDynamicLocal() {
	if (_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL)
		return 1;
	return 0;
}
/*2021*/uint32 isPageReplacmentAlgorithmNchanceCLOCK() {
	if (_PageRepAlgoType == PG_REP_NchanceCLOCK)
		return 1;
	return 0;
}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt) {
	_EnableModifiedBuffer = enableIt;
}
uint8 isModifiedBufferEnabled() {
	return _EnableModifiedBuffer;
}

void enableBuffering(uint32 enableIt) {
	_EnableBuffering = enableIt;
}
uint8 isBufferingEnabled() {
	return _EnableBuffering;
}

void setModifiedBufferLength(uint32 length) {
	_ModifiedBufferLength = length;
}
uint32 getModifiedBufferLength() {
	return _ModifiedBufferLength;
}

//===============================
// FAULT HANDLERS
//===============================

//Handle the table fault
void table_fault_handler(struct Env * curenv, uint32 fault_va) {
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory,
				(uint32) fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//Handle the page fault

void page_fault_handler(struct Env * curenv, uint32 fault_va) {
#if USE_KHEAP
	struct WorkingSetElement *victimWSElement = NULL;
	uint32 wsSize = LIST_SIZE(&(curenv->page_WS_list));
#else
	int iWS =curenv->page_last_WS_index;
	uint32 wsSize = env_page_ws_get_size(curenv);
#endif

	//cprintf("REPLACEMENT=========================WS Size = %d\n", wsSize );
	//refer to the project presentation and documentation for details
	if (isPageReplacmentAlgorithmFIFO()) {
		if (wsSize < (curenv->page_WS_max_size)) {
			struct FrameInfo *frame_info_ptr = NULL;
			int allocatereturn = allocate_frame(&frame_info_ptr);
			if (allocatereturn != E_NO_MEM) {

				map_frame(curenv->env_page_directory, frame_info_ptr, fault_va,
				PERM_USER | PERM_WRITEABLE);
				int ret = pf_read_env_page(curenv, (void *) fault_va);
				if (ret == E_PAGE_NOT_EXIST_IN_PF)

				{
					bool flag1 = fault_va >= USTACKBOTTOM
							&& fault_va < USTACKTOP;
					bool flag2 = fault_va >= USER_HEAP_START
							&& fault_va < USER_HEAP_MAX;

					if (!(flag1) && !(flag2)) {

						uint32 offset = pt_get_page_permissions(
								curenv->env_page_directory, fault_va);
						sched_kill_env(curenv->env_id);

					}

				}
				struct WorkingSetElement* element =
						env_page_ws_list_create_element(curenv, fault_va);
				LIST_INSERT_TAIL(&(curenv->page_WS_list), element);
				if (LIST_SIZE(&(curenv->page_WS_list))
						== curenv->page_WS_max_size) {
					curenv->page_last_WS_element = LIST_FIRST(
							&(curenv->page_WS_list));
				} else {
					curenv->page_last_WS_element = NULL;
				}

			}
		}

		else //replacement fifo
		{
			//TODO: [PROJECT'23.MS3 - #1] [1] PAGE FAULT HANDLER - FIFO Replacement
			uint32 *page_table_pointer;
			get_page_table(curenv->env_page_directory,curenv->page_last_WS_element->virtual_address,&page_table_pointer);
			uint32 PTX = page_table_pointer[PTX(curenv->page_last_WS_element->virtual_address)];
			struct FrameInfo *info = get_frame_info(curenv->env_page_directory,
					curenv->page_last_WS_element->virtual_address,&page_table_pointer);
			if ((PTX & PERM_MODIFIED) == PERM_MODIFIED)
			{
				pf_update_env_page(curenv,curenv->page_last_WS_element->virtual_address, info);
			}
			unmap_frame(curenv->env_page_directory,curenv->page_last_WS_element->virtual_address);
			struct WorkingSetElement *removed_element =curenv->page_last_WS_element;
			curenv->page_last_WS_element = LIST_NEXT(curenv->page_last_WS_element);
			LIST_REMOVE(&(curenv->page_WS_list), removed_element);
			struct FrameInfo *frame_info_ptr = NULL;
			int allocatereturn = allocate_frame(&frame_info_ptr);
			if (allocatereturn != E_NO_MEM) {

				map_frame(curenv->env_page_directory, frame_info_ptr, fault_va,
						PERM_USER | PERM_WRITEABLE);
				int ret = pf_read_env_page(curenv, (void *) fault_va);
				if (ret == E_PAGE_NOT_EXIST_IN_PF)

				{
					bool flag1 = fault_va >= USTACKBOTTOM
							&& fault_va < USTACKTOP;
					bool flag2 = fault_va >= USER_HEAP_START
							&& fault_va < USER_HEAP_MAX;
					if (!(flag1) && !(flag2)) {
						//uint32 offset = pt_get_page_permissions(curenv->env_page_directory, fault_va);
						sched_kill_env(curenv->env_id);
					}

				}
				struct WorkingSetElement* element =
						env_page_ws_list_create_element(curenv, fault_va);
				if (curenv->page_last_WS_element == NULL) {
					LIST_INSERT_TAIL(&(curenv->page_WS_list), element);
					curenv->page_last_WS_element = LIST_FIRST(
							&(curenv->page_WS_list));
				} else {
					LIST_INSERT_BEFORE(&(curenv->page_WS_list),
							curenv->page_last_WS_element, element);
				}

			}
			//cprintf("===================================================================\n");
		}

	} //end of fifo

	if (isPageReplacmentAlgorithmLRU(PG_REP_LRU_LISTS_APPROX))
	{
		uint32 ActiveSize = LIST_SIZE(&(curenv->ActiveList));
		uint32 SecondSize = LIST_SIZE(&(curenv->SecondList));

		if ((ActiveSize + SecondSize) < curenv->page_WS_max_size) {

			if (ActiveSize < curenv->ActiveListSize) {

				struct FrameInfo *frame_info_ptr = NULL;
				int allocatereturn = allocate_frame(&frame_info_ptr);
				if (allocatereturn != E_NO_MEM) {

					map_frame(curenv->env_page_directory, frame_info_ptr,
							fault_va, PERM_USER | PERM_WRITEABLE);
					int ret = pf_read_env_page(curenv, (void*) fault_va);
					if (ret == E_PAGE_NOT_EXIST_IN_PF) {
						bool flag1 = fault_va >= USTACKBOTTOM
								&& fault_va < USTACKTOP;
						bool flag2 = fault_va >= USER_HEAP_START
								&& fault_va < USER_HEAP_MAX;
						if (!(flag1) && !(flag2)) {
							sched_kill_env(curenv->env_id);

						}

					}
					struct WorkingSetElement* element =
							env_page_ws_list_create_element(curenv, fault_va);
					LIST_INSERT_HEAD(&(curenv->ActiveList), element);
					pt_set_page_permissions(curenv->env_page_directory,
							LIST_FIRST(&(curenv->ActiveList))->virtual_address,
							PERM_PRESENT, 0);

				}

			} else
			{
				struct WorkingSetElement* ActiveTail = LIST_LAST(&(curenv->ActiveList));
				struct WorkingSetElement* it;
				struct WorkingSetElement* el;
				int insecond = 0;

				LIST_FOREACH(it,&(curenv->SecondList))
				{
					if (it->virtual_address == fault_va)
					{
						LIST_REMOVE(&(curenv->ActiveList), ActiveTail);
						LIST_REMOVE(&(curenv->SecondList), it);
						//set present
						pt_set_page_permissions(curenv->env_page_directory,
								it->virtual_address, PERM_PRESENT, 0);
						LIST_INSERT_HEAD(&(curenv->ActiveList), it);
						LIST_INSERT_HEAD(&(curenv->SecondList), ActiveTail);
						pt_set_page_permissions(curenv->env_page_directory,
								ActiveTail->virtual_address, 0, PERM_PRESENT);

						insecond = 1;
						break;
					}

				}

				if (insecond == 0) {
					struct FrameInfo *frame_info_ptr = NULL;
					int allocatereturn = allocate_frame(&frame_info_ptr);
					if (allocatereturn != E_NO_MEM) {

						map_frame(curenv->env_page_directory, frame_info_ptr,
								fault_va, PERM_USER | PERM_WRITEABLE);
						int ret = pf_read_env_page(curenv, (void *) fault_va);
						if (ret == E_PAGE_NOT_EXIST_IN_PF) {
							bool flag1 = fault_va >= USTACKBOTTOM
									&& fault_va < USTACKTOP;
							bool flag2 = fault_va >= USER_HEAP_START
									&& fault_va < USER_HEAP_MAX;
							if (!(flag1) && !(flag2)) {
								sched_kill_env(curenv->env_id);

							}

						}
						struct WorkingSetElement* element =
								env_page_ws_list_create_element(curenv,
										fault_va);
						//set present to 0
						LIST_REMOVE(&(curenv->ActiveList), ActiveTail);
						pt_set_page_permissions(curenv->env_page_directory,
								ActiveTail->virtual_address, 0, PERM_PRESENT);
						LIST_INSERT_HEAD(&(curenv->SecondList), ActiveTail);
						struct WorkingSetElement* fault =
								curenv->page_last_WS_element;

						pt_set_page_permissions(curenv->env_page_directory,
								element->virtual_address, PERM_PRESENT, 0);

						LIST_INSERT_HEAD(&(curenv->ActiveList), element);

					}

					//TODO: [PROJECT'23.MS3 - #2] [1] PAGE FAULT HANDLER – LRU Placement
				}
			}

		} else //replacement

		{

			//TODO: [PROJECT'23.MS3 - #1] [1] PAGE FAULT HANDLER - LRU Replacement
            bool inList = 0;
			struct WorkingSetElement* ActiveTail = LIST_LAST(&(curenv->ActiveList));
			struct WorkingSetElement* it;
			//access to already existing page :
			LIST_FOREACH(it, &(curenv->SecondList))
			{
				it->virtual_address=ROUNDDOWN(it->virtual_address,PAGE_SIZE);
				fault_va=ROUNDDOWN(fault_va,PAGE_SIZE);
				if (it->virtual_address == fault_va)
				{
					LIST_REMOVE(&(curenv->ActiveList), ActiveTail);
					LIST_REMOVE(&(curenv->SecondList), it);
					//set present
					pt_set_page_permissions(curenv->env_page_directory,it->virtual_address, PERM_PRESENT, 0);

					LIST_INSERT_HEAD(&(curenv->ActiveList), it);
					LIST_INSERT_HEAD(&(curenv->SecondList), ActiveTail);
					pt_set_page_permissions(curenv->env_page_directory,ActiveTail->virtual_address, 0, PERM_PRESENT);
					inList = 1;
					break;
				}
			}
			//not in the second list
			if (inList == 0)
			{
				struct WorkingSetElement* victim = LIST_LAST(&(curenv->SecondList));
				uint32 *page_table_pointer;
				get_page_table(curenv->env_page_directory,victim->virtual_address, &page_table_pointer);
				uint32 offset = page_table_pointer[PTX(victim->virtual_address)];
				struct FrameInfo *ptr_frame_info = get_frame_info(curenv->env_page_directory, victim->virtual_address,&page_table_pointer);
				if ((offset & PERM_MODIFIED) == PERM_MODIFIED)
				{
					int ret = pf_update_env_page(curenv,victim->virtual_address, ptr_frame_info);
				}
				unmap_frame(curenv->env_page_directory,victim->virtual_address);
				struct FrameInfo *frame_info_ptr = NULL;
				int allocatereturn = allocate_frame(&frame_info_ptr);
				if (allocatereturn != E_NO_MEM)
				{

					map_frame(curenv->env_page_directory, frame_info_ptr,fault_va, PERM_USER | PERM_WRITEABLE);
					int ret = pf_read_env_page(curenv, (void *) fault_va);
					if (ret == E_PAGE_NOT_EXIST_IN_PF)
					{
						bool flag1 = fault_va >= USTACKBOTTOM
								&& fault_va < USTACKTOP;
						bool flag2 = fault_va >= USER_HEAP_START
								&& fault_va < USER_HEAP_MAX;
						if (!(flag1) && !(flag2))
						{
							sched_kill_env(curenv->env_id);

						}

					}
					struct WorkingSetElement* element =env_page_ws_list_create_element(curenv, fault_va);
					struct WorkingSetElement* firstTail = LIST_LAST(&(curenv->ActiveList));
					LIST_REMOVE(&(curenv->SecondList), victim);
					LIST_REMOVE(&(curenv->ActiveList), firstTail);
					//set present to 0
					pt_set_page_permissions(curenv->env_page_directory,firstTail->virtual_address, 0, PERM_PRESENT);
					//ActiveTail->virtual_address =ActiveTail->virtual_address & 0xFFFFFFFE;
					LIST_INSERT_HEAD(&(curenv->SecondList), firstTail);
					pt_set_page_permissions(curenv->env_page_directory,element->virtual_address, PERM_PRESENT, 0);
					LIST_INSERT_HEAD(&(curenv->ActiveList), element);
				}

			}

		}
	}

}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}

