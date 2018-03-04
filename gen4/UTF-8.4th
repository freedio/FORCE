vocabulary UTF-8
  requires" FORTH.voc"
      requires" IO.voc"

variable UTF8-STATE

( Returns the next character from the buffer, or 0 if no more characters are available. )
: char> ( a # -- a' #' c|0 )  dup if  1+> over 1- c@  else  0  then ;

( Reads the next UTF-8 byte, "adds" it to uc and returns the combination uc'. )
: UTF8>+ ( a # uc -- a # uc' )  -rot char> ?dupunless  rot UTF8-STATE 0! exit  then
  ( uc a # c ) dup $C0 and $80=if  $3F and 4 roll 6u<< +  else  drop -1+> UTF8-STATE 0!  then  UTF8-STATE @ and ;
( Reads and returns UTF-8 2-byte sequence uc with prefix c. )
: UTF8-2 ( c -- uc )  1FH and  UTF8>+ ;
( Reads and returns UTF-8 3-byte sequence uc with prefix c. )
: UTF8-3 ( c -- uc )  0FH and  UTF8>+  UTF8>+ ;
( Reads and returns UTF-8 4-byte sequence uc with prefix c. )
: UTF8-4 ( c -- uc )  07H and  UTF8>+  UTF8>+  UTF8>+ ;
( Reads and returns UTF-8 5-byte sequence uc with prefix c. )
: UTF8-5 ( c -- uc )  03H and  UTF8>+  UTF8>+  UTF8>+  UTF8>+ ;
( Reads and returns UTF-8 6-byte sequence uc with prefix c. )
: UTF8-6 ( c -- uc )  01H and  UTF8>+  UTF8>+  UTF8>+  UTF8>+  UTF8>+ ;
( Reads and returns UTF-8 7-byte sequence uc with prefix c. )
: UTF8-7 ( c -- uc )  00H and  UTF8>+  UTF8>+  UTF8>+  UTF8>+  UTF8>+  UTF8>+ ;
( Reads and returns UTF-8 8-byte sequence uc with prefix c. )
: UTF8-8 ( c -- uc )  00H and  UTF8>+  UTF8>+  UTF8>+  UTF8>+  UTF8>+  UTF8>+  UTF8>+ ;
( Returns the next Unicode character from the buffer, or 0 if the character was invalid. )
: uc> ( a # -- a' #' uc|0 )
  UTF8-STATE -1!  char>  7#?unless  exit  then  dup c0->
  5=?if  drop UTF8-2 exit  then
  4=?if  drop UTF8-3 exit  then
  3=?if  drop UTF8-4 exit  then
  2=?if  drop UTF8-5 exit  then
  1=?if  drop UTF8-6 exit  then
  0=?if  drop UTF8-7 exit  then
  -1=if  UTF8-8 exit  then  0 ;

vocabulary;
