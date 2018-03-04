/**
  * Base functionality for vocabulary tests.
  */

import Forth

vocabulary TestBase

public static section

variable SourceColumn             ( Address of the source column variable )
variable SourceLine               ( Address of the source line variable )

: sourceColumn@ ( -- u )  SourceColumn @ @ ;
: sourceLine@ ( -- u )  SourceLine @ @ ;

( Checks if actual value a equals expected value e.  If not, prints a suitable error message. )
: expect ( a e -- )  2dup =unlessever
  sourceColumn@ sourceLine@ 4 "Test Error at %d.%d: Expected %d, but got %d!"|.  else  2drop  then ;


private init : init ( @initstr -- @initstr )
  ( dup 3cells+ dup @ SourceLine ! cell+ @ SourceColumn ! ) ;

vocabulary;
export TestBase
