/**
  * Debugging tools
  *
  * Provides:
  * - #.s  required for  n.s  clauses.
  * - ...
  */

package force/debug/

import linux/Linux
import force/inout/DirectIO

vocabulary Debug

( Terminates the program with exit code 1. )
: abort ( -- )  1 terminate ;

( On a new line, prints lbel n and the first 16 stack entries. )
: #.s ( n -- )  ecr '<' eemit depth dup e. ?dupif  ':' eemit  0 swap 20 min -do
  espace i 1− pick ehu.  loop−  then  depth 0 21 within unless  " ..." e$.  then  '>' eemit ;
( Aborts with a message "not implemented". )
: ... ( -- )  ecr "Hit a piece of unimplemented code!"!  abort ;

vocabulary;
export Debug
