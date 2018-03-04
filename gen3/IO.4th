/* FORCE I/O Vocabulary (64-bit)
 * =============================
 * version 0
 */

vocabulary IO
  requires" FORTH.voc"

CREATE EMIT$  0 c,
CREATE OUTBFR  512 0allot

variable INFILENAME
variable INPAGE
variable INLINE
variable INCOLUMN

: sourceFile@ ( -- a$ )  INFILENAME @ ;
: sourcePage@ ( -- u )  INPAGE @ ;
: sourceLine@ ( -- u )  INLINE @ ;
: sourceColumn@ ( -- u )  INCOLUMN @ ;

=== Standard Output ===

:( Prints # chars at a to standard output. )
: >stdout ( a # -- )  PRT-STDOUT, ; alias str.
:( Prints counted string a$ to standard output. )
: $>stdout ( a$ -- )  PRT-STDOUT$, ; alias $.
:( Prints # chars at a to standard error. )
: >stderr ( a # -- )  PRT-STDERR, ; alias estr.
:( Prints counted string a$ to standard error. )
: $>stderr ( a$ -- )  PRT-STDERR$, ; alias e$. alias $..
:( Prints character c to standard output. )
: emit ( c -- )  EMIT$ tuck c! 1 >stdout ;
:( Prints character c a$ to standard error. )
: eemit ( c -- )  EMIT$ tuck c! 1 >stderr ;
:( Moves cursor to beginning of new line on standard output. )
: cr ( -- )  10 emit ;
:( Moves cursor to beginning of new line on standard error. )
: ecr ( -- )  10 eemit ;
:( Prints a double quote to standard output. )
: dquo ( -- )  '"' emit ;
:( Prints a double quote to standard error. )
: edquo ( -- )  '"' eemit ;
:( Prints a space to standard output. )
: space ( -- )  32 emit ;
:( Prints a space to standard error. )
: espace ( -- )  32 eemit ;
:( Prints u spaces to standard output. )
: spaces ( u -- )  OUTBFR swap 2dup 32 cfill >stdout ;
:( Prints u spaces to standard error. )
: espaces ( u -- )  OUTBFR swap 2dup 32 cfill >stderr ;
( Prints a$ in double quotes to standard output. )
: "$". ( a$ -- )  dquo $. dquo ;
( Prints a$ in double quotes to standard error. )
: "$".. ( a$ -- )  edquo $.. edquo ;

=== Display Attributes ===

: log+ ( -- )  "\e[2m" $. ;
: log- ( -- )  "\e[22m" $. ;
: err+ ( -- )  "\e[1m" $. ;
: err- ( -- )  "\e[22m" $. ;

=== Numeric Conversion and Output ===

--- Convert Number to String ---

:( Converts signed number n to a counted string. )
: n>$ ( u -- a$ )  dup abs
  OUTBFR 128+ tuck begin  swap 10/mod swap '0'+ rot --c! over aslong  nip tuck - swap --c!
  swap 0<if  dup c@ 1+ '-' ( a # '-') rot c!-- tuck c!  then ;
:( Converts unsigned number u to a counted string. )
: u>$ ( u -- a$ )  OUTBFR 128+ tuck begin  swap 10u/mod swap '0'+ rot --c! over aslong
  nip tuck - swap --c! ;
:( Converts unsigned number u to a counted string in hex format [FFFFFFFFFFFFFFFF]. )
: hu>$ ( u -- a$ )
  OUTBFR 128+ tuck begin  swap 16u/mod swap dup 9> 7and +  '0'+ rot --c! over aslong
  nip tuck - swap --c! ;
:( Converts unsigned number c to a counted string in hex format [FF]. )
: hc>$ ( c -- a$ )
  OUTBFR 128+ tuck 2 0 do  swap 16u/mod swap dup 9> 7and +  '0'+ rot --c!  loop
  nip tuck - swap --c! ;
:( Converts address a to a counted string in hex format [FFFFFFFFFFFFFFFF]. )
: a>$ ( a -- a$ )
  OUTBFR 128+ tuck 16 0 do  swap 16u/mod swap dup 9> 39and +  '0'+ rot --c!  loop
  nip tuck - swap --c! ;
:( Converts signed number n to a counted string in octal format. )
: o>$ ( u -- a$ )  dup abs
  OUTBFR 128+ tuck begin  swap 8/mod swap '0'+ rot --c! over aslong  nip tuck - swap --c!
  swap 0<if  dup c@ 1+ '-' ( a # '-') rot c!-- tuck c!  then ;
:( Converts unsigned number u to a counted string in octal format. )
: uo>$ ( u -- a$ )  OUTBFR 128+ tuck begin  swap 10u/mod swap '0'+ rot --c! over aslong
  nip tuck - swap --c! ;

--- Print Numbers ---

:( Prints signed number n to standard output. )
: . ( n -- )  n>$ $>stdout ;
:( Prints signed number n to standard error. )
: e. ( n -- )  n>$ $>stderr ;  alias ..
:( Prints unsigned number n to standard output. )
: u. ( n -- )  u>$ $>stdout ;
:( Prints unsigned number n to standard error. )
: eu. ( n -- )  u>$ $>stderr ;  alias u..
:( Prints address a to standard output. )
: a. ( a -- )  a>$ $>stdout ;
:( Prints address a to standard error. )
: ea. ( a -- )  a>$ $>stderr ; alias a..
:( Prints unsigned number n to standard output in hexadecimal format [FFFFFFFFFFFFFFFF]. )
: hu. ( u -- )  hu>$ $>stdout ;
:( Prints unsigned number n to standard error in hexadecimal format [FFFFFFFFFFFFFFFF]. )
: ehu. ( u -- )  hu>$ $>stderr ;  alias hu..
:( Prints unsigned number c to standard output in hexadecimal format [FF]. )
: hc. ( c -- )  hc>$ $>stdout ;
:( Prints unsigned number c to standard error in hexadecimal format [FF]. )
: ehc. ( c -- )  hc>$ $>stderr ;  alias hc..
:( Prints a stack dump to standard error. )
: .s ( -- )  '<' eemit depth dup e. if
    ':' eemit depth 0 swap 20 min -do  espace i 1- pick ehu.  loop-  then
  depth 0 21 within unless  " ..."..  then  '>' eemit ;

=== Hex Dump ===

--- Format ---

:( Returns printable representation c' of character c. )
: >printable ( c -- c' )  dup 32<if  drop '.'  else  dup 127>if  drop '.'  then  then ;

--- Output ---

:( Dumps the remaining # bytes [<16] at address a as a hex-dump to standard error. )
: hexdump.rest ( a # -- )
  2dup 0 do  c@++ ehc. i 7=if  '-' eemit  else  espace  then  loop  drop  16 over - 3* 4+ espaces
  tuck 0 do  c@++ >printable eemit  loop  drop  16 r- espaces ;
:( Dumps # bytes at address a as a hex-dump to standard error. )
: hexdump ( a # -- )
  begin  dup while  over cr ea. ':' eemit  4 espaces  dup 16u<if  hexdump.rest exit  then
  over 16 0 do  c@++ ehc. i 7=if  '-' eemit  else  espace  then  loop  drop  4 espaces
  over 16 0 do  c@++ >printable eemit  loop  drop
  16-  swap  16+  swap  repeat  2drop ;
: hexbytes. ( a # -- )  0 swap -do  c@++ ehc.  i 1- if  space  then  loop-  drop ;

vocabulary;
