vocabulary ForcemblerTools
also ForcemblerTools definitions

=== Compiler variables ===

variable ADP  : adepth depth ADP @ - ;
variable THENA
variable reloc-voc
variable reloc-sym

=== Saved operations ===

( Originals will be overridden with assembly language opcodes )

: [and] and ;
: [or] or ;
: [xor] xor ;
: [not] invert ;
: call abort" We should not call this!" ;

=== Error Handling ===

--- Error Messages ---

CREATE MISSING_ADDRESS_DISPLACEMENT$ ," Missing address displacement!?"
CREATE ARCHITECTURE_MISMATCH$ ," Architecture mismatch!"
CREATE ADDRESS_NOT_COMBINABLE$ ," Addresses not combinable!"
CREATE INVALID_ADDRESS_INDEX$ ," Invalid address index!"
CREATE OPERAND_SIZE_MISMATCH$ ," Operand size mismatch!"
CREATE OPERAND_SIZE_UNKNOWN$ ," Unknown operand size (use <SIZE> PTR to specify)!"
CREATE REGISTER_64_EXPECTED$ ," 64-bit register operand required!"
CREATE REGISTER_32+_EXPECTED$ ," 32-bit or higher register operand required!"
CREATE REGISTER_32_EXPECTED$ ," 32-bit register operand required!"
CREATE REGISTER_16+_EXPECTED$ ," 16-bit or higher register operand required!"
CREATE REGISTER_16_EXPECTED$ ," 16-bit register operand required!"
CREATE ADDRESS_128_OPERAND_EXPECTED$ ," 128-bit memory operand expected!"
CREATE ADDRESS_80_OPERAND_EXPECTED$ ," 80-bit address operand expected!"
CREATE ADDRESS_64_OPERAND_EXPECTED$ ," 64-bit address operand expected!"
CREATE ADDRESS_32+_EXPECTED$ ," 32-bit or higher address operand required!"
CREATE ADDRESS_32_OPERAND_EXPECTED$ ," 32-bit address operand expected!"
CREATE ADDRESS_16+_OPERAND_EXPECTED$ ," 16-bit or higher address operand required!"
CREATE ADDRESS_16_OPERAND_EXPECTED$ ," 16-bit address operand required!"
CREATE R/M_64_EXPECTED$ ," 64-bit address or register operand required!"
CREATE R/M_32+_EXPECTED$ ," 32-bit or higher address or register operand required!"
CREATE R/M_32_EXPECTED$ ," 32-bit address or register operand required!"
CREATE R32/M16_EXPECTED$ ," 32-bit register or 16-bit address operand expected!"
CREATE R/M_16+_EXPECTED$ ," 16-bit or higher address or register operand required!"
CREATE R/M_16_EXPECTED$ ," 16-bit address or register operand required!"
CREATE R/M_8_EXPECTED$ ," 8-bit address or register operand required!"
CREATE INVALID_TARGET_ARCHITECTURE$ ," Invalid target architecture!"
CREATE I32_NOT_SUPPORTED$ ," Intel 32-bit target architecture not supported!"
CREATE I64_NOT_SUPPORTED$ ," Intel 64-bit target architecture not supported!"
CREATE X87_NOT_SUPPORTED$ ," X87-coprocessor not supported!"
CREATE MMX_NOT_SUPPORTED$ ," Multimedia Extensions not supported!"
CREATE XMM_NOT_SUPPORTED$ ," XMM not supported!"
CREATE INVALID_IMMEDIATE_SIZE$ ," Invalid size of immediate operand!"
CREATE INVALID_FLOAT_COND$ ," Invalid floating point condition!"
CREATE LEGACY_OPCODE$ ," Legacy opcode in i64 mode!"
CREATE INVALID_SIZE_IN_BITS$ ," Invalid size in bits!"
CREATE INVALID_SIZE$ ," Invalid size!"
CREATE INVALID_WIDTH$ ," Invalid width!"
CREATE INVALID_ARCHITECTURE_DEFINITION$ ," Invalid architecture in operand definition!"
CREATE IMMEDIATE_TOO_BIG$ ," Immediate operand too big!"
CREATE INVALID_OPERAND_COMBINATION$ ," Invalid operand combination!"
CREATE XMM_REGISTER_EXPECTED$ ," XMM register operand expected!"
CREATE XMM_REGMEM128_EXPECTED$ ," XMM register or 128-bit address operand required!"
CREATE XMM_REGMEM64_EXPECTED$ ," XMM register or 64-bit address operand required!"
CREATE XMM_REGMEM32_EXPECTED$ ," XMM register or 32-bit address operand required!"
CREATE XMM_REGMEM16_EXPECTED$ ," XMM register or 16-bit address operand required!"
CREATE MMX_REGISTER_EXPECTED$ ," MMX register operand expected!"
CREATE MMX_REGMEM64_EXPECTED$ ," MMX register or 64-bit address operand required!"
CREATE INVALID_OPERAND_TYPE$ ," Invalid operand type!"
CREATE HIBYTE_NOT_AVAILABLE_WITH_REX$ ," AH, BH, CH, DH cannot be used with REX!"
CREATE WORD_SIZE_OPERAND_EXPECTED$ ," 16-bit operand expected!"
CREATE [D]WORD_SIZE_OPERAND_EXPECTED$ ," 16- or 32-bit operand expected!"
CREATE DQWORD_SIZE_OPERAND_EXPECTED$ ," 32- or 64-bit operand expected!"
CREATE REGISTER_OPERAND_EXPECTED$ ," Register expected!"
CREATE ADDRESS_OPERAND_EXPECTED$ ," Address operand expected!"
CREATE CONDITION_OPERAND_EXPECTED$ ," Condition expected!"
CREATE REGISTER_OR_ADDRESS_OPERAND_EXPECTED$ ," Register or address operand expected!"
CREATE BYTE_SIZE_OPERAND_INVALID$ ," 8-bit operand invalid!"
CREATE STANDARD_REGISTER_EXPECTED$ ," Standard register operand expected!"
CREATE FPU_REGISTER_EXPECTED$ ," FPU register operand expected!"
CREATE STANDARD_R/M_EXPECTED$ ," Standard register or address operand expected!"
CREATE IMMEDIATE_OPERAND_EXPECTED$ ," Immediate operand expected!"
CREATE IMMEDIATE8_OPERAND_EXPECTED$ ," 8-bit immediate operand expected!"
CREATE IMMEDIATE16_OPERAND_EXPECTED$ ," 16-bit immediate operand expected!"
CREATE NESTLEVEL_OPERAND_EXPECTED$ ," nesting level operand 0..31 expected!"
CREATE TARGET_ADDRESS_OUT_OF_RANGE$ ," Target address out of range!"
CREATE INVALID_OPERAND_SIZE$ ," Invalid operand size!"
CREATE OPERATION_NOT_SUPPORTED<486$ ," Operation not supported before i486!"
CREATE OPERATION_NOT_SUPPORTED<586$ ," Operation not supported before Pentium!"
CREATE RIP_64_ONLY$ ," RIP-relative addressing is available only in 64-bit mode!"
CREATE MISSING_NESTING_LEVEL$ ," Missing nesting level!"
CREATE ACCU_OPERAND_REQUIRED$ ," Accu operand required!"
CREATE EQ_OR_NEQ_REQUIRED$ ," Condition 0=, 0≠, = or ≠ required!"
CREATE INVALID_NOP_SIZE$ ," Immediate constant between 1 and 10 required!"
CREATE NOP#_NOT_SUPPORTED$ ," Multibyte NOP not supported in 16-bit mode!"
CREATE CANNOT_POP_CS$ ," Cannot pop CS!"
CREATE CANNOT_POP_CONSTANT$ ," Cannot pop constant!"
CREATE BASE_EBP_REQUIRED$ ," With a displacement ≠ 0, EBP/RBP/R13 must be base of an indexed address!"
CREATE MISPLACED_OTHERWISE$ ," Misplaced OTHERWISE!"
CREATE CONDLOOP_RANGE$ ," Conditional loop exceeds range!"

( Temporary )
CREATE FAR_CALL_UNSUPPORTED$ ," Far calls not supported by FORCEMBLER!"

--- Error Variables ---

variable ERRMSG
variable ERRLINE
variable ERROR-HANDLER
variable ERRMODE    0 constant #PRODUCTION  1 constant #TEST

--- Error Methods ---

: error>> ( -- )  errmsg @ ?dup if  cr ." Line " errline @ dec. ." : " count type  then  errmsg 0! ;
: .error ( $ -- ) cr ." Line " sourceline# dec. ." : " count type ;
: error! ( $ -- )  errmsg @ if  drop  else  errmsg !  sourceline# errline !  then ;
: error ( $ -- )  error-handler @ execute ;
' .error error-handler !
: ?error>> ( -- )  ERRMODE @ #TEST - if  error>>  then ;
: test-mode ( -- )  ['] error! error-handler !  #TEST ERRMODE ! ;
: prod-mode ( -- )  ['] .error error-handler !  #PRODUCTION ERRMODE ! ;
: e? ( -- )  errmsg @ ?dup if  cr ." Line " errline @ dec. ." : " count type else cr ." No error"  then ;

: .line  cr ." Line " sourceline# dec. ;
: .s.  ( c -- )  .line emit ." : " .s ;
: .sh.  ( c -- )  .line emit ." : " .sh ;

=== Sizes and Architecture ===

--- Size ---

$F0 constant %ADDRSIZE
$0F constant %OPSIZE

01 constant #BYTE
02 constant #WORD
03 constant #DWORD
04 constant #QWORD
05 constant #TBYTE
06 constant #OWORD

previous definitions
vocabulary Forcembler
also ForcemblerTools
also Forcembler definitions

01 constant BYTE
02 constant WORD
04 constant DWORD
08 constant QWORD
10 constant TBYTE
16 constant OWORD

previous definitions  ( cr ." Order @1: " order )
also Forcembler

: bit  8/ ;
: bits>size ( n -- # )  bit case
   BYTE of  #BYTE endof
   WORD of  #WORD endof
  DWORD of #DWORD endof
  QWORD of #QWORD endof
  TBYTE of #TBYTE endof
  OWORD of #OWORD endof
  INVALID_SIZE_IN_BITS$ error  endcase ;
: bits>shift ( n -- # )  bit case
   WORD of  1 endof
  DWORD of 2 endof
  QWORD of 3 endof
  OWORD of 4 endof
  INVALID_SIZE_IN_BITS$ error  endcase ;
: width>size ( n -- # )  case
   BYTE of  #BYTE endof
   WORD of  #WORD endof
  DWORD of #DWORD endof
  QWORD of #QWORD endof
  TBYTE of #TBYTE endof
  OWORD of #OWORD endof
  INVALID_SIZE$ error  endcase ;
: size>width ( # -- n ) case
   #BYTE of  BYTE  endof
   #WORD of  WORD  endof
  #DWORD of DWORD  endof
  #QWORD of QWORD  endof
  #TBYTE of TBYTE  endof
  #OWORD of OWORD  endof
  INVALID_WIDTH$ error  0 endcase ;
: !size ( # -- # )  dup unless  OPERAND_SIZE_UNKNOWN$ error  then ;

--- Architecture ---

 #WORD constant i16
#DWORD constant i32
#QWORD constant i64
#TBYTE constant x87
12 constant mmx
13 constant uni
14 constant ext
#OWORD constant xmm

--- Target Architecture ---

%00000001 constant %X87
%00000010 constant %MMX
%00000100 constant %XMM

Forcembler definitions
( cr ." Order @0: " order )

_ADDRSIZE bits>size constant T.ADDRSIZE
_OPSIZE bits>size constant T.OPSIZE
_ARCH bits>size constant T.ARCH
_X87 1 and %X87 u*  _MMX 1 and %MMX u* +  _XMM 1 and %XMM u* + constant T.COPROC
T.ADDRSIZE #DWORD min constant T.ADDRWIDTH
_ADDRSIZE bits>shift constant T.ADDRSHIFT

previous definitions
( cr ." Order @1: " order )
also Forcembler

=== Condition Code Values ===

$00 constant COV                      \ overflow
$01 constant CNO                      \ not overflow
$02 constant CCY                      \ carry
CCY constant CBL                      \ below
$03 constant CAE                      \ above or equal
CAE constant CNC                      \ not carry
CAE constant CNB                      \ not below
$04 constant CEQ                      \ equal
CEQ constant CZR                      \ zero
$05 constant CNE                      \ not equal
CNE constant CNZ                      \ not zero
$06 constant CBE                      \ below or equal
$07 constant CAB                      \ above
$08 constant CNG                      \ negative
$09 constant CPS                      \ positive
$0A constant CPY                      \ parity
CPY constant CPE                      \ parity even
CPY constant CUO                      \ unordered
$0B constant CNP                      \ no parity
CNP constant CPO                      \ parity odd
CNP constant COD                      \ ordered
CNP constant CNU                      \ not unordered
$0C constant CLT                      \ less
$0D constant CGE                      \ greater or equal
$0E constant CLE                      \ less or equal
$0F constant CGT                      \ greater

: cond>fcond ( cond -- fcond )  case
  CBL of  0  endof
  CEQ of  1  endof
  CBE of  2  endof
  CUO of  3  endof
  CNB of  4  endof
  CNE of  5  endof
  CAB of  6  endof
  COD of  7  endof
  INVALID_FLOAT_COND$ error  0  endcase ;

=== Operand Structure ===

( type arch+size mode code )
$000000FF constant %FIELD   $F constant %SUBFIELD
$000000FF constant %CODE    00 constant ^CODE
$0000FF00 constant %MODE    08 constant ^MODE
$000F0000 constant %SIZE    16 constant ^SIZE           %SIZE invert constant %~SIZE
$00F00000 constant %ARCH    20 constant ^ARCH
$FF000000 constant %TYPE    24 constant ^TYPE

--- Operand Types ---
00 constant #UNKNOWN
01 constant #REGISTER
02 constant #ADDRESS
03 constant #IMMEDIATE
04 constant #CONDITION
05 constant #FCONDITION

--- Register Modes ---
00 constant #REGULAR
01 constant #HI-BYTE
02 constant #SEGMENT
03 constant #CONTROL
04 constant #DEBUG
05 constant #FLOATING
06 constant #MMX
07 constant #XMM
07 constant %REG_MODE
%11111110 constant %~STANDARD

--- Address Modes ---
00 constant #DIRECT
01 constant #LINEAR
02 constant #INDEXED
03 constant #SCALED1
04 constant #SCALED2
05 constant #SCALED4
06 constant #SCALED8
07 constant %ADDR_MODE
$FFFF00FF constant %~MODE
%~MODE %ADDR_MODE ^MODE 4+ << + constant %~AMODE
%00001000 constant %BASEADDR
%00010000 constant %MOD01
%00100000 constant %MOD00

--- Condition Modes ---

( 00 constant #REGULAR )
01 constant #FLOATCND

--- Accessors ---

: .type ( op -- type )  ^TYPE u>> %FIELD and ;
: .size ( op -- opsize ) ^SIZE u>> %SUBFIELD and ;
: .!size ( op -- opsize )  .size !size ;
: .arch ( addr -- addr.size ) ^ARCH u>> %SUBFIELD and ;
: .mode ( op -- mode )  ^MODE u>> %FIELD and ;
: .regmode ( reg -- reg.mode ) .mode %REG_MODE and ;
: .addrmode ( addr -- addr.mode ) .mode %ADDR_MODE and ;
: .base ( addr -- addr.base )  %FIELD and ;
: .index ( addr -- addr.index )  4 u>> %FIELD and ;
: .code ( op -- code )  %CODE and ;
: .code! ( op code -- op' )  swap %CODE nand or ;
: .amode! ( addr mode -- addr' )  %ADDR_MODE and ^MODE << swap %~AMODE and or ;
: .size! ( op size -- op' )  %SUBFIELD and ^SIZE << swap %~SIZE and or ;
: register? ( op -- ? )  .type #REGISTER = ;
: stdreg? ( op -- ? )  dup register? over .regmode %~STANDARD and 0= and swap .size #OWORD < and ;
: fpureg? ( op -- ? )  dup register? swap .regmode #FLOATING = and ;
: segreg? ( op -- ? )  dup register? swap .regmode #SEGMENT = and ;
: ctrlreg? ( op -- ? )  dup register? swap .regmode #CONTROL = and ;
: dbugreg? ( op -- ? )  dup register? swap .regmode #DEBUG = and ;
: mmxreg? ( op -- ? )  dup register? swap .regmode #MMX = and ;
: xmmreg? ( op -- ? )  dup register? swap .regmode #XMM = and ;
: address? ( op -- ? )  .type #ADDRESS = ;
: immediate? ( op -- ? )  .type #IMMEDIATE = ;
: condition? ( op -- ? )  .type #CONDITION = ;
: indexed? ( addr -- ? )  .addrmode #INDEXED >= ;
: sibified? ( addr -- ? )  .addrmode #SCALED1 >= ;
: base? ( addr -- ? )  %BASEADDR and 0- ;
: r/m? ( op -- ? )  dup address? swap register? or ;
: 2register? ( op1 op2 -- ? )  register? swap register? and ;
: addr>reg? ( op1 op2 -- ? )  register? swap address? and ;
: reg>addr? ( op1 op2 -- ? )  address? swap register? and ;
: imm>r/m? ( op1 op2 -- ? )  r/m? swap immediate? and ;
: reg>r/m? ( op1 op2 -- ? )  r/m? swap register? and ;
: mem>reg? ( op1 op2 -- ? )  register? swap address? and ;
: accu? ( op -- ? )  dup stdreg? swap .code 0= and ;
: !accu ( op -- op )  dup accu? unless  ACCU_OPERAND_REQUIRED$ error  then ;
: .size-no-imm ( op -- opsize )  dup immediate? if  drop 0  else  .size  then ;

=== Operand Parameters ===

variable control ( Various flags )
: control? ( n -- ? )  1 swap << control @ and 0- ;
: control?- ( n -- ? )  1 swap << dup control @ and 0- swap control nand! ;
: control+ ( n -- )  1 swap << control or! ;
: control- ( n -- ? )  1 swap << control nand! ;
: control/ ( -- )  0 control ! ;
: REX? ( -- ? )         00 control? ;
: REX+ ( -- )           00 control+ ;
: REX- ( -- )           00 control- ;
: REX.R? ( -- ? )       01 control? ;
: REX.R+ ( -- )         01 control+ ;
: REX.R?- ( -- ? )      01 control?- ;
: REX.B? ( -- ? )       02 control? ;
: REX.B+ ( -- )         02 control+ ;
: REX.X? ( -- ? )       03 control? ;
: REX.X+ ( -- )         03 control+ ;
: REX.W? ( -- ? )       04 control? ;
: REX.W+ ( -- )         04 control+ ;
: REX.W- ( -- )         04 control- ;
: imm? ( -- ? )         05 control? ;
: imm+ ( -- )           05 control+ ;
: imm- ( -- )           05 control- ;
: modregr/m? ( -- )     06 control? ;
: modregr/m+ ( -- )     06 control+ ;
: sib? ( -- ? )         07 control? ;
: sib+ ( -- )           07 control+ ;
: opsize? ( -- ? )      08 control? ;
: opsize+ ( -- )        08 control+ ;
: addrsize? ( -- ? )    09 control? ;
: addrsize+ ( -- )      09 control+ ;
: prefix? ( -- )        10 control? ;
: prefix+ ( -- )        10 control+ ;
: esc? ( -- ? )         11 control? ;
: esc+ ( -- )           11 control+ ;
: hibyte? ( -- ? )      12 control? ;
: hibyte+ ( -- )        12 control+ ;
: addr? ( -- ? )        13 control? ;
: addr+ ( -- )          13 control+ ;
: fpuop? ( -- ? )       14 control? ;
: fpuop+ ( -- )         14 control+ ;
: fpuop- ( -- )         14 control- ;
: mmxop? ( -- ? )       15 control? ;
: mmxop+ ( -- )         15 control+ ;
: mmxop- ( -- )         15 control- ;
: far? ( -- ? )         16 control? ;
: far+ ( -- )           16 control+ ;
: near? ( -- ? )        17 control? ;
: near+ ( -- )          17 control+ ;
: simblock? ( -- ? )    18 control? ;
: simblock+ ( -- )      18 control+ ;
: wide? ( -- ? )        19 control? ;
: wide+ ( -- )          19 control+ ;
: nobase? ( -- ? )      20 control? ;
: nobase+ ( -- )        20 control+ ;
: reloc? ( -- ? )       21 control? ;
: reloc+ ( -- )         21 control+ ;
: noREX? ( -- ? )       22 control? ;
: noREX+ ( -- )         22 control+ ;

1 constant #REX.B
2 constant #REX.X
4 constant #REX.R
8 constant #REX.W
: rex? ( -- ? )     REX? REX.R? or REX.B? or REX.X? or REX.W? or noREX? nand ;
: rex@ ( -- u )     REX.B? negate REX.X? -2 * REX.R? -4 * REX.W? -8 * + + + ;

bytevar DISPSIZE ( Size of displacement [B] )
: dispsize@ ( -- n )  DISPSIZE c@ ;
: dispsize! ( n -- )  DISPSIZE c! ;
: dispsize/ ( -- )  0 dispsize! ;
bytevar IMMSIZE ( Size of immediate operand value )
: immsize@ ( -- n )  IMMSIZE c@ ;
: immsize! ( n -- )  IMMSIZE c! ;
: immsize/ ( -- )  0 immsize! ;
bytevar MODREGR/M
: modregr/m@ ( -- c )  MODREGR/M c@ ;
: reg! ( c -- )  dup 8 and if  REX.R+  then  7 and 3 << MODREGR/M cor!  modregr/m+ ;
: reg/ ( -- )  MODREGR/M dup c@ $C7 and swap c! ;
: r/m! ( c -- )  dup 8 and if  REX.B+  then  7 and MODREGR/M cor!  modregr/m+ ;
: mod! ( c -- )  3 and 6 << MODREGR/M cor!  modregr/m+ ;
: mod@ ( -- c )  modregr/m@ 6 >> 3 and ;
: reg>r/m ( -- )  modregr/m@ 3 u>> r/m! reg/  REX.R?- if  REX.B+  then ;
: modregr/m/ ( -- )  0 MODREGR/M c! ;
bytevar SIB
: sib@ ( -- c )  SIB c@ ;
: sib! ( c -- )  SIB c! ;
: sib/ ( -- )  0 sib! ;
: base! ( c -- )  dup 8 and if  REX.B+  then  7 and SIB cor!  sib+ ;
: index! ( c -- )  dup 8 and if  REX.X+  then  7 and 3 << SIB cor!  sib+ ;
: scale! ( c -- )  3 and 6 << SIB cor!  sib+ ;
variable IMMOPVAL ( Immediate operand value )
: imm@ ( -- n )  IMMOPVAL @ ;
: imm#! ( n # -- )  immsize!  IMMOPVAL ! imm+ ;
: imm! ( n -- )  dup n.size imm#! imm+ ;
: uimm! ( n -- )  dup u.size imm#! ;
: imm/ ( -- )  immsize/  0 IMMOPVAL ! ;
variable DISPLACEMENT ( Address displacement )
: disp@ ( -- n )  DISPLACEMENT @ ;
: disp! ( n -- )  dup n.size dispsize! DISPLACEMENT ! ;
: disp/ ( -- ) 0 disp! ;
variable CODEBASE
: codebase@ ( -- u ) CODEBASE @ ;
: codebase! ( u -- ) CODEBASE ! ;
bytevar OPSIZE
: opsize@ ( -- c )  OPSIZE c@ ;
: opsize! ( c -- )  dup T.ARCH > fpuop? nand if  INVALID_OPERAND_SIZE$ error then
  dup #QWORD = if  REX.W+  then  OPSIZE c!  opsize+ ;
: opsize/ ( -- )  0 OPSIZE c! ;
bytevar ADDRSIZE
: addrsize@ ( -- c )  ADDRSIZE c@ ;
: addrsize! ( c -- )  ADDRSIZE c!  addrsize+ ;
: addrsize/ ( -- )  0 ADDRSIZE c! ;
: addrwidth@ ( -- n )  addrsize@ ?dup unless  T.ADDRSIZE  then size>width ;
bytevar PREFIX
: prefix@ ( -- c )  PREFIX c@ ;
: prefix! ( c -- )  dup PREFIX c!  if  prefix+  then ;
: prefix/ ( -- )  0 PREFIX c! ;
bytevar SIZEX
: sizex@ ( -- c )  SIZEX c@ ;
: sizex! ( c -- )  SIZEX c! ;
: sizex/ ( -- )  0 sizex! ;
: sizex@/ ( -- c )  SIZEX dup c@ 0 rot c! ;
bytevar OP#
: op#@ ( -- n )  OP# c@ ;
: op#1+! ( -- )  OP# c1+! ;
: op#/ ( -- )  0 OP# c! ;

: cleanup  ?error>>
  control/ imm/ disp/ dispsize/ prefix/ opsize/ addrsize/  modregr/m/  sib/  sizex/ op#/  0 THENA !
  adepth ?dup if  cr ." Line " sourceline# dec.  ." : cleanup " drop .sh space ." ADP=" ADP @ . ( abort
    adepth 0 do  drop  loop ) then ;

require A0-test.gf

=== Operand Definitions ===

--- Operand Utilities ---

: %BASEADDR/ ( addr -- addr' )  dup .mode %BASEADDR and if  %BASEADDR ^MODE << xor  then ;
: >indexed ( addr -- addr' )  $40 or  #INDEXED .amode! ;
: >indexed2 ( base index -- sib-addr )  .code 4 << or #INDEXED .amode! %BASEADDR/ ;
: base>index ( addr -- addr' )  disp@ if  BASE_EBP_REQUIRED$ error  then
  dup .code 4 << or  $FFFFFFF0 and  5 or #INDEXED .amode! nobase+ ;
: >sib ( addr -- addr' )  dup $F and base!  dup 4 >> $F and index!
  dup .addrmode #SCALED1 - 0 max scale! 4 .code! ;
: !register ( op -- op )  dup register? unless  REGISTER_OPERAND_EXPECTED$ error  then ;
: !address ( op -- op )  dup address? unless ADDRESS_OPERAND_EXPECTED$ error  then ;
: !immediate ( op -- op )  dup immediate? unless  IMMEDIATE_OPERAND_EXPECTED$ error  then ;
: !condition ( op -- op )  dup condition? unless  CONDITION_OPERAND_EXPECTED$ error  then ;
: !imm8 ( op -- op )
  dup immediate? over .size #WORD < and unless  IMMEDIATE8_OPERAND_EXPECTED$ error  then ;
: !imm16 ( op -- op )
  dup immediate? over .size #WORD ≤ and unless  IMMEDIATE16_OPERAND_EXPECTED$ error  then ;
: !r/m ( op -- op )  dup r/m? unless  REGISTER_OR_ADDRESS_OPERAND_EXPECTED$ error  then ;
: !stdreg ( op -- op )  dup stdreg? unless  STANDARD_REGISTER_EXPECTED$ error  then ;
: !fpureg ( op -- op )  dup fpureg? unless  FPU_REGISTER_EXPECTED$ error  then ;
: !mmxreg ( op -- op )  dup mmxreg? unless  MMX_REGISTER_EXPECTED$ error  then ;
: !xmmreg ( op -- op )  dup xmmreg? unless  XMM_REGISTER_EXPECTED$ error  then ;
: stdreg! ( op -- )  !stdreg reg! ;
: stdaddress?  ( op -- ? )  dup address? swap .size #OWORD < and ;
: direct? ( op -- ? )  dup .arch i64 = if $FF0FFFF and $2402245 = else .addrmode #DIRECT = then ;
: diraddr? ( op -- ? )  dup address? swap direct? and ;
: !stdr/m ( op -- op )  dup stdreg? over stdaddress? or unless  STANDARD_R/M_EXPECTED$ error  then ;
: op>opsize! ( op -- op )  dup .size opsize! ;
: addrmodr/m! ( op -- )
  dup address? unless  INVALID_OPERAND_TYPE$ error  then
  dup .mode %BASEADDR and if   4 >indexed2  then
  dup .mode %MOD01 and if  dispsize@ 1 max dispsize!  then
  dup .arch i16 = over .addrmode #INDEXED < or unless  >sib then
  dup .addrmode #DIRECT = unless
    dispsize@  over .mode %MOD00 and 0= and
    case  0 of 0 mod! endof  #BYTE of 1 mod! endof  2 mod!  endcase  then
  nobase? mod@ 0= and if  DWORD dispsize!  then
  r/m! ;
: ?rexreg ( op -- op )  dup .size #QWORD = if  REX.W+  then ;
: modr/m! ( op -- )  dup register? if  ?rexreg 3 mod! r/m!  else  addrmodr/m!  then ;
: stdmodr/m! ( op -- )  dup register? if  ?rexreg !stdreg 3 mod! r/m!  else  addrmodr/m!  then ;
: addr128? ( op -- ? )  dup address? swap .size #OWORD = and ;
: addr80? ( op -- ? )  dup address? swap .size #TBYTE = and ;
: addr64? ( op -- ? )  dup address? swap .size #QWORD = and ;
: addr32? ( op -- ? )  dup address? swap .size #DWORD = and ;
: addr16? ( op -- ? )  dup address? swap .size #WORD = and ;
: addr8? ( op -- ? )  dup address? swap .size #BYTE = and ;
: !addr128 ( op -- op )  dup addr128? unless  ADDRESS_128_OPERAND_EXPECTED$ error  then ;
: !addr80 ( op -- op )  dup addr80? unless  ADDRESS_80_OPERAND_EXPECTED$ error  then ;
: !addr64 ( op -- op )  dup addr64? unless  ADDRESS_64_OPERAND_EXPECTED$ error  then ;
: !addr32 ( op -- op )  dup addr32? unless  ADDRESS_32_OPERAND_EXPECTED$ error  then ;
: !addr16 ( op -- op )  dup addr16? unless  ADDRESS_16_OPERAND_EXPECTED$ error  then ;
: addr16+? ( op -- ? )  dup address? swap .size #BYTE > and ;
: !addr16+ ( op -- op )  dup addr16+? unless  ADDRESS_16+_OPERAND_EXPECTED$ error  then ;
: addr32+? ( op -- ? )  dup address? swap .size dup #DWORD = swap #QWORD = or and ;
: !addr32+ ( op -- op )  dup addr32+? unless  ADDRESS_32+_EXPECTED$ error  then ;
: addri32+? ( op -- ? )  dup .type #ADDRESS = swap .arch #DWORD >= and ;
: !addri32+ ( op -- op )  dup addri32+? unless  ADDRESS_32+_EXPECTED$ error  then ;
: xmreg? ( op -- ? )  dup register? swap .regmode #XMM = and ;
: !xmreg ( op -- op )  dup xmreg? unless  XMM_REGISTER_EXPECTED$ error  then ;
: xmreg! ( xmreg -- )  !xmreg reg! ;
: xmr/m128? ( op -- ? )  dup xmreg? swap addr128? or ;
: !xmr/m128 ( op -- op )  dup xmr/m128? unless  XMM_REGMEM128_EXPECTED$ error  then ;
: xmr/m128! ( op -- )  !xmr/m128 modr/m! ;
: xmr/m64? ( op -- ? )  dup xmreg? swap addr64? or ;
: !xmr/m64 ( op -- op )  dup xmr/m64? unless  XMM_REGMEM64_EXPECTED$ error  then ;
: xmr/m64! ( op -- )  !xmr/m64 modr/m! ;
: xmr/m32? ( op -- ? )  dup xmreg? swap addr32? or ;
: !xmr/m32 ( op -- op )  dup xmr/m32? unless  XMM_REGMEM32_EXPECTED$ error  then ;
: xmr/m32! ( op -- )  !xmr/m32 modr/m! ;
: xmr/m16? ( op -- ? )  dup xmreg? swap addr16? or ;
: !xmr/m16 ( op -- op )  dup xmr/m16? unless  XMM_REGMEM16_EXPECTED$ error  then ;
: xmr/m16! ( op -- )  !xmr/m16 modr/m! ;
: mxreg? ( op -- ? )  dup register? swap .regmode #MMX = and ;
: !mxreg ( op -- op )  dup mxreg? unless  MMX_REGISTER_EXPECTED$ error  then ;
: mxreg! ( xmreg -- )  !mxreg reg! ;
: mxr/m64? ( op -- ? )  dup mxreg? swap addr64? or ;
: !mxr/m64 ( op -- op )  dup mxr/m64? unless  MMX_REGMEM64_EXPECTED$ error  then ;
: mxr/m64! ( op -- )  !mxr/m64 modr/m! ;
: reg32+? ( op -- ? )  dup register? swap .size dup #DWORD = swap #QWORD = or and ;
: !reg32+ ( op -- op )  dup reg32+? unless  REGISTER_32+_EXPECTED$ error  then ;
: reg64? ( op -- ? )  dup register? swap .size #QWORD = and ;
: !reg64 ( op -- op )  dup reg64? unless  REGISTER_64_EXPECTED$ error  then ;
: stdreg32+? ( op -- ? )  dup stdreg? swap .size #DWORD < 0= and ;
: !stdreg32+ ( op -- op )  dup stdreg32+? unless  REGISTER_32+_EXPECTED$ error  then ;
: reg32? ( op -- ? )  dup register? swap .size #DWORD = and ;
: !reg32 ( op -- op )  dup reg32? unless  REGISTER_32_EXPECTED$ error  then ;
: stdreg32? ( op -- ? )  dup stdreg? swap .size #DWORD = and ;
: reg16+? ( op -- ? )  dup register? swap .size #BYTE > and ;
: !reg16+ ( op -- op )  dup reg16+? unless  REGISTER_16_EXPECTED$ error  then ;
: reg16? ( op -- ? )  dup register? swap .size #WORD = and ;
: !reg16 ( op -- op )  dup reg16? unless  REGISTER_16_EXPECTED$ error  then ;
: stdreg16+? ( op -- ? )  dup stdreg? swap .size dup #BYTE > swap #OWORD < and and ;
: !stdreg16+ ( op -- op )  dup stdreg16+? unless  REGISTER_16+_EXPECTED$ error  then ;
: reg8? ( op -- ? )  dup register? swap .size #BYTE = and ;
: !r/m64 ( op -- op )  dup addr64? unless dup reg64? unless R/M_64_EXPECTED$ error then then ;
: !r/m32+ ( op -- op )  dup addr32+? unless dup reg32+? unless R/M_32+_EXPECTED$ error then then ;
: !r/m32 ( op -- op )
  dup address? over register? or  over .size #DWORD = and unless  R/M_32_EXPECTED$ error  then ;
: !r/m16 ( op -- op )  dup addr16? unless dup reg16? unless  R/M_16_EXPECTED$ error  then then ;
: modr32/m16! ( op -- )  dup stdreg32? if  ?rexreg 3 mod! r/m!  else  dup addr16? if
  addrmodr/m!  else  drop R32/M16_EXPECTED$ error  then then ;
: !stdr/m16+ ( op -- op )
  dup addr16+? unless dup stdreg16+? unless  R/M_16+_EXPECTED$ error  then then ;
: !r/m8 ( op -- op )  dup addr8? unless dup reg8? unless  R/M_8_EXPECTED$ error  then then ;
: !-byteop ( op -- op )  dup .size #BYTE = if  BYTE_SIZE_OPERAND_INVALID$ error  then ;
: !wordop ( op -- op )  dup .size #WORD - if  WORD_SIZE_OPERAND_EXPECTED$ error  then ;
: ![d]wordop ( op -- op )
  dup .size dup #WORD = swap #DWORD = or unless  [D]WORD_SIZE_OPERAND_EXPECTED$ error  then ;
: !d|qwordop ( op -- op )  dup .size #WORD > unless  DQWORD_SIZE_OPERAND_EXPECTED$ error  then ;
: !sibified ( addr -- addr' )  dup indexed? unless  base>index  >sib  then ;
: match-arch16 ( op -- op ? )  T.ARCH dup i16 = swap uni = or unless
    dup address? if #WORD addrsize! then  then  true ;
: match-arch32 ( -- ? )
  T.ARCH dup i32 = over uni = or swap ext = or  over register? if  T.ARCH i64 = or then ;
: match-arch64 ( op -- op ? )  T.ARCH dup i64 = over uni = or swap ext = or ;
: match-archuni ( -- ? )  true ;
: match-archext ( -- ? )  T.ARCH dup i32 = swap i64 = or ;
: check-arch ( op arch -- op )  case
  i16 of  match-arch16  unless INVALID_TARGET_ARCHITECTURE$ error then  endof
  i32 of  match-arch32  unless I32_NOT_SUPPORTED$ error then  endof
  i64 of  match-arch64  unless I64_NOT_SUPPORTED$ error then  endof
  uni of  match-archuni  unless INVALID_TARGET_ARCHITECTURE$ error then  endof
  ext of  match-archext  unless INVALID_TARGET_ARCHITECTURE$ error then  endof
  x87 of  T.COPROC %X87 and  unless X87_NOT_SUPPORTED$ error then  endof
  mmx of  T.COPROC %MMX and  unless MMX_NOT_SUPPORTED$ error then  endof
  xmm of  T.COPROC %XMM and  unless XMM_NOT_SUPPORTED$ error then  endof
  INVALID_ARCHITECTURE_DEFINITION$ error  endcase ;
: !arch ( op -- op )  dup .arch check-arch ;
: !arch= ( addr addr -- addr addr )
  2dup .arch swap .arch = unless  ARCHITECTURE_MISMATCH$ error  then ;
: validBase? ( addr -- ? )  !arch .addrmode #INDEXED u< ;
: ~[xSP] ( addr -- ? )  .code 7 and 4 ≠ ;
: validIndex32+? ( addr -- ? )  !arch dup validBase?  over .arch #WORD u> and swap ~[xSP] and ;
: !validBase ( addr -- addr )  dup validBase? unless ADDRESS_NOT_COMBINABLE$ error  then ;
: !validIndex32+ ( addr -- addr )  dup validIndex32+? unless  INVALID_ADDRESS_INDEX$ error  then ;
: >sizex ( op -- op' )  dup .size 0= if  sizex@ .size!  then ;
: size>immsize ( op -- op )  dup .size immsize! ;
: check-opsize ( op1 op2 -- op1 op2 )
  over .size-no-imm over .size or unless  OPERAND_SIZE_UNKNOWN$ error  then ;
: ?size! ( op1 op2 -- op1 op2' )  dup .size-no-imm unless  over .size .size! then ;
: supply-opsize ( op1 op2 -- op1' op2' )  swap ?size! swap ?size! ;
: match-size16 ( -- ? )  #WORD opsize! true ;
: match-size32 ( -- ? )  #DWORD opsize! true ;
: match-size64 ( -- ? )  #QWORD opsize! true ;
: !opsize ( op -- op )  dup .size case
       0 of  OPERAND_SIZE_UNKNOWN$ error true  endof
   #BYTE of  true  endof
   #WORD of  match-size16  endof
  #DWORD of  match-size32  endof
  #QWORD of  match-size64  endof
  false  endcase  unless  INVALID_OPERAND_SIZE$ error  then ;
: !=opsize ( op sz -- op )  over .size = unless  INVALID_OPERAND_SIZE$ error  then ;
: !opsize= ( op1 op2 -- op1 op2 ) \ assert that operand sizes are equal
  check-opsize supply-opsize !opsize over .size over .size - if  OPERAND_SIZE_MISMATCH$ error  then
  over immediate? if  dup .size immsize!  then ;
: limit32 #DWORD min ;
: opsizext ( imm op -- imm op n ) \ check operand size with size extension
  !opsize over .size over .size u> if  IMMEDIATE_TOO_BIG$ error 0  else  dup .size
  #BYTE = if  0  else  over .size #BYTE = 2 and 1+  then then
  dup 1 = if  opsize@ limit32 immsize!  then ;
: ?hibyte+ ( op -- op )  dup .regmode #HI-BYTE = if  hibyte+  then ;
: ![n]eq ( condition -- 0=eq|1=ne ) !condition .code dup CEQ = if 1 else dup CNE = if 0 else
  EQ_OR_NEQ_REQUIRED$ error -1  then then nip ;
: ?rex+ ( op -- op )  dup .arch i64 = if  REX+  then ;

--- Definer Tools ---

: buildOp ( a[type size mode code] )  c@++ c@++< c@++< c@< ;
: makeSize ( size arch -- size+arch )  $F and 4 << swap $F and or ;
: makeImmediate ( n # -- immop )  ^SIZE << #IMMEDIATE ^TYPE << + swap imm! ;
: makeUmmediate ( n # -- immop )  ^SIZE << #IMMEDIATE ^TYPE << + swap uimm! ;
: makeAddress ( disp addr -- addr )  adepth 2 u< if  MISSING_ADDRESS_DISPLACEMENT$ error  exit  then
  swap disp!  !arch  addr+ >sizex  op#1+! ;
: makeDirect ( disp code mode size arch -- addr )
  #ADDRESS 4 << + 4 << + 8 << + 8 << + swap disp! addr+ >sizex ;
: mergeAddress ( addr1 addr2 -- addr1' )  !arch= swap !validBase swap !validIndex32+ !arch= >indexed2 ;
: ?mergeAddress ( [disp] [addr] addr -- addr' )  addr? if  mergeAddress else makeAddress then ;

--- Definers ---

: register ( code mode size arch "name" -- )
  create #REGISTER c, makeSize c, c, c,
  does>  buildOp ?hibyte+ ?rex+ !arch  op#1+! ;
: address ( code mode size arch "name" -- )
  create #ADDRESS c, makeSize c, c, c,
  does>  buildOp ?mergeAddress ;
: scale ( code "name" -- ) ( addr -- addr' )
  create c,
  does>  swap !addri32+ !sibified swap c@ #SCALED1 + .amode! ;
: condition  ( code "name" -- )
  create #CONDITION c, 0 c, #REGULAR c, c,
  does>  buildOp  op#1+! ;
: fcondition  ( code "name" -- )
  create #CONDITION c, 0 c, #FLOATCND c, c,
  does>  buildOp  op#1+! ;

=== Registers ===

Forcembler definitions
( cr ." Order @2: " order )

--- Regular Registers ---

00 #REGULAR #BYTE uni register AL
01 #REGULAR #BYTE uni register CL
02 #REGULAR #BYTE uni register DL
03 #REGULAR #BYTE uni register BL
04 #HI-BYTE #BYTE uni register AH
05 #HI-BYTE #BYTE uni register CH
06 #HI-BYTE #BYTE uni register DH
07 #HI-BYTE #BYTE uni register BH
04 #REGULAR #BYTE i64 register SPL
05 #REGULAR #BYTE i64 register BPL
06 #REGULAR #BYTE i64 register SIL
07 #REGULAR #BYTE i64 register DIL
08 #REGULAR #BYTE i64 register R08L alias R8L
09 #REGULAR #BYTE i64 register R09L alias R9L
10 #REGULAR #BYTE i64 register R10L
11 #REGULAR #BYTE i64 register R11L
12 #REGULAR #BYTE i64 register R12L
13 #REGULAR #BYTE i64 register R13L
14 #REGULAR #BYTE i64 register R14L
15 #REGULAR #BYTE i64 register R15L

00 #REGULAR #WORD i16 register AX
01 #REGULAR #WORD i16 register CX
02 #REGULAR #WORD i16 register DX
03 #REGULAR #WORD i16 register BX
04 #REGULAR #WORD i16 register SP
05 #REGULAR #WORD i16 register BP
06 #REGULAR #WORD i16 register SI
07 #REGULAR #WORD i16 register DI
08 #REGULAR #WORD i64 register R08W
09 #REGULAR #WORD i64 register R09W
10 #REGULAR #WORD i64 register R10W
11 #REGULAR #WORD i64 register R11W
12 #REGULAR #WORD i64 register R12W
13 #REGULAR #WORD i64 register R13W
14 #REGULAR #WORD i64 register R14W
15 #REGULAR #WORD i64 register R15W

00 #REGULAR #DWORD i32 register EAX
01 #REGULAR #DWORD i32 register ECX
02 #REGULAR #DWORD i32 register EDX
03 #REGULAR #DWORD i32 register EBX
04 #REGULAR #DWORD i32 register ESP
05 #REGULAR #DWORD i32 register EBP
06 #REGULAR #DWORD i32 register ESI
07 #REGULAR #DWORD i32 register EDI
08 #REGULAR #DWORD i64 register R08D alias R8D
09 #REGULAR #DWORD i64 register R09D alias R9D
10 #REGULAR #DWORD i64 register R10D
11 #REGULAR #DWORD i64 register R11D
12 #REGULAR #DWORD i64 register R12D
13 #REGULAR #DWORD i64 register R13D
14 #REGULAR #DWORD i64 register R14D
15 #REGULAR #DWORD i64 register R15D

00 #REGULAR #QWORD i64 register RAX
01 #REGULAR #QWORD i64 register RCX
02 #REGULAR #QWORD i64 register RDX
03 #REGULAR #QWORD i64 register RBX
04 #REGULAR #QWORD i64 register RSP
05 #REGULAR #QWORD i64 register RBP
06 #REGULAR #QWORD i64 register RSI
07 #REGULAR #QWORD i64 register RDI
08 #REGULAR #QWORD i64 register R08 alias R8
09 #REGULAR #QWORD i64 register R09 alias R9
10 #REGULAR #QWORD i64 register R10
11 #REGULAR #QWORD i64 register R11
12 #REGULAR #QWORD i64 register R12
13 #REGULAR #QWORD i64 register R13
14 #REGULAR #QWORD i64 register R14
15 #REGULAR #QWORD i64 register R15

--- Segment Registers ---

00 #SEGMENT #WORD uni register ES
01 #SEGMENT #WORD uni register CS
02 #SEGMENT #WORD uni register SS
03 #SEGMENT #WORD uni register DS
04 #SEGMENT #WORD uni register FS
05 #SEGMENT #WORD uni register GS

--- Control Registers ---

00 #CONTROL #DWORD ext register CR0
01 #CONTROL #DWORD ext register CR1
02 #CONTROL #DWORD ext register CR2
03 #CONTROL #DWORD ext register CR3
04 #CONTROL #DWORD ext register CR4
05 #CONTROL #DWORD ext register CR5
06 #CONTROL #DWORD ext register CR6
07 #CONTROL #DWORD ext register CR7
08 #CONTROL #DWORD i64 register CR8
09 #CONTROL #DWORD i64 register CR9
10 #CONTROL #DWORD i64 register CR10
11 #CONTROL #DWORD i64 register CR11
12 #CONTROL #DWORD i64 register CR12
13 #CONTROL #DWORD i64 register CR13
14 #CONTROL #DWORD i64 register CR14
15 #CONTROL #DWORD i64 register CR15

--- Debug Registers ---

00 #DEBUG #DWORD ext register DR0
01 #DEBUG #DWORD ext register DR1
02 #DEBUG #DWORD ext register DR2
03 #DEBUG #DWORD ext register DR3
04 #DEBUG #DWORD ext register DR4
05 #DEBUG #DWORD ext register DR5
06 #DEBUG #DWORD ext register DR6
07 #DEBUG #DWORD ext register DR7
08 #DEBUG #DWORD i64 register DR8
09 #DEBUG #DWORD i64 register DR9
10 #DEBUG #DWORD i64 register DR10
11 #DEBUG #DWORD i64 register DR11
12 #DEBUG #DWORD i64 register DR12
13 #DEBUG #DWORD i64 register DR13
14 #DEBUG #DWORD i64 register DR14
15 #DEBUG #DWORD i64 register DR15

--- FPU Registers ---

00 #FLOATING #TBYTE x87 register ST0 alias ST(0)
01 #FLOATING #TBYTE x87 register ST1 alias ST(1)
02 #FLOATING #TBYTE x87 register ST2 alias ST(2)
03 #FLOATING #TBYTE x87 register ST3 alias ST(3)
04 #FLOATING #TBYTE x87 register ST4 alias ST(4)
05 #FLOATING #TBYTE x87 register ST5 alias ST(5)
06 #FLOATING #TBYTE x87 register ST6 alias ST(6)
07 #FLOATING #TBYTE x87 register ST7 alias ST(7)

--- MMX Registers ---

00 #MMX #QWORD mmx register MM0
01 #MMX #QWORD mmx register MM1
02 #MMX #QWORD mmx register MM2
03 #MMX #QWORD mmx register MM3
04 #MMX #QWORD mmx register MM4
05 #MMX #QWORD mmx register MM5
06 #MMX #QWORD mmx register MM6
07 #MMX #QWORD mmx register MM7

--- XMM Registers ---

00 #XMM #OWORD xmm register XMM0
01 #XMM #OWORD xmm register XMM1
02 #XMM #OWORD xmm register XMM2
03 #XMM #OWORD xmm register XMM3
04 #XMM #OWORD xmm register XMM4
05 #XMM #OWORD xmm register XMM5
06 #XMM #OWORD xmm register XMM6
07 #XMM #OWORD xmm register XMM7
08 #XMM #OWORD i64 register XMM8
09 #XMM #OWORD i64 register XMM9
10 #XMM #OWORD i64 register XMM10
11 #XMM #OWORD i64 register XMM11
12 #XMM #OWORD i64 register XMM12
13 #XMM #OWORD i64 register XMM13
14 #XMM #OWORD i64 register XMM14
15 #XMM #OWORD i64 register XMM15

=== Addresses ===

--- 16-bit addresses ---

00 #INDEXED 0 i16 address [BX+SI]
01 #INDEXED 0 i16 address [BX+DI]
02 #INDEXED 0 i16 address [BP+SI]
03 #INDEXED 0 i16 address [BP+DI]
04 #INDEXED 0 i16 address [SI]
05 #INDEXED 0 i16 address [DI]
06 #INDEXED %MOD01 + 0 i16 address [BP]
07 #INDEXED 0 i16 address [BX]

--- 32-bit Addresses ---

00 #LINEAR 0 i32 address [EAX]
01 #LINEAR 0 i32 address [ECX]
02 #LINEAR 0 i32 address [EDX]
03 #LINEAR 0 i32 address [EBX]
04 #LINEAR %BASEADDR + 0 i32 address [ESP]
05 #LINEAR %MOD01 + 0 i32 address [EBP]
06 #LINEAR 0 i32 address [ESI]
07 #LINEAR 0 i32 address [EDI]
08 #LINEAR 0 i32 address [D08] alias [D8]
09 #LINEAR 0 i32 address [D09] alias [D9]
10 #LINEAR 0 i32 address [D10]
11 #LINEAR 0 i32 address [D11]
12 #LINEAR %BASEADDR + 0 i32 address [D12]
13 #LINEAR %MOD01 + 0 i32 address [D13]
14 #LINEAR 0 i32 address [D14]
15 #LINEAR 0 i32 address [D15]

--- 64-bit Addresses ---

00 #LINEAR 0 i64 address [RAX]
01 #LINEAR 0 i64 address [RCX]
02 #LINEAR 0 i64 address [RDX]
03 #LINEAR 0 i64 address [RBX]
04 #LINEAR %BASEADDR + 0 i64 address [RSP]
05 #LINEAR %MOD01 + 0 i64 address [RBP]
06 #LINEAR 0 i64 address [RSI]
07 #LINEAR 0 i64 address [RDI]
08 #LINEAR 0 i64 address [R08] alias [R8]
09 #LINEAR 0 i64 address [R09] alias [R9]
10 #LINEAR 0 i64 address [R10]
11 #LINEAR 0 i64 address [R11]
12 #LINEAR %BASEADDR + 0 i64 address [R12]
13 #LINEAR %MOD01 + 0 i64 address [R13]
14 #LINEAR 0 i64 address [R14]
15 #LINEAR 0 i64 address [R15]

--- Scales ---

00 scale *1
01 scale *2
02 scale *4
03 scale *8

--- Direct Memory ---

: [] ( a -- )  T.ADDRSIZE case
  #WORD of 6 #DIRECT 0 i16 makeDirect  #WORD dispsize!  endof
  #DWORD of 5 #DIRECT 0 i32 makeDirect #DWORD dispsize!  endof
  #QWORD of $45 #INDEXED %MOD00 OR 0 i64 makeDirect #DWORD dispsize!  endof
  INVALID_TARGET_ARCHITECTURE$ error!  endcase op#1+! ;
: [RIP] ( disp -- )  T.ARCH i64 = unless  RIP_64_ONLY$ error  then
  5 #DIRECT 0 i64 makeDirect  #DWORD dispsize! op#1+! ;
: @@ ( @rvoc sym$ u -- )  -rot reloc-sym ! reloc-voc ! reloc+ [] ;
: # ( n -- )  dup n.size makeImmediate op#1+! ;
: ## ( @rvoc sym$ u -- )  -rot reloc-sym ! reloc-voc ! reloc+ # ;
: u# ( u -- )  dup u.size makeUmmediate op#1+! ;

: PTR ( # -- )  width>size sizex! ;
: FAR ( -- )  far+ ;
: NEAR ( -- )  near+ ;

previous definitions
also Forcembler
( cr ." Order @3: " order )

=== Operations ===

--- Operation Utils ---

: !legacy ( -- )  T.ARCH i64 = if  LEGACY_OPCODE$ error  then ;
: !>486 ( -- )  T.ARCH i16 = if  OPERATION_NOT_SUPPORTED<486$ error  then ;
: !>586 ( -- )  T.ARCH i16 = if  OPERATION_NOT_SUPPORTED<586$ error  then ;
: !fpu ( -- )  T.COPROC %X87 and unless  X87_NOT_SUPPORTED$ error  then  fpuop+ ;
: >opsize ( op -- op # )  dup .size #BYTE > negate ;
: !no64 ( -- )  opsize@ #DWORD > if  INVALID_OPERAND_SIZE$ error  then ;
: r/mreg! ( r/mop regop -- )  reg! !stdr/m modr/m! ;
: >mask  ( # -- % )  case
   0 of  1  endof
   #BYTE of  $7F  endof
   #WORD of  $7FFF  endof
  #DWORD of  $7FFFFFFF  endof
  #QWORD of  $7FFFFFFFFFFFFFFF  endof
  INVALID_OPERAND_SIZE$ error  endcase ;
: fits? ( n # -- n # ? )  over abs over >mask over and = ;
: !fits ( n # -- n # )  fits? unless  IMMEDIATE_TOO_BIG$ error  then ;
: !size= ( op1 op2 -- op1 op2 )  over .size over .size - if  OPERAND_SIZE_MISMATCH$ error  then ;
: reladdr ( size offset -- )
  imm@ r- swap fits? unless  TARGET_ADDRESS_OUT_OF_RANGE$ error  then imm#! ;
: farptr?  ( -- ? )  false ;

--- Operation Builders ---

: #, ( n # -- )  !fits  case
  0 of  tc,  endof
   #BYTE of  tc,  endof
   #WORD of  tw,  endof
  #DWORD of  td,  endof
  #QWORD of  td,  endof
  INVALID_IMMEDIATE_SIZE$ error  endcase ;
: ##, ( n # -- )  !fits  case
  0 of  tc,  endof
   #BYTE of  tc,  endof
   #WORD of  tw,  endof
  #DWORD of  td,  endof
  #QWORD of  t,   endof
  INVALID_IMMEDIATE_SIZE$ error  endcase ;
: #! ( n # a -- )  >r !fits  case
   #BYTE of  r> c!  endof
   #WORD of  r> w!  endof
  #DWORD of  r> d!  endof
  #QWORD of  r> !   endof
  r> drop INVALID_IMMEDIATE_SIZE$ error  endcase ;
: disp, ( -- )  dispsize@ case
  0 of  endof
  #BYTE of  disp@ #BYTE #,  endof
  disp@ addrsize? if  addrsize@ else T.ADDRSIZE  then  dup >r #,
    reloc? if  reloc-voc @ reloc-sym @ toff r@ - r@ dataReloc,  then  r> drop  endcase ;
: modregr/m, ( ... -- )  modregr/m? if  modregr/m@ tc,  sib? if  sib@ tc,  then  disp, then ;
: opsize, ( -- )
  opsize? fpuop? 0= and if
    opsize@ #QWORD = if  REX.W+  then
    opsize@ #WORD = T.ADDRSIZE #WORD ≠ and if  $66 tc,  then then ;
: addrsize, ( -- )  addrsize? if  addrsize@ T.ADDRSIZE = unless  $67 tc,  then then ;
: prefix, ( -- )  prefix? if  prefix@ tc,  then ;
: rex, ( -- )
  rex? fpuop? nand if rex@ 8 = mmxop? and unless rex@ mmxop? 8 and nand $40 u+ tc, then then ;
: escape, ( -- )  esc? if  $0F tc,  then ;
: prefices, ( -- )  opsize, addrsize, prefix, rex, escape, ;
: imm, ( -- )  imm? if  imm@ immsize@  wide? if  ##,  else  #,  then then ;
: operands, ( -- )  modregr/m, imm, ;
: validate ( -- )  hibyte? rex? and if  HIBYTE_NOT_AVAILABLE_WITH_REX$ error  then ;
: op, ( ... opc -- )  validate prefices, tc, operands,  cleanup ;
: op&, ( ... opc -- )  validate prefices, tc, operands, ;
: 2op, ( ... opc2 opc1 -- )  validate prefices, tc, tc, operands,  cleanup ;
: daop, ( opc -- )  validate prefices, tc, imm@ T.ARCH ##, cleanup ;

--- Operation Definer Tools ---

: 66+ ( -- )  $66 prefix! ;
: F2+ ( -- )  $F2 prefix! ;
: F3+ ( -- )  $F3 prefix! ;
: !args ( n -- )  dup op#@ = unless
  cr c" Expected " .error dup dec. ." operand(s), but got " op#@ . ." -- cannot continue!"
  abort then drop ;

--- Operation Definers ---

: segprefix ( / opc )
  create c,
  does>  c@ tc, ;
: op00 ( / opc )
  create c,
  does> 0 !args c@ op, ;
: op0F ( / opc )
  create c,
  does> 0 !args !>586 esc+ c@ op, ;
: op00L ( / opc )
  create c,
  does>  c@ !legacy op, ;
: op01L ( / [n] opc )
  create c,
  does>  c@ !legacy adepth 2 - if  10 # swap  then  nip op, ;
: op02 ( / opc )
  create c,
  does>  sizex@ opsize! c@ op, ;
: op02L ( / opc )
  create c,
  does>  sizex@ opsize! c@ !legacy op, ;
: op02F ( / opc )
  create c,
  does>  sizex@ opsize! !>586 esc+ c@ op, ;
: flop01 ( / opc )
  create c,
  does>  0 !args  !fpu c@ $D9 tc, tc, cleanup ;
: flop02 ( mem / opc )
  create c,
  does>  1 !args  !fpu c@ reg!  !address modr/m!  $D9 op, ;
: flop03 ( mem / opc )
  create c,
  does>  1 !args  !fpu c@ reg!  !address modr/m!  $DD op, ;
: logarop-immacc  ( imm acc -- )  2 !args !opsize= size>immsize .size #WORD < 5 + A@ 8* u+ nip op, ;
: logarop-immr/m  ( imm r/m -- )  .line .sh 2 !args !opsize  opsizext $80 + swap  A@ r/mreg! nip op,  ;
: logarop-imm ( imm r/m -- )  2 !args dup accu? if  logarop-immacc  else  logarop-immr/m  then ;
: logarop-reg ( reg r/m -- )  2 !args !opsize=  stdmodr/m! dup stdreg! >opsize A@ 8* + nip op, ;
: logarop-mem ( mem reg -- )  2 !args !opsize=  over stdmodr/m! stdreg! >opsize A@ 8* 2+ + nip op, ;
: logarop ( ... opc )
  create c,
  does>  c@ >A 2dup imm>r/m? if logarop-imm else 2dup reg>r/m? if logarop-reg else 2dup mem>reg? if
         logarop-mem else INVALID_OPERAND_COMBINATION$ error then then then  A> drop ;
: xmop01a ( xmr/m128 xmreg / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m128! c@ op, ;
: xmop01b ( xmr/m64 xmreg / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m64! c@ op, ;
: xmop01c ( xmr/m32 xmreg / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m32! c@ op, ;
: xmop01d ( mem128 xmreg / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! !addr128 modr/m! c@ op, ;
: xmop01e ( xmreg1 xmreg2 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! !xmreg xmr/m128! c@ op, ;
: xmop01g ( xmreg mem128 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot !addr128 modr/m! xmreg! c@ op, ;
: xmop01h ( imm8 xmreg mem128 / opc prefix )
  create c, c,
  does>  3 !args  esc+ @c++ prefix! -rot xmreg! xmr/m128! swap !imm8 drop c@ op, ;
: xmop01i ( imm8 xmreg mem32 / opc prefix )
  create c, c,
  does>  3 !args  esc+ @c++ prefix! -rot xmreg! xmr/m32! swap !imm8 drop c@ op, ;
: xmop02a ( xmr/m128 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m128! c@++ c@ 2op, ;
: xmop02b ( xmr/m64 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m64! c@++ c@ 2op, ;
: xmop02c ( xmr/m32 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m32! c@++ c@ 2op, ;
: xmop02d ( xmr/m16 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! xmr/m16! c@++ c@ 2op, ;
: xmop02e ( mem128 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! !addr128 modr/m! c@++ c@ 2op, ;
: xmop03a ( imm8 xmr/m128 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args  esc+ @c++ prefix! >r xmreg! xmr/m128! !imm8 drop r> c@++ c@ 2op, ;
: xmop03b ( imm8 xmr/m32 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args  esc+ @c++ prefix! >r xmreg! xmr/m32! !imm8 drop r> c@++ c@ 2op, ;
: xmop03c ( imm8 xmreg r/m64 / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args esc+ @c++ prefix! >r !r/m64 op>opsize! stdmodr/m! xmreg! !imm8 drop r> c@++ c@ 2op, ;
: xmop03d ( imm8 xmreg r/m32 / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args esc+ @c++ prefix! >r !r/m32 op>opsize! stdmodr/m! xmreg! !imm8 drop r> c@++ c@ 2op, ;
: xmop03e ( imm8 xmreg r/m8 / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args esc+ @c++ prefix! >r !r/m8 op>opsize! stdmodr/m! xmreg! !imm8 drop r> c@++ c@ 2op, ;
: xmop03f ( imm8 r/m64 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args esc+ @c++ prefix! >r xmreg! !r/m64 op>opsize! stdmodr/m! !imm8 drop r> c@++ c@ 2op, ;
: xmop03g ( imm8 r/m32 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args esc+ @c++ prefix! >r xmreg! !r/m32 op>opsize! stdmodr/m! !imm8 drop r> c@++ c@ 2op, ;
: xmop03h ( imm8 r/m8 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args esc+ @c++ prefix! >r xmreg! !r/m8 op>opsize! stdmodr/m! !imm8 drop r> c@++ c@ 2op, ;
: xmop03i ( imm8 xmr/m64 xmreg / opc1 opc2 prefix )
  create c, c, c,
  does>  3 !args  esc+ @c++ prefix! >r xmreg! xmr/m64! !imm8 drop r> c@++ c@ 2op, ;
: xmop03z ( imm8 xmr/m64 xmreg / opc prefix )
  create c, c,
  does>  3 !args  esc+ @c++ prefix! >r xmreg! xmr/m128! !imm8 drop r> c@ op, ;
: xmop04a ( xmr/m64 reg32|64 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot !reg32+ op>opsize! stdreg! xmr/m64! c@ op, ;
: xmop04b ( xmr/m32 reg32|64 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmr/m32! !reg32+ reg! c@ op, ;
: xmop04c ( r/m32|64 xmreg / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot xmreg! !r/m32+ op>opsize! stdmodr/m! c@ op, ;
: xmop04d ( xmreg reg32+ / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! -rot !stdreg32+ op>opsize! reg! !xmreg modr/m! c@ op, ;
: xmop05a ( xmr/m128 xmreg | xmreg xmr/m128 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! c@ -rot dup
         address? if rot 1+ -rot swap then  xmreg! xmr/m128! op, ;
: xmop05b ( xmr/m128 xmreg | xmreg xmr/m128 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! c@ -rot dup
         address? if rot $10 + -rot swap then  xmreg! xmr/m128! op, ;
: xmop05c ( mem64 xmreg | xmreg mem64 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! c@ -rot dup
         address? if rot 1+ -rot swap then  xmreg! !addr64 modr/m! op, ;
: xmop05d ( xmr/m64 xmreg | xmreg xmr/m64 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! c@ -rot dup
         address? if rot 1+ -rot swap then  xmreg! xmr/m64! op, ;
: xmop05e ( xmr/m64 xmreg | xmreg xmr/m64 / opc prefix )
  create c, c,
  does>  2 !args  esc+ @c++ prefix! c@ -rot dup
         address? if rot 1+ -rot swap then  xmreg! xmr/m32! op, ;
: mxop01e ( mxreg1 mxreg2 / opc prefix )
  create c, c,
  does>  2 !args  mmxop+ esc+ @c++ prefix! -rot mxreg! !mxreg mxr/m64! c@ op, ;
: mxop01g ( mxreg mem64 / opc prefix )
  create c, c,
  does>  2 !args  mmxop+ esc+ @c++ prefix! -rot !address mxr/m64! mxreg! c@ op, ;
: mxop01h ( imm8 xmreg mem128 / opc prefix )
  create c, c,
  does>  3 !args  mmxop+ esc+ @c++ prefix! -rot mxreg! mxr/m64! swap !imm8 drop c@ op, ;
: bitscop ( r/m reg / opc )
  create c,
  does>  2 !args esc+ c@ -rot !opsize= !stdreg reg! !stdr/m modr/m! op, ;
: bitop-imm ( opc imm r/m )  !-byteop !opsize !stdr/m modr/m!  !imm8 drop reg! $BA op, ;
: bitop-reg ( opc reg r/m )  !opsize= swap op>opsize! !stdreg reg!  !r/m modr/m! 8* $83 + op, ;
: bitop ( imm|reg r/m / opc )
  create c,
  does>  2 !args esc+ c@ -rot over immediate? if  bitop-imm  else  bitop-reg  then ;
: jmp-rel8 ( opc )  drop #BYTE toff 2+ reladdr  $EB op, ;
: jmpcall-imm ( opc imm )
  drop imm@ toff - -126 130 within near? nand if  dup if  jmp-rel8 exit  then  then
  imm@ swap addrwidth@ DWORD min dup 1+  toff + reladdr $E8 + op&,
  reloc? if  reloc-voc @ reloc-sym @ toff 4- codeReloc,  then  drop cleanup ;
: jmpcall-far ( opc addr )  FAR_CALL_UNSUPPORTED$ error  swap $50 * $9A + op, ;
: jmpcall-r/m ( opc r/m )  swap 1 << 2+ reg! modr/m! $FF op, ;
: jmpcall ( target / opc )
  create  c,
  does>   1 !args  c@ swap dup immediate? if  jmpcall-imm  else  farptr? if  jmpcall-far  else
          dup r/m? if  jmpcall-r/m  else  INVALID_OPERAND_TYPE$ error  then then then ;
: cvop01 ( / size )
  create c,
  does>  0 !args c@ opsize! $98 op, ;
: cvop02 ( / size )
  create c,
  does>  0 !args c@ opsize! $99 op, ;
: strop ( size opc )
  create c,
  does>  0 !args c@ sizex@ dup opsize! ?dup unless OPERAND_SIZE_UNKNOWN$ error then  #BYTE > - op, ;
: incdecreg ( opc reg )  op>opsize! .code swap 8* + $40 + op, ;
: incdecr/m ( opc r/m )  swap reg! op>opsize! >opsize $FE + swap stdmodr/m! op, ;
: incdecop ( r/m / opc )
  create c,
  does>  c@ swap T.ARCH i64 = unless  dup stdreg16+? if  incdecreg exit then then  incdecr/m ;
: (arithop)  ( r/m opc )  reg! op>opsize! >opsize $F6 + swap stdmodr/m! op, ;
: arithop ( r/m / opc )
  create c,
  does>  1 !args c@ (arithop) ;
: flopar1m32 ( opc mem32 )  swap reg! modr/m! $D8 op, ;
: flopar1m64 ( opc mem64 )  swap reg! modr/m! $DC op, ;
: flopar1ST ( opc ST )  swap reg! modr/m! $DC op, ;
: flopar1 ( ST/mem32|64 / opc )
  create c,
  does>  !fpu 1 !args c@ swap !opsize dup addr32? if flopar1m32 else dup addr64? if flopar1m64 else
         dup fpureg? if  flopar1ST  else  2drop INVALID_OPERAND_TYPE$ error cleanup then then then ;
: flopar0 ( ST / opc )
  create c,
  does>  !fpu 1 !args c@ swap !fpureg swap reg! modr/m! $D8 op, ;
: flopar2 ( [ST] / opc )
  create c,
  does>  !fpu adepth 1 = if  ST(1) swap  then  1 !args c@ reg! !fpureg modr/m! $DE op, ;
: flopar3m16 ( opc mem16 )  swap reg! modr/m! $DA op, ;
: flopar3m32 ( opc mem32 )  swap reg! modr/m! $DE op, ;
: flopar3 ( mem16|32 / opc )
  create c,
  does>  !fpu 1 !args c@ swap !opsize dup addr16? if flopar3m16 else dup addr32? if flopar3m32 else
         2drop INVALID_OPERAND_TYPE$ error cleanup  then then ;
: flopar4 ( mem16|32 / opc )
  create c,
  does>  !fpu 1 !args c@ swap !opsize dup addr16? if flopar3m32 else dup addr32? if flopar3m16 else
         2drop INVALID_OPERAND_TYPE$ error cleanup  then then ;
: fbcdop ( mem80 / opc )
  create c,
  does>  !fpu 1 !args c@ reg! !opsize !addr80 modr/m! $DF op, ;
: fcomop ( STx / opc )
  create c,
  does>  !fpu 1 !args c@ $10 /mod $DB + -rot reg! !fpureg modr/m! op, ;
: fildstop16 ( mem16 @opc )  reg! modr/m! $DF op, ;
: fildstop32 ( mem32 @opc )  reg! modr/m! $DB op, ;
: fildstop64 ( mem64 @opc )  reg! modr/m! $DF op, ;
: fisttpop64 ( mem64 @opc )  reg! modr/m! $DD op, ;
: fildstop ( mem16|32|64 / opc2 opc1 )
  create c, c,
  does>  !fpu 1 !args over addr16? if  c@ fildstop16  else  over addr32? if  c@ fildstop32  else
         over addr64? if  1+ c@ fildstop64  else  2drop INVALID_OPERAND_TYPE$ error cleanup
         then then then ;
: fistop ( mem16|32 / opc )
  create c,
  does>  !fpu 1 !args over addr16? if  c@ fildstop16  else  over addr32? if  c@ fildstop32  else
         2drop INVALID_OPERAND_TYPE$ error cleanup  then then ;
: fxenvop ( mem / opc )
  create c,
  does>  !fpu 1 !args esc+ c@ reg! !address modr/m! $AE op, ;
: fxenvop64 ( mem / opc )
  create c,
  does>  !fpu 1 !args esc+ c@ reg! fpuop- REX.W+ !address modr/m! $AE op, ;
: imul2 ( r/m reg )  !stdreg16+ !opsize= reg! stdmodr/m! esc+ $AF op, ;
: imul3opc ( imm r/m -- opc )  over .size #BYTE = if  2drop $6B  else  !opsize= 2drop $69  then ;
: imul3 ( imm r/m reg )  !stdreg16+ !opsize= reg! dup stdmodr/m! imul3opc op, ;
: inoutop ( imm8|DX accu / opc )
  create  c,
  does>   2 !args  c@ dup if  >r swap r>  then  swap !accu op>opsize! !no64 .size #BYTE > - swap
          dup DX = if  drop 8+  else  !imm8 drop  then  $E4 + op, ;
: oplp ( r/m16 reg )
  create  c,
  does>   2 !args  c@ -rot esc+ !stdreg16+ op>opsize! stdreg! !r/m16 stdmodr/m! op, ;
: ldop1 ( mem reg / opc )
  create  c,
  does>   2 !args c@ -rot !legacy !stdreg16+ op>opsize! reg! !address stdmodr/m! op, ;
: ldop2 ( mem reg / opc )
  create  c,
  does>   2 !args c@ -rot esc+ !stdreg16+ op>opsize! reg! !address stdmodr/m! op, ;
: ldop3 ( mem reg / opc )
  create  c,
  does>   2 !args c@ -rot !stdreg16+ op>opsize! reg! !address stdmodr/m! op, ;
: fenceop ( / opc )
  create  c,
  does>   0 !args c@ reg! esc+ $AE op, ;
: memop1 ( mem / opc reg )
  create  c, c,
  does>   1 !args @c++ reg! swap !address stdmodr/m! esc+ c@ op, ;
: memop2 ( r/m16 / opc reg )
  create  c, c,
  does>   1 !args @c++ reg! swap !r/m16 stdmodr/m! esc+ c@ op, ;
: memop3 ( mem / opc reg )
  create  c, c,
  does>   1 !args @c++ reg! swap !address op>opsize! stdmodr/m! esc+ c@ op, ;
: movr/m ( r/m reg opc )  -rot reg! stdmodr/m! op, ;
: movr/m+ ( r/m16+ reg opc )  -rot reg! !stdr/m16+ op>opsize! stdmodr/m! op, ;
: movr/m++ ( r/m16+ reg opc )  -rot reg! !r/m32+ op>opsize! modr/m! op, ;
: mov>seg ( src segreg )  dup .code 1 = if  INVALID_OPERAND_COMBINATION$ error  then  $8E movr/m+ ;
: mov<seg ( segreg tgt )  swap $8C movr/m+ ;
: mov>ctrl ( src ctlreg )  esc+ $22 movr/m++ ;
: mov<ctrl ( ctlreg tgt )  swap esc+ $20 movr/m++ ;
: mov>dbug ( src dbgreg )  esc+ $23 movr/m++ ;
: mov<dbug ( dbgreg tgt )  swap esc+ $21 movr/m++ ;
: movreg<imm ( imm reg )
  !opsize=  dup .size dup immsize! wide+ #BYTE > 8 and $B0 + swap .code + nip op, ;
: movmem<imm ( imm mem )
  !address !opsize=  0 reg! dup .size dup immsize! #WORD < $C7 + swap stdmodr/m! nip op, ;
: movmem>accu ( mem accu )  !opsize= nip $A1 swap op>opsize! .size #BYTE = + daop, ;
: movmem<accu ( accu mem )  !opsize= drop $A3 swap op>opsize! .size #BYTE = + daop, ;
: mov>reg ( r/m reg )  !opsize= $8B over .size #BYTE = + movr/m ;
: mov<reg ( reg r/m )  !opsize= swap $89 over .size #BYTE = + movr/m ;
: movop ( src tgt )
  dup segreg? if  mov>seg  else  over segreg? if  mov<seg  else  dup ctrlreg? if  mov>ctrl  else
  over ctrlreg? if  mov<ctrl  else  dup dbugreg? if  mov>dbug  else
  over dbugreg? if  mov<dbug  else  over accu? over diraddr? and if  movmem<accu  else
  over diraddr? over accu? and if  movmem>accu  else  over immediate? if  dup stdreg? if
    movreg<imm  else  movmem<imm  then  else  dup stdreg? if  mov>reg  else
  over stdreg? if  mov<reg  else  2drop INVALID_OPERAND_COMBINATION$ error cleanup
  then then then then then then then then then then then ;
: movd>mmx ( r/m32 mmx )  reg! !r/m32 op>opsize! stdmodr/m! $6E op, ;
: movd>xmm ( r/m32 xmm )  66+ movd>mmx ;
: movd<mmx ( mmx r/m32 )  swap reg! !r/m32 op>opsize! stdmodr/m! $7E op, ;
: movd<xmm ( xmm r/m32 )  66+ movd<mmx ;
: movq>mmx ( r/m64 mmx )  over mmxreg? if  mmxop+ reg! modr/m! $6F else
  reg! !r/m64 op>opsize! stdmodr/m! $6E then  op, ;
: movq>xmm ( r/m64 xmm )  over xmmreg? if  reg! modr/m! F3+ $7E op,  else  66+ movq>mmx  then ;
: movq<mmx ( mmx r/m64 )  dup mmxreg? if  mmxop+ modr/m! reg! $7F  else
  !r/m64 op>opsize! stdmodr/m! reg! $7E then  op, ;
: movq<xmm ( xmm r/m64 )  66+ dup xmmreg? if  modr/m! reg! $D6 op,  else  movq<mmx  then ;
: movxbyte ( opc r/m8 reg16+ )  !reg16+ op>opsize! stdreg! stdmodr/m!  op, ;
: movxword ( opc r/m16 reg32+ )  !reg32+ op>opsize! stdreg! !r/m16 stdmodr/m!  1+ op, ;
: movxop ( r/m8|16 reg / opc )
  create  c,
  does>   esc+ c@ -rot over .size #BYTE = if  movxbyte  else  movxword  then ;
: pkmmxop1 ( mxr/m64 mmxreg @opc )  swap reg!  swap mxr/m64! mmxop+ c@ op, ;
: pkxmmop1 ( xmr/m64 xmmreg @opc )  swap reg!  swap xmr/m128! 66+ c@ op, ;
: packop1 ( mxr/m64 mmxreg | xmr/m128 xmmreg / opc )
  create  c,
  does>   2 !args  esc+  over mmxreg? if  pkmmxop1  else  over xmmreg? if  pkxmmop1  else
          2drop drop INVALID_OPERAND_COMBINATION$ error  cleanup  then  then ;
: pkmmxop2 ( mxr/m64 mmxreg @opc )  swap reg!  swap mxr/m64! mmxop+ c@++ c@ 2op, ;
: pkxmmop2 ( xmr/m64 xmmreg @opc )  swap reg!  swap xmr/m128! 66+ c@++ c@ 2op, ;
: packop2 ( mxr/m64 mmxreg | xmr/m128 xmmreg / opc1 opc2 )
  create  c, c,
  does>   2 !args  esc+  over mmxreg? if  pkmmxop2  else  over xmmreg? if  pkxmmop2  else
          2drop drop INVALID_OPERAND_COMBINATION$ error  cleanup  then  then ;
: pkmmxop3 ( imm8 mxr/m64 mmxreg @opc )  swap reg! swap mxr/m64! mmxop+ swap !imm8 drop c@++ c@ 2op, ;
: pkxmmop3 ( imm8 xmr/m64 xmmreg @opc )  swap reg! swap xmr/m128! 66+ swap !imm8 drop c@++ c@ 2op, ;
: packop3 ( imm8 mxr/m64 mmxreg | imm8 xmr/m128 xmmreg / opc1 opc2 )
  create  c, c,
  does>   3 !args  esc+  over mmxreg? if  pkmmxop3  else  over xmmreg? if  pkxmmop3  else
          2drop drop INVALID_OPERAND_COMBINATION$ error  cleanup  then  then ;
: pextrwr/m ( imm8 xmmreg r/m16 )  !stdr/m16+ modr/m! xmreg! !imm8 drop 66+ $C5 op, ;
: pextrwmmx ( imm8 mmxreg reg ) !stdreg16+ reg! !mmxreg mxr/m64! mmxop+ !imm8 drop $C5 op, ;
: pextrwxmm ( imm8 xmmreg reg ) !stdreg16+ reg! !xmmreg xmr/m128! !imm8 drop 66+ $15 $3A 2op, ;
: pinsrwmmx ( imm8 r32/m16 mmx )  !mmxreg reg!  modr32/m16! !imm8 drop $C4 op, ;
: pinsrwxmm ( imm8 r32/m16 xmm )  !xmmreg reg!  modr32/m16! !imm8 drop 66+ $C4 op, ;
: pmovmbmmx ( mxreg r32|64 )  swap mxreg! !stdreg32+ op>opsize! modr/m! $D7 op, ;
: pmovmbxmm ( xmreg r32|64 )  swap xmreg! !stdreg32+ op>opsize! modr/m! 66+ $D7 op, ;
: pushpopreg ( reg opc )  8* $58 r- swap op>opsize! T.ADDRSIZE !=opsize  noREX+ .code + op, ;
: pushpopseg ( segreg opc )  swap .code 8* 7 + over - swap unless  dup $0F = if
    CANNOT_POP_CS$ error  then then  dup $20 > if  esc+ $7A +  then op, ;
: pushpopr/m ( r/m opc )
  dup 6 * reg! $70 * $8F + swap op>opsize! T.ADDRSIZE !=opsize noREX+ !stdr/m16+ modr/m! op, ;
: pushpopimm ( imm opc )  unless  CANNOT_POP_CONSTANT$ error  then
  drop $68 immsize@ dup opsize! #BYTE = 2 and + op, ;
: pushpop ( ... / opc )
  create  c,
  does>   c@ 1 !args over stdreg? if  pushpopreg  else  over segreg? if  pushpopseg  else
          over address? if  pushpopr/m  else  over immediate? if  pushpopimm  else
          2drop INVALID_OPERAND_TYPE$ error cleanup  then then then then ;
: prefetchop ( mem8 / opc )
  create  c,
  does>   1 !args esc+ c@ reg! !address modr/m! $18 op, ;
: xshiftop  ( imm8 xmm1 / op1 op2 )
  create  c, c,
  does>   2 !args esc+ @c++ reg! -rot !xmreg xmr/m128! !imm8 drop 66+ c@ op, ;
: pshmmxop1 ( imm mmxreg @opc )
  swap mxr/m64! mmxop+ c@ dup $38 and 3 >> reg! 7 and $70 + swap !imm8 drop op, ;
: pshxmmop1 ( imm xmmreg @opc )
  swap xmr/m128! 66+ c@ dup $38 and 3 >> reg! 7 and $70 + swap !imm8 drop op, ;
: pshopimm  ( imm mmxreg|xmmreg @opc )  over mmxreg? if  pshmmxop1 else
  over xmmreg? if  pshxmmop1 else drop 2drop INVALID_OPERAND_COMBINATION$ error cleanup then then ;
: pshiftop1  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg / opc )
  create  c,
  does>   2 !args esc+ 2 pick immediate? if  pshopimm  else
          over mmxreg? if  pkmmxop1  else  over xmmreg? if  pkxmmop1  else
            2drop drop INVALID_OPERAND_COMBINATION$ error  cleanup  then then then ;
: shrotop, ( r/m ) over .size #BYTE > - swap op>opsize! stdmodr/m! op, ;
: shrotop ( CL|imm8 r/m / opc )
  create  c,
  does>   2 !args  c@ reg! swap dup immediate? if
            imm@ 1 = if  drop imm- $D0 shrotop,  else  drop $C0 shrotop,  then  else
            $1D10001 = if $D2 shrotop, else
            drop INVALID_OPERAND_COMBINATION$ error cleanup then  then ;
: shrotop2 ( CL|imm8 reg r/m / opc )
  create  c,
  does>   3 !args esc+ c@ -rot !opsize= op>opsize! stdmodr/m! !stdreg16+ stdreg! over $1D10001 = if
            nip 1+ else swap immediate? unless
              INVALID_OPERAND_COMBINATION$ error cleanup then  then  op, ;
: ret0 ( )  0 !args  far? 8 and $C3 + op, ;
: retn ( imm16 )  1 !args  !imm16 drop  $C2 far? 8 and + op, ;
: testop-immacc  ( imm acc -- )  2 !args !opsize= size>immsize .size #WORD < $A9 + nip op, ;
: testop-immr/m  ( imm r/m -- )
  2 !args !opsize size>immsize  $F7 over .size #BYTE = + swap  0 r/mreg! nip op, ;
: testop-imm ( imm r/m -- )  2 !args dup accu? if  testop-immacc  else  testop-immr/m  then ;
: testop-reg ( reg r/m -- )  2 !args !opsize=  stdmodr/m! dup stdreg! >opsize $84 + nip op, ;
: testop-mem ( mem reg -- )  2 !args !opsize=  over stdmodr/m! stdreg! >opsize $84 + nip op, ;
: testop ( ... )
  2 !args 2dup imm>r/m? if testop-imm else 2dup reg>r/m? if testop-reg else
    2drop INVALID_OPERAND_COMBINATION$ error cleanup then then ;
: xchgop ( reg r/m | r/m reg )  2 !args !opsize=  dup address? if swap then  over accu? if swap then
  op>opsize!  over register? over accu? and over .size #BYTE > and if  drop .code $90 +  else
    $87 over .size #BYTE = + -rot stdreg! stdmodr/m!  then  op, ;
: endblock ( a -- )  1+ dup T.ADDRSIZE + toff r- T.ADDRWIDTH rot toff - there + #! ;
: back ( a -- a' )  1+ T.ADDRSIZE + ;
: skip ( n -- a )  T.ADDRSIZE 1+ * 2+ toff + ;

--- Operation Definitions ---

Forcembler definitions
( cr ." Order @4: " order )
hex
  2E segprefix CS:
  3E segprefix DS:
  26 segprefix ES:
  64 segprefix FS:
  65 segprefix GS:
  36 segprefix SS:
: UNLIKELY ( branch hint for ?JMP )  2E tc, ;
: LIKELY ( branch hint ?JMP )  3E tc, ;
  37 op00L AAA                        ( )
  D5 op01L AAD                        ( [imm] )
  D4 op01L AAM                        ( [imm] )
  3F op00L AAS                        ( )
  02 logarop ADC                      ( ... )
  00 logarop ADD                      ( ... )
  58 66 xmop01a ADDPD                 ( xmr/m128 xmreg )
  58 00 xmop01a ADDPS                 ( xmr/m128 xmreg )
  58 F2 xmop01b ADDSD                 ( xmr/m64 xmreg )
  58 F3 xmop01c ADDSS                 ( xmr/m32 xmreg )
  D0 66 xmop01a ADDSUBPD              ( xmr/m128 xmreg )
  D0 F2 xmop01a ADDSUBPS              ( xmr/m128 xmreg )
  38 DE 66 xmop02a AESDEC             ( xmr/m128 xmreg )
  38 DF 66 xmop02a AESDECLAST         ( xmr/m128 xmreg )
  38 DC 66 xmop02a AESENC             ( xmr/m128 xmreg )
  38 DD 66 xmop02a AESENCLAST         ( xmr/m128 xmreg )
  38 DB 66 xmop02a AESIMC             ( xmr/m128 xmreg )
  3A DF 66 xmop03a AESKEYGENASSIST    ( imm8 xmr/m128 xmreg )
  04 logarop AND                      ( ... )
  54 66 xmop01a ANDPD                 ( xmr/m128 xmreg )
  54 00 xmop01a ANDPS                 ( xmr/m128 xmreg )
  55 66 xmop01a ANDNPD                ( xmr/m128 xmreg )
  55 00 xmop01a ANDNPS                ( xmr/m128 xmreg )
: ARPL ( reg16 r/m16 )  !opsize= !wordop !r/m modr/m! !wordop !register reg! 63 !legacy op, ;
  3A 0D 66 xmop03a BLENDPD            ( imm8 xmr/m128 xmreg )
  3A 0C 66 xmop03a BLENDPS            ( imm8 xmr/m128 xmreg )
  38 15 66 xmop02a BLENDVPD           ( xmr/m128 xmreg )
  38 14 66 xmop02a BLENDVPS           ( xmr/m128 xmreg )
: BOUND ( mem16|32 reg16|32 )  !legacy !opsize= ![d]wordop  !register reg! !address modr/m! 62 op, ;
  BC bitscop BSF                      ( r/m reg )
  BD bitscop BSR                      ( r/m reg )
: BSWAP ( reg32|64 )  !>486 !d|qwordop op>opsize! !register modr/m!  1 reg!  0F op, ;
  4 bitop BT                          ( imm|reg r/m )
  7 bitop BTC                         ( imm|reg r/m )
  6 bitop BTR                         ( imm|reg r/m )
  5 bitop BTS                         ( imm|reg r/m )
  0 jmpcall CALL                      ( addr )
  #WORD cvop01 CBW                    ( )
  #DWORD cvop01 CWDE                  ( )
  #QWORD cvop01 CDQE                  ( )
  F8 op00 CLC                         ( )
  FC op00 CLD                         ( )
: CLFLUSH ( mem8 )  !>586 !address esc+  7 reg! modr/m!  AE op, ;
  FA op00 CLI                         ( )
  06 op0F CLTS                        ( )
  F5 op00 CMC                         ( )
: ?MOV ( r/m reg cond ) 3 !args !>586 esc+ !opsize= -rot op>opsize! stdreg! modr/m! .code 40 + op, ;
  07 logarop CMP                      ( ... )
  C2 66 xmop01a CMPPD                 ( xmr/m128 xmreg )
  C2 00 xmop01a CMPPS                 ( xmr/m128 xmreg )
  C2 F2 xmop01b CMPSD                 ( xmr/m64 xmreg )
  C2 F3 xmop01c CMPSS                 ( xmr/m32 xmreg )
  A6 strop CMPS                       ( size )
: CMPXCHG ( reg r/m )  2 !args  esc+ !opsize=
  dup .size #BYTE = B1 + -rot swap op>opsize! stdreg! modr/m! op, ;
: CMPXCHG8B ( mem64 ) esc+ !>586 !addr64 1 reg! modr/m! C7 op, ;
  2F 66 xmop01b COMISD                ( xmr/m64 xmreg )
  2F 00 xmop01c COMISS                ( xmr/m32 xmreg )
  A2 op0F CPUID                       ( )
: CRC32 ( r/m reg )  over .size over .size > if  INVALID_OPERAND_COMBINATION$ error  then
  2 !args !reg32+ op>opsize! stdreg! >opsize $F0 + swap  op>opsize! modr/m! $38 esc+ F2+ 2op, ;
  E6 F3 xmop01b CVTDQ2PD              ( xmr/m64 xmreg )
  5B 00 xmop01a CVTDQ2PS              ( xmr/m128 xmreg )
  E6 F2 xmop01a CVTPD2DQ              ( xmr/m128 xmreg )
  2D 66 xmop01a CVTPD2PI              ( xmr/m128 xmreg )
  5A 66 xmop01a CVTPD2PS              ( xmr/m128 xmreg )
  2A 66 xmop01b CVTPI2PD              ( xmr/m64 xmreg )
  2A 00 xmop01b CVTPI2PS              ( xmr/m64 xmreg )
  5B 66 xmop01a CVTPS2DQ              ( xmr/m128 xmreg )
  5A 00 xmop01b CVTPS2PD              ( xmr/m64 xmreg )
  2D 00 xmop01b CVTPS2PI              ( xmr/m64 xmreg )
  2D F2 xmop04a CVTSD2SI              ( xmr/m64 reg32|64 )
  5A F2 xmop01b CVTSD2SS              ( xmr/m64 xmreg )
  2A F2 xmop04c CVTSI2SD              ( r/m32|64 xmreg )
  2A F3 xmop04c CVTSI2SS              ( r/m32|64 xmreg )
  5A F3 xmop01c CVTSS2SD              ( xmr/m32 xmreg )
  2D F3 xmop04b CVTSS2SI              ( xmr/m32 reg32|64 )
  E6 66 xmop01a CVTTPD2DQ             ( xmr/m128 xmreg )
  2C 66 xmop01a CVTTPD2PI             ( xmr/m128 xmreg )
  5B F3 xmop01a CVTTPS2DQ             ( xmr/m128 xmreg )
  2C 00 xmop01b CVTTPS2PI             ( xmr/m64 xmreg )
  2C F2 xmop04a CVTTSD2SI             ( xmr/m64 reg32|64 )
  2C F3 xmop04b CVTTSS2SI             ( xmr/m32 reg32|64 )
  #WORD cvop02 CWD                    ( )
  #DWORD cvop02 CDQ                   ( )
  #QWORD cvop02 CQO                   ( )
  27 op00L DAA                        ( )
  2F op00L DAS                        ( )
  1 incdecop DEC                      ( r/m )
  6 arithop DIV                       ( r/m )
  5E 66 xmop01a DIVPD                 ( xmr/m128 xmreg )
  5E 00 xmop01a DIVPS                 ( xmr/m128 xmreg )
  5E F2 xmop01b DIVSD                 ( xmr/m64 xmreg )
  5E F3 xmop01c DIVSS                 ( xmr/m32 xmreg )
  3A 41 66 xmop03a DPPD               ( imm8 xmr/m128 xmreg )
  3A 40 66 xmop03a DPPS               ( imm8 xmr/m128 xmreg )
  77 op0F EMMS                        ( )
: ENTER ( imm8 imm16 )
  1 !args !imm16 drop  adepth 1 u< if  MISSING_NESTING_LEVEL$ error cleanup exit  then
  validate prefices, $C8 tc, #WORD opsize! operands,
  dup 0 32 within unless  NESTLEVEL_OPERAND_EXPECTED$ error  then  tc,  cleanup ;
  3A 17 66 xmop03d EXTRACTPS          ( imm8 xmreg r/m32 )
  F0 flop01 F2XM1                     ( ) alias F2^X-1
  E1 flop01 FABS                      ( )
  0 flopar1 FADD                      ( STn/mem32|64 )
  0 flopar0 RFADD                     ( STn )
  0 flopar2 FADDP                     ( [STn] )
  0 flopar3 FIADD                     ( mem16|32 )
  4 fbcdop FBLD                       ( mem80 )
  6 fbcdop FBSTP                      ( mem80 )
  E0 flop01 FCHS                      ( )
: FWAIT ( )  !fpu $9B tc, ; alias WAIT
: FNCLEX ( )  0 !args  !fpu $DB tc, $E2 op, ;
: FCLEX ( )  FWAIT FNCLEX ;
: ?FMOV ( STn cond )
  !fpu 2 !args !condition .code cond>fcond 4 /mod $DA + -rot reg! !fpureg modr/m! op, ;
  06 fcomop FCOMI                     ( STn )
  46 fcomop FCOMIP                    ( STn )
  05 fcomop FUCOMI                    ( STn )
  45 fcomop FUCOMIP                   ( STn )
  FF flop01 FCOS                      ( )
  F6 flop01 FDECSTP                   ( )
  6 flopar1 FDIV                      ( STn/mem32|64 )
  6 flopar0 RFDIV                     ( STn )
  6 flopar2 FDIVP                     ( [STn] )
  6 flopar3 FIDIV                     ( mem16|32 )
  7 flopar1 FDIVR                     ( STn/mem32|64 )
  7 flopar0 RFDIVR                    ( STn )
  7 flopar2 FDIVRP                    ( [STn] )
  7 flopar3 FIDIVR                    ( mem16|32 )
: FFREE ( STn )  !fpu  1 !args  !fpureg  0 reg! modr/m! $DD op, ;
  2 flopar4 FICOM                     ( mem16|32 )
  3 flopar4 FICOMP                    ( mem16|32 )
  5 0 fildstop FILD                   ( mem16|32|64 )
  F7 flop01 FINCSTP                   ( )
: FNINIT ( )  0 !args  !fpu $DB tc, $E3 op, ;
: FINIT ( )  FWAIT FNINIT ;
  2 fistop FIST                       ( mem16|32 )
  7 3 fildstop FISTP                  ( mem16|32|64 )
: FISTTP ( mem16|32|64 )  !fpu 1 !args dup addr16? if  1 fildstop16  else  dup addr32? if
  1 fildstop32  else dup addr64? if  1 fisttpop64  else
  drop INVALID_OPERAND_TYPE$ error cleanup  then then then ;
: FLD ( STn/mem32|64|80 )  !fpu 1 !args dup addr32? if  $D9 0  else  dup addr64? if
  $DD 0  else  dup addr80? if  $DB 5  else  dup fpureg? if  $D9 0  else
  INVALID_OPERAND_TYPE$ error 0 0  then then then then  reg! swap modr/m! op, ;
  E8 flop01 FLD1                      ( )
  E9 flop01 FLDL2T                    ( )
  EA flop01 FLDL2E                    ( )
  EB flop01 FLDPI                     ( )
  EC flop01 FLDLG2                    ( )
  ED flop01 FLDLN2                    ( )
  EE flop01 FLDZ                      ( ) alias FLD0
  5 flop02 FLDCW                      ( mem )
  4 flop02 FLDENV                     ( mem )
  1 flopar1 FMUL                      ( STn/mem32|64 )
  1 flopar0 RFMUL                     ( STn )
  1 flopar2 FMULP                     ( [STn] )
  1 flopar3 FIMUL                     ( mem16|32 )
  D0 flop01 FNOP                      ( )
  F3 flop01 FPATAN                    ( )
  F8 flop01 FPREM                     ( )
  F5 flop01 FPREM1                    ( )
  F2 flop01 FPTAN                     ( )
  FC flop01 FRNDINT                   ( )
  4 flop03 FRSTOR                     ( mem )
  6 flop03 FNSAVE                     ( mem )
: FSAVE ( mem )  FWAIT FNSAVE ;
  FD flop01 FSCALE                    ( )
  FE flop01 FSIN                      ( )
  FB flop01 FSINCOS                   ( )
  FA flop01 FSQRT                     ( )
: FST ( STn/mem32|64)  !fpu 1 !args dup addr32? if  $D9 2  else
  dup addr64? if  $DD 2  else  dup fpureg? if  $DD 2  else
  INVALID_OPERAND_TYPE$ error 0 0  then then then  reg! swap modr/m! op, ;
: FSTP ( STn/mem32|64|80 )  !fpu 1 !args dup addr32? if  $D9 3  else  dup addr64? if
  $DD 3  else  dup addr80? if  $DB 7  else  dup fpureg? if  $DD 3  else
  INVALID_OPERAND_TYPE$ error 0 0  then then then then  reg! swap modr/m! op, ;
  7 flop02 FNSTCW                     ( mem )
: FSTCW ( mem )  FWAIT FNSTCW ;
  6 flop02 FNSTENV                    ( mem )
: FSTENV ( mem )  FWAIT FNSTENV ;
: FNSTSW ( mem | AX )
  !fpu 1 !args dup AX = if  $DF 4  else  !address $DD 7  then  reg! swap modr/m! op, ;
: FSTSW ( mem | AX )  FWAIT FNSTSW ;
  4 flopar1 FSUB                      ( STn/mem32|64 )
  4 flopar0 RFSUB                     ( STn )
  4 flopar2 FSUBP                     ( [STn] )
  4 flopar3 FISUB                     ( mem16|32 )
  5 flopar1 FSUBR                     ( STn/mem32|64 )
  5 flopar0 RFSUBR                    ( STn )
  5 flopar2 FSUBRP                    ( [STn] )
  5 flopar3 FISUBR                    ( mem16|32 )
  E4 flop01 FTST                      ( )
: FUCOM ( [STn] )  !fpu  op#@ 0= if  ST(1)  then  1 !args  4 reg! !fpureg modr/m!  $DD op, ;
: FUCOMP ( [STn] )  !fpu  op#@ 0= if  ST(1)  then  1 !args  5 reg! !fpureg modr/m!  $DD op, ;
: FUCOMPP ( )  !fpu  ST(1)  1 !args  5 reg! !fpureg modr/m!  $DA op, ;
  E5 flop01 FXAM                      ( )
: FXCH ( [STn] )  !fpu op#@ 0= if  ST(1)  then  1 !args  1 reg! !fpureg modr/m!  $D9 op, ;
  1 fxenvop FXRSTOR                   ( mem )
  0 fxenvop FXSAVE                    ( mem )
  1 fxenvop64 FXRSTOR64               ( mem )
  0 fxenvop64 FXSAVE64                ( mem )
  F4 flop01 FXTRACT                   ( )
  F1 flop01 FYL2X                     ( )
  F9 flop01 FYL2XP1                   ( )
  7C 66 xmop01a HADDPD                ( xmr/m128 xmreg )
  7C F2 xmop01a HADDPS                ( xmr/m128 xmreg )
  F4 op00 HLT                         ( )
  7D 66 xmop01a HSUBPD                ( xmr/m128 xmreg )
  7D F2 xmop01a HSUBPS                ( xmr/m128 xmreg )
  7 arithop IDIV                      ( r/m )
: IMUL ( [imm] r/m reg | r/m )  op#@ case
  1 of  5 (arithop)  endof
  2 of  imul2  endof
  3 of  imul3  endof
  adepth 0 ?do drop loop  INVALID_OPERAND_COMBINATION$ error cleanup exit endcase ;
  0 inoutop IN                        ( imm8|DX accu )
  0 incdecop INC                      ( r/m )
  6C strop INS                        ( size )
  3A 21 66 xmop03b INSERTPS           ( imm8 xmr/m128 xmreg )
: INT ( imm8 )  1 !args  !imm8 drop  imm@ 3 = if  CC tc,  else  CD tc, imm@ tc, then cleanup ;
  CE op00 INTO
  08 op0F INVD                        ( )
: INVLPG ( mem )  1 !args !address esc+ 7 reg! modr/m! 01 op, ;
: IRET  ( )  T.ARCH opsize!  CF op, ;
  1 jmpcall JMP
: ?JMP ( target cond )  2 !args !condition .code 70 + #BYTE toff 2+ reladdr  nip op, ;
  9F op00 LAHF                        ( )
  02 oplp LAR                         ( r/m reg )
  F0 F2 xmop01d LDDQU                 ( mem128 xmreg )
: LDMXCSR ( mem32 )  1 !args !addr32 2 reg! modr/m! esc+ AE op, ;
  C5 ldop1 LDS                        ( mem reg )
  C4 ldop1 LES                        ( mem reg )
  B4 ldop2 LFS                        ( mem reg )
  B5 ldop2 LGS                        ( mem reg )
  B2 ldop2 LSS                        ( mem reg )
  8D ldop3 LEA                        ( mem reg )
  C9 op00 LEAVE                       ( )
  5 fenceop LFENCE                    ( )
  01 02 memop1 LGDT                   ( mem )
  01 03 memop1 LIDT                   ( mem )
  00 02 memop2 LLDT                   ( r/m16 )
  01 06 memop2 LMSW                   ( r/m16 )
  F0 op00 LOCK                        ( )
  AC strop LODS                       ( size )
: LOOP ( target )  1 !args !immediate drop  #BYTE toff 2+ reladdr E2 op, ;
: ?LOOP ( target cond )  2 !args ![n]eq E0 + swap !immediate drop #BYTE toff 2+ reladdr op, ;
  03 oplp LSL                         ( rx/m16 reg )
  00 03 memop2 LTR                    ( r/m16 )
  F7 66 xmop01e MASKMOVDQU            ( xmreg1 xmreg2 )
  F7 00 mxop01e MASKMOVQ              ( mxreg1 mxreg2 )
  5F 66 xmop01a MAXPD                 ( xmr/m128 xmreg )
  5F 00 xmop01a MAXPS                 ( xmr/m128 xmreg )
  5F F2 xmop01b MAXSD                 ( xmr/m64 xmreg )
  5F F3 xmop01c MAXSS                 ( xmr/m32 xmreg )
  6 fenceop MFENCE                    ( )
  5D 66 xmop01a MINPD                 ( xmr/m128 xmreg )
  5D 00 xmop01a MINPS                 ( xmr/m128 xmreg )
  5D F2 xmop01b MINSD                 ( xmr/m64 xmreg )
  5D F3 xmop01c MINSS                 ( xmr/m32 xmreg )
: MONITOR ( )  0 !args  1 reg! esc+ 3 mod! 01 op, ;
: MOV ( src tgt )  2 !args  movop ;
  28 66 xmop05a MOVAPD                ( xmr/m128 xmreg | xmreg xmr/m128 )
  28 00 xmop05a MOVAPS                ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVBE ( mem reg | reg mem )  2 !args !opsize= esc+ $F0 over address? if  1+ swap  then -rot
  !stdreg16+ stdreg! !address stdmodr/m! $38 2op, ;
: MOVD ( mmx|xmm r/m32 | r/m32 mmx|xmm )
  2 !args esc+ dup mmxreg? if  movd>mmx  else  dup xmmreg? if  movd>xmm  else  over mmxreg? if
  movd<mmx  else  over xmmreg? if  movd<xmm  else
  2 drop INVALID_OPERAND_COMBINATION$ error cleanup  then then then then ;
  12 F2 xmop01b MOVDDUP               ( xmr/m64 xmreg )
  6F 66 xmop05b MOVDQA                ( xmr/m128 xmreg | xmreg xmr/m128 )
  6F F3 xmop05b MOVDQU                ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVDQ2Q ( xmreg mxreg )  2 !args  !mmxreg reg! !xmmreg modr/m! F2+ esc+ D6 op, ;
  12 00 xmop01e MOVHLPS               ( xmreg1 xmreg2 )
  16 66 xmop05c MOVHPD                ( mem64 xmreg | xmreg mem64 )
  16 00 xmop05c MOVHPS                ( mem64 xmreg | xmreg mem64 )
  16 00 xmop01e MOVLHPS               ( xmreg1 xmreg2 )
  12 66 xmop05c MOVLPD                ( mem64 xmreg | xmreg mem64 )
  12 00 xmop05c MOVLPS                ( mem64 xmreg | xmreg mem64 )
  50 66 xmop04d MOVMSKPD              ( xmreg reg )
  50 00 xmop04d MOVMSKPS              ( xmreg reg )
  38 2A 66 xmop02e MOVNTDQA           ( mem128 xmreg )
  E7 66 xmop01g MOVNTDQ               ( xmreg mem128 )
: MOVNTI ( reg mem )  2 !args swap !opsize= op>opsize! !reg32+ reg! modr/m! esc+ C3 op, ;
  2B 66 xmop01g MOVNTPD               ( xmreg mem128 )
  2B 00 xmop01g MOVNTPS               ( xmreg mem128 )
  E7 00 mxop01g MOVNTQ                ( mxreg mem64 )
: MOVQ ( mmx|xmm r/m64 | r/m64 mmx|xmm )
  2 !args esc+ dup mmxreg? if  movq>mmx  else  dup xmmreg? if  movq>xmm  else  over mmxreg? if
  movq<mmx  else  over xmmreg? if  movq<xmm  else
  2 drop INVALID_OPERAND_COMBINATION$ error cleanup  then then then then ;
: MOVQ2DQ ( mxreg xmreg )  2 !args  !xmmreg reg! !mmxreg modr/m! F3+ esc+ D6 op, ;
  A4 strop MOVS                       ( size )
  10 F2 xmop05d MOVSD                 ( xmr/m64 xmreg | xmreg xmr/m64 )
  16 F3 xmop01a MOVSHDUP              ( xmr/m128 xmreg )
  12 F3 xmop01a MOVSLDUP              ( xmr/m128 xmreg )
  10 F3 xmop05e MOVSS                 ( xmr/m32 xmreg | xmreg xmr/m32 )
  BE movxop MOVSX                     ( r/m reg )
: MOVSXD ( r/m32 reg64 )  2 !args op>opsize! !reg64 stdreg!  !r/m32 stdmodr/m!  63 op, ;
  10 66 xmop05a MOVUPD                ( xmr/m128 xmreg | xmreg xmr/m128 )
  10 00 xmop05a MOVUPS                ( xmr/m128 xmreg | xmreg xmr/m128 )
  B6 movxop MOVZX                     ( r/m reg )
  3A 42 66 xmop03a MPSADBW            ( imm8 xmr/m128 xmreg )
  4 arithop MUL                       ( r/m )
  59 66 xmop01a MULPD                 ( xmr/m128 xmreg )
  59 00 xmop01a MULPS                 ( xmr/m128 xmreg )
  59 F2 xmop01b MULSD                 ( xmr/m64 xmreg )
  59 F3 xmop01c MULSS                 ( xmr/m32 xmreg )
: MWAIT ( )  0 !args  1 reg! esc+ 3 mod! 1 r/m! 01 op, ;
  3 arithop NEG                       ( r/m )
: NOP ( [n] )  op#@ unless  1 #  then  1 !args  drop
  imm@ 1 < if  INVALID_NOP_SIZE$ error cleanup exit  then
  T.ARCH i16 = if  imm@ 1- if  NOP#_NOT_SUPPORTED$ error cleanup exit  then  90 tc,  else
  imm@ case
    1 of  90 tc,  endof
    2 of  66 tc, 90 tc,  endof
    3 of  0F tc, 1F tc, 00 tc,  endof
    4 of  0F tc, 1F tc, 40 tc, 00 tc,  endof
    5 of  0F tc, 1F tc, 44 tc, 00 tc, 00 tc,  endof
    6 of  66 tc, 0F tc, 1F tc, 44 tc, 00 tc, 00 tc,  endof
    7 of  0F tc, 1F tc, 80 tc, 00 tc, 00 tc, 00 tc, 00 tc,  endof
    8 of  0F tc, 1F tc, 84 tc, 00 tc, 00 tc, 00 tc, 00 tc, 00 tc,  endof
    9 of  66 tc, 0F tc, 1F tc, 84 tc, 00 tc, 00 tc, 00 tc, 00 tc, 00 tc,  endof
    INVALID_NOP_SIZE$ error endcase
  then cleanup ;
  2 arithop NOT                       ( r/m )
  1 logarop OR                        ( ... )
  56 66 xmop01a ORPD                  ( xmr/m128 xmreg )
  56 00 xmop01a ORPS                  ( xmr/m128 xmreg )
  2 inoutop OUT                       ( accu imm8|DX )
  6E strop OUTS                       ( size )
  38 1C packop2 PABSB                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 1D packop2 PABSW                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 1E packop2 PABSD                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  63 packop1 PACKSSWB                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  6B packop1 PACKSSDW                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 2B 66 xmop02a PACKUSDW           ( xmr/m128 xmmreg )
  67 packop1 PACKUSWB                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  FC packop1 PADDB                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  FD packop1 PADDW                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  FE packop1 PADDD                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  D4 packop1 PADDQ                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  EC packop1 PADDSB                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  ED packop1 PADDSW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  DC packop1 PADDUSB                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  DD packop1 PADDUSW                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  3A 0F packop3 PALIGNR               ( imm8 mxr/m64 mmxreg | imm8 xmr/m128 xmmreg )
  DB packop1 PAND                     ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  DF packop1 PANDN                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PAUSE F3+ 90 op, ;                  ( )
  E0 packop1 PAVGB                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  E3 packop1 PAVGW                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 10 66 xmop02a PBLENDVB           ( xmr/m128 xmreg )
  3A 0E 66 xmop03a PBLENDW            ( imm8 xmr/m128 xmmreg )
  3A 44 66 xmop03a PCLMULQDQ          ( imm8 xmr/m128 xmmreg )
  74 packop1 PCMPEQB                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  75 packop1 PCMPEQW                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  76 packop1 PCMPEQD                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 29 66 xmop02a PCMPEQQ            ( xmr/m128 xmreg )
  3A 61 66 xmop03a PCMPESTRI          ( imm8 xmr/m128 xmmreg )
  3A 60 66 xmop03a PCMPESTRM          ( imm8 xmr/m128 xmmreg )
  64 packop1 PCMPGTB                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  65 packop1 PCMPGTW                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  66 packop1 PCMPGTD                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 37 66 xmop02a PCMPGTQ            ( xmr/m128 xmreg )
  3A 63 66 xmop03a PCMPISTRI          ( imm8 xmr/m128 xmmreg )
  3A 62 66 xmop03a PCMPISTRM          ( imm8 xmr/m128 xmmreg )
  3A 14 66 xmop03e PEXTRB             ( imm8 xmmreg r/m8 )
  3A 16 66 xmop03d PEXTRD             ( imm8 xmmreg r/m32 )
  3A 16 66 xmop03c PEXTRQ             ( imm8 xmmreg r/m64 )
: PEXTRW ( imm8 xmm|mm reg )  3 !args  esc+ over mmxreg? if  pextrwmmx  else
  dup address? if  pextrwr/m  else  pextrwxmm  then then ;
  38 01 packop2 PHADDW                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 02 packop2 PHADDD                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 03 packop2 PHADDSW               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 41 66 xmop02a PHMINPOSUW         ( xmr/m128 xmreg )
  38 05 packop2 PHSUBW                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 06 packop2 PHSUBD                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 07 packop2 PHSUBSW               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  3A 20 66 xmop03h PINSRB             ( imm8 r32/m8 xmmreg )
  3A 22 66 xmop03g PINSRD             ( imm8 r/m32 xmmreg )
  3A 22 66 xmop03F PINSRQ             ( imm8 r/m64 xmmreg )
: PINSRW ( imm8 r32/m16 xmreg|xmreg )  3 !args esc+ dup mmxreg? if pinsrwmmx else pinsrwxmm then ;
  38 04 packop2 PMADDUBSW             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  F5 packop1 PMADDWD                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 3C 66 xmop02a PMAXSB             ( xmr/m128 xmreg )
  38 3D 66 xmop02a PMAXSD             ( xmr/m128 xmreg )
  EE packop1 PMAXSW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  DE packop1 PMAXUB                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 3F 66 xmop02a PMAXUD             ( xmr/m128 xmreg )
  38 3E 66 xmop02a PMAXUW             ( xmr/m128 xmreg )
  38 38 66 xmop02a PMINSB             ( xmr/m128 xmreg )
  38 39 66 xmop02a PMINSD             ( xmr/m128 xmreg )
  EA packop1 PMINSW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  DA packop1 PMINUB                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 3B 66 xmop02a PMINUD             ( xmr/m128 xmreg )
  38 3A 66 xmop02a PMINUW             ( xmr/m128 xmreg )
: PMOVMSKB ( mxreg|xmreg reg )  2 !args esc+ over mmxreg? if  pmovmbmmx  else  pmovmbxmm  then ;
  38 20 66 xmop02b PMOVSXBW           ( xmr/m64 xmmreg )
  38 21 66 xmop02c PMOVSXBD           ( xmr/m32 xmmreg )
  38 22 66 xmop02d PMOVSXBQ           ( xmr/m16 xmmreg )
  38 23 66 xmop02b PMOVSXWD           ( xmr/m64 xmmreg )
  38 24 66 xmop02c PMOVSXWQ           ( xmr/m32 xmmreg )
  38 25 66 xmop02b PMOVSXDQ           ( xmr/m64 xmmreg )
  38 30 66 xmop02b PMOVZXBW           ( xmr/m64 xmmreg )
  38 31 66 xmop02c PMOVZXBD           ( xmr/m32 xmmreg )
  38 32 66 xmop02d PMOVZXBQ           ( xmr/m16 xmmreg )
  38 33 66 xmop02b PMOVZXWD           ( xmr/m64 xmmreg )
  38 34 66 xmop02c PMOVZXWQ           ( xmr/m32 xmmreg )
  38 35 66 xmop02b PMOVZXDQ           ( xmr/m64 xmmreg )
  38 28 66 xmop02a PMULDQ             ( xmr/m128 xmreg )
  38 0B packop2 PMULHRSW              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  E4 packop1 PMULHUW                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  E5 packop1 PMULHW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 40 66 xmop02a PMULLD             ( xmr/m128 xmreg )
  D5 packop1 PMULLW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  F4 packop1 PMULUDQ                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  0 pushpop POP                       ( ... )
  61 op02L POPA                       ( )
: POPCNT ( r/m reg )  2 !args !opsize= !stdreg16+ reg! stdmodr/m! F3+ esc+ $B8 op, ;
  9D op02 POPF                        ( )
  EB packop1 POR                      ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  1 prefetchop PREFETCHT0             ( mem8 )
  2 prefetchop PREFETCHT1             ( mem8 )
  3 prefetchop PREFETCHT2             ( mem8 )
  0 prefetchop PREFETCHNTA            ( mem8 )
  F6 packop1 PSADBW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 00 packop2 PSHUFB                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  70 66 xmop01h PSHUFD                ( imm8 xmr/m128 xmmreg )
  70 F3 xmop01h PSHUFHW               ( imm8 xmr/m128 xmmreg )
  70 F2 xmop01h PSHUFLW               ( imm8 xmr/m128 xmmreg )
  70 00 mxop01h PSHUFW                ( imm8 xmr/m128 xmmreg )
  38 08 packop2 PSIGNB                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 09 packop2 PSIGNW                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 0A packop2 PSIGND                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  73 07 xshiftop PSLLDQ               ( imm8 xmm )
  F1 pshiftop1 PSLLW                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  F2 pshiftop1 PSLLD                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  F3 pshiftop1 PSLLQ                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  E1 pshiftop1 PSRAW                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  E2 pshiftop1 PSRAD                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  73 03 xshiftop PSRLDQ               ( imm8 xmm )
  D1 pshiftop1 PSRLW                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  D2 pshiftop1 PSRLD                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  D3 pshiftop1 PSRLQ                  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
  F8 packop1 PSUBB                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  F9 packop1 PSUBW                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  FA packop1 PSUBD                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  FB packop1 PSUBQ                    ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  E8 packop1 PSUBSB                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  E9 packop1 PSUBSW                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  D8 packop1 PSUBUSB                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  D9 packop1 PSUBUSW                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  38 17 66 xmop02a PTEST              ( imm8 xmr/m128 xmmreg )
  68 packop1 PUNPCKHBW                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  69 packop1 PUNPCKHWD                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  6A packop1 PUNPCKHDQ                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  6D 66 xmop01a PUNPCKHQDQ            ( xmr/m128 xmmreg )
  60 packop1 PUNPCKLBW                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  61 packop1 PUNPCKLWD                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  62 packop1 PUNPCKLDQ                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  6C 66 xmop01a PUNPCKLQDQ            ( xmr/m128 xmmreg )
  1 pushpop PUSH                      ( ... )
  EF packop1 PXOR                     ( mxr/m64 mmxreg | xmr/m128 xmmreg )
  2 shrotop RCL                       ( CL|imm8 r/m )
  3 shrotop RCR                       ( CL|imm8 r/m )
  0 shrotop ROL                       ( CL|imm8 r/m )
  1 shrotop ROR                       ( CL|imm8 r/m )
  4 shrotop SAL                       ( CL|imm8 r/m )
  7 shrotop SAR                       ( CL|imm8 r/m )
  4 shrotop SHL                       ( CL|imm8 r/m )
  5 shrotop SHR                       ( CL|imm8 r/m )
  53 00 xmop01a RCPPS                 ( xmr/m128 xmmreg )
  53 F3 xmop01c RCPSS                 ( xmr/m32 xmmreg )
  32 op0F RDMSR                       ( )
  33 op0F RDPMC                       ( )
  31 op0F RDTSC                       ( )
: RDTSCP ( )  esc+ F9 01 2op, ;
  F3 op00 REP                         ( )
  F3 op00 REPE                        ( )
  F3 op00 REPZ                        ( )
  F2 op00 REPNE                       ( )
  F2 op00 REPNZ                       ( )
: RET ( [imm16] )  op#@ unless  ret0  else  retn  then ;
  3A 09 66 xmop03a ROUNDPD            ( imm8 xmr/m128 xmmreg )
  3A 08 66 xmop03a ROUNDPS            ( imm8 xmr/m128 xmmreg )
  3A 0B 66 xmop03i ROUNDSD            ( imm8 xmr/m64 xmmreg )
  3A 0A 66 xmop03b ROUNDSS            ( imm8 xmr/m32 xmmreg )
  AA op0F RSM                         ( )
  52 00 xmop01a RSQRTPS               ( xmr/m128 xmmreg )
  52 F3 xmop01c RSQRTSS               ( xmr/m32 xmmreg )
  9E op00L SAHF                       ( )
  3 logarop SBB                       ( ... )
  AE strop SCAS                       ( size )
: ?SET ( r/m8 cond ) 2 !args esc+ swap op>opsize! !r/m8 stdmodr/m! .code 90 + op, ;
  7 fenceop SFENCE                    ( )
  01 00 memop3 SGDT                   ( mem )
  A4 shrotop2 SHLD                    ( imm8 reg r/m )
  AC shrotop2 SHRD                    ( imm8 reg r/m )
  C6 66 xmop03z SHUFPD                ( imm8 xmr/m32 xmmreg )
  C6 00 xmop03z SHUFPS                ( imm8 xmr/m32 xmmreg )
  01 01 memop3 SIDT                   ( mem )
  00 00 memop2 SLDT                   ( r/m16 )
  01 04 memop2 SMSW                   ( r/m16 )
  51 00 xmop01a SQRTPS                ( xmr/m128 xmmreg )
  51 F2 xmop01b SQRTSD                ( xmr/m64 xmmreg )
  51 F3 xmop01c SQRTSS                ( xmr/m32 xmmreg )
  F9 op00 STC                         ( )
  FD op00 STD                         ( )
  FB op00 STI                         ( )
: STMXCSR ( mem32 )  1 !args !addr32 3 reg! modr/m! esc+ AE op, ;
  AA strop STOS                       ( size )
: STR ( r/m16 )  1 !args 1 reg! !r/m16 modr/m! esc+ 00 op, ;
  5 logarop SUB                       ( ... )
  5C 66 xmop01a SUBPD                 ( xmr/m128 xmreg )
  5C 00 xmop01a SUBPS                 ( xmr/m128 xmreg )
  5C F2 xmop01b SUBSD                 ( xmr/m64 xmreg )
  5C F3 xmop01c SUBSS                 ( xmr/m32 xmreg )
: SWAPGS ( )  0 !args  7 reg! esc+ 01 op, ;
  05 op0F SYSCALL                     ( )
  34 op0F SYSENTER                    ( )
  35 op02F SYSEXIT                    ( )
  07 op02F SYSRET                     ( )
: TEST ( ... )  testop ;
  2E 66 xmop01b UCOMISD               ( xmr/m64 xmreg )
  2E 00 xmop01c UCOMISS               ( xmr/m32 xmreg )
  0B op0F UD2                         ( )
  15 66 xmop01a UNPACKHPD             ( xmr/m128 xmreg )
  15 00 xmop01a UNPACKHPS             ( xmr/m128 xmreg )
  14 66 xmop01a UNPACKLPD             ( xmr/m128 xmreg )
  14 00 xmop01a UNPACKLPS             ( xmr/m128 xmreg )
  00 04 memop2 VERR                   ( r/m16 )
  00 05 memop2 VERW                   ( r/m16 )
  09 op0F WBINVD                      ( )
  30 op0F WRMSR                       ( )
: XADD ( reg r/m )  2 !args !opsize= esc+ C1 over .size #BYTE = + -rot stdmodr/m! stdreg! op, ;
: XCHG ( r/m reg | reg r/m )  xchgop ;
: XGETBV ( )  esc+ 2 reg! 3 mod! 01 op, ;
  D7 op02 XLAT                        ( )
  6 logarop XOR                       ( ... )
  57 66 xmop01a XORPD                 ( xmr/m128 xmreg )
  57 00 xmop01a XORPS                 ( xmr/m128 xmreg )
: XRSTOR ( mem )  1 !args  !address esc+  5 reg! modr/m!  AE op, ;
: XRSTOR64 ( mem )  1 !args  !>586 !address esc+  48 prefix! 5 reg! modr/m!  AE op, ;
: XSAVE ( mem )  1 !args  !address esc+  4 reg! modr/m!  AE op, ;
: XSAVE64 ( mem )  1 !args  !>586 !address esc+  48 prefix! 4 reg! modr/m!  AE op, ;
: XSETBV ( )  0 !args esc+ 2 reg! 3 mod! 1 r/m! 01 op, ;

=== Condition Codes ===

COV condition OV                      \ overflow
CNO condition NO                      \ not overflow
CBL condition U<                      \ below
CCY condition CY                      \ carry
CAE condition U≥                      \ above or equal
CNC condition NC                      \ not carry
CEQ condition =                       \ equal
CZR condition 0=                      \ zero
CNE condition ≠                       \ not equal
CNZ condition 0≠                      \ not zero
CNZ condition 0-                      \ not zero
CBE condition U≤                      \ below or equal
CAB condition U>                      \ above
CNG condition 0<                      \ negative
CPS condition 0≥                      \ positive
CLE condition 0≤                      \ negative or zero
CGT condition 0>                      \ positive and not zero
CPY condition PY                      \ parity
CPE condition P=                      \ parity even
CNP condition NP                      \ no parity
CPO condition P≠                      \ parity odd
CLT condition <                       \ less
CGE condition ≥                       \ greater or equal
CLE condition ≤                       \ less or equal
CGT condition >                       \ greater
CGT condition 0>                      \ greater zero

CUO fcondition X<                     \ unordered
COD fcondition X>                     \ ordered

=== [Counted] Loops and Blocks ===

( All loops and blocks support BREAK and CONTINUE to go past the end or restart the next
  cycle at the beginning, respectively.  As the Intel architecture only supports short
  conditional branches in the range of ±128 bytes, forward oriented conditionals such as
  IF, UNLESS and WHILE [but not UNTIL, which is backward oriented] would need two forms:
   - SHORT BRANCH, in which the short jump directly points past the block, and
   - LONG BRANCH, in which a short branch with inverted condition points at the beginning
     of the block, followed by a near jump to the end of the block.
  However, to support LEAVE, an unconditional branch to the end of the block is needed, anyway,
  so the long branch is implemented unconditionally. )
( [a] denotes a value of the A stack [consumed if on the left side, produced if on the right side. )

decimal
: (BEGIN) ( -- [a] )  1 skip # JMP  toff dup >A T.ADDRSIZE 1+ + # NEAR JMP ;
: (END) ( [a] -- )  32 assertCodeSpace  A> endblock ;
: (AGAIN) ( [a] -- )  32 assertCodeSpace  A@ hex. A@ back # JMP  A> endblock ;
: (UNTIL) ( [a] cond -- )  32 assertCodeSpace  A@ back dup toff 3 + - -128 128 within simblock? nand if
  # swap 1 [xor] LIKELY ?JMP  else >A 1 skip 1+ # swap UNLIKELY ?JMP  A> # NEAR JMP then  A> endblock ;
: (ASLONG) ( [a] cond -- )  32 assertCodeSpace  A@ back dup toff 3 + - -128 128 within simblock? nand if
  # swap LIKELY ?JMP  else >A 1 skip 1+ # swap 1 [xor] UNLIKELY ?JMP  A> # NEAR JMP then  A> endblock ;
: (IF) ( cond -- [a] )  1 skip # swap ?JMP  toff dup >A T.ADDRSIZE 1+ + # NEAR JMP ;
: (THEN) ( [a] -- )  32 assertCodeSpace  A> dup THENA ! endblock ;
: (ELSE) ( [a1] -- [a2] )  32 assertCodeSpace  A> toff >A >A toff T.ADDRSIZE 1+ + # NEAR JMP A> endblock ;
: (OTHERWISE) ( -- [a] )
  THENA dup @ 0 rot ! ?dup unless  MISPLACED_OTHERWISE$ error  else  >A (ELSE)  then ;
: (WHILE) ( [a1] cond -- [a2] [a1] )  LIKELY (IF) A> A> swap >A >A ;
: (REPEAT) ( [a2] [a1] -- )  32 assertCodeSpace  (AGAIN) (THEN) ;
: (FOR) ( -- [a] )  (BEGIN) ;
: (NEXT) ( [a] -- )  32 assertCodeSpace  A@ back dup toff 2+ - -128 128 within simblock? nand if
  # LOOP  else  >A  RCX DEC  1 skip # 0= ?JMP  A> # NEAR JMP  then  A> endblock ;
: (NEXTIF) ( [a] -- )  32 assertCodeSpace  A@ back dup toff 2+ - -128 128 within simblock? nand if
  # swap ?LOOP  else  CONDLOOP_RANGE$ error  then  A> endblock ;
: (BREAK) ( [a] -- [a] )  A@ # JMP ;
: (BREAKLOOP) ( [a] -- [a] )  A> A@ # JMP >A ;
: (CONTINUE) ( [a] -- [a] )  A@ T.ADDRSIZE 1+ + # JMP ;
: (?BREAK) ( [a] cond -- [a] )  A@ dup toff 2+ - -128 128 within simblock? nand if
  # swap UNLIKELY ?JMP  else  >A 1 skip 1+ # swap 1 [xor] LIKELY ?JMP  A> # NEAR JMP  then ;
: (?CONTINUE) ( [a] cond -- [a] )  A@ T.ADDRSIZE 1+ + dup toff 2+ - -128 128 within simblock? nand if
  # swap UNLIKELY ?JMP  else  >A 1 skip 1+ # swap 1 [xor] LIKELY ?JMP  A> # NEAR JMP  then ;
: (IFUNLIKELY) ( cond -- [a] )  UNLIKELY (IF) ;
: (IFLIKELY) ( cond -- [a] )  LIKELY (IF) ;
: (UNLESS) ( cond -- [a] )  1 [xor] (IF) ;
: (UNLESSUNLIKELY) ( cond -- [a] )  UNLIKELY (UNLESS) ;
: (UNLESSLIKELY) ( cond -- [a] )  LIKELY (UNLESS) ;

: BEGIN (BEGIN) ;
: END (END) ;
: AGAIN (AGAIN) ;
: UNTIL (UNTIL) ;
: ASLONG (ASLONG) ;
: THEN (THEN) ;
: IF (IF) ;
: IFEVER (IFUNLIKELY) ;
: IFLIKELY (IFLIKELY) ;
: IFUNLIKELY (IFUNLIKELY) ;
: UNLESS (UNLESS) ;
: UNLESSEVER (UNLESSUNLIKELY) ;
: UNLESSLIKELY (UNLESSLIKELY) ;
: UNLESSUNLIKELY (UNLESSUNLIKELY) ;
: ELSE (ELSE) ;
: WHILE (WHILE) ;
: REPEAT (REPEAT) ;
: FOR (FOR) ;
: NEXT (NEXT) ;
: ?NEXT (NEXTIF) ;
: BREAK (BREAK) ;
: BREAKLOOP (BREAKLOOP) ;
: CONTINUE (CONTINUE) ;
: ?BREAK (?BREAK) ;
: ?CONTINUE (?CONTINUE) ;
: ADP+ ( n -- ) ( cr ." ADP+ " ADP @ . ) ADP +! ( ADP @ . ) ;
: ADP- ( n -- ) ( cr ." ADP- " ADP @ . ) ADP -! ( ADP @ . ) ;

decimal
stackcheck
cr
( cr ." Order @5: " order )
previous previous  definitions
cr ." Order @6: " order
