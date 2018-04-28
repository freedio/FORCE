/**
  * Memory page for large objects (size from 511 to 4080 bytes).
  */

/*
 * A large page entry starts with a WORD size header of the following structure:
 * - 3 digits entry size
 * - 1 digit entry state
 *     bit 00: 1 = occupied, 0 = free
 *
 * The next entry starts at address a + <entry size> + 2.
 */

/*
 * - The strategy for finding a suitable free entry of size # is:
 *   Set "waste" to MAX.  Scan each unoccupied entry.  If the entry is at least # bytes long and
 *   produces less waste than "waste",
 *   mark it as candidate and set "waste" to the waste it produces.  If, at the end, there is a
 *   candidate, return it, otherwise throw an exception.
 * - Waste is calculated as:
 *   If the entry is larger than twice #, waste is 0.  Otherwise waste is the larger value of:
 *   - 2# - entry-size
 *   - entry-size - #
 */

package force/memory/

import force/memory/Page
import force/debug/Debug

Page structure LargePage

ubyte variable #Entries           ( Number of entries on page. )
create Entries                    ( Start of first entry. )

private static section --- Interna ----------------------

( Removes the flags from length u, giving u'. )
: unflag ( u -- u' )  4095and ;

( Computes waste u2 of entry with size # with respect to free entry with size u1. )
: >waste ( u1 # -- u2 )  2dup 2u* u<if  2drop 0  else  2dup 2u* r− -rot − max  then ;
( Splits entry @e into two, an occupied entry of size # at @e, and an unoccupied entry of the
  remaining size immediately following it. )
: splitEntry ( # @e -- @e )  dup w@ unflag  2pick − 2− >r 2dup 2+ + r> swap w!
  swap 12bit+ over w! ;

public dynamic section --- API ---------------------------

( Checks if the page has a free entry with at least size #. )
: hasFreeEntry? ( # @p -- ? )  my Entries  my #Entries@ 0 do  12bit@?unless  dup w@ unflag
  2pick u≥if  2drop true exitloop  then  then  dup w@ unflag 2+ +  loop  2drop false ;
( Occupies entry with size #, or splits it off a larger free area, and returns its address @e. )
: Entry ( # @p -- @e|0 )  0 -1 1u>> my Entries my #Entries@ 0 do  12bit@?unless
  dup w@ unflag  dup 5pick u>if  4pick >waste 2pick u<?if
  rot drop swap  rot drop tuck then  then  else  dup w@ unflag  2+ + then  loop  2drop
  0=?unless  tuck splitEntry  my #Entries 1c+!  then  nip 2+ ;
( Checks if the page cannot make a free slot for an entry of size #. )
: full? ( # @p -- ? )  this hasFreeEntry? not ;
( Checks if the page has one free entry occupying all the space. )
: empty? ( @p -- ? )  my #Entries@ 1= ;
( Merges all mergable free slots on page @p. )
: mergeFreeSlots ( @p -- )  my Entries  my #Entries@ 1− 0 do  12bit@?if  dup w@ unflag 2+ +  else
  dup w@ unflag 2+ over + 12bit@?if  nip  else  w@ 2+ over w+!  my #Entries 1c-!  then  then  loop  drop ;

structure;
export LargePage
