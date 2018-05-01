package force/memory/trouble/

import force/lang/Forth
import force/exception/Exception

Exception class NoSuitableEntryFoundException

cell variable Page                ( The page on which no entry was found. )

( Constructor of class NoSuitablEntryFoundException )
: construct ( Page:page -- )  superconstruct  my Page! ;

class;
export NoSuitableEntryFoundException
