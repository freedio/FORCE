$ED constant ED
$EB constant EB
: 2exit  r> drop exit ;
: #drop ( ... n -- )  0 +do  drop  loop ;
: smash ( x1 x2 -- x1 x1 )  drop dup ;
: rev ( x1 x2 x3 -- x3 x2 x1 )  swap rot ;
: slide ( x1 x2 x3 -- x2 x1 x3 ) rot swap ;
: − ( n1 n2 -- n1−n2 ) - ;
: ≤ ( n1 n2 -- ? ) <= ;
: ≠ ( n1 n2 -- ? ) <> ;
: << ( x1 n -- x2 )  lshift ;
: >> ( z1 n -- x2 )  rshift ;
: u>> ( z1 n -- x2 )  rshift ;
: 0- ( n -- ? )  0= 0= ;
: u+ ( u1 u2 -- u3 ) + ;
: u- ( u1 u2 -- u3 ) - ;
: u* ( u1 u2 -- u3 ) * ;
: u/ ( u1 u2 -- u3 ) / ;
: umod ( u1 u2 -- u1%u2 ) mod ;
: ± ( n -- -n )  negate ;
: !and ( u1 u2 -- u3 )  over and 2dup ≠ if  cr ." Warning: Range exceeded!"  then  nip ;
: nand ( n1 n2 -- n1&¬n2 )  invert and ;
: nand! ( n a -- )  dup @ rot nand swap ! ;
: or!  ( n a -- )  dup @ rot or swap ! ;
: xor!  ( n a -- )  dup @ rot xor swap ! ;
: cor! ( c a -- )  dup c@ rot or swap c! ;
: bit? ( x n -- ? )  1 swap << and 0- ;
: bit- ( x n -- x' )  1 swap << invert and ;
: bit+ ( x n -- x' )  1 swap << or ;
: bit+- ( x n -- x' )  1 swap << xor ;
: bit?- ( x n -- x' ? )  over swap bit- tuck = ;
: 2+ ( n -- n+2 )  2 + ;
: 2- ( n -- n−2 )  2 - ;
: 4+ ( n -- n-4 )  4 + ;
: 4- ( n -- n-4 )  4 - ;
: 8+ ( n -- n+8 )  8 + ;
: 8- ( n -- n-8 )  8 - ;
: 4* ( n -- n*4 )  2 << ;
: 8* ( n -- n*8 )  3 << ;
: 4/ ( n -- n/8 )  2 >> ;
: 8/ ( n -- n/8 )  3 >> ;
: r- ( n1 n2 -- n2-n1 )  swap - ;
: r! ( a x -- )  swap ! ;
: cell- ( a -- a-cell )  cell - ;
: -cell ( -- -cell )  cell negate ;
: unless  postpone 0=  postpone if ; immediate
: unlessever postpone 0= postpone if ; immediate
: ifever postpone if ; immediate
: c@++ ( a -- c a+1 )  dup c@ swap 1+ ;
: @c++ ( a -- a+1 c )  c@++ swap ;
: --@c ( a -- a-1 c )  1- dup c@ ;
: c@++< ( n a -- n' a+1 )  swap 8 << over c@ + swap 1+ ;
: c@< ( c1 a -- c2 )  c@ swap 8 << + ;
: c!++ ( c a -- a+1 )  tuck c! 1+ ;
: w!++ ( w a -- a+2 )  tuck w! 2+ ;
: !c++ ( a c -- a+1 )  over c! 1+ ;
: !++ ( x a -- a+cell )  tuck ! cell+ ;
: d@ ( a -- d )  ul@ ;
: d! ( d a -- )  l! ;
: d@++ ( a -- d a+1 )  dup d@ swap 4+ ;
: @d++ ( a -- a+1 d )  d@++ swap ;
: !d++ ( a c -- a+1 )  over d! 4+ ;
: i@ ( a -- i )  sl@ ;
: s@ ( a -- s )  sw@ ;
: @++ ( a -- a+cell a@ )  dup cell+ swap @ ;
: @-- ( a -- a-cell a-cell@ )  cell- dup @ ;
: --@ ( a -- a-cell@ a-cell )  @-- swap ;
: --c! ( c a -- a-1 )  1- tuck c! ;
: c!++> ( n a -- n' a+1 )  2dup c!  swap 8 >> swap 1+ ;
: ++c!> ( a x -- a+1 x' )  2dup swap c!  8 u>> swap 1+ swap ;
: 0! ( a -- )  0 swap ! ;
: -! ( n a -- )  tuck @ swap - swap ! ;
: @! ( n1 a -- n2 )  dup @ -rot ! ;
: #! ( x a # -- )  case
  1 of  c!  endof
  2 of  w!  endof
  4 of  d!  endof
  8 of  !  endof
  cr ." Invalid size: " . abort  endcase ;
: c1+! ( a -- )  dup c@ 1+ swap c! ;
: c+! ( c a -- )  dup c@ rot + swap c! ;
: c-! ( c a -- )  dup c@ rot - swap c! ;
: 1+! ( a -- )  dup @ 1+ swap ! ;
: 1-! ( a -- )  dup @ 1- swap ! ;
: b>n ( b -- n )  dup 128 256 within if  -1 $ff xor +  then ;
: n.size ( n -- # )  dup if
  dup -128 128 within if  drop 1  else
  dup -32768 32768 within if  drop 2  else
  dup -2147483648 2147483648 within if  drop 3  else  drop 4  then then then then ;
: u.size ( u -- # )  dup if
  dup 0 256 within if  drop 1  else
  dup 0 65536 within if  drop 2  else
  dup 0 4294967296 within if  drop 3  else  drop 4  then then then then ;
: advance ( a # -- a+1 #-1 )  1- swap 1+ swap ;
: advance# ( a # u -- a+u #-u )  tuck - -rot + swap ;
: nextchar ( a # -- a+1 #-1 c )  1- swap dup 1+ -rot c@ ;
: regress ( a # -- a-1 #+1 )  1+ swap 1- swap ;
: =variable ( x -- )  create , ;
: bytevar  create 0 c, ;
: type$ ( $ -- )  count type ;
: qtype$ ( $ -- )  '"' emit  count type  '"' emit ;
: qtype ( a # -- )  '"' emit  type  '"' emit ;
: hexb. ( c -- )  dup 4 u>> dup 9 > 7 and + '0' + emit $F and dup 9 > 7 and + '0' + emit ;
: addr. ( a -- )  60 begin dup 4+ while  2dup >> $F and dup 9 > 7 and + '0' + emit  4 - repeat  2drop ;
: append ( a1 a2 # -- a2' )  2dup + >r cmove r> ;

: hexdump ( a # -- a # )  2dup  cr  over addr. ." : " 0 ?do dup c@ hexb. space 1+ loop  drop ;

: hexline ( a # -- )
  CR OVER 0 <# # # # # # # # # # # # # #> type space
  2DUP 16 0 DO
    I 8 = IF  45 EMIT  ELSE  SPACE  THEN
    DUP 0> IF  OVER C@ 0 <# # # #> type  ELSE  2 spaces  THEN
    1- SWAP 1+ SWAP LOOP
  2DROP 10 spaces
  16 0 DO
\   I 8 = IF  space  THEN
    DUP 0> IF
      OVER C@ DUP bl < OVER $7F > OR IF  DROP '.'  ELSE DUP bl = IF  DROP 2422  THEN  THEN
      XEMIT  ELSE  space  THEN
    1- SWAP 1+ SWAP LOOP
  2DROP ;

: hexdumpf ( a # -- )
  BEGIN
    DUP 0> WHILE
    2DUP ['] hexline #16 base-execute
    16 - SWAP 16 + SWAP
    REPEAT
  2DROP ;



: $$#= ( a1 a2 # -- ? )
  0 ?do 2dup c@ swap c@ = unless  2drop unloop false exit then 1+ swap 1+ loop  2drop true ;

: $$= ( $1 $2 -- ? )
    \ Compare counted strings a1 and a2 for equality.
    COUNT ROT COUNT ( a1 #1 a2 #2 )
    ROT OVER - IF  2DROP DROP FALSE EXIT  THEN
    0 ?DO 2DUP C@ SWAP C@ - IF  UNLOOP 2DROP FALSE EXIT  THEN
        1+ SWAP 1+ LOOP
    2DROP TRUE ;

: commentbracket ( a -- )
    \ Skip words until word a is encountered.
    BEGIN
        DUP BL WORD DUP C@ 0= IF
            ABORT" Isolated comment bracket!" THEN
        $$= UNTIL
    DROP ;

: textbracket ( a -- )
  BEGIN
    DUP BL WORD DUP C@ 0= IF
      2DROP REFILL UNLESS  ABORT" Isolated text bracket!" THEN  FALSE
      ELSE $$= THEN UNTIL
    DROP ;

: === ( -- )  c" ===" commentbracket ;
: --- ( -- )  c" ---" commentbracket ;
: :(  ( "comment" rpar -- )  c" )" textbracket ;

: udo postpone u+do ; immediate

( Number of bits in quantity |  Shift count for byte quantity | Shift count for bit quantity )
  8 constant byte#              0 constant byte%                3 constant byte^
 16 constant word#              1 constant word%                4 constant word^
 32 constant dword#             2 constant dword%               5 constant dword^
 64 constant qword#             3 constant qword%               6 constant qword^
 80 constant tbyte#
128 constant oword#             4 constant oword%               7 constant oword^
256 constant hword#             5 constant hword%               8 constant hword^

( Number of bits in the specified binary quantity )
: bytes# ( u1 -- u2 )   byte^ << ;
: words# ( u1 -- u2 )   word^ << ;
: dwords# ( u1 -- u2 )  dword^ << ;
: qwords# ( u1 -- u2 )  qword^ << ;
: tbytes# ( u1 -- u2 )  tbyte# * ;
: owords# ( u1 -- u2 )  oword^ << ;
: hwords# ( u1 -- u2 )  hword^ << ;

( Number of bytes in quantity | Mask for unsigned quantity |  Mask for signed quantity )
1 constant #byte          $FF constant %ubyte                 $7F constant %byte
2 constant #word          $FFFF constant %uword               $7FFF constant %word
4 constant #dword         $FFFFFFFF constant %udword          $7FFFFFFF constant %dword
8 constant #qword         $FFFFFFFFFFFFFFFF constant %uqword  $7FFFFFFFFFFFFFFF constant %qword
10 constant #tbyte
16 constant #oword
32 constant #hword

( Number of bytes in specified binary quantity )
: #bytes ( u1 -- u1 )  byte% << ;
: #words ( u1 -- u2 )  word% << ;
: #dwords ( u1 -- u2 )  dword% << ;
: #qwords ( u1 -- u2 )  qword% << ;
: #tbytes ( u1 -- u2 )  10 * ;
: #owords ( u1 -- u2 )  oword% << ;
: #hwords ( u1 -- u2 )  hword% << ;

: alias  latest name>int alias ; immediate
: stackcheck  depth if  .s  depth 0 do  drop  loop  then ;
: 0allot ( u -- )  here over allot swap 0 fill ;
: w,  here w! 2 allot ;
: d,  here d! 4 allot ;
: >mask ( n -- %n )
  -128 128 within if  $FF  else  -65536 65536 within if $FFFF else $FFFFFFFF  then  then ;
: sp/ ( ... -- )  depth 0 ?do drop loop ;
: .sh  base @ >r hex .s r> base ! ;

create ASTACK 1024 allot
create ASP  ASTACK ,
: A?  ASP @ ASTACK - cell / ;
: >A  ( cr ." ---- " dup hex. ." >A[" A? 0 <# #s #> type ']' emit )   ASP @ !  8 ASP +! ;
: A>  8 ASP -!  ASP @ @  ( cr ." ---- A[" A? 0 <# #s #> type ." ]> " dup hex. ) ;
: A@  ASP @ 8- @ ;

create BSTACK 1024 allot
create BSP  BSTACK ,
: >B  BSP @ !  8 BSP +! ;
: B>  8 BSP -!  BSP @ @ ;
: B@  BSP @ 8- @ ;
: B2@  BSP @ 16 - @ ;
: BDEPTH  BSP @ BSTACK - cell / ;

create XSTACK 1024 allot
create XSP  XSTACK ,
: >X  XSP @ !  8 XSP +! ;
: X>  8 XSP -!  XSP @ @ ;
: X@  XSP @ 8- @ ;
: XDEPTH  XSP @ XSTACK - cell / ;

: there  here ;
: toff 0 ;
: tc,  c, ;
: tw,  w, ;
: td,  d, ;
: t,  , ;
: dataReloc,  cr ." ---- dataReloc: wrong!" .sh 4 #drop ;
: codeReloc,  cr ." ---- codeReloc: wrong!" .sh 3 #drop ;
: assertCodeSpace ( u -- ) drop ;

: cfill ( a # c -- )  fill ;
: append$ ( a1$ a2$ -- a1$ )  count dup >r 2 pick count + swap cmove r> over c+! ;
