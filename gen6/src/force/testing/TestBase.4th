/**
  * Test methods and environment.
  */

package force/testing/

import force/lang/Forth
import force/string/Format
import force/inout/DirectIO
import my/OS

vocabulary TestBase

private static section --- interna ------------------------

 uword variable successes
 uword variable failures

public static section --- API ----------------------------

( Compares actual short string a$ against expectation e$. )
: expect$ ( a$ e$ -- )  2dup $= unless
  ecr 2 "Expected «%s», but got «%s»!"|!  failures 1w+!  else  2drop  successes 1w+!  then ;
( Prints a resumee of failures and successes. )
: resumee. ( -- )
  ecr failures@ successes@ 2 "%5d test%<p successful, %5d failure%<p."|
  failures@ if  !$.  else  $..  then ;
( Terminates the test suite with exit code 0 if successful, otherwise exit code 1. )
: endTest ( -- )  failures@ 1 min terminate ;

vocabulary;
export TestBase
