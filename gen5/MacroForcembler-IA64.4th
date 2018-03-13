/* Interface to the Forcembler code. */

vocabulary MacroForcembler-IA64
  requires" FORTH.voc"
        requires" IO.voc"
  requires" OS.voc"
  requires" Referent.voc"
  requires" Heap.voc"
  requires" Exception.voc"
  requires" Vocabulary.voc"
  requires" Relocation.voc"
  requires" AsmBase-IA64.voc"
  requires" Forcembler-IA64.voc"

: CELL 8 ;
: -CELL -8 ;
: CELLS CELL * ;
: *CELL *8 ;
-1 1 u>> CONSTANT maxcellv
-1 CONSTANT mincellv

1 constant LINKERTAIL#            ( Length of the linker tail [RAX POP] )
1 constant JOINERHEAD#            ( Length of the joiner head [RAX PUSH] )
variable LINKER                   ( Indicates if last contribution was a linker. )

: nolink ( -- )  LINKER 0! ;

: xhpopped A2@ ;
: tryended A1@ ;
: xhstruct A@ ;

( Save top of stack because it is going to be loaded with another value.  A RAX PUSH is inserted and
  the word is marked as JOINER, if the SAVE, instruction is the first instruction of the word after
  the header [ENTER or ENTER_FIELD].  When a piece of code is copied rather than called, this will
  check if the last instruction so far was a RAX POP — in this particular case, both the RAX POP
  from the previous code and the RAX PUSH in the code to be copied will be skipped.
  This is quite a frequent case, so it's woth-while doing this. )
: SAVE, ( -- )
  LINKER @ if  LINKERTAIL# unallot  else  RAX PUSH  @CURRENTWORD @ &@ FLAG.JOINER bit+!  then ;

( Inserts a call to code referent &c. )
: REFCALL, ( &c -- )  &# CALL  nolink ;
( Inserts the ENTER code. )
: ENTER, ( -- )  CELL [RBP] RBP LEA  -CELL [RBP] POP  ENTER+  nolink ;
( Inserts the EXIT code. )
: EXIT, ( -- )  "(next)" getTargetWord word>code &# JMP  EXIT+  nolink ;
( Inserts the alternative EXIT code. )
: EXIT2, ( -- )  -CELL [RBP] PUSH  -CELL [RBP] RBP LEA  RET  EXIT2+  nolink ;
( Inserts the ENTER_FIELD code. )
: ENTER_FIELD, ( -- )  RCX POP  FIELD_ENTER+  nolink ;
( Inserts the EXIT_FIELD code. )
: EXIT_FIELD, ( -- )  RCX PUSH  RET  FIELD_EXIT+  nolink ;

( Sets up the instance variable "me", "my", "this". )
: ENTER_INSTANCE, ( this -- )  CELL [RBP] RBP LEA  RBX -CELL [RBP] MOV  RBX POP  nolink ;
( Rstores the previous instance variable. )
: EXIT_INSTANCE, ( -- )  -CELL [RBP] RBX MOV  -CELL [RBP] RBP LEA  nolink ;

( Punches a "load int" into the current code. )
: INT, ( x -- )  1 ADP+  SAVE,  1 ADP-  # RAX MOV  nolink ;
( Punches a "load Unicode char" into the current code. )
: CHAR, ( uc -- )  1 ADP+  SAVE,  1 ADP-  # EAX MOV  nolink ;
( Punches a "load address" for refrent &r into the current code. )
: ADDR, ( &r -- )  1 ADP+  SAVE,  1 ADP-  [] RAX LEA  nolink ;

( Returns the cell size. )
: CELL, ( -- cell# )  SAVE,  8 # RAX MOV  nolink ;
( Adds cell size to x. )
: CELLPLUS, ( x -- x+cell#. )  8 # RAX ADD  nolink ;
( Multiplies n by cell size. )
: CELLS, ( n -- u*cell# )  3 # RAX SHL  nolink ;
( Adds n cells to x. )
: CELLSPLUS, ( x n -- x+n*cell# )  3 # RAX SHL  RDX POP  RDX RAX ADD  nolink ;
( Divides u by the cell size. )
: CELLUBY, ( u -- u/cell# )  3 # RAX SHR  nolink ;

: THIS, ( -- @o )  SAVE,  RBX RAX MOV  nolink ;

( Pushes constant 0. )
: ZERO, ( -- 0 )  SAVE,  RAX RAX XOR  nolink ;
( Pushes constant 1. )
: ONE, ( -- 0 )  ZERO,  RAX INC  nolink ;
( Pushes constant -1. )
: NEGONE, ( -- 0 )  ZERO,  RAX DEC  nolink ;
( Pushes a blank. )
: BLANK, ( -- ␣ )  SAVE,  20 # RAX MOV  nolink ;

( Pushes floating point literal 0.0. )
: 0.0, ( -- :F: -- 0.0 )  FLD0  nolink ;
( Pushes floating point literal 1.0. )
: 1.0, ( -- :F: -- 1.0 )  FLD1  nolink ;
( Pushes floating point literal -1.0. )
: −1.0, ( -- :F: -- −1.0 )  FLD1  FCHS  nolink ;
( Pushes floating point literal 10.0. )
: 10.0, ( F: -- 10.0 )  10 # PUSH  WORD PTR 0 [RSP] FILD  CELL [RSP] RSP LEA  nolink ;
( Pushes floating point literal π. )
: PI, ( F: -- π )  FLDPI  nolink ;

=== Stack Operations ===

--- Parameter Stack Operations ---

( Duplicates top of stack. )
: DUP, ( x -- x x )  RAX PUSH  nolink ;
( Drops top of stack. )
: DROP, ( x -- )  RAX POP  @CURRENTWORD @ &@ FLAG.LINKER bit+!  LINKER -1! ;
( Exchanges top and second of stack. )
: SWAP, ( x y -- y x )  0 [RSP] RAX XCHG  nolink ;
( Copies second over top of stack. )
: OVER, ( x y -- x y x )  RAX PUSH  CELL [RSP] RAX MOV  nolink ;
( Tucks top behind second of stack. )
: TUCK, ( x y -- y x y )  RAX RDX MOV  RDX 0 [RSP] XCHG  RDX PUSH  nolink ;
( Drops second of stack. )
: NIP, ( x y -- y )  CELL [RSP] RSP LEA  nolink ;
( Replaces second with top of stack. )
: SMASH, ( x y -- y y )  RAX 0 [RSP] MOV  nolink ;
( Rotates stack triple up. )
: ROT, ( x₁ x₂ x₃ -- x₂ x₃ x₁ )  0 [RSP] RAX XCHG  CELL [RSP] RAX XCHG  nolink ;
( Rotates stack triple down. )
: NEGROT, ( x₁ x₂ x₃ -- x₃ x₁ x₂ )  CELL [RSP] RAX XCHG  0 [RSP] RAX XCHG  nolink ;
( Flips the first and third stack entry. )
: FLIP, ( x₁ x₂ x₃ -- x₃ x₂ x₁ )  CELL [RSP] RAX XCHG  nolink ;
( Swaps the second and third stack entry. )
: SLIDE, ( x₁ x₂ x₃ -- x₂ x₁ x₃ )  RDX POP  0 [RSP] RDX XCHG  RDX PUSH  nolink ;

( Returns current stack pointer a. )
: GETSP, ( -- a )  SAVE,  RSP RAX MOV  nolink ;
( Sets the stack pointer to a. )
: SETSP, ( a -- )  RAX RSP MOV  DROP, ;

( Duplicates top stack pair. )
: 2DUP, ( x y -- x y x y )  RAX PUSH  CELL [RSP] PUSH  nolink ;
( Drops top of stack pair. )
: 2DROP, ( x y -- )  CELL [RSP] RSP LEA  DROP, ;
( Swaps top and second of stack pair. )
: 2SWAP, ( x₁ y₁ x₂ y₂ -- x₂ y₂ x₁ y₁ )
  CELL [RSP] RAX XCHG  RDX POP  CELL [RSP] RDX XCHG  RDX PUSH  nolink ;
( Copies second of stack pair over top pair. )
: 2OVER, ( x₁ y₁ x₂ y₂ -- x₁ y₁ x₂ y₂ x₁ y₁ )  RAX PUSH  3 CELLS [RSP] PUSH  3 cells [RSP] RAX MOV  nolink ;
( Drops second of stack pair. )
: 2NIP, ( x1 y1 x2 y2 -- x2 y2 )  RDX POP  2 CELLS [RSP] RSP LEA  RDX PUSH  nolink ;

( Drops u cells. )
: UDROP, ( ... u -- )  0 [RSP] [RAX] *CELL RSP LEA  DROP, ;
( Picks the uth stack cell. )
: PICK, ( ... u -- ... xu )  0 [RSP] [RAX] *CELL RAX MOV  nolink ;
( Rotates u cells on the stack up. )
: ROLL, ( x₁ x₂ ... xu u -- x₂ ... xu x₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR
  BEGIN  RCX DEC  0> WHILE  0 [RSP] [RDX] *CELL RAX XCHG  RDX INC  REPEAT  nolink ;
( Rotates u cells on the stack down. )
: NEGROLL, ( x₁ x₂ ... xu u -- x₂ ... xu x₁ )  RAX RCX MOV  RAX POP
  BEGIN  RCX DEC  0> WHILE  -CELL [RSP] [RCX] *CELL RAX XCHG  REPEAT  nolink ;

--- Returns Stack Operations ---

( Returns current return stack pointer a. )
: GETRP, ( -- a )  SAVE,  RBP RAX MOV  nolink ;
( Sets the return stack pointer to a. )
: SETRP, ( a -- )  RAX RBP MOV  DROP, ;

: RDROP, ( R: x -- )  -CELL [RBP] RBP LEA  nolink ;
: RPUSH, ( R: -- x )  CELL [RBP] RBP LEA  nolink ;
: RFETCH, ( -- x R: x -- x )  DUP,  -CELL [RBP] RAX MOV  nolink ;
: RCOPY, ( x -- x R: -- x )  RPUSH,  RAX -CELL [RBP] MOV  nolink ;
: FROMR, ( -- x R: x -- )  RFETCH, RDROP,  nolink ;
: TOR, ( x -- R: -- x )  RCOPY,  DROP, ;
: RDUP, ( R: x -- x x )  -CELL [RBP] RDX MOV  RPUSH,  RDX -CELL [RBP] MOV  nolink ;

: LOOPINDEX, ( -- index R: limit index -- limit index )  RFETCH,  nolink ;
: LOOPLIMIT, ( -- limit R: limit index -- limit index )   SAVE,  -2 CELLS [RBP] RAX MOV  nolink ;
: LOOPINDEX2, ( -- index2 R: limit2 index2 limit1 index2 -- limit2 index2 limit1 index2 )
  SAVE,  -3 CELLS [RBP] RAX MOV  nolink ;
: LOOPLIMIT2, ( -- limit2 R: limit2 index2 limit1 index2 -- limit2 index2 limit1 index2 )
  SAVE,  -4 CELLS [RBP] RAX MOV  nolink ;
: LOOPPARA, ( -- RDX=limit RCX=index -- R: limit index -- limit index )
  -CELL [RBP] RCX MOV  -2 CELLS [RBP] RDX MOV  nolink ;
: 2RDROP, ( R: x x -- )  -2 CELLS [RBP] RBP LEA  nolink ;

--- Float Stack Operations ---

( Duplicates top of float stack. )
: FDUP, ( :F: r -- r r )  ST(0) FLD  nolink ;
( Drops top of float stack. )
: FDROP, ( :F: r -- )  ST(0) FFREE  FINCSTP  nolink ;
( Swaps top and second of float stack. )
: FSWAP, ( :F: r₁ r₂ -- r₂ r₁ )  ST(1) FXCH  nolink ;
( Copies second over top of float stack. )
: FOVER, ( :F: r₁ r₂ -- r₁ r₂ r₁ )  ST(1) FLD  nolink ;
( Rotates float stack triple. )
: FROT, ( :F: r₁ r₂ r₃ -- r₂ r₃ r₁ )  ST(1) FXCH  ST(2) FXCH  nolink ;
( Rotates float stack triple backwards. )
: FNEGROT, ( :F: r₁ r₂ r₃ -- r₃ r₁ r₂ )  ST(2) FXCH  ST(1) FXCH  nolink ;

( Duplicates pair of floats. )
: F2DUP, ( :F: r₁ r₂ -- r₁ r₂ r₁ r₂ )  ST(1) FLD  ST(1) FLD  nolink ;

--- Exception Handler Stack ---

( Sets the exception handler stack pointer to a. )
: SETEX, ( a -- )  RAX R10 MOV  DROP, ;
( Returns current exception handler stack pointer a. )
: GETEX, ( -- a )  SAVE,  R10 RAX MOV  nolink ;
( Pops the current exception handler from the exception handler stack. )
: POPEX, ( -- a )  CELL # R10 ADD  nolink ;

=== Arithemtic Operations ===

--- Integer Arithemtics ---

( Adds y to x. )
: PLUS, ( x y -- x+y )  RDX POP  RDX RAX ADD  nolink ;
( Subtracts y from x. )
: MINUS, ( x y -- x−y )  RAX 0 [RSP] SUB  DROP, ;
( Subtracts x from y. )
: RMINUS, ( x y -- y−x )  RDX POP  RDX RAX SUB  nolink ;
( Multiplies n₁ with n₂. )
: TIMES, ( n₁ n₂ -- n₁×n₂ )  RDX POP  RDX IMUL  nolink ;
( Multiplies u₁ with u₂. )
: UTIMES, ( u₁ u₂ -- u₁×u₂ )  RDX POP  RDX MUL  nolink ;
( Divides n₁ through n₂. )
: THROUGH, ( n₁ n₂ -- n₁÷n₂ )  RCX POP  CQO  RCX IDIV  nolink ;
( Divides n₂ through n₁. )
: RTHROUGH, ( n₁ n₂ -- n₂÷n₁ )  RAX RCX MOV  RAX POP  CQO  RCX IDIV  nolink ;
( Divides u₁ through u₂. )
: UTHROUGH, ( u₁ u₂ -- u₁÷u₂ )  RCX POP  RDX RDX XOR  RCX DIV  nolink ;
( Divides u₂ through u₁. )
: URTHROUGH, ( u₁ u₂ -- u₂÷u₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR  RCX DIV  nolink ;
( Calculates the rest of the integer division n₁ through n₂. )
: MOD, ( n₁ n₂ -- n₁%n₂ )  RCX POP  CQO  RCX IDIV  RDX RAX MOV  nolink ;
( Calculates the rest of the integer division n₂ through n₁. )
: RMOD, ( n₁ n₂ -- n₂%n₁ )  RAX RCX MOV  RAX POP  CQO  RCX IDIV  RDX RAX MOV  nolink ;
( Calculates the rest of the integer division u₁ through u₂. )
: UMOD, ( u₁ u₂ -- u₁%u₂ )  RCX POP  RDX RDX XOR  RCX DIV  RDX RAX MOV  nolink ;
( Calculates the rest of the integer division u₂ through u₁. )
: URMOD, ( u₁ u₂ -- u₂%u₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR  RCX IDIV  RDX RAX MOV  nolink ;
( Calculates the quotient and rest of the integer division n₁ through n₂. )
: MODTHROUGH, ( n₁ n₂ -- n₁%n₂ n₁÷n₂ )  RCX POP  CQO  RCX IDIV  RDX PUSH  nolink ;
( Calculates the quotient and rest of the integer division n₂ through n₁. )
: RMODTHROUGH, ( n₁ n₂ -- n₂%n₁ n₂÷n₁ )  RAX RCX MOV  RAX POP  CQO  RCX IDIV  RDX PUSH  nolink ;
( Calculates the quotient and rest of the integer division u₁ through u₂. )
: UMODTHROUGH, ( u₁ u₂ -- u₁%u₂ u₁÷u₂ )  RCX POP  RDX RDX XOR  RCX DIV  RDX PUSH  nolink ;
( Calculates the quotient and rest of the integer division u₂ through u₁. )
: URMODTHROUGH, ( u₁ u₂ -- u₂%u₁ u₂÷u₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR  RCX IDIV  RDX PUSH  nolink ;

( Increments x by 1. )
: INC, ( x -- x+1 )  RAX INC  nolink ;
( Decrements x by 1. )
: DEC, ( x -- x−1 )  RAX DEC  nolink ;

( Increments second of stack. )
: INCS, ( x₁ x₂ -- x₁+1 x₂ )  CELL PTR 0 [RSP] INC  nolink ;
( Advances cursor of buffer with address a and lenght # by u bytes. )
: ADV, ( a # u -- a+u #-u )  RAX 0 [RSP] SUB  RAX CELL [RSP] ADD  DROP, ;

( Negatea top of stack. )
: NEG, ( n -- −n )  RAX NEG  nolink ;
( Returns the absolute value of top of stack. )
: ABS, ( n -- |n| )  RAX RAX TEST  0< IF  RAX NEG  THEN  nolink ;
( Selects the lesser of two signed numbers. )
: MIN2, ( n1 n2 -- n3 )  RDX POP  RAX RDX CMP  < IF  RDX RAX MOV  THEN  nolink ;
( Selects the greater of two signed numbers. )
: MAX2, ( n1 n2 -- n3 )  RDX POP  RAX RDX CMP  > IF  RDX RAX MOV  THEN  nolink ;
( Selects the lesser of two unsigned numbers. )
: UMIN2, ( u1 u2 -- u3 )  RDX POP  RAX RDX CMP  U< IF  RDX RAX MOV  THEN  nolink ;
( Selects the greater of two unsigned numbers. )
: UMAX2, ( u1 u2 -- u3 )    RDX POP  RAX RDX CMP  U> IF  RDX RAX MOV  THEN  nolink ;
( Returns size # in bytes of n.  Note that size of n=0 will be reported as 0, so to get at least 1,
  use "nsize 1 max" )
: NSIZE, ( n -- n # )  RAX PUSH  ABS,  RAX RAX BSR  0= UNLESS  3 # RAX SHR  RAX INC  THEN  nolink ;
( Returns size # in bytes of u.  See note on NSIZE, )
: USIZE, ( u -- u # )  RAX PUSH  RAX RAX BSR  0= UNLESS  3 # RAX SHR  RAX INC  THEN  nolink ;

=== Floating Point Operations ===

: FADD, ( F: f1 f2 -- f1+f2 )  FADDP  nolink ;
: FIADD, ( i -- F: f -- f+i )  RAX PUSH  DWORD PTR 0 [RSP] FIADD  CELL # RSP ADD  DROP, ;
: FSUB, ( F: f1 f2 -- f1-f2 )  FSUBP  nolink ;
: FISUB, ( i -- F: f -- f-i )  RAX PUSH  DWORD PTR 0 [RSP] FISUB  CELL # RSP ADD  DROP, ;
: FSUBR, ( F: f1 f2 -- f2-f1 )  FSUBRP  nolink ;
: FISUBR, ( i -- F: f -- i-f )  RAX PUSH  DWORD PTR 0 [RSP] FISUBR  CELL # RSP ADD  DROP, ;

--- Multiply and Divide ---

: FMPY, ( F: f1 f2 -- f1*f2 )  FMULP  nolink ;
: FIMPY, ( i -- F: f -- f*i )  RAX PUSH  DWORD PTR 0 [RSP] FIMUL  CELL # RSP ADD  DROP, ;
: FDIV, ( F: f1 f2 -- f1/f2 )  FDIVP  nolink ;
: FIDIV, ( i -- F: f -- f/i )  RAX PUSH  DWORD PTR 0 [RSP] FIDIV  CELL # RSP ADD  DROP, ;
: FDIVR, ( F: f1 f2 -- f2/f1 )  FDIVRP  nolink ;
: FIDIVR, ( i -- F: f -- i/f )  RAX PUSH  DWORD PTR 0 [RSP] FIDIVR  CELL # RSP ADD  DROP, ;

--- Negate, absolute value, min, max, ... ---

: FNEG, ( F: f -- -f )  FCHS  nolink ;
: FABS, ( F: f -- |f| )  FABS  nolink ;
: FMIN2, ( F: f1 f2 -- f1|f2 )  ST(1) FCOMI  U< IF  ST(1) FSTP  ELSE  FDROP,  THEN  nolink ;
: FMAX2, ( F: f1 f2 -- f1|f2 )  ST(1) FCOMI  U< UNLESS  ST(1) FSTP  ELSE  FDROP,  THEN  nolink ;

--- Miscellaneous ---

: TIMESPLUS, ( n₁ n₂ n₃ -- n₁+n₂×n₃ )  RDX POP  RDX IMUL  RDX POP  RDX RAX ADD ;
: UTIMESPLUS, ( n₁ n₂ n₃ -- n₁+n₂×n₃ )  RDX POP  RDX MUL  RDX POP  RDX RAX ADD ;

--- Floating Point Comparisons ---

: FISZERO, ( -- f=0.0 |F: f -- )  SAVE,  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %01000000 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNOTZERO, ( -- f≠0.0 |F: f -- )  SAVE, FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %01000000 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNEGATIVE, ( -- f<0.0 |F: f -- )  SAVE,  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %00000001 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNOTNEGATIVE, ( -- f≥0.0 |F: f -- )  SAVE,  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %00000001 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISPOSITIVE, ( -- f>0.0 |F: f -- )  SAVE,  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  AH AH TEST  0= IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNOTPOSITIVE, ( -- f>0.0 |F: f -- )  SAVE,  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  AH AH TEST  0- IF  AL DEC  THEN  AL RAX MOVSX  nolink ;

: FISEQUAL, ( -- f1=f2 |F: f1 f2 -- )  SAVE,  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %01000000 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNOTEQUAL, ( -- f1=f2 |F: f1 f2 -- )  SAVE,  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %01000000 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISLESS, ( -- f1<f2 |F: f1 f2 -- )  SAVE,  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  AH AH TEST  0= IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNOTLESS, ( -- f1≥f2 |F: f1 f2 -- )  SAVE,  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  AH AH TEST  0- IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISGREATER, ( -- f1>f2 |F: f1 f2 -- )  SAVE,  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %00000001 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISNOTGREATER, ( -- f1≤f2 |F: f1 f2 -- )  SAVE,  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %00000001 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX  nolink ;
: FISWITHIN, ( -- flow≤f<fhigh -- f flow fhigh -- )  SAVE,  ST2 FLD  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  00000001 # AH CMP  0= IF  AL DEC  THEN  AL BL MOV  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  00000001 # AH CMP  0= IF  BL INC  THEN  BL RAX MOVSX  nolink ;

=== Logical Operations ===

( Conjoins two stack cells x1 and x2 giving x3. )
: AND, ( x1 x2 -- x3 )  RDX POP  RDX RAX AND  nolink ;
( Bijoins two stack cells x1 and x2 giving x3. )
: OR, ( x1 x2 -- x3 )  RDX POP  RDX RAX OR  nolink ;
( Disjoins two stack cells x1 and x2 giving x3. )
: XOR, ( x1 x2 -- x3 )  RDX POP  RDX RAX XOR  nolink ;
( Complements stack cell x1. )
: NOT, ( x1 -- ¬x1 )  RAX NOT  nolink ;

( Shifts u logically left by # bits. )
: SHL, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX SHL  nolink ;
( Shifts u logically right by # bits. )
: SHR, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX SHR  nolink ;
( Shifts n arithmetically left by # bits. )
: SAL, ( n # -- n' )  RAX RCX MOV  RAX POP  CL RAX SAL  nolink ;
( Shifts n arithmetically right by # bits. )
: SAR, ( n # -- n' )  RAX RCX MOV  RAX POP  CL RAX SAR  nolink ;

=== Memory Operations ===

( Returns signed byte b at address a. )
: BFETCH, ( a -- c )  BYTE PTR 0 [RAX] RAX MOVSX  nolink ;
( Returns unsigned byte c at address a. )
: CFETCH, ( a -- c )  BYTE PTR 0 [RAX] RAX MOVZX  nolink ;
( Returns signed word s at address a. )
: SFETCH, ( a -- s )  WORD PTR 0 [RAX] RAX MOVSX  nolink ;
( Returns unsigned word w at address a. )
: WFETCH, ( a -- w )  WORD PTR 0 [RAX] RAX MOVZX  nolink ;
( Returns signed double-word i at address a. )
: IFETCH, ( a -- s )  DWORD PTR 0 [RAX] RAX MOVSXD  nolink ;
( Returns unsigned double-word d at address a. )
: DFETCH, ( a -- d )  DWORD PTR 0 [RAX] EAX MOV  nolink ;
( Returns signed quad-word l at address a. )
: LFETCH, ( a -- l )  0 [RAX] RAX MOV  nolink ;
( Returns unsigned quad-word q at address a. )
: QFETCH, ( a -- q )  0 [RAX] RAX MOV  nolink ;
( Returns signed oct-word h at address a. )
: HFETCH, ( a -- h )  CELL [RAX] PUSH  0 [RAX] RAX MOV  nolink ;
( Returns unsigned quad-word q at address a. )
: OFETCH, ( a -- d )  CELL [RAX] PUSH  0 [RAX] RAX MOV  nolink ;

( Returns signed byte b at address a and post-increments. )
: BFETCHINC, ( a -- a+1 c )  1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RAX] RAX MOVSX  nolink ;
( Returns unsigned byte c at address a and post-increments. )
: CFETCHINC, ( a -- a+1 c )  1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RAX] RAX MOVZX  nolink ;
( Returns signed word s at address a and post-increments. )
: SFETCHINC, ( a -- a+2 s )  2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RAX] RAX MOVSX  nolink ;
( Returns unsigned word w at address a and post-increments. )
: WFETCHINC, ( a -- a+2 w )  2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RAX] RAX MOVZX  nolink ;
( Returns signed double-word i at address a and post-increments. )
: IFETCHINC, ( a -- a+4 s )  4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RAX] RAX MOVSXD  nolink ;
( Returns unsigned double-word d at address a and post-increments. )
: DFETCHINC, ( a -- a+4 d )  4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RAX] EAX MOV  nolink ;
( Returns signed quad-word l at address a and post-increments. )
: LFETCHINC, ( a -- a+8 l )  8 [RAX] RDX LEA  RDX PUSH  0 [RAX] RAX MOV  nolink ;
( Returns unsigned quad-word q at address a and post-increments. )
: QFETCHINC, ( a -- a+8 q )  8 [RAX] RDX LEA  RDX PUSH  0 [RAX] EAX MOV  nolink ;
( Returns signed oct-word h at address a and post-increments. )
: HFETCHINC, ( a -- a+16 h )  16 [RAX] RDX LEA  RDX PUSH  CELL [RAX] PUSH  0 [RAX] RAX MOV  nolink ;
( Returns unsigned quad-word q at address a and post-increments. )
: OFETCHINC, ( a -- a+16 d )  16 [RAX] RDX LEA  RDX PUSH  CELL [RAX] PUSH  0 [RAX] RAX MOV  nolink ;

( Returns signed byte b at address a and post-increments. )
: DECBFETCH, ( a -- a+1 c )  -1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RDX] RAX MOVSX  nolink ;
( Returns unsigned byte c at address a and post-increments. )
: DECCFETCH, ( a -- a+1 c )  -1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RDX] RAX MOVZX  nolink ;
( Returns signed word s at address a and post-increments. )
: DECSFETCH, ( a -- a+2 s )  -2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RDX] RAX MOVSX  nolink ;
( Returns unsigned word w at address a and post-increments. )
: DECWFETCH, ( a -- a+2 w )  -2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RDX] RAX MOVZX  nolink ;
( Returns signed double-word i at address a and post-increments. )
: DECIFETCH, ( a -- a+4 s )  -4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RDX] RAX MOVSXD  nolink ;
( Returns unsigned double-word d at address a and post-increments. )
: DECDFETCH, ( a -- a+4 d )  -4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RDX] EAX MOV  nolink ;
( Returns signed quad-word l at address a and post-increments. )
: DECLFETCH, ( a -- a+8 l )  -8 [RAX] RDX LEA  RDX PUSH  0 [RDX] RAX MOV  nolink ;
( Returns unsigned quad-word q at address a and post-increments. )
: DECQFETCH, ( a -- a+8 q )  -8 [RAX] RDX LEA  RDX PUSH  0 [RDX] EAX MOV  nolink ;
( Returns signed oct-word h at address a and post-increments. )
: DECHFETCH, ( a -- a+16 h )  -16 [RAX] RDX LEA  RDX PUSH  CELL [RDX] PUSH  0 [RDX] RAX MOV  nolink ;
( Returns unsigned quad-word q at address a and post-increments. )
: DECOFETCH, ( a -- a+16 d )  -16 [RAX] RDX LEA  RDX PUSH  CELL [RDX] PUSH  0 [RDX] RAX MOV  nolink ;

( Sets byte at address a to the LSB8 of c. )
: CSTORE, ( c a -- )  RDX POP  DL 0 [RAX] MOV  DROP, ;
( Sets word at address a to the LSB16 of w. )
: WSTORE, ( w a -- )  RDX POP  DX 0 [RAX] MOV  DROP, ;
( Sets double-word at address a to the LSB32 of d. )
: DSTORE, ( d a -- )  RDX POP  EDX 0 [RAX] MOV  DROP, ;
( Sets quad-word at address a to the LSB32 of q. )
: QSTORE, ( q a -- )  0 [RAX] POP  DROP, ;
( Sets oct-word at address a to the LSB64 of o. )
: OSTORE, ( o a -- )  0 [RAX] POP  CELL [RAX] POP  DROP, ;

( Exchanges signed byte at address a with b, returning previous value b'. )
: BXCHG, ( b a -- b' a )  0 [RSP] RDX MOV  DL 0 [RAX] XCHG  DL RDX MOVSX  RDX 0 [RSP] MOV ;
( Exchanges unsigned byte at address a with c, returning previous value c'. )
: CXCHG, ( c a -- c' a )  0 [RSP] RDX MOV  DL 0 [RAX] XCHG  DL RDX MOVZX  RDX 0 [RSP] MOV ;
( Exchanges signed ord at address a with s, returning previous value s'. )
: SXCHG, ( s a -- s' a )  0 [RSP] RDX MOV  DX 0 [RAX] XCHG  DX RDX MOVSX  RDX 0 [RSP] MOV ;
( Exchanges unsigned word at address a with w, returning previous value w'. )
: WXCHG, ( w a -- w' a )  0 [RSP] RDX MOV  DX 0 [RAX] XCHG  DX RDX MOVZX  RDX 0 [RSP] MOV ;
( Exchanges signed double-word at address a with i, returning previous value i'. )
: IXCHG, ( i a -- i' a )  0 [RSP] RDX MOV  EDX 0 [RAX] XCHG  EDX RDX MOVSXD  RDX 0 [RSP] MOV ;
( Exchanges unsigned double-word at address a with d, returning previous value d'. )
: DXCHG, ( d a -- d' a )  0 [RSP] RDX MOV  EDX 0 [RAX] XCHG  RDX 0 [RSP] MOV ;
( Exchanges signed quad-word at address a with l, returning previous value l'. )
: LXCHG, ( l a -- l' a )  0 [RSP] RDX MOV  RDX 0 [RAX] XCHG  RDX 0 [RSP] MOV ;  alias QXCHG,

( Sets byte at address a to the LSB8 of c and post-increments. )
: CSTOREINC, ( c a -- a+1 )  RDX POP  DL 0 [RAX] MOV  RAX INC  nolink ;
( Sets word at address a to the LSB16 of w and post-increments. )
: WSTOREINC, ( w a -- a+2 )  RDX POP  DX 0 [RAX] MOV  2 # RAX ADD  nolink ;
( Sets double-word at address a to the LSB32 of d and post-increments. )
: DSTOREINC, ( d a -- a+4 )  RDX POP  EDX 0 [RAX] MOV  4 # RAX ADD  nolink ;
( Sets quad-word at address a to the LSB32 of q and post-increments. )
: QSTOREINC, ( q a -- a+8 )  0 [RAX] POP  8 # RAX ADD  nolink ;
( Sets oct-word at address a to the LSB64 of o and post-increments. )
: OSTOREINC, ( o a -- a+16 )  0 [RAX] POP  CELL [RAX] POP  16 # RAX ADD  nolink ;

( Sets byte at address a to the LSB8 of c and post-increments. )
: STORECINC, ( a c -- a+1 )  RDX POP  AL 0 [RDX] MOV  1 [RDX] RAX LEA  nolink ;
( Sets word at address a to the LSB16 of w and post-increments. )
: STOREWINC, ( a w -- a+2 )  RDX POP  AX 0 [RDX] MOV  2 [RDX] RAX LEA  nolink ;
( Sets double-word at address a to the LSB32 of d and post-increments. )
: STOREDINC, ( a d -- a+4 )  RDX POP  EAX 0 [RDX] MOV  4 [RDX] RAX LEA  nolink ;
( Sets quad-word at address a to the LSB32 of q and post-increments. )
: STOREQINC, ( a q -- a+8 )  RDX POP  RAX 0 [RDX] MOV  8 [RDX] RAX LEA  nolink ;
( Sets oct-word at address a to the LSB64 of o and post-increments. )
: STOREOINC, ( a o -- a+16 )
  RCX POP  RDX POP  RAX 0 [RDX] MOV  RCX CELL [RDX] MOV  16 [RDX] RAX LEA  nolink ;

( Sets byte at address a to the LSB8 of c after pre-decrements. )
: DECCSTORE, ( a c -- a−1 )  RDX POP  AL -1 [RDX] MOV  -1 [RDX] RAX LEA  nolink ;
( Sets word at address a to the LSB16 of w after pre-decrements. )
: DECWSTORE, ( a w -- a−2 )  RDX POP  AX -2 [RDX] MOV  -2 [RDX] RAX LEA  nolink ;
( Sets double-word at address a to the LSB32 of d after pre-decrements. )
: DECDSTORE, ( a d -- a−4 )  RDX POP  EAX -4 [RDX] MOV  -4 [RDX] RAX LEA  nolink ;
( Sets quad-word at address a to the LSB32 of q after pre-decrements. )
: DECQSTORE, ( a q -- a−8 )  RDX POP  RAX -8 [RDX] MOV  -8 [RDX] RAX LEA  nolink ;
( Sets oct-word at address a to the LSB64 of o after pre-decrements. )
: DECOSTORE, ( a o -- a−16 )
  RCX POP  RDX POP  RAX -16 [RDX] MOV  RCX -8 [RDX] MOV  -16 [RDX] RAX LEA  nolink ;

( Loads float at address a onto the float stack. )
: FFETCH, ( a -- :F: -- r )  QWORD PTR 0 [RAX] FLD  DROP, ;

( Stores top of float stack to address a. )
: FSTORE, ( a -- :F: r -- )  QWORD PTR 0 [RAX] FSTP  DROP, ;

=== Storage Arithmetics ===

( Adds c to byte at address a. )
: CADD, ( c a -- )  RDX POP  BL 0 [RAX] ADD  DROP, ;
( Adds w to word at address a. )
: WADD, ( w a -- )  RDX POP  BX 0 [RAX] ADD  DROP, ;
( Adds d to double-word at address a. )
: DADD, ( w a -- )  RDX POP  EBX 0 [RAX] ADD  DROP, ;
( Adds q to quad-word at address a. )
: QADD, ( q a -- )  RDX POP  RDX 0 [RAX] ADD  DROP, ;

( Subtracts c from byte at address a. )
: CSUB, ( c a -- )  RDX POP  BL 0 [RAX] SUB  DROP, ;
( Subtracts w from word at address a. )
: WSUB, ( w a -- )  RDX POP  BX 0 [RAX] SUB  DROP, ;
( Subtracts d from double-word at address a. )
: DSUB, ( w a -- )  RDX POP  EBX 0 [RAX] SUB  DROP, ;
( Subtracts q from quad-word at address a. )
: QSUB, ( q a -- )  RDX POP  RDX 0 [RAX] SUB  DROP, ;

=== Assertions ===

: ASSERT_TYPE, ( @0 -- @0 :C: &voc )  [] RDX LEA  "!instance" getTargetWord &# CALL  nolink ;

=== Definitions ===

( Inserts code to push a variable. )
: DOVAR, ( -- a )  SAVE,  targetVoc# §DATA dup #segment# createReferent [] RAX LEA  nolink ;
( Inserts code to push a constant. )
: DOCONST, ( -- x )  SAVE,  1 ADP- ?dupif  # RAX MOV  else  RAX RAX XOR  then  nolink ;
( Inserts code to fetch the contents of a signed byte variable. )
: FETCHBVAR, ( -- x )
  SAVE,  BYTE PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVSX  nolink ;
( Inserts code to fetch the contents of an unsigned byte variable. )
: FETCHCVAR, ( -- x )
  SAVE,  BYTE PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVZX  nolink ;
( Inserts code to fetch the contents of a signed word variable. )
: FETCHSVAR, ( -- x )
  SAVE,  WORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVSX  nolink ;
( Inserts code to fetch the contents of an unsigned word variable. )
: FETCHWVAR, ( -- x )
  SAVE,  WORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVZX  nolink ;
( Inserts code to fetch the contents of a signed double-word variable. )
: FETCHIVAR, ( -- x )
  SAVE,  DWORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVSXD  nolink ;
( Inserts code to fetch the contents of an unsigned double-word variable. )
: FETCHDVAR, ( -- x )
  SAVE,  DWORD PTR targetVoc# §DATA dup #segment# createReferent [] EAX MOV  nolink ;
( Inserts code to fetch the contents of a signed quad-word variable. )
: FETCHLVAR, ( -- x )
  SAVE,  QWORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOV  nolink ;
( Inserts code to fetch the contents of an unsigned quad-word variable. )
: FETCHQVAR, ( -- x )
  SAVE,  QWORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOV  nolink ;
( Inserts code to store the contents of a byte variable. )
: STORECVAR, ( x -- )  AL targetVoc# §DATA dup #segment# createReferent [] MOV  DROP, ;
( Inserts code to store the contents of a word variable. )
: STOREWVAR, ( x -- )  AX targetVoc# §DATA dup #segment# createReferent [] MOV  DROP, ;
( Inserts code to store the contents of a double-word variable. )
: STOREDVAR, ( x -- )  EAX targetVoc# §DATA dup #segment# createReferent [] MOV  DROP, ;
( Inserts code to store the contents of a quad-word variable. )
: STOREQVAR, ( x -- )  RAX targetVoc# §DATA dup #segment# createReferent [] MOV  DROP, ;

( Inserts code to address a field within an object instance. )
: DOFIELD, ( -- a )  SAVE,  targetVoc@ class# [RAX] RAX LEA  nolink ;
( Inserts code to get the field offset. )
: FIELDOFFSET, ( -- # )
  SAVE,  targetVoc@ class# ?dup if  # RAX MOV  else  RAX RAX XOR  then nolink ;
( Inserts code to fetch the contents of a signed byte field within an object instance. )
: FETCHBFIELD, ( -- x )  BYTE PTR targetVoc@ class# [RAX] RAX MOVSX  nolink ;
( Inserts code to fetch the contents of an unsigned byte field within an object instance. )
: FETCHCFIELD, ( -- x )  BYTE PTR targetVoc@ class# [RAX] RAX MOVZX  nolink ;
( Inserts code to fetch the contents of a signed word field within an object instance. )
: FETCHSFIELD, ( -- x )  WORD PTR targetVoc@ class# [RAX] RAX MOVSX  nolink ;
( Inserts code to fetch the contents of an unsigned word field within an object instance. )
: FETCHWFIELD, ( -- x )  WORD PTR targetVoc@ class# [RAX] RAX MOVZX  nolink ;
( Inserts code to fetch the contents of a signed double-word field within an object instance. )
: FETCHIFIELD, ( -- x )  DWORD PTR targetVoc@ class# [RAX] RAX MOVSXD  nolink ;
( Inserts code to fetch the contents of an unsigned double-word field within an object instance. )
: FETCHDFIELD, ( -- x )  DWORD PTR targetVoc@ class# [RAX] EAX MOV  nolink ;
( Inserts code to fetch the contents of a signed quad-word field within an object instance. )
: FETCHLFIELD, ( -- x )  QWORD PTR targetVoc@ class# [RAX] RAX MOV  nolink ;
( Inserts code to fetch the contents of an unsigned quad-word field within an object instance. )
: FETCHQFIELD, ( -- x )  QWORD PTR targetVoc@ class# [RAX] RAX MOV  nolink ;
( Inserts code to store the contents of a byte field within an object instance. )
: STORECFIELD, ( x -- )  RDX POP  DL targetVoc@ class# [RAX] MOV  DROP, ;
( Inserts code to store the contents of a word field within an object instance. )
: STOREWFIELD, ( x -- )  RDX POP  DX targetVoc@ class# [RAX] MOV  DROP, ;
( Inserts code to store the contents of a double-word field within an object instance. )
: STOREDFIELD, ( x -- )  RDX POP  EDX targetVoc@ class# [RAX] MOV  DROP, ;
( Inserts code to store the contents of a quad-word field within an object instance. )
: STOREQFIELD, ( x -- )  targetVoc@ class# [RAX] POP  DROP, ;

=== Object and Class Management ===

( Inserts code to allocate a block of memory of u bytes and return its address a. )
: ALLOC, ( u -- a )  depth dup >r ADP+
  SAVE,  1 ADP-  # RAX MOV  "allocate" getTargetWord &# CALL  r> 1- ADP-  nolink ;

=== Exception Handling ===

: TRY, ( a -- [&h] )  dup >A  &# RDX MOV  CELL # R10 SUB  RDX 0 [R10] MOV
  EXCEPT.@HCODE [RDX] RCX MOV  RCX RCX TEST  0= IF  EXCEPT.@CCODE [RDX] RCX MOV  RCX RCX TEST  0= IF
  EXCEPT.@RCODE [RDX] RCX MOV  THEN  THEN
  RCX EXCEPT.NEXT [RDX] MOV  RSP EXCEPT.REFPSP [RDX] MOV  RBP EXCEPT.REFRSP [RDX] MOV
  RCX RCX XOR  RCX EXCEPT.CURRENT [RDX] MOV  RCX EXCEPT.FLAGS [RDX] MOV  nolink ;
: CATCH, ( [&h] -- [&h] )  A@ &here over EXCEPT.@HCODE &+ REL.ABS64 reloc,
  &# RDX MOV  EXCEPT.@CCODE [RDX] RCX MOV  RCX RCX TEST  0= IF  EXCEPT.@RCODE [RDX] RCX MOV  THEN
  RCX EXCEPT.NEXT [RDX] MOV  EXCEPT.CURRENT [RDX] RCX MOV
  RCX RCX TEST  0= IF  EXCEPT.NEXT [RDX] JMP  THEN  nolink ;
: FINALLY, ( [&h] -- [&h] )  A@ &here over EXCEPT.@CCODE &+ REL.ABS64 reloc,
  &# RDX MOV  EXCEPT.@RCODE [RDX] RCX MOV  RCX EXCEPT.NEXT [RDX] MOV
  EXCEPT_BLOCKED # QWORD PTR EXCEPT.FLAGS [RDX] BTS  nolink ;
: RESUME, ( [&h] -- )  A> &here over EXCEPT.@RCODE &+ REL.ABS64 reloc,
  &# RDX MOV  EXCEPT_CONSUMED # QWORD PTR EXCEPT.FLAGS [RDX] BT  CY UNLESS  CELL # R10 ADD  THEN
  EXCEPT.CURRENT [RDX] RCX MOV  RCX RCX TEST  0= UNLESS
    RAX PUSH  RCX RAX MOV  "throw" getTargetWord &# CALL  THEN  nolink ;

=== String Handling ===

( Inserts code to push the string address onto the stack. )
: STRING, ( a$ -- a$ [a] )  1 ADP+  there # CALL  1 ADP-  &here >A  nolink ;
( Finishes string insertion. )
: STREND, ( [a] -- )  A> &here REL.REL32 reloc,  SWAP,  nolink ;

=== Linux System Calls ===

( Inserts a Linux system call with one argument, x₁, and result x₀. )
: LINUX-CALL-1, ( x₁ # -- x₀ )  RDI 0 [RSP] XCHG  SYSCALL  RDI POP  nolink ;
( Inserts a Linux system call with two argument, x₁ and x₂, and result x₀. )
: LINUX-CALL-2, ( x₁ x₂ x₃ # -- x₀ )  RDI CELL [RSP] XCHG  RSI 0 [RSP] XCHG  SYSCALL
  RSI POP  RDI POP  nolink ;
( Inserts a Linux system call with three argument, x₁ and x₂, and result x₀. )
: LINUX-CALL-3, ( x₁ x₂ x₃ # -- x₀ )  RDI 2 CELLS [RSP] XCHG  RSI CELL [RSP] XCHG  RDX 0 [RSP] XCHG
  SYSCALL  RDX POP  RSI POP  RDI POP  nolink ;

( Transforms result x into error code #e and false, if negative, otherwise into result x and true. )
: RESULT, ( x -- x t | #e f )
  RAX RAX TEST  0< IF  RAX NEG  STC  THEN  RAX PUSH  CMC  RAX RAX SBB  nolink ;
( Transforms outcome x into error code #e and false, if negative, otherwise just returns true. )
: ERROR, ( x -- t | #e f )
  RAX RAX TEST  0< IF  RAX NEG  RAX PUSH  STC  THEN  CMC  RAX RAX SBB  nolink ;

=== Block Operations ===

( Fills byte buffer of length # at address a with c. )
: CFILL, ( a # c -- )  RCX POP  0 [RSP] RDI XCHG  REP BYTE STOS  nolink ;
( Fills word buffer of length # at address a with w. )
: WFILL, ( a # w -- )  RCX POP  0 [RSP] RDI XCHG  REP WORD STOS  nolink ;
( Fills double-word buffer of length # at address a with d. )
: DFILL, ( a # d -- )  RCX POP  0 [RSP] RDI XCHG  REP DWORD STOS  nolink ;
( Fills quad-word buffer of length # at address a with q. )
: QFILL, ( a # q -- )  RCX POP  0 [RSP] RDI XCHG  REP QWORD STOS  nolink ;

=== Short String Operations ===

( Returns address a and ength # of short string a$. )
: COUNT, ( a$ -- a # )  BYTE PTR 1 [RAX] RDX MOV  RDX PUSH  RAX INC  nolink ;
( Appends unsigned byte c to counted string in buffer at a$. )
: CAPPEND$, ( c a$ -- )
  BYTE PTR 0 [RAX] INC  BYTE PTR 0 [RAX] RCX MOVZX  RDX POP  DL 1 [RAX] [RCX] MOV  nolink ;

=== UTF8 ===

( Converts unicode character uc to UTF8 representation utf8 on the stack. )
: TOUTF8, ( uc -- utf8 )  128 u# RAX CMP  0< UNLESS
  RDX RDX XOR  %1000000 u# RCX MOV
  BEGIN  1 # CH SHR  8 # RDX SHL  AL DL MOV  %111111 u# DL AND  %10000000 u# DL OR  6 # RAX SHR
  RCX RAX CMP  U< UNTIL  CL CH MOV  CL NOT  CH DEC  CH CL XOR  CL AL OR   8 # RDX SHL  AL DL MOV
  op#@ . RDX RAX MOV  op#@ . THEN  op#@ . nolink  op#@ . ;

=== Blocks and Loops ===

: BEGIN,  BEGIN  nolink ;
: END,  END  nolink ;
: AGAIN,  AGAIN  nolink ;
: UNTIL,  RAX RAX TEST  RAX POP  0- UNTIL  nolink ;
: ASLONG,  RAX RAX TEST  RAX POP  0- ASLONG  nolink ;
: WHILE,  RAX RAX TEST  RAX POP  0- WHILE  nolink ;
: REPEAT,  REPEAT  nolink ;
: DO,  RAX RCX MOV  RDX POP  RAX POP  RCX RDX CMP  > IF
  16 [RBP] RBP LEA  RCX -16 [RBP] MOV  RDX -8 [RBP] MOV  BEGIN  nolink ;
: UDO,  RAX RCX MOV  RDX POP  RAX POP  RCX RDX CMP  U> IF
  16 [RBP] RBP LEA  RCX -16 [RBP] MOV  RDX -8 [RBP] MOV  BEGIN  nolink ;
: DODOWN,  RAX RCX MOV  RDX POP  RAX POP  RDX RCX CMP  > IF
  16 [RBP] RBP LEA  RCX -16 [RBP] MOV  RDX -8 [RBP] MOV  BEGIN  nolink ;
: LOOP,  QWORD PTR -CELL [RBP] INC  LOOPPARA,  RCX RDX CMP  = UNTIL  2RDROP,  THEN  nolink ;

=== Conditional Expressions ===

: ELSE,  ELSE  nolink ;
: THEN,  THEN  nolink ;

: IF,  RAX RAX TEST  RAX POP  0- IF  nolink ;
: UNLESS,  RAX RAX TEST  RAX POP  0- UNLESS  nolink ;
: IFEVER,  RAX RAX TEST  RAX POP  0- IFEVER  nolink ;
: UNLESSEVER,  RAX RAX TEST  RAX POP  0- UNLESSEVER  nolink ;

=== Conditions ===

: ISZERO, ( x -- x=0 )  1 # RAX SUB  RAX RAX SBB  nolink ;
: ISNOTZERO, ( x -- x≠0 )  1 # RAX SUB  CMC  RAX RAX SBB  nolink ;
: ISNEGATIVE, ( x -- x<0 )  1 # RAX SHL  RAX RAX SBB  nolink ;
: ISNOTNEGATIVE, ( x -- x≥0 )  1 # RAX SHL  CMC  RAX RAX SBB  nolink ;
: ISPOSITIVE, ( x -- x>0 )  RAX RAX TEST  AL 0> ?SET  AL RAX MOVZX  RAX NEG  nolink ;
: ISNOTPOSITIVE, ( x -- x≤0 )  RAX RAX TEST  AL 0≤ ?SET  AL RAX MOVZX  RAX NEG  nolink ;

: ISEQUAL, ( x1 x2 -- x1=x2 )  RDX POP  RDX RAX SUB  ISZERO,  nolink ;
: ISNOTEQUAL, ( x1 x2 -- x1≠x2 )  RDX POP  RDX RAX SUB  ISNOTZERO,  nolink ;
: ISLESS, ( n1 n2 -- n1<n2 )  RDX POP  RAX RDX CMP  AL < ?SET  AL NEG  AL RAX MOVSX  nolink ;
: ISNOTLESS, ( n1 n2 -- n1≥n2 )  RDX POP  RAX RDX CMP  AL ≥ ?SET  AL NEG  AL RAX MOVSX  nolink ;
: ISGREATER, ( n1 n2 -- n1>n2 )  RDX POP  RAX RDX CMP  AL > ?SET  AL NEG  AL RAX MOVSX  nolink ;
: ISNOTGREATER, ( n1 n2 -- n1≤n2 )  RDX POP  RAX RDX CMP  AL ≤ ?SET  AL NEG  AL RAX MOVSX  nolink ;
: ISBELOW, ( u1 u2 -- u1<u2 )  RDX POP  RAX RDX CMP  RAX RAX SBB  nolink ;
: ISNOTBELOW, ( u1 u2 -- u1≥u2 )  RDX POP  RAX RDX CMP  CMC  RAX RAX SBB  nolink ;
: ISABOVE, ( u1 u2 -- u1>u2 )  RDX POP  RAX RDX CMP  AL U> ?SET  AL NEG  AL RAX MOVSX  nolink ;
: ISNOTABOVE, ( u1 u2 -- u1≤u2 )  RDX POP  RAX RDX CMP  AL U≤ ?SET  AL NEG  AL RAX MOVSX  nolink ;
: ISWITHIN, ( n1 n2 n3 -- n2≤n1<n3 )  RDX POP  RCX POP  RAX RSI MOV  RAX RAX XOR
  RDX RSI CMP  ≤ IF  RCX RSI CMP  > IF  RAX DEC  THEN  THEN  nolink ;
: ISBETWEEN, ( u1 u2 u3 -- u2≤u1<u3 )  RDX POP  RCX POP  RAX RSI MOV  RAX RAX XOR
  RDX RSI CMP  U≤ IF  RCX RSI CMP  U> IF  RAX DEC  THEN  THEN  nolink ;

: DUPIF, ( x -- [x] x )  RAX RAX TEST  0= UNLESS  RAX PUSH  nolink ;
: DUPUNLESS, ( x -- [x] x )  RAX RAX TEST  0= UNLESS  RAX PUSH  ELSE  nolink ;

=== Conditional Terms ===

--- Likely ---

: IFZERO, ( x -- )  RAX RAX TEST  RAX POP  0= IF  nolink ;
: IFNOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESS  nolink ;
: IFNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< IF  nolink ;
: IFNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESS  nolink ;
: IFPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> IF  nolink ;
: IFNOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESS  nolink ;

: IFEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = IF  nolink ;
: IFNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESS  nolink ;
: IFLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < IF  nolink ;
: IFNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESS  nolink ;
: IFGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > IF  nolink ;
: IFNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESS  nolink ;
: IFBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< IF  nolink ;
: IFNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESS  nolink ;
: IFABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> IF  nolink ;
: IFNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESS  nolink ;

: DUPIFZERO, ( x -- x )  RAX RAX TEST  0= IF  nolink ;
: DUPIFNOTZERO, ( x -- x )  RAX RAX TEST  0= UNLESS  nolink ;
: DUPIFNEGATIVE, ( x -- x )  RAX RAX TEST  0< IF  nolink ;
: DUPIFNOTNEGATIVE, ( x -- x )  RAX RAX TEST  0< UNLESS  nolink ;
: DUPIFPOSITIVE, ( x -- x )  RAX RAX TEST  0> IF  nolink ;
: DUPIFNOTPOSITIVE, ( x -- x )  RAX RAX TEST  0> UNLESS  nolink ;

: DUPIFEQUAL, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  = IF  nolink ;
: DUPIFNOTEQUAL, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  = UNLESS  nolink ;
: DUPIFLESS, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  < IF  nolink ;
: DUPIFNOTLESS, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  < UNLESS  nolink ;
: DUPIFGREATER, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  > IF  nolink ;
: DUPIFNOTGREATER, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  > UNLESS  nolink ;
: DUPIFBELOW, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U< IF  nolink ;
: DUPIFNOTBELOW, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U< UNLESS  nolink ;
: DUPIFABOVE, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U> IF  nolink ;
: DUPIFNOTABOVE, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U> UNLESS  nolink ;

: WHILEZERO, ( x -- )  RAX RAX TEST  RAX POP  0= WHILE  nolink ;
: WHILENOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESS  nolink ;
: WHILENEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< WHILE  nolink ;
: WHILENOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESS  nolink ;
: WHILEPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> WHILE  nolink ;
: WHILENOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESS  nolink ;

: WHILEEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = WHILE  nolink ;
: WHILENOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESS  nolink ;
: WHILELESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < WHILE  nolink ;
: WHILENOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESS  nolink ;
: WHILEGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > WHILE  nolink ;
: WHILENOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESS  nolink ;
: WHILEBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< WHILE  nolink ;
: WHILENOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESS  nolink ;
: WHILEABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> WHILE  nolink ;
: WHILENOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESS  nolink ;

: DUPWHILEZERO, ( x -- )  RAX RAX TEST  0= WHILE  nolink ;
: DUPWHILENOTZERO, ( x -- )  RAX RAX TEST  0= UNLESS  nolink ;
: DUPWHILENEGATIVE, ( x -- )  RAX RAX TEST  0< WHILE  nolink ;
: DUPWHILENOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESS  nolink ;
: DUPWHILEPOSITIVE, ( x -- )  RAX RAX TEST  0> WHILE  nolink ;
: DUPWHILENOTPOSITIVE, ( x -- )  RAX RAX TEST  0> UNLESS  nolink ;

: DUPWHILEEQUAL, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  = WHILE  nolink ;
: DUPWHILENOTEQUAL, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  = UNLESS  nolink ;
: DUPWHILELESS, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  < WHILE  nolink ;
: DUPWHILENOTLESS, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  < UNLESS  nolink ;
: DUPWHILEGREATER, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  > WHILE  nolink ;
: DUPWHILENOTGREATER, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  > UNLESS  nolink ;
: DUPWHILEBELOW, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U< WHILE  nolink ;
: DUPWHILENOTBELOW, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U< UNLESS  nolink ;
: DUPWHILEABOVE, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U> WHILE  nolink ;
: DUPWHILENOTABOVE, ( x₁ x₂ -- x₁ )  RDX POP  RAX RDX CMP  U> UNLESS  nolink ;

: DUPUNTILZERO, ( x -- x )  RAX RAX TEST  0= UNTIL  nolink ;

--- Unlikely ---

: IFEVERZERO, ( x -- )  RAX RAX TEST  RAX POP  0= IFEVER  nolink ;
: IFEVERNOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESSEVER  nolink ;
: IFEVERNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< IFEVER  nolink ;
: IFEVERNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESSEVER  nolink ;
: IFEVERPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> IFEVER  nolink ;
: IFEVERNOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESSEVER  nolink ;

: IFEVEREQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = IFEVER  nolink ;
: IFEVERNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESSEVER  nolink ;
: IFEVERLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < IFEVER  nolink ;
: IFEVERNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESSEVER  nolink ;
: IFEVERGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > IFEVER  nolink ;
: IFEVERNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESSEVER  nolink ;
: IFEVERBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< IFEVER  nolink ;
: IFEVERNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESSEVER  nolink ;
: IFEVERABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> IFEVER  nolink ;
: IFEVERNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESSEVER  nolink ;

: DUPIFEVERZERO, ( x -- )  RAX RAX TEST  0= IFEVER  nolink ;
: DUPIFEVERNOTZERO, ( x -- )  RAX RAX TEST  0= UNLESSEVER  nolink ;
: DUPIFEVERNEGATIVE, ( x -- )  RAX RAX TEST  0< IFEVER  nolink ;
: DUPIFEVERNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESSEVER  nolink ;
: DUPIFEVERPOSITIVE, ( x -- )  RAX RAX TEST  0> IFEVER  nolink ;
: DUPIFEVERNOTPOSITIVE, ( x -- )  RAX RAX TEST  0> UNLESSEVER  nolink ;

: DUPIFEVEREQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  = IFEVER  nolink ;
: DUPIFEVERNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  = UNLESSEVER  nolink ;
: DUPIFEVERLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  < IFEVER  nolink ;
: DUPIFEVERNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  < UNLESSEVER  nolink ;
: DUPIFEVERGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  > IFEVER  nolink ;
: DUPIFEVERNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  > UNLESSEVER  nolink ;
: DUPIFEVERBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U< IFEVER  nolink ;
: DUPIFEVERNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U< UNLESSEVER  nolink ;
: DUPIFEVERABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U> IFEVER  nolink ;
: DUPIFEVERNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U> UNLESSEVER  nolink ;

vocabulary;
