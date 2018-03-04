vocabulary AsmBase64
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Relocation.voc"
  requires" Vocabulary.voc"
  requires" AsmProdBase.voc"

: .line  sourceFile@ sourceColumn@ sourceLine@ 3 "At %d.%d in «%s»: "|! ;

=== Compiler variables ===

variable ADP
: adepth depth ADP @ - ;

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

: error>> ( -- )  ERRMSG @ ?dupif  .line e$.  then  ERRMSG 0! ;
: .error ( $ -- ) .line e$. ;
: error! ( $ -- )  ERRMSG @ if  drop  else  ERRMSG !  sourceLine@ ERRLINE !  then ;
: error ( $ -- )  AsmBase64 ERROR-HANDLER @ execute ;
: ?error>> ( -- )  ERRMODE @ #TEST - if  error>>  then ;
: test-mode ( -- )  tick error! ERROR-HANDLER !  #TEST ERRMODE ! ;
: prod-mode ( -- )  tick .error ERROR-HANDLER !  #PRODUCTION ERRMODE ! ;

=== A-Stack ===

create ASTACK 1024 0allot
variable ASP
: A?  ASP @ cell/ ;
: >A  ( cr ASP @ over 2 "---- %08x >A[%d]"|. )  ASTACK ASP @ + !  ASP cell+! ;
: A>  ASP cell-!  ASTACK ASP @ + @  ( cr dup ASP @ 2 "---- A[%d]> %08x"|. ) ;
: A@  ASTACK ASP @ + cell- @ ;

=== Sizes and Architecture ===

--- Size ---

01 constant BYTE
02 constant WORD
04 constant DWORD
08 constant QWORD
10 constant TBYTE
16 constant OWORD

$F0 constant %ADDRSIZE
$0F constant %OPSIZE

01 constant #BYTE
02 constant #WORD
03 constant #DWORD
04 constant #QWORD
05 constant #TBYTE
06 constant #OWORD

create WIDTH>SIZE
   0 c, 1 c, 2 c, -1 c, 3 c, -1 c, -1 c, -1 c, 4 c, -1 c, 5 c, -1 c, -1 c, -1 c, -1 c, -1 c, 6 c,
create SIZE>WIDTH  0 c, 1 c, 2 c, 4 c, 8 c, 10 c, 16 c, 32 c,
create SIZE>SHIFT
   -1 c, -1 c, 1 c, -1 c, 2 c, -1 c, -1 c, -1 c, 3 c, -1 c, 4 c, -1 c, -1 c, -1 c, -1 c, -1 c, -1 c,

: bit  8u/ ;
: width>size ( n -- # )  16 min WIDTH>SIZE + b@  -1=?if  INVALID_SIZE$ error  then ;
  alias bits>size
: size>width ( # -- n )  7and  SIZE>WIDTH + b@  -1=?if  INVALID_WIDTH$ error  then ;
: bits>shift ( n -- # )  15and  SIZE>SHIFT + b@  -1=?if INVALID_SIZE_IN_BITS$ error then ;
: !size ( # -- # )  dup unless  OPERAND_SIZE_UNKNOWN$ error  then ;

--- Architecture ---

02 (  #WORD ) constant i16
03 ( #DWORD ) constant i32
04 ( #QWORD ) constant i64
05 ( #TBYTE ) constant x87
12 constant mmx
13 constant uni
14 constant ext
06 ( #OWORD ) constant xmm

--- Target Architecture ---

%00000001 constant %X87
%00000010 constant %MMX
%00000100 constant %XMM

04 ( _ADDRSIZE bits>size ) constant T.ADDRSIZE
04 ( _OPSIZE bits>size ) constant T.OPSIZE
04 ( _ARCH bits>size ) constant T.ARCH
$FF ( _X87 1 and %X87 u*  _MMX 1 and %MMX u* +  _XMM 1 and %XMM u* + ) constant T.COPROC
03 ( T.ADDRSIZE #DWORD min ) constant T.ADDRWIDTH
03 ( _ADDRSIZE bits>shift ) constant T.ADDRSHIFT

=== Condition Code Values ===

$00 constant COV                      ( overflow )
$01 constant CNO                      ( not overflow )
$02 constant CCY                      ( carry )
$02 constant CBL                      ( below )
$03 constant CAE                      ( above or equal )
$03 constant CNC                      ( not carry )
$03 constant CNB                      ( not below )
$04 constant CEQ                      ( equal )
$04 constant CZR                      ( zero )
$05 constant CNE                      ( not equal )
$05 constant CNZ                      ( not zero )
$06 constant CBE                      ( below or equal )
$07 constant CAB                      ( above )
$08 constant CNG                      ( negative )
$09 constant CPS                      ( positive )
$0A constant CPY                      ( parity )
$0A constant CPE                      ( parity even )
$0A constant CUO                      ( unordered )
$0B constant CNP                      ( no parity )
$0B constant CPO                      ( parity odd )
$0B constant COD                      ( ordered )
$0B constant CNU                      ( not unordered )
$0C constant CLT                      ( less )
$0D constant CGE                      ( greater or equal )
$0E constant CLE                      ( less or equal )
$0F constant CGT                      ( greater )

create COND>FCOND  02 c, 04 c, 06 c, 10 c, 03 c, 05 c, 07 c, 11 c,

: cond>fcond ( cond -- fcond )
  COND>FCOND 8 rot cfind dup unless  INVALID_FLOAT_COND$ error  then  1- ;

=== Operand Structure ===

( type arch+size mode code )
$000000FF constant %FIELD   $F constant %SUBFIELD
$000000FF constant %CODE    00 constant ^CODE
$0000FF00 constant %MODE    08 constant ^MODE
$000F0000 constant %SIZE    16 constant ^SIZE           $FFF0FFFF constant %~SIZE
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
$FFFF70FF ( %~MODE %ADDR_MODE ^MODE 4+ << + ) constant %~AMODE
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
: .index ( addr -- addr.index )  4u>> %FIELD and ;
: .code ( op -- code )  %CODE and ;
: .code! ( op code -- op' )  swap %CODE andn or ;
: .amode! ( addr mode -- addr' )  %ADDR_MODE and ^MODE << swap %~AMODE and or ;
: .size! ( op size -- op' )  %SUBFIELD and ^SIZE << swap %~SIZE and or ;
: register? ( op -- ? )  .type #REGISTER = ;
: stdreg? ( op -- ? )  dup register? over .regmode %~STANDARD and 0= and swap .size #TBYTE < and ;
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
: DX? ( op -- ? )  dup stdreg? over .size #WORD = and swap .code 2 = and ;
: .size-no-imm ( op -- opsize )  dup immediate? if  drop 0  else  .size  then ;

=== Operand Parameters ===

variable control ( Various flags )
: control? ( n -- ? )  1 swap << control @ and 0- ;
: control?- ( n -- ? )  1 swap << dup control @ and 0- swap control andn! ;
: control+ ( n -- )  1 swap << control or! ;
: control- ( n -- ? )  1 swap << control andn! ;
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
: rex? ( -- ? )     REX? REX.R? or REX.B? or REX.X? or REX.W? or noREX? andn ;
: rex@ ( -- u )     REX.B? negate REX.X? 2and REX.R? 4and REX.W? 8and or or or ;

variable RELOCATION-TARGET
: reloc@ ( -- &t )  RELOCATION-TARGET @ ;
: reloc! ( &t -- )  RELOCATION-TARGET ! ;
: reloc/ ( -- )  0 reloc! ;
variable CODEBASE
: codebase@ ( -- u ) CODEBASE @ ;
: codebase! ( u -- ) CODEBASE ! ;
bytevar DISPSIZE ( Size of displacement [B] )
: dispsize@ ( -- n )  DISPSIZE c@ ;
: dispsize! ( n -- )  DISPSIZE c! ;
: dispsize/ ( -- )  DISPSIZE 0c! ;
bytevar IMMSIZE ( Size of immediate operand value )
: immsize@ ( -- n )  IMMSIZE c@ ;
: immsize! ( n -- )  IMMSIZE c! ;
: immsize/ ( -- )  0 immsize! ;
bytevar MODREGR/M
: modregr/m@ ( -- c )  MODREGR/M c@ ;
: reg! ( c -- )  dup 8and if  REX.R+  then  7and 3u<< MODREGR/M cor!  modregr/m+ ;
: reg/ ( -- )  MODREGR/M dup c@ $C7 and swap c! ;
: r/m! ( c -- )  dup 8and if  REX.B+  then  7and MODREGR/M cor!  modregr/m+ ;
: mod! ( c -- )  3 and 6 << MODREGR/M cor!  modregr/m+ ;
: mod@ ( -- c )  modregr/m@ 6u>> 3and ;
: reg>r/m ( -- )  modregr/m@ 3u>> r/m! reg/  REX.R?- if  REX.B+  then ;
: modregr/m/ ( -- )  0 MODREGR/M c! ;
bytevar SIB
: sib@ ( -- c )  SIB c@ ;
: sib! ( c -- )  SIB c! ;
: sib/ ( -- )  0 sib! ;
: base! ( c -- )  dup 8and if  REX.B+  then  7and SIB cor!  sib+ ;
: index! ( c -- )  dup 8and if  REX.X+  then  7and 3u<< SIB cor!  sib+ ;
: scale! ( c -- )  3and 6u<< SIB cor!  sib+ ;
bytevar OPSIZE
: opsize@ ( -- c )  OPSIZE c@ ;
: opsize! ( c -- )  dup T.ARCH > fpuop? andn if  INVALID_OPERAND_SIZE$ error then
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
variable IMMOPVAL ( Immediate operand value )
: imm@ ( -- n )  IMMOPVAL @ ;
: imm#! ( n # -- )  immsize!  IMMOPVAL ! imm+ ;
: imm! ( n -- )  nsize imm#! imm+ ;
: uimm! ( n -- )  usize imm#! ;
: imm/ ( -- )  immsize/  0 IMMOPVAL ! ;
variable DISPLACEMENT ( Address displacement )
: disp@ ( -- n )  DISPLACEMENT @ ;
: disp! ( n -- )  nsize dispsize! DISPLACEMENT ! ;
: disp/ ( -- ) 0 disp! ;
bytevar OP#
: op#@ ( -- n )  OP# c@ ;
: op#1+! ( -- )  OP# 1c+! ;
: op#/ ( -- )  0 OP# c! ;

: cleanup  ?error>>
  control/ imm/ disp/ dispsize/ prefix/ opsize/ addrsize/  modregr/m/  sib/  sizex/ op#/  reloc/
  adepth ?dup if  .line  " : cleanup ".. drop .s espace " ADP=". ADP @ .. ( abort
    adepth 0 do  drop  loop ) then ;

=== Operand Definitions ===

--- Operand Utilities ---

: %BASEADDR/ ( addr -- addr' )  dup .mode %BASEADDR and if  %BASEADDR ^MODE u<< xor  then ;
: >indexed ( addr -- addr' )  $40or  #INDEXED .amode! ;
: >indexed2 ( base index -- sib-addr )  .code 4u<< or #INDEXED .amode! %BASEADDR/ ;
: base>index ( addr -- addr' )  disp@ if  BASE_EBP_REQUIRED$ error  then
  dup .code 4u<< or  $FFFFFFF0 and  5or #INDEXED .amode! nobase+ ;
: >sib ( addr -- addr' )  dup 15and base!  dup 4u>> 15and index!
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
: stdaddress?  ( op -- ? )  dup address? swap .size #TBYTE < and ;
: direct? ( op -- ? )  dup .arch i64 = if $FF0FFFF and $2402245= else .addrmode #DIRECT = then ;
: diraddr? ( op -- ? )  dup address? swap direct? and ;
: !stdr/m ( op -- op )  dup stdreg? over stdaddress? or unless  STANDARD_R/M_EXPECTED$ error  then ;
: !stdregr/m ( reg r/m -- reg r/m )  swap !stdreg swap !stdr/m ;
: !stdr/mreg ( r/m reg -- r/m reg )  swap !stdr/m swap !stdreg ;
: op>opsize! ( op -- op )  dup .size opsize! ;
: addrmodr/m! ( op -- )
   dup address? unless  INVALID_OPERAND_TYPE$ error  then
   dup .mode %BASEADDR and if    4 >indexed2  then
   dup .mode %MOD01 and if   dispsize@ 1 max dispsize!  then
   dup .arch i16 = over .addrmode #INDEXED < or unless   >sib then
   dup .addrmode #DIRECT =unless
     dispsize@ over .mode %MOD00 and 0= and  2 min mod!  then
   nobase? mod@ 0= and if   DWORD dispsize!  then
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
: stdreg32+? ( op -- ? )  dup stdreg? swap .size #DWORD u< 0= and ;
: !stdreg32+ ( op -- op )  dup stdreg32+? unless  REGISTER_32+_EXPECTED$ error  then ;
: reg32? ( op -- ? )  dup register? swap .size #DWORD = and ;
: !reg32 ( op -- op )  dup reg32? unless  REGISTER_32_EXPECTED$ error  then ;
: stdreg32? ( op -- ? )  dup stdreg? swap .size #DWORD = and ;
: reg16+? ( op -- ? )  dup register? swap .size #BYTE > and ;
: !reg16+ ( op -- op )  dup reg16+? unless  REGISTER_16_EXPECTED$ error  then ;
: reg16? ( op -- ? )  dup register? swap .size #WORD = and ;
: !reg16 ( op -- op )  dup reg16? unless  REGISTER_16_EXPECTED$ error  then ;
: stdreg16+? ( op -- ? )  dup stdreg? swap .size dup #BYTE > swap #TBYTE < and and ;
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
: check-arch ( op arch -- op )
  i16 =?if  drop match-arch16  unless INVALID_TARGET_ARCHITECTURE$ error then  exit  then
  i32 =?if  drop match-arch32  unless I32_NOT_SUPPORTED$ error then  exit  then
  i64 =?if  drop match-arch64  unless I64_NOT_SUPPORTED$ error then  exit  then
  uni =?if  drop match-archuni  unless INVALID_TARGET_ARCHITECTURE$ error then  exit  then
  ext =?if  drop match-archext  unless INVALID_TARGET_ARCHITECTURE$ error then  exit  then
  x87 =?if  drop T.COPROC %X87 and  unless X87_NOT_SUPPORTED$ error then  exit  then
  mmx =?if  drop T.COPROC %MMX and  unless MMX_NOT_SUPPORTED$ error then  exit  then
  xmm =?if  drop T.COPROC %XMM and  unless XMM_NOT_SUPPORTED$ error then  exit  then
  INVALID_ARCHITECTURE_DEFINITION$ error ;
: !arch ( op -- op )  dup .arch check-arch ;
: !arch= ( addr addr -- addr addr )
  2dup .arch swap .arch = unless  ARCHITECTURE_MISMATCH$ error  then ;
: validBase? ( addr -- ? )  !arch .addrmode #INDEXED u< ;
: ~[xSP] ( addr -- ? )  .code 7and 4≠ ;
: validIndex32+? ( addr -- ? )  !arch dup validBase?  over .arch #WORD u> and swap ~[xSP] and ;
: !validBase ( addr -- addr )  dup validBase? unless ADDRESS_NOT_COMBINABLE$ error  then ;
: !validIndex32+ ( addr -- addr )  dup validIndex32+? unless  INVALID_ADDRESS_INDEX$ error  then ;
: >sizex ( op -- op' )  dup .size 0=if  sizex@ .size!  then ;
: size>immsize ( op -- op )  dup .size immsize! ;
: check-opsize ( op1 op2 -- op1 op2 )
  over .size-no-imm over .size or unless  OPERAND_SIZE_UNKNOWN$ error  then ;
: ?size! ( op1 op2 -- op1 op2' )  dup .size-no-imm unless  over .size .size! then ;
: supply-opsize ( op1 op2 -- op1' op2' )  swap ?size! swap ?size! ;
: match-size16 ( -- ? )  #WORD opsize! true ;
: match-size32 ( -- ? )  #DWORD opsize! true ;
: match-size64 ( -- ? )  #QWORD opsize! true ;
: match-size80 ( -- ? )  #TBYTE opsize! true ;
: !opsize ( op -- op )  dup .size
       0 =?if  drop OPERAND_SIZE_UNKNOWN$ error true  else
   #BYTE =?if  drop true  else
   #WORD =?if  drop match-size16  else
  #DWORD =?if  drop match-size32  else
  #QWORD =?if  drop match-size64  else
  #TBYTE =?if  drop match-size80  else  false  then  then  then  then  then  then
  unless  drop INVALID_OPERAND_SIZE$ error  then ;
: !=opsize ( op sz -- op )  over .size = unless  INVALID_OPERAND_SIZE$ error  then ;
( assert that operand sizes are equal )
: !opsize= ( op1 op2 -- op1 op2 )
  check-opsize  supply-opsize  !opsize  over .size over .size -  if  OPERAND_SIZE_MISMATCH$ error  then
   over immediate? if   dup .size immsize!  then ;
: limit32 #DWORD min ;
( check operand size with size extension )
: opsizext ( imm op -- imm op n )
  !opsize over .size over .size u> if  IMMEDIATE_TOO_BIG$ error 0  else  dup .size
  #BYTE = if  0  else  over .size #BYTE = 2 and 1+  then then
  1=?if  opsize@ limit32 immsize!  then ;
: ?hibyte+ ( op -- op )  dup .regmode #HI-BYTE = if  hibyte+  then ;
: ![n]eq ( condition -- 0=eq|1=ne ) !condition .code dup CEQ = if 1 else dup CNE = if 0 else
  EQ_OR_NEQ_REQUIRED$ error -1  then then nip ;
: ?rex+ ( op -- op )  dup .arch i64 = if  REX+  then ;

--- Definer Tools ---

: buildOp ( code mode size type -- op )
  ^TYPE u<< swap ( ^ARCH u<< or swap ) ^SIZE u<< or swap ^MODE u<< or swap ^CODE u<< or ;
: makeSize ( size arch -- size+arch )  15and 4u<< swap 15and or ;
: makeImmediate ( n # -- immop )  ^SIZE u<< #IMMEDIATE ^TYPE u<< + swap imm! ;
: makeUmmediate ( n # -- immop )  ^SIZE u<< #IMMEDIATE ^TYPE u<< + swap uimm! ;
: makeAddress ( disp addr -- addr )  adepth 2u<if  MISSING_ADDRESS_DISPLACEMENT$ error  exit  then
  swap disp!  !arch  addr+ >sizex  op#1+! ;
: makeDirect ( disp code mode size arch -- addr )
  #ADDRESS 4u<< + 4u<< + 8u<< + 8u<< + swap disp! addr+ >sizex ;
: mergeAddress ( addr1 addr2 -- addr1' )
  !arch= swap !validBase swap !validIndex32+ !arch= >indexed2 ;
: ?mergeAddress ( [disp] [addr] addr -- addr' )  addr? if  mergeAddress else makeAddress then ;

--- Definers ---

: register ( code mode size arch -- reg )
  makeSize #REGISTER buildOp  ?hibyte+ ?rex+ !arch  op#1+! ;
: address ( code mode size arch -- addr )
  makeSize #ADDRESS buildOp  ?mergeAddress ;
: scale ( addr code -- addr' )
  swap !addri32+ !sibified swap #SCALED1 + .amode! ;
: condition  ( code -- cond )
  #REGULAR 0 #CONDITION buildOp  op#1+! ;
: fcondition  ( code -- fcond )
  #FLOATCND 0 #CONDITION buildOp  op#1+! ;

=== Operations ===

--- Operation Utils ---

: !legacy ( -- )  T.ARCH i64 = if  LEGACY_OPCODE$ error  then ;
: !>486 ( -- )  T.ARCH i16 = if  OPERATION_NOT_SUPPORTED<486$ error  then ;
: !>586 ( -- )  T.ARCH i16 = if  OPERATION_NOT_SUPPORTED<586$ error  then ;
: !fpu ( -- )  T.COPROC %X87 and unless  X87_NOT_SUPPORTED$ error  then  fpuop+ ;
: >opsize ( op -- op # )  dup .size #BYTE > negate ;
: !no64 ( -- )  opsize@ #DWORD > if  INVALID_OPERAND_SIZE$ error  then ;
: r/mreg! ( r/mop regop -- )  reg! !stdr/m modr/m! ;
: >mask  ( # -- % )
       0 =?if  drop 1  exit  then
   #BYTE =?if  drop $7F  exit  then
   #WORD =?if  drop $7FFF  exit  then
  #DWORD =?if  drop $7FFFFFFF  exit  then
  #QWORD =?if  drop $7FFFFFFFFFFFFFFF  exit  then
  INVALID_OPERAND_SIZE$ error ;
: fits? ( n # -- n # ? )  over abs over >mask over and = ;
: !fits ( n # -- n # )  fits? unless  IMMEDIATE_TOO_BIG$ error  then ;
: !size= ( op1 op2 -- op1 op2 )  over .size over .size - if  OPERAND_SIZE_MISMATCH$ error  then ;
: reladdr ( size offset -- )
  imm@ r- swap fits? unless  TARGET_ADDRESS_OUT_OF_RANGE$ error  then imm#! ;
: farptr?  ( -- ? )  false ;

--- Operation Builders ---

: #, ( n # -- )  !fits
       0 =?if  drop tc,  exit  then
   #BYTE =?if  drop tc,  exit  then
   #WORD =?if  drop tw,  exit  then
  #DWORD =?if  drop td,  exit  then
  #QWORD =if   td,  exit  then
  drop INVALID_IMMEDIATE_SIZE$ error  ;
: ##, ( n # -- )  !fits
       0 =?if  drop tc,  exit  then
   #BYTE =?if  drop tc,  exit  then
   #WORD =?if  drop tw,  exit  then
  #DWORD =?if  drop td,  exit  then
  #QWORD =?if  drop tq,  exit  then
  drop INVALID_IMMEDIATE_SIZE$ error ;
: #! ( n # a -- )  >r !fits
   #BYTE =?if  drop r> c!  exit  then
   #WORD =?if  drop r> w!  exit  then
  #DWORD =?if  drop r> d!  exit  then
  #QWORD =?if  drop r> !   exit  then
  r> 3drop INVALID_IMMEDIATE_SIZE$ error ;
: disp, ( -- )  dispsize@
      0 =?if  drop  exit  then
  #BYTE =if   disp@ #BYTE #,  exit  then
  disp@ addrsize? if  addrsize@ else T.ADDRSIZE  then  dup >r #,
  reloc? if  reloc@ &here r@ − RELOC-32 RELOC-ABSOLUTE + #currentRelo relocate  then  r> drop ;
: modregr/m, ( ... -- )  modregr/m? if  modregr/m@ tc,  sib? if  sib@ tc,  then  disp, then ;
: opsize, ( -- )
  opsize? fpuop? andn if
    opsize@ #QWORD = if  REX.W+  then
    opsize@ #WORD = T.ADDRSIZE #WORD ≠ and if  $66 tc,  then then ;
: addrsize, ( -- )  addrsize? if  addrsize@ T.ADDRSIZE = unless  $67 tc,  then then ;
: prefix, ( -- )  prefix? if  prefix@ tc,  then ;
: rex, ( -- )
  rex? fpuop? andn if rex@ 8= mmxop? and unless rex@ mmxop? 8and andn $40+ tc, then then ;
: escape, ( -- )  esc? if  $0F tc,  then ;
: prefices, ( -- )  opsize, addrsize, prefix, rex, escape, ;
: imm, ( -- )  imm? if  imm@ immsize@  wide? if  ##,  else  #,  then then ;
: operands, ( -- )  modregr/m, imm, ;
: validate ( -- )  hibyte? rex? and if  HIBYTE_NOT_AVAILABLE_WITH_REX$ error  then ;
: op, ( ... opc -- )  validate prefices, tc, operands,  cleanup ;
: op&, ( ... opc -- )  validate prefices, tc, operands, ;
: 2op, ( ... opc2 opc1 -- )  validate prefices, swap tc, tc, operands,  cleanup ;
: daop, ( opc -- )  validate prefices, tc, imm@ T.ARCH ##, cleanup ;

--- Operation Definer Tools ---

: 66+ ( -- )  $66 prefix! ;
: F2+ ( -- )  $F2 prefix! ;
: F3+ ( -- )  $F3 prefix! ;
: !args ( n -- )  dup op#@ = unless
  cr "Expected " .error dup . " operand(s), but got ". op#@ . " -- cannot continue!".
  abort then drop ;

--- Operation Definers ---

: segprefix  tc, ;
: op00  0 !args   op, ;
: op0F  0 !args !>586 esc+ op, ;
: op00L  !legacy op, ;
: op01L   !legacy op#@  unless   10 nsize makeImmediate  op#1+!  swap  then   nip op,  ;
: op02  sizex@ opsize! op, ;
: op02L  sizex@ opsize! !legacy op, ;
: op02F  sizex@ opsize! !>586 esc+ op, ;
: flop01  0 !args  !fpu $D9 tc, tc, cleanup ;
: flop02  1 !args  !fpu reg!  !address modr/m!  $D9 op, ;
: flop03  1 !args  !fpu reg!  !address modr/m!  $DD op, ;
: logarop-immacc  ( imm acc -- )   !opsize= size>immsize .size #WORD < 5+ A@ 8* + nip op, ;
: logarop-immr/m  ( imm r/m -- )   !stdr/m  !opsize  opsizext $80+  swap  A@  r/mreg!  nip op,  ;
: logarop-imm ( imm r/m -- )   over .size #BYTE = over .size #BYTE u> and if
  logarop-immr/m  else  dup accu? if  logarop-immacc  else  logarop-immr/m  then  then ;
: logarop-reg ( reg r/m -- )   !stdregr/m !opsize=  stdmodr/m! dup stdreg! >opsize A@ 8* + nip op, ;
: logarop-mem ( mem reg -- )   !stdr/mreg !opsize=  over stdmodr/m! stdreg! >opsize A@ 8* 2+ + nip op, ;
: logarop ( ... opc )   2 !args
  >A  2dup  imm>r/m?  if  logarop-imm else  2dup reg>r/m?  if  logarop-reg else  2dup mem>reg? if
   logarop-mem else  INVALID_OPERAND_COMBINATION$ error then then then   A>  drop ;
: xmop01a ( xmr/m128 xmreg / opc prefix )  2 !args  esc+ prefix! -rot xmreg! xmr/m128! op, ;
: xmop01b ( xmr/m64 xmreg / opc prefix )  2 !args  esc+ prefix! -rot xmreg! xmr/m64! op, ;
: xmop01c ( xmr/m32 xmreg / opc prefix )  2 !args  esc+ prefix! -rot xmreg! xmr/m32! op, ;
: xmop01d ( mem128 xmreg / opc prefix )  2 !args  esc+ prefix! -rot xmreg! !addr128 modr/m! op, ;
: xmop01e ( xmreg1 xmreg2 / opc prefix )  2 !args  esc+ prefix! -rot xmreg! !xmreg xmr/m128! op, ;
: xmop01g ( xmreg mem128 / opc prefix )  2 !args  esc+ prefix! -rot !addr128 modr/m! xmreg! op, ;
: xmop01h ( imm8 xmreg mem128 / opc prefix )
  3 !args  esc+ prefix! -rot xmreg! xmr/m128! swap !imm8 drop op, ;
: xmop01i ( imm8 xmreg mem32 / opc prefix )
  3 !args  esc+ prefix! -rot xmreg! xmr/m32! swap !imm8 drop op, ;
: xmop02a ( xmr/m128 xmreg / opc1 opc2 prefix )  2 !args  esc+ prefix! 2swap xmreg! xmr/m128! 2op, ;
: xmop02b ( xmr/m64 xmreg / opc1 opc2 prefix )  2 !args  esc+ prefix! 2swap xmreg! xmr/m64! 2op, ;
: xmop02c ( xmr/m32 xmreg / opc1 opc2 prefix )  2 !args  esc+ prefix! 2swap xmreg! xmr/m32! 2op, ;
: xmop02d ( xmr/m16 xmreg / opc1 opc2 prefix )  2 !args  esc+ prefix! 2swap xmreg! xmr/m16! 2op, ;
: xmop02e ( mem128 xmreg / opc1 opc2 prefix )
  2 !args  esc+ prefix! 2swap xmreg! !addr128 modr/m! 2op, ;
: xmop03a ( imm8 xmr/m128 xmreg / opc1 opc2 prefix )
  3 !args  esc+ prefix! >r >r xmreg! xmr/m128! !imm8 drop r> r> 2op, ;
: xmop03b ( imm8 xmr/m32 xmreg / opc1 opc2 prefix )
  3 !args  esc+ prefix! >r >r xmreg! xmr/m32! !imm8 drop r> r> 2op, ;
: xmop03c ( imm8 xmreg r/m64 / opc1 opc2 prefix )
  3 !args esc+ prefix! >r >r !r/m64 op>opsize! stdmodr/m! xmreg! !imm8 drop r> r> 2op, ;
: xmop03d ( imm8 xmreg r/m32 / opc1 opc2 prefix )
  3 !args esc+ prefix! >r >r !r/m32 op>opsize! stdmodr/m! xmreg! !imm8 drop r> r> 2op, ;
: xmop03e ( imm8 xmreg r/m8 / opc1 opc2 prefix )
  3 !args esc+ prefix! >r >r !r/m8 op>opsize! stdmodr/m! xmreg! !imm8 drop r> r> 2op, ;
: xmop03f ( imm8 r/m64 xmreg / opc1 opc2 prefix )
  3 !args esc+ prefix! >r >r xmreg! !r/m64 op>opsize! stdmodr/m! !imm8 drop r> r> 2op, ;
: xmop03g ( imm8 r/m32 xmreg / opc1 opc2 prefix )
  3 !args esc+ prefix! >r >r xmreg! !r/m32 op>opsize! stdmodr/m! !imm8 drop r> r> 2op, ;
: xmop03h ( imm8 r/m8 xmreg / opc1 opc2 prefix )
  3 !args esc+ prefix! >r >r xmreg! !r/m8 op>opsize! stdmodr/m! !imm8 drop r> r> 2op, ;
: xmop03i ( imm8 xmr/m64 xmreg / opc1 opc2 prefix )
  3 !args  esc+ prefix! >r >r xmreg! xmr/m64! !imm8 drop r> r> 2op, ;
: xmop03z ( imm8 xmr/m64 xmreg / opc prefix )
  3 !args  esc+ prefix! >r xmreg! xmr/m128! !imm8 drop r> op, ;
: xmop04a ( xmr/m64 reg32|64 / opc prefix )
  2 !args  esc+ prefix! -rot !reg32+ op>opsize! stdreg! xmr/m64! op, ;
: xmop04b ( xmr/m32 reg32|64 / opc prefix )  2 !args  esc+ prefix! -rot xmr/m32! !reg32+ reg! op, ;
: xmop04c ( r/m32|64 xmreg / opc prefix )
  2 !args  esc+ prefix! -rot xmreg! !r/m32+ op>opsize! stdmodr/m! op, ;
: xmop04d ( xmreg reg32+ / opc prefix )
  2 !args  esc+ prefix! -rot !stdreg32+ op>opsize! reg! !xmreg modr/m! op, ;
: xmop05a ( xmr/m128 xmreg | xmreg xmr/m128 / opc prefix )
  2 !args  esc+ prefix! -rot dup address? if rot 1+ -rot swap then  xmreg! xmr/m128! op, ;
: xmop05b ( xmr/m128 xmreg | xmreg xmr/m128 / opc prefix )
  2 !args  esc+ prefix! -rot dup address? if rot $10 + -rot swap then  xmreg! xmr/m128! op, ;
: xmop05c ( mem64 xmreg | xmreg mem64 / opc prefix )
  2 !args  esc+ prefix! -rot dup address? if rot 1+ -rot swap then  xmreg! !addr64 modr/m! op, ;
: xmop05d ( xmr/m64 xmreg | xmreg xmr/m64 / opc prefix )
  2 !args  esc+ prefix! -rot dup address? if rot 1+ -rot swap then  xmreg! xmr/m64! op, ;
: xmop05e ( xmr/m64 xmreg | xmreg xmr/m64 / opc prefix )
  2 !args  esc+ prefix! -rot dup address? if rot 1+ -rot swap then  xmreg! xmr/m32! op, ;
: mxop01e ( mxreg1 mxreg2 / opc prefix )
  2 !args  mmxop+ esc+ prefix! -rot mxreg! !mxreg mxr/m64! op, ;
: mxop01g ( mxreg mem64 / opc prefix )
  2 !args  mmxop+ esc+ prefix! -rot !address mxr/m64! mxreg! op, ;
: mxop01h ( imm8 xmreg mem128 / opc prefix )
  3 !args  mmxop+ esc+ prefix! -rot mxreg! mxr/m64! swap !imm8 drop op, ;
: bitscop ( r/m reg / opc )  2 !args esc+ -rot !opsize= !stdreg reg! !stdr/m modr/m! op, ;
: bitop-imm ( opc imm r/m )  !-byteop !opsize !stdr/m modr/m!  !imm8 drop reg! $BA op, ;
: bitop-reg ( opc reg r/m )  !opsize= swap op>opsize! !stdreg reg!  !r/m modr/m! 8* $83+ op, ;
: bitop ( imm|reg r/m / opc )
  2 !args esc+ -rot over immediate? if  bitop-imm  else  bitop-reg  then ;
: jmp-rel8 ( opc )  drop #BYTE there 2+ reladdr  $EB op, ;
: jmpcall-imm ( opc imm )
  drop imm@ there - -126 130 within near? andn if  dup if  jmp-rel8 exit  then  then
  imm@ swap addrwidth@ DWORD min dup 1+  there + reladdr $E8+ op&,
  reloc? if  reloc@ &here 4- RELOC-32 RELOC-RELATIVE + #currentRelo relocate  then  drop cleanup ;
: jmpcall-far ( opc addr )  FAR_CALL_UNSUPPORTED$ error  swap $50 * $9A+ op, ;
: jmpcall-r/m ( opc r/m )  swap 2* 2+ reg! modr/m! $FF op, ;
: jmpcall ( target / opc )
  1 !args  swap dup immediate? if  jmpcall-imm  else  farptr? if  jmpcall-far  else  dup r/m? if
    jmpcall-r/m  else  INVALID_OPERAND_TYPE$ error  then then then ;
: cvop01 ( / size )  0 !args opsize! $98 op, ;
: cvop02 ( / size )  0 !args opsize! $99 op, ;
: strop ( size opc )
  0 !args sizex@ dup opsize! ?dup unless OPERAND_SIZE_UNKNOWN$ error then  #BYTE > - op, ;
: incdecreg ( opc reg )  op>opsize! .code swap 8* + $40+ op, ;
: incdecr/m ( opc r/m )  >sizex swap reg! op>opsize! >opsize $FE+ swap stdmodr/m! op, ;
: incdecop ( r/m / opc )
  swap T.ARCH i64 = unless  dup stdreg16+? if  incdecreg exit then then  !stdr/m incdecr/m ;
: (arithop)  ( r/m opc )  reg! op>opsize! >opsize $F6+ swap stdmodr/m! op, ;
: arithop ( r/m / opc )  1 !args (arithop) ;
: flopar1m32 ( opc mem32 )  swap reg! modr/m! $D8 op, ;
: flopar1m64 ( opc mem64 )  swap reg! modr/m! $DC op, ;
: flopar1ST ( opc ST )  swap reg! modr/m! $DC op, ;
: flopar1 ( ST/mem32|64 / opc )
  !fpu 1 !args swap !opsize dup addr32? if flopar1m32 else dup addr64? if flopar1m64 else
    dup fpureg? if  flopar1ST  else  2drop INVALID_OPERAND_TYPE$ error cleanup then then then ;
: flopar0 ( ST / opc )  !fpu 1 !args swap !fpureg swap reg! modr/m! $D8 op, ;
: flopar2 ( [ST] / opc )  !fpu adepth 1=if  01 #FLOATING #TBYTE x87 register  swap  then
  1 !args reg! !fpureg modr/m! $DE op, ;
: flopar3m16 ( opc mem16 )  swap reg! modr/m! $DA op, ;
: flopar3m32 ( opc mem32 )  swap reg! modr/m! $DE op, ;
: flopar3 ( mem16|32 / opc )
  !fpu 1 !args swap !opsize dup addr16? if flopar3m16 else dup addr32? if flopar3m32 else
    2drop INVALID_OPERAND_TYPE$ error cleanup  then then ;
: flopar4 ( mem16|32 / opc )
  !fpu 1 !args swap !opsize dup addr16? if flopar3m32 else dup addr32? if flopar3m16 else
    2drop INVALID_OPERAND_TYPE$ error cleanup  then then ;
: fbcdop ( mem80 / opc )  !fpu 1 !args reg! !opsize !addr80 modr/m! $DF op, ;
: fcomop ( STx / opc )  !fpu 1 !args 16/mod $DB+ -rot reg! !fpureg modr/m! op, ;
: fildstop16 ( mem16 @opc )  reg! modr/m! $DF op, ;
: fildstop32 ( mem32 @opc )  reg! modr/m! $DB op, ;
: fildstop64 ( mem64 @opc )  reg! modr/m! $DF op, ;
: fisttpop64 ( mem64 @opc )  reg! modr/m! $DD op, ;
: fildstop ( mem16|32|64 / opc2 opc1 )
  !fpu 1 !args 2pick addr16? if  nip fildstop16  else  2pick addr32? if  nip fildstop32  else
  2pick addr64? if  drop fildstop64  else 3drop INVALID_OPERAND_TYPE$ error cleanup then then then ;
: fistop ( mem16|32 / opc )
  !fpu 1 !args over addr16? if  fildstop16  else  over addr32? if  fildstop32  else
    2drop INVALID_OPERAND_TYPE$ error cleanup  then then ;
: fxenvop ( mem / opc )  !fpu 1 !args esc+ reg! !address modr/m! $AE op, ;
: fxenvop64 ( mem / opc )  !fpu 1 !args esc+ reg! fpuop- REX.W+ !address modr/m! $AE op, ;
: imul2 ( r/m reg )  !stdreg16+ !opsize= reg! stdmodr/m! esc+ $AF op, ;
: imul3opc ( imm r/m -- opc )  over .size #BYTE = if  2drop $6B  else  !opsize= 2drop $69  then ;
: imul3 ( imm r/m reg )  !stdreg16+ !opsize= reg! dup stdmodr/m! imul3opc op, ;
: inoutop ( imm8|DX accu / opc )
  2 !args  dup if  >r swap r>  then  swap !accu op>opsize! !no64 .size #BYTE > - swap  dup DX? if
    drop 8+  else  !imm8 drop  then  $E4+ op, ;
: oplp ( r/m16 reg )   2 !args  -rot esc+ !stdreg16+ op>opsize! stdreg! !r/m16 stdmodr/m! op, ;
: ldop1 ( mem reg / opc )  2 !args -rot !legacy !stdreg16+ op>opsize! reg! !address stdmodr/m! op, ;
: ldop2 ( mem reg / opc )  2 !args -rot esc+ !stdreg16+ op>opsize! reg! !address stdmodr/m! op, ;
: ldop3 ( mem reg / opc )  2 !args -rot !stdreg16+ op>opsize! reg! !address stdmodr/m! op, ;
: fenceop ( / opc )  0 !args reg! esc+ $AE op, ;
: memop1 ( mem / opc reg )  1 !args reg! swap !address stdmodr/m! esc+ op, ;
: memop2 ( r/m16 / opc reg )  1 !args reg! swap !r/m16 stdmodr/m! esc+ op, ;
: memop3 ( mem / opc reg )  1 !args reg! swap !address op>opsize! stdmodr/m! esc+ op, ;
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
  !opsize=  dup .size dup immsize! wide+ #BYTE > 8and $B0+ swap .code + nip op, ;
: movmem<imm ( imm mem )
  !address !opsize=  0 reg! dup .size dup immsize! #WORD < $C7+ swap stdmodr/m! nip op, ;
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
: movxop ( r/m8|16 reg / opc )  esc+ -rot over .size #BYTE = if  movxbyte  else  movxword  then ;
: pkmmxop1 ( mxr/m64 mmxreg opc )  swap reg!  swap mxr/m64! mmxop+ op, ;
: pkxmmop1 ( xmr/m64 xmmreg opc )  swap reg!  swap xmr/m128! 66+ op, ;
: packop1 ( mxr/m64 mmxreg | xmr/m128 xmmreg / opc )  2 !args  esc+  over mmxreg? if  pkmmxop1  else
  over xmmreg? if pkxmmop1 else  2drop drop INVALID_OPERAND_COMBINATION$ error  cleanup  then then ;
: pkmmxop2 ( mxr/m64 mmxreg opc1 opc2 )  rot reg!  rot mxr/m64! mmxop+ 2op, ;
: pkxmmop2 ( xmr/m64 xmmreg opc1 opc2 )  rot reg!  rot xmr/m128! 66+ 2op, ;
: packop2 ( mxr/m64 mmxreg | xmr/m128 xmmreg / opc1 opc2 )
  2 !args  esc+  2pick mmxreg? if  pkmmxop2  else  2pick xmmreg? if  pkxmmop2  else
    4drop INVALID_OPERAND_COMBINATION$ error  cleanup  then  then ;
: pkmmxop3 ( imm8 mxr/m64 mmxreg opc1 opc2 )  rot reg! rot mxr/m64! mmxop+ rot !imm8 drop 2op, ;
: pkxmmop3 ( imm8 xmr/m64 xmmreg opc1 opc2 )  rot reg! rot xmr/m128! 66+ rot !imm8 drop 2op, ;
: packop3 ( imm8 mxr/m64 mmxreg | imm8 xmr/m128 xmmreg / opc1 opc2 )
  3 !args  esc+  2pick mmxreg? if  pkmmxop3  else  2pick xmmreg? if  pkxmmop3  else
    4drop INVALID_OPERAND_COMBINATION$ error  cleanup  then  then ;
: pextrwr/m ( imm8 xmmreg r/m16 )  !stdr/m16+ modr/m! xmreg! !imm8 drop 66+ $C5 op, ;
: pextrwmmx ( imm8 mmxreg reg ) !stdreg16+ reg! !mmxreg mxr/m64! mmxop+ !imm8 drop $C5 op, ;
: pextrwxmm ( imm8 xmmreg reg ) !stdreg16+ reg! !xmmreg xmr/m128! !imm8 drop 66+ $3A $15 2op, ;
: pinsrwmmx ( imm8 r32/m16 mmx )  !mmxreg reg!  modr32/m16! !imm8 drop $C4 op, ;
: pinsrwxmm ( imm8 r32/m16 xmm )  !xmmreg reg!  modr32/m16! !imm8 drop 66+ $C4 op, ;
: pmovmbmmx ( mxreg r32|64 )  swap mxreg! !stdreg32+ op>opsize! modr/m! $D7 op, ;
: pmovmbxmm ( xmreg r32|64 )  swap xmreg! !stdreg32+ op>opsize! modr/m! 66+ $D7 op, ;
: pushpopreg ( reg opc )  8* $58 r- swap op>opsize! T.ADDRSIZE !=opsize  noREX+ .code + op, ;
: pushpopseg ( segreg opc )  swap .code 8* 7+ over - swap unless  dup $0F=if
    CANNOT_POP_CS$ error  then then  dup $20>if  esc+ $7A+  then op, ;
: pushpopr/m ( r/m opc )
  dup 6* reg! $70* $8F+ swap op>opsize! T.ADDRSIZE !=opsize noREX+ !stdr/m16+ modr/m! op, ;
: pushpopimm ( imm opc )  unless  CANNOT_POP_CONSTANT$ error  then
  drop $68 immsize@ dup #DWORD min opsize! #BYTE = 2and + op, ;
: pushpop ( ... / opc )  1 !args  over stdreg? if  pushpopreg  else  over segreg? if
  pushpopseg  else  over address? if  pushpopr/m  else  over immediate? if  pushpopimm  else
    2drop INVALID_OPERAND_TYPE$ error cleanup  then then then then ;
: prefetchop ( mem8 / opc )  1 !args esc+ reg! !address modr/m! $18 op, ;
: xshiftop  ( imm8 xmm1 / op1 op2 )  2 !args esc+ reg! -rot !xmreg xmr/m128! !imm8 drop 66+ op, ;
: pshmmxop1 ( imm mmxreg opc )
  swap mxr/m64! mmxop+ dup $38 and 3u>> reg! 7and $70+ swap !imm8 drop op, ;
: pshxmmop1 ( imm xmmreg opc )
  swap xmr/m128! 66+ dup $38 and 3u>> reg! 7and $70+ swap !imm8 drop op, ;
: pshopimm  ( imm mmxreg|xmmreg opc )  over mmxreg? if  pshmmxop1 else
  over xmmreg? if  pshxmmop1 else drop 2drop INVALID_OPERAND_COMBINATION$ error cleanup then then ;
: pshiftop1  ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg / opc )  2 !args esc+ 2 pick immediate? if
  pshopimm  else  over mmxreg? if  pkmmxop1  else  over xmmreg? if  pkxmmop1  else
    2drop drop INVALID_OPERAND_COMBINATION$ error  cleanup  then then then ;
: shrotop, ( r/m ) over .size #BYTE > - swap op>opsize! stdmodr/m! op, ;
: shrotop ( CL|imm8 r/m / opc )
  2 !args  reg! swap dup immediate? if imm@ 1=if drop imm- $D0 shrotop, else  drop $C0 shrotop, then
    else  $1D10001=if $D2 shrotop, else  drop INVALID_OPERAND_COMBINATION$ error cleanup then then ;
: shrotop2 ( CL|imm8 reg r/m / opc )
  3 !args esc+ -rot !opsize= op>opsize! stdmodr/m! !stdreg16+ stdreg! over $1D10001=if  nip 1+ else
    swap immediate? unless  INVALID_OPERAND_COMBINATION$ error cleanup then  then  op, ;
: ret0 ( )  0 !args  far? 8and $C3+ op, ;
: retn ( imm16 )  1 !args  !imm16 drop  $C2 far? 8and + op, ;
: testop-immacc  ( imm acc -- )  2 !args !opsize= size>immsize .size #WORD < $A9+ nip op, ;
: testop-immr/m  ( imm r/m -- )
  2 !args !opsize size>immsize  $F7 over .size #BYTE = + swap  0 r/mreg! nip op, ;
: testop-imm ( imm r/m -- )  2 !args dup accu? if  testop-immacc  else  testop-immr/m  then ;
: testop-reg ( reg r/m -- )  2 !args !opsize=  stdmodr/m! dup stdreg! >opsize $84+ nip op, ;
: testop-mem ( mem reg -- )  2 !args !opsize=  over stdmodr/m! stdreg! >opsize $84+ nip op, ;
: testop ( ... )  2 !args 2dup imm>r/m? if testop-imm else 2dup reg>r/m? if testop-reg else
    2drop INVALID_OPERAND_COMBINATION$ error cleanup then then ;
: xchgop ( reg r/m | r/m reg )  2 !args !opsize=  dup address? if swap then  over accu? if swap then
  op>opsize!  over register? over accu? and over .size #BYTE > and if  drop .code $90+  else
    $87 over .size #BYTE = + -rot stdreg! stdmodr/m!  then  op, ;

: ADP+ ( n -- ) ( cr ." ADP+ " ADP @ . ) ADP +! ( ADP @ . ) ;
: ADP- ( n -- ) ( cr ." ADP- " ADP @ . ) ADP -! ( ADP @ . ) ;

( Initializes the forcembler. )
: initA4 ( -- )  tick .error ERROR-HANDLER ! ;
vocabulary;
