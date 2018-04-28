( Copyright ⓒ 2018. by Coradec LLC. All rights reserved. )

/**
  * FORCE Base Vocabulary.
  */

package force/lang/

vocabulary Forth

  "[%S]" >altername template

public static section

( Checks if the current thread has time left to execute; if not, switches to the next thread in the
  thread list (i.e. makes that thread the current thread), then resumes the current thread. )
protected static :: (next) ( TODO implementation ) ;;

=== Constants ===

( Returns the cell size. )
: cell ( -- cell# )  CELL, ;
( Returns the cell shift. )
: %cell ( -- %cell )  %CELL, ;
( Adds cell size to x. )
: cell+ ( x -- x+cell# )  CELLPLUS, ;
( Multiplies n by cell size. )
: cells ( n -- n*cell# )  CELLS, ;
( Adds n cells to x. )
: cells+ ( x n -- x+n*cell# )  CELLSPLUS, ;
( Divides u by the cell size. )
: cellu/ ( u -- u/cell# )  CELLUBY, ;

( Pushes constant 0. )
: 0 ( -- 0 )  ZERO, ;  alias false
( Pushes constant 1. )
: 1 ( -- 1 )  ONE, ;
( Pushes constant −1. )
: −1 ( -- −1 )  NEGONE, ;  alias true
( Pushes a blank. )
: bl ( -- ␣ )  BLANK, ;  alias ␣

5 cells constant EXCEPT#

--- Initialization Vector ---

0000  dup constant @PSP
cell+ dup constant @RSP
cell+ dup constant @@SourceFile
cell+ dup constant @@SourceLine
cell+ dup constant @@SourceColumn
cell+ dup constant @XSP
cell+ constant ExHandler#

=== Stack Operations ===

 cell variable SP0                ( Initial stack pointer )
 cell variable RP0                ( Initial return stack poointer )

--- Parameter Stack Operations ---

( Returns initial stack pointer sp. )
: sp0 ( -- sp )  SP0@ ;
( Returns stack pointer sp. )
: sp@ ( -- sp )  GETSP, ;
( Sets the stack pointer to sp. )
: sp! ( sp -- )  SETSP, ;
( Returns the number of occupied stack cells. )
: depth ( -- # )  sp0 sp@ MINUS, cellu/ 1- ;

( Duplicates top of parameter stack. )
: dup ( x -- x x )  DUP, ;
( Drops the top of stack. )
: drop ( x -- )  DROP, ;
( Exchanges top and second of stack. )
: swap ( x₁ x₂ -- x₂ x₁ )  SWAP, ;
( Copies second over top of stack. )
: over ( x₁ x₂ -- x₁ x₂ x₁ )  OVER, ;
( Tucks top behind second of stack (swap over). )
: tuck ( x₁ x₂ -- x₂ x₁ x₂ )  TUCK, ;
( Drops second of stack. (swap drop) )
: nip ( x₁ x₂ -- x₂ )  NIP, ;
( Replaces second of stack with top of stack (drop dup). )
: smash ( x₁ x₂ -- x₁ x₁ )  SMASH, ;
( Rotates stack triple up. )
: rot ( x₁ x₂ x₃ -- x₂ x₃ x₁ )  ROT, ;
( Rotates stack triple down. )
: -rot ( x₁ x₂ x₃ -- x₃ x₁ x₂ )  NEGROT, ;
( Flips the first and third stack entry (-rot swap). )
: flip ( x₁ x₂ x₃ -- x₃ x₂ x₁ )  FLIP, ;
( Swaps the second and third stack entry (rot swap). )
: slide ( x₁ x₂ x₃ -- x₂ x₁ x₃ )  SLIDE, ;

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

( Drops u cells. )
: udrop ( ... u -- )  UDROP, ;
( Picks the uth stack cell. )
: pick ( ... u -- ... xu )  PICK, ;
( Rotates u cells on the stack up. )
: roll ( x₁ x₂ ... xu u -- x₂ ... xu x₁ )  ROLL, ;
( Rotates u cells on the stack down. )
: -roll ( x₁ x₂ ... xu u -- x₂ ... xu x₁ )  NEGROLL, ;

( Duplicates top of stack unless it's zero. )
: ?dup ( x -- x [x] )  ?DUP, ;

--- Return Stack Operations ---

( Returns initial return stack pointer rp. )
: rp0 ( -- rp )  RP0@ ;
( Returns return stack pointer rp. )
: rp@ ( -- rp )  GETRP, ;
( Sets the return stack pointer to rp. )
: rp! ( rp -- )  SETRP, ;
( Moves top of return stack to parameter stack. )
: r> ( -- x |R: x -- )  FROMR, ;
( Moves top of parameter stack to return stack. )
: >r ( x -- |R: -- x )  TOR, ;
( Copies top of return stack to parameter stack. )
: r@ ( -- x |R: x -- x )  RFETCH, ;
( Copies top of parameter stack to return stack. )
: r! ( x -- x |R: -- x )  RCOPY, ;
( Drops top of return stack. )
: rdrop ( -- |R: x -- )  RDROP, ;
( Duplicates top of return stack. )
: rdup ( -- |R: x -- x x )  RDUP, ;
( Returns the inner loop index. )
: i ( -- index |R: limit index -- limit index )  LOOPINDEX, ;
( Returns the inner loop limit. )
: limit ( -- limit |R: limit index -- limit index )  LOOPLIMIT, ;
( Retrns the outer loop index. )
: j ( -- index1 |R: limit1 index1 limit2 index2 -- limit1 index1 limit2 index2 )  LOOPINDEX2, ;
( Returns the outer loop limit. )
: ljmit ( -- limit1 |R: limit1 index1 limit2 index2 -- limit1 index1 limit2 index2 )  LOOPLIMIT2, ;
( Prepares for leaving a DO-LOOP loop. )
: unloop ( -- )  2RDROP, ;
( Pushes return stack depth n. )
: rdepth ( -- n )  rp0 rp@ r− cellu/ ;

--- Float Stack Operations ---

( Duplicates top of float stack. )
: fdup ( :F: r -- r r )  FDUP, ;
( Drops top of float stack. )
: fdrop ( :F: r -- )  FDROP, ;
( Swaps top and second of float stack. )
: fswap ( :F: r₁ r₂ -- r₂ r₁ )  FSWAP, ;
( Copies second over top of float stack. )
: fover ( :F: r₁ r₂ -- r₁ r₂ r₁ )  FOVER, ;
( Rotates float stack triple. )
: frot ( :F: r₁ r₂ r₃ -- r₂ r₃ r₁ )  FROT, ;
( Rotates float stack triple backwards. )
: f-rot ( :F: r₁ r₂ r₃ -- r₃ r₁ r₂ )  FNEGROT, ;

( Duplicates pair of floats. )
: f2dup ( :F: r₁ r₂ -- r₁ r₂ r₁ r₂ )  F2DUP, ;

=== Stack Arithmetics ===

( Adds x₂ to x₁. )
: + ( x₁ x₂ -- x₁+x₂ )  PLUS, ;
( Subtracts x₂ from x₁. )
: − ( x₁ x₂ -- x₁−x₂ )  MINUS, ;  alias -
( Subtracts x₁ from x₂. )
: r− ( x₁ x₂ -- x₂−x₁ )  RMINUS, ;  alias r-
( Multiplies n₁ with n₂. )
: × ( n₁ n₂ -- n₁×n₂ )  TIMES, ;  alias *
( Multiplies u₁ with u₂. )
: u× ( u₁ u₂ -- u₁×u₂ )  UTIMES, ;  alias u*
( Divides n₁ through n₂. )
: ÷ ( n₁ n₂ -- n₁÷n₂ )  THROUGH, ;  alias /
( Divides n₂ through n₁. )
: r÷ ( n₁ n₂ -- n₂÷n₁ )  RTHROUGH, ;  alias r/
( Divides u₁ through u₂. )
: u÷ ( u₁ u₂ -- u₁÷u₂ )  UTHROUGH, ;  alias u/
( Divides u₂ through u₁. )
: ur÷ ( u₁ u₂ -- u₂÷u₁ )  URTHROUGH, ;  alias ur/
( Calculates the rest of the integer division n₁ through n₂. )
: % ( n₁ n₂ -- n₁%n₂ )  MOD, ;  alias mod
( Calculates the rest of the integer division n₂ through n₁. )
: r% ( n₁ n₂ -- n₂%n₁ )  RMOD, ;  alias rmod
( Calculates the rest of the integer division u₁ through u₂. )
: u% ( u₁ u₂ -- u₁%u₂ )  UMOD, ;  alias umod
( Calculates the rest of the integer division u₂ through u₁. )
: ur% ( u₁ u₂ -- u₂%u₁ )  URMOD, ;  alias urmod
( Calculates the quotient and rest of the integer division n₁ through n₂. )
: %÷ ( n₁ n₂ -- n₁%n₂ n₁÷n₂ )  MODTHROUGH, ;  alias mod/
( Calculates the quotient and rest of the integer division n₂ through n₁. )
: r%÷ ( n₁ n₂ -- n₂%n₁ n₂÷n₁ )  RMODTHROUGH, ;  alias rmod/
( Calculates the quotient and rest of the integer division u₁ through u₂. )
: u%÷ ( u₁ u₂ -- u₁%u₂ u₁÷u₂ )  UMODTHROUGH, ;  alias umod/
( Calculates the quotient and rest of the integer division u₂ through u₁. )
: ur%÷ ( u₁ u₂ -- u₂%u₁ u₂÷u₁ )  URMODTHROUGH, ;  alias urmod/
( Calculates the rest and quotient of the integer division n₁ through n₂. )
: ÷% ( n₁ n₂ -- n₁÷n₂ n₁%n₂ )  THROUGHMOD, ;  alias /mod
( Calculates the rest and quotient of the integer division n₂ through n₁. )
: r÷% ( n₁ n₂ -- n₂÷n₁ n₂%n₁ )  RTHROUGHMOD, ;  alias r/mod
( Calculates the rest and quotient of the integer division u₁ through u₂. )
: u÷% ( u₁ u₂ -- u₁÷u₂ u₁%u₂ )  UTHROUGHMOD, ;  alias u/mod
( Calculates the rest and quotient of the integer division u₂ through u₁. )
: ur÷% ( u₁ u₂ -- u₂÷u₁ u₂%u₁ )  URTHROUGHMOD, ;  alias ur/mod

( Returns n = n₁+n₂×n₃. )
: *+ ( n₁ n₂ n₃ -- n )  TIMESPLUS, ;
( Returns u = u₁+u₂×u₃. )
: u*+ ( u₁ u₂ u₃ -- u )  UTIMESPLUS, ;

( Increments second of stack. )
: nxt ( x₁ x₂ -- x₁+1 x₂ )  INCS, ;
( Advances cursor of buffer with address a and lenght # by u bytes. )
: +> ( a # u -- a+u #-u )  ADV, ;
( Rounds n1 up to the next multiple of n2. )
: →| ( n1 n2 -- n3 )  tuck 1− + over / * ;  alias >|
( Rounds u1 up to the next multiple of u2. )
: u→| ( u1 u2 -- u3 )  tuck 1− + over u/ u* ;  alias u>|
( Rounds n1 down to the next multiple of n2. )
: |← ( n1 n2 -- n3 )  over r% − ;  alias |<
( Rounds u1 down to the next multiple of u2. )
: u|← ( u1 u2 -- u3 )  over ur% − ;  alias u|<

( Negates n. )
: ± ( n -- −n )  NEG, ;  alias negate
( Returns the absolute value of n. )
: abs ( n -- |n| )  ABS, ;
( Selects the lesser of two signed numbers n1 and n2. )
: min ( n₁ n₂ -- n₁|n₂ )  MIN2, ;
( Selects the greater of two signed numbers n1 and n2. )
: max ( n₁ n₂ -- n₁|n₂ )  MAX2, ;
( Selects the lesser of two unsigned numbers u1 and u2. )
: umin ( u₁ u₂ -- u₁|u₂ )  UMIN2, ;
( Selects the greater of two unsigned numbers u1 and u2. )
: umax ( u₁ u₂ -- u₁|u₂ )  UMAX2, ;
( Selects the least of # signed numbers. )
: nmin ( n₁ ... n# # -- n )  maxcellv INT, SWAP, 0 udo  min  loop ;
( Selects the greatest of # signed numbers. )
: nmax ( n₁ ... n# # -- n )  mincellv INT, SWAP, 0 udo  max  loop ;
( Selects the least of # unsigned numbers. )
: numin ( u₁ ... u# # -- u )  -1 SWAP, 0 udo  umin  loop ;
( Selects the greatest of # unsigned numbers. )
: numax ( u₁ ... u# # -- u )  0 SWAP, 0 udo  umax  loop ;
( Checks if x₁ is at least x₂ and less than x₃. )
: within ( x₁ x₂ x₃ -- ? )  ISWITHIN, ;
( Returns size # in bytes of n.  Note that size of n=0 will be reported as 0, so to get at least 1,
  use "nsize 1 max" )
: nsize ( n -- n # )  NSIZE, ;
( Returns size # in bytes of u. )
: usize ( u -- u # )  USIZE, ;

=== Floating Point Arithmetics ===

( Pushes 0.0 onto the float stack. )
: 0.0 ( :F: -- 0.0 )  0.0, ;
( Pushes 1.0 onto the float stack. )
: 1.0 ( :F: -- 1.0 )  1.0, ;
( Pushes -1.0 onto the float stack. )
: −1.0 ( :F: -- -1.0 )  −1.0, ;  alias -1.0
( Pushes 10.0 onto the float stack. )
: 10.0 ( :F: -- 10.0 )  10.0, ;
( Pushes π onto the float stack. )
: π ( :F: -- π )  PI, ;  alias pi

--- Arithmetic Operations ---

( Adds two floats )
: f+ ( :F: f1 f2 -- f1+f2. )  FADD, ;
( Adds 32-bit integer to float )
: f+i ( i -- :F: f -- f+i. )  FIADD, ;
( Subtracts two floats. )
: f− ( :F: f1 f2 -- f1−f2 )  FSUB, ;  alias f-
( Subtracts 32-bit integer from float. )
: f−i ( i -- :F: f -- f−i )  FISUB, ;  alias f-i
( Subtracts two floats reverse. )
: fr− ( :F: f1 f2 -- f2−f1 )  FSUBR, ;  alias fr-
( Subtracts float from 32-bit integer. )
: i−f ( i -- :F: f -- i−f )  FISUBR, ;  alias i-f
( Multiplies two floats. )
: f* ( :F: f1 f2 -- f1+f2 )  FMPY, ;  alias f×
( Multiplies float by 32-bit integer. )
: f*i ( i -- :F: f -- f*i )  FIMPY, ;  alias f×i
( Divides two floats. )
: f/ ( :F: f1 f2 -- f1/f2 )  FDIV, ;  alias f÷
( Divides float through 32-bit integer. )
: f/i ( i -- :F: f -- f/i )  FIDIV, ;  alias f÷i
( Divides two floats reverse. )
: fr/ ( :F: f1 f2 -- f2/f1 )  FDIVR, ;  alias fr÷
( Divides 32-bit integer through float. )
: i/f ( i -- :F: f -- i/f )  FIDIVR, ;  alias i÷f
( Negates top of the float stack. )
: fneg ( :F: f -- -f )  FNEG, ;
( Calculates the absolute value of the top of the float stack. )
: fabs ( :F: f -- |f| )  FABS, ;
( Returns the lesser of two floating point values. )
: fmin ( :F: f1 f2 -- f3 )  FMIN2, ;
( Returns the greater of two floating point values. )
: fmax ( :F: f1 f2 -- f3 )  FMAX2, ;
( Returns the least of several floating point values. )
: fnmin ( # -- :F: f1 ... f# -- f )  0 udo  fmin  loop ;
( Returns the greatest of several floating point values. )
: fnmax ( :F: f1 f2 -- f3 )  0 udo  fmax  loop ;

--- Comparison and Test ---

( Tests if floating point value is 0.0. )
: f0= ( -- f=0.0 :F: f -- )  FISZERO, ;
( Tests if floating point value is not 0.0. )
: f0− ( -- f≠0.0 :F: f -- )  FISNOTZERO, ;  alias f0-
( Tests if floating point value is negative. )
: f0< ( -- f<0.0 :F: f -- )  FISNEGATIVE, ;
( Tests if floating point value is not negative. )
: f0≥ ( -- f≥0.0 :F: f -- )  FISNOTNEGATIVE, ;  alias f0>=
( Tests if floating point value is positive. )
: f0> ( -- f>0.0 :F: f -- )  FISPOSITIVE, ;
( Tests if floating point value is not positive. )
: f0≤ ( -- f≤0.0 :F: f -- )  FISNOTPOSITIVE, ;  alias f0<=

( Compares two floats for equality. )
: f= ( -- f1=f2 :F: f1 f2 -- )  FISEQUAL, ;
( Compares two floats for inequality. )
: f≠ ( -- f1≠f2 :F: f1 f2 -- )  FISNOTEQUAL, ;  alias f<>
( Compares two floating point values if less. )
: f< ( -- f1<f2 :F: f1 f2 -- )  FISLESS, ;
( Compares two floating point values if not less. )
: f≥ ( -- f1≥f2 :F: f1 f2 -- )  FISNOTLESS, ;
( Compares two floating point values if greater. )
: f> ( -- f1>f2 :F: f1 f2 -- )  FISGREATER, ;
( Compares two floating point values if not greater. )
: f≤ ( -- f1≤f2 :F: f1 f2 -- )  FISNOTGREATER, ;
( Checks if a float value is within the bounds. )
: fwithin ( -- flow≤f<fhigh :F: f flow fhigh -- )  FISWITHIN, ;

=== Logical Stack Operations ===

--- Logops ---

( Conjoins two stack cells x1 and x2 giving x3. )
: and ( x1 x2 -- x3 )  AND, ;
( Bijoins two stack cells x1 and x2 giving x3. )
: or ( x1 x2 -- x3 )  OR, ;
( Disjoins two stack cells x1 and x2 giving x3. )
: xor ( x1 x2 -- x3 )  XOR, ;
( Complements stack cell x1. )
: not ( x1 -- ¬x1 )  NOT, ;
( Conjoins x1 with the complement of x2 giving x3. )
: andn ( x1 x2 -- x3 )  NOT, AND, ;

--- Shift and Rotate ---

( Shifts u logically left by # bits. )
: u<< ( u # -- u' )  SHL, ;  alias u≪
( Shifts u logically right by # bits. )
: u>> ( u # -- u' )  SHR, ;  alias u≫
( Shifts n arithmetically left by # bits. )
: << ( n # -- n' )  SAL, ;  alias ≪
( Shifts n arithmetically right by # bits. )
: >> ( n # -- n' )  SAR, ;  alias ≫

--- Bitops ---

( Tests if bit # is set in x. )
: bit? ( x # -- ? )  BTST, ;
( Sets bit # in x. )
: bit+ ( x # -- )  BSET, ;
( Clears bit # in x. )
: bit− ( x # -- )  BCLR, ;  alias bit-
( Flips bit # in x. )
: bit× ( x # -- )  BCHG, ;  alias bit*
( Tests bit # in x, then sets it.  This operation is not atomic. )
: bit?+ ( x # -- ? )  BTSTSET, ;
( Tests bit # in x, then clears it.  This operation is not atomic. )
: bit?− ( x # -- )  BTSTCLR, ;  alias bit-
( Tests bit # in x, then flips it.  This operation is not atomic. )
: bit?× ( x # -- )  BTSTCHG, ;  alias bit*
( Atomically tests bit # in x and sets it. )
: !bit?+ ( x # -- ? )  ABTSTSET, ;
( Atomically tests bit # in x and clears it. )
: !bit?− ( x # -- )  ABTSTCLR, ;  alias !bit-
( Atomically tests bit # in x and flips it. )
: !bit?× ( x # -- )  ABTSTCHG, ;  alias !bit*

=== Storage Operations ===

( Returns signed byte b at address a. )
: b@ ( a -- b )  BFETCH, ;
( Returns unsigned byte c at address a. )
: c@ ( a -- c )  CFETCH, ;
( Returns signed word s at address a. )
: s@ ( a -- s )  SFETCH, ;
( Returns unsigned word w at address a. )
: w@ ( a -- w )  WFETCH, ;
( Returns signed double-word i at address a. )
: i@ ( a -- i )  IFETCH, ;
( Returns unsigned double-word d at address a. )
: d@ ( a -- d )  DFETCH, ;
( Returns signed quad-word l at address a. )
: l@ ( a -- l )  LFETCH, ;
( Returns unsigned quad-word q at address a. )
: q@ ( a -- q )  QFETCH, ;  alias @
( Returns signed oct-word h at address a. )
: h@ ( a -- h )  HFETCH, ;
( Returns unsigned oct-word o at address a. )
: o@ ( a -- o )  OFETCH, ;

( Exchanges signed byte at address a with c, returning previous value c'. )
: b@! ( b a -- b' )  BXCHG,  DROP, ;
( Exchanges unsigned byte at address a with c, returning previous value c'. )
: c@! ( c a -- c' )  CXCHG,  DROP, ;
( Exchanges signed word at address a with s, returning previous value s'. )
: s@! ( s a -- s' )  SXCHG,  DROP, ;
( Exchanges unsigned word at address a with w, returning previous value w'. )
: w@! ( w a -- w' )  WXCHG,  DROP, ;
( Exchanges signed double-word at address a with i, returning previous value i'. )
: i@! ( i a -- i' )  IXCHG,  DROP, ;
( Exchanges unsigned double-word at address a with d, returning previous value d'. )
: d@! ( d a -- d' )  DXCHG,  DROP, ;
( Exchanges signed quad-word at address a with l, returning previous value l'. )
: l@! ( l a -- l' )  LXCHG,  DROP, ;
( Exchanges unsigned quad-word at address a with q, returning previous value q'. )
: q@! ( q a -- q' )  QXCHG,  DROP, ;  alias @!

( Returns signed byte b at address a and post-increments. )
: b@++ ( a -- a+1 b )  BFETCHINC, ;
( Returns unsigned byte c at address a and post-increments. )
: c@++ ( a -- a+1 c )  CFETCHINC, ;
( Returns signed word s at address a and post-increments. )
: s@++ ( a -- a+2 s )  SFETCHINC, ;
( Returns unsigned word w at address a and post-increments. )
: w@++ ( a -- a+2 w )  WFETCHINC, ;
( Returns signed double-word i at address a and post-increments. )
: i@++ ( a -- a+4 i )  IFETCHINC, ;
( Returns unsigned double-word d at address a and post-increments. )
: d@++ ( a -- a+4 d )  DFETCHINC, ;
( Returns signed quad-word l at address a and post-increments. )
: l@++ ( a -- a+8 l )  LFETCHINC, ;
( Returns unsigned quad-word q at address a and post-increments. )
: q@++ ( a -- a+8 q )  QFETCHINC, ;  alias @++
( Returns signed oct-word h at address a and post-increments. )
: h@++ ( a -- a+16 h )  HFETCHINC, ;
( Returns unsigned oct-word o at address a and post-increments. )
: o@++ ( a -- a+16 o )  OFETCHINC, ;

( Returns signed byte b at address a after pre-decrements. )
: --b@ ( a -- a−1 b )  DECBFETCH, ;
( Returns unsigned byte c at address a after pre-decrements. )
: --c@ ( a -- a−1 c )  DECCFETCH, ;
( Returns signed word s at address a after pre-decrements. )
: --s@ ( a -- a−2 s )  DECSFETCH, ;
( Returns unsigned word w at address a after pre-decrements. )
: --w@ ( a -- a−2 w )  DECWFETCH, ;
( Returns signed double-word i at address a after pre-decrements. )
: --i@ ( a -- a−4 i )  DECIFETCH, ;
( Returns unsigned double-word d at address a after pre-decrements. )
: --d@ ( a -- a−4 d )  DECDFETCH, ;
( Returns signed quad-word l at address a after pre-decrements. )
: --l@ ( a -- a−8 l )  DECLFETCH, ;
( Returns unsigned quad-word q at address a after pre-decrements. )
: --q@ ( a -- a−8 q )  DECQFETCH, ;  alias --@
( Returns signed oct-word h at address a after pre-decrements. )
: --h@ ( a -- a−16 h )  DECHFETCH, ;
( Returns unsigned oct-word o at address a after pre-decrements. )
: --o@ ( a -- a−16 o )  DECOFETCH, ;

( Sets byte at address a to the LSB8 of c. )
: c! ( c a -- )  CSTORE, ;
( Sets word at address a to the LSB16 of w. )
: w! ( w a -- )  WSTORE, ;
( Sets double-word at address a to the LSB32 of d. )
: d! ( d a -- )  DSTORE, ;
( Sets quad-word at adddress a to the LSB64 of q. )
: q! ( q a -- )  QSTORE, ;  alias !
( Sets oct-word at adddress a to the LSB128 of o. )
: o! ( o a -- )  OSTORE, ;
( Stores # bytes of x at address a. )
: #! ( x a # -- )  #STORE, ;

( Sets byte at address a to the LSB8 of c and post-increments. )
: c!++ ( c a -- a+1 )  CSTOREINC, ;
( Sets word at address a to the LSB16 of w and post-increments. )
: w!++ ( w a -- a+2 )  WSTOREINC, ;
( Sets double-word at address a to the LSB32 of d and post-increments. )
: d!++ ( d a -- a+4 )  DSTOREINC, ;
( Sets quad-word at adddress a to the LSB64 of q and post-increments. )
: q!++ ( q a -- a+8 )  QSTOREINC, ;  alias !++
( Sets oct-word at adddress a to the LSB128 of o and post-increments. )
: o!++ ( o a -- a+16 )  OSTOREINC, ;
( Stores # bytes of x at address a and advances a by the number of bytes stored. )
: #!++ ( x a # -- a+# )  #STOREINC, ;

( Sets byte at address a to the LSB8 of c and post-increments. )
: !c++ ( a c -- a+1 )  STORECINC, ;
( Sets word at address a to the LSB16 of w and post-increments. )
: !w++ ( a w -- a+2 )  STOREWINC, ;
( Sets double-word at address a to the LSB32 of d and post-increments. )
: !d++ ( a d -- a+4 )  STOREDINC, ;
( Sets quad-word at adddress a to the LSB64 of q and post-increments. )
: !q++ ( a q -- a+8 )  STOREQINC, ;
( Sets oct-word at adddress a to the LSB128 of o and post-increments. )
: !o++ ( a o -- a+16 )  STOREOINC, ;

( Sets byte at address a to the LSB8 of c and post-decrements. )
: c!−− ( c a -- a+1 )  CSTOREDEC, ;  alias c!--
( Sets word at address a to the LSB16 of w and post-decrements. )
: w!−− ( w a -- a+2 )  WSTOREDEC, ;  alias w!--
( Sets double-word at address a to the LSB32 of d and post-decrements. )
: d!−− ( d a -- a+4 )  DSTOREDEC, ;  alias d!--
( Sets quad-word at adddress a to the LSB64 of q and post-decrements. )
: q!−− ( q a -- a+8 )  QSTOREDEC, ;  alias !−−  alias q!--  alias !--
( Sets oct-word at adddress a to the LSB128 of o and post-decrements. )
: o!−− ( o a -- a+16 )  OSTOREDEC, ;  alias o!--

( Sets byte at address a-1 to the LSB8 of c after pre-decrements. )
: --c! ( c a -- a−1 )  DECCSTORE, ;
( Sets word at address a-2 to the LSB16 of w after pre-decrements. )
: --w! ( w a -- a−2 )  DECWSTORE, ;
( Sets double-word at address a-4 to the LSB32 of d after pre-decrements. )
: --d! ( d a -- a−4 )  DECDSTORE, ;
( Sets quad-word at adddress a-8 to the LSB64 of q after pre-decrements. )
: --q! ( q a -- a−8 )  DECQSTORE, ;  alias --!
( Sets oct-word at adddress a-16 to the LSB128 of o after pre-decrements. )
: --o! ( o a -- a−16 )  DECOSTORE, ;

( Sets byte at address a-1 to the LSB8 of c after pre-decrements. )
: --!c ( a c -- a−1 )  DECSTOREC, ;
( Sets word at address a-2 to the LSB16 of w after pre-decrements. )
: --!w ( a w -- a−2 )  DECSTOREW, ;
( Sets double-word at address a-4 to the LSB32 of d after pre-decrements. )
: --!d ( a d -- a−4 )  DECSTORED, ;
( Sets quad-word at adddress a-8 to the LSB64 of q after pre-decrements. )
: --!q ( a q -- a−8 )  DECSTOREQ, ;
( Sets oct-word at adddress a-16 to the LSB128 of o after pre-decrements. )
: --!o ( a o -- a−16 )  DECSTOREO, ;

( Sets cell at address a to 0. )
: off ( a -- )  0! ;
( Sets cell at address a to -1. )
: on ( a -- )  -1! ;

( Loads float at address a onto the float stack. )
: f@ ( a -- :F: -- r )  FFETCH, ;

( Stores top of float stack to address a. )
: f! ( a -- :F: r -- )  FSTORE, ;

=== Storage Arithmetics ===

( Adds c to byte at address a. )
: c+! ( c a -- )  CADD, ;
( Adds w to word at address a. )
: w+! ( w a -- )  WADD, ;
( Adds d to double-word at address a. )
: d+! ( w a -- )  DADD, ;
( Adds q to quad-word at address a. )
: q+! ( q a -- )  QADD, ;  alias +!
( Subtracts c from byte at address a. )
: c−! ( c a -- )  CSUB, ;  alias c-!
( Subtracts w from word at address a. )
: w−! ( w a -- )  WSUB, ;  alias w-!
( Subtracts d from double-word at address a. )
: d−! ( w a -- )  DSUB, ;  alias d-!
( Subtracts q from quad-word at address a. )
: q−! ( q a -- )  QSUB, ;  alias −!  alias q-!  alias -!

=== Logical Memory Operations ===

--- Bitops ---

/*
 * In the following bit operations, the "memory starting at address a" indicates an open range of
 * memory with origin a.  The bit number # can be quite a large number, and the actual operation
 * takes place on cell (a + # u/ %cell).  Bit (# u% %cell) will be tested or affected by the
 * operation.
 */

( Tests if bit # is set in memory starting at address a. )
: bit@ ( a # -- ? )  BTSTAT, ;
( Sets bit # in memory starting at address a. )
: bit+! ( a # -- )  BSETAT, ;
( Clears bit # in memory starting at address a. )
: bit−! ( a # -- )  BCLRAT, ;  alias bit-! alias bit!− alias bit!-
( Flips bit # in memory starting at address a. )
: bit×! ( a # -- )  BCHGAT, ;  alias bit!× alias bit*! alias bit!*
( Tests bit # in memory starting at address a, then sets it.  This operation is not atomic. )
: bit@+ ( a # -- ? )  BTSTSETAT, ;
( Tests bit # in memory starting at address a, then clears it.  This operation is not atomic. )
: bit@− ( a # -- ? )  BTSTCLRAT, ;  alias bit@-
( Tests bit # in memory starting at address a, then flips it.  This operation is not atomic. )
: bit@× ( a # -- ? )  BTSTCHGAT, ;  alias bit@*
( Atomically tests bit # in memory starting at address a and sets it. )
: !bit@+ ( a # -- ? )  ABTSTSETAT, ;
( Atomically tests bit # in memory starting at address a and clears it. )
: !bit@− ( a # -- ? )  ABTSTCLRAT, ;  alias !bit@-
( Atomically tests bit # in memory starting at address a and flips it. )
: !bit@× ( a # -- ? )  ABTSTCHGAT, ;  alias !bit@*

=== Block Operations ===

( Fills byte buffer of length # at address a with c. )
: cfill ( a # c -- )  CFILL, ;
( Fills word buffer of length # at address a with w. )
: wfill ( a # w -- )  WFILL, ;
( Fills double-word buffer of length # at address a with d. )
: dfill ( a # d -- )  CFILL, ;
( Fills quad-word buffer of length # at address a with q. )
: qfill ( a # q -- )  QFILL, ;
( Fills cell buffer of length # at address a with x. )
: qfill ( a # x -- )  QFILL, ;  alias fill

( Looks up c in byte buffer of length # at address a.  Returns 0 if not found, otherwise the 1-based
  index of the location u of the occurrence. )
: cfind ( a # c -- u )  CFIND, ;
( Looks up w in word buffer of length # at address a.  Returns 0 if not found, otherwise the 1-based
  index of the location u of the occurrence. )
: wfind ( a # w -- u )  WFIND, ;
( Looks up d in double-word buffer of length # at address a.  Returns 0 if not found, otherwise the
  1-based index of the location u of the occurrence. )
: dfind ( a # d -- u )  DFIND, ;
( Looks up d in quad-word buffer of length # at address a.  Returns 0 if not found, otherwise the
  1-based index of the location u of the occurrence. )
: qfind ( a # q -- u )  QFIND, ;  alias find

( Moves # bytes from source address sa to target address ta. )
: cmove ( sa ta # -- )  CMOVE, ;
( Moves # words from source address sa to target address ta. )
: wmove ( sa ta # -- )  WMOVE, ;
( Moves # double-words from source address sa to target address ta. )
: dmove ( sa ta # -- )  DMOVE, ;
( Moves # quad-words from source address sa to target address ta. )
: qmove ( sa ta # -- )  QMOVE, ;  alias move

=== Short String Operations ===

( Returns address a and length # of short string a$. )
: count ( a$ -- a # )  COUNT, ;
( Returns address a and length # of zero terminated string aº.  Note that # may theoretically be -1
  if no zero was found inside the string; practically, a segmentation fault will occur first in this
  case. )
: 0count ( aº -- a # )  dup -1 0 cfind 1- ;
( Appends unsigned byte c to counted string in buffer at a$. )
: c>$ ( c a$ -- )  CAPPEND$, ;
( Appends b$ to a$. )
: $+$ ( a$ b$ -- a$ )  APPEND$, ;
( Reads the next unicode character uc from UTF8-buffer at address a and increments cursor a. )
: c$@++ ( a -- a' uc )  FETCHUC$INC, ;
( Reads the next unicode character uc from UTF8-buffer at address a and adjusts cursor a and
  remaining length #. )
: c$>++ ( a # -- a' #' uc )  NEXTUC$ADV, ;
( Stores unicode character uc at UTF8-buffer address a and increments cursor a. )
: c$!++ ( uc a -- a' )  swap TOUTF8, usize slide #!++ ;
( Compares short strings a$ and b$. )
: $= ( a$ b$ -- ? )  STRCOMP, ;
( Converts character buffer a with length # to counted short string in buffer of minimum size 256
  at a$.  If # is not in the range [0;255], it is trimmed. )
: a#>$ ( a # a$ -- a$ )  >r 0 max 255 umin  dup r@ c!  r@ 1+ swap cmove  r> ;
( Converts zero-terminated string at aº to counted short string in buffer of minimum size 256
  at a$.  If aº is longer than 255 chars, only the first 255 will be copied. )
: z>$ ( aº a$ -- a$ )  over -1 0 cfind 1- swap a#>$ ;

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

=== Code Invocation ===

( Executes code at address a. )
: execute ( a -- )  EXECUTE, ;
( Executes code of word at address @w. )
: execWord ( @w -- )  EXECUTEWORD, ;

=== Module Initialization ===

( Initializes the vocabulary from initialization structure at address @initstr when loading. )
private init : init ( @initstr -- @initstr )  dup @PSP + @ 8− SP0!  dup @RSP + @ 32+ RP0! ;

vocabulary;
export Forth
