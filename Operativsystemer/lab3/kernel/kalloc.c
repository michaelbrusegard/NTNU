// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

uint64 MAX_PAGES = 0;
uint64 FREE_PAGES = 0;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
    struct run *next;
};

struct
{
    struct spinlock lock;
    struct run *freelist;
    uint64 ref[PHYSTOP/PGSIZE];
} kmem;

void kinit()
{
    initlock(&kmem.lock, "kmem");
    memset(kmem.ref, 0, sizeof(kmem.ref));
    FREE_PAGES = 0;
    freerange(end, (void *)PHYSTOP);
    MAX_PAGES = FREE_PAGES;
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    {
        kmem.ref[(uint64)p/PGSIZE] = 1;
        kfree(p);
    }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    struct run *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
      panic("kfree");

    acquire(&kmem.lock);
    if(kmem.ref[(uint64)pa/PGSIZE] <= 0)
      panic("kfree: negative reference count");
    if(--kmem.ref[(uint64)pa/PGSIZE] > 0) {
      release(&kmem.lock);
      return;
    }
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;
    r->next = kmem.freelist;
    kmem.freelist = r;
    FREE_PAGES++;
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    struct run *r;

    acquire(&kmem.lock);
    r = kmem.freelist;
    if(r) {
      kmem.freelist = r->next;
      kmem.ref[(uint64)r/PGSIZE] = 1;
      FREE_PAGES--;
    }
    release(&kmem.lock);

    if(r)
      memset((char*)r, 5, PGSIZE); // fill with junk
    return (void*)r;
}

void
increment_ref(void *pa)
{
    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
      panic("increment_ref");
    acquire(&kmem.lock);
    kmem.ref[(uint64)pa/PGSIZE]++;
    release(&kmem.lock);
}

int
get_ref(void *pa)
{
    acquire(&kmem.lock);
    int ref = kmem.ref[(uint64)pa/PGSIZE];
    release(&kmem.lock);
    return ref;
}
