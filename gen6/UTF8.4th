/**
  * Static library of UTF8 utilities.
  */

import Forth
import Heap

vocabulary UTF8

private static section --- Utils

public static section --- API

( Converts Unicode character uc to UTF8 string u$. )
: uc> ( uc -- u$ )  >utf8 usize dup 1+ allot 2dup c!++ 1+ #, ;

vocabulary;
export UTF8
