/**
  * Debug I/O
  *
  * Provides  #.s  required for  n.s  clauses.
  */

package force/debug/

import force/inout/DirectIO

vocabulary DebugIO

( On a new line, prints lbel n and the first 16 stack entries. )
: #.s ( n -- )  ecr '<' eemit depth dup e. ?dupif  ':' eemit  0 swap 20 min -do
  espace i 1− pick ehu.  loop−  then  depth 0 21 within unless  " ..." e$.  then  '>' eemit ;

vocabulary;
export DebugIO
