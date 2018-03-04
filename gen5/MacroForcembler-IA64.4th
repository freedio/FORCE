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

: xhpopped A2@ ;
: tryended A1@ ;
: xhstruct A@ ;

( Inserts a call to code referent &c. )
: REFCALL, ( &c -- )  &# CALL ;
( Inserts the ENTER code. )
: ENTER, ( -- )  CELL [RBP] RBP LEA  -CELL [RBP] POP  ENTER+ ;
( Inserts the EXIT code. )
: EXIT, ( -- )  "(next)" getTargetWord &# JMP  EXIT+ ;
( Inserts the alternative EXIT code. )
: EXIT2, ( -- )  -CELL [RBP] PUSH  -CELL [RBP] RBP LEA  RET  EXIT2+ ;
( Inserts the ENTER_FIELD code. )
: ENTER_FIELD, ( -- )  RCX POP  FIELD_ENTER+ ;
( Inserts the EXIT_FIELD code. )
: EXIT_FIELD, ( -- )  RCX PUSH  RET  FIELD_EXIT+ ;

( Sets up the instance variable "me", "my", "this". )
: ENTER_INSTANCE, ( this -- )  CELL [RBP] RBP LEA  RBX -CELL [RBP] MOV  RBX POP ;
( Rstores the previous instance variable. )
: EXIT_INSTANCE, ( -- )  -CELL [RBP] RBX MOV  -CELL [RBP] RBP LEA ;

( Punches a "load int" into the current code. )
: INT, ( x -- )  1 ADP+  RAX PUSH  1 ADP-  # RAX MOV ;
( Punches a "load Unicode char" into the current code. )
: CHAR, ( uc -- )  1 ADP+  RAX PUSH  1 ADP-  # EAX MOV ;
( Punches a "load address" for refrent &r into the current code. )
: ADDR, ( &r -- )  1 ADP+  RAX PUSH  1 ADP-  [] RAX LEA ;

( Returns the cell size. )
: CELL, ( -- cell# )  RAX PUSH  8 # RAX MOV ;
( Adds cell size to x. )
: CELLPLUS, ( x -- x+cell#. )  8 # RAX ADD ;
( Multiplies n by cell size. )
: CELLS, ( n -- u*cell# )  3 # RAX SHL ;
( Adds n cells to x. )
: CELLSPLUS, ( x n -- x+n*cell# )  3 # RAX SHL  RDX POP  RDX RAX ADD ;
( Divides u by the cell size. )
: CELLUBY, ( u -- u/cell# )  3 # RAX SHR ;

: THIS, ( -- @o )  RAX PUSH  RBX RAX MOV ;

( Pushes constant 0. )
: ZERO, ( -- 0 )  RAX PUSH  RAX RAX XOR ;
( Pushes constant 1. )
: ONE, ( -- 0 )  ZERO,  RAX INC ;
( Pushes constant -1. )
: NEGONE, ( -- 0 )  ZERO,  RAX DEC ;
( Pushes a blank. )
: BLANK, ( -- ␣ )  RAX PUSH  20 # RAX MOV ;

( Pushes floating point literal 0.0. )
: 0.0, ( -- :F: -- 0.0 )  FLD0 ;
( Pushes floating point literal 1.0. )
: 1.0, ( -- :F: -- 1.0 )  FLD1 ;
( Pushes floating point literal -1.0. )
: −1.0, ( -- :F: -- −1.0 )  FLD1  FCHS ;
( Pushes floating point literal 10.0. )
: 10.0, ( F: -- 10.0 )  10 # PUSH  WORD PTR 0 [RSP] FILD  CELL [RSP] RSP LEA ;
( Pushes floating point literal π. )
: PI, ( F: -- π )  FLDPI ;

=== Stack Operations ===

--- Parameter Stack Operations ---

( Returns current stack pointer a. )
: GETSP, ( -- a )  RAX PUSH  RSP RAX MOV ;
( Sets the stack pointer to a. )
: SETSP, ( a -- )  RAX RSP MOV  RAX POP ;

( Duplicates top of stack. )
: DUP, ( x -- x x )  RAX PUSH ;
( Drops top of stack. )
: DROP, ( x -- )  RAX POP ;
( Exchanges top and second of stack. )
: SWAP, ( x y -- y x )  0 [RSP] RAX XCHG ;
( Copies second over top of stack. )
: OVER, ( x y -- x y x )  RAX PUSH  CELL [RSP] RAX MOV ;
( Tucks top behind second of stack. )
: TUCK, ( x y -- y x y )  RAX RDX MOV  RDX 0 [RSP] XCHG  RDX PUSH ;
( Drops second of stack. )
: NIP, ( x y -- y )  CELL [RSP] RSP LEA ;
( Replaces second with top of stack. )
: SMASH, ( x y -- y y )  RAX 0 [RSP] MOV ;
( Rotates stack triple up. )
: ROT, ( x₁ x₂ x₃ -- x₂ x₃ x₁ )  0 [RSP] RAX XCHG  CELL [RSP] RAX XCHG ;
( Rotates stack triple down. )
: NEGROT, ( x₁ x₂ x₃ -- x₃ x₁ x₂ )  CELL [RSP] RAX XCHG  0 [RSP] RAX XCHG ;
( Flips the first and third stack entry. )
: FLIP, ( x₁ x₂ x₃ -- x₃ x₂ x₁ )  CELL [RSP] RAX XCHG ;
( Swaps the second and third stack entry. )
: SLIDE, ( x₁ x₂ x₃ -- x₂ x₁ x₃ )  RDX POP  0 [RSP] RDX XCHG  RDX PUSH ;

( Duplicates top stack pair. )
: 2DUP, ( x y -- x y x y )  RAX PUSH  CELL [RSP] PUSH ;
( Drops top of stack pair. )
: 2DROP, ( x y -- )  CELL [RSP] RSP LEA  RAX POP ;
( Swaps top and second of stack pair. )
: 2SWAP, ( x₁ y₁ x₂ y₂ -- x₂ y₂ x₁ y₁ )
  CELL [RSP] RAX XCHG  RDX POP  CELL [RSP] RDX XCHG  RDX PUSH ;
( Copies second of stack pair over top pair. )
: 2OVER, ( x₁ y₁ x₂ y₂ -- x₁ y₁ x₂ y₂ x₁ y₁ )  RAX PUSH  3 CELLS [RSP] PUSH  3 cells [RSP] RAX MOV ;
( Drops second of stack pair. )
: 2NIP, ( x1 y1 x2 y2 -- x2 y2 )  RDX POP  2 CELLS [RSP] RSP LEA  RDX PUSH ;

( Drops u cells. )
: UDROP, ( ... u -- )  0 [RSP] [RAX] *CELL RSP LEA  RAX POP ;
( Picks the uth stack cell. )
: PICK, ( ... u -- ... xu )  0 [RSP] [RAX] *CELL RAX MOV ;
( Rotates u cells on the stack up. )
: ROLL, ( x₁ x₂ ... xu u -- x₂ ... xu x₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR
  BEGIN  RCX DEC  0> WHILE  0 [RSP] [RDX] *CELL RAX XCHG  RDX INC  REPEAT ;
( Rotates u cells on the stack down. )
: NEGROLL, ( x₁ x₂ ... xu u -- x₂ ... xu x₁ )  RAX RCX MOV  RAX POP
  BEGIN  RCX DEC  0> WHILE  -CELL [RSP] [RCX] *CELL RAX XCHG  REPEAT ;

--- Returns Stack Operations ---

( Returns current return stack pointer a. )
: GETRP, ( -- a )  RAX PUSH  RBP RAX MOV ;
( Sets the return stack pointer to a. )
: SETRP, ( a -- )  RAX RBP MOV  RAX POP ;

: RDROP, ( R: x -- )  -CELL [RBP] RBP LEA ;
: RPUSH, ( R: -- x )  CELL [RBP] RBP LEA ;
: RFETCH, ( -- x R: x -- x )  DUP,  -CELL [RBP] RAX MOV ;
: RCOPY, ( x -- x R: -- x )  RPUSH,  RAX -CELL [RBP] MOV ;
: FROMR, ( -- x R: x -- )  RFETCH, RDROP, ;
: TOR, ( x -- R: -- x )  RCOPY,  RAX POP ;
: RDUP, ( R: x -- x x )  -CELL [RBP] RDX MOV  RPUSH,  RDX -CELL [RBP] MOV ;

: LOOPINDEX, ( -- index R: limit index -- limit index )  RFETCH, ;
: LOOPLIMIT, ( -- limit R: limit index -- limit index )   RAX PUSH  -2 CELLS [RBP] RAX MOV ;
: LOOPINDEX2, ( -- index2 R: limit2 index2 limit1 index2 -- limit2 index2 limit1 index2 )
  RAX PUSH  -3 CELLS [RBP] RAX MOV ;
: LOOPLIMIT2, ( -- limit2 R: limit2 index2 limit1 index2 -- limit2 index2 limit1 index2 )
  RAX PUSH  -4 CELLS [RBP] RAX MOV ;
: LOOPPARA, ( -- RDX=limit RCX=index -- R: limit index -- limit index )
  -CELL [RBP] RCX MOV  -2 CELLS [RBP] RDX MOV ;
: 2RDROP, ( R: x x -- )  -2 CELLS [RBP] RBP LEA ;

--- Float Stack Operations ---

( Duplicates top of float stack. )
: FDUP, ( :F: r -- r r )  ST(0) FLD ;
( Drops top of float stack. )
: FDROP, ( :F: r -- )  ST(0) FFREE  FINCSTP ;
( Swaps top and second of float stack. )
: FSWAP, ( :F: r₁ r₂ -- r₂ r₁ )  ST(1) FXCH ;
( Copies second over top of float stack. )
: FOVER, ( :F: r₁ r₂ -- r₁ r₂ r₁ )  ST(1) FLD ;
( Rotates float stack triple. )
: FROT, ( :F: r₁ r₂ r₃ -- r₂ r₃ r₁ )  ST(1) FXCH  ST(2) FXCH ;
( Rotates float stack triple backwards. )
: FNEGROT, ( :F: r₁ r₂ r₃ -- r₃ r₁ r₂ )  ST(2) FXCH  ST(1) FXCH ;

( Duplicates pair of floats. )
: F2DUP, ( :F: r₁ r₂ -- r₁ r₂ r₁ r₂ )  ST(1) FLD  ST(1) FLD ;

--- Exception Handler Stack ---

( Sets the exception handler stack pointer to a. )
: SETEX, ( a -- )  RAX R10 MOV  RAX POP ;
( Returns current exception handler stack pointer a. )
: GETEX, ( -- a )  RAX PUSH  R10 RAX MOV ;
( Pops the current exception handler from the exception handler stack. )
: POPEX, ( -- a )  CELL # R10 ADD ;

=== Arithemtic Operations ===

--- Integer Arithemtics ---

( Adds y to x. )
: PLUS, ( x y -- x+y )  RDX POP  RDX RAX ADD ;
( Subtracts y from x. )
: MINUS, ( x y -- x−y )  RAX 0 [RSP] SUB  RAX POP ;
( Subtracts x from y. )
: RMINUS, ( x y -- y−x )  RDX POP  RDX RAX SUB ;
( Multiplies n₁ with n₂. )
: TIMES, ( n₁ n₂ -- n₁×n₂ )  RDX POP  RDX IMUL ;
( Multiplies u₁ with u₂. )
: UTIMES, ( u₁ u₂ -- u₁×u₂ )  RDX POP  RDX MUL ;
( Divides n₁ through n₂. )
: THROUGH, ( n₁ n₂ -- n₁÷n₂ )  RCX POP  CQO  RCX IDIV ;
( Divides n₂ through n₁. )
: RTHROUGH, ( n₁ n₂ -- n₂÷n₁ )  RAX RCX MOV  RAX POP  CQO  RCX IDIV ;
( Divides u₁ through u₂. )
: UTHROUGH, ( u₁ u₂ -- u₁÷u₂ )  RCX POP  RDX RDX XOR  RCX DIV ;
( Divides u₂ through u₁. )
: URTHROUGH, ( u₁ u₂ -- u₂÷u₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR  RCX DIV ;
( Calculates the rest of the integer division n₁ through n₂. )
: MOD, ( n₁ n₂ -- n₁%n₂ )  RCX POP  CQO  RCX IDIV  RDX RAX MOV ;
( Calculates the rest of the integer division n₂ through n₁. )
: RMOD, ( n₁ n₂ -- n₂%n₁ )  RAX RCX MOV  RAX POP  CQO  RCX IDIV  RDX RAX MOV ;
( Calculates the rest of the integer division u₁ through u₂. )
: UMOD, ( u₁ u₂ -- u₁%u₂ )  RCX POP  RDX RDX XOR  RCX DIV  RDX RAX MOV ;
( Calculates the rest of the integer division u₂ through u₁. )
: URMOD, ( u₁ u₂ -- u₂%u₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR  RCX IDIV  RDX RAX MOV ;
( Calculates the quotient and rest of the integer division n₁ through n₂. )
: MODTHROUGH, ( n₁ n₂ -- n₁%n₂ n₁÷n₂ )  RCX POP  CQO  RCX IDIV  RDX PUSH ;
( Calculates the quotient and rest of the integer division n₂ through n₁. )
: RMODTHROUGH, ( n₁ n₂ -- n₂%n₁ n₂÷n₁ )  RAX RCX MOV  RAX POP  CQO  RCX IDIV  RDX PUSH ;
( Calculates the quotient and rest of the integer division u₁ through u₂. )
: UMODTHROUGH, ( u₁ u₂ -- u₁%u₂ u₁÷u₂ )  RCX POP  RDX RDX XOR  RCX DIV  RDX PUSH ;
( Calculates the quotient and rest of the integer division u₂ through u₁. )
: URMODTHROUGH, ( u₁ u₂ -- u₂%u₁ u₂÷u₁ )  RAX RCX MOV  RAX POP  RDX RDX XOR  RCX IDIV  RDX PUSH ;

( Increments x by 1. )
: INC, ( x -- x+1 )  RAX INC ;
( Decrements x by 1. )
: DEC, ( x -- x−1 )  RAX DEC ;

( Increments second of stack. )
: INCS, ( x₁ x₂ -- x₁+1 x₂ )  CELL PTR 0 [RSP] INC ;
( Advances cursor of buffer with address a and lenght # by u bytes. )
: ADV, ( a # u -- a+u #-u )  RAX 0 [RSP] SUB  RAX CELL [RSP] ADD  RAX POP ;

( Negatea top of stack. )
: NEG, ( n -- −n )  RAX NEG ;
( Returns the absolute value of top of stack. )
: ABS, ( n -- |n| )  RAX RAX TEST  0< IF  RAX NEG  THEN ;
( Selects the lesser of two signed numbers. )
: MIN2, ( n1 n2 -- n3 )  RDX POP  RAX RDX CMP  < IF  RDX RAX MOV  THEN ;
( Selects the greater of two signed numbers. )
: MAX2, ( n1 n2 -- n3 )  RDX POP  RAX RDX CMP  > IF  RDX RAX MOV  THEN ;
( Selects the lesser of two unsigned numbers. )
: UMIN2, ( u1 u2 -- u3 )  RDX POP  RAX RDX CMP  U< IF  RDX RAX MOV  THEN ;
( Selects the greater of two unsigned numbers. )
: UMAX2, ( u1 u2 -- u3 )    RDX POP  RAX RDX CMP  U> IF  RDX RAX MOV  THEN ;
( Returns size # in bytes of n.  Note that size of n=0 will be reported as 0, so to get at least 1,
  use "nsize 1 max" )
: NSIZE, ( n -- n # )  RAX PUSH  ABS,  RAX RAX BSR  0= UNLESS  3 # RAX SHR  RAX INC  THEN ;
( Returns size # in bytes of u.  See note on NSIZE, )
: USIZE, ( u -- u # )  RAX PUSH  RAX RAX BSR  0= UNLESS  3 # RAX SHR  RAX INC  THEN ;

=== Floating Point Operations ===

: FADD, ( F: f1 f2 -- f1+f2 )  FADDP ;
: FIADD, ( i -- F: f -- f+i )  RAX PUSH  DWORD PTR 0 [RSP] FIADD  CELL # RSP ADD  RAX POP ;
: FSUB, ( F: f1 f2 -- f1-f2 )  FSUBP ;
: FISUB, ( i -- F: f -- f-i )  RAX PUSH  DWORD PTR 0 [RSP] FISUB  CELL # RSP ADD  RAX POP ;
: FSUBR, ( F: f1 f2 -- f2-f1 )  FSUBRP ;
: FISUBR, ( i -- F: f -- i-f )  RAX PUSH  DWORD PTR 0 [RSP] FISUBR  CELL # RSP ADD  RAX POP ;

--- Multiply and Divide ---

: FMPY, ( F: f1 f2 -- f1*f2 )  FMULP ;
: FIMPY, ( i -- F: f -- f*i )  RAX PUSH  DWORD PTR 0 [RSP] FIMUL  CELL # RSP ADD  RAX POP ;
: FDIV, ( F: f1 f2 -- f1/f2 )  FDIVP ;
: FIDIV, ( i -- F: f -- f/i )  RAX PUSH  DWORD PTR 0 [RSP] FIDIV  CELL # RSP ADD  RAX POP ;
: FDIVR, ( F: f1 f2 -- f2/f1 )  FDIVRP ;
: FIDIVR, ( i -- F: f -- i/f )  RAX PUSH  DWORD PTR 0 [RSP] FIDIVR  CELL # RSP ADD  RAX POP ;

--- Negate, absolute value, min, max, ... ---

: FNEG, ( F: f -- -f )  FCHS ;
: FABS, ( F: f -- |f| )  FABS ;
: FMIN2, ( F: f1 f2 -- f1|f2 )  ST(1) FCOMI  U< IF  ST(1) FSTP  ELSE  FDROP,  THEN ;
: FMAX2, ( F: f1 f2 -- f1|f2 )  ST(1) FCOMI  U< UNLESS  ST(1) FSTP  ELSE  FDROP,  THEN ;

--- Floating Point Comparisons ---

: FISZERO, ( -- f=0.0 |F: f -- )  RAX PUSH  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %01000000 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNOTZERO, ( -- f≠0.0 |F: f -- )  RAX PUSH  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %01000000 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNEGATIVE, ( -- f<0.0 |F: f -- )  RAX PUSH  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %00000001 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNOTNEGATIVE, ( -- f≥0.0 |F: f -- )  RAX PUSH  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  %00000001 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX ;
: FISPOSITIVE, ( -- f>0.0 |F: f -- )  RAX PUSH  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  AH AH TEST  0= IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNOTPOSITIVE, ( -- f>0.0 |F: f -- )  RAX PUSH  FTST  AX FSTSW  RDROP,
  %0100011100000000 # AX AND  AH AH TEST  0- IF  AL DEC  THEN  AL RAX MOVSX ;

: FISEQUAL, ( -- f1=f2 |F: f1 f2 -- )  RAX PUSH  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %01000000 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNOTEQUAL, ( -- f1=f2 |F: f1 f2 -- )  RAX PUSH  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %01000000 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX ;
: FISLESS, ( -- f1<f2 |F: f1 f2 -- )  RAX PUSH  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  AH AH TEST  0= IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNOTLESS, ( -- f1≥f2 |F: f1 f2 -- )  RAX PUSH  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  AH AH TEST  0- IF  AL DEC  THEN  AL RAX MOVSX ;
: FISGREATER, ( -- f1>f2 |F: f1 f2 -- )  RAX PUSH  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %00000001 # AH CMP  0= IF  AL DEC  THEN  AL RAX MOVSX ;
: FISNOTGREATER, ( -- f1≤f2 |F: f1 f2 -- )  RAX PUSH  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  %00000001 # AH CMP  0- IF  AL DEC  THEN  AL RAX MOVSX ;
: FISWITHIN, ( -- flow≤f<fhigh -- f flow fhigh -- )  RAX PUSH  ST2 FLD  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  00000001 # AH CMP  0= IF  AL DEC  THEN  AL BL MOV  FUCOMPP  AX FSTSW
  %0100011100000000 # AX AND  00000001 # AH CMP  0= IF  BL INC  THEN  BL RAX MOVSX ;

=== Logical Operations ===

( Conjoins two stack cells x1 and x2 giving x3. )
: AND, ( x1 x2 -- x3 )  RDX POP  RDX RAX AND ;
( Bijoins two stack cells x1 and x2 giving x3. )
: OR, ( x1 x2 -- x3 )  RDX POP  RDX RAX OR ;
( Disjoins two stack cells x1 and x2 giving x3. )
: XOR, ( x1 x2 -- x3 )  RDX POP  RDX RAX XOR ;
( Complements stack cell x1. )
: NOT, ( x1 -- ¬x1 )  RAX NOT ;

( Shifts u logically left by # bits. )
: SHL, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX SHL ;
( Shifts u logically right by # bits. )
: SHR, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX SHR ;
( Shifts n arithmetically left by # bits. )
: SAL, ( n # -- n' )  RAX RCX MOV  RAX POP  CL RAX SAL ;
( Shifts n arithmetically right by # bits. )
: SAR, ( n # -- n' )  RAX RCX MOV  RAX POP  CL RAX SAR ;

=== Memory Operations ===

( Returns signed byte b at address a. )
: BFETCH, ( a -- c )  BYTE PTR 0 [RAX] RAX MOVSX ;
( Returns unsigned byte c at address a. )
: CFETCH, ( a -- c )  BYTE PTR 0 [RAX] RAX MOVZX ;
( Returns signed word s at address a. )
: SFETCH, ( a -- s )  WORD PTR 0 [RAX] RAX MOVSX ;
( Returns unsigned word w at address a. )
: WFETCH, ( a -- w )  WORD PTR 0 [RAX] RAX MOVZX ;
( Returns signed double-word i at address a. )
: IFETCH, ( a -- s )  DWORD PTR 0 [RAX] RAX MOVSXD ;
( Returns unsigned double-word d at address a. )
: DFETCH, ( a -- d )  DWORD PTR 0 [RAX] EAX MOV ;
( Returns signed quad-word l at address a. )
: LFETCH, ( a -- l )  0 [RAX] RAX MOV ;
( Returns unsigned quad-word q at address a. )
: QFETCH, ( a -- q )  0 [RAX] RAX MOV ;
( Returns signed oct-word h at address a. )
: HFETCH, ( a -- h )  CELL [RAX] PUSH  0 [RAX] RAX MOV ;
( Returns unsigned quad-word q at address a. )
: OFETCH, ( a -- d )  CELL [RAX] PUSH  0 [RAX] RAX MOV ;

( Returns signed byte b at address a and post-increments. )
: BFETCHINC, ( a -- a+1 c )  1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RAX] RAX MOVSX ;
( Returns unsigned byte c at address a and post-increments. )
: CFETCHINC, ( a -- a+1 c )  1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RAX] RAX MOVZX ;
( Returns signed word s at address a and post-increments. )
: SFETCHINC, ( a -- a+2 s )  2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RAX] RAX MOVSX ;
( Returns unsigned word w at address a and post-increments. )
: WFETCHINC, ( a -- a+2 w )  2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RAX] RAX MOVZX ;
( Returns signed double-word i at address a and post-increments. )
: IFETCHINC, ( a -- a+4 s )  4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RAX] RAX MOVSXD ;
( Returns unsigned double-word d at address a and post-increments. )
: DFETCHINC, ( a -- a+4 d )  4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RAX] EAX MOV ;
( Returns signed quad-word l at address a and post-increments. )
: LFETCHINC, ( a -- a+8 l )  8 [RAX] RDX LEA  RDX PUSH  0 [RAX] RAX MOV ;
( Returns unsigned quad-word q at address a and post-increments. )
: QFETCHINC, ( a -- a+8 q )  8 [RAX] RDX LEA  RDX PUSH  0 [RAX] EAX MOV ;
( Returns signed oct-word h at address a and post-increments. )
: HFETCHINC, ( a -- a+16 h )  16 [RAX] RDX LEA  RDX PUSH  CELL [RAX] PUSH  0 [RAX] RAX MOV ;
( Returns unsigned quad-word q at address a and post-increments. )
: OFETCHINC, ( a -- a+16 d )  16 [RAX] RDX LEA  RDX PUSH  CELL [RAX] PUSH  0 [RAX] RAX MOV ;

( Returns signed byte b at address a and post-increments. )
: DECBFETCH, ( a -- a+1 c )  -1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RDX] RAX MOVSX ;
( Returns unsigned byte c at address a and post-increments. )
: DECCFETCH, ( a -- a+1 c )  -1 [RAX] RDX LEA  RDX PUSH  BYTE PTR 0 [RDX] RAX MOVZX ;
( Returns signed word s at address a and post-increments. )
: DECSFETCH, ( a -- a+2 s )  -2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RDX] RAX MOVSX ;
( Returns unsigned word w at address a and post-increments. )
: DECWFETCH, ( a -- a+2 w )  -2 [RAX] RDX LEA  RDX PUSH  WORD PTR 0 [RDX] RAX MOVZX ;
( Returns signed double-word i at address a and post-increments. )
: DECIFETCH, ( a -- a+4 s )  -4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RDX] RAX MOVSXD ;
( Returns unsigned double-word d at address a and post-increments. )
: DECDFETCH, ( a -- a+4 d )  -4 [RAX] RDX LEA  RDX PUSH  DWORD PTR 0 [RDX] EAX MOV ;
( Returns signed quad-word l at address a and post-increments. )
: DECLFETCH, ( a -- a+8 l )  -8 [RAX] RDX LEA  RDX PUSH  0 [RDX] RAX MOV ;
( Returns unsigned quad-word q at address a and post-increments. )
: DECQFETCH, ( a -- a+8 q )  -8 [RAX] RDX LEA  RDX PUSH  0 [RDX] EAX MOV ;
( Returns signed oct-word h at address a and post-increments. )
: DECHFETCH, ( a -- a+16 h )  -16 [RAX] RDX LEA  RDX PUSH  CELL [RDX] PUSH  0 [RDX] RAX MOV ;
( Returns unsigned quad-word q at address a and post-increments. )
: DECOFETCH, ( a -- a+16 d )  -16 [RAX] RDX LEA  RDX PUSH  CELL [RDX] PUSH  0 [RDX] RAX MOV ;

( Sets byte at address a to the LSB8 of c. )
: CSTORE, ( c a -- )  RDX POP  DL 0 [RAX] MOV  RAX POP ;
( Sets word at address a to the LSB16 of w. )
: WSTORE, ( w a -- )  RDX POP  DX 0 [RAX] MOV  RAX POP ;
( Sets double-word at address a to the LSB32 of d. )
: DSTORE, ( d a -- )  RDX POP  EDX 0 [RAX] MOV  RAX POP ;
( Sets quad-word at address a to the LSB32 of q. )
: QSTORE, ( q a -- )  0 [RAX] POP  RAX POP ;
( Sets oct-word at address a to the LSB64 of o. )
: OSTORE, ( o a -- )  0 [RAX] POP  CELL [RAX] POP  RAX POP ;

( Sets byte at address a to the LSB8 of c and post-increments. )
: CSTOREINC, ( c a -- a+1 )  RDX POP  DL 0 [RAX] MOV  RAX INC ;
( Sets word at address a to the LSB16 of w and post-increments. )
: WSTOREINC, ( w a -- a+2 )  RDX POP  DX 0 [RAX] MOV  2 # RAX ADD ;
( Sets double-word at address a to the LSB32 of d and post-increments. )
: DSTOREINC, ( d a -- a+4 )  RDX POP  EDX 0 [RAX] MOV  4 # RAX ADD ;
( Sets quad-word at address a to the LSB32 of q and post-increments. )
: QSTOREINC, ( q a -- a+8 )  0 [RAX] POP  8 # RAX ADD ;
( Sets oct-word at address a to the LSB64 of o and post-increments. )
: OSTOREINC, ( o a -- a+16 )  0 [RAX] POP  CELL [RAX] POP  16 # RAX ADD ;

( Sets byte at address a to the LSB8 of c and post-increments. )
: STORECINC, ( a c -- a+1 )  RDX POP  AL 0 [RDX] MOV  1 [RDX] RAX LEA ;
( Sets word at address a to the LSB16 of w and post-increments. )
: STOREWINC, ( a w -- a+2 )  RDX POP  AX 0 [RDX] MOV  2 [RDX] RAX LEA ;
( Sets double-word at address a to the LSB32 of d and post-increments. )
: STOREDINC, ( a d -- a+4 )  RDX POP  EAX 0 [RDX] MOV  4 [RDX] RAX LEA ;
( Sets quad-word at address a to the LSB32 of q and post-increments. )
: STOREQINC, ( a q -- a+8 )  RDX POP  RAX 0 [RDX] MOV  8 [RDX] RAX LEA ;
( Sets oct-word at address a to the LSB64 of o and post-increments. )
: STOREOINC, ( a o -- a+16 )
  RCX POP  RDX POP  RAX 0 [RDX] MOV  RCX CELL [RDX] MOV  16 [RDX] RAX LEA ;

( Sets byte at address a to the LSB8 of c after pre-decrements. )
: DECCSTORE, ( a c -- a−1 )  RDX POP  AL -1 [RDX] MOV  -1 [RDX] RAX LEA ;
( Sets word at address a to the LSB16 of w after pre-decrements. )
: DECWSTORE, ( a w -- a−2 )  RDX POP  AX -2 [RDX] MOV  -2 [RDX] RAX LEA ;
( Sets double-word at address a to the LSB32 of d after pre-decrements. )
: DECDSTORE, ( a d -- a−4 )  RDX POP  EAX -4 [RDX] MOV  -4 [RDX] RAX LEA ;
( Sets quad-word at address a to the LSB32 of q after pre-decrements. )
: DECQSTORE, ( a q -- a−8 )  RDX POP  RAX -8 [RDX] MOV  -8 [RDX] RAX LEA ;
( Sets oct-word at address a to the LSB64 of o after pre-decrements. )
: DECOSTORE, ( a o -- a−16 )
  RCX POP  RDX POP  RAX -16 [RDX] MOV  RCX -8 [RDX] MOV  -16 [RDX] RAX LEA ;

( Loads float at address a onto the float stack. )
: FFETCH, ( a -- :F: -- r )  QWORD PTR 0 [RAX] FLD  RAX POP ;

( Stores top of float stack to address a. )
: FSTORE, ( a -- :F: r -- )  QWORD PTR 0 [RAX] FSTP  RAX POP ;

=== Storage Arithmetics ===

( Adds c to byte at address a. )
: CADD, ( c a -- )  RDX POP  BL 0 [RAX] MOV  RAX POP ;
( Adds w to word at address a. )
: WADD, ( w a -- )  RDX POP  BX 0 [RAX] MOV  RAX POP ;
( Adds d to double-word at address a. )
: DADD, ( w a -- )  RDX POP  EBX 0 [RAX] MOV  RAX POP ;
( Adds q to quad-word at address a. )
: QADD, ( q a -- )  QWORD PTR 0 [RAX] POP  RAX POP ;

=== Assertions ===

: ASSERT_TYPE, ( @0 -- @0 :C: &voc )  [] RDX LEA  "!instance" getTargetWord &# CALL ;

=== Definitions ===

( Inserts code to push a variable. )
: DOVAR, ( -- a )  RAX PUSH  targetVoc# §DATA dup #segment# createReferent [] RAX LEA ;
( Inserts code to push a constant. )
: DOCONST, ( -- x )  RAX PUSH  1 ADP-  # RAX MOV ;
( Inserts code to fetch the contents of a signed byte variable. )
: FETCHBVAR, ( -- x )
  RAX PUSH  BYTE PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVSX ;
( Inserts code to fetch the contents of an unsigned byte variable. )
: FETCHCVAR, ( -- x )
  RAX PUSH  BYTE PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVZX ;
( Inserts code to fetch the contents of a signed word variable. )
: FETCHSVAR, ( -- x )
  RAX PUSH  WORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVSX ;
( Inserts code to fetch the contents of an unsigned word variable. )
: FETCHWVAR, ( -- x )
  RAX PUSH  WORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVZX ;
( Inserts code to fetch the contents of a signed double-word variable. )
: FETCHIVAR, ( -- x )
  RAX PUSH  DWORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOVSXD ;
( Inserts code to fetch the contents of an unsigned double-word variable. )
: FETCHDVAR, ( -- x )
  RAX PUSH  DWORD PTR targetVoc# §DATA dup #segment# createReferent [] EAX MOV ;
( Inserts code to fetch the contents of a signed quad-word variable. )
: FETCHLVAR, ( -- x )
  RAX PUSH  QWORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOV ;
( Inserts code to fetch the contents of an unsigned quad-word variable. )
: FETCHQVAR, ( -- x )
  RAX PUSH  QWORD PTR targetVoc# §DATA dup #segment# createReferent [] RAX MOV ;
( Inserts code to store the contents of a byte variable. )
: STORECVAR, ( x -- )  AL targetVoc# §DATA dup #segment# createReferent [] MOV  RAX POP ;
( Inserts code to store the contents of a word variable. )
: STOREWVAR, ( x -- )  AX targetVoc# §DATA dup #segment# createReferent [] MOV  RAX POP ;
( Inserts code to store the contents of a double-word variable. )
: STOREDVAR, ( x -- )  EAX targetVoc# §DATA dup #segment# createReferent [] MOV  RAX POP ;
( Inserts code to store the contents of a quad-word variable. )
: STOREQVAR, ( x -- )  RAX targetVoc# §DATA dup #segment# createReferent [] MOV  RAX POP ;

( Inserts code to address a field within an object instance. )
: DOFIELD, ( -- a )  RAX PUSH  targetVoc@ class# [RBX] RAX LEA ;
( Inserts code to fetch the contents of a signed byte field within an object instance. )
: FETCHBFIELD, ( -- x )  BYTE PTR targetVoc@ class# [RAX] RAX MOVSX ;
( Inserts code to fetch the contents of an unsigned byte field within an object instance. )
: FETCHCFIELD, ( -- x )  BYTE PTR targetVoc@ class# [RAX] RAX MOVZX ;
( Inserts code to fetch the contents of a signed word field within an object instance. )
: FETCHSFIELD, ( -- x )  WORD PTR targetVoc@ class# [RAX] RAX MOVSX ;
( Inserts code to fetch the contents of an unsigned word field within an object instance. )
: FETCHWFIELD, ( -- x )  WORD PTR targetVoc@ class# [RAX] RAX MOVZX ;
( Inserts code to fetch the contents of a signed double-word field within an object instance. )
: FETCHIFIELD, ( -- x )  DWORD PTR targetVoc@ class# [RAX] RAX MOVSXD ;
( Inserts code to fetch the contents of an unsigned double-word field within an object instance. )
: FETCHDFIELD, ( -- x )  DWORD PTR targetVoc@ class# [RAX] EAX MOV ;
( Inserts code to fetch the contents of a signed quad-word field within an object instance. )
: FETCHLFIELD, ( -- x )  QWORD PTR targetVoc@ class# [RAX] RAX MOV ;
( Inserts code to fetch the contents of an unsigned quad-word field within an object instance. )
: FETCHQFIELD, ( -- x )  QWORD PTR targetVoc@ class# [RAX] RAX MOV ;
( Inserts code to store the contents of a byte field within an object instance. )
: STORECFIELD, ( x -- )  RDX POP  DL targetVoc@ class# [RAX] MOV  RAX POP ;
( Inserts code to store the contents of a word field within an object instance. )
: STOREWFIELD, ( x -- )  RDX POP  DX targetVoc@ class# [RAX] MOV  RAX POP ;
( Inserts code to store the contents of a double-word field within an object instance. )
: STOREDFIELD, ( x -- )  RDX POP  EDX targetVoc@ class# [RAX] MOV  RAX POP ;
( Inserts code to store the contents of a quad-word field within an object instance. )
: STOREQFIELD, ( x -- )  targetVoc@ class# [RAX] POP  RAX POP ;

=== Object and Class Management ===

( Inserts code to allocate a block of memory of u bytes and return its address a. )
: ALLOC, ( u -- a )  depth dup >r ADP+
  RAX PUSH  1 ADP-  # RAX MOV  "allocate" getTargetWord &# CALL  r> 1- ADP- ;

=== Exception Handling ===

: TRY, ( a -- [&h] )  dup >A  &# RDX MOV  CELL # R10 SUB  RDX 0 [R10] MOV
  EXCEPT.@HCODE [RDX] RCX MOV  RCX RCX TEST  0= IF  EXCEPT.@CCODE [RDX] RCX MOV  RCX RCX TEST  0= IF
  EXCEPT.@RCODE [RDX] RCX MOV  THEN  THEN
  RCX EXCEPT.NEXT [RDX] MOV  RSP EXCEPT.REFPSP [RDX] MOV  RBP EXCEPT.REFRSP [RDX] MOV
  RCX RCX XOR  RCX EXCEPT.CURRENT [RDX] MOV  RCX EXCEPT.FLAGS [RDX] MOV ;
: CATCH, ( [&h] -- [&h] )  A@ &here over EXCEPT.@HCODE &+ REL.ABS64 reloc,
  &# RDX MOV  EXCEPT.@CCODE [RDX] RCX MOV  RCX RCX TEST  0= IF  EXCEPT.@RCODE [RDX] RCX MOV  THEN
  RCX EXCEPT.NEXT [RDX] MOV  EXCEPT.CURRENT [RDX] RCX MOV
  RCX RCX TEST  0= IF  EXCEPT.NEXT [RDX] JMP  THEN ;
: FINALLY, ( [&h] -- [&h] )  A@ &here over EXCEPT.@CCODE &+ REL.ABS64 reloc,
  &# RDX MOV  EXCEPT.@RCODE [RDX] RCX MOV  RCX EXCEPT.NEXT [RDX] MOV
  EXCEPT_BLOCKED # QWORD PTR EXCEPT.FLAGS [RDX] BTS ;
: RESUME, ( [&h] -- )  A> &here over EXCEPT.@RCODE &+ REL.ABS64 reloc,
  &# RDX MOV  EXCEPT_CONSUMED # QWORD PTR EXCEPT.FLAGS [RDX] BT  CY UNLESS  CELL # R10 ADD  THEN
  EXCEPT.CURRENT [RDX] RCX MOV  RCX RCX TEST  0= UNLESS
    RAX PUSH  RCX RAX MOV  "throw" getTargetWord &# CALL  THEN ;

=== String Handling ===

( Inserts code to push the string address onto the stack. )
: STRING, ( a$ -- a$ [a] )  1 ADP+  there # CALL  1 ADP-  &here >A ;
( Finishes string insertion. )
: STREND, ( [a] -- )  A> &here REL.REL32 reloc,  SWAP, ;

=== UTF-8 ===

( Converts unicode character uc to 8-byte UTF-8 representation uu on the stack [1 cell on a 64-bit
  machines]. )
: TO_UTF8, ( uc -- uu )  128 # RAX CMP  U< UNLESS
  RBX PUSH  RAX RDX MOV  RAX RAX XOR  %100000 # CL MOV  CL RCX MOVZX  %11000000 # BX MOV
  BEGIN  RDX RCX CMP  U≤ WHILE  DL AL MOV  %111111 # AL AND  $80 # AX OR  8 # RAX SHL  6 # RDX SHR
    1 # RCX SHR  1 # BL SAR  REPEAT  DL AL MOV  BL AL OR  THEN ;

=== Blocks and Loops ===

: BEGIN,  BEGIN ;
: END,  END ;
: AGAIN,  AGAIN ;
: UNTIL,  RAX RAX TEST  RAX POP  0- UNTIL ;
: ASLONG,  RAX RAX TEST  RAX POP  0- ASLONG ;
: WHILE,  RAX RAX TEST  RAX POP  0- WHILE ;
: REPEAT,  REPEAT ;
: DO,  RAX RCX MOV  RDX POP  RAX POP  RCX RDX CMP  > IF
  16 [RBP] RBP LEA  RCX -16 [RBP] MOV  RDX -8 [RBP] MOV  BEGIN ;
: UDO,  RAX RCX MOV  RDX POP  RAX POP  RCX RDX CMP  U> IF
  16 [RBP] RBP LEA  RCX -16 [RBP] MOV  RDX -8 [RBP] MOV  BEGIN ;
: DODOWN,  RAX RCX MOV  RDX POP  RAX POP  RDX RCX CMP  > IF
  16 [RBP] RBP LEA  RCX -16 [RBP] MOV  RDX -8 [RBP] MOV  BEGIN ;
: LOOP,  QWORD PTR -CELL [RBP] INC  LOOPPARA,  RCX RDX CMP  = UNTIL  2RDROP,  THEN ;

=== Conditional Expressions ===

: ELSE,  ELSE ;
: THEN,  THEN ;

: IF,  RAX RAX TEST  RAX POP  0- IF ;
: UNLESS,  RAX RAX TEST  RAX POP  0- UNLESS ;
: IFEVER,  RAX RAX TEST  RAX POP  0- IFEVER ;
: UNLESSEVER,  RAX RAX TEST  RAX POP  0- UNLESSEVER ;

=== Conditions ===

: ISZERO, ( x -- x=0 )  1 # RAX SUB  RAX RAX SBB ;
: ISNOTZERO, ( x -- x≠0 )  1 # RAX SUB  CMC  RAX RAX SBB ;
: ISNEGATIVE, ( x -- x<0 )  1 # RAX SHL  RAX RAX SBB ;
: ISNOTNEGATIVE, ( x -- x≥0 )  1 # RAX SHL  CMC  RAX RAX SBB ;
: ISPOSITIVE, ( x -- x>0 )  RAX RAX TEST  AL 0> ?SET  AL RAX MOVZX  RAX NEG ;
: ISNOTPOSITIVE, ( x -- x≤0 )  RAX RAX TEST  AL 0≤ ?SET  AL RAX MOVZX  RAX NEG ;

: ISEQUAL, ( x1 x2 -- x1=x2 )  RDX POP  RDX RAX SUB  ISZERO, ;
: ISNOTEQUAL, ( x1 x2 -- x1≠x2 )  RDX POP  RDX RAX SUB  ISNOTZERO, ;
: ISLESS, ( n1 n2 -- n1<n2 )  RDX POP  RAX RDX CMP  AL < ?SET  AL NEG  AL RAX MOVSX ;
: ISNOTLESS, ( n1 n2 -- n1≥n2 )  RDX POP  RAX RDX CMP  AL ≥ ?SET  AL NEG  AL RAX MOVSX ;
: ISGREATER, ( n1 n2 -- n1>n2 )  RDX POP  RAX RDX CMP  AL > ?SET  AL NEG  AL RAX MOVSX ;
: ISNOTGREATER, ( n1 n2 -- n1≤n2 )  RDX POP  RAX RDX CMP  AL ≤ ?SET  AL NEG  AL RAX MOVSX ;
: ISBELOW, ( u1 u2 -- u1<u2 )  RDX POP  RAX RDX CMP  RAX RAX SBB ;
: ISNOTBELOW, ( u1 u2 -- u1≥u2 )  RDX POP  RAX RDX CMP  CMC  RAX RAX SBB ;
: ISABOVE, ( u1 u2 -- u1>u2 )  RDX POP  RAX RDX CMP  AL U> ?SET  AL NEG  AL RAX MOVSX ;
: ISNOTABOVE, ( u1 u2 -- u1≤u2 )  RDX POP  RAX RDX CMP  AL U≤ ?SET  AL NEG  AL RAX MOVSX ;
: ISWITHIN, ( n1 n2 n3 -- n2≤n1<n3 )  RDX POP  RCX POP  RAX RSI MOV  RAX RAX XOR
  RCX RDX CMP  ≤ IF  RCX RSI CMP  > IF  RAX DEC  THEN  THEN ;
: ISBETWEEN, ( u1 u2 u3 -- u2≤u1<u3 )  RDX POP  RCX POP  RAX RSI MOV  RAX RAX XOR
  RCX RDX CMP  U≤ IF  RCX RSI CMP  U> IF  RAX DEC  THEN  THEN ;
: DUPIF, ( x -- [x] x )  RAX RAX TEST  0= UNLESSEVER  RAX PUSH  THEN ;

=== Conditional Terms ===

--- Likely ---

: IFZERO, ( x -- )  RAX RAX TEST  RAX POP  0= IF ;
: IFNOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESS ;
: IFNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< IF ;
: IFNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESS ;
: IFPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> IF ;
: IFNOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESS ;

: IFEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = IF ;
: IFNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESS ;
: IFLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < IF ;
: IFNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESS ;
: IFGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > IF ;
: IFNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESS ;
: IFBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< IF ;
: IFNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESS ;
: IFABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> IF ;
: IFNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESS ;

: DUPIFZERO, ( x -- )  RAX RAX TEST  0= IF ;
: DUPIFNOTZERO, ( x -- )  RAX RAX TEST  0= UNLESS ;
: DUPIFNEGATIVE, ( x -- )  RAX RAX TEST  0< IF ;
: DUPIFNOTNEGATIVE, ( x -- )  RAX RAX TEST  0< UNLESS ;
: DUPIFPOSITIVE, ( x -- )  RAX RAX TEST  0> IF ;
: DUPIFNOTPOSITIVE, ( x -- )  RAX RAX TEST  0> UNLESS ;

: DUPIFEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  = IF ;
: DUPIFNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  = UNLESS ;
: DUPIFLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  < IF ;
: DUPIFNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  < UNLESS ;
: DUPIFGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  > IF ;
: DUPIFNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  > UNLESS ;
: DUPIFBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U< IF ;
: DUPIFNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U< UNLESS ;
: DUPIFABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U> IF ;
: DUPIFNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U> UNLESS ;

: WHILEZERO, ( x -- )  RAX RAX TEST  RAX POP  0= WHILE ;
: WHILENOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESS ;
: WHILENEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< WHILE ;
: WHILENOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESS ;
: WHILEPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> WHILE ;
: WHILENOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESS ;

: WHILEEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = WHILE ;
: WHILENOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESS ;
: WHILELESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < WHILE ;
: WHILENOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESS ;
: WHILEGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > WHILE ;
: WHILENOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESS ;
: WHILEBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< WHILE ;
: WHILENOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESS ;
: WHILEABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> WHILE ;
: WHILENOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESS ;

--- Unlikely ---

: IFEVERZERO, ( x -- )  RAX RAX TEST  RAX POP  0= IFEVER ;
: IFEVERNOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESSEVER ;
: IFEVERNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< IFEVER ;
: IFEVERNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESSEVER ;
: IFEVERPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> IFEVER ;
: IFEVERNOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESSEVER ;

: IFEVEREQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = IFEVER ;
: IFEVERNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESSEVER ;
: IFEVERLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < IFEVER ;
: IFEVERNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESSEVER ;
: IFEVERGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > IFEVER ;
: IFEVERNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESSEVER ;
: IFEVERBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< IFEVER ;
: IFEVERNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESSEVER ;
: IFEVERABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> IFEVER ;
: IFEVERNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESSEVER ;

: DUPIFEVERZERO, ( x -- )  RAX RAX TEST  0= IFEVER ;
: DUPIFEVERNOTZERO, ( x -- )  RAX RAX TEST  0= UNLESSEVER ;
: DUPIFEVERNEGATIVE, ( x -- )  RAX RAX TEST  0< IFEVER ;
: DUPIFEVERNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP 0< UNLESSEVER ;
: DUPIFEVERPOSITIVE, ( x -- )  RAX RAX TEST  0> IFEVER ;
: DUPIFEVERNOTPOSITIVE, ( x -- )  RAX RAX TEST  0> UNLESSEVER ;

: DUPIFEVEREQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  = IFEVER ;
: DUPIFEVERNOTEQUAL, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  = UNLESSEVER ;
: DUPIFEVERLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  < IFEVER ;
: DUPIFEVERNOTLESS, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  < UNLESSEVER ;
: DUPIFEVERGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  > IFEVER ;
: DUPIFEVERNOTGREATER, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  > UNLESSEVER ;
: DUPIFEVERBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U< IFEVER ;
: DUPIFEVERNOTBELOW, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U< UNLESSEVER ;
: DUPIFEVERABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U> IFEVER ;
: DUPIFEVERNOTABOVE, ( x₁ x₂ -- )  RDX POP  RAX RDX CMP  U> UNLESSEVER ;

vocabulary;
