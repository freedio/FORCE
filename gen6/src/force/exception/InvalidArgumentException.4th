package force/exception/

import force/lang/Forth
import force/exception/Exception
import force/object/String

Exception class InvalidArgumentException

public section

cell variable Message           ( TODO belongs into a superclass )

( Constructor of class TypeCastException. )
: construct ( String:message -- )  superconstruct  my Message! ;

class;
export InvalidArgumentException
