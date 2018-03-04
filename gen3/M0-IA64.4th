require G0.4th

/* FORCE Base Macros for Intel Generation 6 (64-bit)
 * =================================================
 * version 0

 * The stack comments on the macros show their net effect on the generated code, not their effect
 * when executed, as these macros must not have a stack effect unless otherwise specified.
 */

require A0-IA64.4th
also Forcembler

=== Definitions ===

8 CONSTANT CELL
-8 CONSTANT -CELL
-16 CONSTANT -2CELLS
: CELLS ( n1 -- n2 )  3 << ;
: *CELL  *8 ;
-1 1 u>> CONSTANT maxcellv
-1 CONSTANT mincellv

=== Literals ===

: LIT0, ( 0 -- )  drop  RAX PUSH  RAX RAX XOR ;
: LIT1, ( b -- )  RAX PUSH  1 ADP- # AL MOV  AL RAX MOVSX  1 ADP+ ;
: LIT2, ( s -- )  RAX PUSH  1 ADP- # RAX MOV  1 ADP+ ;
: LIT4, ( i -- )  RAX PUSH  1 ADP- # RAX MOV  1 ADP+ ;
: LIT8, ( l -- )  RAX PUSH  1 ADP-  # RAX MOV  1 ADP+ ;
: LITF, ( -- F: r -- )  there 13 + # CALL  tf,  RDX POP  QWORD PTR CS: 0 [RDX] FLD ;
: LITA, ( @voc @sym -- )  RAX PUSH  0 [] RAX LEA  toff 4- intReloc, ;

=== Stack Operations ===

--- Parameter Stack Operations ---

: DUP, ( x -- x x )  RAX PUSH ;
: DROP, ( x -- )  RAX POP ;
: UDROP, ( ... u -- )  0 [RSP] [RAX] *8 RSP LEA  RAX POP ;
: SWAP, ( x1 x2 -- x2 x1 )  RAX 0 [RSP] XCHG ;
: OVER, ( x1 x2 -- x1 x2 x1 )  RAX PUSH  CELL [RSP] RAX MOV ;
: NIP, ( x1 x2 -- x2 )  CELL # RSP ADD ;
: SMASH, ( x1 x2 -- x1 x1 )  0 [RSP] RAX MOV ;
: TUCK, ( x1 x2 -- x2 x1 x2 )  RAX RDX MOV  RDX 0 [RSP] XCHG  RDX PUSH ;
: ROT, ( x1 x2 x3 -- x2 x3 x1 )  0 [RSP] RAX XCHG  CELL [RSP] RAX XCHG ;
: UNROT, ( x1 x2 x3 -- x3 x1 x2 )  CELL [RSP] RAX XCHG  0 [RSP] RAX XCHG ;
: FLIP, ( x1 x2 x3 -- x3 x2 x1 )  CELL [RSP] RAX XCHG ;
: SLIP, ( x1 x2 x3 -- x2 x1 x3 )  RDX POP  RDX 0 [RSP] XCHG  RDX PUSH ;
: PICK, ( ... u -- x[u] )  0 [RSP] [RAX] *CELL RAX MOV ;
: ROLL, ( x1 x2 ... xu u -- x2 .. xu x1 )  RAX RCX MOV  RAX POP  RBX RBX XOR
  BEGIN  RCX DEC  0> WHILE  0 [RSP] [RBX] *CELL RAX XCHG  RBX INC  REPEAT ;
: UNROLL, ( x1 x2 ... xu u -- xu x1 x2 ... )  RAX RCX MOV  RAX POP
  BEGIN  RCX DEC  0> WHILE  -CELL [RSP] [RCX] *CELL RAX XCHG  REPEAT ;

: 2DUP, ( x y -- x y x y )  RAX PUSH  QWORD PTR CELL [RSP] PUSH ;
: 2DROP, ( x y -- )  CELL # RSP ADD  RAX POP ;
: 2SWAP, ( x1 y1 x2 y2 -- x2 y2 x1 y1 )
  CELL [RSP] RAX XCHG  0 [RSP] RBX MOV  2 CELLS [RSP] RBX XCHG  RBX 0 [RSP] MOV ;
: 2OVER, ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )
  RAX PUSH  QWORD PTR 3 CELLS [RSP] PUSH  3 CELLS [RSP] RAX MOV ;
: 2NIP, ( x1 x2 x3 x4 -- x3 x4 )  RDX POP  2 CELLS # RSP ADD  RDX PUSH ;

: GETSP, ( -- u )  RAX PUSH  RSP RAX MOV  CELL # RAX ADD ;
: SETSP, ( u -- )  RAX RDX MOV  RAX POP  RDX RSP MOV ;

--- Return Stack Operations ---

: GETRP, ( -- a )  RAX PUSH  RBP RAX MOV ;

: RDROP, ( R: x -- )  -CELL [RBP] RBP LEA ;
: RPUSH, ( R: -- x )  CELL [RBP] RBP LEA ;
: RFETCH, ( -- x R: x -- x )  DUP,  -CELL [RBP] RAX MOV ;
: RCOPY, ( x -- x R: -- x )  RPUSH,  RAX -CELL [RBP] MOV ;
: FROMR, ( -- x R: x -- )  RFETCH, RDROP, ;
: TOR, ( x -- R: -- x )  RCOPY,  RAX POP ;
: RDUP, ( R: x -- x x )  -CELL [RBP] RDX MOV  RPUSH,  RDX -CELL [RBP] MOV ;
: ENTER, ( R: -- reta )  RPUSH, QWORD PTR -CELL [RBP] POP ;
: EXIT, ( R: reta -- )  QWORD PTR -CELL [RBP] PUSH  RDROP,  RET ;
: ENTER-METHOD, ( -- )  QWORD PTR 0 [RBX] POP  CELL # RBX ADD ;
: EXIT-METHOD, ( -- )  CELL # RBX SUB ;
: 2EXIT, ( R: reta1 reta2 -- )  RDROP,  -CELL [RBP] PUSH  RDROP,  RET ;
: LOOPINDEX, ( -- index R: limit index -- limit index )  RFETCH, ;
: LOOPLIMIT, ( -- limit R: limit index -- limit index )   RAX PUSH  2 CELLS NEGATE [RBP] RAX MOV ;
: LOOPINDEX2, ( -- index2 R: limit2 index2 limit1 index2 -- limit2 index2 limit1 index2 )
  RAX PUSH  3 CELLS NEGATE [RBP] RAX MOV ;
: LOOPLIMIT2, ( -- limit2 R: limit2 index2 limit1 index2 -- limit2 index2 limit1 index2 )
  RAX PUSH  4 CELLS NEGATE [RBP] RAX MOV ;
: LOOPPARA, ( -- RDX=limit RCX=index -- R: limit index -- limit index )
  -CELL [RBP] RCX MOV  -2CELLS [RBP] RDX MOV ;
: EXXIT, ( R: reta -- )  there # NEAR JMP  there >X ;

: 2RDROP, ( R: x x -- )  -2CELLS [RBP] RBP LEA ;
: 2EXXIT, ( R: reta x -- )  RDROP, EXXIT, ;

--- Object Stack Operations ---

: GETQP, ( -- a )  RAX PUSH  RBX RAX MOV ;

: QDROP, ( Q: x -- )  -CELL [RBX] RBX LEA ;
: QPUSH, ( Q: -- x )  CELL [RBX] RBX LEA ;
: QGET, ( -- x Q: x -- x )  DUP,  -CELL [RBX] RAX MOV ;
: QCOPY, ( x -- x Q: -- x )  QPUSH,  RAX -CELL [RBX] MOV ;
: FROMQ, ( -- x Q: x -- )  QGET, QDROP, ;
: TOQ, ( x -- Q: -- x )  QCOPY,  RAX POP ;
: QDUP, ( Q: x -- x x )  -CELL [RBX] RDX MOV  QPUSH,  RDX -CELL [RBX] MOV ;

--- Floating Point Stack Operations ---

: FDROP, ( F: f -- )  ST(0) FFREE  FINCSTP ;
: FDUP, ( F: f -- f f )  ST0 FLD ;
: FOVER, ( F: f1 f2 -- f2 f2 f1 )  ST1 FLD ;
: F2DUP, ( F: f1 f2 -- f1 f2 f1 f2 )  ST1 FLD  ST1 FLD ;

=== Stack Arithmetic ===

--- Constants ---

: 0, ( -- 0 )  RAX PUSH  RAX RAX XOR ;
: ZERO, ( -- 0 )  0, ;
: ONE, ( -- 1 )  0,  RAX INC ;
: MINUS_ONE, ( -- 1 )  RAX PUSH  STC  RAX RAX SBB ;
: BLANK, ( -- '␣' )  RAX PUSH  $20 # RAX MOV ;

--- Add and Subtract ---

: PLUS1, ( x -- x+1 )  1 # RAX ADD ;
: PLUS2, ( x -- x+2 )  2 # RAX ADD ;
: PLUS4, ( x -- x+4 )  4 # RAX ADD ;
: PLUS8, ( x -- x+8 )  8 # RAX ADD ;
: PLUS16, ( x -- x+10)  16 # RAX ADD ;
: PLUS, ( n x -- x+n )  RDX POP  RDX RAX ADD ;

: NXT, ( x y -- x+1 y )  QWORD PTR 0 [RSP] INC ;

: MINUS1, ( x -- x−1 )  1 # RAX SUB ;
: MINUS2, ( x -- x−2 )  2 # RAX SUB ;
: MINUS4, ( x -- x−4 )  4 # RAX SUB ;
: MINUS8, ( x -- x−8 )  8 # RAX SUB ;
: MINUS16, ( x -- x−10)  16 # RAX SUB ;
: MINUS, ( x1 x2 -- x1−x2 )  RAX 0 [RSP] SUB  RAX POP ;
: RMINUS, ( x1 x2 -- x2−x1 )  RDX POP  RDX RAX SUB ;

--- Multiply and Divide ---

: TIMES, ( n x -- x*n )  RDX POP  RDX IMUL ;
: UTIMES, ( u x -- x*u )  RDX POP  RDX MUL ;
: TEN_TIMES, ( x -- x*10 )  1 # RAX SHL  RAX RDX MOV  2 # RAX SHL  RDX RAX ADD ;

: THROUGH, ( n1 n2 -- n1/n2 )  RCX POP  RCX RAX XCHG  CQO  RCX IDIV ;
: RTHROUGH, ( n1 n2 -- n2/n1 )  RCX POP  CQO  RCX IDIV ;
: MODULO, ( n1 n2 -- n1%n2 )  THROUGH,  RDX RAX MOV ;
: RMODULO, ( n1 n2 -- n2%n1 )  RTHROUGH,  RDX RAX MOV ;
: QUOTREM, ( n1 n2 -- n1%n2 n1/n2 )  THROUGH,  RDX PUSH ;
: RQUOTREM, ( n1 n2 -- n2%n1 n2/n1 )  RTHROUGH,  RDX PUSH ;

: UTHROUGH, ( u1 u2 -- u1/u2 )  RCX POP  RCX RAX XCHG  RDX RDX XOR  RCX DIV ;
: URTHROUGH, ( u1 u2 -- u2/u1 )  RCX POP  RDX RDX XOR  RCX DIV ;
: UMODULO, ( u1 u2 -- u1%u2 )  UTHROUGH,  RDX RAX MOV ;
: URMODULO, ( u1 u2 -- u2%u1 )  URTHROUGH,  RDX RAX MOV ;
: UQUOTREM, ( u1 u2 -- u1%u2 u1/u2 )  UTHROUGH,  RDX PUSH ;
: URQUOTREM, ( u1 u2 -- u2%u1 u2/u1 )  URTHROUGH,  RDX PUSH ;

--- Negate, Absolute, Min, Max, Rounding ---

: NEG, ( n -- −n )  RAX NEG ;
: ABS, ( n -- |n| )  RAX RAX TEST  0< IF  RAX NEG  THEN ;
: MIN2, ( n1 n2 -- n3 )  RDX POP  RAX RDX CMP  < IF  RDX RAX MOV  THEN ;
: UMIN2, ( u1 u2 -- u3 )  RDX POP  RAX RDX CMP  U< IF  RDX RAX MOV  THEN ;
: MAX2, ( n1 n2 -- n3 )  RDX POP  RAX RDX CMP  > IF  RDX RAX MOV  THEN ;
: UMAX2, ( u1 u2 -- u3 )  RDX POP  RAX RDX CMP  U> IF  RDX RAX MOV  THEN ;
: NSIZE, ( n -- n # )  DUP,  RDX RDX XOR  RAX RDX XCHG  RDX RDX TEST  0< IF  RDX NEG  THEN
  0= UNLESS  CY IF  RDX DEC  THEN  RAX INC  7 # RDX SHR  0= UNLESS  1 # RAX SHL
  8 # RDX SHR  0= UNLESS  1 # RAX SHL  16 # RDX SHR  0= UNLESS  1 # RAX SHL  THEN  THEN  THEN THEN ;
: USIZE, ( n -- n # )  DUP,  RDX RDX XOR  RAX RDX XCHG  RDX RDX TEST 0= UNLESS
  RAX INC  8 # RDX SHR  0= UNLESS  1 # RAX SHL  8 # RDX SHR  0= UNLESS  1 # RAX SHL
  16 # RDX SHR  0= UNLESS  1 # RAX SHL  THEN  THEN  THEN  THEN ;

: UROUNDUP, ( u1 u2 -- u1' )  RAX RCX MOV  RAX POP  RDX RDX XOR  -1 [RAX] [RCX] RAX LEA
  RCX DIV  RCX MUL ;
: ARRINDEX, ( u1 u2 u3 -- u )  RDX POP  RDX MUL  RDX POP  RDX RAX ADD ;

--- Conjoin, Bijoin, Disjoin, Clear ---

: AND, ( x1 x2 -- x1&x2 )  RDX POP  RDX RAX AND ;
: OR, ( x1 x2 -- x1|x2 )  RDX POP  RDX RAX OR ;
: XOR, ( x1 x2 -- x1^x2 )  RDX POP  RDX RAX XOR ;
: ANDN, ( x1 x2 -- x1&¬x2 )  RDX POP  RAX NOT  RDX RAX AND ;
: NOT, ( x -- ¬x )  RAX NOT ;
: NORMBOOL, ( x -- 0|-1 )  1 # RAX SUB  CMC  RAX RAX SBB ;

--- Shift and Rotate ---

: SAL, ( n # -- n<<# )  RAX RCX MOV  RAX POP  CL RAX SHL ;
: SHL, ( u # -- u<<# )  RAX RCX MOV  RAX POP  CL RAX SHL ;
: SAR, ( n # -- n>># )  RAX RCX MOV  RAX POP  CL RAX SAR ;
: SHR, ( u # -- u>># )  RAX RCX MOV  RAX POP  CL RAX SHR ;
: ROL, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX ROL ;
: ROR, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX ROR ;
: RCL, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX RCL ;
: RCR, ( u # -- u' )  RAX RCX MOV  RAX POP  CL RAX RCR ;

--- Bit Operations ---

: BT, ( u # -- ? )  RAX RCX MOV  RAX POP  RCX RAX BT  RAX RAX SBB ;
: BTS, ( u # -- u' ? )  RAX 0 [RSP] BTS  RAX RAX SBB ;
: BTR, ( u # -- u' ? )  RAX 0 [RSP] BTR  RAX RAX SBB ;
: BTC, ( u # -- u' ? )  RAX 0 [RSP] BTC  RAX RAX SBB ;
: BS, ( u # -- u' )  RAX 0 [RSP] BTS  RAX POP ;
: BR, ( u # -- u' )  RAX 0 [RSP] BTR  RAX POP ;
: BC, ( u # -- u' )  RAX 0 [RSP] BTC  RAX POP ;

: BSF1, ( u -- # )  RAX RAX BSF  0= IF  STC  RAX RAX SBB  THEN ;
: BSR1, ( u -- # )  RAX RAX BSR  0= IF  STC  RAX RAX SBB  THEN ;
: BSF0, ( u -- # )  RAX NOT  RAX RAX BSF  0= IF  STC  RAX RAX SBB  THEN ;
: CBSF0, ( u -- # )  AL NOT  AL RAX MOVZX  RAX RAX BSF  0= IF  STC  RAX RAX SBB  THEN ;
: BSR0, ( u -- # )  RAX NOT  RAX RAX BSR  0= IF  STC  RAX RAX SBB  THEN ;
: CBSR0, ( c -- # )  AL NOT  AL RAX MOVZX  RAX RAX BSR  0= IF  STC  RAX RAX SBB  THEN ;

: BTIF, ( u # -- u )  RAX RCX MOV  RAX POP  RCX RAX BT  CY IF ;

: BIT, ( # -- u )  AL CL MOV  RAX RAX XOR  RAX INC  CL RAX SHL ;
: BITS, ( u -- p )
  64 # CL MOV  AL CL SUB  CY IF  CL CL XOR  THEN  RAX RAX XOR  RAX DEC  CL RAX SHR ;

=== Floating Point Arithmetic ===

--- Constants ---

: 0.0, ( F: -- 0.0 )  FLD0 ;
: 1.0, ( F: -- 1.0 )  FLD1 ;
: 10.0, ( F: -- 10.0 )  10 # PUSH  WORD PTR 0 [RSP] FILD  CELL # RSP ADD ;
: -1.0, ( F: -- -1.0 )  FLD1  FCHS ;
: PI, ( F: -- π )  FLDPI ;

--- Add and subtract ---

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

=== Comparison and Test ===

--- IF-combinations ---

: ?ISZERO, ( x -- )  backup  RAX RAX TEST  RAX POP  0= ;
: ?ISNOTZERO, ( x -- )  backup  RAX RAX TEST  RAX POP  0≠ ;
: ?ISNEGATIVE, ( x -- )  backup  RAX RAX TEST  RAX POP  0< ;
: ?ISNOTNEGATIVE, ( x -- )  backup  RAX RAX TEST  RAX POP  0≥ ;
: ?ISPOSITIVE, ( x -- )  backup  RAX RAX TEST  RAX POP  0> ;
: ?ISNOTPOSITIVE, ( x -- )  backup  RAX RAX TEST  RAX POP  0≤ ;

: ?ISEQUAL, ( x1 x2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  = ;
: ?ISNOTEQUAL, ( x1 x2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  ≠ ;
: ?ISLESS, ( n1 n2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  < ;
: ?ISNOTLESS, ( n1 n2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  ≥ ;
: ?ISGREATER, ( n1 n2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  > ;
: ?ISNOTGREATER, ( n1 n2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  ≤ ;
: ?ISBELOW, ( u1 u2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  U< ;
: ?ISNOTBELOW, ( u1 u2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  U≥ ;
: ?ISABOVE, ( u1 u2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  U> ;
: ?ISNOTABOVE, ( u1 u2 -- )  backup  RDX POP  RAX RDX CMP  RAX POP  U≤ ;
: ?DUPIF, ( x -- [x] )  backup  RAX RAX TEST  0- IFLIKELY  RAX PUSH  THEN  0≠ ;

: ?ISEQUAL#, ( x1 -- )  backup  RAX POP  = ;
: ?ISNOTEQUAL#, ( x1 -- )  backup  RAX POP  ≠ ;
: ?ISLESS#, ( x1 -- )  backup  RAX POP  < ;
: ?ISNOTLESS#, ( x1 -- )  backup  RAX POP  ≥ ;
: ?ISGREATER#, ( x1 -- )  backup  RAX POP  > ;
: ?ISNOTGREATER#, ( x1 -- )  backup  RAX POP  ≤ ;
: ?ISBELOW#, ( x1 -- )  backup  RAX POP  U< ;
: ?ISNOTBELOW#, ( x1 -- )  backup  RAX POP  U≥ ;
: ?ISABOVE#, ( x1 -- )  backup  RAX POP  U> ;
: ?ISNOTABOVE#, ( x1 -- )  backup  RAX POP  U≤ ;

: ?IF, ( cond -- )  CONDITION @ execute  IF ;
: ?IFLIKELY, ( cond -- )  CONDITION @ execute  IFLIKELY ;
: ?IFUNLIKELY, ( cond -- )  CONDITION @ execute  IFUNLIKELY ;
: ?UNLESS, ( cond -- )  CONDITION @ execute  UNLESS ;
: ?UNLESSLIKELY, ( cond -- )  CONDITION @ execute  UNLESSLIKELY ;
: ?UNLESSUNLIKELY, ( cond -- )  CONDITION @ execute  UNLESSUNLIKELY ;
: ?UNTIL, ( cond -- )  CONDITION @ execute  UNTIL ;
: ?ASLONG, ( cond -- )  CONDITION @ execute  ASLONG ;
: ?WHILE, ( cond -- )  CONDITION @ execute  WHILE ;

: ?DUPIF, ( x -- [x] )  RAX RAX TEST  0= IF  RAX POP  ELSE ;
: ?DUPIFUNLIKELY, ( x -- [x] )  RAX RAX TEST  0= UNLIKELY IF  RAX POP  ELSE ;
: ?DUPUNLESS, ( x -- [x] )  RAX RAX TEST  0= IF  RAX POP ;
: ?DUPUNLESSUNLIKELY, ( x -- [x] )  RAX RAX TEST  0= UNLIKELY IF  RAX POP ;

--- Parameter Stack Operations ---

: ISZERO, ( x -- x=0 )  1 # RAX SUB  RAX RAX SBB  ['] ?ISZERO, CURRENTCOND ! ;
: ISNOTZERO, ( x -- x≠0 )  1 # RAX SUB  CMC  RAX RAX SBB  ['] ?ISNOTZERO, CURRENTCOND ! ;
: ISNEGATIVE, ( x -- x<0 )  1 # RAX SHL  RAX RAX SBB  ['] ?ISNEGATIVE, CURRENTCOND ! ;
: ISNOTNEGATIVE, ( x -- x≥0 )  1 # RAX SHL  CMC  RAX RAX SBB  ['] ?ISNOTNEGATIVE, CURRENTCOND ! ;
: ISPOSITIVE, ( x -- x>0 )
  RAX RAX TEST  AL 0> ?SET  AL RAX MOVZX  RAX NEG  ['] ?ISPOSITIVE, CURRENTCOND ! ;
: ISNOTPOSITIVE, ( x -- x≤0 )
  RAX RAX TEST  AL 0≤ ?SET  AL RAX MOVZX  RAX NEG  ['] ?ISNOTPOSITIVE, CURRENTCOND ! ;

: ISEQUAL, ( x1 x2 -- x1=x2 )  RDX POP  RDX RAX SUB  ISZERO,  ['] ?ISEQUAL, CURRENTCOND ! ;
: ISNOTEQUAL, ( x1 x2 -- x1≠x2 )  RDX POP  RDX RAX SUB  ISNOTZERO,  ['] ?ISNOTEQUAL, CURRENTCOND ! ;
: ISLESS, ( n1 n2 -- n1<n2 )
  RDX POP  RAX RDX CMP  AL < ?SET  AL NEG  AL RAX MOVSX  ['] ?ISLESS, CURRENTCOND ! ;
: ISNOTLESS, ( n1 n2 -- n1≥n2 )
  RDX POP  RAX RDX CMP  AL ≥ ?SET  AL NEG  AL RAX MOVSX  ['] ?ISNOTLESS, CURRENTCOND ! ;
: ISGREATER, ( n1 n2 -- n1>n2 )
  RDX POP  RAX RDX CMP  AL > ?SET  AL NEG  AL RAX MOVSX  ['] ?ISGREATER, CURRENTCOND ! ;
: ISNOTGREATER, ( n1 n2 -- n1≤n2 )
  RDX POP  RAX RDX CMP  AL ≤ ?SET  AL NEG  AL RAX MOVSX  ['] ?ISNOTGREATER, CURRENTCOND ! ;
: ISBELOW, ( u1 u2 -- u1<u2 )  RDX POP  RAX RDX CMP  RAX RAX SBB  ['] ?ISBELOW, CURRENTCOND ! ;
: ISNOTBELOW, ( u1 u2 -- u1≥u2 )
  RDX POP  RAX RDX CMP  CMC  RAX RAX SBB  ['] ?ISNOTBELOW, CURRENTCOND ! ;
: ISABOVE, ( u1 u2 -- u1>u2 )
  RDX POP  RAX RDX CMP  AL U> ?SET  AL NEG  AL RAX MOVSX  ['] ?ISABOVE, CURRENTCOND ! ;
: ISNOTABOVE, ( u1 u2 -- u1≤u2 )
  RDX POP  RAX RDX CMP  AL U≤ ?SET  AL NEG  AL RAX MOVSX  ['] ?ISNOTABOVE, CURRENTCOND ! ;
: ISWITHIN, ( n1 n2 n3 -- n2≤n1<n3 )  RDX POP  RCX POP  RAX RSI MOV  RAX RAX XOR
  RCX RDX CMP  ≤ IFLIKELY  RCX RSI CMP  > IFLIKELY  RAX DEC  THEN  THEN ;
: ISBETWEEN, ( u1 u2 u3 -- u2≤u1<u3 )  RDX POP  RCX POP  RAX RSI MOV  RAX RAX XOR
  RCX RDX CMP  U≤ IFLIKELY  RCX RSI CMP  U> IFLIKELY  RAX DEC  THEN  THEN ;
: DUPIF, ( x -- [x] x )  RAX RAX TEST  0= UNLESSLIKELY  RAX PUSH  THEN  ['] ?DUPIF, CURRENTCOND ! ;

: IFZERO, ( x -- )  RAX RAX TEST  RAX POP  0= IF ;
: IFNOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESS ;
: IFNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< IF ;
: IFNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< UNLESS ;
: IFPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> IF ;
: IFNOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESS ;
: IFEQUAL, ( x1 x2 -- )  RDX POP  RAX RDX CMP  RAX POP  = IF ;
: IFNOTEQUAL, ( x1 x2 -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESS ;
: IFLESS, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  < IF ;
: IFNOTLESS, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESS ;
: IFGREATER, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  > IF ;
: IFNOTGREATER, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  > UNLESS ;
: IFBELOW, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U< IF ;
: IFNOTBELOW, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESS ;
: IFABOVE, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U> IF ;
: IFNOTABOVE, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESS ;

: IFEVERZERO, ( x -- )  RAX RAX TEST  RAX POP  0= IFEVER ;
: IFEVERNOTZERO, ( x -- )  RAX RAX TEST  RAX POP  0= UNLESS ;
: IFEVERNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< IFEVER ;
: IFEVERNOTNEGATIVE, ( x -- )  RAX RAX TEST  RAX POP  0< UNLESS ;
: IFEVERPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> IFEVER ;
: IFEVERNOTPOSITIVE, ( x -- )  RAX RAX TEST  RAX POP  0> UNLESS ;
: IFEVEREQUAL, ( x1 x2 -- )  RDX POP  RAX RDX CMP  RAX POP  = IFEVER ;
: IFEVERNOTEQUAL, ( x1 x2 -- )  RDX POP  RAX RDX CMP  RAX POP  = UNLESS ;
: IFEVERLESS, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  < IFEVER ;
: IFEVERNOTLESS, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  < UNLESS ;
: IFEVERGREATER, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  > IFEVER ;
: IFEVERNOTGREATER, ( n1 n2 -- )  RDX POP  RAX RDX CMP  RAX POP  > IFEVER ;
: IFEVERBELOW, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U< IFEVER ;
: IFEVERNOTBELOW, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U< UNLESS ;
: IFEVERABOVE, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U> IFEVER ;
: IFEVERNOTABOVE, ( u1 u2 -- )  RDX POP  RAX RDX CMP  RAX POP  U> UNLESS ;

: DUPIFZERO, ( x -- x )  RAX RAX TEST  0= IF ;
: DUPIFNOTZERO, ( x -- x )  RAX RAX TEST  0= UNLESS ;
: DUPIFNEGATIVE, ( x -- x )  RAX RAX TEST  0< IF ;
: DUPIFNOTNEGATIVE, ( x -- x )  RAX RAX TEST  0< UNLESS ;
: DUPIFPOSITIVE, ( x -- x )  RAX RAX TEST  0> IF ;
: DUPIFNOTPOSITIVE, ( x -- x )  RAX RAX TEST  0> UNLESS ;
: DUPIFEQUAL, ( x1 x2 -- x1 )  RAX 0 [RSP] CMP  RAX POP  = IF ;
: DUPIFNOTEQUAL, ( x1 x2 -- x1 )  RAX 0 [RSP] CMP  RAX POP  = UNLESS ;
: DUPIFLESS, ( n1 n2 -- n1 )  RAX 0 [RSP] CMP  RAX POP  < IF ;
: DUPIFNOTLESS, ( n1 n2 -- n1 )  RAX 0 [RSP] CMP  RAX POP  < UNLESS ;
: DUPIFGREATER, ( n1 n2 -- n1 )  RAX 0 [RSP] CMP  RAX POP  > IF ;
: DUPIFNOTGREATER, ( n1 n2 -- n1 )  RAX 0 [RSP] CMP  RAX POP  > UNLESS ;
: DUPIFBELOW, ( u1 u2 -- u1 )  RAX 0 [RSP] CMP  RAX POP  U< IF ;
: DUPIFNOTBELOW, ( u1 u2 -- u1 )  RAX 0 [RSP] CMP  RAX POP  U< UNLESS ;
: DUPIFABOVE, ( u1 u2 -- u1 )  RAX 0 [RSP] CMP  RAX POP  U> IF ;
: DUPIFNOTABOVE, ( u1 u2 -- u1 )  RAX 0 [RSP] CMP  RAX POP  U> UNLESS ;

: 2DUPIFEQUAL, ( x1 x2 -- x1 x2 )  RAX 0 [RSP] CMP  = IF ;
: 2DUPIFNOTEQUAL, ( x1 x2 -- x1 x2 )  RAX 0 [RSP] CMP  = UNLESS ;
: 2DUPIFLESS, ( n1 n2 -- n1 n2 )  RAX 0 [RSP] CMP  < IF ;
: 2DUPIFNOTLESS, ( n1 n2 -- n1 n2 )  RAX 0 [RSP] CMP  < UNLESS ;
: 2DUPIFGREATER, ( n1 n2 -- n1 n2 )  RAX 0 [RSP] CMP  > IF ;
: 2DUPIFNOTGREATER, ( n1 n2 -- n1 n2 )  RAX 0 [RSP] CMP  > UNLESS ;
: 2DUPIFBELOW, ( u1 u2 -- u1 u2 )  RAX 0 [RSP] CMP  U< IF ;
: 2DUPIFNOTBELOW, ( u1 u2 -- u1 u2 )  RAX 0 [RSP] CMP  U< UNLESS ;
: 2DUPIFABOVE, ( u1 u2 -- u1 u2 )  RAX 0 [RSP] CMP  U> IF ;
: 2DUPIFNOTABOVE, ( u1 u2 -- u1 u2 )  RAX 0 [RSP] CMP  U> UNLESS ;

--- Floating Point Stack Operations ---

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

=== Memory ===

--- Fetch and Store ---

: BFETCH, ( a -- b )  BYTE PTR 0 [RAX] RAX MOVSX ;
: CFETCH, ( a -- c )  BYTE PTR 0 [RAX] RAX MOVZX ;
: SFETCH, ( a -- s )  WORD PTR 0 [RAX] RAX MOVSX ;
: WFETCH, ( a -- w )  WORD PTR 0 [RAX] RAX MOVZX ;
: IFETCH, ( a -- i )  DWORD PTR 0 [RAX] RAX MOVSXD ;
: DFETCH, ( a -- d )  0 [RAX] EAX MOV ;
: QFETCH, ( a -- l )  0 [RAX] RAX MOV ;
: OFETCH, ( a -- v )  QWORD PTR 0 [RAX] PUSH  CELL [RAX] RAX MOV ;

: CSTORE, ( c a -- )  RDX POP  DL 0 [RAX] MOV  RAX POP ;
: WSTORE, ( w a -- )  RDX POP  DX 0 [RAX] MOV  RAX POP ;
: DSTORE, ( d a -- )  RDX POP  EDX 0 [RAX] MOV  RAX POP ;
: QSTORE, ( q a -- )  QWORD PTR 0 [RAX] POP  RAX POP ;
: OSTORE, ( o a -- )  QWORD PTR 0 [RAX] POP  QWORD PTR CELL [RAX] POP  RAX POP ;

: FETCHINCB, ( a -- a+1 b )  RAX INC  RAX PUSH  BYTE PTR -1 [RAX] RAX MOVSX ;
: FETCHINCC, ( a -- a+1 c )  RAX INC  RAX PUSH  BYTE PTR -1 [RAX] RAX MOVZX ;
: FETCHINCS, ( a -- a+2 s )  PLUS2,  RAX PUSH  WORD PTR -2 [RAX] RAX MOVSX ;
: FETCHINCW, ( a -- a+1 w )  PLUS2,  RAX PUSH  WORD PTR -2 [RAX] RAX MOVZX ;
: FETCHINCI, ( a -- a+4 i )  PLUS4,  RAX PUSH  DWORD PTR -4 [RAX] RAX MOVSXD ;
: FETCHINCD, ( a -- a+4 d )  PLUS4,  RAX PUSH  -4 [RAX] EAX MOV ;
: FETCHINCQ, ( a -- a+8 q )  PLUS8,  RAX PUSH  -8 [RAX] RAX MOV ; alias FETCHINCH,

: DECFETCHB, ( a -- a-1 b )  RAX DEC  RAX PUSH  BYTE PTR 0 [RAX] RAX MOVSX  ;
: DECFETCHC, ( a -- a-1 c )  RAX DEC  RAX PUSH  BYTE PTR 0 [RAX] RAX MOVZX ;
: DECFETCHS, ( a -- a-2 s )  MINUS2,  RAX PUSH  WORD PTR 0 [RAX] RAX MOVSX ;
: DECFETCHW, ( a -- a-2 w )  MINUS2,  RAX PUSH  WORD PTR 0 [RAX] RAX MOVZX ;
: DECFETCHI, ( a -- a-4 i )  MINUS4,  RAX PUSH  DWORD PTR 0 [RAX] RAX MOVSXD ;
: DECFETCHD, ( a -- a-4 d )  MINUS4,  RAX PUSH  0 [RAX] EAX MOV ;
: DECFETCHQ, ( a -- a-8 q )  MINUS8,  RAX PUSH  QWORD PTR 0 [RAX] RAX MOV ; alias DECFETCHH,

: CSTOREINC, ( c a -- a+1 )  RDX POP  DL 0 [RAX] MOV  PLUS1, ;
: WSTOREINC, ( w a -- a+2 )  RDX POP  DX 0 [RAX] MOV  PLUS2, ;
: DSTOREINC, ( d a -- a+4 )  RDX POP  EDX 0 [RAX] MOV  PLUS4, ;
: QSTOREINC, ( q a -- a+8 )  QWORD PTR 0 [RAX] POP  PLUS8, ;
: OSTOREINC, ( o a -- a+16 )  QWORD PTR 0 [RAX] POP  QWORD PTR 8 [RAX] POP  PLUS16, ;

: STOREINCC, ( a c -- a+1 )  RAX RDX MOV  RAX POP  DL 0 [RAX] MOV  PLUS1, ;
: STOREINCW, ( a w -- a+2 )  RAX RDX MOV  RAX POP  DX 0 [RAX] MOV  PLUS2, ;
: STOREINCD, ( a d -- a+4 )  RAX RDX MOV  RAX POP  EDX 0 [RAX] MOV  PLUS4, ;
: STOREINCQ, ( a q -- a+8 )  RDX POP  RAX 0 [RDX] MOV  8 [RDX] RAX LEA ;

: CDECSTORE, ( c a -- a-1 )  RDX POP  MINUS1,  DL 0 [RAX] MOV ;
: WDECSTORE, ( w a -- a-2 )  RDX POP  MINUS2,  DX 0 [RAX] MOV ;
: DDECSTORE, ( d a -- a-4 )  RDX POP  MINUS4, EDX 0 [RAX] MOV ;
: QDECSTORE, ( q a -- a-8 )  MINUS8,  QWORD PTR 0 [RAX] POP ;
: ODECSTORE, ( o a -- a-16 )  MINUS16,  QWORD PTR 0 [RAX] POP  QWORD PTR 8 [RAX] POP ;

: DECSTOREC, ( a c -- a-1 )  RDX POP  RDX DEC  AL 0 [RDX] MOV  RDX RAX MOV ;
: DECSTOREW, ( a w -- a-2 )  RDX POP  2 # RDX SUB  AX 0 [RDX] MOV  RDX RAX MOV ;
: DECSTORED, ( a d -- a-4 )  RDX POP  4 # RDX SUB  EAX 0 [RDX] MOV  RDX RAX MOV ;
: DECSTOREQ, ( a q -- a-8 )  RDX POP  8 # RDX SUB  RAX 0 [RDX] MOV  RDX RAX MOV ;

: CSTOREDEC, ( c a -- a-1 )  RDX POP  DL 0 [RAX] MOV  MINUS1, ;
: WSTOREDEC, ( w a -- a-2 )  RDX POP  DX 0 [RAX] MOV  MINUS2, ;
: DSTOREDEC, ( d a -- a-4 )  RDX POP  EDX 0 [RAX] MOV  MINUS4, ;
: QSTOREDEC, ( q a -- a-8 )  QWORD PTR 0 [RAX] POP  MINUS8, ;
: OSTOREDEC, ( o a -- a-16 )  QWORD PTR 0 [RAX] POP  QWORD PTR 8 [RAX] POP  MINUS16, ;

: XCHG, ( x a -- x' a )  0 [RSP] RDX MOV  0 [RAX] RDX XCHG  RDX 0 [RSP] MOV ;

( Floating Point Transfer )

: FSTORE, ( a -- F: f1 -- )  QWORD PTR 0 [RAX] FSTP  RAX POP ;
: FFETCH, ( a -- F: -- f )  QWORD PTR 0 [RAX] FLD  RAX POP ;

--- Storage Arithmetic ---

( Add and Subtract )

: CADD, ( c a -- )  RDX POP  DL 0 [RAX] ADD  RAX POP ; alias BADD,
: WADD, ( w a -- )  RDX POP  DX 0 [RAX] ADD  RAX POP ; alias SADD,
: DADD, ( d a -- )  RDX POP  EDX 0 [RAX] ADD  RAX POP ; alias IADD,
: QADD, ( q a -- )  RDX POP  RDX 0 [RAX] ADD  RAX POP ; alias LADD, alias ADD,
: OADD, ( o a -- )  RDX POP  RDX 0 [RAX] ADD  0 # QWORD PTR CELL [RAX] ADC  RAX POP ; alias VADD,

: CSUB, ( c a -- )  RDX POP  DL 0 [RAX] SUB  RAX POP ; alias BSUB,
: WSUB, ( w a -- )  RDX POP  DX 0 [RAX] SUB  RAX POP ; alias SSUB,
: DSUB, ( d a -- )  RDX POP  EDX 0 [RAX] SUB  RAX POP ; alias ISUB,
: QSUB, ( q a -- )  RDX POP  RDX 0 [RAX] SUB  RAX POP ; alias LSUB, alias SUB,
: OSUB, ( o a -- )  RDX POP  RDX 0 [RAX] SUB  0 # QWORD PTR CELL [RAX] SBB  RAX POP ; alias VSUB,

: ADDC, ( a c -- )  RDX POP  DL 0 [RAX] ADD  RAX POP ; alias ADDB,
: ADDW, ( a w -- )  RDX POP  DX 0 [RAX] ADD  RAX POP ; alias ADDS,
: ADDD, ( a d -- )  RDX POP  EDX 0 [RAX] ADD  RAX POP ; alias ADDI,
: ADDQ, ( a q -- )  RDX POP  RDX 0 [RAX] ADD  RAX POP ; alias ADDL, alias ADDR,

: SUBC, ( a c -- )  RDX POP  DL 0 [RAX] SUB  RAX POP ; alias SUBB,
: SUBW, ( a w -- )  RDX POP  DX 0 [RAX] SUB  RAX POP ; alias SUBS,
: SUBD, ( a d -- )  RDX POP  EDX 0 [RAX] SUB  RAX POP ; alias SUBI,
: SUBQ, ( a q -- )  RDX POP  RDX 0 [RAX] SUB  RAX POP ; alias SUBL, alias SUBR,

( Multiply and Divide )

: BMPY, ( b a -- )  RAX RCX MOV  RAX POP  BYTE PTR 0 [RCX] IMUL  AL 0 [RCX] MOV  RAX POP ;
: CMPY, ( c a -- )  RAX RCX MOV  RAX POP  BYTE PTR 0 [RCX] MUL  AL 0 [RCX] MOV  RAX POP ;
: SMPY, ( s a -- )  RAX RCX MOV  RAX POP  WORD PTR 0 [RCX] IMUL  AX 0 [RCX] MOV  RAX POP ;
: WMPY, ( w a -- )  RAX RCX MOV  RAX POP  WORD PTR 0 [RCX] MUL  AX 0 [RCX] MOV  RAX POP ;
: IMPY, ( i a -- )  RAX RCX MOV  RAX POP  DWORD PTR 0 [RCX] IMUL  EAX 0 [RCX] MOV  RAX POP ;
: DMPY, ( d a -- )  RAX RCX MOV  RAX POP  DWORD PTR 0 [RCX] MUL  EAX 0 [RCX] MOV  RAX POP ;
: LMPY, ( l a -- )  RAX RCX MOV  RAX POP  QWORD PTR 0 [RCX] IMUL  RAX 0 [RCX] MOV  RAX POP ;
: QMPY, ( q a -- )  RAX RCX MOV  RAX POP  QWORD PTR 0 [RCX] MUL  RAX 0 [RCX] MOV  RAX POP ;

: BDIV, ( b a -- )  RAX RSI MOV  RCX POP  0 [RSI] AX MOVSX  CL IDIV  AL 0 [RSI] MOV  RAX POP ;
: CDIV, ( c a -- )  RAX RSI MOV  RCX POP  0 [RSI] AX MOVZX  CL DIV  AL 0 [RSI] MOV  RAX POP ;
: SDIV, ( s a -- )  RAX RSI MOV  RCX POP  0 [RSI] AX MOV  CWD  CX IDIV  AX 0 [RSI] MOV  RAX POP ;
: WDIV, ( w a -- )
  RAX RSI MOV  RCX POP  0 [RSI] AX MOV  DX DX XOR  CX DIV  AX 0 [RSI] MOV  RAX POP ;
: IDIV, ( i a -- )  RAX RSI MOV  RCX POP  0 [RSI] EAX MOV  CDQ  ECX IDIV  EAX 0 [RSI] MOV  RAX POP ;
: DDIV, ( d a -- )
  RAX RSI MOV  RCX POP  0 [RSI] EAX MOV  EDX EDX XOR  ECX DIV  EAX 0 [RSI] MOV  RAX POP ;
: LDIV, ( l a -- )  RAX RSI MOV  RCX POP  0 [RSI] RAX MOV  CQO  RCX IDIV  RAX 0 [RSI] MOV  RAX POP ;
: QDIV, ( q a -- )
  RAX RSI MOV  RCX POP  0 [RSI] RAX MOV  RDX RDX XOR  RCX DIV  RAX 0 [RSI] MOV  RAX POP ;

: BMOD, ( b a -- )  RAX RSI MOV  RCX POP  0 [RSI] AX MOVSX  CL IDIV  AH 0 [RSI] MOV  RAX POP ;
: CMOD, ( c a -- )  RAX RSI MOV  RCX POP  0 [RSI] AX MOVZX  CL DIV  AH 0 [RSI] MOV  RAX POP ;
: SMOD, ( s a -- )  RAX RSI MOV  RCX POP  0 [RSI] AX MOV  CWD  CX IDIV  DX 0 [RSI] MOV  RAX POP ;
: WMOD, ( w a -- )
  RAX RSI MOV  RCX POP  0 [RSI] AX MOV  DX DX XOR  CX DIV  DX 0 [RSI] MOV  RAX POP ;
: IMOD, ( i a -- )  RAX RSI MOV  RCX POP  0 [RSI] EAX MOV  CDQ  ECX IDIV  EDX 0 [RSI] MOV  RAX POP ;
: DMOD, ( d a -- )
  RAX RSI MOV  RCX POP  0 [RSI] EAX MOV  EDX EDX XOR  ECX DIV  EDX 0 [RSI] MOV  RAX POP ;
: LMOD, ( l a -- )  RAX RSI MOV  RCX POP  0 [RSI] RAX MOV  CQO  RCX IDIV  RDX 0 [RSI] MOV  RAX POP ;
: QMOD, ( q a -- )
  RAX RSI MOV  RCX POP  0 [RSI] RAX MOV  RDX RDX XOR  RCX DIV  RDX 0 [RSI] MOV  RAX POP ;

: MPYB, ( a b -- )  RCX POP  BYTE PTR 0 [RCX] IMUL  AL 0 [RCX] MOV  RAX POP ;
: MPYC, ( a c -- )  RCX POP  BYTE PTR 0 [RCX] MUL  AL 0 [RCX] MOV  RAX POP ;
: MPYS, ( a s -- )  RCX POP  WORD PTR 0 [RCX] IMUL  AX 0 [RCX] MOV  RAX POP ;
: MPYW, ( a w -- )  RCX POP  WORD PTR 0 [RCX] MUL  AX 0 [RCX] MOV  RAX POP ;
: MPYI, ( a i -- )  RCX POP  DWORD PTR 0 [RCX] IMUL  EAX 0 [RCX] MOV  RAX POP ;
: MPYD, ( a d -- )  RCX POP  DWORD PTR 0 [RCX] MUL  EAX 0 [RCX] MOV  RAX POP ;
: MPYL, ( a l -- )  RCX POP  QWORD PTR 0 [RCX] IMUL  RAX 0 [RCX] MOV  RAX POP ;
: MPYQ, ( a q -- )  RCX POP  QWORD PTR 0 [RCX] MUL  RAX 0 [RCX] MOV  RAX POP ;

: DIVB, ( a b -- )  RSI POP  0 [RSI] CL MOV  CBW  CL IDIV  AL 0 [RSI] MOV  RAX POP ;
: DIVC, ( a c -- )  RSI POP  0 [RSI] CL MOV  AH AH XOR  CL DIV  AL 0 [RSI] MOV  RAX POP ;
: DIVS, ( a s -- )  RSI POP  0 [RSI] CX MOV  CWD  CX IDIV  AX 0 [RSI] MOV  RAX POP ;
: DIVW, ( a w -- )  RSI POP  0 [RSI] CX MOV  DX DX XOR  CX DIV  AX 0 [RSI] MOV  RAX POP ;
: DIVI, ( a i -- )  RSI POP  0 [RSI] ECX MOV  CDQ  ECX IDIV  EAX 0 [RSI] MOV  RAX POP ;
: DIVD, ( a d -- )  RSI POP  0 [RSI] ECX MOV  EDX EDX XOR  ECX DIV  EAX 0 [RSI] MOV  RAX POP ;
: DIVL, ( a l -- )  RSI POP  0 [RSI] RCX MOV  CQO  RCX IDIV  RAX 0 [RSI] MOV  RAX POP ;
: DIVQ, ( a q -- )  RSI POP  0 [RSI] RCX MOV  RDX RDX XOR  RCX DIV  RAX 0 [RSI] MOV  RAX POP ;

: MODB, ( a b -- )  RSI POP  0 [RSI] CL MOV  CBW  CL IDIV  AH 0 [RSI] MOV  RAX POP ;
: MODC, ( a c -- )  RSI POP  0 [RSI] CL MOV  AH AH XOR  CL DIV  AH 0 [RSI] MOV  RAX POP ;
: MODS, ( a s -- )  RSI POP  0 [RSI] CX MOV  CWD  CX IDIV  DX 0 [RSI] MOV  RAX POP ;
: MODW, ( a w -- )  RSI POP  0 [RSI] CX MOV  DX DX XOR  CX DIV  DX 0 [RSI] MOV  RAX POP ;
: MODI, ( a i -- )  RSI POP  0 [RSI] ECX MOV  CDQ  ECX IDIV  EDX 0 [RSI] MOV  RAX POP ;
: MODD, ( a d -- )  RSI POP  0 [RSI] ECX MOV  EDX EDX XOR  ECX DIV  EDX 0 [RSI] MOV  RAX POP ;
: MODL, ( a l -- )  RSI POP  0 [RSI] RCX MOV  CQO  RCX IDIV  RDX 0 [RSI] MOV  RAX POP ;
: MODQ, ( a q -- )  RSI POP  0 [RSI] RCX MOV  RDX RDX XOR  RCX DIV  RDX 0 [RSI] MOV  RAX POP ;

( Logical Operations )

: CAND, ( c a -- )  RDX POP  DL 0 [RAX] AND  DROP, ;
: WAND, ( w a -- )  RDX POP  DX 0 [RAX] AND  DROP, ;
: DAND, ( d a -- )  RDX POP  EDX 0 [RAX] AND  DROP, ;
: QAND, ( q a -- )  RDX POP  RDX 0 [RAX] AND  DROP, ;

: COR, ( c a -- )  RDX POP  DL 0 [RAX] OR  DROP, ;
: WOR, ( w a -- )  RDX POP  DX 0 [RAX] OR  DROP, ;
: DOR, ( d a -- )  RDX POP  EDX 0 [RAX] OR  DROP, ;
: QOR, ( q a -- )  RDX POP  RDX 0 [RAX] OR  DROP, ;

: CXOR, ( c a -- )  RDX POP  DL 0 [RAX] XOR  DROP, ;
: WXOR, ( w a -- )  RDX POP  DX 0 [RAX] XOR  DROP, ;
: DXOR, ( d a -- )  RDX POP  EDX 0 [RAX] XOR  DROP, ;
: QXOR, ( q a -- )  RDX POP  RDX 0 [RAX] XOR  DROP, ;

: CANDN, ( c a -- )  RDX POP  DL NOT  DL 0 [RAX] AND  DROP, ;
: WANDN, ( w a -- )  RDX POP  DX NOT  DX 0 [RAX] AND  DROP, ;
: DANDN, ( d a -- )  RDX POP  EDX NOT  EDX 0 [RAX] AND  DROP, ;
: QANDN, ( q a -- )  RDX POP  RDX NOT  RDX 0 [RAX] AND  DROP, ;

: ANDC, ( a c -- )  RDX POP  AL 0 [RDX] AND  DROP, ;
: ANDW, ( a w -- )  RDX POP  AX 0 [RDX] AND  DROP, ;
: ANDD, ( a d -- )  RDX POP  EAX 0 [RDX] AND  DROP, ;
: ANDQ, ( a q -- )  RDX POP  RAX 0 [RDX] AND  DROP, ;

: ORC, ( a c -- )  RDX POP  AL 0 [RDX] OR  DROP, ;
: ORW, ( a w -- )  RDX POP  AX 0 [RDX] OR  DROP, ;
: ORD, ( a d -- )  RDX POP  EAX 0 [RDX] OR  DROP, ;
: ORQ, ( a q -- )  RDX POP  RAX 0 [RDX] OR  DROP, ;

: XORC, ( a c -- )  RDX POP  AL 0 [RDX] XOR  DROP, ;
: XORW, ( a w -- )  RDX POP  AX 0 [RDX] XOR  DROP, ;
: XORD, ( a d -- )  RDX POP  EAX 0 [RDX] XOR  DROP, ;
: XORQ, ( a q -- )  RDX POP  RAX 0 [RDX] XOR  DROP, ;

: NOTC, ( a -- )  BYTE PTR 0 [RAX] NOT  DROP, ;
: NOTW, ( a -- )  WORD PTR 0 [RAX] NOT  DROP, ;
: NOTD, ( a -- )  DWORD PTR 0 [RAX] NOT  DROP, ;
: NOTQ, ( a -- )  QWORD PTR 0 [RAX] NOT  DROP, ;

( Shift Operations )

: BSAL, ( # a -- )  RCX POP  CL BYTE PTR 0 [RAX] SAL  DROP, ;
: BSAR, ( # a -- )  RCX POP  CL BYTE PTR 0 [RAX] SAR  DROP, ;
: CSHL, ( # a -- )  RCX POP  CL BYTE PTR 0 [RAX] SHL  DROP, ;
: CSHR, ( # a -- )  RCX POP  CL BYTE PTR 0 [RAX] SHR  DROP, ;
: SSAL, ( # a -- )  RCX POP  CL WORD PTR 0 [RAX] SAL  DROP, ;
: SSAR, ( # a -- )  RCX POP  CL WORD PTR 0 [RAX] SAR  DROP, ;
: WSHL, ( # a -- )  RCX POP  CL WORD PTR 0 [RAX] SHL  DROP, ;
: WSHR, ( # a -- )  RCX POP  CL WORD PTR 0 [RAX] SHR  DROP, ;
: ISAL, ( # a -- )  RCX POP  CL DWORD PTR 0 [RAX] SAL  DROP, ;
: ISAR, ( # a -- )  RCX POP  CL DWORD PTR 0 [RAX] SAR  DROP, ;
: DSHL, ( # a -- )  RCX POP  CL DWORD PTR 0 [RAX] SHL  DROP, ;
: DSHR, ( # a -- )  RCX POP  CL DWORD PTR 0 [RAX] SHR  DROP, ;
: LSAL, ( # a -- )  RCX POP  CL QWORD PTR 0 [RAX] SAL  DROP, ;
: LSAR, ( # a -- )  RCX POP  CL QWORD PTR 0 [RAX] SAR  DROP, ;
: QSHL, ( # a -- )  RCX POP  CL QWORD PTR 0 [RAX] SHL  DROP, ;
: QSHR, ( # a -- )  RCX POP  CL QWORD PTR 0 [RAX] SHR  DROP, ;
: VSAL, ( # a -- )
  RCX POP  0 [RAX] RDX MOV  CL RDX QWORD PTR CELL [RAX] SHLD  CL QWORD PTR 0 [RAX] SAL  DROP, ;
: VSAR, ( # a -- )
  RCX POP  CELL [RAX] RDX MOV  CL RDX QWORD PTR 0 [RAX] SHRD  CL QWORD PTR CELL [RAX] SAR  DROP, ;
: OSHL, ( # a -- )
  RCX POP  0 [RAX] RDX MOV  CL RDX QWORD PTR CELL [RAX] SHLD  CL QWORD PTR 0 [RAX] SHL  DROP, ;
: OSHR, ( # a -- )
  RCX POP  CELL [RAX] RDX MOV  CL RDX QWORD PTR 0 [RAX] SHLD  CL QWORD PTR CELL [RAX] SHR  DROP, ;

( Bit Operations )

: BTAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BT  RAX RAX SBB ;
: BTSAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BTS  RAX RAX SBB ;
: BTRAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BTR  RAX RAX SBB ;
: BTCAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BTC  RAX RAX SBB ;
: BSAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BTS  RAX POP ;
: BRAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BTR  RAX POP ;
: BCAT, ( a # -- ? )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BTC  RAX POP ;

: BTATIF, ( a # -- )
  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP  AL 0 [RDX] BT  RAX POP  CY IF ;
: BTATUNLESS, ( a # -- )  RAX RDX MOV  7 # RAX AND  3 # RDX SHR  RDX 0 [RSP] ADD  RDX POP
  AL 0 [RDX] BT  RAX POP  CY UNLESS ;

: BSF1AT, ( a #1 -- #2 )  RAX RCX MOV  RSI POP  RDX RDX XOR  RDX RAX MOV  CLD
  FOR  QWORD PTR LODS  RAX RDI BSF  0= IF  64 [RDX] RDX LEA  THEN  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: CBSF1AT, ( a #1 -- #2 )  RAX RCX MOV  RSI POP  RDX RDX XOR  RDX RAX MOV  CLD
  FOR  BYTE PTR LODS  RAX RDI BSF  0= IF  8 [RDX] RDX LEA  THEN  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: BSR1AT, ( a #1 -- #2 )  RAX RCX MOV  RAX RAX XOR  RSI POP  -8 [RSI] [RCX] *8 RSI LEA
  RCX RDX MOV  6 # RDX SHL  STD  FOR  QWORD PTR LODS  -64 [RDX] RDX LEA  RAX RDI BSR  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: CBSR1AT, ( a #1 -- #2 )  RAX RCX MOV  RAX RAX XOR  RSI POP  -1 [RSI] [RCX] RSI LEA
  0 [RCX] *8 RDX LEA  STD  FOR  BYTE PTR LODS  -8 [RDX] RDX LEA  RAX RDI BSR  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: BSF0AT, ( a #1 -- #2 )  RAX RCX MOV  RSI POP  RDX RDX XOR  RDX RAX MOV  CLD
  FOR  QWORD PTR LODS  RAX NOT  RAX RDI BSF  0= IF  64 [RDX] RDX LEA  THEN  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: CBSF0AT, ( a #1 -- #2 )  RAX RCX MOV  RSI POP  RDX RDX XOR  RDX RAX MOV  CLD
  FOR  BYTE PTR LODS  AL NOT  RAX RDI BSF  0= IF  8 [RDX] RDX LEA  THEN  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: BSR0AT, ( a #1 -- #2 )  RAX RCX MOV  RAX RAX XOR  RSI POP  -8 [RSI] [RCX] *8 RSI LEA  STD
  RCX RDX MOV  6 # RDX SHL  FOR  QWORD PTR LODS  RAX NOT  -64 [RDX] RDX LEA  RAX RDI BSR  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;
: CBSR0AT, ( a #1 -- #2 )  RAX RCX MOV  RAX RAX XOR  RSI POP  -1 [RCX] [RSI] RSI LEA
  0 [RCX] *8 RDX LEA  STD  FOR  BYTE PTR LODS  AL NOT  -8 [RDX] RDX LEA  RAX RDI BSR  0= ?NEXT
  0= IF  STC  RAX RAX SBB  ELSE  RDX RAX MOV  RDI RAX ADD  THEN ;

: CHARBUILD, ( u1 u2 a -- )  RAX RSI MOV  0 [RSI] RAX MOV  RDX POP  RDX MUL  RDX POP  RDX RAX ADD
  RAX 0 [RSI] MOV  RAX POP ;

=== Block Operations & Loops ===

: IF, ( ? -- )  RAX RAX TEST  RAX POP  0≠ IF ;
: IFLIKELY, ( ? -- )  RAX RAX TEST  RAX POP  0≠ IFLIKELY ;
: IFUNLIKELY, ( ? -- )  RAX RAX TEST  RAX POP  0≠ IFUNLIKELY ;
: UNLESS, ( ? -- )  RAX RAX TEST  RAX POP  0= IF ;
: UNLESSLIKELY, ( ? -- )  RAX RAX TEST  RAX POP  0= IFLIKELY ;
: UNLESSUNLIKELY, ( ? -- )  RAX RAX TEST  RAX POP  0= IFUNLIKELY ;
: ELSE, ( -- )  ELSE ;
: THEN, ( -- )  THEN ;
: BEGIN, ( -- )  BEGIN ;
: END, ( -- )  END ;
: AGAIN, ( -- )  AGAIN ;
: UNTIL, ( ? -- )  RAX RAX TEST  RAX POP  0- UNTIL ;
: ASLONG, ( ? -- )  RAX RAX TEST  RAX POP  0= UNTIL ;
: WHILE, ( ? -- )  RAX RAX TEST  RAX POP  0- WHILE ;
: REPEAT, ( -- )  REPEAT ;
: DO, ( limit index -- )  RAX 0 [RSP] CMP  ≤ IFUNLIKELY  2DROP,  ELSE  SWAP, TOR, TOR,  BEGIN ;
: UDO, ( limit index -- )  RAX 0 [RSP] CMP  U≤ IFUNLIKELY  2DROP,  ELSE  SWAP, TOR, TOR,  BEGIN ;
: DODOWN, ( index limit -- )  0 [RSP] RAX CMP  ≤ IFUNLIKELY  2DROP,  ELSE  SWAP, TOR, TOR, BEGIN ;
: LOOP, ( -- )  QWORD PTR -CELL [RBP] INC  LOOPPARA,  RCX RDX CMP  = UNTIL  2RDROP,  THEN ;
: LOOPDOWN, ( -- )  QWORD PTR -CELL [RBP] DEC  LOOPPARA,  RCX RDX CMP  = UNTIL  2RDROP,  THEN ;
: PLUSLOOP, ( n -- )  RAX -CELL [RBP] ADD  DROP,  LOOPPARA,  RCX RDX CMP  = UNTIL  2RDROP,  THEN ;
: MINUSLOOP, ( n -- )  RAX -CELL [RBP] SUB  DROP,  LOOPPARA,  RCX RDX CMP  = UNTIL  2RDROP,  THEN ;
: CONDLOOP, ( ? -- )  RAX RAX TEST  RAX POP  0= UNLESS
  QWORD PTR -CELL [RBP] INC  LOOPPARA,  RCX RDX CMP  THEN  = UNTIL  2RDROP,  THEN ;
: CONDLOOPDOWN, ( ? -- )  RAX RAX TEST  RAX POP  0= UNLESS
  QWORD PTR -CELL [RBP] DEC  LOOPPARA,  RCX RDX CMP  THEN  = UNTIL  2RDROP,  THEN ;
: CONDPLUSLOOP, ( ? n -- )  RAX -CELL [RBP] ADD  DROP,  RAX RAX TEST  RAX POP  0= UNLESS
  LOOPPARA,  RCX RDX CMP  THEN  = UNTIL  2RDROP,  THEN ;
: CONDMINUSLOOP, ( ? n -- )  RAX -CELL [RBP] SUB  DROP,  RAX RAX TEST  RAX POP  0= UNLESS
  LOOPPARA,  RCX RDX CMP  THEN  = UNTIL  2RDROP,  THEN ;
: BREAK, ( -- )  BREAK ;
: BREAKLOOP, ( -- )  BREAKLOOP ;

=== Object Primitives ===

: TOTHIS, ( object -- )  RAX 0 [R15] MOV  CELL [R15] R15 LEA  DROP, ;
: FETCHTHIS, ( -- object )  RAX PUSH  -CELL [R15] RAX MOV ;
: FETCHMY, ( -- )  -CELL [R15] RBX MOV ;
: FROMTHIS, ( -- object )  FETCHTHIS, -CELL [R15] R15 LEA ;

=== Special Macros ===

: CALL, ( >a$ -- )  tvoc@ swap 0 ## CALL ;
: CALLX, ( >a$ -- )  0 swap 0 ## CALL ;
: INVOKE, ( a -- )  RAX RDX MOV  RAX POP  RDX CALL ;

: [DEBUGLIT],  c" cr" compile  1 ADP+  RAX PUSH  1 ADP-  # RAX MOV  c" ." compile
  RAX PUSH  $3A # RAX MOV  c" emit" compile  c" space" compile  c" .s" compile  c" space" compile ;

: [UNIP],  CELLS # RSP ADD ;
: [UDROP],  1- [UNIP],  RAX POP ;
: [UPICK],  1 ADP+  RAX PUSH  1 ADP-  CELLS [RSP] RAX MOV ;

: [PLUS],  # RAX ADD ;
: [MINUS],  # RAX SUB ;
: [LSHIFT],  # RAX SHL ;
: [RSHIFT],  # RAX SAR ;
: [URSHIFT],  # RAX SHR ;
: [LROT],  # RAX ROL ;
: [RROT],  # RAX ROR ;
: [AND],  # RAX AND ;
: [OR],  # RAX OR ;
: [XOR],  # RAX XOR ;
: [ANDN],  invert # RAX AND ;

: [BT],  # RAX BT  RAX PUSH  RAX RAX SBB ;
: [BTS],  # RAX BTS  RAX PUSH  RAX RAX SBB ;
: [BTR],  # RAX BTR  RAX PUSH  RAX RAX SBB ;
: [BTC],  # RAX BTC  RAX PUSH  RAX RAX SBB ;
: [BS],  # RAX BTS ;
: [BR],  # RAX BTR ;
: [BC],  # RAX BTC ;
: [BIT],  1 swap << # RAX MOV ;

: [CSTORE],  # BYTE PTR 0 [RAX] MOV  DROP, ;
: [WSTORE],  # WORD PTR 0 [RAX] MOV  DROP, ;
: [DSTORE],  # DWORD PTR 0 [RAX] MOV  DROP, ;
: [QSTORE],  # QWORD PTR 0 [RAX] MOV  DROP, ;
: [CSTOREINC],  # BYTE PTR 0 [RAX] MOV  RAX INC ;
: [WSTOREINC],  # WORD PTR 0 [RAX] MOV  2 # RAX ADD ;
: [DSTOREINC],  # DWORD PTR 0 [RAX] MOV  4 # RAX ADD ;
: [QSTOREINC],  # QWORD PTR 0 [RAX] MOV  8 # RAX ADD ;

: [ADDC],  # BYTE PTR 0 [RAX] ADD  DROP, ;
: [ADDW],  # WORD PTR 0 [RAX] ADD  DROP, ;
: [ADDD],  # DWORD PTR 0 [RAX] ADD  DROP, ;
: [ADDQ],  # QWORD PTR 0 [RAX] ADD  DROP, ;
: [SUBC],  # BYTE PTR 0 [RAX] SUB  DROP, ;
: [SUBW],  # WORD PTR 0 [RAX] SUB  DROP, ;
: [SUBD],  # DWORD PTR 0 [RAX] SUB  DROP, ;
: [SUBQ],  # QWORD PTR 0 [RAX] SUB  DROP, ;
: [FETCHSUBQ],  negate # RDX MOV  0 [RAX] RDX XCHG  RDX 0 [RAX] ADD  RDX RAX MOV ;
: [BSAL],  # BYTE PTR 0 [RAX] SHL  DROP, ;
: [BSAR],  # BYTE PTR 0 [RAX] SAR  DROP, ;
: [CSHL],  # BYTE PTR 0 [RAX] SHL  DROP, ;
: [CSHR],  # BYTE PTR 0 [RAX] SHR  DROP, ;
: [SSAL],  # WORD PTR 0 [RAX] SHL  DROP, ;
: [SSAR],  # WORD PTR 0 [RAX] SAR  DROP, ;
: [WSHL],  # WORD PTR 0 [RAX] SHL  DROP, ;
: [WSHR],  # WORD PTR 0 [RAX] SHR  DROP, ;
: [ISAL],  # DWORD PTR 0 [RAX] SHL  DROP, ;
: [ISAR],  # DWORD PTR 0 [RAX] SAR  DROP, ;
: [DSHL],  # DWORD PTR 0 [RAX] SHL  DROP, ;
: [DSHR],  # DWORD PTR 0 [RAX] SHR  DROP, ;
: [LSAL],  # QWORD PTR 0 [RAX] SHL  DROP, ;
: [LSAR],  # QWORD PTR 0 [RAX] SAR  DROP, ;
: [QSHL],  # QWORD PTR 0 [RAX] SHL  DROP, ;
: [QSHR],  # QWORD PTR 0 [RAX] SHR  DROP, ;
: [VSAL],
  # CL MOV  0 [RAX] RDX MOV  CL RDX QWORD PTR CELL [RAX] SHLD  CL QWORD PTR 0 [RAX] SAL  DROP, ;
: [VSAR],
  # CL MOV  CELL [RAX] RDX MOV  CL RDX QWORD PTR 0 [RAX] SHRD  CL QWORD PTR CELL [RAX] SAR  DROP, ;
: [OSHL],
  # CL MOV  0 [RAX] RDX MOV  CL RDX QWORD PTR CELL [RAX] SHLD  CL QWORD PTR 0 [RAX] SHL  DROP, ;
: [OSHR],
  # CL MOV  CELL [RAX] RDX MOV  CL RDX QWORD PTR 0 [RAX] SHRD  CL QWORD PTR CELL [RAX] SHR  DROP, ;
: [ANDC],  # BYTE PTR 0 [RAX] AND  DROP, ;
: [ANDW],  # WORD PTR 0 [RAX] AND  DROP, ;
: [ANDD],  # DWORD PTR 0 [RAX] AND  DROP, ;
: [ANDQ],  # QWORD PTR 0 [RAX] AND  DROP, ;
: [ORC],  # BYTE PTR 0 [RAX] OR  DROP, ;
: [ORW],  # WORD PTR 0 [RAX] OR  DROP, ;
: [ORD],  # DWORD PTR 0 [RAX] OR  DROP, ;
: [ORQ],  # QWORD PTR 0 [RAX] OR  DROP, ;
: [XORC],  # BYTE PTR 0 [RAX] XOR  DROP, ;
: [XORW],  # WORD PTR 0 [RAX] XOR  DROP, ;
: [XORD],  # DWORD PTR 0 [RAX] XOR  DROP, ;
: [XORQ],  # QWORD PTR 0 [RAX] XOR  DROP, ;

: [BTAT],  # QWORD PTR 0 [RAX] BT  RAX RAX SBB ;
: [BTSAT],  # QWORD PTR 0 [RAX] BTS  RAX RAX SBB ;
: [BTRAT],  # QWORD PTR 0 [RAX] BTR  RAX RAX SBB ;
: [BTCAT],  # QWORD PTR 0 [RAX] BTC  RAX RAX SBB ;
: [BSAT],  # QWORD PTR 0 [RAX] BTS  DROP, ;
: [BRAT],  # QWORD PTR 0 [RAX] BTR  DROP, ;
: [BCAT],  # QWORD PTR 0 [RAX] BTC  DROP, ;

: [CELLS],  1 ADP+  RAX PUSH  1 ADP-  cells # RAX MOV ;
: [CELLSPLUS],  cells # RAX ADD ;
: [ADVANCE],  1 ADP+  dup # RAX SUB  1 ADP-  # QWORD PTR 0 [RSP] ADD ;

: [ISEQUAL],  # RAX SUB  setCurrent  ISZERO,  ['] ?ISEQUAL#, CONDITION ! ;
: [ISNOTEQUAL],  # RAX SUB  setCurrent  ISNOTZERO,  ['] ?ISNOTEQUAL#, CONDITION ! ;
: [ISLESS],  # RAX SUB  setCurrent  ISNEGATIVE,  ['] ?ISLESS#, CONDITION ! ;
: [ISNOTLESS],  # RAX SUB  setCurrent  ISNOTNEGATIVE,  ['] ?ISNOTLESS#, CONDITION ! ;
: [ISGREATER],  # RAX SUB  setCurrent  ISPOSITIVE,  ['] ?ISGREATER#, CONDITION ! ;
: [ISNOTGREATER],  # RAX SUB  setCurrent  ISNOTPOSITIVE,  ['] ?ISNOTGREATER#, CONDITION ! ;
: [ISBELOW],  # RAX SUB  setCurrent  RAX RAX SBB  ['] ?ISBELOW#, CONDITION ! ;
: [ISNOTBELOW],  # RAX SUB  setCurrent  CMC  RAX RAX SBB  ['] ?ISNOTBELOW#, CONDITION ! ;
: [ISABOVE],  # RAX SUB  setCurrent  AL U> ?SET  AL NEG  AL RAX MOVSX  ['] ?ISABOVE#, CONDITION ! ;
: [ISNOTABOVE],
  # RAX SUB  setCurrent  AL U≤ ?SET  AL NEG  AL RAX MOVSX  ['] ?ISNOTABOVE#, CONDITION ! ;

: [IFEQUAL],  # RAX CMP  DROP,  = IF ;
: [IFNOTEQUAL],  # RAX CMP  DROP,  ≠ IF ;
: [IFLESS],  # RAX CMP  DROP,  < IF ;
: [IFNOTLESS],  # RAX CMP  DROP,  ≥ IF ;
: [IFGREATER],  # RAX CMP  DROP,  > IF ;
: [IFNOTGREATER],  # RAX CMP  DROP,  ≤ IF ;
: [IFBELOW],  # RAX CMP  DROP,  U< IF ;
: [IFNOTBELOW],  # RAX CMP  DROP,  U≥ IF ;
: [IFABOVE],  # RAX CMP  DROP,  U> IF ;
: [IFNOTABOVE],  # RAX CMP  DROP,  = IF ;
: [DUPIFEQUAL],  # RAX CMP  = IF ;
: [DUPIFNOTEQUAL],  # RAX CMP  ≠ IF ;
: [DUPIFLESS],  # RAX CMP  < IF ;
: [DUPIFNOTLESS],  # RAX CMP  ≥ IF ;
: [DUPIFGREATER],  # RAX CMP  > IF ;
: [DUPIFNOTGREATER],  # RAX CMP  ≤ IF ;
: [DUPIFBELOW],  # RAX CMP  U< IF ;
: [DUPIFNOTBELOW],  # RAX CMP  U≥ IF ;
: [DUPIFABOVE],  # RAX CMP  U> IF ;
: [DUPIFNOTABOVE],  # RAX CMP  = IF ;

: [IFEVEREQUAL],  # RAX CMP  DROP,  = IFEVER ;
: [IFEVERNOTEQUAL],  # RAX CMP  DROP,  ≠ IFEVER ;
: [IFEVERLESS],  # RAX CMP  DROP,  < IFEVER ;
: [IFEVERNOTLESS],  # RAX CMP  DROP,  ≥ IFEVER ;
: [IFEVERGREATER],  # RAX CMP  DROP,  > IFEVER ;
: [IFEVERNOTGREATER],  # RAX CMP  DROP,  ≤ IFEVER ;
: [IFEVERBELOW],  # RAX CMP  DROP,  U< IFEVER ;
: [IFEVERNOTBELOW],  # RAX CMP  DROP,  U≥ IFEVER ;
: [IFEVERABOVE],  # RAX CMP  DROP,  U> IFEVER ;
: [IFEVERNOTABOVE],  # RAX CMP  DROP,  = IFEVER ;
: [DUPIFEVEREQUAL],  # RAX CMP  = IFEVER ;
: [DUPIFEVERNOTEQUAL],  # RAX CMP  ≠ IFEVER ;
: [DUPIFEVERLESS],  # RAX CMP  < IFEVER ;
: [DUPIFEVERNOTLESS],  # RAX CMP  ≥ IFEVER ;
: [DUPIFEVERGREATER],  # RAX CMP  > IFEVER ;
: [DUPIFEVERNOTGREATER],  # RAX CMP  ≤ IFEVER ;
: [DUPIFEVERBELOW],  # RAX CMP  U< IFEVER ;
: [DUPIFEVERNOTBELOW],  # RAX CMP  U≥ IFEVER ;
: [DUPIFEVERABOVE],  # RAX CMP  U> IFEVER ;
: [DUPIFEVERNOTABOVE],  # RAX CMP  = IFEVER ;

: [BTIF],  # RAX BT  CY IF ;
: [BTSIF],  # RAX BTS  CY IF ;
: [BTRIF],  # RAX BTR  CY IF ;
: [BTCIF],  # RAX BTC  CY IF ;
: [BTUNLESS],  # RAX BT  CY UNLESS ;
: [BTSUNLESS],  # RAX BTS  CY UNLESS ;
: [BTRUNLESS],  # RAX BTR  CY UNLESS ;
: [BTCUNLESS],  # RAX BTC  CY UNLESS ;

: [TIMES], ( n -- )  case
  1 of  NOP  endof
  2 of  1 # RAX SHL  endof
  4 of  2 # RAX SHL  endof
  8 of  3 # RAX SHL  endof
  16 of  4 # RAX SHL  endof
  32 of  5 # RAX SHL  endof
  64 of  6 # RAX SHL  endof
  128 of  7 # RAX SHL  endof
  256 of  8 # RAX SHL  endof
  512 of  9 # RAX SHL  endof
  1024 of  10 # RAX SHL  endof
  2048 of  11 # RAX SHL  endof
  4096 of  12 # RAX SHL  endof
  8192 of  13 # RAX SHL  endof
  16384 of  14 # RAX SHL  endof
  32768 of  15 # RAX SHL  endof
  65536 of  16 # RAX SHL  endof
  # RDX MOV  RDX IMUL  0 endcase ;
: [UTIMES], ( n -- )  case
  1 of  NOP  endof
  2 of  1 # RAX SHL  endof
  4 of  2 # RAX SHL  endof
  8 of  3 # RAX SHL  endof
  16 of  4 # RAX SHL  endof
  32 of  5 # RAX SHL  endof
  64 of  6 # RAX SHL  endof
  128 of  7 # RAX SHL  endof
  256 of  8 # RAX SHL  endof
  512 of  9 # RAX SHL  endof
  1024 of  10 # RAX SHL  endof
  2048 of  11 # RAX SHL  endof
  4096 of  12 # RAX SHL  endof
  8192 of  13 # RAX SHL  endof
  16384 of  14 # RAX SHL  endof
  32768 of  15 # RAX SHL  endof
  65536 of  16 # RAX SHL  endof
  # RDX MOV  RDX MUL  0 endcase ;
: [THROUGH], ( n -- )  case
  1 of  NOP  endof
  2 of  1 # RAX SAR  endof
  4 of  2 # RAX SAR  endof
  8 of  3 # RAX SAR  endof
  16 of  4 # RAX SAR  endof
  32 of  5 # RAX SAR  endof
  64 of  6 # RAX SAR  endof
  128 of  7 # RAX SAR  endof
  256 of  8 # RAX SAR  endof
  512 of  9 # RAX SAR  endof
  1024 of  10 # RAX SAR  endof
  2048 of  11 # RAX SAR  endof
  4096 of  12 # RAX SAR  endof
  8192 of  13 # RAX SAR  endof
  16384 of  14 # RAX SAR  endof
  32768 of  15 # RAX SAR  endof
  65536 of  16 # RAX SAR  endof
  # RCX MOV  CQO  RCX IDIV  0 endcase ;
: [UTHROUGH], ( u -- )  case
  1 of  NOP  endof
  2 of  1 # RAX SHR  endof
  4 of  2 # RAX SHR  endof
  8 of  3 # RAX SHR  endof
  16 of  4 # RAX SHR  endof
  32 of  5 # RAX SHR  endof
  64 of  6 # RAX SHR  endof
  128 of  7 # RAX SHR  endof
  256 of  8 # RAX SHR  endof
  512 of  9 # RAX SHR  endof
  1024 of  10 # RAX SHR  endof
  2048 of  11 # RAX SHR  endof
  4096 of  12 # RAX SHR  endof
  8192 of  13 # RAX SHR  endof
  16384 of  14 # RAX SHR  endof
  32768 of  15 # RAX SHR  endof
  65536 of  16 # RAX SHR  endof
  # RCX MOV  RDX RDX XOR  RCX DIV  0 endcase ;
: [MODULO], ( n|u -- )  case
  1 of  RAX RAX XOR  endof
  2 of  1 # RAX AND  endof
  4 of  3 # RAX AND  endof
  8 of  7 # RAX AND  endof
  16 of  15 # RAX AND  endof
  32 of  31 # RAX AND  endof
  64 of  63 # RAX AND  endof
  128 of  127 # RAX AND  endof
  256 of  255 # RAX AND  endof
  512 of  511 # RAX AND  endof
  1024 of  1023 # RAX AND  endof
  2048 of  2047 # RAX AND  endof
  4096 of  4095 # RAX AND  endof
  8192 of  8191 # RAX AND  endof
  16384 of  16383 # RAX AND  endof
  32768 of  32767 # RAX AND  endof
  65536 of  65535 # RAX AND  endof
  # RCX MOV  RDX RDX XOR  RCX DIV  RDX RAX MOV  0 endcase ;
: [QUOTREM], ( u -- )  case
  1 of  0 # PUSH  endof
  2 of  RAX RDX MOV  1 # RAX SAR  1 # RDX AND  RDX PUSH  endof
  4 of  RAX RDX MOV  2 # RAX SAR  3 # RDX AND  RDX PUSH  endof
  8 of  RAX RDX MOV  3 # RAX SAR  7 # RDX AND  RDX PUSH  endof
  16 of  RAX RDX MOV  4 # RAX SAR  15 # RDX AND  RDX PUSH  endof
  32 of  RAX RDX MOV  5 # RAX SAR  31 # RDX AND  RDX PUSH  endof
  64 of  RAX RDX MOV  6 # RAX SAR  63 # RDX AND  RDX PUSH  endof
  128 of  RAX RDX MOV  7 # RAX SAR  127 # RDX AND  RDX PUSH  endof
  256 of  RAX RDX MOV  8 # RAX SAR  255 # RDX AND  RDX PUSH  endof
  512 of  RAX RDX MOV  9 # RAX SAR  511 # RDX AND  RDX PUSH  endof
  1024 of  RAX RDX MOV  10 # RAX SAR  1023 # RDX AND  RDX PUSH  endof
  2048 of  RAX RDX MOV  11 # RAX SAR  2047 # RDX AND  RDX PUSH  endof
  4096 of  RAX RDX MOV  12 # RAX SAR  4095 # RDX AND  RDX PUSH  endof
  8192 of  RAX RDX MOV  13 # RAX SAR  8191 # RDX AND  RDX PUSH  endof
  16384 of  RAX RDX MOV  14 # RAX SAR  16383 # RDX AND  RDX PUSH  endof
  32768 of  RAX RDX MOV  15 # RAX SAR  32767 # RDX AND  RDX PUSH  endof
  65536 of  RAX RDX MOV  16 # RAX SAR  65535 # RDX AND  RDX PUSH  endof
  # RCX MOV  CQO  RCX IDIV  RDX PUSH  0 endcase ;
: [UQUOTREM], ( u -- )  case
  1 of  0 # PUSH  endof
  2 of  RAX RDX MOV  1 # RAX SHR  1 # RDX AND  RDX PUSH  endof
  4 of  RAX RDX MOV  2 # RAX SHR  3 # RDX AND  RDX PUSH  endof
  8 of  RAX RDX MOV  3 # RAX SHR  7 # RDX AND  RDX PUSH  endof
  16 of  RAX RDX MOV  4 # RAX SHR  15 # RDX AND  RDX PUSH  endof
  32 of  RAX RDX MOV  5 # RAX SHR  31 # RDX AND  RDX PUSH  endof
  64 of  RAX RDX MOV  6 # RAX SHR  63 # RDX AND  RDX PUSH  endof
  128 of  RAX RDX MOV  7 # RAX SHR  127 # RDX AND  RDX PUSH  endof
  256 of  RAX RDX MOV  8 # RAX SHR  255 # RDX AND  RDX PUSH  endof
  512 of  RAX RDX MOV  9 # RAX SHR  511 # RDX AND  RDX PUSH  endof
  1024 of  RAX RDX MOV  10 # RAX SHR  1023 # RDX AND  RDX PUSH  endof
  2048 of  RAX RDX MOV  11 # RAX SHR  2047 # RDX AND  RDX PUSH  endof
  4096 of  RAX RDX MOV  12 # RAX SHR  4095 # RDX AND  RDX PUSH  endof
  8192 of  RAX RDX MOV  13 # RAX SHR  8191 # RDX AND  RDX PUSH  endof
  16384 of  RAX RDX MOV  14 # RAX SHR  16383 # RDX AND  RDX PUSH  endof
  32768 of  RAX RDX MOV  15 # RAX SHR  32767 # RDX AND  RDX PUSH  endof
  65536 of  RAX RDX MOV  16 # RAX SHR  65535 # RDX AND  RDX PUSH  endof
  # RCX MOV  RDX RDX XOR  RCX DIV  RDX PUSH  0 endcase ;
: [MPYB], ( n -- )  case
  0 of  0 # BYTE PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  4 of  2 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  8 of  3 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  16 of  4 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  32 of  5 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  64 of  6 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  128 of  7 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  256 of  8 # BYTE PTR 0 [RAX] SAL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYB,  0 endcase ;
: [MPYC], ( u -- )  case
  0 of  0 # BYTE PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  4 of  2 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  8 of  3 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  16 of  4 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  32 of  5 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  64 of  6 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  128 of  7 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  256 of  8 # BYTE PTR 0 [RAX] SHL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYC,  0 endcase ;
: [MPYS], ( n -- )  case
  0 of  0 # WORD PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # WORD PTR 0 [RAX] SAL  DROP,  endof
  4 of  2 # WORD PTR 0 [RAX] SAL  DROP,  endof
  8 of  3 # WORD PTR 0 [RAX] SAL  DROP,  endof
  16 of  4 # WORD PTR 0 [RAX] SAL  DROP,  endof
  32 of  5 # WORD PTR 0 [RAX] SAL  DROP,  endof
  64 of  6 # WORD PTR 0 [RAX] SAL  DROP,  endof
  128 of  7 # WORD PTR 0 [RAX] SAL  DROP,  endof
  256 of  8 # WORD PTR 0 [RAX] SAL  DROP,  endof
  512 of  9 # WORD PTR 0 [RAX] SAL  DROP,  endof
  1024 of  10 # WORD PTR 0 [RAX] SAL  DROP,  endof
  2048 of  11 # WORD PTR 0 [RAX] SAL  DROP,  endof
  4096 of  12 # WORD PTR 0 [RAX] SAL  DROP,  endof
  8192 of  13 # WORD PTR 0 [RAX] SAL  DROP,  endof
  16384 of  14 # WORD PTR 0 [RAX] SAL  DROP,  endof
  32768 of  15 # WORD PTR 0 [RAX] SAL  DROP,  endof
  65536 of  16 # WORD PTR 0 [RAX] SAL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYS,  0 endcase ;
: [MPYW], ( u -- )  case
  0 of  0 # WORD PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # WORD PTR 0 [RAX] SHL  DROP,  endof
  4 of  2 # WORD PTR 0 [RAX] SHL  DROP,  endof
  8 of  3 # WORD PTR 0 [RAX] SHL  DROP,  endof
  16 of  4 # WORD PTR 0 [RAX] SHL  DROP,  endof
  32 of  5 # WORD PTR 0 [RAX] SHL  DROP,  endof
  64 of  6 # WORD PTR 0 [RAX] SHL  DROP,  endof
  128 of  7 # WORD PTR 0 [RAX] SHL  DROP,  endof
  256 of  8 # WORD PTR 0 [RAX] SHL  DROP,  endof
  512 of  9 # WORD PTR 0 [RAX] SHL  DROP,  endof
  1024 of  10 # WORD PTR 0 [RAX] SHL  DROP,  endof
  2048 of  11 # WORD PTR 0 [RAX] SHL  DROP,  endof
  4096 of  12 # WORD PTR 0 [RAX] SHL  DROP,  endof
  8192 of  13 # WORD PTR 0 [RAX] SHL  DROP,  endof
  16384 of  14 # WORD PTR 0 [RAX] SHL  DROP,  endof
  32768 of  15 # WORD PTR 0 [RAX] SHL  DROP,  endof
  65536 of  16 # WORD PTR 0 [RAX] SHL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYW,  0 endcase ;
: [MPYI], ( n -- )  case
  0 of  0 # DWORD PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  4 of  2 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  8 of  3 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  16 of  4 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  32 of  5 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  64 of  6 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  128 of  7 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  256 of  8 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  512 of  9 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  1024 of  10 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  2048 of  11 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  4096 of  12 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  8192 of  13 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  16384 of  14 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  32768 of  15 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  65536 of  16 # DWORD PTR 0 [RAX] SAL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYI,  0 endcase ;
: [MPYD], ( u -- )  case
  0 of  0 # DWORD PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  4 of  2 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  8 of  3 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  16 of  4 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  32 of  5 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  64 of  6 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  128 of  7 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  256 of  8 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  512 of  9 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  1024 of  10 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  2048 of  11 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  4096 of  12 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  8192 of  13 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  16384 of  14 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  32768 of  15 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  65536 of  16 # DWORD PTR 0 [RAX] SHL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYD,  0 endcase ;
: [MPYL], ( n -- )  case
  0 of  0 # QWORD PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  4 of  2 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  8 of  3 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  16 of  4 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  32 of  5 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  64 of  6 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  128 of  7 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  256 of  8 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  512 of  9 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  1024 of  10 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  2048 of  11 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  4096 of  12 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  8192 of  13 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  16384 of  14 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  32768 of  15 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  65536 of  16 # QWORD PTR 0 [RAX] SAL  DROP,  endof
  RAX PUSH  # RAX MOV  MPYL,  0 endcase ;
: [MPYQ], ( u -- )  case
  0 of  0 # QWORD PTR 0 [RAX] MOV  DROP,  endof
  1 of  DROP,  endof
  2 of  1 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  4 of  2 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  8 of  3 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  16 of  4 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  32 of  5 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  64 of  6 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  128 of  7 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  256 of  8 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  512 of  9 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  1024 of  10 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  2048 of  11 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  4096 of  12 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  8192 of  13 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  16384 of  14 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  32768 of  15 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  65536 of  16 # QWORD PTR 0 [RAX] SHL  DROP,  endof
  1 ADP+  RAX PUSH  1 ADP-  # RAX MOV  MPYQ,  0 endcase ;
: [DIVB], ( n -- )  case
  1 of  DROP,  endof
  2 of  1 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  4 of  2 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  8 of  3 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  16 of  4 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  32 of  5 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  64 of  6 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  128 of  7 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  256 of  8 # BYTE PTR 0 [RAX] SAR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVB,  0 endcase ;
: [DIVC], ( u -- )  case
  1 of  DROP,  endof
  2 of  1 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  4 of  2 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  8 of  3 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  16 of  4 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  32 of  5 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  64 of  6 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  128 of  7 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  256 of  8 # BYTE PTR 0 [RAX] SHR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVC,  0 endcase ;
: [DIVS], ( n -- )  case
  1 of  DROP,  endof
  2 of  1 # WORD PTR 0 [RAX] SAR  DROP,  endof
  4 of  2 # WORD PTR 0 [RAX] SAR  DROP,  endof
  8 of  3 # WORD PTR 0 [RAX] SAR  DROP,  endof
  16 of  4 # WORD PTR 0 [RAX] SAR  DROP,  endof
  32 of  5 # WORD PTR 0 [RAX] SAR  DROP,  endof
  64 of  6 # WORD PTR 0 [RAX] SAR  DROP,  endof
  128 of  7 # WORD PTR 0 [RAX] SAR  DROP,  endof
  256 of  8 # WORD PTR 0 [RAX] SAR  DROP,  endof
  512 of  9 # WORD PTR 0 [RAX] SAR  DROP,  endof
  1024 of  10 # WORD PTR 0 [RAX] SAR  DROP,  endof
  2048 of  11 # WORD PTR 0 [RAX] SAR  DROP,  endof
  4096 of  12 # WORD PTR 0 [RAX] SAR  DROP,  endof
  8192 of  13 # WORD PTR 0 [RAX] SAR  DROP,  endof
  16384 of  14 # WORD PTR 0 [RAX] SAR  DROP,  endof
  32768 of  15 # WORD PTR 0 [RAX] SAR  DROP,  endof
  65536 of  16 # WORD PTR 0 [RAX] SAR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVS,  0 endcase ;
: [DIVW], ( u -- )  case
  1 of  DROP,  endof
  2 of  1 # WORD PTR 0 [RAX] SHR  DROP,  endof
  4 of  2 # WORD PTR 0 [RAX] SHR  DROP,  endof
  8 of  3 # WORD PTR 0 [RAX] SHR  DROP,  endof
  16 of  4 # WORD PTR 0 [RAX] SHR  DROP,  endof
  32 of  5 # WORD PTR 0 [RAX] SHR  DROP,  endof
  64 of  6 # WORD PTR 0 [RAX] SHR  DROP,  endof
  128 of  7 # WORD PTR 0 [RAX] SHR  DROP,  endof
  256 of  8 # WORD PTR 0 [RAX] SHR  DROP,  endof
  512 of  9 # WORD PTR 0 [RAX] SHR  DROP,  endof
  1024 of  10 # WORD PTR 0 [RAX] SHR  DROP,  endof
  2048 of  11 # WORD PTR 0 [RAX] SHR  DROP,  endof
  4096 of  12 # WORD PTR 0 [RAX] SHR  DROP,  endof
  8192 of  13 # WORD PTR 0 [RAX] SHR  DROP,  endof
  16384 of  14 # WORD PTR 0 [RAX] SHR  DROP,  endof
  32768 of  15 # WORD PTR 0 [RAX] SHR  DROP,  endof
  65536 of  16 # WORD PTR 0 [RAX] SHR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVW,  0 endcase ;
: [DIVI], ( n -- )  case
  1 of  DROP,  endof
  2 of  1 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  4 of  2 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  8 of  3 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  16 of  4 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  32 of  5 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  64 of  6 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  128 of  7 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  256 of  8 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  512 of  9 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  1024 of  10 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  2048 of  11 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  4096 of  12 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  8192 of  13 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  16384 of  14 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  32768 of  15 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  65536 of  16 # DWORD PTR 0 [RAX] SAR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVI,  0 endcase ;
: [DIVD], ( u -- )  case
  1 of  DROP,  endof
  2 of  1 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  4 of  2 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  8 of  3 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  16 of  4 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  32 of  5 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  64 of  6 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  128 of  7 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  256 of  8 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  512 of  9 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  1024 of  10 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  2048 of  11 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  4096 of  12 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  8192 of  13 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  16384 of  14 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  32768 of  15 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  65536 of  16 # DWORD PTR 0 [RAX] SHR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVD,  0 endcase ;
: [DIVL], ( n -- )  case
  1 of  DROP,  endof
  2 of  1 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  4 of  2 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  8 of  3 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  16 of  4 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  32 of  5 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  64 of  6 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  128 of  7 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  256 of  8 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  512 of  9 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  1024 of  10 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  2048 of  11 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  4096 of  12 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  8192 of  13 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  16384 of  14 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  32768 of  15 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  65536 of  16 # QWORD PTR 0 [RAX] SAR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVL,  0 endcase ;
: [DIVQ], ( u -- )  case
  1 of  DROP,  endof
  2 of  1 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  4 of  2 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  8 of  3 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  16 of  4 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  32 of  5 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  64 of  6 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  128 of  7 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  256 of  8 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  512 of  9 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  1024 of  10 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  2048 of  11 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  4096 of  12 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  8192 of  13 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  16384 of  14 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  32768 of  15 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  65536 of  16 # QWORD PTR 0 [RAX] SHR  DROP,  endof
  RAX PUSH  # RAX MOV  DIVQ,  0 endcase ;
: [MODC], ( n -- )  case
  1 of  0 # BYTE PTR 0 [RAX] MOV  DROP,  endof
  2 of  1 # BYTE PTR 0 [RAX] AND  DROP,  endof
  4 of  3 # BYTE PTR 0 [RAX] AND  DROP,  endof
  8 of  7 # BYTE PTR 0 [RAX] AND  DROP,  endof
  16 of  15 # BYTE PTR 0 [RAX] AND  DROP,  endof
  32 of  31 # BYTE PTR 0 [RAX] AND  DROP,  endof
  64 of  63 # BYTE PTR 0 [RAX] AND  DROP,  endof
  128 of  127 # BYTE PTR 0 [RAX] AND  DROP,  endof
  256 of  255 # BYTE PTR 0 [RAX] AND  DROP,  endof
  RAX PUSH  # RAX MOV  MODC,  0 endcase ;
: [MODW], ( n -- )  case
  1 of  0 # WORD PTR 0 [RAX] MOV  DROP,  endof
  2 of  1 # WORD PTR 0 [RAX] AND  DROP,  endof
  4 of  3 # WORD PTR 0 [RAX] AND  DROP,  endof
  8 of  7 # WORD PTR 0 [RAX] AND  DROP,  endof
  16 of  15 # WORD PTR 0 [RAX] AND  DROP,  endof
  32 of  31 # WORD PTR 0 [RAX] AND  DROP,  endof
  64 of  63 # WORD PTR 0 [RAX] AND  DROP,  endof
  128 of  127 # WORD PTR 0 [RAX] AND  DROP,  endof
  256 of  255 # WORD PTR 0 [RAX] AND  DROP,  endof
  512 of  511 # WORD PTR 0 [RAX] AND  DROP,  endof
  1024 of  1023 # WORD PTR 0 [RAX] AND  DROP,  endof
  2048 of  2047 # WORD PTR 0 [RAX] AND  DROP,  endof
  4096 of  4095 # WORD PTR 0 [RAX] AND  DROP,  endof
  8192 of  8191 # WORD PTR 0 [RAX] AND  DROP,  endof
  16384 of  16383 # WORD PTR 0 [RAX] AND  DROP,  endof
  32768 of  32767 # WORD PTR 0 [RAX] AND  DROP,  endof
  65536 of  65535 # WORD PTR 0 [RAX] AND  DROP,  endof
  RAX PUSH  # RAX MOV  MODW,  0 endcase ;
: [MODD], ( n -- )  case
  1 of  0 # DWORD PTR 0 [RAX] MOV  DROP,  endof
  2 of  1 # DWORD PTR 0 [RAX] AND  DROP,  endof
  4 of  3 # DWORD PTR 0 [RAX] AND  DROP,  endof
  8 of  7 # DWORD PTR 0 [RAX] AND  DROP,  endof
  16 of  15 # DWORD PTR 0 [RAX] AND  DROP,  endof
  32 of  31 # DWORD PTR 0 [RAX] AND  DROP,  endof
  64 of  63 # DWORD PTR 0 [RAX] AND  DROP,  endof
  128 of  127 # DWORD PTR 0 [RAX] AND  DROP,  endof
  256 of  255 # DWORD PTR 0 [RAX] AND  DROP,  endof
  512 of  511 # DWORD PTR 0 [RAX] AND  DROP,  endof
  1024 of  1023 # DWORD PTR 0 [RAX] AND  DROP,  endof
  2048 of  2047 # DWORD PTR 0 [RAX] AND  DROP,  endof
  4096 of  4095 # DWORD PTR 0 [RAX] AND  DROP,  endof
  8192 of  8191 # DWORD PTR 0 [RAX] AND  DROP,  endof
  16384 of  16383 # DWORD PTR 0 [RAX] AND  DROP,  endof
  32768 of  32767 # DWORD PTR 0 [RAX] AND  DROP,  endof
  65536 of  65535 # DWORD PTR 0 [RAX] AND  DROP,  endof
  RAX PUSH  # RAX MOV  MODD,  0 endcase ;
: [MODQ], ( n -- )  case
  1 of  0 # QWORD PTR 0 [RAX] MOV  DROP,  endof
  2 of  1 # QWORD PTR 0 [RAX] AND  DROP,  endof
  4 of  3 # QWORD PTR 0 [RAX] AND  DROP,  endof
  8 of  7 # QWORD PTR 0 [RAX] AND  DROP,  endof
  16 of  15 # QWORD PTR 0 [RAX] AND  DROP,  endof
  32 of  31 # QWORD PTR 0 [RAX] AND  DROP,  endof
  64 of  63 # QWORD PTR 0 [RAX] AND  DROP,  endof
  128 of  127 # QWORD PTR 0 [RAX] AND  DROP,  endof
  256 of  255 # QWORD PTR 0 [RAX] AND  DROP,  endof
  512 of  511 # QWORD PTR 0 [RAX] AND  DROP,  endof
  1024 of  1023 # QWORD PTR 0 [RAX] AND  DROP,  endof
  2048 of  2047 # QWORD PTR 0 [RAX] AND  DROP,  endof
  4096 of  4095 # QWORD PTR 0 [RAX] AND  DROP,  endof
  8192 of  8191 # QWORD PTR 0 [RAX] AND  DROP,  endof
  16384 of  16383 # QWORD PTR 0 [RAX] AND  DROP,  endof
  32768 of  32767 # QWORD PTR 0 [RAX] AND  DROP,  endof
  65536 of  65535 # QWORD PTR 0 [RAX] AND  DROP,  endof
  RAX PUSH  # RAX MOV  MODQ,  0 endcase ;

: [UNUMBUILD],  SWAP, 1 ADP+ [UTIMES], 1 ADP- PLUS, ;
: [UNUMBUILDAT],  [MPYQ],  RAX 0 [RCX] ADD  RAX POP ;

=== Memory Block Operations ===

: FILL, ( a # c -- )  RCX POP  RDI POP  CLD  REP QWORD PTR STOS  RAX POP ;
: CFILL, ( a # c -- )  RCX POP  RDI POP  CLD  REP BYTE PTR STOS  RAX POP ;
: MOVE, ( a1 a2 # -- )  RAX RCX MOV  RDI POP  RSI POP  CLD
  RSI RDI CMP  U> IFUNLIKELY  -8 [RSI] [RCX] *8 RSI LEA  -8 [RDI] [RCX] *8 RDI LEA  STD  THEN
  REP QWORD PTR MOVS  RAX POP ;
: CMOVE, ( a1 a2 # -- )  RAX RCX MOV  RDI POP  RSI POP  CLD
  RSI RDI CMP  U> IFUNLIKELY  -1 [RSI] [RCX] RSI LEA  -1 [RDI] [RCX] RDI LEA  STD  THEN
  REP BYTE PTR MOVS  RAX POP ;
: FIND, ( a # x -- u )  RCX POP  RCX RDX MOV  RDI POP  CLD  REPNE QWORD PTR SCAS
  = UNLESS  RDX RCX MOV  THEN  RCX RDX SUB  RDX RAX MOV ;
: DFIND, ( a # c -- u )  RCX POP  RCX RDX MOV  RDI POP  CLD  REPNE DWORD PTR SCAS
  = UNLESS  RDX RCX MOV  THEN  RCX RDX SUB  RDX RAX MOV ;
: CFIND, ( a # c -- u )  RCX POP  RCX RDX MOV  RDI POP  CLD  REPNE BYTE PTR SCAS
  = UNLESS  RDX RCX MOV  THEN  RCX RDX SUB  RDX RAX MOV ;
: RCFIND, ( a # c -- u )  RCX POP  RDI POP  -1 [RDI] [RCX] RDI LEA  STD  REPNE BYTE PTR SCAS
  = IF  RCX INC  THEN  RCX RAX MOV ;
: CREPLSTR, ( c1 c2 a$ -- )  RAX RDI MOV  BYTE PTR 0 [RDI] RCX MOVZX  RDI INC  RDX POP  RAX POP
  CLD  BEGIN  REPNE BYTE PTR SCAS  0= WHILE  DL -1 [RDI] MOV  REPEAT  RAX POP ;
: CSAME, ( a1 a2 # -- ? )  RAX RCX MOV  RDI POP  RSI POP  RAX RAX XOR  CLD  REPE BYTE PTR CMPS
  = IF  RAX DEC  THEN ;
: STREQ, ( a1$ a2$ -- ? )  RAX RSI MOV  RDI POP  BYTE PTR 0 [RSI] RCX MOVZX
  BYTE PTR 0 [RDI] RDX MOVZX  RCX RDX CMP  U< IF  RDX RCX MOV  THEN  RCX INC  CLD
  REPE BYTE PTR CMPS  AL 0= ?SET  AL NEG  AL RAX MOVSX ;
: [IFSTREQ], ( a1$ a2$ -- )  RAX RSI MOV  RDI POP  BYTE PTR 0 [RSI] RCX MOVZX
  BYTE PTR 0 [RDI] RDX MOVZX  RCX RDX CMP  U< IF  RDX RCX MOV  THEN  RCX INC  CLD
  REPE BYTE PTR CMPS  RAX POP  = IF ;
: ADVANCE, ( a # u -- a+u #-u )  RAX 0 [RSP] SUB  RAX CELL [RSP] ADD  RAX POP ;
: UCAPPEND, ( uc a$ -- )  RAX RSI MOV  BYTE PTR 0 [RSI] RAX MOVZX  1 [RSI] [RAX] RDI LEA   RAX POP
  RAX RDX BSR  0= UNLESS  42 # DL CMP  U< IF  ( Hard limits )
    7 # DL CMP  U< IF  BYTE PTR STOS  BYTE PTR 0 [RSI] INC  ELSE
      DL INC  RBX PUSH  RCX RCX XOR  %10000000 # BL MOV  %111111 # BH MOV  6 # DH MOV
      BEGIN  6 # RAX ROR  RCX INC  1 # BH SHR  1 # BL SAR  DH DEC  6 # DL SUB  DH DL CMP  0≤ UNTIL
      BH AL AND  BL AL OR  BYTE PTR STOS  BYTE PTR 0 [RSI] INC
      FOR  AL AL XOR  6 # RAX ROL  $80 # AL OR  BYTE PTR STOS  BYTE PTR 0 [RSI] INC  NEXT  RBX POP
  THEN  THEN  THEN  RAX POP ;

=== Parameter Field Operations ===

: CREATE, ( -- | -- a )  createParameterSymbol
  ENTER,  RAX PUSH  tvoc@ CURRENT-WORD @ 2dup @name  swap .pfa@ @@ RAX LEA  EXIT, ;
: DOCONST, ( u -- | -- u )  createParameterSymbol
  ENTER,  RAX PUSH  tvoc@ CURRENT-WORD @ 2dup @name  swap .pfa@ @@ RAX LEA  0 [RAX] RAX MOV  EXIT, ;
: DOFIELD, ( u -- | o -- a )  RAX PUSH  -CELL [RBX] RAX MOV  CELLS [RAX] RAX LEA ;

=== Program Control ===

: INIT, ( -- )  RSP RBP MOV  4096 # RBP SUB  1 ADP+  c" INITSP" compile  1 ADP-
  RSP RDX MOV  CELL # RDX ADD  RDX 0 [RAX] MOV  RAX POP  2 ADP-  c" INITRP" compile  2 ADP+
  4096 # RDX SUB  RDX 0 [RAX] MOV  RAX POP ;
: INITOBJ, ( -- )  c" ZP" compile  RAX RBX MOV  c" INITZP" compile  QSTORE, ;
: GETDICT, ( -- a )  depth ADP+
  ENTER,  RAX PUSH  tvoc@ dup vocabulary$ toff @@ RAX LEA  EXIT,  depth ADP- ;
: INITPROG, ( -- )  RSP RBP MOV  4096 # RBP SUB  c" #args" compile
  CELL # RSP ADD  RCX POP  RCX 0 [RAX] MOV  c" @args" compile
  CELL # RSP ADD  128 # RCX CMP  U> IF  128 # RCX MOV  THEN
  FOR  QWORD PTR 0 [RAX] POP  CELL [RAX] RAX LEA  NEXT  RAX POP
  c" @envs" compile  c" #envs" compile
  RAX RBX MOV  RAX POP  RAX RDI MOV  RAX POP  256 # RCX MOV
  FOR  RAX POP  QWORD PTR STOS  QWORD PTR 0 [RBX] INC  RAX RAX TEST  0≠ ?NEXT  QWORD PTR 0 [RBX] DEC
  c" INITSP" compile  RSP RDX MOV  CELL # RDX ADD  RDX 0 [RAX] MOV  RAX POP
  c" INITRP" compile  RBP 0 [RAX] MOV  RAX POP ;

=== Object Operations ===

: my ( -- a )  RAX PUSH  -CELL [RBX] RAX MOV ; alias me alias this

: word# ( -- word# )  RAX PUSH  4 cells # RAX MOV ;
: cell ( -- cell )  RAX PUSH  8 # RAX MOV ;
: cell+ ( u -- u+cell )  8 # RAX ADD ;
: cell- ( u -- u+cell )  8 # RAX SUB ;
: CELLS, ( u -- u*cell )  3 # RAX SHL ;
: cells+ ( u # -- u+#*cell )  CELLS,  RAX 0 [RSP] ADD  RAX POP ;

=== Macros for inlining ===

previous

: #drop ( ... #u -- )  [UDROP], ;
: #nip ( ... #u -- )  [UNIP], ;
: #pick ( ... #u -- xu )  [UPICK], ;

: #+ ( n1 #n2 -- n1+n2 )  [PLUS], ;
: #- ( n1 #n2 -- n1-n2 )  [MINUS], ; alias #−
: #* ( n1 #n2 -- n1*n2 )  [TIMES], ; alias #×
: #u* ( u1 #u2 -- u1*u2 )  [UTIMES], ; alias #u×
: #/ ( n1 #n2 -- n1/n2 )  [THROUGH], ;
: #u/ ( u1 #u2 -- u1/u2 )  [UTHROUGH], ;
: #mod ( n1 #n2 -- n1%n2 )  [MODULO], ;
: #umod ( u1 #u2 -- u1%u2 )  [MODULO], ;
: #/mod ( n1 #n2 -- n1%n2 n1/n2 )  [QUOTREM], ;
: #u/mod ( u1 #u2 -- u1%u2 u1/u2 )  [UQUOTREM], ;
: #<< ( n #u -- n<<u )  [LSHIFT], ; alias #u<<
: #>> ( n #u -- n>>u )  [RSHIFT], ;
: #u>> ( u1 #u2 -- u1>>u2 )  [URSHIFT], ;
: #<u< ( u1 #u2 -- u1<u<u2 )  [LROT], ;
: #>u> ( u1 #u2 -- u1>u>u2 )  [RROT], ;
: #and ( u1 #u2 -- u1⊙u2 )  [AND], ;
: #or ( u1 #u2 -- u1⊕u2 )  [OR], ;
: #xor ( u1 #u2 -- u1¤u2 )  [XOR], ;
: #andn ( u1 #u2 -- u1⊙~u2 )  [ANDN], ;
: #bit? ( u ## -- ? )  [BT], ;
: #bit+? ( u ## -- u' ? ) [BTS], ;
: #bit-? ( u ## -- u' ? ) [BTR], ;  alias ##−?
: #bit~? ( u ## -- u' ? ) [BTC], ;  alias ##×?
: #bit+ ( u ## -- u' ) [BS], ;
: #bit- ( u ## -- u' ) [BR], ;  alias ##−
: #bit~ ( u ## -- u' ) [BC], ;  alias ##×
: #bit ( # -- u ) [BIT], ;

: #c! ( a #c -- )  [CSTORE], ;
: #w! ( a #w -- )  [WSTORE], ;
: #d! ( a #d -- )  [DSTORE], ;
: #q! ( a #q -- )  [QSTORE], ; alias #!
: #c!++ ( a #c -- a+1 )  [CSTOREINC], ;
: #w!++ ( a #w -- a+2 )  [WSTOREINC], ;
: #d!++ ( a #d -- a+4 )  [DSTOREINC], ;
: #q!++ ( a #q -- a+8 )  [QSTOREINC], ; alias #!++

: #c+! ( a #c -- )  [ADDC], ;
: #w+! ( a #w -- )  [ADDW], ;
: #d+! ( a #d -- )  [ADDD], ;
: #q+! ( a #q -- )  [ADDQ], ; alias #+!
: #c-! ( a #c -- )  [SUBC], ; alias #c−!  alias #b-!  alias #b−!
: #w-! ( a #w -- )  [SUBW], ; alias #w−!  alias #s-!  alias #s−!
: #d-! ( a #d -- )  [SUBD], ; alias #d−!  alias #i-!  alias #d−!
: #q-! ( a #q -- )  [SUBQ], ; alias #q−!  alias #-!  alias #−!
: #q@-! ( a #q -- )  [FETCHSUBQ], ; alias #q@−!  alias #@-!  alias #@−!
: #b*! ( a #b -- )  [MPYB], ; alias #b×!
: #c*! ( a #c -- )  [MPYC], ; alias #c×!
: #s*! ( a #s -- )  [MPYS], ; alias #s×!
: #w*! ( a #w -- )  [MPYW], ; alias #w×!
: #i*! ( a #i -- )  [MPYI], ; alias #i×!
: #d*! ( a #d -- )  [MPYD], ; alias #d×!
: #l*! ( a #l -- )  [MPYL], ; alias #q×!  alias #*!  alias #×!
: #q*! ( a #q -- )  [MPYQ], ; alias #q×!  alias #u*!  alias #u×!
: #b/! ( a #b -- )  [DIVB], ; alias #b÷!
: #c/! ( a #c -- )  [DIVD], ; alias #c÷!
: #s/! ( a #s -- )  [DIVS], ; alias #s÷!
: #w/! ( a #w -- )  [DIVW], ; alias #w÷!
: #i/! ( a #i -- )  [DIVI], ; alias #i÷!
: #d/! ( a #d -- )  [DIVD], ; alias #d÷!
: #l/! ( a #l -- )  [DIVL], ; alias #l÷!  alias #/!  alias #÷!
: #q/! ( a #q -- )  [DIVQ], ; alias #q÷!  alias #u/!  alias #u÷!
: #bmod! ( a #b -- )  [MODC], ; alias #b%!
: #cmod! ( a #c -- )  [MODC], ; alias #c%!
: #smod! ( a #s -- )  [MODW], ; alias #s%!
: #wmod! ( a #w -- )  [MODW], ; alias #w%!
: #imod! ( a #i -- )  [MODD], ; alias #i%!
: #dmod! ( a #d -- )  [MODD], ; alias #d%!
: #lmod! ( a #l -- )  [MODQ], ; alias #l%!  alias #mod!  alias #%!
: #qmod! ( a #q -- )  [MODQ], ; alias #q%!  alias #umod!  alias #u%!
: #cand! ( a #c -- )  [ANDC], ;
: #wand! ( a #w -- )  [ANDW], ;
: #dand! ( a #d -- )  [ANDD], ;
: #qand! ( a #q -- )  [ANDQ], ; alias #and!
: #cor! ( a #c -- )  [ORC], ;
: #wor! ( a #w -- )  [ORW], ;
: #dor! ( a #d -- )  [ORD], ;
: #qor! ( a #q -- )  [ORQ], ; alias #or!
: #cxor! ( a #c -- )  [XORC], ;
: #wxor! ( a #w -- )  [XORW], ;
: #dxor! ( a #d -- )  [XORD], ;
: #qxor! ( a #q -- )  [XORQ], ; alias #xor!
: #b<<! ( a #u -- )  [BSAL], ;
: #b>>! ( a #u -- )  [BSAR], ;
: #c<<! ( a #u -- )  [CSHL], ;
: #c>>! ( a #u -- )  [CSHR], ;
: #s<<! ( a #u -- )  [SSAL], ;
: #s>>! ( a #u -- )  [SSAR], ;
: #w<<! ( a #u -- )  [WSHL], ;
: #w>>! ( a #u -- )  [WSHR], ;
: #i<<! ( a #u -- )  [ISAL], ;
: #i>>! ( a #u -- )  [ISAR], ;
: #d<<! ( a #u -- )  [DSHL], ;
: #d>>! ( a #u -- )  [DSHR], ;
: #l<<! ( a #u -- )  [LSAL], ; alias #<<!
: #l>>! ( a #u -- )  [LSAR], ; alias #>>!
: #q<<! ( a #u -- )  [QSHL], ; alias #u<<!
: #q>>! ( a #u -- )  [QSHR], ; alias #u>>!
: #v<<! ( a #u -- )  [VSAL], ;
: #v>>! ( a #u -- )  [VSAR], ;
: #o<<! ( a #u -- )  [OSHL], ;
: #o>>! ( a #u -- )  [OSHR], ;

: #bit@ ( a #u -- ? )  [BTAT], ;
: #bit+@ ( a #u -- ? )  [BTSAT], ;
: #bit-@ ( a #u -- ? )  [BTRAT], ; alias #bit−@
: #bit~@ ( a #u -- ? )  [BTCAT], ; alias #bit×@
: #bit+! ( a #u -- )  [BSAT], ;
: #bit-! ( a #u -- )  [BRAT], ; alias #bit−!
: #bit~! ( a #u -- )  [BCAT], ; alias #bit×!

: #cells ( #u -- u*cell )  [CELLS], ;
: #cells+ ( #u -- u*cell )  [CELLSPLUS], ;

: #+> ( a # #u -- a+u #-u )  [ADVANCE], ;
: #u*+ ( u1 u2 #u3 -- u1*u3+u2 )  [UNUMBUILD], ;
: #u*+! ( u1 a #u2 -- )  [UNUMBUILDAT], ;

: #= ( x1 #x2 -- x1=x2 )  [ISEQUAL], ;
: #≠ ( x1 #x2 -- x1≠x2 )  [ISNOTEQUAL], ; alias #<>
: #< ( n1 #n2 -- n1<n2 )  [ISLESS], ;
: #≥ ( n1 #n2 -- n1≥n2 )  [ISNOTLESS], ; alias #>=
: #> ( n1 #n2 -- n1>n2 )  [ISGREATER], ;
: #≤ ( n1 #n2 -- n1≤n2 )  [ISNOTGREATER], ; alias #<=
: #u< ( u1 #u2 -- u1<u2 )  [ISBELOW], ;
: #u≥ ( u1 #u2 -- u1≥u2 )  [ISNOTBELOW], ; alias #u>=
: #u> ( u1 #u2 -- u1>u2 )  [ISABOVE], ;
: #u≤ ( u1 #u2 -- u1≤u2 )  [ISNOTABOVE], ; alias #u<=

: #=if ( x1 #x2 -- )  [IFEQUAL], ;
: #≠if ( x1 #x2 -- )  [IFNOTEQUAL], ; alias #<>if
: #<if ( n1 #n2 -- )  [IFLESS], ;
: #≥if ( n1 #n2 -- )  [IFNOTLESS], ; alias #>=if
: #>if ( n1 #n2 -- )  [IFGREATER], ;
: #≤if ( n1 #n2 -- )  [IFNOTGREATER], ; alias #<=if
: #u<if ( u1 #u2 -- )  [IFBELOW], ;
: #u≥if ( u1 #u2 -- )  [IFNOTBELOW], ; alias #u>=if
: #u>if ( u1 #u2 -- )  [IFABOVE], ;
: #u≤if ( u1 #u2 -- )  [IFNOTABOVE], ; alias #u<=if
: #=?if ( x1 #x2 -- )  [DUPIFEQUAL], ;
: #≠?if ( x1 #x2 -- )  [DUPIFNOTEQUAL], ; alias #<>if
: #<?if ( n1 #n2 -- )  [DUPIFLESS], ;
: #≥?if ( n1 #n2 -- )  [DUPIFNOTLESS], ; alias #>=if
: #>?if ( n1 #n2 -- )  [DUPIFGREATER], ;
: #≤?if ( n1 #n2 -- )  [DUPIFNOTGREATER], ; alias #<=if
: #u<?if ( u1 #u2 -- )  [DUPIFBELOW], ;
: #u≥?if ( u1 #u2 -- )  [DUPIFNOTBELOW], ; alias #u>=if
: #u>?if ( u1 #u2 -- )  [DUPIFABOVE], ;
: #u≤?if ( u1 #u2 -- )  [DUPIFNOTABOVE], ; alias #u<=if
: ##?if ( u ## -- )  [BTIF], ;
: ##+?if ( u ## -- )  [BTSIF], ;
: ##-?if ( u ## -- )  [BTRIF], ;  alias ##−?if
: ##~?if ( u ## -- )  [BTCIF], ;  alias ##×?if
: #=ifever ( x1 #x2 -- )  [IFEVEREQUAL], ;
: #≠ifever ( x1 #x2 -- )  [IFEVERNOTEQUAL], ; alias #<>if
: #<ifever ( n1 #n2 -- )  [IFEVERLESS], ;
: #≥ifever ( n1 #n2 -- )  [IFEVERNOTLESS], ; alias #>=if
: #>ifever ( n1 #n2 -- )  [IFEVERGREATER], ;
: #≤ifever ( n1 #n2 -- )  [IFEVERNOTGREATER], ; alias #<=if
: #u<ifever ( u1 #u2 -- )  [IFEVERBELOW], ;
: #u≥ifever ( u1 #u2 -- )  [IFEVERNOTBELOW], ; alias #u>=if
: #u>ifever ( u1 #u2 -- )  [IFEVERABOVE], ;
: #u≤ifever ( u1 #u2 -- )  [IFEVERNOTABOVE], ; alias #u<=if
: #=?ifever ( x1 #x2 -- )  [DUPIFEVEREQUAL], ;
: #≠?ifever ( x1 #x2 -- )  [DUPIFEVERNOTEQUAL], ; alias #<>if
: #<?ifever ( n1 #n2 -- )  [DUPIFEVERLESS], ;
: #≥?ifever ( n1 #n2 -- )  [DUPIFEVERNOTLESS], ; alias #>=if
: #>?ifever ( n1 #n2 -- )  [DUPIFEVERGREATER], ;
: #≤?ifever ( n1 #n2 -- )  [DUPIFEVERNOTGREATER], ; alias #<=if
: #u<?ifever ( u1 #u2 -- )  [DUPIFEVERBELOW], ;
: #u≥?ifever ( u1 #u2 -- )  [DUPIFEVERNOTBELOW], ; alias #u>=if
: #u>?ifever ( u1 #u2 -- )  [DUPIFEVERABOVE], ;
: #u≤?ifever ( u1 #u2 -- )  [DUPIFEVERNOTABOVE], ; alias #u<=if
: ##?ifever ( u ## -- )  [BTIF], ;
: ##+?ifever ( u ## -- )  [BTSIF], ;
: ##-?ifever ( u ## -- )  [BTRIF], ;  alias ##−?if
: ##~?ifever ( u ## -- )  [BTCIF], ;  alias ##×?if
: #=unless ( x1 #x2 -- )  [IFNOTEQUAL], ;
: #≠unless ( x1 #x2 -- )  [IFEQUAL], ; alias #<>unless
: #<unless ( n1 #n2 -- )  [IFNOTLESS], ;
: #≥unless ( n1 #n2 -- )  [IFLESS], ; alias #>=unless
: #>unless ( n1 #n2 -- )  [IFNOTGREATER], ;
: #≤unless ( n1 #n2 -- )  [IFGREATER], ; alias #<=unless
: #u<unless ( u1 #u2 -- )  [IFNOTBELOW], ;
: #u≥unless ( u1 #u2 -- )  [IFBELOW], ; alias #u>=unless
: #u>unless ( u1 #u2 -- )  [IFNOTABOVE], ;
: #u≤unless ( u1 #u2 -- )  [IFABOVE], ; alias #u<=unless

: #=unlessever ( x1 #x2 -- )  [IFEVERNOTEQUAL], ;
: #≠unlessever ( x1 #x2 -- )  [IFEVEREQUAL], ; alias #<>unlessever
: #<unlessever ( n1 #n2 -- )  [IFEVERNOTLESS], ;
: #≥unlessever ( n1 #n2 -- )  [IFEVERLESS], ; alias #>=unlessever
: #>unlessever ( n1 #n2 -- )  [IFEVERNOTGREATER], ;
: #≤unlessever ( n1 #n2 -- )  [IFEVERGREATER], ; alias #<=unlessever
: #u<unlessever ( u1 #u2 -- )  [IFEVERNOTBELOW], ;
: #u≥unlessever ( u1 #u2 -- )  [IFEVERBELOW], ; alias #u>=unlessever
: #u>unlessever ( u1 #u2 -- )  [IFEVERNOTABOVE], ;
: #u≤unlessever ( u1 #u2 -- )  [IFEVERABOVE], ; alias #u<=unlessever

: #=?unless ( x1 #x2 -- )  [DUPIFNOTEQUAL], ;
: #≠?unless ( x1 #x2 -- )  [DUPIFEQUAL], ; alias #<>unless
: #<?unless ( n1 #n2 -- )  [DUPIFNOTLESS], ;
: #≥?unless ( n1 #n2 -- )  [DUPIFLESS], ; alias #>=unless
: #>?unless ( n1 #n2 -- )  [DUPIFNOTGREATER], ;
: #≤?unless ( n1 #n2 -- )  [DUPIFGREATER], ; alias #<=unless
: #u<?unless ( u1 #u2 -- )  [DUPIFNOTBELOW], ;
: #u≥?unless ( u1 #u2 -- )  [DUPIFBELOW], ; alias #u>=unless
: #u>?unless ( u1 #u2 -- )  [DUPIFNOTABOVE], ;
: #u≤?unless ( u1 #u2 -- )  [DUPIFABOVE], ; alias #u<=unless

: #=?unlessever ( x1 #x2 -- )  [DUPIFEVERNOTEQUAL], ;
: #≠?unlessever ( x1 #x2 -- )  [DUPIFEVEREQUAL], ; alias #<>unlessever
: #<?unlessever ( n1 #n2 -- )  [DUPIFEVERNOTLESS], ;
: #≥?unlessever ( n1 #n2 -- )  [DUPIFEVERLESS], ; alias #>=unlessever
: #>?unlessever ( n1 #n2 -- )  [DUPIFEVERNOTGREATER], ;
: #≤?unlessever ( n1 #n2 -- )  [DUPIFEVERGREATER], ; alias #<=unlessever
: #u<?unlessever ( u1 #u2 -- )  [DUPIFEVERNOTBELOW], ;
: #u≥?unlessever ( u1 #u2 -- )  [DUPIFEVERBELOW], ; alias #u>=unlessever
: #u>?unlessever ( u1 #u2 -- )  [DUPIFEVERNOTABOVE], ;
: #u≤?unlessever ( u1 #u2 -- )  [DUPIFEVERABOVE], ; alias #u<=unlessever

: ##?unless ( u ## -- )  [BTUNLESS], ;
: ##+?unless ( u ## -- )  [BTSUNLESS], ;
: ##-?unless ( u ## -- )  [BTRUNLESS], ;  alias ##−?unless
: ##~?unless ( u ## -- )  [BTCUNLESS], ;  alias ##×?unless

: #.s ( -- )  [DEBUGLIT], ;

:( Writes string a$ to stdout. )
: }. ( #a$ -- )  c" $." compile ;
:( Writes string a$ to stderr. )
: }.. ( #a$ -- )  c" e$." compile ;
:( Logs string a$. )
: }log ( #a$ -- )  c" log+" compile  c" $." compile  c" log-" compile ;
:( Writes error a$ with a leading cr. )
: }! ( #a$ -- )  c" ecr" compile  c" err+" compile  c" e$." compile  c" err-" compile ;
:( Formats string a$ with u arguments ... and writes it to stdout. )
: }|. ( ... u #a$ -- )  c" |$|" compile  c" $." compile ;
:( Formats string a$ with u arguments ... and writes it to stderr. )
: }|.. ( ... u #a$ -- )  c" |$|" compile  c" e$." compile ;
:( Formats string a$ with u arguments ... and logs it. )
: }|log ( ... u #a$ -- )  c" log+" compile  c" |$|" compile  c" $." compile  c" log-" compile ;
:( Formats error message a$ with u arguments ... and writes it to stderr with a leading cr. )
: }|! ( ... u #a$ -- )
  c" ecr" compile  c" err+" compile  c" |$|" compile  c" e$." compile  c" err-" compile ;
:( Formats string a$ with u arguments ... and returns composite b$. )
: }| ( ... u #a$ -- b$ )  c" |$|" compile ;
:( Punches string into data segment. )
: }, ( #a$ -- )  punchString, ;
:( Prints string a$ with a leading cr to stderr and aborts the process. )
: }abort ( #a$ -- )  }!  c" abort" compile ;
:( Formats string a$ with u arguments ..., prints it to stderr with a leading cr, and aborts the
   process. )
: }|abort ( ... u #a$ -- )  }|!  c" abort" compile ;

:( Non-destructively checks if x1 is zero, starting an if-clause. )
: 0=if ( x1 -- )  IFZERO, ;
:( Non-destructively checks if x1 is not zero, starting an if-clause. )
: 0≠if ( x1 -- )  IFNOTZERO, ; alias 0-if
:( Non-destructively checks if x1 is negative, starting an if-clause. )
: 0<if ( x1 -- )  IFNEGATIVE, ;
:( Non-destructively checks if x1 is positive, starting an if-clause. )
: 0>if ( x1 -- )  IFPOSITIVE, ;
:( Non-destructively checks if x1 is not negative [i.e. >= 0], starting an if-clause. )
: 0≥if ( x1 -- )  IFNOTNEGATIVE, ;
:( Non-destructively checks if x1 is not positive [i.e. <= 0], starting an if-clause. )
: 0≤if ( x1 -- )  IFNOTPOSITIVE, ;
:( Non-destructively checks if x1 is zero, starting an if-clause. )
: 0=?if ( x1 -- )  DUPIFZERO, ;
:( Non-destructively checks if x1 is not zero, starting an if-clause. )
: 0≠?if ( x1 -- )  DUPIFNOTZERO, ; alias 0-?if
:( Non-destructively checks if x1 is negative [i.e. < 0], starting an if-clause. )
: 0<?if ( x1 -- )  DUPIFNEGATIVE, ;
:( Non-destructively checks if x1 is positive [i.e. > 0], starting an if-clause. )
: 0>?if ( x1 -- )  DUPIFPOSITIVE, ;
:( Non-destructively checks if x1 is not negative [i.e. >= 0], starting an if-clause. )
: 0≥?if ( x1 -- )  DUPIFNOTNEGATIVE, ;
:( Non-destructively checks if x1 is not positive [i.e. <= 0], starting an if-clause. )
: 0≤?if ( x1 -- )  DUPIFNOTPOSITIVE, ;

:( Semi-destructively checks if x1 is equal to x2, starting an if-clause. )
: =?if ( x1 x2 -- x1 )  DUPIFEQUAL, ;
:( Semi-destructively checks if x1 is not equal to x2, starting an if-clause. )
: ≠?if ( x1 x2 -- x1 )  DUPIFNOTEQUAL, ; alias <>if  alias -if
:( Semi-destructively checks if n1 is less than n2, starting an if-clause. )
: <?if ( n1 n2 -- x1 )  DUPIFLESS, ;
:( Semi-destructively checks if n1 is not less than n2, starting an if-clause. )
: ≥?if ( n1 n2 -- x1 )  DUPIFNOTLESS, ; alias >=if
:( Semi-destructively checks if n1 is greater than n2, starting an if-clause. )
: >?if ( n1 n2 -- x1 )  DUPIFGREATER, ;
:( Semi-destructively checks if n1 is not greater than n2, starting an if-clause. )
: ≤?if ( n1 n2 -- x1 )  DUPIFNOTGREATER, ; alias <=if
:( Semi-destructively checks if u1 is less than u2, starting an if-clause. )
: u<?if ( u1 u2 -- x1 )  DUPIFBELOW, ;
:( Semi-destructively checks if u1 is not less than u2, starting an if-clause. )
: u≥?if ( u1 u2 -- x1 )  DUPIFNOTBELOW, ; alias u>=if
:( Semi-destructively checks if u1 is greater than u2, starting an if-clause. )
: u>?if ( u1 u2 -- x1 )  DUPIFABOVE, ;
:( Semi-destructively checks if u1 is not greater than u2, starting an if-clause. )
: u≤?if ( u1 u2 -- x1 )  DUPIFNOTABOVE, ; alias u<=if

:( Non-destructively checks if x1 is equal to x2, starting an if-clause. )
: =??if ( x1 x2 -- x1 x2 )  2DUPIFEQUAL, ;
:( Non-destructively checks if x1 is not equal to x2, starting an if-clause. )
: ≠??if ( x1 x2 -- x1 x2 )  2DUPIFNOTEQUAL, ; alias <>if  alias -if
:( Non-destructively checks if n1 is less than n2, starting an if-clause. )
: <??if ( n1 n2 -- x1 x2 )  2DUPIFLESS, ;
:( Non-destructively checks if n1 is not less than n2, starting an if-clause. )
: ≥??if ( n1 n2 -- x1 x2 )  2DUPIFNOTLESS, ; alias >=if
:( Non-destructively checks if n1 is greater than n2, starting an if-clause. )
: >??if ( n1 n2 -- x1 x2 )  2DUPIFGREATER, ;
:( Non-destructively checks if n1 is not greater than n2, starting an if-clause. )
: ≤??if ( n1 n2 -- x1 x2 )  2DUPIFNOTGREATER, ; alias <=if
:( Non-destructively checks if u1 is less than u2, starting an if-clause. )
: u<??if ( u1 u2 -- x1 x2 )  2DUPIFBELOW, ;
:( Non-destructively checks if u1 is not less than u2, starting an if-clause. )
: u≥??if ( u1 u2 -- x1 x2 )  2DUPIFNOTBELOW, ; alias u>=if
:( Non-destructively checks if u1 is greater than u2, starting an if-clause. )
: u>??if ( u1 u2 -- x1 x2 )  2DUPIFABOVE, ;
:( Non-destructively checks if u1 is not greater than u2, starting an if-clause. )
: u≤??if ( u1 u2 -- x1 x2 )  2DUPIFNOTABOVE, ; alias u<=if

:( Checks if x1 is equal to x2, starting an if-clause. )
: =if ( x1 x2 -- )  IFEQUAL, ;
:( Checks if x1 is not equal to x2, starting an if-clause. )
: ≠if ( x1 x2 -- )  IFNOTEQUAL, ; alias <>if  alias -if
:( Checks if n1 is less than n2, starting an if-clause. )
: <if ( n1 n2 -- )  IFLESS, ;
:( Checks if n1 is not less than n2, starting an if-clause. )
: ≥if ( n1 n2 -- )  IFNOTLESS, ; alias >=if
:( Checks if n1 is greater than n2, starting an if-clause. )
: >if ( n1 n2 -- )  IFGREATER, ;
:( Checks if n1 is not greater than n2, starting an if-clause. )
: ≤if ( n1 n2 -- )  IFNOTGREATER, ; alias <=if
:( Checks if u1 is less than u2, starting an if-clause. )
: u<if ( u1 u2 -- )  IFBELOW, ;
:( Checks if u1 is not less than u2, starting an if-clause. )
: u≥if ( u1 u2 -- )  IFNOTBELOW, ; alias u>=if
:( Checks if u1 is greater than u2, starting an if-clause. )
: u>if ( u1 u2 -- )  IFABOVE, ;
:( Checks if u1 is not greater than u2, starting an if-clause. )
: u≤if ( u1 u2 -- )  IFNOTABOVE, ; alias u<=if

:( Checks if x1 is equal to x2, starting an if-clause. )
: =ifever ( x1 x2 -- )  IFEVEREQUAL, ;
:( Checks if x1 is not equal to x2, starting an if-clause. )
: ≠ifever ( x1 x2 -- )  IFEVERNOTEQUAL, ; alias <>if  alias -if
:( Checks if n1 is less than n2, starting an if-clause. )
: <ifever ( n1 n2 -- )  IFEVERLESS, ;
:( Checks if n1 is not less than n2, starting an if-clause. )
: ≥ifever ( n1 n2 -- )  IFEVERNOTLESS, ; alias >=if
:( Checks if n1 is greater than n2, starting an if-clause. )
: >ifever ( n1 n2 -- )  IFEVERGREATER, ;
:( Checks if n1 is not greater than n2, starting an if-clause. )
: ≤ifever ( n1 n2 -- )  IFEVERNOTGREATER, ; alias <=if
:( Checks if u1 is less than u2, starting an if-clause. )
: u<ifever ( u1 u2 -- )  IFEVERBELOW, ;
:( Checks if u1 is not less than u2, starting an if-clause. )
: u≥ifever ( u1 u2 -- )  IFEVERNOTBELOW, ; alias u>=if
:( Checks if u1 is greater than u2, starting an if-clause. )
: u>ifever ( u1 u2 -- )  IFEVERABOVE, ;
:( Checks if u1 is not greater than u2, starting an if-clause. )
: u≤ifever ( u1 u2 -- )  IFEVERNOTABOVE, ; alias u<=if

:( Checks if x1 is equal to x2, starting an if-clause. )
: =unless ( x1 x2 -- )  IFNOTEQUAL, ;
:( Checks if x1 is not equal to x2, starting an if-clause. )
: ≠unless ( x1 x2 -- )  IFEQUAL, ; alias <>unless  alias -unless
:( Checks if n1 is less than n2, starting an if-clause. )
: <unless ( n1 n2 -- )  IFNOTLESS, ;
:( Checks if n1 is not less than n2, starting an if-clause. )
: ≥unless ( n1 n2 -- )  IFLESS, ; alias >=unless
:( Checks if n1 is greater than n2, starting an if-clause. )
: >unless ( n1 n2 -- )  IFNOTGREATER, ;
:( Checks if n1 is not greater than n2, starting an if-clause. )
: ≤unless ( n1 n2 -- )  IFGREATER, ; alias <=unless
:( Checks if u1 is less than u2, starting an if-clause. )
: u<unless ( u1 u2 -- )  IFNOTBELOW, ;
:( Checks if u1 is not less than u2, starting an if-clause. )
: u≥unless ( u1 u2 -- )  IFBELOW, ; alias u>=unless
:( Checks if u1 is greater than u2, starting an if-clause. )
: u>unless ( u1 u2 -- )  IFNOTABOVE, ;
:( Checks if u1 is not greater than u2, starting an if-clause. )
: u≤unless ( u1 u2 -- )  IFABOVE, ; alias u<=unless

:( Semi-destructively checks if x1 is equal to x2, starting an if-clause. )
: =?unless ( x1 x2 -- x1 )  DUPIFNOTEQUAL, ;
:( Semi-destructively checks if x1 is not equal to x2, starting an if-clause. )
: ≠?unless ( x1 x2 -- x1 )  DUPIFEQUAL, ; alias <>if  alias -if
:( Semi-destructively checks if n1 is less than n2, starting an if-clause. )
: <?unless ( n1 n2 -- x1 )  DUPIFNOTLESS, ;
:( Semi-destructively checks if n1 is not less than n2, starting an if-clause. )
: ≥?unless ( n1 n2 -- x1 )  DUPIFLESS, ; alias >=if
:( Semi-destructively checks if n1 is greater than n2, starting an if-clause. )
: >?unless ( n1 n2 -- x1 )  DUPIFNOTGREATER, ;
:( Semi-destructively checks if n1 is not greater than n2, starting an if-clause. )
: ≤?unless ( n1 n2 -- x1 )  DUPIFGREATER, ; alias <=if
:( Semi-destructively checks if u1 is less than u2, starting an if-clause. )
: u<?unless ( u1 u2 -- x1 )  DUPIFNOTBELOW, ;
:( Semi-destructively checks if u1 is not less than u2, starting an if-clause. )
: u≥?unless ( u1 u2 -- x1 )  DUPIFBELOW, ; alias u>=if
:( Semi-destructively checks if u1 is greater than u2, starting an if-clause. )
: u>?unless ( u1 u2 -- x1 )  DUPIFNOTABOVE, ;
:( Semi-destructively checks if u1 is not greater than u2, starting an if-clause. )
: u≤?unless ( u1 u2 -- x1 )  DUPIFABOVE, ; alias u<=if

:( Non-destructively checks if x1 is equal to x2, starting an if-clause. )
: =??unless ( x1 x2 -- x1 x2 )  2DUPIFNOTEQUAL, ;
:( Non-destructively checks if x1 is not equal to x2, starting an if-clause. )
: ≠??unless ( x1 x2 -- x1 x2 )  2DUPIFEQUAL, ; alias <>if  alias -if
:( Non-destructively checks if n1 is less than n2, starting an if-clause. )
: <??unless ( n1 n2 -- x1 x2 )  2DUPIFNOTLESS, ;
:( Non-destructively checks if n1 is not less than n2, starting an if-clause. )
: ≥??unless ( n1 n2 -- x1 x2 )  2DUPIFLESS, ; alias >=if
:( Non-destructively checks if n1 is greater than n2, starting an if-clause. )
: >??unless ( n1 n2 -- x1 x2 )  2DUPIFNOTGREATER, ;
:( Non-destructively checks if n1 is not greater than n2, starting an if-clause. )
: ≤??unless ( n1 n2 -- x1 x2 )  2DUPIFGREATER, ; alias <=if
:( Non-destructively checks if u1 is less than u2, starting an if-clause. )
: u<??unless ( u1 u2 -- x1 x2 )  2DUPIFNOTBELOW, ;
:( Non-destructively checks if u1 is not less than u2, starting an if-clause. )
: u≥??unless ( u1 u2 -- x1 x2 )  2DUPIFBELOW, ; alias u>=if
:( Non-destructively checks if u1 is greater than u2, starting an if-clause. )
: u>??unless ( u1 u2 -- x1 x2 )  2DUPIFNOTABOVE, ;
:( Non-destructively checks if u1 is not greater than u2, starting an if-clause. )
: u≤??unless ( u1 u2 -- x1 x2 )  2DUPIFABOVE, ; alias u<=if

:( Compares strings a1$ and a2$ for equality, returning true if both are equal, otherwise false. )
: $$=if ( a1$ a2$ -- )  [IFSTREQ], ;

:( Tests bit # in u. )
: bit?if ( u # -- )  BTIF, ;
:( Tests bit # at a. )
: bit@if ( a # -- ) BTATIF, ;
:( Tests bit # at a. )
: bit@unless ( a # -- ) BTATUNLESS, ;
