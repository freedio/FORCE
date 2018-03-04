=== A1 test utilities ===

variable START
CREATE SHOULD  32 allot

: more ( n -- ? )  dup 0= swap -1 = or 0= ;
: hexdig. ( c -- )  dup 9 > 7 and + '0' + emit ;
: hexchar. ( c -- )  dup 4 >> $F and hexdig. $F and hexdig. ;
: hex. ( u -- )  24 4 0 do  2dup >> dup i 3 = or if  dup  $FF and hexchar.  then  drop  8- loop 2drop ;
: .butgot  ." but got " dec. ;
: .butgoth  ." , but got " hex. ;
: !op ( op code mode size arch type -- )
  4 << + 4 << + 8 << + 8 << + 2dup = unless
    2dup .line ." : expected op " hex. .butgoth  then  2drop ;
: !disp ( n # -- )  dispsize@ swap 2dup - if
    2dup .line ." : expected disp# " dec. .butgot then 2drop
  disp@ swap 2dup - if
    2dup .line ." : expected disp " dec. .butgot then 2drop ;
: !depth0  depth 0= unless  cr ." Depth is " depth dec.  then ;
: .q 34 emit ;
: !error ( $ -- )  ERRMSG @ 2dup - if
  .line ." : expected error " .q  over count type .q ." , but got "
  dup if  .q dup count type .q  else  ." no error"  then  then  sp/  0 ERRMSG ! ;
: !REX ( x -- )  REX@ swap 2dup = unless  2dup .line ." : expected REX " hex. .butgoth then  2drop ;
: ¶  cleanup error>> ;
: .hex$ ( c a # -- ) ?dup unless  drop emit  else
  0 ?do  swap emit dup c@ hexchar. 1+ $20 swap loop 2drop then ;
: ~ ( -- )  here START ! ;
: chk ( ... -- )
  here START @ - depth 1- ( 2dup - if 2dup .line ." : expected " .  ." byte[s] " .butgot then )
  2dup = >R min >R  depth dup SHOULD c!++ over + swap 0 ?do --c!   loop drop
  SHOULD 1+ START @ R> $$#= R> and unless
    .line ." : expected " '<' SHOULD count .hex$ ." > but got " '<' START @ here over - .hex$
    '>' emit then
  error>> ;
