/**
  * Debugging tools
  *
  * Provides:
  * - #.s  required for  n.s  clauses.
  * - ...
  */

package force/debug/

import linux/system/Linux
import force/inout/DirectIO

vocabulary Debug

public static section --- API

( Terminates the program with exit code 1. )
: abort ( -- )  1 terminate ;

( On a new line, prints lbel n and the first 16 stack entries. )
: #.s ( n -- )  ecr '<' eemit depth dup e. ?dupif  ':' eemit  0 swap 20 min -do
  espace i 1− pick ehu.  loop−  then  depth 0 21 within unless  " ..." $..  then  '>' eemit ;
( Aborts with a message "not implemented". )
: ... ( -- )  ecr "Hit a piece of unimplemented code!"!  abort ;

( private init : init ( -- )  1000 #.s ; )

vocabulary;
export Debug
