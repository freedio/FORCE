/**
  * Memory page for small objects (size from 1 to 250 bytes).
  */

package force/memory/

import force/memory/Page

Page structure SmallPage

uword variable Capacity           ( Total numbr of slots on page. )
uword variable #Free              ( Number of free slots. )
uword variable Used#              ( Size of the bit array in bytes. )
create #Used                      ( Bit array of used entries. )

( Returns entry base address @e0 on page @p. )
: Base ( @p -- @e0 )  dup #Used + swap Used#@ + ;
( Occupies one entry on page @p and returns its address @e. )
: Entry ( @p -- @e )  dup Base over #Free 1w-!@ rot Type@ u*+ ;

structure;
export SmallPage
