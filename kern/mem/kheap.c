#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

uint32 kbreak;
int initialize_kheap_dynamic_allocator(uint32 daStart,uint32 initSizeToAllocate, uint32 daLimit)
{
    start = ROUNDDOWN(daStart, PAGE_SIZE);
	initSize = ROUNDUP(initSizeToAllocate, PAGE_SIZE);
	limit = ROUNDUP(daLimit, PAGE_SIZE);
	kbreak = daStart + initSize;
	if (kbreak > limit)
		return E_NO_MEM;
	int allocate_return;
	int map_return;
	uint32 noOfPages = initSize / PAGE_SIZE;
	uint32 startva = start;
	struct FrameInfo *frame_ptr;
	for (uint32 i = 0; i < noOfPages; i++) {

		allocate_return = allocate_frame(&frame_ptr);
		map_return = map_frame(ptr_page_directory, frame_ptr, startva, PERM_WRITEABLE);
		frame_ptr->va=startva;
		startva += PAGE_SIZE;
		if (allocate_return != 0 || map_return != 0)
			return E_NO_MEM;
	}
	initialize_dynamic_allocator(start, initSize);
	return 0;

}

uint32 brk;
uint32 oldbrk;
uint32 x;
int firstcall=0;
void* sbrk(int increment)
{
	//TODO: [PROJECT'23.MS2 - #02] [1] KERNEL HEAP - sbrk()

if(firstcall==0){
	 brk = start + initSize;


firstcall=1;
}
oldbrk= brk;
 x = brk;

	if(increment == 0)
	{
		return (void*)oldbrk;
	}

	else if(increment > 0 && (brk + increment) <= limit)
	{


		if(increment % PAGE_SIZE == 0)
		{

			for(uint32 i = 0; i<(increment/PAGE_SIZE); i++)
			{
				struct FrameInfo* newFrame;
				allocate_frame(&newFrame);
				map_frame(ptr_page_directory, newFrame, x, PERM_WRITEABLE);
				newFrame->va=x;
				x +=PAGE_SIZE;
			}

		}
		else
		{

			for(uint32 i = 0; i<(increment/PAGE_SIZE)+1; i++)
			{
				struct FrameInfo* newFrame;
				allocate_frame(&newFrame);
				map_frame(ptr_page_directory, newFrame, x, PERM_WRITEABLE);
				newFrame->va=x;
				x +=PAGE_SIZE;
			}

		}
		brk+=increment;
		brk= ROUNDUP(brk, PAGE_SIZE);
		return (void*)oldbrk;

	}
	else if(increment < 0)
	{
		brk+=increment;
		if(ROUNDUP(oldbrk, PAGE_SIZE) - brk > PAGE_SIZE)
		{
				for(uint32 i=0 ; i<(ROUNDUP(oldbrk, PAGE_SIZE) - brk)/PAGE_SIZE; i++)
				{
					unmap_frame(ptr_page_directory, x);
					x-=PAGE_SIZE;
				}


		}
		return (void*)brk;
	}
	panic("no space to allocate\n");


	//MS2: COMMENT THIS LINE BEFORE START CODING====
	return (void*)-1 ;
	//panic("not implemented yet");
}

#define  kernel_pages ((KERNEL_HEAP_MAX-KERNEL_HEAP_START)/PAGE_SIZE)
#define  kernel_space (KERNEL_HEAP_MAX-KERNEL_HEAP_START)
struct kernel_struct
{
	uint32 address;
	uint8 is_allocated;
	uint32 Size;
};
struct kernel_struct kernelArr[kernel_pages];
uint32 kernel_free_space;
uint32 block_pages;
int temp =0;
void* kmalloc(unsigned int size)
{
	if(size==0)
		return NULL;
    block_pages =(limit-KERNEL_HEAP_START)/PAGE_SIZE;
	uint32 alloc_start = (((limit+PAGE_SIZE)-KERNEL_HEAP_START))/PAGE_SIZE;
	if(temp==0)
	{
		kernel_free_space= KERNEL_HEAP_MAX-(limit + PAGE_SIZE);
		for(uint32 i=0;i<kernel_pages;i++)
	{

		kernelArr[i].address=((KERNEL_HEAP_START)+(i*PAGE_SIZE));
		kernelArr[i].is_allocated=0;
		kernelArr[i].Size=0;
	}
    temp=1;
	}

	if(size<=DYN_ALLOC_MAX_BLOCK_SIZE)
	{

			return alloc_block_FF(size);
	}

		else if(size>(KERNEL_HEAP_MAX-(limit + PAGE_SIZE)))
		{
			return NULL;
		}
		else if(size>DYN_ALLOC_MAX_BLOCK_SIZE)
		{

			uint32 roundedUp_size= ROUNDUP (size, PAGE_SIZE);
			uint32 number_of_pages=roundedUp_size/PAGE_SIZE;
			uint32 start;
			uint32 startIndex;
			int allocate_return;
			int map_return;
			uint32 counter=0;
			//search
			for(uint32 i=alloc_start;i<kernel_pages;i++)
			{
				if(kernelArr[i].is_allocated==0)
				{
					counter++;

					if(counter==1)
					{
					start=kernelArr[i].address;

					startIndex=i;
					}
					if(counter==number_of_pages)
					{
					break;
					}
				}
				else if (kernelArr[i].is_allocated==1)
				{
					counter=0;
				}

			}

			//allocate
			struct FrameInfo *frame_ptr;
			uint32 startva;
			if(counter==number_of_pages)
			{
				startva=start;
			for(int i=0;i<number_of_pages;i++)
			{
				allocate_return=allocate_frame(&frame_ptr);
				map_return=map_frame(ptr_page_directory,frame_ptr,startva,PERM_WRITEABLE);
				frame_ptr->va=startva;
				startva+=PAGE_SIZE;

					     if(allocate_return!=0||map_return!=0)
					    	 return NULL;
			}
			kernelArr[startIndex].Size=roundedUp_size;
			for(int i=startIndex;i<startIndex+number_of_pages;i++)
			{
              kernelArr[i].is_allocated=1;
			}
		 //  kernel_free_space-=size;
			return (void*)start;
			}
				}
	return NULL;
}

void kfree(void* virtual_address)
{
	if(virtual_address==NULL)
		return;
    uint32 va_cast=(uint32)virtual_address;
    uint32 sz;
    uint32 numPages;
    uint32 index;

    if(va_cast >= start && va_cast <= limit) //block  allocator start-limit
    {
	  free_block(virtual_address);
	  return;
    }
    else if(va_cast >= (limit+PAGE_SIZE) && va_cast <= KERNEL_HEAP_MAX) //page allocator  limit+page - kernel max
    {
	  for(int i =0;i<kernel_pages;i++) //search for passed va in kernel array
	  {
		 if(va_cast==kernelArr[i].address)
		 {
			sz=kernelArr[i].Size;
			index=i;
			break;
		}
	}
	if (sz==0)
		return;
	numPages=sz/PAGE_SIZE; //no of pages to deallocate
	uint32 start_va=va_cast;
	for(uint32 i=0;i<numPages;i++)
	{
		unmap_frame(ptr_page_directory,start_va);
		start_va+=PAGE_SIZE;
	}
	//edit array
	kernelArr[index].Size=0;
	for(int i=index;i<numPages+index;i++)
	{
		kernelArr[i].is_allocated=0;
	}

    }
else
      {
	panic("invalid address\n");
      }
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
    uint32 offset=physical_address&0xFFF;
	struct FrameInfo *ptr_frame_info=NULL;
	ptr_frame_info=to_frame_info(physical_address);
	if(ptr_frame_info->references==0)
	{
		return 0;
	}
	else if(ptr_frame_info!=NULL)
    {
	 uint32 va=ptr_frame_info->va;
	 return(va+offset);
    }

    return 0;
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	uint32* ptr_page_table = NULL;
	get_page_table(ptr_page_directory, virtual_address, &ptr_page_table);
	int tableindex = PTX(virtual_address);
	uint32 offset = virtual_address & 0xFFF;

	if (ptr_page_table != NULL)
	{
		uint32 entry = ptr_page_table[tableindex];
		uint32 startphyadd = entry & 0xFFFFF000;
		uint32 phyadd = startphyadd + offset;
		return (phyadd);
	}
	return 0;

}

void kfreeall() {
	panic("Not implemented!");

}

void kshrink(uint32 newSize) {
	panic("Not implemented!");
}

void kexpand(uint32 newSize) {
	panic("Not implemented!");
}

//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void * krealloc(void *virtual_address, uint32 new_size) {
    //TODO: [PROJECT'23.MS2 - BONUS#1] [1] KERNEL HEAP - krealloc()
    // Write your code here, remove the panic and write your code
    //panic("krealloc() is not implemented yet...!!");
	uint32 page_alloc_start = (((limit + PAGE_SIZE) - KERNEL_HEAP_START)) / PAGE_SIZE;
	uint32 old_size;
	int index;

    for (int i = 0; i < kernel_pages; i++)
    {
        // finding the va
        if (kernelArr[i].address == (uint32)virtual_address)
        {
            old_size = kernelArr[i].Size;
            index = i;
            break;
        }
    }
    //if it's in dynamic allocator
        if (index < page_alloc_start)
        {
            return realloc_block_FF(virtual_address, new_size);
        }

     else
     {
        //page allocator

    	 if (virtual_address == NULL)
    	 {
    	         if (new_size == 0)
    	         {
    	             return NULL;
    	         }
    	         else
    	         {
    	             return kmalloc(new_size);
    	         }
    	  }

    	  if (new_size == 0)
    	     {
    	         kfree(virtual_address);
    	         return NULL;
    	     }


    if (old_size == new_size)
    	{
    		return virtual_address;
    	}
    //new size > old
    else if (new_size > old_size) {
                //searching for pages after and reallocating in the same place
                uint32 size_inc = new_size- old_size;
                uint32 rounded_up = ROUNDUP(size_inc, PAGE_SIZE);
                uint32 number_of_allocated=old_size/PAGE_SIZE; //add->size/pgsz
                uint32 number_of_pages_allocate = rounded_up / PAGE_SIZE;//6
                uint32 number_of_pgs=index+number_of_allocated;
                uint32 counter = 0;

                for (int i = number_of_pgs; i < (number_of_pgs + number_of_pages_allocate); i++)
                {
                    if (kernelArr[i].is_allocated == 0)
                    {
                        counter++;
                    }
                    else if (kernelArr[i].is_allocated == 1)
                    {
                        break;
                    }
                }

                int allocate_return;
                int map_return;
                struct FrameInfo *frame_ptr;
                uint32 dx = number_of_pgs;
                if (counter == number_of_pages_allocate)
                {
                    for (int i = 0; i < number_of_pages_allocate; i++)
                    {
                        allocate_return = allocate_frame(&frame_ptr);
                        map_return = map_frame(ptr_page_directory, frame_ptr, kernelArr[dx].address, PERM_WRITEABLE);
                        frame_ptr->va = kernelArr[dx].address;
                        dx++;
                        if (allocate_return != 0 || map_return != 0)
                            return NULL;
                    }
                    kernelArr[index].Size = ROUNDUP(new_size,PAGE_SIZE);
                    for (int i = number_of_pgs; i < (number_of_pgs + number_of_pages_allocate); i++)
                     {
                    	kernelArr[i].is_allocated=1;
                     }
                    return (void*)kernelArr[index].address;
                }
                else
                {
                    //no enough pages after so reallocate in different place
                    void *kmalloc_ret = kmalloc(new_size);
                    if (kmalloc_ret != NULL)
                    {
                    	memcpy(kmalloc_ret, virtual_address, old_size);
                        kfree(virtual_address);
                        return kmalloc_ret;
                }
                    //failure
                    else
                    {
                        return NULL;
                    }
                }

        }
        //calling reallocate with decreased size
        else if (new_size < old_size)
        {

        	uint32 round_new_size=ROUNDUP(new_size,PAGE_SIZE);
        	uint32 diff = old_size-round_new_size;
        	uint32 pgs_to_keep=round_new_size/PAGE_SIZE;

        	if(diff==0)
        	{
        		return (void*)kernelArr[index].address;
        	}
        	else
        	{
        		uint32 no_of_removed_pgs=diff/PAGE_SIZE;
        		uint32 new_index=index+pgs_to_keep;
        		for(uint32 i=new_index;i<(new_index+no_of_removed_pgs);i++)
        		{
        			kfree((void*)kernelArr[i].address);
        		}
        		kernelArr[index].Size=round_new_size;
        		return (void*)kernelArr[index].address;
        	}
        }
        return NULL;
    }
}
