vocabulary Memory
  requires" FORTH.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" OS.voc"

/*
 * The page array contains the front page address for all pages according to the size of their
 * elements, where the entry size is the index into the page array.  Since elements smaller than
 * cell size are impossible due to the leading class address of 1 cell, and the minimum supported
 * architecture is 32 bits, pages 0 to 4 would never be used.
 * Because there are entries bigger than 255 are common, these first 5 pages are used for these
 * bigger entries:
 * page 0: entries of size 256
 * page 1: large entries of size 257 up to and including 4080 bytes.
 * page 2: huge entries (>4080 bytes) spanning multiple pages.
 * page 3: a bit array of roughly 32000 bits.
 * page 4: unused as yet.
 *

 *
 * General page layout:
 * cell     NEXT                              ( Pointer to next page of same type. )
 * byte     TYPE                              ( Page type. )
 * byte     FLAGS                             ( Status flags. )

 * Layout of a small page:
 * word     CAPACITY                          ( Total number of slots on page. )
 * word     #FREE                             ( Number of free slots. )
 * word     USED#                             ( Size in bytes of the bit array of used entries. )
 * bit[]    USED                              ( Bit array of used entries. )
 * entry[]  ENTRIES                           ( The entries. )

 * Layout of a large page:
 * bit[16]  FREE                              ( Bit array of free entries. Note ¹ )
 * entry[]  ENTRIES                           ( The entries, with a leading length word each. )

 * Layout of a huge page:
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
 * ¹ this is under the reasonable assumption of a page size of 4096 — needs reprogramming if this
 *   assumption changes!
 */

variable PGM-BRK
variable OBJECT-SPACE
4096 constant PAGE#
variable PAGE-ARRAY

: .next ;
: .type  cell+ ;
: .flags [[ 1 cell+ ]]#+ ;
: .capacity [[ 2 cell+ ]]#+ ;  alias .free  alias .#pages
: .#free [[ 4 cell+ ]]#+ ;  alias .#bytes  alias .entries ( of large page )
: .used# [[ 6 cell+ ]]#+ ;
: .used [[ 8 cell+ ]]#+ ;

=== Initialization ===

: allocpg ( -- a )  PGM-BRK dup @ dup PAGE# + pgmbrk rot ! ;
: setup ( -- )  0 pgmbrk dup PGM-BRK ! OBJECT-SPACE !  allocpg dup PAGE# cell/ 0 fill PAGE-ARRAY ! ;
: pgmbrk@ ( -- a )  PGM-BRK dup @ unlessever  setup  then ;

=== Memory Management ===

:( Allocates a contiguous array of u pages of memory and returns its address a. )
: allocPages ( u -- a )  PAGE# u* pgmbrk@ tuck @ + pgmbrk  swap xchg drop ;
:( Resizes the area at address a from u1 to u2 consecutive pages at a'.  If no other object is
   allocated above a, the page break is simply extended, and a' = a, otherwise a new area of the
   requested size is allocated, the previous contents of the page copied to the new area, and
   finally the old area freed. TODO at the moment, we always allocate a new area, until memory management is
   mature. )
: resize ( a u1 u2 -- a' )  allocPages dup >r swap PAGE# u* cmove  r> ;

=== Page Operations ===

:( Returns address a of the page array. )
: pages@ ( -- a )  PAGE-ARRAY @ ?dupunless  1 allocPages dup PAGE-ARRAY !  then ;
:( Returns page type t for entry size u. )
: pg# ( u -- t )  dup 256u<if  exit  then  dup 256=if  drop 0 exit  then  4081u< 2+ ;
:( Returns front page slot address a for pages of type t. )
: page[] ( t -- a )  cells pages@ + ;
:( Returns successor @p2 of page @p1, or nil if the page has no successor. )
: next@ ( @p1 -- @p2|nil )  @ ;
:( Returns type t of page at address @p. )
: pagetype@ ( @p -- t )  .type c@ ;
:( Returns address of flags on page @p. )
: flags ( @p -- a )  .flags ;
:( Returns flags of page @p1. )
: flags@ ( @p1 -- @p2|nil )  flags c@ ;
:( Checks if page @p is the front page. )
: top? ( @p -- ? )  dup pagetype@ page[] @ = ;
:( Checks if page @p has not enough rest capacity to allocate a slot of size u. )
: full? ( @p -- ? )  flags 0bit@ ;
:( Marks page @p full. )
: full! ( @p -- )  flags 0bit+! ;
:( Returns the bit map of free slots, or 0 if no slot is free. )
: free@ ( @p -- #|0 )  .free w@ ;
:( Determines quality u of a free slot with size u2 with respect to a request to allocate an entry
   of size u1:  Returns 0 if the slot is too small.  If the slot is at least twice as big as the
   entry to allocate, returns 1 [maximum quality].  Otherwise returns the lesser value of [a] the
   number of bytes remaining in the free slot after allocating taken twice to double its weight,
   [b] the absolute difference between the number of remaining bytes and the slot size.
   The quality is the better the smaller the resulting value is. )
: quality ( u1 u2 -- u|0 )  2dup u>if  2drop 0 exit  then  over 2* over u≤if  2drop 1 exit  then
  2dup r− 2* ( u1 u2 Δ₁ ) rot 2* rot − ( Δ₁ Δ₂ ) umin ;
:( Returns address @e and index # of the best-fitting free slot on large page @p from which to cut
   off an entry of size u, or @e=0 and #=-1 if no such slot could be found. )
: freeSlot@ ( u @p -- # @e|0 )  dup free@ ?dupunless  2drop -1 0 exit  then
  -1 >r 0 >r  -1 >r  ( u @p %free ) 1 rot .entries ( u %free #bit @e ) begin
    -rot ( u @e %free #bit )  2dup and if  2over w@ quality ?dupif
      r@ over u>if  r> r> r> 3drop ( u @e %free #bit q ) over 1<- >r 3pick >r >r  then  then  then
    ( u @e %free #bit' ) 1u<< 2swap w@++ + 2swap ( u @e' %free #bit' ) 2dup u< until
  r> drop r> 5 -roll 4drop r> swap ;
:( Checks if page @p cannot allocate a slot of size u. )
: exhausted? ( u @p -- ? )  dup pagetype@ 1=if  freeSlot@ nip 0=  else  nip full?  then ;
:( Moves the page at address @p to the top, unless it already is the front page. )
: >top ( @p -- @p )
  dup top? unless  dup dup pagetype@ page[] xchg @ xchg over if  @ !  else  2drop  then  then ;
:( Formats page at address a for small entries of size u. )
: formatSmallPage ( u a -- a )  tuck  0!++  over FFH and !++c  0c!++
  PAGE# 0 .used - 8u* rot 8u* 1+ u/ ( #entries )  tuck !++w  over !++w
  swap 7+ 8u/ ( size of bit array in bytes ) swap w! ;
:( Formats page at address a for large entries. )
: formatLargePage ( a -- a )  dup  0!++  1c!++  0c!++  1w!++  PAGE# 0 .entries 2+ - swap w! ;
:( Formats page[s] at address a for huge entries. )
: formatHugePage ( u a -- a )  dup  0!++  2c!++  0c!++  rot tuck PAGE# 1- + PAGE# u/ !++w  d! ;
:( Formats the page[s] at address a for entries of size u. )
: formatPage ( u a -- a )  swap dup 5u< 5and + ( let minimum slot size be 5 )
  dup 257u<if  swap formatSmallPage exit  then
  dup 4081u<if  drop formatLargePage exit  then
  swap formatHugePage ;
:( Creates and formats a page for entries of size u and returns its address a. )
: createPage ( u -- a )  dup PAGE# 1- + PAGE# u/ allocPages  dup PAGE# 0 cfill  formatPage ;
:( Returns front page @p for entries of size u, creating it if necessary. )
: frontPage ( u -- @p )
  dup pg# page[] dup @ unlessever  swap createPage tuck swap !  else  nip @  then ;
:( Finds a page for an entry of size u with at least one free entry, or creates one, and returns
   its address @p. )
: findPage ( u -- @p )  dup frontPage begin  2dup exhausted? over next@ and while  next@  repeat
  2dup exhausted? ifever  smash createPage  then  >top nip ;

=== Entry Operations ===

:( Finds and allots small slot a for an entry of size u on page @p. )
: occupySmallSlot ( u @p -- a )  .#free  dup 1w-!  w@++ unless  dup cell- 6- full!  then
  w@++ ( u a e# ) 2dup 0<-@ ( u a #e #b )  2pick over bit+! -rot ( u #b a @e ) + -rot u* + ;
:( Occupies the entire unused slot @e with index # in large page @p for entry of size u and returns
   entry address a. )
: takeSlot ( u @p # @e -- a )
  2+ swap 2pick .free swap bit-! ( u @p @e ) over .free w@ 0=if  over full!  then  2nip ;
:( Splits empty slot @e with index # in large page @p into 2 slots, 1 empty and one occupied for an
   entry of size u, returning the address of the new occupied entry. )
: splitSlot ( u @p # @e -- a )  3pick 2+ over w-!  w@++ + 4 roll !++w -rot ( @e' @p # )
  swap .free swap  1+ 1 swap u<< 1- ( @e' @f %m )  over w@ over and ( @e' @f %m vl )
  2pick w@ rot andn ( @e' @f vl vh ) 1u<< or ( @e' @f v ) swap w! ;
:( Finds and allots large slot a for an entry of size u on page @p, or 0 if no slot was found
   [which should not happen if the method was called from allocEntry:occupySlot]. )
: occupyLargeSlot ( u @p -- a|0 )  2dup freeSlot@ ?dupif  ( u @p # @e )
  dup w@ ( u @p # @e u ) 4pick - 259<if  takeSlot  else  splitSlot  then  else  2drop 0  then ;
:( Finds and allots huge slot a for an entry of size u on page @p. )
: occupyHugeSlot ( u @p -- a )  nip dup full! cell+ 8+ ;
:( Finds a slot for an entry of size u on page @p and occupies it. )
: occupySlot ( u @p -- a )  dup pagetype@
  dup 1=if  drop occupyLargeSlot exit  then  2=if  occupyHugeSlot  else  occupySmallSlot  then ;
:( Allocates an entry of size u and returns its address a )
: allocate ( u -- a )  dup findPage occupySlot ;
: 0allocate ( u -- a )  dup allocate tuck swap 0 cfill ;
:( Frees slot with address a. )
: free ( a -- )
  ( TODO: implement ) drop ;

=== Test Code ===

create Page8$  ," Page layout for 8 bytes: "
create PageArray$  ," Page Array: "
create Entry#$  ," Entry #"
create CS$  ," : "

:: memory ( -- )  INIT,  setup
(  280 findPage  40H hexdump
  280 allocEntry  $12345678!  cr dup a. 280 findPage  200H hexdump
  280 allocEntry  $12345678!  cr dup a. 280 findPage  200H hexdump
  cr .s bye )
(  cr PageArray$ >stdout  PAGE-ARRAY @ a.
  PAGE-ARRAY @ 256 0 do  i 8umod unlessever  cr  then  ++@ a. 4 spaces  loop  drop
  8 findPage  40H hexdump
  8 findPage  40H hexdump
  cr PageArray$ >stdout
  PAGE-ARRAY @ 256 0 do  i 8umod unlessever  cr  then  ++@ a. 4 spaces  loop  drop )
(  101 1 do  i 10* allocEntry  cr Entry#$ >stdout i .  CS$ >stdout dup a. i dup * swap !  loop
  280 findPage  begin  dup  PAGE# cr hexdump  @ dup 0= until  drop )
  101 1 do  i 8000 allocate  cr Entry#$ >stdout i .  CS$ >stdout dup a. i dup * swap !  loop
  2 page[] @ begin  dup  PAGE# cr hexdump  @ dup 0= until  drop
  cr .s bye ;; ( >main )

vocabulary;
