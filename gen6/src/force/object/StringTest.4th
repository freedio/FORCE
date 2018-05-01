/**
  * Tests the String class.
  */

package force/object/

import force/object/String
import force/testing/TestBase
import force/debug/Debug
import my/Memory

vocabulary StringTest

: test0 ( -- )
  "Hello, World" String new Length 12 expect ;

vocabulary;
export StringTest
