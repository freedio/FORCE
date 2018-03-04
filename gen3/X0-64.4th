require forceemu.4th
require C0-64.4th
require ELF.4th

/* FORCE Application Generator for 64-bit target systems
 * =====================================================
 * version 0
 */

create source$  256 allot
create target$  256 allot

: usage ( -- )
  cr ." Usage: X0-64 <input> [<output>]"
  cr ." where: <input>  is the name of an input file name"
  cr ."        <output> is the name of an output file name"
  cr ." If the input file name has no file extension, '.voc' is assumed.  If the output file name
  cr ." is missing, the input file name is stripped of its extension, and '.o' is appended to get
  cr ." the output file name." ;

:( Returns address @ext and length #ext of extension in filename a$. #ext is 0 if none was found )
: findExtension ( a$ -- @ext #ext )  count tuck + swap 0 +do  --@c dup
    '/' = if  drop 0 unloop exit  then
    '.' = if  i 1+ unloop exit  then  loop  0 ;
:( Appends extension ext$ to file name a$ )
: addExtension ( ext$ a$ -- )  2dup count + swap count slide cmove  swap c@ swap c+! ;
:( Appends extension ext$ to file name a$ ONLY if it has no extension )
: supplyExtension ( ext$ a$ -- )  dup findExtension nip unless  addExtension  else  2drop  then ;
:( Replaces extension of file name a$ with ext$ )
: replaceExtension ( ext$ a$ -- )  dup findExtension ?dup if
  2 pick c-! ( ext$ a$ a )  rot tuck ( a$ ext$ a ext$ ) count slide cmove ( a$ ext$ ) c@ swap c+!  else
  drop addExtension  then ;

: program ( -- ) next-arg 2dup 0 0 d= if  usage cr bye  then
  2 TARGET-SIZE !  1 TARGET-FORMAT !  3 TARGET-SYSTEM !  1 MODULE-TYPE !  $3E TARGET-ISA !
  dup source$ c! source$ 1+ swap cmove  source$ dup c@ 1+ target$ swap cmove
  c" .voc" source$ supplyExtension  c" .o" target$ replaceExtension
  cr source$ type$ space ." → " target$ type$
  target$ source$ transform  cr bye ;
program
