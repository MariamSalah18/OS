/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
	return curBlkMetaData->size;
}

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
	return curBlkMetaData->is_free;
}

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
	void *va = NULL;
	switch (ALLOC_STRATEGY)
	{
	case DA_FF:
		va = alloc_block_FF(size);
		break;
	case DA_NF:
		va = alloc_block_NF(size);
		break;
	case DA_BF:
		va = alloc_block_BF(size);
		break;
	case DA_WF:
		va = alloc_block_WF(size);
		break;
	default:
		cprintf("Invalid allocation strategy\n");
		break;
	}
	return va;
}

//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");

}
//
////****************************//
////****************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized=0;
struct MemBlock_LIST list;
void initialize_dynamic_allocator(uint32 daStart,uint32 initSizeOfAllocatedSpace)
{
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
	is_initialized=1;
	LIST_INIT(&list);
	struct BlockMetaData* blk = (struct BlockMetaData *) daStart;
	blk->is_free = 1;
	blk->size = initSizeOfAllocatedSpace;
	LIST_INSERT_TAIL(&list, blk);

}
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{

	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");

	struct BlockMetaData* iterator;
	if(size == 0)
	{
		return NULL;
	}
	if (!is_initialized)
	{
	uint32 required_size = size + sizeOfMetaData();
	uint32 da_start = (uint32)sbrk(required_size);
	//get new break since it's page aligned! thus, the size can be more than the required one
	uint32 da_break = (uint32)sbrk(0);
	initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	LIST_FOREACH(iterator, &list)
	{
		if(size + sizeOfMetaData() == iterator->size && iterator->is_free==1)
		{
			iterator->is_free = 0;
			return iterator+1;
		}

		else if (size + sizeOfMetaData() < iterator->size && iterator->is_free==1)
		{

			if(iterator->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
			{
			struct BlockMetaData *newBlockAfterSplit = (struct BlockMetaData *)((uint32)iterator + size + sizeOfMetaData());
			newBlockAfterSplit->size = iterator->size - (size + sizeOfMetaData()) ;
			newBlockAfterSplit->is_free=1;

		    LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
		    iterator->size = size + sizeOfMetaData();

			}
			iterator->is_free =0;
		    return iterator+1;
		}
	}
	void * oldbrk = sbrk(size + sizeOfMetaData());
	void* newbrk = sbrk(0);

	uint32 brksz= ((uint32)newbrk - (uint32)oldbrk);

		if( oldbrk != (void*)-1)
		 {
			struct BlockMetaData* newBlock = (struct BlockMetaData*)(oldbrk);
			LIST_INSERT_TAIL(&list, newBlock);
			newBlock->size = size + sizeOfMetaData();
			newBlock->is_free = 0;
			if(brksz -(size + sizeOfMetaData()) != 0)
			{
				if(brksz -(size + sizeOfMetaData()) >= sizeOfMetaData())
				{
					struct BlockMetaData* newBlockAfterbrk = (struct BlockMetaData*)((uint32)oldbrk +  size + sizeOfMetaData());
					LIST_INSERT_TAIL(&list, newBlockAfterbrk);
					newBlockAfterbrk->size = brksz -(size + sizeOfMetaData());
					newBlockAfterbrk->is_free = 1;
				}
				else
				{
					newBlock->size= brksz;
				}

			}

			return newBlock+1;
		}
		else
		{
			return NULL;
		}


	return NULL;
}
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
	struct BlockMetaData* iterator;
	struct BlockMetaData* BF = NULL;

	if (size == 0)
	{
		return NULL;
	}

	LIST_FOREACH(iterator, &list)
	{
		if (iterator->is_free == 1 && (size + sizeOfMetaData() == iterator->size))
		{
			iterator->is_free = 0;
			return iterator + 1;
		}
		else if (iterator->is_free == 1&& (size + sizeOfMetaData() <= iterator->size))
		{
			if (BF == NULL || iterator->size < BF->size)
			{
				BF = iterator;
			}
		}
	}

	if (BF != NULL)
	{
		if (size + sizeOfMetaData() <= BF->size)
		{
			if (BF->size - (size + sizeOfMetaData()) >= sizeOfMetaData())
			{
				struct BlockMetaData* newBlockAfterSplit = (struct BlockMetaData *) ((uint32) BF + size + sizeOfMetaData());
				newBlockAfterSplit->size = 0;
				newBlockAfterSplit->size = BF->size - (size + sizeOfMetaData());
				newBlockAfterSplit->is_free = 1;
				LIST_INSERT_AFTER(&list, BF, newBlockAfterSplit);

				BF->size = size + sizeOfMetaData();
				BF->is_free = 0;

				return BF + 1;
			}
			else
			{
				BF->is_free = 0;
				return BF + 1;
			}
		}
	}

	struct BlockMetaData* newBlock = (struct BlockMetaData*) sbrk(size + sizeOfMetaData());

	if (newBlock != (void*) -1)
	{
		LIST_INSERT_TAIL(&list, newBlock);
		newBlock->size = size + sizeOfMetaData();
		newBlock->is_free = 0;
		return newBlock + 1;
	}
	else
	{
		return NULL;
	}

	return NULL;
}

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
	panic("alloc_block_WF is not implemented yet");
	return NULL;
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
	panic("alloc_block_NF is not implemented yet");
	return NULL;
}

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{


	if (va == NULL)
		return;

	struct BlockMetaData* block_pointer = ((struct BlockMetaData*) va - 1);

	uint8 flagx = 0;
	struct BlockMetaData* it;
	LIST_FOREACH(it, &list)
	{
		if (block_pointer == it)
		{
			flagx = 1;
			break;
		}
	}
	if (flagx == 0)
		return;
	if (va == NULL)
		return;

	struct BlockMetaData* prev_block = LIST_PREV(block_pointer);
	struct BlockMetaData* next_block = LIST_NEXT(block_pointer);

	if (prev_block == NULL && next_block == NULL) //only block in list 1
	{
		block_pointer->is_free = 1;
		return;
	}
	else if (prev_block == NULL && next_block->is_free == 1) //head next free --> merge 2
	{
		block_pointer->is_free = 1;
		block_pointer->size += next_block->size;
		next_block->size = 0;
		next_block->is_free = 0;
		LIST_REMOVE(&list, next_block);
		next_block = 0;
		return;
	}
	else if (prev_block == NULL && next_block->is_free == 0) //head next not free 3
	{
		block_pointer->is_free = 1;
	}
	else if (next_block == NULL && prev_block->is_free == 1) //tail prev free --> merge  4
	{
		prev_block->size += block_pointer->size;
		block_pointer->size = 0;
		block_pointer->is_free = 0;
		LIST_REMOVE(&list, block_pointer);
		block_pointer = 0;
		return;
	}
	else if (next_block == NULL && prev_block->is_free == 0) //tail prev not free 5
	{
		block_pointer->is_free = 1;
		return;
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 1) // middle prev and next free 6
	{
		prev_block->size += (block_pointer->size + next_block->size);
		next_block->size = 0;
		next_block->is_free = 0;
		block_pointer->size = 0;
		block_pointer->is_free = 0;
		LIST_REMOVE(&list, block_pointer);
		LIST_REMOVE(&list, next_block);
		next_block = 0;
		block_pointer = 0;
		return;
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 1) //middle prev free 7
	{
		prev_block->size += block_pointer->size;
		block_pointer->size = 0;
		block_pointer->is_free = 0;
		LIST_REMOVE(&list, block_pointer);
		block_pointer = 0;
		return;
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 1 && prev_block->is_free == 0) //middle next free 8
	{
		block_pointer->is_free = 1;
		block_pointer->size += next_block->size;
		next_block->size = 0;
		next_block->is_free = 0;
		LIST_REMOVE(&list, next_block);
		next_block = 0;
		return;
	}
	else if (next_block != NULL && prev_block != NULL && next_block->is_free == 0 && prev_block->is_free == 0) //middle no free  9
	{
		block_pointer->is_free = 1;
		return;
	}
}

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void * realloc_block_FF(void* va, uint32 new_size)
{
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	struct BlockMetaData* iterator;

	if (va == NULL && new_size != 0)
	{
		return alloc_block_FF(new_size);
	}

	if (new_size == 0)
	{
		//(NULL,0)
		if (va == NULL)
		{
			alloc_block_FF(0);
			return NULL;
		}
		//(va,0)
		else if (va != NULL)
		{
			free_block(va);
			return NULL;
		}
	}

	LIST_FOREACH(iterator, &list)
	{
		if (iterator == ((struct BlockMetaData*) va - 1))
		{
			if (iterator->size == new_size + sizeOfMetaData())
			{
				return va;
			}

			//new size > size
			if (new_size > iterator->size)
			{
				struct BlockMetaData* next = LIST_NEXT(iterator);

				//next block more than the needed size
				if (next->is_free == 1 && next != NULL) {
					if (next->size > (new_size - iterator->size))
					{
						if (next->size- (new_size - iterator->size)>=sizeOfMetaData())
						{
							struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator	+ new_size + sizeOfMetaData());
							newBlockAfterSplit->size = 0;
							newBlockAfterSplit->is_free = 1;
							LIST_INSERT_AFTER(&list, iterator,newBlockAfterSplit);
							next->size = 0;
							next->is_free = 0;
							iterator->size = new_size + sizeOfMetaData();
							return va;
						}
						else
						{
							iterator->size = new_size + sizeOfMetaData();
							return (iterator + 1);
						}
					}
					else if (next->size < (new_size - iterator->size)){
						struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
						if (alloc_return != NULL)
						{
							memcpy(alloc_return, va, iterator->size);
							free_block(va);
							return alloc_return;
						}
						else
						{
							return va;
						}
					}

				}

				//next block equal the needed size
				else if (next->is_free == 1 && (next->size)==(new_size-(iterator->size)) && next !=NULL)
				{
					struct BlockMetaData* after_next = LIST_NEXT(next);
					iterator->prev_next_info.le_next = after_next;
					after_next->prev_next_info.le_prev = iterator;
					next->size = 0;
					next->is_free = 0;
					iterator->size = new_size + sizeOfMetaData();
					return va;
				}

				//next block has no free size
				else if (next->is_free == 0 || next == NULL)
				{
					struct BlockMetaData* alloc_return = alloc_block_FF(new_size);
					if (alloc_return != NULL)
					{
						memcpy(alloc_return, va, iterator->size);
						free_block(va);
						return alloc_return;
					}
					else
					{
						return va;
					}
				}
			}
			//new size < size
			else if (new_size < iterator->size)
			{
				if (iterator->size - new_size >= sizeOfMetaData())
				{
					struct BlockMetaData *newBlockAfterSplit =(struct BlockMetaData *) ((uint32) iterator+ new_size + sizeOfMetaData());
					newBlockAfterSplit->size = iterator->size - new_size - sizeOfMetaData();
					LIST_INSERT_AFTER(&list, iterator, newBlockAfterSplit);
					free_block((void*) (newBlockAfterSplit + 1));
					iterator->size = new_size + sizeOfMetaData();
					return va;
				}
				else
				{
					iterator->size = new_size + sizeOfMetaData();
					return (iterator + 1);
				}
			}
		}
	}
	return NULL;
}
