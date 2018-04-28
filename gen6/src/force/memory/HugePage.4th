/**
  * Memory page for huge objects (size > 4080 bytes).
  */

package force/memory/

import force/memory/Page

Page structure HugePage

 uword variable #Pages            ( Number of pages in array. )
udword variable #Bytes            ( Number of bytes in entry. )
create Entry                      ( Start of entry. )

private section --- Interna ----------------------

public section --- API ---------------------------

structure;
export HugePage
