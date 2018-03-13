/**
  * Object representation of a short UTF-8 string with ubyte length.
  */

package force/object/

import force/lang/Forth
import force/object/Object

Object class ShortString

cell variable Address

public section --- API

: construct ( a$ -- )  superconstruct  my Address! ;

: formatString ( ... # -- ) ... ;

class;
export ShortString
