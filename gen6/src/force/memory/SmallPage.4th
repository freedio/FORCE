/**
  * Memory page for small objects (size from 1 to 512 bytes).
  */

package force/memory/

import force/memory/Page
import force/debug/Debug

Page structure SmallPage

uword variable Capacity           ( Total number of slots on page. )
uword variable #Free              ( Number of free slots. )
uword variable Used#              ( Size of the bit array in bytes. )
create #Used                      ( Bit array of used entries. )

private section --- Interna ----------------------

( Marks slot # on page @p occupied. )
: occupy ( # @p -- )  me #Used# + swap bit+! ;

public section --- API ---------------------------

( Returns entry base address @e0 on page @p. )
: Base ( @p -- @e0 )  my #Used# + my Used#@ + ;
( Occupies one entry on page @p and returns its address @e. )
: Entry ( @p -- @e )  my Base my #Free 1w-!@ dup me occupy my Type@ u*+ ;
( Checks if page @p has no free entry left. )
: full? ( @p -- ? )  my #Free@ 0= ;
( Checks if page @p has no allocated entry left. )
: empty? ( @p -- ? )  my #Free@ my Capacity@ = ;

structure;
export SmallPage
