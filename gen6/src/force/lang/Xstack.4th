/*
 * The X-Stack, an alternative stack.
 */

package force/lang/

import force/lang/Forth

vocabulary Xstack

private static section --- Interna ---

create xstack  1024 allot         ( The stack area. )
ubyte variable xsptr              ( Stack pointer: index to next element to push. )

public static section --- API ---

( Pushes x on the stack. )
: >x ( x -- )  xstack xsptr dup c@ swap 1c+! cells+ q! ;
( Pops x on from the stack. )
: x> ( -- x )  xstack xsptr dup 1c−! c@ cells+ q@ ;
( Returns the top entry of the stack. )
: x@ ( -- x )  xstack xsptr c@ 1− cells+ q@ ;

vocabulary;
export Xstack
