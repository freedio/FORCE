/**
  * Exceptions base module.
  *
  * --> Contains assembler code <--
  */

package force/exception/

import force/lang/Forth
import force/exception/Exception
import force/exception/ExceptionHandler
( import force/logging/Log )

import force/debug/Debug

vocabulary Exceptions

=== Exception Handler Stack ===

( Note: like the parameter stack, the exception handler stack grows downwards, so EX0 actually
  points at the first byte past the stack. )

private cell variable EX0       ( Initial exception handler stack pointer )

( Returns initial exception handler stack pointer a. )
: ex0 ( -- a )  EX0@ ;
( Returns current exception handler stack pointer a. )
: ex@ ( -- a )  GETEX, ;
( Sets the exception handler stack pointer to a. )
: ex! ( a -- )  SETEX, ;
( Returns the number of occupied cells on the exception handler stack. )
: exdepth ( -- # )  ex0 ex@ − cellu/ ;
( Pops the current exception handler from the stack and returns the address of the next one, or 0
  if the last handler has been popped. )
: ex> ( -- a|0 )  POPEX,  ex@ ex0 over − cellu/ 0≠ and ;

=== Exception Operations ===

private section

( Logs exception e as "lost under the radar". )
: lost ( Exception:e -- )  ( TODO 1 "Lost exception %! under the radar!" WARNING flog ) drop ;
( Logs exception e as "uncaught". )
: uncaught ( Exception:e -- )  "Uncaught exception!"abort ;

public section

: throw ( Exception:e -- )
  exdepth 0=if  uncaught  then
  ex@ dup Flags 0bit@if  Current @! ?dupif  lost  else  drop  then  else
  ex> ?dupunless  uncaught  else  Current!  then  then
  rp@ sp@ ex@ tuck RefPSP! RefRSP!  ex@ @Next rdrop >r ;

=== Module Initialization ===

( Initializes the vocabulary from initialization structure at address @initstr when loading. )
private init : init ( @initstr -- @initstr )  dup @XSP + @ dup EX0! ex! ;

vocabulary;
export Exceptions
