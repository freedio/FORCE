package linux/memory/

import force/lang/Forth
import force/exception/Exceptions
import force/exception/InvalidArgumentException
import linux/memory/trouble/MemoryReallocationError
import force/memory/Page
import force/memory/SmallPage
import force/memory/LargePage
import force/memory/HugePage
import linux/system/Linux
import linux/system/UnixErrors
import force/string/Format

vocabulary Memory

/* All ranges "x up to y" include x and exclude y as usual. */

/*
 * There are 3 types of Memory Pages:
 * • "Small Pages" hold unisize entries of size 1 up to 254
 * • "Large Pages" hold mixed size entries of size 255 up to 4080.
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
 * byte     #ENTRIES                          ( Number of entries on page. )
 * entry[]  ENTRIES                           ( The entries, with a leading length/stat word each. )

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

cell variable InitialBreak        ( Initial address of the program break. )
cell variable ProgramBreak        ( Current address of the program break = top memory. )
cell variable ObjectSpace         ( Address of the object page array. )
4096 constant Page#               ( Size of a memory page, linked with Page%. )
-4096 constant -Page#             ( Mask of a memory page address. )
12 constant Page%                 ( Shift for page related operations, linked with Page#. )
cell variable PageArray           ( Address of the page array: 512 page pointers )
cell variable PageDirectory       ( Address of the page directory. )

255 constant MAX_SMALL            ( Maximum small entry size + 1. )
4081 constant MAX_LARGE           ( Maximum large entry size + 1. )

( Converts page number #p to corresponding page address @p. )
: pages ( #p -- @p )  Page% u<< ;
( Converts page address @p corresponding to page number #p. )
: >page# ( @p -- #p )  Page% u>> ;

( Returns page number #p stored at entry # in the page array. )
: toppage@ ( # -- #p )  PageArray@ swap 4u*+ d@ ;
( Stores page number #p at entry # in the page array. )
: toppage! ( #p # -- )  PageArray@ swap 4u*+ d! ;

public defer allocate

( Reduces freed page range at address a by # pages and returns the address of the removed range. )
: reduceRange ( a # -- a' )  over cell+ −!  dup cell+ @ pages + ;
( Removes page range at address a from the page directory and returns its address. )
: reallocateRange ( a -- a )  PageDirectory@ over =?if  over @ swap !  exit  then
  begin dup while  2dup @ =if  over @ swap ! exit  then  @  repeat  drop
  MemoryReallocationError raise ;
( Reallocates # pages of the freed page range at address a.
  If the range at address a contains more than # pages, the last of them are removed and allocated,
  otherwise the entire page range is removed from the page directory )
: reallocate ( a # -- a )  over cell+ @ over u> if  reduceRange  else  drop reallocateRange  then ;
( Allocates a single page after the program break, returning its address a. )
: allocateNewPage ( -- a )  ProgramBreak@ dup Page# + pgmbreak unless
  >errmsg 1 "Error while setting program break: %s"|abort  then
  ProgramBreak! ;
( Unlinks page @p from page array slot at address a. )
: _unlinkPage ( @p a -- )  begin  2dup d@ pages ≠while  d@ pages  0=?until  2drop exit  then
  swap Successor@ swap d! ;
( Removes page @p from the page array. )
: unlinkPage ( @p -- )  PageArray@ over PageType@ 4*+ _unlinkPage ;
( Merges free pages in the page directory. )
: mergeFreePages ( -- )  PageDirectory@ begin  dup 1 ProgramBreak@ within while  dup cell+ @ pages over + over @ =?if
  2dup @ swap !  cell+ @ over cell+ +!  else  nip  then  repeat  drop ;
( Inserts page(s) @p into the page directory. )
: freePage ( @p -- )  PageDirectory  begin  2dup @ dup 0- -rot u> and while
  @  0=?until  drop PageDirectory! exit  then  2dup @! nip swap ! ;
( Clears page at address a to all zeroes. )
: clearPage ( a -- )  Page# cellu/ 0 fill ;

( Allocates a single page of memory, preferrably from the page directory, returning its address a. )
public static : allocatePage ( -- a )
  PageDirectory@ begin dup 0≠ while  dup cell+ @ 4u<if  1 reallocate exit  then
  @ repeat  drop  allocateNewPage ;
( Allocates a single page of clear memory (all zeroes) and returns address a of the block. )
public static : allocatePage0 ( -- a )  allocatePage  dup clearPage ;
( Disposes of allocated page range of # ages at address a. )
public static : disposePages ( a # -- )  over cell+ !  dup unlinkPage  freePage  mergeFreePages ;
( Disposes of allocated single page at address a. )
public static : disposePage ( a -- )  1 disposePages ;

( Allocates a contiguous area of # pages after the program break and returns its address a. )
: allocateNewArea ( # -- a )  ProgramBreak@ tuck swap pages + pgmbreak unless
  >errmsg 1 "Fatal error while updating program break: %s!"abort  then  ProgramBreak! ;
( Finds an area of # contiguous free pages, or allocates from the program break, and returns its
  address a. )
: allocateArea ( # -- a )
  PageDirectory@ begin 0≠?while  dup cell+ @ 3pick u≥if  swap reallocate exit  then
  @  repeat  drop allocateNewArea ;

( Removes one page from the first area in the page directory and returns its address a. )
: splitFreeRange ( -- a )  PageDirectory@ dup cell+ dup 1−! @ pages + ;
( Pops single page a' from page directory a. )
: popFreePage ( a -- a' )  PageDirectory  begin  over cell+ @ 1=if  over @ swap ! exit  then
  drop dup @ swap  over 0=until  2drop splitFreeRange ;
( Pops page a from the page directory, or returns 0 if the page directory is empty. )
: @freePage ( -- a|0 )  PageDirectory@ dupif  popFreePage  then ;
( If a free range of # pages is available in the page directory, returns its address a, else 0. )
: @freeRange ( # -- a|0 )  PageDirectory@ dupif PageDirectory  begin  over cell+ @ 3pick =if
  over @ swap ! exit  then  smash @ tuck 0=until  drop  then  2drop 0 ;

( Formats page a for small entries of size # and inserts it into the page array. )
: formatSmallPage ( # a -- a )
  dup clearPage  over toppage@ over Successor!  2dup Type!  0 over Flags!
  Page# #Used# − 8u* 2pick 8u* 1+ u÷ 7+ 8u÷ over Used#!
  Page# #Used# − over Used#@ − 2pick u÷ over Capacity!  dup Capacity@ over #Free!
  dup >page# rot toppage! ;
( Formats page a for large entries and inserts it into the page array. )
: formatLargePage ( a -- a )  dup clearPage  0 toppage@ over Successor!  1 over #Entries!
  Page# Entries# − 2− over Entries w!  dup >page# 0 toppage! ;
( Forats page area of u₁ pages for a huge entry of size u₂ and inserts it into the
  page array. )
: formatHugePage ( u₁ u₂ a -- a )  dup clearPage 255 toppage@ over Successor!  255 over Type!
  tuck #Pages!  tuck #Bytes!  dup >page# 255 toppage! ;

( Creates a page for small entries of size #, registers it in the page directory, and returns its
  address a. )
: @newSmallPage ( # -- a )  @freePage ?dupunless  allocatePage  then  formatSmallPage ;
( Creates a page for large entries, registers it in the page directory, and returns its address a. )
: @newLargePage ( -- a )  @freePage ?dupunless  allocatePage  then  formatLargePage ;
( Creates a range of # pages for huge entries, registers it in the page directory, and returns its
  address a. )
: @newHugePage ( u₁ u₂ -- a )  dup allocateArea  formatHugePage ;

( Scans the page array for a small page with free capacity for an entry of size #, and returns its
  address a, or 0 if no such page was found. )
: findSmallPage ( # -- a|0 )  PageArray@ over 4u* + d@ pages dupif
  begin  dup SmallPage full? while  Successor@ pages  0=?until  drop 0  then  then  nip ;
( Scans the page array for a large page with free capacity for an entry of size #, and returns its
  address a, or 0 if no such page was found. )
: findLargePage ( # -- a|0 )  PageArray@ d@ pages dupif
  begin  2dup LargePage full? while  Successor@ pages  0=?until  drop 0  then  then  nip ;

( Looks up the top page in the page array for entries of size #, returning its address a.  If the
  address is 0, creates a new page, inserts it into the page array, and returns its address a. )
: smallPage ( # -- a )  dup findSmallPage  ?dupunless  dup @newSmallPage  then  nip ;
( Looks up the top page in the page array for large entries, returning its address a.  If the
  address is 0, creates a new page, inserts it into the page array, and returns its address a. )
: largePage ( # -- a )  findLargePage ?dupunless  @newLargePage  then ;
( Returns address a of a huge page for with enough free space to accommodate an entry of size #. )
: hugePage ( # -- a )  dup HugePage Entry# + Page# →| >page# @freeRange
  ?dupif  formatHugePage  else  HugePage Entry# + Page# →| >page# @newHugePage  then ;

( Allocates a small entry (1 up to 255 bytes). )
: allocateSmall ( # -- a )
  debug? if  cr dup 1 "Allocating page for small entries of size %d"| debug.  then
  smallPage SmallPageEntry  debug? if  dup 1 ": @%016X."| debug.  then ;
( Allocates a large entry (255 up to 4080 bytes). )
: allocateLarge ( # -- a )
  debug? if  cr dup 1 "Allocating page for large entries of size %d"| debug.  then
  dup largePage LargePageEntry  debug? if  dup 1 ": @016X."| debug.  then ;
( Allocates a huge entry (bigger than 4080 bytes). )
: allocateHuge ( # -- a )
  debug? if  cr dup 1 "Allocating page array for  huge entry of size %d"| debug.  then
  dup hugePage HugePageEntry  debug? if  dup dup #Pages@ 2 ": %d pages @%016X."| debug.  then ;

( Allocates a memory chunk of size # and returns its address a. )
: _allocate ( # -- a )  1<?if  1 "Invalid allocation size: %d"| InvalidArgumentException raise  then
  MAX_SMALL u<?if  allocateSmall  else  MAX_LARGE u<?if allocateLarge else allocateHuge then  then ;
  fulfills allocate

( Disposes small entry @e of size # on page @p. )
: disposeSmall ( @e @p # -- )
  >r tuck dup -Page# and Used#@ + #Used# + − r> u÷  over #Used swap bit−! dup #Free 1w+!
  dup SmallPage empty? if  dup disposePage  then  drop ;
( Disposes large entry @e on page @p. )
: disposeLarge ( @e @p -- )  swap 2− 12bit−!  dup LargePage mergeFreeSlots
  dup LargePage empty? if  dup disposePage  then  drop ;
( Disposes huge entry @e on page @p. )
: disposeHuge ( @e @p -- )  nip dup #Pages@ disposePages ;

public static section --- API

--- Single Page Allocation ---

( see above: allocatePage, allocatePage0 )

--- Multi-Page Allocation ---

( Allocates # contiguous pages of memory and returns address a of the block. )
: allocatePages ( # -- a )
  0=?if  1 "Invalid amount of pages: %d"| InvalidArgumentException raise  then
  1=?if  drop allocatePage  else  allocateArea  then ;
( Allocates # contiguous pages of clear memory (all zeroes) and returns address a of the block. )
: allocatePages0 ( # -- a )  dup allocatePages  tuck swap pages cellu/ 0 fill ;

--- Entry Allocation ---

( Allocates a memory chunk of # bytes at address a and clears it to all 0. )
: allocate0 ( # -- a )  dup allocate tuck swap 0 cfill ;

--- Entry Deallocation ---

( Disposes of memory chunk at address a. )
: dispose ( a -- )  dup -Page# and dup Type@ 0=?if
  drop disposeLarge  else  255=?if  drop disposeHuge  else
  disposeSmall  then  then ;

--- Object Allocation ---

( Allocates a small object of size # and returns its address a. )
: allocSmallObj ( # -- a )  ... ;
( Allocates a large object of size # and returns its address a. )
: allocLargeObj ( # -- a )  ... ;
( Allocates a huge object of size # and returns its address a. )
: allocHugeObj ( # -- a )  ... ;
( Allocates an object instance of total size #, clears it to all 0, and returns its address a. )
: allocObj ( # -- a )  1<?if  1 "Invalid allocation size: %d"| InvalidArgumentException raise  then
  dup MAX_SMALL u<?if  allocSmallObj  else  4080<?if  allocLargeObj  else  allocHugeObj  then  then
  tuck -rot 0 cfill ;

( Returns the top memory address. )
: topmem ( -- a )  ProgramBreak@ ;
( Dumps the page array to the console. )
: pageArray. ( -- )  PageArray@ 1024 hexdump ;
( Prints the memory parameters. )
: mempara. ( -- )  ProgramBreak@ "Memtop" 2 "%n%:-20s: %016X"|.
  PageArray@ "@Page Array" 2 "%n%:-20s: %016X"|.
  PageDirectory@ "@Page Directory" 2 "%n%:-20s: %016X"|.
  ObjectSpace@ "@Object Space" 2 "%n%-:20s: %016X"|. ;

( Initializes the vocabulary from initialization structure at address @initstr when loading. )
private init : init ( @initstr -- @initstr )
  0 pgmbreak unless  >errmsg 1 "Fatal error while initializing Linux memory: %s!"abort  then
  ProgramBreak!  allocatePage0 PageArray!  allocatePage0 ObjectSpace! ProgramBreak@ InitialBreak! ;

vocabulary;
export LinuxMemory
