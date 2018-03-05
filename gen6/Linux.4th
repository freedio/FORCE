/**
  * Linux System Calls
  *
  * --> Contains Assembler Code <---
  */

import Forth

vocabulary Linux

private static section --- Interna --------------------------------

00 constant LINUX.READ
01 constant LINUX.WRITE

12 constant LINUX.BRK

60 constant LINUX.EXIT

public static section --- API -------------------------------------

( Reads u₁ bytes from file descriptor #f into buffer a, returning actual number of bytes read u₂. )
: read ( #f a u₁ -- u₂ t | #e f )  LINUX.READ LINUX-CALL-3,  RESULT, ;
( Writes u₁ bytes from buffer a to file descriptor #f returning actual number of written bytes u₂. )
: write ( #f a u₁ -- u₂ t | #r f )  LINUX.WRITE LINUX-CALL-3,  RESULT, ;
: open ( fnz fl md -- #f t | #e f )

( Sets program break a (if a≠0) and returns new (a≠0) or current (a=0) program break. )
: pgmbrk ( a|0 -- a' t | #e f )  LINUX.BRK LINUX-CALL-1,  RESULT, ;

( Terminates the program with exit code n.  Does not return. )
: terminate ( n -- )  LINUX.EXIT LINUX-CALL-1, ;
( Terminates the program successfully. )
: bye ( -- )  0 terminate ;

vocabulary;
export Linux
