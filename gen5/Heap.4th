/*
  A heap provides the framework for a heap space, keeping track of its current address, size and
  length, while the heap itself may grow, shrink, change its address a.s.o. */

vocabulary Heap
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Memory.voc"

=== Heap List Management ===

variable @HEAPS                   ( Address of the heap list )
variable HEAPS#                   ( Length of the heap list )
variable HEAPS##                  ( Size of the heap list )

( Returns address a of the heap list. )
: heaps ( -- a )
  @HEAPS dup @ unlessever  1 allocPages over !  PAGE# HEAPS## !  cell HEAPS# !  then  @ ;
( Extends the heap list by another page.)
: extendHeapList ( -- )  heaps HEAPS## PAGE# over +! @ PAGE# u/ dup 1- swap resize @HEAPS ! ;
( Makes sure the heap list is big enough to take another heap address. )
: ?extendHeapList ( -- )  heaps drop  HEAPS# @ cell+ HEAPS## @ u>if  extendHeapList  then ;
( Adds heap @h to the heap list and returns its index. )
: addHeap ( @h -- #h )  ?extendHeapList  heaps HEAPS# dup @ swap cell+! tuck + slide ! cellu/ ;
( Returns the address of heap #h. )
: #heap@ ( #h -- @h )  heaps swap cells+ @ ;

=== Current Heap Management ===

-1 =variable #CURRENTHEAP         ( Index of the current heap )

( Returns index # of the current heap. )
: currentHeap# ( -- # )  #CURRENTHEAP @ -1=?ifever  "No current heap appointed!"abort  then ;
( Returns address @h of the current heap. )
: currentHeap@ ( -- @h )  heaps currentHeap# cells+ @ ;
( Sets index # of current heap. )
: currentHeap! ( # -- ) #CURRENTHEAP ! ;

=== Heap Structure ===

0000  dup constant HEAP.ADDRESS   ( Address of the extensible heap space¹ )
cell+ dup constant HEAP.SIZE      ( Size of the allocated heap space )
cell+ dup constant HEAP.LENGTH    ( Length of the heap space in use )
cell+ constant HEAP#              ( Size of the heap structure )

/* ¹ the least significant bit of HEAP.ADDRESS is "abused" to indicate a table relocation that
     occurred since the last call to tableMoved? */

( Initializes heap @h to one page of memory. )
: initHeap ( @h -- @h )  1 allocPages over HEAP.ADDRESS + !  PAGE# over HEAP.SIZE + ! ;

=== Constructors ===

( Creates a heap, registers it in the heap list and returns its index #h. )
: createHeap ( -- #h )  HEAP# 0allocate initHeap  addHeap ;
( If the cell at address a is NIL, creates a heap and saves its address at a. )
: ?heap ( a -- a )  dup @ unlessever  createHeap over !  then ;

=== Heap Maintenance ===

=== Accessors ===

( Returns address a of heap @h. )
: @heap@ ( @h -- a )  HEAP.ADDRESS + @ -2and ;
( Sets address of heap @h to a. )
: @heap! ( a @h -- )  HEAP.ADDRESS + ! ;
( Returns length u of heap @h. )
: @heap# ( @h -- u )  HEAP.LENGTH + @ ;
( Returns the capacity of heap @h. )
: @heap## ( @h -- u )  HEAP.SIZE + @ ;
( Returns address a and length u of heap @h. )
: @heap@# ( @h -- a u )  dup @heap@ swap @heap# ;
( Returns address a and capacity u of heap @h. )
: @heap@## ( @h -- a u )  dup @heap@ swap @heap## ;
( Allocates # bytes on heap @h. )
: @heap+! ( # @h -- )  HEAP.LENGTH + +! ;
( Sets the capacity of heap @h to # pages. )
: @heap++! ( @h # -- )  PAGE# u* swap HEAP.SIZE + ! ;

( Returns the address of heap #h. )
: heap@ ( #h -- a )  #heap@ @heap@ ;
( Returns length u of heap #h, i.e. the number of bytes already in use. )
: heap# ( #h -- u )  #heap@ @heap# ;
( Returns size u of heap #h, i,e. the current capacity in bytes. )
: heap## ( #h -- u )  #heap@ @heap## ;
( Returns address a and length u of heap #h. )
: heap@# ( #h -- a u )  #heap@ @heap@# ;
( Returns address a and size u of heap #h. )
: heap@## ( #h -- a u )  #heap@ @heap@## ;
( Adds # to the length of heap #h. )
: heap+! ( # #h -- )  #heap@ @heap+! ;
( Adds u bytes to the capacity of heap @h. )
: _extendHeap ( @h u -- )  over @heap## +  PAGE# 1− + PAGE# u/ 2dup @heap++!
  over @heap@ swap dup 1- swap resize 0bit+ swap @heap! ;
( Extends heap #h, if necessary, to accommodate # more bytes. )
: ?extendHeap ( # #h -- # #h )
  2dup #heap@ dup @heap# rot + swap @heap## − 0>if dup #heap@ PAGE# _extendHeap then ;
( Extends current heap, if necessary, to accommodate # more bytes. )
: ?extendCurrentHeap ( # -- )  currentHeap# ?extendHeap  2drop ;

=== Heap Addressing ===

( Returns address a of the end of the current heap. )
: here ( -- a )  currentHeap@ @heap@# + ;
( Returns length u of the current heap. )
: there ( -- u )  currentHeap@ @heap# ;

=== Heap Allocation and Punching ===

( Allots # bytes on heap #h and returns physical address a of the allotted area. )
: heapAllot@ ( # #h -- a )  ?extendHeap  dup heap@# + -rot heap+! ;
( Allots # bytes on heap #h. )
: heapAllot ( # #h -- )  heapAllot@ drop ;

( Allots # bytes on current heap and returns physical address a of the allotted area. )
: allot@ ( # -- a )  currentHeap# heapAllot@ ;
( Punches byte c onto current heap. )
: c, ( c -- )
  dup -128 256 within unless  dup 1 "WARNING: Punching %d into a byte slot!"|!  then  1 allot@ c! ;
( Punches word w onto current heap. )
: w, ( w -- )  dup -32768 65536 within unless
  dup 1 "WARNING: Punching %d into a word slot!"|!  then  2 allot@ w! ;
( Punches double-word d onto current heap. )
: d, ( d -- )  dup -2147483648 4294967296 within unless
  dup 1 "WARNING: Punching %d into a double-word slot!"|!  then  4 allot@ d! ;
( Punches uad-word q onto current heap. )
: q, ( q -- )  8 allot@ q! ;  alias ,
( Punches byte array with length # at address a onto current heap. )
: #, ( a # -- )  dup allot@ swap cmove ;
( Allocates # bytes and fills them with zeroes. )
: 0#, ( # -- )  dup allot@ swap 0 cfill ;
( Punches counted string a$ onto current heap. )
: $, ( a$ -- )  dup c@ 1+ #, ;
( Allots # bytes on current heap. )
: allot ( # -- )  allot@ drop ;
( Allots # bytes on current heap and clears the area to all zeroes. )
: allotz ( # -- )  dup allot@ swap 0 cfill ;

=== Heap State ===

( Checks if the address of heap #h has changed since the last time.  Resets the flag. )
: heapMoved? ( #h -- ? )  #heap@ HEAP.ADDRESS + 0bit−@ ;

vocabulary;
