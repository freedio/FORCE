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

( Returns entry base address @e0 on page @p. )
: Base ( @p -- @e0 )  4002.s my #Used# + 4003.s my Used#@ + ;
( Occupies one entry on page @p and returns its address @e. )
: Entry ( @p -- @e )  4001.s my Base 4010.s my 4015.s #Free 4020.s 1w-!@ 4030.s my Type@ 4040.s u*+ 4050.s ;

structure;
export SmallPage
