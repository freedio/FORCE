/**
  * Simple I/O library.
  *
  * Description:
  * - This vocabulary uses direct OS input/output through system calls.
  * - It is a wrapper to shield from platform specifities.
  *
  * Intended use:
  * - where higher level input/output is not yet available, at very low stages.
  * - debugIO uses this library.
  */

package force/inout/

import my/OS
import force/convert/UTF8

vocabulary DirectIO

private static section --- Internals

create Buffer  256 allot          ( Buffer for various outputs. )
create @Buffer                    ( End of buffer address. )

( Converts unsigned number u to its radix r string equivalent in a transient buffer u$. )
: #u>$ ( u r -- u$ )  >r @Buffer 0 rot begin  r@ ÷% ( a # u' c )  dup 9u> 7and +  '0'+
  4roll --c! rot 1+ rot 0=until  swap --c!  r> drop ;
: #n>$ ( n r -- n$ )  over abs swap #u>$ swap 0<if  '−' over c@! 1+ swap 1- tuck c!  then ;

( Converts unsigned number u to its decimal string equivalent u$ in a transient buffer. )
: u>$ ( u -- u$ )  10 #u>$ ;
( Converts unsigned number u to its hexadecimal string equivalent u$ in a transient buffer. )
: hu>$ ( u -- u$ )  16 #u>$ ;
( Converts signed number n to its decimal string equivalent n$ in a transient buffer. )
: n>$ ( n -- n$ )  10 #n>$ ;
( Converts signed number n to its hexadecimal string equivalent n$ in a transient buffer. )
: hn>$ ( n -- n$ )  16 #n>$ ;

public static section --- API

( Writes short string a$ to the standard output channel. )
: $. ( a$ -- )  out. ;
( Writes short string a$ to the standard error channel. )
: $.. ( a$ -- )  err. ;
( Emits unicode character uc as UTF-8 to standard output. )
: emit ( uc -- )  Buffer tuck dup 1c! 1+ c! ( 0c! uc>utf8$ ) $. ;
( Emits unicode character uc as UTF-8 to standard error. )
: eemit ( uc -- )  Buffer tuck dup 1c! 1+ c! ( 0c! uc>utf8$ ) $.. ;
( Advances the cursor to the beginning of next line by sending a NEWLINE to stdout. )
: cr ( -- )  10 emit ;
( Advances the cursor to the beginning of next line by sending a NEWLINE to stderr. )
: ecr ( -- )  10 eemit ;
( Advances the cursor by sending a BLANK to stdout. )
: space ( -- )  bl emit ;
( Advances the cursor by sending a BLANK to stderr. )
: espace ( -- )  bl eemit ;
( Prints number n to standard output. )
: n. ( n -- )  n>$ $. ;
( Prints number n to standard error. )
: e. ( n -- )  n>$ $.. ;
( Prints unsigned number u to standard output. )
: u. ( n -- )  u>$ $. ;
( Prints unsigned number u to standard error. )
: eu. ( n -- )  u>$ $.. ;
( Prints unsigned number u to standard output as hex nmber. )
: hu. ( n -- )  hu>$ $. ;
( Prints unsigned number u to standard error as hex number. )
: ehu. ( n -- )  hu>$ $.. ;

( Prints string a$ as an error message (highlighted) to stderr. )
: !$. ( a$ -- )  "\e[1m" $..  $..  "\e[22m" $.. ;

vocabulary;
export DirectIO
