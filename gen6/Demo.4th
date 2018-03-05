/**
  * Demo / Test class
  */

import Forth
import Object
( import Exceptions )

Object class Demo

( Object variable anObject )
byte variable singleByte

public section

( : demo1 ( this -- )  1 singleByte! try singleByte 1c+! catch  0 singleByte!  resume
  0 singleByte!  Object + ; )

( defer demo2

: demo3 demo2 ; )

: allocate ( # -- a ) ;

: demo4  Object new ;

public static section

class;
export Demo
