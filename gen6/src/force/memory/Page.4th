/**
  * Basic page structure of a memory page.
  */

package force/memory/

import force/lang/Forth
import force/structure/Fundamental

Fundamental structure Page

4096 constant Page#               ( Standard Page Size. )

udword variable Successor         ( Number of next memory page. )
 ubyte variable Type              ( Page type: 0=large, 511=huge, 1−511=small. )
 ubyte variable Flags             ( See flags below. )

( Page flag indices: )
00 constant %full                 ( set: Page is full. )

structure;
export Page
