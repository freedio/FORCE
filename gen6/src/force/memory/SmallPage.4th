/**
  * Memory page for small objects (size from 1 to 250 bytes).
  */

package force/memory/

import force/memory/Page

MemoryPage structure SmallPage

uword variable Capacity           ( Total numbr of slots on page )
uword variable #Free              ( Number of free slots )
uword variable Used#              ( Size of the bit array )
create #Used                      ( Bit array of used entries )

structure;
export SmallPage
