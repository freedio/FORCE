/** Compiler clauses. */

vocabulary Clauses
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" AsmBase-IA64.voc"
  requires" Forcembler-IA64.voc"
  requires" MacroForcembler-IA64.voc"

=== Stack Arithemtic Clauses ===

( Adds _n to x. )
: _#+ ( x _n -- x+_n )  # RAX ADD ;
( Subtracts _n from x. )
: _#− ( x _n -- x+_n )  # RAX SUB ;  alias _#-
( Multiply n with _n. )
: _#× ( n _n -- n*_n )
  0=?if  drop  RAX RAX XOR  else
  1=?if  drop  else
  -1=?if  drop  RAX NEG  else
  2=?if  drop  RAX RAX ADD  else
  4=?if  drop  2 # RAX SHL  else
  8=?if  drop  3 # RAX SHL  else
  16=?if  drop  4 # RAX SHL  else
  32=?if  drop  5 # RAX SHL  else
  64=?if  drop  6 # RAX SHL  else
  128=?if  drop  7 # RAX SHL  else
  256=?if  drop  8 # RAX SHL  else
  512=?if  drop  9 # RAX SHL  else
  1024=?if  drop  10 # RAX SHL  else
  2048=?if  drop  11 # RAX SHL  else
  4096=?if  drop  12 # RAX SHL  else
  8192=?if  drop  13 # RAX SHL  else
  16384=?if  drop  14 # RAX SHL  else
  32768=?if  drop  15 # RAX SHL  else
  65536=?if  drop  16 # RAX SHL  else
  # RDX MOV  RDX IMUL
  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then
  then  then  then ;  alias _#*
( Multiply u with _u. )
: _#u× ( u _u -- u*_u )
  0=?if  drop  RAX RAX XOR  else
  1=?if  drop  else
  2=?if  drop  RAX RAX ADD  else
  4=?if  drop  2 # RAX SHL  else
  8=?if  drop  3 # RAX SHL  else
  16=?if  drop  4 # RAX SHL  else
  32=?if  drop  5 # RAX SHL  else
  64=?if  drop  6 # RAX SHL  else
  128=?if  drop  7 # RAX SHL  else
  256=?if  drop  8 # RAX SHL  else
  512=?if  drop  9 # RAX SHL  else
  1024=?if  drop  10 # RAX SHL  else
  2048=?if  drop  11 # RAX SHL  else
  4096=?if  drop  12 # RAX SHL  else
  8192=?if  drop  13 # RAX SHL  else
  16384=?if  drop  14 # RAX SHL  else
  32768=?if  drop  15 # RAX SHL  else
  65536=?if  drop  16 # RAX SHL  else
  # RDX MOV  RDX MUL
  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then
  then  then ;  alias _#u*
( Divide n through _n. )
: _#÷ ( n _n -- n*_n )
  0=?if  "Division by zero!"abort  else
  1=?if  drop  else
  -1=?if  drop  RAX NEG  else
  2=?if  drop  1 # RAX SAR  else
  4=?if  drop  2 # RAX SAR  else
  8=?if  drop  3 # RAX SAR  else
  16=?if  drop  4 # RAX SAR  else
  32=?if  drop  5 # RAX SAR  else
  64=?if  drop  6 # RAX SAR  else
  128=?if  drop  7 # RAX SAR  else
  256=?if  drop  8 # RAX SAR  else
  512=?if  drop  9 # RAX SAR  else
  1024=?if  drop  10 # RAX SAR  else
  2048=?if  drop  11 # RAX SAR  else
  4096=?if  drop  12 # RAX SAR  else
  8192=?if  drop  13 # RAX SAR  else
  16384=?if  drop  14 # RAX SAR  else
  32768=?if  drop  15 # RAX SAR  else
  65536=?if  drop  16 # RAX SAR  else
  # RCX MOV  CQO  RCX IDIV
  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then
  then  then  then ;  alias _#/
( Divide u through _u. )
: _#u÷ ( u _u -- u*_u )
  0=?if  "Division by zero!"abort  else
  1=?if  drop  else
  2=?if  drop  1 # RAX SHR  else
  4=?if  drop  2 # RAX SHR  else
  8=?if  drop  3 # RAX SHR  else
  16=?if  drop  4 # RAX SHR  else
  32=?if  drop  5 # RAX SHR  else
  64=?if  drop  6 # RAX SHR  else
  128=?if  drop  7 # RAX SHR  else
  256=?if  drop  8 # RAX SHR  else
  512=?if  drop  9 # RAX SHR  else
  1024=?if  drop  10 # RAX SHR  else
  2048=?if  drop  11 # RAX SHR  else
  4096=?if  drop  12 # RAX SHR  else
  8192=?if  drop  13 # RAX SHR  else
  16384=?if  drop  14 # RAX SHR  else
  32768=?if  drop  15 # RAX SHR  else
  65536=?if  drop  16 # RAX SHR  else
  # RCX MOV  RDX RDX XOR  RCX DIV
  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then
  then  then ;  alias _#u/
( Returns the rest of the integer division of n through _n. )
: _#% ( n _n -- n%_n )
  0=?if  "Division by zero!"abort  else
  1=?if  drop  RAX RAX XOR  else
  # RCX MOV  CQO  RCX IDIV  RDX RAX MOV
  then  then ;  alias _#mod
( Returns the rest of the integer division of u through _u. )
: _#u% ( n _u -- u%_u )
  0=?if  "Division by zero!"abort  else
  1=?if  drop  RAX RAX XOR  else
  2=?if  drop  1 # RAX AND  else
  4=?if  drop  3 # RAX AND  else
  8=?if  drop  7 # RAX AND  else
  16=?if  drop  15 # RAX AND  else
  32=?if  drop  31 # RAX AND  else
  64=?if  drop  63 # RAX AND  else
  128=?if  drop  127 # RAX AND  else
  256=?if  drop  255 # RAX AND  else
  512=?if  drop  511 # RAX AND  else
  1024=?if  drop  1023 # RAX AND  else
  2048=?if  drop  2047 # RAX AND  else
  4096=?if  drop  4097 # RAX AND  else
  8192=?if  drop  8191 # RAX AND  else
  16384=?if  drop  16383 # RAX AND  else
  32768=?if  drop  32767 # RAX AND  else
  65536=?if  drop  65535 # RAX AND  else
  # RCX MOV  RDX RDX XOR  RCX DIV  RDX RAX MOV
  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then  then
  then  then ;  alias _#umod
( Advances _n positions in the buffer with length # and address a. )
: _#+> ( a # _n -- a+_n #−_n )  1 ADP+  dup # RAX SUB  1 ADP-  # CELL PTR 0 [RSP] ADD ;
( Loads _n cells. )
: _#cells ( _n -- _n*cell# )  1 ADP+  RAX PUSH  1 ADP-  CELL * # RAX MOV ;
( Adds _n cells to x. )
: _#cells+ ( x _n -- x+_n*cell# )  CELL * # RAX ADD ;

=== Stack Logical Clauses ===

( Conjoins x with _x. )
: _#and ( x _x -- x' )  # RAX AND ;
( Bijoins x with _x. )
: _#or ( x _x -- x' )  # RAX OR ;
( Disjoins x with _x. )
: _#xor ( x _x -- x' )  # RAX XOR ;

: _#bit? ( x _# -- ? )  # RAX BT  RAX RAX SBB ;

( Shifts n left arithmetically by _# bits. )
: _#<< ( n _# -- n' )  # RAX SAL ;  alias _#≪
( Shifts n right arithmetically by _# bits. )
: _#>> ( n _# -- n' )  # RAX SAR ;  alias _#≫
( Shifts u left logically by _# bits. )
: _#u<< ( u _# -- u' )  # RAX SHL ;  alias _#u≪
( Shifts n right logically by _# bits. )
: _#u>> ( n _# -- u' )  # RAX SHR ;  alias _#u≫

=== Stack Manipulation Clauses ===

( Drops _u cells. )
: _#drop ( ... _u -- )  CELLS # RSP ADD ;

=== Storage Clauses ===

( Sets byte at address a to _c. )
: _#c! ( a _c -- )  # BYTE PTR 0 [RAX] MOV ;
( Sets word at address a to _w. )
: _#w! ( a _w -- )  # WORD PTR 0 [RAX] MOV ;
( Sets double-word at address a to _d. )
: _#d! ( a _d -- )  # DWORD PTR 0 [RAX] MOV ;
( Sets quadword at address a to _q. )
: _#q! ( a _q -- )  # QWORD PTR 0 [RAX] MOV ;  alias _#!

=== Memory Arithmetics ===

: _#c+! ( a _c -- )  # BYTE PTR 0 [RAX] ADD  RAX POP ;
: _#w+! ( a _w -- )  # WORD PTR 0 [RAX] ADD  RAX POP ;
: _#d+! ( a _d -- )  # DWORD PTR 0 [RAX] ADD  RAX POP ;
: _#q+! ( a _q -- )  # QWORD PTR 0 [RAX] ADD  RAX POP ;  alias _#+!

: _#c-! ( a _c -- )  # BYTE PTR 0 [RAX] SUB  RAX POP ;  alias _#c−!
: _#w-! ( a _w -- )  # WORD PTR 0 [RAX] SUB  RAX POP ;  alias _#w−!
: _#d-! ( a _d -- )  # DWORD PTR 0 [RAX] SUB  RAX POP ;  alias _#d−!
: _#q-! ( a _q -- )  # QWORD PTR 0 [RAX] SUB  RAX POP ;  alias _#q−!  alias _#-!  alias _#−!

=== Memory Logicals ===

: _#bit@ ( a _# -- ? )  64u/mod # swap 8* QWORD PTR [RAX] BT  RAX RAX SBB ;

=== String Clauses ===

/*
( Prints string template a$ fitted with u arguments ... )
: _$|. ( ... u a$ -- )  $| $. ;
*/

=== Conditional Clauses ===

( Tests if x is equal to _x. )
: _#= ( x _x -- ? )  # RAX SUB  1 # RAX SUB  RAX POP  RAX RAX SBB ;
( Tests if x is different from _x. )
: _#≠ ( x _x -- ? )  # RAX SUB  1 # RAX SUB  CMC  RAX POP  RAX RAX SBB ;
( Tests if n is less than _n. )
: _#< ( n _n -- ? )  # RAX CMP  AL < ?SET  AL NEG  AL RAX MOVSX ;
( Tests if n is less than or equal to _n. )
: _#≤ ( n _n -- ? )  # RAX CMP  AL ≤ ?SET  AL NEG  AL RAX MOVSX ;
( Tests if n is greater than _n. )
: _#> ( n _n -- ? )  # RAX CMP  AL > ?SET  AL NEG  AL RAX MOVSX ;
( Tests if n is greater than or equal to _n. )
: _#≥ ( n _n -- ? )  # RAX CMP  AL ≥ ?SET  AL NEG  AL RAX MOVSX ;
( Tests if u is below _u. )
: _#u< ( u _u -- ? )  # RAX CMP  RAX RAX SBB ;
( Tests if u is below than or equal to _u. )
: _#u≤ ( n _n -- ? )  # RAX CMP  AL U≤ ?SET  AL NEG  AL RAX MOVSX ;
( Tests if u is above _u. )
: _#u> ( u _u -- ? )  # RAX CMP  AL U> ?SET  AL NEG  AL RAX MOVSX ;
( Tests if u is above than or equal to _u. )
: _#u≥ ( n _n -- ? )  # RAX CMP  CMC  RAX RAX SBB ;

=== Conditional Term Clauses ===

--- Likely ---

( Tests if x is equal to _x and starts a likely conditional. )
: _#=if ( x _x -- )  # RAX CMP  RAX POP  = IF ;  alias _#≠unless
( Tests if x is not equal to _x and starts a likely conditional. )
: _#≠if ( x _x -- )  # RAX CMP  RAX POP  = UNLESS ;  alias _#=unless
( Tests if n is less than _n and starts a likely conditional. )
: _#<if ( n _n -- )  # RAX CMP  RAX POP  < IF ;  alias _#≥unless
( Tests if n is not less than _n and starts a likely conditional. )
: _#≥if ( n _n -- )  # RAX CMP  RAX POP  < UNLESS ;  alias _#<unless
( Tests if n is greater than _n and starts a likely conditional. )
: _#>if ( n _n -- )  # RAX CMP  RAX POP  > IF ;  alias _#≤unless
( Tests if n is not greater than _n and starts a likely conditional. )
: _#≤if ( n _n -- )  # RAX CMP  RAX POP  > UNLESS ;  alias _#>unless
( Tests if u is below _u and starts a likely conditional. )
: _#u<if ( u _u -- )  # RAX CMP  RAX POP  U< IF ;  alias _#u≥unless
( Tests if u is not below _u and starts a likely conditional. )
: _#u≥if ( u _u -- )  # RAX CMP  RAX POP  U< UNLESS ;  alias _#u<unless
( Tests if u is above _u and starts a likely conditional. )
: _#u>if ( u _u -- )  # RAX CMP  RAX POP  U> IF ;  alias _#u≤unless
( Tests if u is not above _u and starts a likely conditional. )
: _#u≤if ( u _u -- )  # RAX CMP  RAX POP  U> UNLESS ;  alias _#u>unless

--- Likely, preserving testee ---

( Tests if x is equal to _x and starts a likely conditional. )
: _#=?if ( x _x -- )  # RAX CMP  = IF ;  alias _#≠?unless
( Tests if x is not equal to _x and starts a likely conditional. )
: _#≠?if ( x _x -- )  # RAX CMP  = UNLESS ;  alias _#=?unless
( Tests if n is less than _n and starts a likely conditional. )
: _#<?if ( n _n -- )  # RAX CMP  < IF ;  alias _#≥?unless
( Tests if n is not less than _n and starts a likely conditional. )
: _#≥?if ( n _n -- )  # RAX CMP  < UNLESS ;  alias _#<?unless
( Tests if n is greater than _n and starts a likely conditional. )
: _#>?if ( n _n -- )  # RAX CMP  > IF ;  alias _#≤?unless
( Tests if n is not greater than _n and starts a likely conditional. )
: _#≤?if ( n _n -- )  # RAX CMP  > UNLESS ;  alias _#>?unless
( Tests if u is below _u and starts a likely conditional. )
: _#u<?if ( u _u -- )  # RAX CMP  U< IF ;  alias _#u≥?unless
( Tests if u is not below _u and starts a likely conditional. )
: _#u≥?if ( u _u -- )  # RAX CMP  U< UNLESS ;  alias _#u<?unless
( Tests if u is above _u and starts a likely conditional. )
: _#u>?if ( u _u -- )  # RAX CMP  U> IF ;  alias _#u≤?unless
( Tests if u is not above _u and starts a likely conditional. )
: _#u≤?if ( u _u -- )  # RAX CMP  U> UNLESS ;  alias _#u>?unless

--- Unlikely ---

( Tests if x is equal to _x and starts a unlikely conditional. )
: _#=ifever ( x _x -- )  # RAX CMP  RAX POP  = IFEVER ;  alias _#≠unlessever
( Tests if x is not equal to _x and starts a unlikely conditional. )
: _#≠ifever ( x _x -- )  # RAX CMP  RAX POP  = UNLESSEVER ;  alias _#=unlessever
( Tests if n is less than _n and starts a unlikely conditional. )
: _#<ifever ( n _n -- )  # RAX CMP  RAX POP  < IFEVER ;  alias _#≥unlessever
( Tests if n is not less than _n and starts a unlikely conditional. )
: _#≥ifever ( n _n -- )  # RAX CMP  RAX POP  < UNLESSEVER ;  alias _#<unlessever
( Tests if n is greater than _n and starts a unlikely conditional. )
: _#>ifever ( n _n -- )  # RAX CMP  RAX POP  > IFEVER ;  alias _#≤unlessever
( Tests if n is not greater than _n and starts a unlikely conditional. )
: _#≤ifever ( n _n -- )  # RAX CMP  RAX POP  > UNLESSEVER ;  alias _#>unlessever
( Tests if u is below _u and starts a unlikely conditional. )
: _#u<ifever ( u _u -- )  # RAX CMP  RAX POP  U< IFEVER ;  alias _#u≥unlessever
( Tests if u is not below _u and starts a unlikely conditional. )
: _#u≥ifever ( u _u -- )  # RAX CMP  RAX POP  U< UNLESSEVER ;  alias _#u<unlessever
( Tests if u is above _u and starts a unlikely conditional. )
: _#u>ifever ( u _u -- )  # RAX CMP  RAX POP  U> IFEVER ;  alias _#u≤unlessever
( Tests if u is not above _u and starts a unlikely conditional. )
: _#u≤ifever ( u _u -- )  # RAX CMP  RAX POP  U> UNLESSEVER ;  alias _#u>unlessever

--- Ununlikely, preserving testee ---

( Tests if x is equal to _x and starts a unlikely conditional. )
: _#=?ifever ( x _x -- )  # RAX CMP  = IFEVER ;  alias _#≠?unlessever
( Tests if x is not equal to _x and starts a unlikely conditional. )
: _#≠?ifever ( x _x -- )  # RAX CMP  = UNLESSEVER ;  alias _#=?unlessever
( Tests if n is less than _n and starts a unlikely conditional. )
: _#<?ifever ( n _n -- )  # RAX CMP  < IFEVER ;  alias _#≥?unlessever
( Tests if n is not less than _n and starts a unlikely conditional. )
: _#≥?ifever ( n _n -- )  # RAX CMP  < UNLESSEVER ;  alias _#<?unlessever
( Tests if n is greater than _n and starts a unlikely conditional. )
: _#>?ifever ( n _n -- )  # RAX CMP  > IFEVER ;  alias _#≤?unlessever
( Tests if n is not greater than _n and starts a unlikely conditional. )
: _#≤?ifever ( n _n -- )  # RAX CMP  > UNLESSEVER ;  alias _#>?unlessever
( Tests if u is below _u and starts a unlikely conditional. )
: _#u<?ifever ( u _u -- )  # RAX CMP  U< IFEVER ;  alias _#u≥?unlessever
( Tests if u is not below _u and starts a unlikely conditional. )
: _#u≥?ifever ( u _u -- )  # RAX CMP  U< UNLESSEVER ;  alias _#u<?unlessever
( Tests if u is above _u and starts a unlikely conditional. )
: _#u>?ifever ( u _u -- )  # RAX CMP  U> IFEVER ;  alias _#u≤?unlessever
( Tests if u is not above _u and starts a unlikely conditional. )
: _#u≤?ifever ( u _u -- )  # RAX CMP  U> UNLESSEVER ;  alias _#u>?unlessever


: _#bit@if ( a _# -- )  64u/mod # swap 8* QWORD PTR [RAX] BT  RAX POP  CY IF ;
: _#bit@unless ( a _# -- )  64u/mod # swap 8* QWORD PTR [RAX] BT  RAX POP  CY UNLESS ;

vocabulary;
