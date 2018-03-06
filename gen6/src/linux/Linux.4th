/**
  * Linux System Calls
  *
  * --> Contains Assembler Code <---
  */

package /linux

import /force/lang/Forth

vocabulary Linux

private static section --- Interna --------------------------------

00 constant LINUX.READ
01 constant LINUX.WRITE
02 constant LINUX.OPEN
03 constant LINUX.CLOSE

12 constant LINUX.BRK

60 constant LINUX.EXIT

public static section --- API -------------------------------------

/* *** fnz and other "string" parameters ending in -z expect a trailing zero byte and no length. */

( Reads u₁ bytes from file descriptor #f into buffer a, returning actual number of bytes read u₂. )
: read ( #f a u₁ -- u₂ t | #e f )  LINUX.READ LINUX-CALL-3,  RESULT, ;
( Writes u₁ bytes from buffer a to file descriptor #f returning actual number of written bytes u₂. )
: write ( #f a u₁ -- u₂ t | #r f )  LINUX.WRITE LINUX-CALL-3,  RESULT, ;
( Opens file with filename fnz for access according to fl, using md was file mode bits if a file
  is going to be created. )
: open ( fnz fl md -- #f t | #e f )  LINUX.OPEN LINUX-CALL-3,  RESULT, ;
( Closes open file handle #f. )
: close ( #f -- t | #e f )  LINUX.CLOSE LINUX-CALL-1,  ERROR, ;
( Reports the status of file with filename fnz in Stat structure s. )
: stat ( fnz Stat:s -- t | #e f )  LINUX.STAT LINUX-CALL-2,  ERROR, ;

( Sets program break a (if a≠0) and returns new (a≠0) or current (a=0) program break. )
: pgmbrk ( a|0 -- a' t | #e f )  LINUX.BRK LINUX-CALL-1,  RESULT, ;

( Terminates the program with exit code n.  Does not return. )
: terminate ( n -- )  LINUX.EXIT LINUX-CALL-1, ;
( Terminates the program successfully. )
: bye ( -- )  0 terminate ;

vocabulary;
export Linux
