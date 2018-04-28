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

( On a new line, prints label n and the first 16 stack entries. )
: #.s ( n -- )  ecr e. espace '<' eemit depth  dup e.  ?dupif  ':' eemit  0 swap 20 min −do
  espace i 1− pick ehu.  loop−  then  depth 0 21 within unless  " ..." $..  then  '>' eemit espace ;
( Prints the stack layout. )
: .s ( -- )  cr '<' emit  depth  dup .  ?dupif  ':' emit  0 swap 20 min -do
  space i 1- pick hu.  loop−  then  depth 0 21 within unless  " ..." $.  then  '>' emit space ;
( Aborts with a message "not implemented". )
: ... ( -- )  ecr "Fatal error: Ran into unimplemented code!"!  abort ;

: addr. ( a -- )  cell 2u* #hu. ;
( Dumps one line with # bytes of a hex dump at address a. )
: hexline. ( a # -- )
  cr  over addr.  3 spaces  2dup 0 do  dup c@ 2 #hu. $20 i 7= 13and + emit  1+ loop  drop
  3 spaces 0 do  dup c@ dup $20 $80 within unless  drop '.'  then  emit  1+ loop  drop ;
( Dumps # bytes at address a as hex bytes and characters. )
: hexdump ( a # -- )  begin 0>?while  2dup 16 min hexline.  16+>  repeat  2drop ;

vocabulary;
export Debug
