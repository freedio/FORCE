/**
  * Basic page structure of a memory page.
  */

import Forth
import Fundamental

Fundamental structure Page

cell variable Successor           ( Address of next memory page )
ubyte variable Type               ( )
ubyte variable Flags              ( )

00 constant %full                 ( )

structure;
export Page
