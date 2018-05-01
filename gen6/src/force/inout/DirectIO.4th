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
import force/lang/Xstack

vocabulary DirectIO

private static section --- Internals

create Buffer  256 allot          ( Buffer for various outputs. )
create @Buffer                    ( End of buffer address. )

( Converts unsigned number u to its radix r string equivalent in a transient buffer u$. )
: #U>$ ( u r -- u$ )  >r @Buffer 0 rot
  begin  r@ u÷% dup 9u> 7and +  '0'+ 4roll --c! rot 1+ rot 0=?until  drop swap --c!  r> drop ;
( Converts unsigned number u to its radix r string equivalent in a transient buffer u$. )
: #u>$ ( u r -- u$ )  >r @Buffer 0 rot
  begin  r@ u÷% dup 9u> $27 and +  '0'+ 4roll --c! rot 1+ rot 0=?until  drop swap --c!  r> drop ;
: #n>$ ( n r -- n$ )  over >r swap abs swap #u>$ r> 0<if  '-' over c@! 1+ swap 1- tuck c!  then ;

( Converts unsigned number u to its radix r string equivalent in a transient buffer u$ with #
  digits. )
: ##u>$ ( u r # -- u$ )  swap >x @Buffer 0 2swap 0 do
  x@ u÷% dup 9u> 7and +  '0'+ 4 roll --c! rot 1+ rot loop  drop swap --c!  x> drop ;

( Converts unsigned number u to its decimal string equivalent u$ in a transient buffer. )
: u>$ ( u -- u$ )  10 #u>$ ;
( Converts unsigned number u to its hexadecimal string equivalent u$ in a transient buffer. )
: hu>$ ( u -- u$ )  16 #u>$ ;
( Converts unsigned number u to its hexadecimal string equivalent u$ in a transient buffer. )
: Hu>$ ( u -- u$ )  16 #U>$ ;
( Converts signed number n to its decimal string equivalent n$ in a transient buffer. )
: n>$ ( n -- n$ )  10 #n>$ ;
: #hu>$ ( u # -- u$ )  16 swap ##u>$ ;

public static section --- API

( Writes short string a$ to the standard output channel. )
: $. ( a$ -- )  out. ;
( Writes short string a$ to the standard error channel. )
: $.. ( a$ -- )  err. ;
( Emits unicode character uc as UTF-8 to standard output. )
: emit ( uc -- )  Buffer tuck dup 0c! uc>utf8$ out. ;
( Emits unicode character uc as UTF-8 to standard error. )
: eemit ( uc -- )  Buffer tuck dup 0c! uc>utf8$ err. ;
( Advances the cursor to the beginning of next line by sending a NEWLINE to stdout. )
: cr ( -- )  10 emit ;
( Advances the cursor to the beginning of next line by sending a NEWLINE to stderr. )
: ecr ( -- )  10 eemit ;
( Advances the cursor by sending a BLANK to stdout. )
: space ( -- )  bl emit ;
( Advances the cursor by sending a BLANK to stderr. )
: espace ( -- )  bl eemit ;
( Advances the cursor by sending # BLANKs to stdout. )
: spaces ( # -- )  Buffer 2dup c!  tuck 1+ swap ␣ cfill  out. ;
( Advances the cursor by sending # BLANKs to stderr. )
: espaces ( # -- )  Buffer 2dup c! tuck 1+ swap ␣ cfill  err. ;
( Prints number n to standard output. )
: . ( n -- )  n>$ out. ;
( Prints number n to standard error. )
: e. ( n -- )  n>$ err. ;
( Prints unsigned number u to standard output. )
: u. ( n -- )  u>$ out. ;
( Prints unsigned number u to standard error. )
: eu. ( n -- )  u>$ err. ;
( Prints unsigned number u to standard output as hex nmber with lower-case letters. )
: hu. ( n -- )  hu>$ out. ;
( Prints unsigned number u to standard error as hex number with lower-case letters. )
: ehu. ( n -- )  hu>$ err. ;
( Prints unsigned number u to standard output as hex nmber with upper-case letters. )
: Hu. ( n -- )  Hu>$ out. ;
( Prints unsigned number u to standard error as hex number with upper-case letters. )
: eHu. ( n -- )  Hu>$ err. ;

( Prints buffer a with length # to stdout. )
: a#. ( a # -- )  a#out ;
( Prints buffer a with length # to stderr. )
: a#.. ( a # -- )  a#err ;

( Prints unsigned number u as # hex digits to standard output. )
: #hu. ( u # -- )  #hu>$ out. ;

( Prints string a$ as an error message (highlighted) to stderr. )
: !$. ( a$ -- )  "\e[1m" err.  err.  "\e[22m" err. ;
( Prints string a$ as a debug message (lowlighted) to stderr. )
: debug. ( a$ -- )  "\e[2m" err.  err.  "\e[22m" err. ;
: newline cr ;

vocabulary;
export DirectIO
