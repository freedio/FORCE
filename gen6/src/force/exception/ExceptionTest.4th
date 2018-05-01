/**
  * Test for exception handling.
  */

package force/exception/

import force/lang/Forth
import force/exception/InvalidArgumentException
import my/Memory

vocabulary ExceptionTest

: test0 ( -- )
  "This is right!" InvalidArgumentException new throw ;

vocabulary;
export ExceptionTest
