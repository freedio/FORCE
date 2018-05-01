/**
  * Standard String with udword length and Character elements.
  */

package force/object/

import force/lang/Forth
import force/object/Object
import force/debug/Debug

Object class String

  cell variable Bytes             ( Byte buffer. )
udword variable Len               ( Length of the String. )

public section --- API ------------------------------

: construct ( a$ -- )  superconstruct  count my Len!  my Bytes!  me ;

( Returns the length of the string. )
: Length ( -- # )  my Len@ ;

class;
export String
