package linux/memory/

import force/lang/Forth
import force/object/ShortString
import force/exception/Exceptions
import force/exception/InvalidArgumentException
import linux/memory/trouble/MemoryReallocationError
import force/memory/Page
import force/memory/SmallPage
import linux/system/Linux
import linux/system/UnixErrors

vocabulary Memory

/* All ranges "x up to y" include x and exclude y as usually. */

/*
 * There are 3 types of Memory Pages:
 * • "Small Pages" hold unisize entries of size 1 up to 512
 * • "Large Pages" hold mixed size entries of size 512 up to 4080.
 * • "Huge Pages" hold entries of size 4080 and bigger (limited only by virtual memory size).
 *
 * All pages start with the general header and then add the additional header for their page style.
 * The first entry immediately follows the header.
 *
 * General page header (10 bytes):
 * cell     NEXT                              ( Pointer to next page of same type. )
 * byte     TYPE                              ( Page type. )
 * byte     FLAGS                             ( Status flags. )

 * Additional header for a small page (+6+n/8 bytes, where n depends on entry size):
 * word     CAPACITY                          ( Total number of slots on page. )
 * word     #FREE                             ( Number of free slots. )
 * word     USED#                             ( Size in bytes of the bit array of used entries. )
 * bit[n]   USED                              ( Bit array of used entries. )
 * entry[]  ENTRIES                           ( The entries. )

 * Additional header for a large page (+1 byte):
 * bit[8]   FREE                              ( Bit array of free entries. Note ¹ )
 * entry[]  ENTRIES                           ( The entries, with a leading length word each. )

 * Additional header for a huge page (+6 bytes):
 * word     #PAGES                            ( Number of consecutive pages. )
 * dword    #BYTES                            ( Total size of the entry. )

 * Flags:
 * 0:       FULL                              ( 1 = Page is full )
 * 1:
 * 2:
 * 3:
 * 4:
 * 5:
 * 6:
 * 7:

 * Notes:
 * ¹ 8 is under the reasonable assumption of a page size of 4096 — needs reprogramming if this
 *   assumption changes!
 */

/*
 * The page array is a memory page containing a list of page numbers for entries of the size equal
 * to the page index --- except for page 0, which is for large entries, and page 511, which is for
 * huge entries.  So, the fourth page number is for entries of size 4, the 100th page number for
 * entries of size 100.
 */

/*
 * The object page array is a memory page of the same structure as the page array, but it is
 * reserved for object instances.  This makes garbage collection a lot easier, because the garbage
 * collector then only has to check the object page array.
 */

/*
 * The Page Directory is a linked list of pages below the program break that have been freed.  It
 * points at the first page, which in turn points at the next page through the first <cell> bytes
 * of the page itself, and contains the number of pages in the next <cell> bytes.
 + Contiguous areas are continually merged.  The last page contains a link of 0.  If the page
 * directory itself is 0, then there are no free pages below the program break.
 * The last block of pages just below the program break is never entered into the page directory;
 * instead, the program break is reduced.
 */

private static section --- Interna

cell variable InitialBreak        ( Initial address of the program break )
cell variable ProgramBreak        ( Current address of the program break = top memory )
cell variable ObjectSpace         ( Address of the object page array )
4096 constant Page#               ( Size of a memory page )
cell variable PageArray           ( Address of the page array: 512 page pointers )
cell variable PageDirectory       ( Address of the page directory. )

: >page ( #p -- @p )  Page# u* ;

public defer allocate

( Reduces freed page range at address a by # pages and returns the address of the removed range. )
: reduceRange ( a # -- a' )  over cell+ −!  dup cell+ @ Page# u* + ;
( Removes page range at address a from the page directory and returns its address. )
: reallocateRange ( a -- a )  PageDirectory@ over =?if  over @ swap !  exit  then
  begin dup while  2dup @ =if  over @ swap ! exit  then  @  repeat  drop
  MemoryReallocationError raise ;
( Reallocates # pages of the freed page range at address a.
  If the range at address a contains more than # pages, the last of them are removed and allocated,
  otherwise the entire page range is removed from the page directory )
: reallocate ( a # -- a )  over cell+ @ over u> if  reduceRange  else  drop reallocateRange  then ;
( Allocates a single page after the program break, returning its address a. )
: allocateNewPage ( -- a )  ProgramBreak@ dup Page# + pgmbreak ProgramBreak! ;

( Allocates a single page of memory, preferrably from the page directory, returning its address a. )
public static : allocatePage ( -- a )
  PageDirectory@ begin 0≠?while  dup cell+ @ 4u<if  1 reallocate exit  then
  @ repeat  drop  allocateNewPage ;
( Allocates a single page of clear memory (all zeroes) and returns address a of the block. )
public static : allocatePage0 ( -- a )  allocatePage  dup Page# cellu/ 0 fill ;


( Allocates a contiguous area of # pages after the program break and returns its address a. )
: allocateNewArea ( # -- a )  ProgramBreak@ tuck swap Page# u* + pgmbreak ProgramBreak! ;
( Finds an area of # contiguous free pages, or allocates from the program break, and returns its
  address a. )
: allocateArea ( # -- a )
  PageDirectory@ begin 0≠?while  dup cell+ @ 3pick u≥if  swap reallocate exit  then
  @  repeat  drop allocateNewArea ;

( Creates a small page for entries of size #, registers it in the page directory, and returns its
  address a. )
: @newSmallPage ( # -- a )  dup allocatePage0  0 over Successor!  2dup Type!  0 over Flags!
  Page# over Used## − 2pick 8u* 3pick 8u* 1+ u/ over Used#!
  Page# over Used## − over Used#@ − over Capacity!  dup Capacity@ over #Free!  nip ;

( Returns address a of a small page for entries of size # with a free slot. )
: @freeSmallPage ( # -- a )  >r PageDirectory@ r@ 4u* + d@ >page
  begin 0=?while  dup SmallPage#Free@ 0≠if  exit  then  Successor@  repeat  @newSmallPage ;
( Returns address a of a large page for with enough free space to accommodate an entry of size #. )
: @freeLargePage ( # -- a )  ... ( >r PageDirectory@ d@ >page begin 0=?while  dup LargePage ) ;
( Returns address a of a huge page for with enough free space to accommodate an entry of size #. )
: @freeHugePage ( # -- a )  ... ;
( Returns address a of a page for entries of size # with enough free space to accommodate an entry
  of size #. )
: @freePage ( # -- a )
  1=?if  @freeSmallPage  else  512u<?if  @freeLargePage  else  @freeHugePage  then  then ;

( Allocates a small entry (1 up to 512 bytes). )
: allocateSmall ( # -- a )  @freeSmallPage Entry ;
( Allocates a large entry (512 up to 4080 bytes). )
: allocateLarge ( # -- a )  ... ;
( Allocates a huge entry (bigger than 4080 bytes). )
: allocateHuge ( # -- a )  ... ;

( Allocates a memory chunk of size # and returns its address a. )
: _allocate ( # -- a )  1<?if  1 "Invalid allocation size: %d"| InvalidArgumentException raise  then
  512<?if  allocateSmall  else  4080<?if  allocateLarge  else  allocateHuge  then  then ;
  fulfills allocate

public static section --- API

--- Single Page Allocation ---

--- Multi-Page Allocation ---

( Allocates # contiguous pages of memory and returns address a of the block. )
: allocatePages ( # -- a )
  0=?if  1 "Invalid amount of pages: %d"| InvalidArgumentException raise  then
  1=?if  drop allocatePage  else  allocateArea  then ;
( Allocates # contiguous pages of clear memory (all zeroes) and returns address a of the block. )
: allocatePages0 ( # -- a )  dup allocatePages  tuck swap Page# u* cellu/ 0 fill ;

--- Entry Allocation ---

( Allocates a memory chunk of # bytes and clears it to all 0. )
: allocate0 ( # -- a )  dup allocate tuck -rot 0 cfill ;

--- Object Allocation ---

( Allocates a small object of size # and returns its address a. )
: allocSmallObj ( # -- a )  ... ;
( Allocates a large object of size # and returns its address a. )
: allocLargeObj ( # -- a )  ... ;
( Allocates a huge object of size # and returns its address a. )
: allocHugeObj ( # -- a )  ... ;
( Allocates an object instance of total size #, clears it to all 0, and returns its address a. )
: allocObj ( # -- a )  1<?if  1 "Invalid allocation size: %d"| InvalidArgumentException raise  then
  dup 512<?if  allocSmallObj  else  4080<?if  allocLargeObj  else  allocHugeObj  then  then
  tuck -rot 0 cfill ;

( Returns the top memory address. )
: topmem ( -- a )  ProgramBreak@ ;

( Initializes the vocabulary from initialization structure at address @initstr when loading. )
private init : init ( @initstr -- @initstr )
  1000.s 0 pgmbreak unless  >errmsg 1 "Fatal error while initializing Linux memory: %s"abort  then
  ProgramBreak!  allocatePage0 PageArray!  allocatePage0 ObjectSpace! ProgramBreak@ InitialBreak! ;

vocabulary;
export LinuxMemory
