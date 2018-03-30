/** Compiler clauses. */

vocabulary Clauses
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Vocabulary.voc"
  requires" AsmBase-IA64.voc"
  requires" Forcembler-IA64.voc"
  requires" MacroForcembler-IA64.voc"
  requires" Compiler.voc"

=== Stack Operations ===

: _#pick ( ... _# -- ... x )  1 ADP+  RAX PUSH  1 ADP-  CELLS [RSP] RAX MOV ;
: _#roll ( ... _# -- ... )  # RCX MOV  RDX RDX XOR
  BEGIN  RCX DEC  0> WHILE  0 [RSP] [RDX] *CELL RAX XCHG  RDX INC  REPEAT  nolink ;

=== Stack Arithmetic Clauses ===

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
: _#c! ( a _c -- )  # BYTE PTR 0 [RAX] MOV  DROP, ;
( Sets word at address a to _w. )
: _#w! ( a _w -- )  # WORD PTR 0 [RAX] MOV  DROP, ;
( Sets double-word at address a to _d. )
: _#d! ( a _d -- )  # DWORD PTR 0 [RAX] MOV  DROP, ;
( Sets quadword at address a to _q. )
: _#q! ( a _q -- )  # QWORD PTR 0 [RAX] MOV  DROP, ;  alias _#!

=== Memory Arithmetics ===

( Adds _c to byte at address a. )
: _#c+! ( a _c -- )  # BYTE PTR 0 [RAX] ADD  DROP, ;
( Adds _w to word at address a. )
: _#w+! ( a _w -- )  # WORD PTR 0 [RAX] ADD  DROP, ;
( Adds _d to double-word at address a. )
: _#d+! ( a _d -- )  # DWORD PTR 0 [RAX] ADD  DROP, ;
( Adds _q to quad-word at address a. )
: _#q+! ( a _q -- )  # QWORD PTR 0 [RAX] ADD  DROP, ;  alias _#+!

( Subtracts _c from byte at address a. )
: _#c-! ( a _c -- )  # BYTE PTR 0 [RAX] SUB  DROP, ;  alias _#c−!
( Subtracts _w from word at address a. )
: _#w-! ( a _w -- )  # WORD PTR 0 [RAX] SUB  DROP, ;  alias _#w−!
( Subtracts _d from double-word at address a. )
: _#d-! ( a _d -- )  # DWORD PTR 0 [RAX] SUB  DROP, ;  alias _#d−!
( Subtracts _q from quad-word at address a. )
: _#q-! ( a _q -- )  # QWORD PTR 0 [RAX] SUB  DROP, ;  alias _#q−!  alias _#-!  alias _#−!

( Subtracts _c from byte at address a and returns the new value at a. )
: _#c−!@ ( a _c -- c )  # BYTE PTR 0 [RAX] SUB  BYTE PTR 0 [RAX] RAX MOVZX ;  alias _#c-!@
( Subtracts _w from word at address a and returns the new value at a. )
: _#w−!@ ( a _w -- w )  # WORD PTR 0 [RAX] SUB  WORD PTR 0 [RAX] RAX MOVZX ;  alias _#w-!@
( Subtracts _d from double-word at address a and returns the new value at a. )
: _#d−!@ ( a _d -- d )  # DWORD PTR 0 [RAX] SUB  DWORD PTR 0 [RAX] RAX MOV ;  alias _#d-!@
( Subtracts _w from quad-word at address a and returns the new value at a. )
: _#q−!@ ( a _q -- q )  # QWORD PTR 0 [RAX] SUB  0 [RAX] RAX MOV ;  alias _#−!@  alias _#q-!@
  alias _#-!@

--- Number and character builders ---

( Multiplies unsigned quad-word at a with _u and adds u. )
: _#q*+! ( u a _u -- )  1 ADP+  RAX RCX MOV  1 ADP-  # RAX MOV  QWORD PTR 0 [RCX] MUL  RDX POP
  RDX RAX ADD  RAX 0 [RCX] MOV  DROP, ;
( Multiplies signed quad-word at a with _u and adds u. )
: _#l*+! ( u a _u -- )  1 ADP+  RAX RCX MOV  1 ADP-  # RAX MOV  QWORD PTR 0 [RCX] IMUL  RDX POP
  RDX RAX ADD  RAX 0 [RCX] MOV  DROP, ;
( Multiplies unsigned double-word at a with _d and adds d. )
: _#d*+! ( d a _d -- )  1 ADP+  RAX RCX MOV  1 ADP-  # EAX MOV  DWORD PTR 0 [RCX] MUL  RDX POP
  EDX EAX ADD  EAX 0 [RCX] MOV  DROP, ;
( Multiplies signed double-word at a with _i and adds i. )
: _#i*+! ( i a _i -- )  1 ADP+  RAX RCX MOV  1 ADP-  # EAX MOV  DWORD PTR 0 [RCX] IMUL  RDX POP
  EDX EAX ADD  EAX 0 [RCX] MOV  DROP, ;
( Multiplies unsigned word at a with _d and adds d. )
: _#w*+! ( w a _w -- )  1 ADP+  RAX RCX MOV  1 ADP-  # AX MOV  WORD PTR 0 [RCX] MUL  RDX POP
  DX AX ADD  AX 0 [RCX] MOV  DROP, ;
( Multiplies signed word at a with _s and adds s. )
: _#s*+! ( s a _s -- )  1 ADP+  RAX RCX MOV  1 ADP-  # AX MOV  WORD PTR 0 [RCX] IMUL  RDX POP
  DX AX ADD  AX 0 [RCX] MOV  DROP, ;
( Multiplies unsigned byte at a with _c and adds c. )
: _#c*+! ( c a _c -- )  1 ADP+  RAX RCX MOV  1 ADP-  # AL MOV  BYTE PTR 0 [RCX] MUL  RDX POP
  DL AL ADD  AL 0 [RCX] MOV  DROP, ;
( Multiplies signed byte at a with _b and adds b. )
: _#b*+! ( b a _b -- )  1 ADP+  RAX RCX MOV  1 ADP-  # AL MOV  BYTE PTR 0 [RCX] IMUL  RDX POP
  DL AL ADD  AL 0 [RCX] MOV  DROP, ;

=== Memory Logicals ===

( Tests bit _# of byte range starting at address a. )
: _#bit@ ( a _# -- ? )  64u/mod # swap 8* QWORD PTR [RAX] BT  RAX RAX SBB ;

=== String Clauses ===

( Formats string template literal _$ fitted with # arguments ... )
: _$| ( ... # _$ -- ShortString:s )  compileString2  "format" getDirectI/OTargetWord  compileTarget ;
( Prints string template literal _$ fitted with # arguments ... to stdout. )
: _$|. ( ... # _$ -- )  _$|  "$." getDirectI/OTargetWord  compileTarget ;
( Prints short string _$ with error style on a new line to stderr. )
: _$! ( _$ -- )  compileString2  "!$." getDirectI/OTargetWord  compileTarget ;
( Formats string template literal _$ fitted with # arguments ... with error style on a new line. )
: _$|! ( ... # _$ -- )  _$|  "!$." getDirectI/OTargetWord  compileTarget ;
( Prints short string _$ with error style on a new line and aborts the process. )
: _$abort ( _$ -- )  _$!  "abort" getTargetWord  compileTarget ;
: _$|abort ( ... # _$ -- )  _$|!  "abort" getTargetWord  compileTarget ;

=== Debugging Clauses ===

( Prints the parameter stack layout with label _n. )
: _#.s ( _n -- )  1 ADP+  RAX PUSH  1 ADP-  # RAX MOV  "#.s" getTargetWord compileTarget ;

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

--- Value and Bit Testing ---

: _#bit@if ( a _# -- )  64u/mod # swap 8* QWORD PTR [RAX] BT  RAX POP  CY IF ;
: _#bit@unless ( a _# -- )  64u/mod # swap 8* QWORD PTR [RAX] BT  RAX POP  CY UNLESS ;

vocabulary;
