/**
  * Memory page for large objects (size from 512 to 4080 bytes).
  */

package force/memory/

import force/memory/Page

Page structure LargePage

ubyte variable Free               ( Bit array of free entries 0..7. )
create Entries                    ( Start of first entry. )

structure;
export LargePage
