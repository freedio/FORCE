/**
  * A heap structure is an area of memory that grows by pages of 4096 bytes on demand.

  * The operation of adding entries to a heap is often referred to as "punching", like in the olden
  * days when characters were punched on a card, and the FORTH idiom is the comma: ‹,› punches a
  * cell, ‹c,› punches a character, a.s.o.  To create a sufficiently large area for u bytes, the
  * FORTH idiom is ‹u allot› or ‹u 0allot› (which also clears the area to zeroes).

  * Heaps are always contiguous.  If the heap grows beyond its current size, it will be resized,
  * with the effect that its base address may change, which affects all pointers to structures into
  * the heap.  This effect can be mitigated in three ways: (1) relocation, (2) offsets (relative
  * address), or (3) heap relative addressing — all of which are concepts beyond this introduction.

  */

vocabulary Heap
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Memory.voc"
  requires" LogLevel.voc"

variable _@HEAPS                  ( Address of the heap array. )
1024 constant #HEAPS              ( Capacity of the heap array. )
-1 =variable CURRENT-HEAP         ( The currently selected heap, or -1 if none. )

=== Heap Structure ===

0000  dup constant HEAP.ADDR      ( Current address of the heap )
cell+ dup constant HEAP.SIZE      ( Current size or capacity, a mulitple of PAGE# )
cell+ dup constant HEAP.LENG      ( Current length = amount of allotted bytes )
cell+ dup constant HEAP.FLAG      ( Flags )
cell+ constant HEAP#

( Flags: )
0 constant HEAP_MOVED             ( Heap has been moved since last check )

( Returns address @h[] of the heap array. )
: heaps@ ( -- @h[] )
  _@HEAPS @ ?dupunless-  HEAP# #HEAPS u* PAGE# >| PAGE# u/ allocPages dup _@HEAPS !  then ;

: heap.addr ( @h -- @h.@addr )  HEAP.ADDR + ;
: heap.size ( @h -- @h.@size )  HEAP.SIZE + ;
: heap.length ( @h -- @h.@length )  HEAP.LENG + ;
: heap.flags ( @h -- @h.@flags )  HEAP.FLAG + ;

    ( Initializes the heap to one page if it's not yet initialized. )
    : ?heap.init ( @h -- @h )  dup heap.addr @ unless
      1 allocPages over heap.addr !  PAGE# over heap.size !  then ;

: heap.addr@ ( @h -- @h.addr )  ?heap.init  heap.addr @ ;
: heap.size@ ( @h -- @h.size )  heap.size @ ;
: heap.length@ ( @h -- @h.length )  heap.length @ ;
: heap.flags@ ( @h -- @h.flags )  heap.flags @ ;
: heap.addr! ( a @h -- )  heap.addr ! ;
: heap.size! ( u @h -- )  heap.size ! ;
: heap.length! ( u @h -- )  heap.length ! ;

    ( Resizes heap @h so that at least u additional bytes fit in. )
    : resizeHeap ( @h u -- )  over heap.size@ + PAGE# >| dup 2pick heap.size!  over heap.addr@ swap
      PAGE# u/ dup 1- swap resize  over heap.addr!  heap.flags HEAP_MOVED bit+! ;

: heap.length+! ( u @h -- )
  tuck heap.length +!  dup heap.length@ over heap.size@ - 0≥?if  resizeHeap  else  2drop  then ;

=== Instance Management ===

--- Constructor ---

( Allocates a heap instance and stores its address at @h. )
: _createHeap ( @h -- )  HEAP# allocate swap ! ;
( Creates a heap instance and returns its instance number h#. )
: createHeap ( -- h# )  heaps@ dup #HEAPS 0 find ?dupunless-
    cr "Error: Out of heap space!".. abort  then
  1- tuck cells+ _createHeap
  debug? if  dup cr 1 "D: Heap %d created."|log  then ;

--- Validation Operations ---

( Validates heap index h#. )
: !h# ( h# -- h# )  dup 0 #HEAPS between unless-
  ecr 1 "Error: Invalid heap index %d!"|.. abort  then ;
( Asserts that #h is an allocated heap. )
: !!h# ( v@ -- v# )  !h#  heaps@ over cells+ unless-
  ecr 1 "Error: Heap %d not allocated!"|.. abort  then ;

--- Query and Update Operations ---

( Returns heap h#'s structure @h.  Aborts if the specified heap does not exist. )
: heap[] ( h# -- @h )  !h#  heaps@ over cells+ @ ?dupunless-
    ecr 1 "Error: Heap %d not allocated!"|.. abort  then  nip ;
( Returns the current heap number.  Aborts if no heap has been selected. )
: selectedHeap ( -- # )  CURRENT-HEAP @ dup 0 #HEAPS between unless-
    drop "Error: No heap selected!".. abort  then ;
( Returns the structure of the current heap.  Aborts if the specified heap does not exist. )
: selectedHeap[] ( -- @h )  selectedHeap heap[] ;
( Makes heap #h the current heap for punching and allocation operations. )
: selectHeap ( #h -- )  debug? if  cr dup 1 "D: Selecting heap #%d."|log  then
  !!h# CURRENT-HEAP ! ;

--- Accessors ---

( Returns address a of heap #h. )
: @heap ( #h -- a )  heap[] heap.addr dup @ ?dupunless  1 allocPages dup 2pick !  then  nip ;
( Returns length u of heap #h. )
: heap% ( #h -- u )  heap[] heap.length@ ;
( Returns size u of heap #h. )
: heap# ( #h -- u )  heap[] heap.size@ ;
( Returns address a and length u of heap #h. )
: @heap% ( #h -- a u )  dup @heap swap heap% ;

=== Heap Operations ===

( Makes sure that at least u bytes remain in the current heap segment. )
: assertHeapSpace ( u -- )  selectedHeap[] dup heap.size@ over heap.length@ − 2pick < if
  2dup swap resizeHeap  then  2drop ;
( Allots # bytes of heap space on the current heap. )
: allot ( # -- )  selectedHeap[] heap.length+! ;
( Allots # bytes of heap space on the current heap and sets the area to 0. )
: 0allot ( # -- )  selectedHeap[] dup heap.length@ heap.length+! ;
( Allots # bytes of heap space on the current heap and returns the absolute address of the area. )
: allot@ ( # -- a )  selectedHeap[] dup heap.length@ rot  allot  swap heap.addr@ + ;
( Punches unsigned byte c into the current heap. )
: c, ( c -- )  1 allot@  over $FF andn if
  ecr 1 "Cannot punch %XH into a byte cell!"|.. abort  then  c! ;
( Punches unsigned word w into the current heap. )
: w, ( w -- )  2 allot@  over $FFFF andn if
  ecr 1 "Cannot punch %XH into a word cell!"|.. abort  then  w! ;
( Punches unsigned double-word d into the current heap. )
: d, ( d -- )  4 allot@  over $FFFFFFFF andn if
  ecr 1 "Cannot punch %XH into a dword cell!"|.. abort  then  d! ;
( Punches unsigned quad-word q into the current heap. )
: q, ( q -- )  8 allot@  q! ;  alias ,
( Punches ten-byte t into the current heap. )
: t, ( q -- )  10 allot@  q!++ w! ;
( Punches unsigned oct-word o into the current heap. )
: o, ( o₁ o₂ -- )  swap 16 allot@ q!++ q! ;  alias 2,
( Punches unsigned 3-byte value into the current heap. )
: u3, ( 3c -- )  dup $FFFF and w, 16u>> c, ;
( Punches counted string a$ into the current heap. )
: $, ( a$ -- )  dup c@ 1+ allot@  swap dup c@ 1+ slide cmove ;

vocabulary;
