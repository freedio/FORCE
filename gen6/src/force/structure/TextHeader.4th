/**
  * Text Segment Header structure.
  */

package force/structure/

import force/lang/Forth
import force/structure/Fundamental

Fundamental structure TextHeader

  cell variable Superclass        ( Superclass reference/address. )
udword variable >Module           ( Offset of module name in string segment. )
udword variable Instance#         ( Instance size. )
 uword variable #Words            ( Number of words in the vocabulary. )
 uword variable VocFlags          ( Vocabulary flags. )
create Contents                   ( Text Segment contents. )

structure;
export TextHeader
