/* FORCE Vocabulary (64-bit)
 * =========================
 * version 0
 */

vocabulary FORTH

=== Memory Operations ===

--- Fetch and Store ---

( Stores byte c at address a. )
: c! ( c a -- )  CSTORE, ;  alias b!
( Stores word w at address a. )
: w! ( w a -- )  WSTORE, ;  alias s!
( Stores double-word d at address a. )
: d! ( d a -- )  DSTORE, ;  alias i!
( Stores quad-word q at address  a. )
: q! ( q a -- )  QSTORE, ;  alias l! alias !
( Stores oct-word o at address a. )
: o! ( o₂ o₁ a -- )  OSTORE, ;  alias v!  alias 2!

( Sets cell at address a to true. )
: on ( a -- )  -1! ;
( Stes cell at address a to false. )
: off ( a -- )  0! ;

( Fetch signed byte from address )
: b@ ( a -- b )  BFETCH, ;
( Fetch unsigned byte from address )
: c@ ( a -- c )  CFETCH, ;
( Fetch signed word from address )
: s@ ( a -- s )  SFETCH, ;
( Fetch unsigned word from address )
: w@ ( a -- w )  WFETCH, ;
( Fetch signed double word from address )
: i@ ( a -- i )  IFETCH, ;
( Fetch unsigned double word from address )
: d@ ( a -- d )  DFETCH, ;
( Fetch signed quad word from address )
: l@ ( a -- l )  QFETCH, ;
( Fetch unsigned quad word from address )
: q@ ( a -- q )  QFETCH, ;  alias @
( Fetch signed oct word from address )
: v@ ( a -- v₂ v₁ )  OFETCH, ;
( Fetch unsigned oct word from address )
: o@ ( a -- o₂ o₁ )  OFETCH, ;  alias 2@

( Store and pre/post-inc/dec )
: c!++ ( c a -- a+1 )  CSTOREINC, ;
: w!++ ( w a -- a+2 )  WSTOREINC, ;
: d!++ ( d a -- a+4 )  DSTOREINC, ;
: q!++ ( q a -- a+8 )  QSTOREINC, ;  alias !++

: !++c ( a c -- a+1 )  STOREINCC, ;
: !++w ( a w -- a+2 )  STOREINCW, ;
: !++d ( a d -- a+4 )  STOREINCD, ;
: !++q ( a q -- a+8 )  STOREINCQ, ;  alias !++x

: --c! ( c a -- a-1 )  CDECSTORE, ;  alias −−c!
: --w! ( w a -- a-2 )  WDECSTORE, ;  alias −−w!
: --d! ( d a -- a-4 )  DDECSTORE, ;  alias −−d!
: --q! ( q a -- a-8 )  QDECSTORE, ;  alias −−q! alias --! alias −−!

: --!c ( a c -- a-1 )  DECSTOREC, ;  alias −−!c
: --!w ( w a -- a-2 )  DECSTOREW, ;  alias −−!w
: --!d ( d a -- a-4 )  DECSTORED, ;  alias −−!d
: --!q ( q a -- a-8 )  DECSTOREQ, ;  alias −−!q alias --!x alias −−!x

: c!-- ( c a -- a-1 )  CSTOREDEC, ;  alias c!−−
: w!-- ( w a -- a-2 )  WSTOREDEC, ;  alias w!−−
: d!-- ( d a -- a-4 )  DSTOREDEC, ;  alias d!−−
: q!-- ( x a -- a-8 )  QSTOREDEC, ;  alias q!−− alias !-- alias !−−

: b@++ ( a -- a+1 b )  FETCHINCB, ;
: c@++ ( a -- a+1 c )  FETCHINCC, ;  alias count
: s@++ ( a -- a+2 s )  FETCHINCS, ;
: w@++ ( a -- a+2 w )  FETCHINCW, ;  alias wcount
: i@++ ( a -- a+4 i )  FETCHINCI, ;
: d@++ ( a -- a+4 d )  FETCHINCD, ;  alias dcount
: h@++ ( a -- a+8 l )  FETCHINCH, ;
: q@++ ( a -- a+8 q )  FETCHINCQ, ;  alias @++

: --b@ ( a -- a−1 b )  DECFETCHB, ;
: --c@ ( a -- a−1 c )  DECFETCHC, ;
: --s@ ( a -- a−2 s )  DECFETCHS, ;
: --w@ ( a -- a−2 w )  DECFETCHW, ;
: --i@ ( a -- a−4 i )  DECFETCHI, ;
: --d@ ( a -- a−4 d )  DECFETCHD, ;
: --h@ ( a -- a−8 l )  DECFETCHH, ;
: --q@ ( a -- a−8 q )  DECFETCHQ, ;  alias --@

: xchg ( x a -- x' a )  XCHG, ;

--- Floating Point Fetch and Store ---

( Stores top of float stack )
: f! ( a -- |F: f -- )  FSTORE, ;
( Pushes float at address to float stack )
: f@ ( a -- |F: -- f )  FFETCH, ;

=== Stack Operations ===

--- Parameter Stack Operations ---

variable INITSP

( Returns the initial parameter stack pointer. )
: sp0 ( -- u )  INITSP @ ;
( Returns the current parameter stack pointer. )
: sp@ ( -- u )  GETSP, ;
( Sets the parameter stack pointer to u. )
: sp! ( u -- )  SETSP, ;
( Pushes parameter stack depth. )
: depth ( -- n )  sp@ sp0 RMINUS, 3 SHR, ;

( Copies nth stack element over top of stack. )
: pick ( ... n -- ... x1 )  PICK, ;
( Rolls u-tuple of stack down. )
: roll ( n₀ n₁ n₂ ... n₎ u -- n₁ n₂ ... n₎ n₀ )  ROLL, ;
( Rolls u-tuple of stack up. )
: -roll ( n₁ n₂ ... n₍ n₎ u -- n₎ n₁ ... n₍ )  UNROLL, ;
( Duplicates top of stack. := 0 pick )
: dup ( x -- x x ) DUP, ;
( Drops top of stack. )
: drop ( x -- )  DROP, ;
( Swaps top and second of stack. := 2 roll )
: swap ( x₁ x₂ -- x₂ x₁ )  SWAP, ;
( Copies second of stack over top of stack. := 1 pick )
: over ( x₁ x₂ -- x₁ x₂ x₁ )  OVER, ;
( Tucks top of stack behind second of stack. := swap over )
: tuck ( x₁ x₂ -- x₂ x₁ x₂ )  TUCK, ;
( Drops second of stack. )
: nip ( x₁ x₂ -- x₂ )  NIP, ;
( Replaces top of stack with second of stack. := drop dup )
: smash ( x₁ x₂ -- x₁ x₁ )  SMASH, ;
( Moves third of stack before top of stack. := 3 roll )
: rot ( x₁ x₂ x₃ -- x₂ x₃ x₁ )  ROT, ;
( Moves top of stack behind third of stack. := 3 -roll )
: -rot ( x₁ x₂ x₃ -- x₃ x₁ x₂ )  UNROT, ;
( Flips the first and third stack entry. ∢ -rot swap )
: flip ( x₁ x₂ x₃ -- x₃ x₂ x₁ )  FLIP, ;
( Swaps the second and third stack entry. ∢ rot swap )
: slide ( x₁ x₂ x₃ -- x₂ x₁ x₃ )  SLIP, ;

( Duplicates top stack pair. )
: 2dup ( x y -- x y x y )  2DUP, ;
( Drops top of stack pair. )
: 2drop ( x y -- )  2DROP, ;
( Swaps top and second of stack pair. )
: 2swap ( x1 y1 x2 y2 -- x2 y2 x1 y1 )  2SWAP, ;
( Copies second of stack pair over top pair. )
: 2over ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )  2OVER, ;
( Drops second of stack pair. )
: 2nip ( x1 y1 x2 y2 -- x2 y2 )  2NIP, ;

( Drops u entries from parameter stack. )
: udrop ( x1 .. x# # -- )  UDROP, ;

--- Return Stack Operations ---

variable INITRP                   ( Initial stack pointer )

( Returns the initial return stack pointer. )
: rp0 ( -- u )  INITRP @ ;
( Returns the current return stack pointer. )
: rp@ ( -- u )  GETRP, ;
( Move top of return stack to parameter stack )
: r> ( -- x |R: x -- )  FROMR, ;
( Move top of parameter stack to return stack )
: >r ( x -- |R: -- x )  TOR, ;
( Copy top of return stack to parameter stack )
: r@ ( -- x |R: x -- x )  RFETCH, ;
( Copy top of parameter stack to return stack )
: r! ( x -- x |R: -- x )  RCOPY, ;
( Drop top of return stack )
: rdrop ( -- |R: x -- )  RDROP, ;
( Duplicate top of return stack )
: rdup ( -- |R: x -- x x )  RDUP, ;
( Inner loop index )
: i ( -- index |R: limit index -- limit index )  LOOPINDEX, ;
( Inner loop limit )
: limit ( -- limit |R: limit index -- limit index )  LOOPLIMIT, ;
( Outer loop index )
: j ( -- index1 |R: limit1 index1 limit2 index2 -- limit1 index1 limit2 index2 )  LOOPINDEX2, ;
( Outer loop limit )
: ljmit ( -- limit1 |R: limit1 index1 limit2 index2 -- limit1 index1 limit2 index2 )  LOOPLIMIT2, ;
( Prepare for leaving a DO-LOOP loop. )
: unloop ( -- )  2RDROP, ;
( Push return stack depth )
: rdepth ( -- n )  rp0 rp@ RMINUS, 1- 3 SHR, ;

--- X-Stack Operations ---

variable INITXP
variable CURRXP
create XP  512 cells 0allot

( Returns the initial X stack pointer. )
: xp0 ( -- u )  INITXP @ ;
( Returns the current X stack pointer. )
: xp@ ( -- u )  CURRXP @ ;
( Moves top of X stack to parameter stack. )
: x> ( -- x |X: x -- )  XP CURRXP dup @ cell- over ! @ PLUS, @ ;
( Moves top of parameter stack to X stack. )
: >x ( x -- |X: -- x )  XP xp@ PLUS, !  CURRXP cell+! ;
( Copy top of X stack to parameter stack )
: x@ ( -- x |X: x -- x )  XP xp@ cell MINUS, PLUS, @ ;
( Copy top of parameter stack to X stack )
: x! ( x -- x |X: -- x )  dup >x ;
( Drop top of X stack )
: xdrop ( -- |X: x -- )  CURRXP cell-! ;

--- Floating Point Stack ---

( Duplicate top of float stack )
: fdup ( |F: f -- f f )  FDUP, ;
( Drop top of float stack )
: fdrop ( |F: f -- )  FDROP, ;
( Copy second of float stack over top )
: fover ( |F: f1 f2 -- f1 f2 f1 )  FOVER, ;

( Duplicate two floats )
: f2dup ( |F: f1 f2 -- f1 f2 f1 f2 )  F2DUP, ;

=== Stack Arithmetic ===

--- Constants ---

( Push 0 )
: 0 ( -- 0 )  ZERO, ;  alias false
( Push 1 )
: 1 ( -- 1 )  ONE, ;
( Push -1 )
: -1 ( -- -1 )  MINUS_ONE, ;  alias true
( Push blank )
: bl ( -- '␣' )  BLANK, ;  alias ␣

--- Arithmetics ---

( Adds x2 to x1. )
: + ( x1 x2 -- x1+x2 )  PLUS, ;
( Subtracts x2 from x1. )
: - ( x1 x2 -- x1−x2 )  MINUS, ;  alias −
( Subtracts x1 from x2. )
: r- ( x1 x2 -- x2−x1 )  RMINUS, ;  alias r−
( Multiplies n1 with n2. )
: * ( n1 n2 -- n1×n2 )  TIMES, ;  alias ×
( Multiplies u1 with u2. )
: u* ( u1 u2 -- u1×u2 )  UTIMES, ;  alias u×
( Divides n1 through n2. )
: / ( n1 n2 -- n1÷n2 )  THROUGH, ;  alias ÷
( Divides n2 through n1. )
: r/ ( n1 n2 -- n2÷n1 )  RTHROUGH, ;  alias r÷
( Divides u1 through u2. )
: u/ ( u1 u2 -- u1÷u2 )  UTHROUGH, ;  alias u÷
( Divides u2 through u1. )
: ur/ ( u1 u2 -- u2÷u1 )  URTHROUGH, ;  alias ur÷
( Calculates rest of n1 through n2. )
: mod ( n1 n2 -- n1%n2. )  MODULO, ;  alias %
( Calculates rest of n2 through n1. )
: rmod ( n1 n2 -- n2%n1 )  RMODULO, ;  alias %%
( Calculates rest of u1 through u2. )
: umod ( u1 u2 -- u1%u2 )  UMODULO, ;  alias u%
( Calculates rest of u2 through u1. )
: urmod ( u1 u2 -- u2%u1 )  URMODULO, ;  alias r%%
( Calculates quotient and rest of n1 through n2. )
: /mod ( n1 n2 -- n1%n2 n1/n2 )  QUOTREM, ;  alias ÷%
( Calculates quotient and rest of n2 through n1. )
: r/mod ( n1 n2 -- n2%n1 n2/n1 )  RQUOTREM, ;
( Calculates quotient and rest of u1 through u2. )
: u/mod ( u1 u2 -- u1%u2 u1/u2 )  UQUOTREM, ;

: nxt ( x1 x2 -- x1+1 x2 )  NXT, ;

: twice ( n -- 2×n )  1 SAL, ;
( Multiplies n with 10. )
: 10* ( n -- 10×n )  TEN_TIMES, ;
: cells ( n -- n×cell )  CELLS, ;

--- Negate, Absolute value, Min, Max, Rounding ---

( Negatea top of stack. )
: neg ( n -- −n )  NEG, ;  alias negate
( Returns the absolute value of top of stack. )
: abs ( n -- |n| )  ABS, ;
( Selects the lesser of two signed numbers. )
: min ( n1 n2 -- n3 )  MIN2, ;
( Selects the greater of two signed numbers. )
: max ( n1 n2 -- n3 )  MAX2, ;
( Selects the lesser of two unsigned numbers. )
: umin ( u1 u2 -- u3 )  UMIN2, ;
( Selects the greater of two unsigned numbers. )
: umax ( u1 u2 -- u3 )  UMAX2, ;
( Selects the least of # signed numbers. )
: nmin ( n1 ... n# # -- n )  maxcellv LIT8, swap 0 udo  min  loop ;
( Selects the greatest of # signed numbers. )
: nmax ( n1 ... n# # -- n )  mincellv LIT8, swap 0 udo  max  loop ;
( Selects the least of # unsigned numbers. )
: numin ( u1 ... u# # -- u )  -1 swap 0 udo  umin  loop ;
( Selects the greatest of # unsigned numbers. )
: numax ( u1 ... u# # -- u )  0 swap 0 udo  umax  loop ;
( Returns size # in bytes of n.  Note that size of n=0 will be reported as 0, so to get at least 1,
  use "nsize 1 max" )
: nsize ( n -- n # )  NSIZE, ;
( Returns size # in bytes of u.  See also comment on nsize. )
: usize ( u -- u # )  USIZE, ;

( Rounds u1 up to the next multiple of u2. )
: >| ( u1 u2 ... u1' )  UROUNDUP, ;

--- Logical Operations ---

( ANDs u1 with u2. )
: and ( u1 u2 -- u1⊙u2 )  AND, ;
( ORs u1 with u2. )
: or ( u1 u2 -- u1⊕u2 )  OR, ;
( XORs u1 with u2. )
: xor ( u1 u2 -- u1¤u2 )  XOR, ;
( ANDs u1 with NOT u2. )
: andn ( u1 u2 -- u1⊙~u2 )  ANDN, ;
( Complement top of stack )
: not ( x -- ¬x )  NOT, ;
( Normalize boolean )
: 0− ( x -- x≠0 )  NORMBOOL, ;  alias 0-

--- Shift and Rotate Operations ---

( Shift n arithmetically left by # bits. )
: << ( n # -- n<<# )  SAL, ;
( Shift u logically left by # bits. )
: u<< ( u # -- u<<# )  SHL, ;
( Shift n arithmetically right by # bits. )
: >> ( n # -- n>># )  SAR, ;
( Shift u logically right by # bits. )
: u>> ( u # -- u>># )  SHR, ;
( Rotates u left by # bits. )
: <u< ( u # -- <u<# )  ROL, ;
( Rotates u right by # bits. )
: >u> ( u # -- >u># )  ROR, ;
( Rotates u left through carry by # bits. )
: <u<c ( u # -- <u<c# )  RCL, ;
( Rotates u right through carry by # bits. )
: c>u> ( u # -- c>u># )  RCR, ;

--- Bit Operations ---

( Checks if bit # in u is set. )
: bit? ( u # -- ? )  BT, ;
( Sets bit # in u and returns its previous state. )
: bit+? ( u # -- u' ? )  BTS, ;
( Clears bit # in u and returns its previous state. )
: bit-? ( u # -- u' ? )  BTR, ;  alias bit−?
( Flips bit # in u and returns its previous state. )
: bit~? ( u # -- u' ? )  BTC, ;  alias bit×?
( Sets bit # in u. )
: bit+ ( u # -- u' )  BS, ;
( Clears bit # in u. )
: bit- ( u # -- u' )  BR, ;  alias bit−
( Flips bit # in u. )
: bit~  ( u # -- u' )  BC, ;  alias bit×
( Creates a bit pattern of u [max. 64] consecutive 1-bits in the lesser significant part. )
: bits ( u -- p )  BITS, ;
( Returns bit mask u with all zeroes, but bit # set. )
: bit ( # -- u )  BIT, ;

( Finds position # of the least significant 1-bit in u, returning -1 if u was all zeroes. )
: 1<- ( u -- # )  BSF1, ;
( Finds position # of the most significant 1-bit in u, returning -1 if u was all zeroes. )
: 1-> ( u -- # )  BSR1, ;
( Finds position # of the least significant 0-bit in u, returning -1 if u was all ones. )
: 0<- ( u -- # )  BSF0, ;
( Finds position # of the most significant 0-bit in u, returning -1 if u was all ones. )
: 0-> ( u -- # )  BSR0, ;
( Finds position # of the least significant 0-bit in c, returning -1 if c was all ones. )
: c0<- ( c -- # )  CBSF0, ;
( Finds position # of the most significant 0-bit in c, returning -1 if c was all ones. )
: c0-> ( c -- # )  CBSR0, ;

=== Comparison and Test ===

( Part of this are immediate compiler words )

: within ( n low high -- low≤n<high )  ISWITHIN, ;
( Test if unsigned number within a range [lower limit included, upper excluded] )
: between ( u1 ulow uhigh -- ulow≤u1<uhigh )  ISBETWEEN, ;
( Duplicate top of stack unless zero )
: ?dup ( x -- [x] x )  DUPIF, ;

=== Floating Point Arithmetic ===

--- Constants ---

( Pushes 0.0 onto the float stack. )
: 0.0 ( |F: -- 0.0 )  0.0, ;
( Pushes 1.0 onto the float stack. )
: 1.0 ( |F: -- 1.0 )  1.0, ;
( Pushes -1.0 onto the float stack. )
: −1.0 ( |F: -- -1.0 )  -1.0, ;  alias -1.0
( Pushes π onto the float stack. )
: π ( |F: -- π )  PI, ;  alias pi

--- Arithmetic Operations ---

( Add two floats )
: f+ ( |F: f1 f2 -- f1+f2 )  FADD, ;
( Add 32-bit integer to float )
: f+i ( i -- |F: f -- f+i )  FIADD, ;
( Subtract two floats )
: f− ( |F: f1 f2 -- f1−f2 )  FSUB, ;  alias f-
( Subtract 32-bit integer from float )
: f−i ( i -- |F: f -- f−i )  FISUB, ;  alias f-i
( Subtract two floats reverse )
: fr− ( |F: f1 f2 -- f2−f1 )  FSUBR, ;  alias fr-
( Subtract float from 32-bit integer )
: i−f ( i -- |F: f -- i−f )  FISUBR, ;  alias i-f
( Multiply two floats )
: f* ( |F: f1 f2 -- f1+f2 )  FMPY, ;  alias f×
( Multiply 32-bit integer to float )
: f*i ( i -- |F: f -- f*i )  FIMPY, ;  alias f×i
( Divide two floats )
: f/ ( |F: f1 f2 -- f1/f2 )  FDIV, ;  alias f÷
( Divide float through 32-bit integer )
: f/i ( i -- |F: f -- f/i )  FIDIV, ;  alias f÷i
( Divide two floats reverse )
: fr/ ( |F: f1 f2 -- f2/f1 )  FDIVR, ;  alias fr÷
( Divide 32-bit integer through float )
: i/f ( i -- |F: f -- i/f )  FIDIVR, ;  alias i÷f
( Negate top of the float stack )
: fneg ( |F: f -- -f )  FNEG, ;
( Absolute value of the top of the float stack )
: fabs ( |F: f -- |f| )  FABS, ;
( Returns the lesser of two floating point values )
: fmin ( |F: f1 f2 -- f3 )  FMIN2, ;
( Returns the greater of two floating point values )
: fmax ( |F: f1 f2 -- f3 )  FMAX2, ;
( Returns the least of several floating point values )
: fnmin ( # -- |F: f1 ... f# -- f )  0 udo  fmin  loop ;
( Returns the greatest of several floating point values )
: fnmax ( |F: f1 f2 -- f3 )  0 udo  fmax  loop ;

--- Comparison and Test ---

( Test if 0.0 )
: f0= ( -- f=0.0 |F: f -- )  FISZERO, ;
( Test if not 0.0 )
: f0− ( -- f≠0.0 |F: f -- )  FISNOTZERO, ;  alias f0-
( Test if negative )
: f0< ( -- f<0.0 |F: f -- )  FISNEGATIVE, ;
( Test if not negative )
: f0≥ ( -- f≥0.0 |F: f -- )  FISNOTNEGATIVE, ;  alias f0>=
( Test if positive )
: f0> ( -- f>0.0 |F: f -- )  FISPOSITIVE, ;
( Test if not positive )
: f0≤ ( -- f≤0.0 |F: f -- )  FISNOTPOSITIVE, ;  alias f0<=

( Compares two floats for equality )
: f= ( -- f1=f2 |F: f1 f2 -- )  FISEQUAL, ;
( Compares two floats for inequality )
: f≠ ( -- f1≠f2 |F: f1 f2 -- )  FISNOTEQUAL, ;  alias f<>
( Compares if less )
: f< ( -- f1<f2 |F: f1 f2 -- )  FISLESS, ;
( Compares if not less )
: f≥ ( -- f1≥f2 |F: f1 f2 -- )  FISNOTLESS, ;
( Compares if greater )
: f> ( -- f1>f2 |F: f1 f2 -- )  FISGREATER, ;
( Compares if not greater )
: f≤ ( -- f1≤f2 |F: f1 f2 -- )  FISNOTGREATER, ;
( Checks if a float value is within the bounds )
: fwithin ( -- flow≤f<fhigh -- f flow fhigh -- )  FISWITHIN, ;

=== Memory Arithmetic ===

--- Add and Subtract ---

( Adds c to byte at address a. )
: c+! ( c a -- )  CADD, ;  alias b+!
( Adds w to word at address a. )
: w+! ( w a -- )  WADD, ;  alias s+!
( Adds d to double word at address a. )
: d+! ( d a -- )  DADD, ;  alias i+!
( Adds q to quad word at address a. )
: q+! ( q a -- )  QADD, ;  alias l+!  alias +!
( Adds o to oct word at address a. )
: o+! ( o a -- )  OADD, ;  alias v+!

( Subtracts c from byte at address a. )
: c-! ( c a -- )  CSUB, ;  alias c−!  alias b-!  alias b−!
( Subtracts w from word at address a. )
: w-! ( w a -- )  WSUB, ;  alias w−!  alias s-!  alias s−!
( Subtracts d from double word at address a. )
: d-! ( d a -- )  DSUB, ;  alias d−!  alias i-!  alias i−!
( Subtracts q from quad word at address a. )
: q-! ( q a -- )  QSUB, ;  alias q−!  alias l-!  alias l−!  alias -!  alias −!
( Subtracts o from oct word at address a. )
: o-! ( o a -- )  OSUB, ;  alias o−!  alias v-!  alias v−!

--- Multiply and Divide ---

( Multiplies signed byte at address a with b. )
: b*! ( b a -- )  BMPY, ;  alias b×!
( Multiplies unsigned byte at address a with c. )
: c*! ( c a -- )  CMPY, ;  alias c×!
( Multiplies signed word at address a with s. )
: s*! ( s a -- )  SMPY, ;  alias s×!
( Multiplies unsigned word at address a with w. )
: w*! ( w a -- )  WMPY, ;  alias w×!
( Multiplies signed double word at address a with i. )
: i*! ( i a -- )  IMPY, ;  alias i×!
( Multiplies unsigned double word at address a with d. )
: d*! ( d a -- )  DMPY, ;  alias d×!
( Multiplies signed quad word at address a with i. )
: l*! ( l a -- )  LMPY, ;  alias l×!  alias *!  alias ×!
( Multiplies unsigned quad word at address a with q. )
: q*! ( q a -- )  QMPY, ;  alias u*!

( Divides signed byte at address a through b. )
: b/! ( b a -- )  BDIV, ;  alias b÷!
( Divides unsigned byte at address a through c. )
: c/! ( c a -- )  CDIV, ;  alias c÷!
( Divides signed word at address a through s. )
: s/! ( s a -- )  SDIV, ;  alias s÷!
( Divides unsigned word at address a through w. )
: w/! ( w a -- )  WDIV, ;  alias w÷!
( Divides signed double word at address a through i. )
: i/! ( i a -- )  IDIV, ;  alias i÷!
( Divides unsigned double word at address a through d. )
: d/! ( d a -- )  DDIV, ;  alias d÷!
( Divides signed quad word at address a through l. )
: l/! ( l a -- )  LDIV, ;  alias l÷!  alias /!  alias ÷!
( Divides unsigned quad word at address a through q. )
: q/! ( q a -- )  QDIV, ;  alias q÷!  alias u/!  alias u÷!

--- Logical (Including Shift and Bit) Operations ---

( ANDs unsigned byte at address a with c. )
: cand! ( c a -- )  CAND, ;
( ANDs unsigned word at address a with w. )
: wand! ( w a -- )  WAND, ;
( ANDs unsigned double word at address a with d. )
: dand! ( d a -- )  DAND, ;
( ANDs unsigned quad word at address a with q. )
: qand! ( q a -- )  QAND, ;  alias and!

( ORs unsigned byte at address a with c. )
: cor! ( c a -- )  COR, ;
( ORs unsigned word at address a with w. )
: wor! ( w a -- )  WOR, ;
( ORs unsigned double word at address a with d. )
: dor! ( d a -- )  DOR, ;
( ORs unsigned quad word at address a with q. )
: qor! ( q a -- )  QOR, ;  alias or!

( XORs unsigned byte at address a with c. )
: cxor! ( c a -- )  CXOR, ;
( XORs unsigned word at address a with w. )
: wxor! ( w a -- )  WXOR, ;
( XORs unsigned double word at address a with d )
: dxor! ( d a -- )  DXOR, ;
( XORs unsigned quad word at address a with q. )
: qxor! ( q a -- )  QXOR, ;  alias xor!

( Complements unsigned byte at address a. )
: notc! ( a -- )  NOTC, ;
( Complements unsigned word at address a. )
: notw! ( a -- )  NOTW, ;
( Complements unsigned double word at address a. )
: notd! ( a -- )  NOTD, ;
( Complements unsigned quad word at address a. )
: notq! ( a -- )  NOTQ, ;  alias not!

( ANDs unsigned byte at address a with the inverse of c. )
: candn! ( c a -- )  CANDN, ;
( ANDs unsigned word at address a with the inverse of w. )
: wandn! ( w a -- )  WANDN, ;
( ANDs unsigned double word at address a with the inverse of d. )
: dandn! ( d a -- )  DANDN, ;
( ANDs unsigned quad word at address a with the inverse of q. )
: qandn! ( q a -- )  QANDN, ;  alias andn!

( Shifts byte at address a arithmetically left by # bits. )
: b<<! ( # a -- )  BSAL, ;
( Shifts byte at address a arithmetically right by # bits. )
: b>>! ( # a -- )  BSAR, ;
( Shifts byte at address a logically left by # bits. )
: c<<! ( # a -- )  CSHL, ;
( Shifts byte at address a logically right by # bits. )
: c>>! ( # a -- )  CSHR, ;
( Shifts word at address a arithmetically left by # bits. )
: s<<! ( # a -- )  SSAL, ;
( Shifts word at address a arithmetically right by # bits. )
: s>>! ( # a -- )  SSAR, ;
( Shifts word at address a logically left by # bits. )
: w<<! ( # a -- )  WSHL, ;
( Shifts word at address a logically right by # bits. )
: w>>! ( # a -- )  WSHR, ;
( Shifts double word at address a arithmetically left by # bits. )
: i<<! ( # a -- )  ISAL, ;
( Shifts double word at address a arithmetically right by # bits. )
: i>>! ( # a -- )  ISAR, ;
( Shifts double word at address a logically left by # bits. )
: d<<! ( # a -- )  DSHL, ;
( Shifts double word at address a logically right by # bits. )
: d>>! ( # a -- )  DSHR, ;
( Shifts quad word at address a arithmetically left by # bits. )
: l<<! ( # a -- )  LSAL, ;
( Shifts quad word at address a arithmetically right by # bits. )
: l>>! ( # a -- )  LSAR, ;
( Shifts quad word at address a logically left by # bits. )
: q<<! ( # a -- )  QSHL, ;
( Shifts quad word at address a logically right by # bits. )
: q>>! ( # a -- )  QSHR, ;
( Shifts oct word at address a arithmetically left by # bits. )
: v<<! ( # a -- )  VSAL, ;
( Shifts oct word at address a arithmetically right by # bits. )
: v>>! ( # a -- )  VSAR, ;
( Shifts oct word at address a logically left by # bits. )
: o<<! ( # a -- )  OSHL, ;
( Shifts oct word at address a logically right by # bits. )
: o>>! ( # a -- )  OSHR, ;

( Checks if bit # at address a is set. )
: bit@ ( a # -- ? )  BTAT, ;
( Sets and tests bit # at address a. )
: bit+@ ( a # -- ? )  BTSAT, ;
( Clears and tests bit # at address a. )
: bit-@ ( a # -- ? )  BTRAT, ;  alias bit−@
( Flips and tests bit # at address a. )
: bit~@ ( a # -- ? )  BTCAT, ;  alias bit×@
( Sets bit # at address a. )
: bit+! ( a # -- )  BSAT, ;
( Clears bit # at address a. )
: bit-! ( a # -- )  BRAT, ;  alias bit−!
( Flips bit # at address a. )
: bit~! ( a # -- )  BCAT, ;  alias bit×!

( Finds position #2 of the least significant 1-bit in buffer of #1 bytes at address a, returning
   -1 if the buffer was all zeroes. )
: c1<-@ ( a #1 -- #2 )  CBSF1AT, ;
( Finds position #2 of the least significant 0-bit in buffer of #1 bytes at address a, returning
   -1 if the buffer was all zeroes. )
: c0<-@ ( a #1 -- #2 )  CBSF0AT, ;
( Finds position #2 of the most significant 1-bit in buffer of #1 bytes at address a, returning
   -1 if the buffer was all zeroes. )
: c1->@ ( a #1 -- #2 )  CBSR1AT, ;
( Finds position #2 of the most significant 0-bit in buffer of #1 bytes at address a, returning
   -1 if the buffer was all zeroes. )
: c0->@ ( a #1 -- #2 )  CBSR0AT, ;
( Finds position #2 of the least significant 1-bit in buffer of #1 cells at address a, returning
   -1 if the buffer was all zeroes. )
: 1<-@ ( a #1 -- #2 )  BSF1AT, ;
( Finds position #2 of the least significant 0-bit in buffer of #1 cells at address a, returning
   -1 if the buffer was all zeroes. )
: 0<-@ ( a #1 -- #2 )  BSF0AT, ;
( Finds position #2 of the most significant 1-bit in buffer of #1 cells at address a, returning
   -1 if the buffer was all zeroes. )
: 1->@ ( a #1 -- #2 )  BSR1AT, ;
( Finds position #2 of the most significant 0-bit in buffer of #1 cells at address a, returning
   -1 if the buffer was all zeroes. )
: 0->@ ( a #1 -- #2 )  BSR0AT, ;

--- Special Utilities ---

( Multiplies cell at address a with u2, then adds u1.  This utility by the name of "charbuilder" is
   used when building numbers and [e.g. Unicode] characters from digits in a string [then u2 is the
   radix, and u1 is the digit to "append"]. )
: u*+! ( u1 u2 a -- )  CHARBUILD, ;
( Multiplies u2 with u3 and adds u1, resulting in u.  This is typically used to compute the
  address of the u2-th element of size u3 [or the u3-th element of size u2] in array u1. )
: u*+ ( u1 u2 u3 -- u )  ARRINDEX, ;

=== Memory Block Operations ===

( Copies # cells from as to ad; makes sure that ad# does not override as#. )
: move ( as ad # -- )  MOVE, ;
( Copies # bytes from as to ad; makes sure that ad# does not override as#. )
: cmove ( as ad # -- )  CMOVE, ;
( Sets # cells at a upwards to x. )
: fill ( a # x -- )  FILL, ;
( Sets # bytes at a upwards to c. )
: cfill ( a u c -- )  CFILL, ;
( Finds first 1-based position u of cell x in array of length # starting at a, or 0 if not found. )
: find ( a # x -- #|0 )  FIND, ;
( Finds first 1-based position u of char c in string of length # starting at a, or 0 if not found. )
: cfind ( a # c -- #|0 )  CFIND, ;
( Finds last 1-based position u of char c in string of length # starting at a, or 0 if not found. )
: rcfind ( a # c -- #|0 )  RCFIND, ;
( Replaces all occurrences of c1 in a$ with c2. )
: crepl$ ( c1 c2 a$ -- )  CREPLSTR, ;
( Compare two buffers of length # starting at a1 and a2, respectively, for equality. )
: csame ( a1 a2 # -- ? )  CSAME, ;
( Compares strings a1$ and a2$ for equality, returning true if both are equal, otherwise false. )
: $$= ( a1$ a2$ -- ? )  STREQ, ;
( Compares buffers a1 and a2 with length # for equality. )
: aa#= ( a1 a2 # -- ? )  BUFEQ, ;
( Consumes u characters from buffer with length # at address a. )
: +> ( a # u -- a+u #-u )  ADVANCE, ;
( Converts char buffer a with length # to a counted string at address a$. )
: >$ ( a # a$ -- a$ )  r! 2dup c! 1+ swap cmove r> ;
( Copies string a$ to address a — the buffer at a must have enough space to accommodate a$. )
: $! ( a$ a -- )  over c@ 1+ cmove ;
( Appends unicode character uc to buffer a$. )
: uc$+ ( uc a$ -- )  UCAPPEND, ;
( Appends string a2$ to a1$.  a1$ must be in a buffer large enough to accommodate a2$. )
: $$+ ( a1$ a2$ -- a1$ )  over count + over count slide cmove  c@ over c+! ;
( Checks if string a$ is empty. )
: empty$? ( a$ -- a$ ? )  dup c@ 0= ;

( Finds 1-based position # of character uc in dstring of length u starting at a; 0 if not found. )
: dfind ( a u uc -- #|0 )  DFIND, ;

=== Vocabulary Operations ===

variable LAST-WORD

( Returns the address of the last word.  Valid only during compile time. )
: last-word ( -- a )  LAST-WORD @ ;

( Returns dictionary address a of vocabulary @voc. )
: dict@ ( @voc -- a )  @ ;
( Returns code segment address a of vocabulary @voc. )
: code@ ( @voc -- a )  cell+ @ ;
( Returns data segment address a of vocabulary @voc. )
: data@ ( @voc -- a )  2 cells + @ ;
( Returns text segment address a of vocabulary @voc. )
: text@ ( @voc -- a )  3 cells + @ ;
( Returns length u of the dictionary of vocabulary @voc. )
: dict# ( @voc -- u )  4 cells + d@ ;
( Returns length u of the code section of vocabulary @voc. )
: code# ( @voc -- u )  4 cells + 4 + d@ ;
( Returns length u of the data section of vocabulary @voc. )
: data# ( @voc -- u )  4 cells + 8 + d@ ;
( Returns length u of the text section of vocabulary @voc. )
: text# ( @voc -- u )  4 cells + 12 + d@ ;
( Returns number of words # in dictionary of vocabulary @voc. )
: #words ( @voc -- # )  dict# 4 cells u/ ;

=== Word Related Operations ===

( Returns code field address @cf of word @w. )
: CFA ( @w -- @cf )  ;
( Returns parameter field address @pf of word @w. )
: PFA ( @w -- @pf )  cell+ ;
( Returns name field address @nf of word @w. )
: NFA ( @w -- @nf )  2cells+ ;
( Returns flag field address @fl of word @w. )
: FLG ( @w -- @fl )  3cells+ ;
( Rturns size u of a dictionary entry. )
: word# ( -- u )  4cells ;

( Returns code field cf of word @w. )
: CFA@ ( @w -- cf )  CFA @ ;
( Returns parameter field pf of word @w. )
: PFA@ ( @w -- pf )  PFA @ ;
( Returns name field nf of word @w. )
: NFA@ ( @w -- nf )  NFA @ ;
( Returns flag field fl of word @w. )
: FLG@ ( @w -- fl )  FLG @ ;

( Returns name a$ of vocabulary @voc. )
: vocname@ ( @voc -- a$ )  dup dict@ NFA@ swap text@ + ;
( Returns address @w of word with name a$ in vocabulary @voc and true to indicate success, or
  the original name and false indicating failure. )
: findWord ( a$ @voc -- w@ t | a$ f )  dup >x dict@ x@ #words 0 do
  dup NFA@ x@ text@ +  2pick $$= if  x> drop nip true unloop exit  then  word# + loop  x> 2drop  0 ;
( Executes code of word @w in vocabulary @voc. )
: execute ( @voc @w -- )  CFA@ swap code@ + INVOKE, ;
( Executes code at address a. )
: exeqt ( a -- )  INVOKE, ;
( Checks if file a$ has an extension. )
: hasExt? ( a$ -- ? )  dup count '/' rcfind swap count rot +> '.' rcfind 1> ;

=== Conditions ===

( Tests if x is 0. )
: 0= ( x -- x=0 )  ISZERO, ;
( Tests if x is not 0. )
: 0≠ ( x -- x=0 )  ISNOTZERO, ;  alias 0<>
( Tests if x is negative / less than zero. )
: 0< ( x -- x<0 )  ISNEGATIVE, ;
( Tests if x is positive / greater than zero. )
: 0> ( x -- x>0 )  ISPOSITIVE, ;
( Tests if x less than or equal to zero. )
: 0≤ ( x -- x≤0 )  ISNOTPOSITIVE, ;  alias 0<=
( Tests if x is greater than or equal to zero. )
: 0≥ ( x -- x≥0 )  ISNOTNEGATIVE, ;  alias 0>=

( Tests if x is equal to y. )
: = ( x y -- x=y )  ISEQUAL, ;
( Tests if x is not equal to y. )
: ≠ ( x y -- x≠y )  ISNOTEQUAL, ;  alias <>
( Tests if n1 is less than n2. )
: < ( n1 n2 -- n1<n2 )  ISLESS, ;
( Tests if u1 is less than u2. )
: u< ( u1 u2 -- u1<u2 )  ISBELOW, ;
( Tests if n1 is greater than n2. )
: > ( n1 n2 -- n1>n2 )  ISGREATER, ;
( Tests if u1 is greater than u2. )
: u> ( u1 u2 -- u1>u2 )  ISABOVE, ;
( Tests if n1 is less than or equal to n2. )
: ≤ ( n1 n2 -- n1≤n2 )  ISNOTGREATER, ;  alias <=
( Tests if u1 is less than or equal to u2. )
: u≤ ( u1 u2 -- u1≤u2 )  ISNOTABOVE, ;  alias u<=
( Tests if n1 is greater than or equal to n2. )
: ≥ ( n1 n2 -- n1≥n2 )  ISNOTLESS, ;  alias >=
( Tests if u1 is greater than or equal to u2. )
: u≥ ( u1 u2 -- u1≥u2 )  ISNOTBELOW, ;  alias u>=

vocabulary;
