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

vocabulary DirectIO

private static section --- Internals

create Buffer  16 allot           ( Buffer for building a UTF-8 output character. )

( Writes short string a$ to the standard output channel. )
: stdout$. ( a$ -- )  out. ;
( Writes short string a$ to the standard error channel. )
: stderr$. ( a$ -- )  err. ;

public static section --- API

( Emit s unicode character uc as UTF-8 to standard output. )
: emit ( uc -- )  Buffer dup dup 0c! uc>utf8$ stdout$. ;
( Emit s unicode character uc as UTF-8 to standard error. )
: eemit ( uc -- )  Buffer dup dup 0c! uc>utf8$ stderr$. ;

vocabulary;
export DirectIO
