/**
  * Static library of UTF8 utilities.
  */

import Forth
import Memory

vocabulary UTF8

private static section --- Utils

public static section --- API

( Disposes of the allocated string u$. )
: dispose ( u$ -- )  deallocate ;
( Converts Unicode character uc to UTF8 string u$.  The string is allocated and must be disposed
  of when no longer used (method dispose in this vocabulary can be used for this). )
: uc>utf8 ( uc -- u$ )  128u<?if  8u<< 1or 2 allocate tuck w! exit  then
  100000B  0 -rot  begin  u>??while  over 63and 128or rot 8u<< or -rot  swap 6u>> swap  1u>>  repeat
  not and  255and swap 8u>> or  usize dup dup 1+ allocate dup >r  c!++ 0 do  c!++>  loop  drop r> ;

vocabulary;
export UTF8
