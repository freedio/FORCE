/** Intel IA-64 Forcembler */

vocabulary Forcembler-IA64
  requires" FORTH.voc"
  requires" IO.voc"
  requires" Heap.voc"
  requires" Referent.voc"
  requires" Vocabulary.voc"
  requires" AsmBase-IA64.voc"

=== Registers ===

--- Regular Registers ---

: AL  00 #REGULAR #BYTE uni register ;
: CL  01 #REGULAR #BYTE uni register ;
: DL  02 #REGULAR #BYTE uni register ;
: BL  03 #REGULAR #BYTE uni register ;
: AH  04 #HI-BYTE #BYTE uni register ;
: CH  05 #HI-BYTE #BYTE uni register ;
: DH  06 #HI-BYTE #BYTE uni register ;
: BH  07 #HI-BYTE #BYTE uni register ;
: SPL  04 #REGULAR #BYTE i64 register ;
: BPL  05 #REGULAR #BYTE i64 register ;
: SIL  06 #REGULAR #BYTE i64 register ;
: DIL  07 #REGULAR #BYTE i64 register ;
: R08L  08 #REGULAR #BYTE i64 register ; alias R8L
: R09L  09 #REGULAR #BYTE i64 register ; alias R9L
: R10L  10 #REGULAR #BYTE i64 register ;
: R11L  11 #REGULAR #BYTE i64 register ;
: R12L  12 #REGULAR #BYTE i64 register ;
: R13L  13 #REGULAR #BYTE i64 register ;
: R14L  14 #REGULAR #BYTE i64 register ;
: R15L  15 #REGULAR #BYTE i64 register ;

: AX  00 #REGULAR #WORD i16 register ;
: CX  01 #REGULAR #WORD i16 register ;
: DX  02 #REGULAR #WORD i16 register ;
: BX  03 #REGULAR #WORD i16 register ;
: SP  04 #REGULAR #WORD i16 register ;
: BP  05 #REGULAR #WORD i16 register ;
: SI  06 #REGULAR #WORD i16 register ;
: DI  07 #REGULAR #WORD i16 register ;
: R08W  08 #REGULAR #WORD i64 register ;
: R09W  09 #REGULAR #WORD i64 register ;
: R10W  10 #REGULAR #WORD i64 register ;
: R11W  11 #REGULAR #WORD i64 register ;
: R12W  12 #REGULAR #WORD i64 register ;
: R13W  13 #REGULAR #WORD i64 register ;
: R14W  14 #REGULAR #WORD i64 register ;
: R15W  15 #REGULAR #WORD i64 register ;

: EAX  00 #REGULAR #DWORD i32 register ;
: ECX  01 #REGULAR #DWORD i32 register ;
: EDX  02 #REGULAR #DWORD i32 register ;
: EBX  03 #REGULAR #DWORD i32 register ;
: ESP  04 #REGULAR #DWORD i32 register ;
: EBP  05 #REGULAR #DWORD i32 register ;
: ESI  06 #REGULAR #DWORD i32 register ;
: EDI  07 #REGULAR #DWORD i32 register ;
: R08D  08 #REGULAR #DWORD i64 register ; alias R8D
: R09D  09 #REGULAR #DWORD i64 register ; alias R9D
: R10D  10 #REGULAR #DWORD i64 register ;
: R11D  11 #REGULAR #DWORD i64 register ;
: R12D  12 #REGULAR #DWORD i64 register ;
: R13D  13 #REGULAR #DWORD i64 register ;
: R14D  14 #REGULAR #DWORD i64 register ;
: R15D  15 #REGULAR #DWORD i64 register ;

: RAX  00 #REGULAR #QWORD i64 register ;
: RCX  01 #REGULAR #QWORD i64 register ;
: RDX  02 #REGULAR #QWORD i64 register ;
: RBX  03 #REGULAR #QWORD i64 register ;
: RSP  04 #REGULAR #QWORD i64 register ;
: RBP  05 #REGULAR #QWORD i64 register ;
: RSI  06 #REGULAR #QWORD i64 register ;
: RDI  07 #REGULAR #QWORD i64 register ;
: R08  08 #REGULAR #QWORD i64 register ; alias R8
: R09  09 #REGULAR #QWORD i64 register ; alias R9
: R10  10 #REGULAR #QWORD i64 register ;
: R11  11 #REGULAR #QWORD i64 register ;
: R12  12 #REGULAR #QWORD i64 register ;
: R13  13 #REGULAR #QWORD i64 register ;
: R14  14 #REGULAR #QWORD i64 register ;
: R15  15 #REGULAR #QWORD i64 register ;

--- Segment Registers ---

: ES  00 #SEGMENT #WORD uni register ;
: CS  01 #SEGMENT #WORD uni register ;
: SS  02 #SEGMENT #WORD uni register ;
: DS  03 #SEGMENT #WORD uni register ;
: FS  04 #SEGMENT #WORD uni register ;
: GS  05 #SEGMENT #WORD uni register ;

--- Control Registers ---

: CR0  00 #CONTROL #DWORD ext register ;
: CR1  01 #CONTROL #DWORD ext register ;
: CR2  02 #CONTROL #DWORD ext register ;
: CR3  03 #CONTROL #DWORD ext register ;
: CR4  04 #CONTROL #DWORD ext register ;
: CR5  05 #CONTROL #DWORD ext register ;
: CR6  06 #CONTROL #DWORD ext register ;
: CR7  07 #CONTROL #DWORD ext register ;
: CR8  08 #CONTROL #DWORD i64 register ;
: CR9  09 #CONTROL #DWORD i64 register ;
: CR10  10 #CONTROL #DWORD i64 register ;
: CR11  11 #CONTROL #DWORD i64 register ;
: CR12  12 #CONTROL #DWORD i64 register ;
: CR13  13 #CONTROL #DWORD i64 register ;
: CR14  14 #CONTROL #DWORD i64 register ;
: CR15  15 #CONTROL #DWORD i64 register ;

--- Debug Registers ---

: DR0  00 #DEBUG #DWORD ext register ;
: DR1  01 #DEBUG #DWORD ext register ;
: DR2  02 #DEBUG #DWORD ext register ;
: DR3  03 #DEBUG #DWORD ext register ;
: DR4  04 #DEBUG #DWORD ext register ;
: DR5  05 #DEBUG #DWORD ext register ;
: DR6  06 #DEBUG #DWORD ext register ;
: DR7  07 #DEBUG #DWORD ext register ;
: DR8  08 #DEBUG #DWORD i64 register ;
: DR9  09 #DEBUG #DWORD i64 register ;
: DR10  10 #DEBUG #DWORD i64 register ;
: DR11  11 #DEBUG #DWORD i64 register ;
: DR12  12 #DEBUG #DWORD i64 register ;
: DR13  13 #DEBUG #DWORD i64 register ;
: DR14  14 #DEBUG #DWORD i64 register ;
: DR15  15 #DEBUG #DWORD i64 register ;

--- FPU Registers ---

: ST0  00 #FLOATING #TBYTE x87 register ; alias ST(0)
: ST1  01 #FLOATING #TBYTE x87 register ; alias ST(1)
: ST2  02 #FLOATING #TBYTE x87 register ; alias ST(2)
: ST3  03 #FLOATING #TBYTE x87 register ; alias ST(3)
: ST4  04 #FLOATING #TBYTE x87 register ; alias ST(4)
: ST5  05 #FLOATING #TBYTE x87 register ; alias ST(5)
: ST6  06 #FLOATING #TBYTE x87 register ; alias ST(6)
: ST7  07 #FLOATING #TBYTE x87 register ; alias ST(7)

--- MMX Registers ---

: MM0  00 #MMX #QWORD mmx register ;
: MM1  01 #MMX #QWORD mmx register ;
: MM2  02 #MMX #QWORD mmx register ;
: MM3  03 #MMX #QWORD mmx register ;
: MM4  04 #MMX #QWORD mmx register ;
: MM5  05 #MMX #QWORD mmx register ;
: MM6  06 #MMX #QWORD mmx register ;
: MM7  07 #MMX #QWORD mmx register ;

--- XMM Registers ---

: XMM0  00 #XMM #OWORD xmm register ;
: XMM1  01 #XMM #OWORD xmm register ;
: XMM2  02 #XMM #OWORD xmm register ;
: XMM3  03 #XMM #OWORD xmm register ;
: XMM4  04 #XMM #OWORD xmm register ;
: XMM5  05 #XMM #OWORD xmm register ;
: XMM6  06 #XMM #OWORD xmm register ;
: XMM7  07 #XMM #OWORD xmm register ;
: XMM8  08 #XMM #OWORD i64 register ;
: XMM9  09 #XMM #OWORD i64 register ;
: XMM10  10 #XMM #OWORD i64 register ;
: XMM11  11 #XMM #OWORD i64 register ;
: XMM12  12 #XMM #OWORD i64 register ;
: XMM13  13 #XMM #OWORD i64 register ;
: XMM14  14 #XMM #OWORD i64 register ;
: XMM15  15 #XMM #OWORD i64 register ;

=== Addresses ===

--- 16-bit addresses ---

: [BX+SI]  00 #INDEXED 0 i16 address ;
: [BX+DI]  01 #INDEXED 0 i16 address ;
: [BP+SI]  02 #INDEXED 0 i16 address ;
: [BP+DI]  03 #INDEXED 0 i16 address ;
: [SI]  04 #INDEXED 0 i16 address ;
: [DI]  05 #INDEXED 0 i16 address ;
: [BP]  06 #INDEXED %MOD01 + 0 i16 address ;
: [BX]  07 #INDEXED 0 i16 address ;

--- 32-bit Addresses ---

: [EAX]  00 #LINEAR 0 i32 address ;
: [ECX]  01 #LINEAR 0 i32 address ;
: [EDX]  02 #LINEAR 0 i32 address ;
: [EBX]  03 #LINEAR 0 i32 address ;
: [ESP]  04 #LINEAR %BASEADDR + 0 i32 address ;
: [EBP]  05 #LINEAR %MOD01 + 0 i32 address ;
: [ESI]  06 #LINEAR 0 i32 address ;
: [EDI]  07 #LINEAR 0 i32 address ;
: [D08]  08 #LINEAR 0 i32 address ; alias [D8]
: [D09]  09 #LINEAR 0 i32 address ; alias [D9]
: [D10]  10 #LINEAR 0 i32 address ;
: [D11]  11 #LINEAR 0 i32 address ;
: [D12]  12 #LINEAR %BASEADDR + 0 i32 address ;
: [D13]  13 #LINEAR %MOD01 + 0 i32 address ;
: [D14]  14 #LINEAR 0 i32 address ;
: [D15]  15 #LINEAR 0 i32 address ;

--- 64-bit Addresses ---

: [RAX]  00 #LINEAR 0 i64 address ;
: [RCX]  01 #LINEAR 0 i64 address ;
: [RDX]  02 #LINEAR 0 i64 address ;
: [RBX]  03 #LINEAR 0 i64 address ;
: [RSP]  04 #LINEAR %BASEADDR + 0 i64 address ;
: [RBP]  05 #LINEAR %MOD01 + 0 i64 address ;
: [RSI]  06 #LINEAR 0 i64 address ;
: [RDI]  07 #LINEAR 0 i64 address ;
: [R08]  08 #LINEAR 0 i64 address ; alias [R8]
: [R09]  09 #LINEAR 0 i64 address ; alias [R9]
: [R10]  10 #LINEAR 0 i64 address ;
: [R11]  11 #LINEAR 0 i64 address ;
: [R12]  12 #LINEAR %BASEADDR + 0 i64 address ;
: [R13]  13 #LINEAR %MOD01 + 0 i64 address ;
: [R14]  14 #LINEAR 0 i64 address ;
: [R15]  15 #LINEAR 0 i64 address ;

--- Scales ---

: *1 0 scale ;
: *2 1 scale ;
: *4 2 scale ;
: *8 3 scale ;

--- Direct Memory ---

: [] ( &r -- )  T.ADDRSIZE
   #WORD =?if  drop 6 #DIRECT 0 i16 makeDirect  #WORD dispsize!  else
  #DWORD =?if  drop 5 #DIRECT 0 i32 makeDirect #DWORD dispsize!  else
  #QWORD =?if  drop $45 #INDEXED %MOD00 or 0 i64 makeDirect #DWORD dispsize!  else
  INVALID_TARGET_ARCHITECTURE$ error!  then then then op#1+! ;
: [RIP] ( disp -- )  T.ARCH i64 = unless  RIP_64_ONLY$ error  then
  5 #DIRECT 0 i64 makeDirect  #DWORD dispsize! op#1+! ;
: # ( n -- )  nsize makeImmediate op#1+! ;
: u# ( u -- )  usize  makeUmmediate op#1+! ;
: &# ( &r -- )  dup reloc! reloc+ &here &− DWORD makeImmediate op#1+! ;

: PTR ( # -- )  width>size sizex! ;
: FAR ( -- )  far+ ;
: NEAR ( -- )  near+ ;

=== Instructions ===

hex
: CS:  2E segprefix ;
: DS:  3E segprefix ;
: ES:  26 segprefix ;
: FS:  64 segprefix ;
: GS:  65 segprefix ;
: SS:  36 segprefix ;
: UNLIKELY ( branch hint for ?JMP )  2E c, ;
: LIKELY ( branch hint ?JMP )  3E c, ;
: AAA  37 op00L ;                     ( )
: AAD  D5 op01L ;                     ( [imm] )
: AAM  D4 op01L ;                     ( [imm] )
: AAS  3F op00L ;                     ( )
: ADC  02 logarop ;                   ( ... )
: ADD  00 logarop ;                   ( ... )
: ADDPD  58 66 xmop01a ;              ( xmr/m128 xmreg )
: ADDPS  58 00 xmop01a ;              ( xmr/m128 xmreg )
: ADDSD  58 F2 xmop01b ;              ( xmr/m64 xmreg )
: ADDSS  58 F3 xmop01c ;              ( xmr/m32 xmreg )
: ADDSUBPD  D0 66 xmop01a ;           ( xmr/m128 xmreg )
: ADDSUBPS  D0 F2 xmop01a ;           ( xmr/m128 xmreg )
: AESDEC  38 DE 66 xmop02a ;          ( xmr/m128 xmreg )
: AESDECLAST  38 DF 66 xmop02a ;      ( xmr/m128 xmreg )
: AESENC  38 DC 66 xmop02a ;          ( xmr/m128 xmreg )
: AESENCLAST  38 DD 66 xmop02a ;      ( xmr/m128 xmreg )
: AESIMC  38 DB 66 xmop02a ;          ( xmr/m128 xmreg )
: AESKEYGENASSIST  3A DF 66 xmop03a ; ( imm8 xmr/m128 xmreg )
: AND  04 logarop ;                   ( ... )
: ANDPD  54 66 xmop01a ;              ( xmr/m128 xmreg )
: ANDPS  54 00 xmop01a ;              ( xmr/m128 xmreg )
: ANDNPD  55 66 xmop01a ;             ( xmr/m128 xmreg )
: ANDNPS  55 00 xmop01a ;             ( xmr/m128 xmreg )
: ARPL ( reg16 r/m16 )  !opsize= !wordop !r/m modr/m! !wordop !register reg! 63 !legacy op, ;
: BLENDPD  3A 0D 66 xmop03a ;         ( imm8 xmr/m128 xmreg )
: BLENDPS  3A 0C 66 xmop03a ;         ( imm8 xmr/m128 xmreg )
: BLENDVPD  38 15 66 xmop02a ;        ( xmr/m128 xmreg )
: BLENDVPS  38 14 66 xmop02a ;        ( xmr/m128 xmreg )
: BOUND ( mem16|32 reg16|32 )  !legacy !opsize= ![d]wordop  !register reg! !address modr/m! 62 op, ;
: BSF  BC bitscop ;                   ( r/m reg )
: BSR  BD bitscop ;                   ( r/m reg )
: BSWAP ( reg32|64 )  !>486 !d|qwordop op>opsize! !register modr/m!  1 reg!  0F op, ;
: BT  4 bitop ;                       ( imm|reg r/m )
: BTC  7 bitop ;                      ( imm|reg r/m )
: BTR  6 bitop ;                      ( imm|reg r/m )
: BTS  5 bitop ;                      ( imm|reg r/m )
: CALL  0 jmpcall ;                   ( addr )
: CBW  #WORD cvop01 ;                 ( )
: CWDE  #DWORD cvop01 ;               ( )
: CDQE  #QWORD cvop01 ;               ( )
: CLC  F8 op00 ;                      ( )
: CLD  FC op00 ;                      ( )
: CLFLUSH ( mem8 )  !>586 !address esc+  7 reg! modr/m!  AE op, ;
: CLI  FA op00 ;                      ( )
: CLTS  06 op0F ;                     ( )
: CMC  F5 op00 ;                      ( )
: ?MOV ( r/m reg cond ) 3 !args !>586 esc+ !opsize= -rot op>opsize! stdreg! modr/m! .code 40 + op, ;
: CMP  07 logarop ;                   ( ... )
: CMPPD  C2 66 xmop01a ;              ( xmr/m128 xmreg )
: CMPPS  C2 00 xmop01a ;              ( xmr/m128 xmreg )
: CMPSD  C2 F2 xmop01b ;              ( xmr/m64 xmreg )
: CMPSS  C2 F3 xmop01c ;              ( xmr/m32 xmreg )
: CMPS  A6 strop ;                    ( size )
: CMPXCHG ( reg r/m )  2 !args  esc+ !opsize=
  dup .size #BYTE = B1 + -rot swap op>opsize! stdreg! modr/m! op, ;
: CMPXCHG8B ( mem64 ) esc+ !>586 !addr64 1 reg! modr/m! C7 op, ;
: COMISD  2F 66 xmop01b ;             ( xmr/m64 xmreg )
: COMISS  2F 00 xmop01c ;             ( xmr/m32 xmreg )
: CPUID  A2 op0F ;                    ( )
: CRC32 ( r/m reg )  over .size over .size > if  INVALID_OPERAND_COMBINATION$ error  then
  2 !args !reg32+ op>opsize! stdreg! >opsize $F0 + swap  op>opsize! modr/m! $38 esc+ F2+ swap 2op, ;
: CVTDQ2PD  E6 F3 xmop01b ;           ( xmr/m64 xmreg )
: CVTDQ2PS  5B 00 xmop01a ;           ( xmr/m128 xmreg )
: CVTPD2DQ  E6 F2 xmop01a ;           ( xmr/m128 xmreg )
: CVTPD2PI  2D 66 xmop01a ;           ( xmr/m128 xmreg )
: CVTPD2PS  5A 66 xmop01a ;           ( xmr/m128 xmreg )
: CVTPI2PD  2A 66 xmop01b ;           ( xmr/m64 xmreg )
: CVTPI2PS  2A 00 xmop01b ;           ( xmr/m64 xmreg )
: CVTPS2DQ  5B 66 xmop01a ;           ( xmr/m128 xmreg )
: CVTPS2PD  5A 00 xmop01b ;           ( xmr/m64 xmreg )
: CVTPS2PI  2D 00 xmop01b ;           ( xmr/m64 xmreg )
: CVTSD2SI  2D F2 xmop04a ;           ( xmr/m64 reg32|64 )
: CVTSD2SS  5A F2 xmop01b ;           ( xmr/m64 xmreg )
: CVTSI2SD  2A F2 xmop04c ;           ( r/m32|64 xmreg )
: CVTSI2SS  2A F3 xmop04c ;           ( r/m32|64 xmreg )
: CVTSS2SD  5A F3 xmop01c ;           ( xmr/m32 xmreg )
: CVTSS2SI  2D F3 xmop04b ;           ( xmr/m32 reg32|64 )
: CVTTPD2DQ  E6 66 xmop01a ;          ( xmr/m128 xmreg )
: CVTTPD2PI  2C 66 xmop01a ;          ( xmr/m128 xmreg )
: CVTTPS2DQ  5B F3 xmop01a ;          ( xmr/m128 xmreg )
: CVTTPS2PI  2C 00 xmop01b ;          ( xmr/m64 xmreg )
: CVTTSD2SI  2C F2 xmop04a ;          ( xmr/m64 reg32|64 )
: CVTTSS2SI  2C F3 xmop04b ;          ( xmr/m32 reg32|64 )
: CWD  #WORD cvop02 ;                 ( )
: CDQ  #DWORD cvop02 ;                ( )
: CQO  #QWORD cvop02 ;                ( )
: DAA  27 op00L ;                     ( )
: DAS  2F op00L ;                     ( )
: DEC  1 incdecop ;                   ( r/m )
: DIV  6 arithop ;                    ( r/m )
: DIVPD  5E 66 xmop01a ;              ( xmr/m128 xmreg )
: DIVPS  5E 00 xmop01a ;              ( xmr/m128 xmreg )
: DIVSD  5E F2 xmop01b ;              ( xmr/m64 xmreg )
: DIVSS  5E F3 xmop01c ;              ( xmr/m32 xmreg )
: DPPD  3A 41 66 xmop03a ;            ( imm8 xmr/m128 xmreg )
: DPPS  3A 40 66 xmop03a ;            ( imm8 xmr/m128 xmreg )
: EMMS  77 op0F ;                     ( )
: ENTER ( imm8 imm16 )
  1 !args !imm16 drop  adepth 1 u< if  MISSING_NESTING_LEVEL$ error cleanup exit  then
  validate prefices, $C8 c, #WORD opsize! operands,
  dup 0 32 within unless  NESTLEVEL_OPERAND_EXPECTED$ error  then  c,  cleanup ;
: EXTRACTPS  3A 17 66 xmop03d ;       ( imm8 xmreg r/m32 )
: F2XM1  F0 flop01 ;                  ( ) alias F2^X-1
: FABS  E1 flop01 ;                   ( )
: FADD  0 flopar1 ;                   ( STn/mem32|64 )
: RFADD  0 flopar0 ;                  ( STn )
: FADDP  0 flopar2 ;                  ( [STn] )
: FIADD  0 flopar3 ;                  ( mem16|32 )
: FBLD  4 fbcdop ;                    ( mem80 )
: FBSTP  6 fbcdop ;                   ( mem80 )
: FCHS  E0 flop01 ;                   ( )
: FWAIT ( )  !fpu $9B c, ; alias WAIT
: FNCLEX ( )  0 !args  !fpu $DB c, $E2 op, ;
: FCLEX ( )  FWAIT FNCLEX ;
: ?FMOV ( STn cond )
  !fpu 2 !args !condition .code cond>fcond 4/mod $DA + -rot reg! !fpureg modr/m! op, ;
: FCOMI  06 fcomop ;                  ( STn )
: FCOMIP  46 fcomop ;                 ( STn )
: FUCOMI  05 fcomop ;                 ( STn )
: FUCOMIP  45 fcomop ;                ( STn )
: FCOS  FF flop01 ;                   ( )
: FDECSTP  F6 flop01 ;                ( )
: FDIV  6 flopar1 ;                   ( STn/mem32|64 )
: RFDIV  6 flopar0 ;                  ( STn )
: FDIVP  6 flopar2 ;                  ( [STn] )
: FIDIV  6 flopar3 ;                  ( mem16|32 )
: FDIVR  7 flopar1 ;                  ( STn/mem32|64 )
: RFDIVR  7 flopar0 ;                 ( STn )
: FDIVRP  7 flopar2 ;                 ( [STn] )
: FIDIVR  7 flopar3 ;                 ( mem16|32 )
: FFREE ( STn )  !fpu  1 !args  !fpureg  0 reg! modr/m! $DD op, ;
: FICOM  2 flopar4 ;                  ( mem16|32 )
: FICOMP  3 flopar4 ;                 ( mem16|32 )
: FILD  5 0 fildstop ;                ( mem16|32|64 )
: FINCSTP  F7 flop01 ;                ( )
: FNINIT ( )  0 !args  !fpu $DB c, $E3 op, ;
: FINIT ( )  FWAIT FNINIT ;
: FIST  2 fistop ;                    ( mem16|32 )
: FISTP  7 3 fildstop ;               ( mem16|32|64 )
: FISTTP ( mem16|32|64 )  !fpu 1 !args dup addr16? if  1 fildstop16  else  dup addr32? if
  1 fildstop32  else dup addr64? if  1 fisttpop64  else
  drop INVALID_OPERAND_TYPE$ error cleanup  then then then ;
: FLD ( STn/mem32|64|80 )  !fpu 1 !args dup addr32? if  $D9 0  else  dup addr64? if
  $DD 0  else  dup addr80? if  $DB 5  else  dup fpureg? if  $D9 0  else
  INVALID_OPERAND_TYPE$ error 0 0  then then then then  reg! swap modr/m! op, ;
: FLD1  E8 flop01 ;                   ( )
: FLDL2T  E9 flop01 ;                 ( )
: FLDL2E  EA flop01 ;                 ( )
: FLDPI  EB flop01 ;                  ( )
: FLDLG2  EC flop01 ;                 ( )
: FLDLN2  ED flop01 ;                 ( )
: FLDZ  EE flop01 ;                   ( ) alias FLD0
: FLDCW  5 flop02 ;                   ( mem )
: FLDENV  4 flop02 ;                  ( mem )
: FMUL  1 flopar1 ;                   ( STn/mem32|64 )
: RFMUL  1 flopar0 ;                  ( STn )
: FMULP  1 flopar2 ;                  ( [STn] )
: FIMUL  1 flopar3 ;                  ( mem16|32 )
: FNOP  D0 flop01 ;                   ( )
: FPATAN  F3 flop01 ;                 ( )
: FPREM  F8 flop01 ;                  ( )
: FPREM1  F5 flop01 ;                 ( )
: FPTAN  F2 flop01 ;                  ( )
: FRNDINT  FC flop01 ;                ( )
: FRSTOR  4 flop03 ;                  ( mem )
: FNSAVE  6 flop03 ;                  ( mem )
: FSAVE ( mem )  FWAIT FNSAVE ;
: FSCALE  FD flop01 ;                 ( )
: FSIN  FE flop01 ;                   ( )
: FSINCOS  FB flop01 ;                ( )
: FSQRT  FA flop01 ;                  ( )
: FST ( STn/mem32|64)  !fpu 1 !args dup addr32? if  $D9 2  else
  dup addr64? if  $DD 2  else  dup fpureg? if  $DD 2  else
  INVALID_OPERAND_TYPE$ error 0 0  then then then  reg! swap modr/m! op, ;
: FSTP ( STn/mem32|64|80 )  !fpu 1 !args dup addr32? if  $D9 3  else  dup addr64? if
  $DD 3  else  dup addr80? if  $DB 7  else  dup fpureg? if  $DD 3  else
  INVALID_OPERAND_TYPE$ error 0 0  then then then then  reg! swap modr/m! op, ;
: FNSTCW  7 flop02 ;                  ( mem )
: FSTCW ( mem )  FWAIT FNSTCW ;
: FNSTENV  6 flop02 ;                 ( mem )
: FSTENV ( mem )  FWAIT FNSTENV ;
: FNSTSW ( mem | AX )
  !fpu 1 !args dup AX = if  $DF 4  else  !address $DD 7  then  reg! swap modr/m! op, ;
: FSTSW ( mem | AX )  FWAIT FNSTSW ;
: FSUB  4 flopar1 ;                   ( STn/mem32|64 )
: RFSUB  4 flopar0 ;                  ( STn )
: FSUBP  4 flopar2 ;                  ( [STn] )
: FISUB  4 flopar3 ;                  ( mem16|32 )
: FSUBR  5 flopar1 ;                  ( STn/mem32|64 )
: RFSUBR  5 flopar0 ;                 ( STn )
: FSUBRP  5 flopar2 ;                 ( [STn] )
: FISUBR  5 flopar3 ;                 ( mem16|32 )
: FTST  E4 flop01 ;                   ( )
: FUCOM ( [STn] )  !fpu  op#@ 0= if  ST(1)  then  1 !args  4 reg! !fpureg modr/m!  $DD op, ;
: FUCOMP ( [STn] )  !fpu  op#@ 0= if  ST(1)  then  1 !args  5 reg! !fpureg modr/m!  $DD op, ;
: FUCOMPP ( )  !fpu  ST(1)  1 !args  5 reg! !fpureg modr/m!  $DA op, ;
: FXAM  E5 flop01 ;                   ( )
: FXCH ( [STn] )  !fpu op#@ 0= if  ST(1)  then  1 !args  1 reg! !fpureg modr/m!  $D9 op, ;
: FXRSTOR  1 fxenvop ;                ( mem )
: FXSAVE  0 fxenvop ;                 ( mem )
: FXRSTOR64  1 fxenvop64 ;            ( mem )
: FXSAVE64  0 fxenvop64 ;             ( mem )
: FXTRACT  F4 flop01 ;                ( )
: FYL2X  F1 flop01 ;                  ( )
: FYL2XP1  F9 flop01 ;                ( )
: HADDPD  7C 66 xmop01a ;             ( xmr/m128 xmreg )
: HADDPS  7C F2 xmop01a ;             ( xmr/m128 xmreg )
: HLT  F4 op00 ;                      ( )
: HSUBPD  7D 66 xmop01a ;             ( xmr/m128 xmreg )
: HSUBPS  7D F2 xmop01a ;             ( xmr/m128 xmreg )
: IDIV  7 arithop ;                   ( r/m )
: IMUL ( [imm] r/m reg | r/m )  op#@
  1=?if  drop 5 (arithop)  else
  2=?if  drop imul2  else
  3=?if  drop imul3  else
  adepth 0 do drop loop  INVALID_OPERAND_COMBINATION$ error cleanup  then then then ;
: IN  0 inoutop ;                     ( imm8|DX accu )
: INC  0 incdecop ;                   ( r/m )
: INS  6C strop ;                     ( size )
: INSERTPS  3A 21 66 xmop03b ;        ( imm8 xmr/m128 xmreg )
: INT ( imm8 )  1 !args  !imm8 drop  imm@ 3 = if  CC c,  else  CD c, imm@ c, then cleanup ;
: INTO  CE op00 ;                     ( )
: INVD  08 op0F ;                     ( )
: INVLPG ( mem )  1 !args !address esc+ 7 reg! modr/m! 01 op, ;
: IRET  ( )  T.ARCH opsize!  CF op, ;
: JMP  1 jmpcall ;                    ( ... )
: ?JMP ( target cond )  2 !args !condition .code 70 + #BYTE &here 2 &+ reladdr  nip op, ;
: LAHF  9F op00 ;                     ( )
: LAR  02 oplp ;                      ( r/m reg )
: LDDQU  F0 F2 xmop01d ;              ( mem128 xmreg )
: LDMXCSR ( mem32 )  1 !args !addr32 2 reg! modr/m! esc+ AE op, ;
: LDS  C5 ldop1 ;                     ( mem reg )
: LES  C4 ldop1 ;                     ( mem reg )
: LFS  B4 ldop2 ;                     ( mem reg )
: LGS  B5 ldop2 ;                     ( mem reg )
: LSS  B2 ldop2 ;                     ( mem reg )
: LEA  8D ldop3 ;                     ( mem reg )
: LEAVE  C9 op00 ;                    ( )
: LFENCE  5 fenceop ;                 ( )
: LGDT  01 02 memop1 ;                ( mem )
: LIDT  01 03 memop1 ;                ( mem )
: LLDT  00 02 memop2 ;                ( r/m16 )
: LMSW  01 06 memop2 ;                ( r/m16 )
: LOCK  F0 op00 ;                     ( )
: LODS  AC strop ;                    ( size )
: LOOP ( target )  1 !args !immediate drop  #BYTE &here 2 &+ reladdr E2 op, ;
: ?LOOP ( target cond )  2 !args ![n]eq E0 + swap !immediate drop #BYTE &here 2 &+ reladdr op, ;
: LSL  03 oplp ;                      ( rx/m16 reg )
: LTR  00 03 memop2 ;                 ( r/m16 )
: MASKMOVDQU  F7 66 xmop01e ;         ( xmreg1 xmreg2 )
: MASKMOVQ  F7 00 mxop01e ;           ( mxreg1 mxreg2 )
: MAXPD  5F 66 xmop01a ;              ( xmr/m128 xmreg )
: MAXPS  5F 00 xmop01a ;              ( xmr/m128 xmreg )
: MAXSD  5F F2 xmop01b ;              ( xmr/m64 xmreg )
: MAXSS  5F F3 xmop01c ;              ( xmr/m32 xmreg )
: MFENCE  6 fenceop ;                 ( )
: MINPD  5D 66 xmop01a ;              ( xmr/m128 xmreg )
: MINPS  5D 00 xmop01a ;              ( xmr/m128 xmreg )
: MINSD  5D F2 xmop01b ;              ( xmr/m64 xmreg )
: MINSS  5D F3 xmop01c ;              ( xmr/m32 xmreg )
: MONITOR ( )  0 !args  1 reg! esc+ 3 mod! 01 op, ;
: MOV ( src tgt )  2 !args  movop ;
: MOVAPD  28 66 xmop05a ;             ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVAPS  28 00 xmop05a ;             ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVBE ( mem reg | reg mem )  2 !args !opsize= esc+ $F0 over address? if  1+ swap  then -rot
  !stdreg16+ stdreg! !address stdmodr/m! $38 swap 2op, ;
: MOVD ( mmx|xmm r/m32 | r/m32 mmx|xmm )
  2 !args esc+ dup mmxreg? if  movd>mmx  else  dup xmmreg? if  movd>xmm  else  over mmxreg? if
  movd<mmx  else  over xmmreg? if  movd<xmm  else
  2 drop INVALID_OPERAND_COMBINATION$ error cleanup  then then then then ;
: MOVDDUP  12 F2 xmop01b ;            ( xmr/m64 xmreg )
: MOVDQA  6F 66 xmop05b ;             ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVDQU  6F F3 xmop05b ;             ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVDQ2Q ( xmreg mxreg )  2 !args  !mmxreg reg! !xmmreg modr/m! F2+ esc+ D6 op, ;
: MOVHLPS  12 00 xmop01e ;            ( xmreg1 xmreg2 )
: MOVHPD  16 66 xmop05c ;             ( mem64 xmreg | xmreg mem64 )
: MOVHPS  16 00 xmop05c ;             ( mem64 xmreg | xmreg mem64 )
: MOVLHPS  16 00 xmop01e ;            ( xmreg1 xmreg2 )
: MOVLPD  12 66 xmop05c ;             ( mem64 xmreg | xmreg mem64 )
: MOVLPS  12 00 xmop05c ;             ( mem64 xmreg | xmreg mem64 )
: MOVMSKPD  50 66 xmop04d ;           ( xmreg reg )
: MOVMSKPS  50 00 xmop04d ;           ( xmreg reg )
: MOVNTDQA  38 2A 66 xmop02e ;        ( mem128 xmreg )
: MOVNTDQ  E7 66 xmop01g ;            ( xmreg mem128 )
: MOVNTI ( reg mem )  2 !args swap !opsize= op>opsize! !reg32+ reg! modr/m! esc+ C3 op, ;
: MOVNTPD  2B 66 xmop01g ;            ( xmreg mem128 )
: MOVNTPS  2B 00 xmop01g ;            ( xmreg mem128 )
: MOVNTQ  E7 00 mxop01g ;             ( mxreg mem64 )
: MOVQ ( mmx|xmm r/m64 | r/m64 mmx|xmm )
  2 !args esc+ dup mmxreg? if  movq>mmx  else  dup xmmreg? if  movq>xmm  else  over mmxreg? if
  movq<mmx  else  over xmmreg? if  movq<xmm  else
  2 drop INVALID_OPERAND_COMBINATION$ error cleanup  then then then then ;
: MOVQ2DQ ( mxreg xmreg )  2 !args  !xmmreg reg! !mmxreg modr/m! F3+ esc+ D6 op, ;
: MOVS  A4 strop ;                    ( size )
: MOVSD  10 F2 xmop05d ;              ( xmr/m64 xmreg | xmreg xmr/m64 )
: MOVSHDUP  16 F3 xmop01a ;           ( xmr/m128 xmreg )
: MOVSLDUP  12 F3 xmop01a ;           ( xmr/m128 xmreg )
: MOVSS  10 F3 xmop05e ;              ( xmr/m32 xmreg | xmreg xmr/m32 )
: MOVSX  BE movxop ;                  ( r/m reg )
: MOVSXD ( r/m32 reg64 )  2 !args op>opsize! !reg64 stdreg!  !r/m32 stdmodr/m!  63 op, ;
: MOVUPD  10 66 xmop05a ;             ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVUPS  10 00 xmop05a ;             ( xmr/m128 xmreg | xmreg xmr/m128 )
: MOVZX  B6 movxop ;                  ( r/m reg )
: MPSADBW  3A 42 66 xmop03a ;         ( imm8 xmr/m128 xmreg )
: MUL  4 arithop ;                    ( r/m )
: MULPD  59 66 xmop01a ;              ( xmr/m128 xmreg )
: MULPS  59 00 xmop01a ;              ( xmr/m128 xmreg )
: MULSD  59 F2 xmop01b ;              ( xmr/m64 xmreg )
: MULSS  59 F3 xmop01c ;              ( xmr/m32 xmreg )
: MWAIT ( )  0 !args  1 reg! esc+ 3 mod! 1 r/m! 01 op, ;
: NEG  3 arithop ;                    ( r/m )
100 bloat
: NOP ( [n] )  op#@ unless  1 #  then  1 !args  drop
  imm@ 1 10 within unless  INVALID_NOP_SIZE$ error cleanup exit  then
  T.ARCH i16 = if  imm@ 1- if  NOP#_NOT_SUPPORTED$ error cleanup exit  then  90 c,  else  imm@
    1=?if  drop  90 c,  cleanup exit  then
    2=?if  drop  66 c, 90 c,  cleanup exit  then
    3=?if  drop  0F c, 1F c, 00 c,  cleanup exit  then
    4=?if  drop  0F c, 1F c, 40 c, 00 c,  cleanup exit  then
    5=?if  drop  0F c, 1F c, 44 c, 00 c, 00 c,  cleanup exit  then
    6=?if  drop  66 c, 0F c, 1F c, 44 c, 00 c, 00 c,  cleanup exit  then
    7=?if  drop  0F c, 1F c, 80 c, 00 c, 00 c, 00 c, 00 c,  cleanup exit  then
    8=?if  drop  0F c, 1F c, 84 c, 00 c, 00 c, 00 c, 00 c, 00 c,  cleanup exit  then
    9=?if  drop  66 c, 0F c, 1F c, 84 c, 00 c, 00 c, 00 c, 00 c, 00 c,  cleanup exit  then
    INVALID_NOP_SIZE$ error  cleanup  then ;
: NOT  2 arithop ;                    ( r/m )
: OR  1 logarop ;                     ( ... )
: ORPD  56 66 xmop01a ;               ( xmr/m128 xmreg )
: ORPS  56 00 xmop01a ;               ( xmr/m128 xmreg )
: OUT  2 inoutop ;                    ( accu imm8|DX )
: OUTS  6E strop ;                    ( size )
: PABSB  38 1C packop2 ;              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PABSW  38 1D packop2 ;              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PABSD  38 1E packop2 ;              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PACKSSWB  63 packop1 ;              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PACKSSDW  6B packop1 ;              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PACKUSDW  38 2B 66 xmop02a ;        ( xmr/m128 xmmreg )
: PACKUSWB  67 packop1 ;              ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDB  FC packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDW  FD packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDD  FE packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDQ  D4 packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDSB  EC packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDSW  ED packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDUSB  DC packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PADDUSW  DD packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PALIGNR  3A 0F packop3 ;            ( imm8 mxr/m64 mmxreg | imm8 xmr/m128 xmmreg )
: PAND  DB packop1 ;                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PANDN  DF packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PAUSE F3+ 90 op, ;                  ( )
: PAVGB  E0 packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PAVGW  E3 packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PBLENDVB  38 10 66 xmop02a ;        ( xmr/m128 xmreg )
: PBLENDW  3A 0E 66 xmop03a ;         ( imm8 xmr/m128 xmmreg )
: PCLMULQDQ  3A 44 66 xmop03a ;       ( imm8 xmr/m128 xmmreg )
: PCMPEQB  74 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PCMPEQW  75 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PCMPEQD  76 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PCMPEQQ  38 29 66 xmop02a ;         ( xmr/m128 xmreg )
: PCMPESTRI  3A 61 66 xmop03a ;       ( imm8 xmr/m128 xmmreg )
: PCMPESTRM  3A 60 66 xmop03a ;       ( imm8 xmr/m128 xmmreg )
: PCMPGTB  64 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PCMPGTW  65 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PCMPGTD  66 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PCMPGTQ  38 37 66 xmop02a ;         ( xmr/m128 xmreg )
: PCMPISTRI  3A 63 66 xmop03a ;       ( imm8 xmr/m128 xmmreg )
: PCMPISTRM  3A 62 66 xmop03a ;       ( imm8 xmr/m128 xmmreg )
: PEXTRB  3A 14 66 xmop03e ;          ( imm8 xmmreg r/m8 )
: PEXTRD  3A 16 66 xmop03d ;          ( imm8 xmmreg r/m32 )
: PEXTRQ  3A 16 66 xmop03c ;          ( imm8 xmmreg r/m64 )
: PEXTRW ( imm8 xmm|mm reg )  3 !args  esc+ over mmxreg? if  pextrwmmx  else
  dup address? if  pextrwr/m  else  pextrwxmm  then then ;
: PHADDW  38 01 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PHADDD  38 02 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PHADDSW  38 03 packop2 ;            ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PHMINPOSUW  38 41 66 xmop02a ;      ( xmr/m128 xmreg )
: PHSUBW  38 05 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PHSUBD  38 06 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PHSUBSW  38 07 packop2 ;            ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PINSRB  3A 20 66 xmop03h ;          ( imm8 r32/m8 xmmreg )
: PINSRD  3A 22 66 xmop03g ;          ( imm8 r/m32 xmmreg )
: PINSRQ  3A 22 66 xmop03f ;          ( imm8 r/m64 xmmreg )
: PINSRW ( imm8 r32/m16 xmreg|xmreg )  3 !args esc+ dup mmxreg? if pinsrwmmx else pinsrwxmm then ;
: PMADDUBSW  38 04 packop2 ;          ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMADDWD  F5 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMAXSB  38 3C 66 xmop02a ;          ( xmr/m128 xmreg )
: PMAXSD  38 3D 66 xmop02a ;          ( xmr/m128 xmreg )
: PMAXSW  EE packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMAXUB  DE packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMAXUD  38 3F 66 xmop02a ;          ( xmr/m128 xmreg )
: PMAXUW  38 3E 66 xmop02a ;          ( xmr/m128 xmreg )
: PMINSB  38 38 66 xmop02a ;          ( xmr/m128 xmreg )
: PMINSD  38 39 66 xmop02a ;          ( xmr/m128 xmreg )
: PMINSW  EA packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMINUB  DA packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMINUD  38 3B 66 xmop02a ;          ( xmr/m128 xmreg )
: PMINUW  38 3A 66 xmop02a ;          ( xmr/m128 xmreg )
: PMOVMSKB ( mxreg|xmreg reg )  2 !args esc+ over mmxreg? if  pmovmbmmx  else  pmovmbxmm  then ;
: PMOVSXBW  38 20 66 xmop02b ;        ( xmr/m64 xmmreg )
: PMOVSXBD  38 21 66 xmop02c ;        ( xmr/m32 xmmreg )
: PMOVSXBQ  38 22 66 xmop02d ;        ( xmr/m16 xmmreg )
: PMOVSXWD  38 23 66 xmop02b ;        ( xmr/m64 xmmreg )
: PMOVSXWQ  38 24 66 xmop02c ;        ( xmr/m32 xmmreg )
: PMOVSXDQ  38 25 66 xmop02b ;        ( xmr/m64 xmmreg )
: PMOVZXBW  38 30 66 xmop02b ;        ( xmr/m64 xmmreg )
: PMOVZXBD  38 31 66 xmop02c ;        ( xmr/m32 xmmreg )
: PMOVZXBQ  38 32 66 xmop02d ;        ( xmr/m16 xmmreg )
: PMOVZXWD  38 33 66 xmop02b ;        ( xmr/m64 xmmreg )
: PMOVZXWQ  38 34 66 xmop02c ;        ( xmr/m32 xmmreg )
: PMOVZXDQ  38 35 66 xmop02b ;        ( xmr/m64 xmmreg )
: PMULDQ  38 28 66 xmop02a ;          ( xmr/m128 xmreg )
: PMULHRSW  38 0B packop2 ;           ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMULHUW  E4 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMULHW  E5 packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMULLD  38 40 66 xmop02a ;          ( xmr/m128 xmreg )
: PMULLW  D5 packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PMULUDQ  F4 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: POP  0 pushpop ;                    ( ... )
: POPA  61 op02L ;                    ( )
: POPCNT ( r/m reg )  2 !args !opsize= !stdreg16+ reg! stdmodr/m! F3+ esc+ $B8 op, ;
: POPF  9D op02 ;                     ( )
: POR  EB packop1 ;                   ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PREFETCHT0  1 prefetchop ;          ( mem8 )
: PREFETCHT1  2 prefetchop ;          ( mem8 )
: PREFETCHT2  3 prefetchop ;          ( mem8 )
: PREFETCHNTA  0 prefetchop ;         ( mem8 )
: PSADBW  F6 packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSHUFB  38 00 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSHUFD  70 66 xmop01h ;             ( imm8 xmr/m128 xmmreg )
: PSHUFHW  70 F3 xmop01h ;            ( imm8 xmr/m128 xmmreg )
: PSHUFLW  70 F2 xmop01h ;            ( imm8 xmr/m128 xmmreg )
: PSHUFW  70 00 mxop01h ;             ( imm8 xmr/m128 xmmreg )
: PSIGNB  38 08 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSIGNW  38 09 packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSIGND  38 0A packop2 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSLLDQ  73 07 xshiftop ;            ( imm8 xmm )
: PSLLW  F1 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSLLD  F2 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSLLQ  F3 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSRAW  E1 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSRAD  E2 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSRLDQ  73 03 xshiftop ;            ( imm8 xmm )
: PSRLW  D1 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSRLD  D2 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSRLQ  D3 pshiftop1 ;               ( mxr/m64|imm8 mmxreg | xmr/m128|imm8 xmmreg )
: PSUBB  F8 packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBW  F9 packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBD  FA packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBQ  FB packop1 ;                 ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBSB  E8 packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBSW  E9 packop1 ;                ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBUSB  D8 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PSUBUSW  D9 packop1 ;               ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PTEST  38 17 66 xmop02a ;           ( imm8 xmr/m128 xmmreg )
: PUNPCKHBW  68 packop1 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PUNPCKHWD  69 packop1 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PUNPCKHDQ  6A packop1 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PUNPCKHQDQ  6D 66 xmop01a ;         ( xmr/m128 xmmreg )
: PUNPCKLBW  60 packop1 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PUNPCKLWD  61 packop1 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PUNPCKLDQ  62 packop1 ;             ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: PUNPCKLQDQ  6C 66 xmop01a ;         ( xmr/m128 xmmreg )
: PUSH  1 pushpop ;                   ( ... )
: PXOR  EF packop1 ;                  ( mxr/m64 mmxreg | xmr/m128 xmmreg )
: RCL  2 shrotop ;                    ( CL|imm8 r/m )
: RCR  3 shrotop ;                    ( CL|imm8 r/m )
: ROL  0 shrotop ;                    ( CL|imm8 r/m )
: ROR  1 shrotop ;                    ( CL|imm8 r/m )
: SAL  4 shrotop ;                    ( CL|imm8 r/m )
: SAR  7 shrotop ;                    ( CL|imm8 r/m )
: SHL  4 shrotop ;                    ( CL|imm8 r/m )
: SHR  5 shrotop ;                    ( CL|imm8 r/m )
: RCPPS  53 00 xmop01a ;              ( xmr/m128 xmmreg )
: RCPSS  53 F3 xmop01c ;              ( xmr/m32 xmmreg )
: RDMSR  32 op0F ;                    ( )
: RDPMC  33 op0F ;                    ( )
: RDTSC  31 op0F ;                    ( )
: RDTSCP ( )  esc+ 01 F9 2op, ;
: REP  F3 op00 ;                      ( )
: REPE  F3 op00 ;                     ( )
: REPZ  F3 op00 ;                     ( )
: REPNE  F2 op00 ;                    ( )
: REPNZ  F2 op00 ;                    ( )
: RET ( [imm16] )  op#@ unless  ret0  else  retn  then ;
: ROUNDPD  3A 09 66 xmop03a ;         ( imm8 xmr/m128 xmmreg )
: ROUNDPS  3A 08 66 xmop03a ;         ( imm8 xmr/m128 xmmreg )
: ROUNDSD  3A 0B 66 xmop03i ;         ( imm8 xmr/m64 xmmreg )
: ROUNDSS  3A 0A 66 xmop03b ;         ( imm8 xmr/m32 xmmreg )
: RSM  AA op0F ;                      ( )
: RSQRTPS  52 00 xmop01a ;            ( xmr/m128 xmmreg )
: RSQRTSS  52 F3 xmop01c ;            ( xmr/m32 xmmreg )
: SAHF  9E op00L ;                    ( )
: SBB  3 logarop ;                    ( ... )
: SCAS  AE strop ;                    ( size )
: ?SET ( r/m8 cond ) 2 !args esc+ swap op>opsize! !r/m8 stdmodr/m! .code 90 + op, ;
: SFENCE  7 fenceop ;                 ( )
: SGDT  01 00 memop3 ;                ( mem )
: SHLD  A4 shrotop2 ;                 ( imm8 reg r/m )
: SHRD  AC shrotop2 ;                 ( imm8 reg r/m )
: SHUFPD  C6 66 xmop03z ;             ( imm8 xmr/m32 xmmreg )
: SHUFPS  C6 00 xmop03z ;             ( imm8 xmr/m32 xmmreg )
: SIDT  01 01 memop3 ;                ( mem )
: SLDT  00 00 memop2 ;                ( r/m16 )
: SMSW  01 04 memop2 ;                ( r/m16 )
: SQRTPS  51 00 xmop01a ;             ( xmr/m128 xmmreg )
: SQRTSD  51 F2 xmop01b ;             ( xmr/m64 xmmreg )
: SQRTSS  51 F3 xmop01c ;             ( xmr/m32 xmmreg )
: STC  F9 op00 ;                      ( )
: STD  FD op00 ;                      ( )
: STI  FB op00 ;                      ( )
: STMXCSR ( mem32 )  1 !args !addr32 3 reg! modr/m! esc+ AE op, ;
: STOS  AA strop ;                    ( size )
: STR ( r/m16 )  1 !args 1 reg! !r/m16 modr/m! esc+ 00 op, ;
: SUB  5 logarop ;                    ( ... )
: SUBPD  5C 66 xmop01a ;              ( xmr/m128 xmreg )
: SUBPS  5C 00 xmop01a ;              ( xmr/m128 xmreg )
: SUBSD  5C F2 xmop01b ;              ( xmr/m64 xmreg )
: SUBSS  5C F3 xmop01c ;              ( xmr/m32 xmreg )
: SWAPGS ( )  0 !args  7 reg! esc+ 01 op, ;
: SYSCALL  05 op0F ;                  ( )
: SYSENTER  34 op0F ;                 ( )
: SYSEXIT  35 op02F ;                 ( )
: SYSRET  07 op02F ;                  ( )
: TEST ( ... )  testop ;
: UCOMISD  2E 66 xmop01b ;            ( xmr/m64 xmreg )
: UCOMISS  2E 00 xmop01c ;            ( xmr/m32 xmreg )
: UD2  0B op0F ;                      ( )
: UNPACKHPD  15 66 xmop01a ;          ( xmr/m128 xmreg )
: UNPACKHPS  15 00 xmop01a ;          ( xmr/m128 xmreg )
: UNPACKLPD  14 66 xmop01a ;          ( xmr/m128 xmreg )
: UNPACKLPS  14 00 xmop01a ;          ( xmr/m128 xmreg )
: VERR  00 04 memop2 ;                ( r/m16 )
: VERW  00 05 memop2 ;                ( r/m16 )
: WBINVD  09 op0F ;                   ( )
: WRMSR  30 op0F ;                    ( )
: XADD ( reg r/m )  2 !args !opsize= esc+ C1 over .size #BYTE = + -rot stdmodr/m! stdreg! op, ;
: XCHG ( r/m reg | reg r/m )  xchgop ;
: XGETBV ( )  esc+ 2 reg! 3 mod! 01 op, ;
: XLAT  D7 op02 ;                     ( )
: XOR  6 logarop ;                    ( ... )
: XORPD  57 66 xmop01a ;              ( xmr/m128 xmreg )
: XORPS  57 00 xmop01a ;              ( xmr/m128 xmreg )
: XRSTOR ( mem )  1 !args  !address esc+  5 reg! modr/m!  AE op, ;
: XRSTOR64 ( mem )  1 !args  !>586 !address esc+  48 prefix! 5 reg! modr/m!  AE op, ;
: XSAVE ( mem )  1 !args  !address esc+  4 reg! modr/m!  AE op, ;
: XSAVE64 ( mem )  1 !args  !>586 !address esc+  48 prefix! 4 reg! modr/m!  AE op, ;
: XSETBV ( )  0 !args esc+ 2 reg! 3 mod! 1 r/m! 01 op, ;

=== [Counted] Loops and Blocks ===

decimal
( Inserts a conditional jump forward and returns referent &a of the location to relocate. )
: ?JMPFWD ( cond -- &a )  $0F c, $80 or c, &here 0 d, ;
( Inserts an unconditional jump forward and returns referent &a of the location to relocate. )
: JMPFWD ( -- &a ) $E9 c, &here 0 d, ;
: ?JMPBCK ( cond &a -- )  16 ?extendCurrentHeap &here 2 &+ &- dup -128 128 within simblock? andn if
  $70 rot $0F and + c, c,  else  $0F c, $80 rot $0F and + c, 4- d,  then ;
: JMPBCK ( &a -- )  16 ?extendCurrentHeap  &here 2 &+ &- dup -128 128 within simblock? andn if
  $EB c, c,  else  $E9 c, 3− d,  then ;
: resolve ( &a -- )  &here over &- -4 &+ swap &@ d! ;

( [a], [a1], [a2] denote referents on the A-stack. )

: (BEGIN) ( -- [a] )  &here >A  cleanup ;
: (END) ( [a] -- )  A> drop  cleanup ;
: (AGAIN) ( [a] -- )  A> JMPBCK cleanup ;
: (UNTIL) ( cond [a] -- )  1 !args !condition $FF and 1 xor A> ?JMPBCK  cleanup ;
: (ASLONG) ( cond [a] -- )  1 !args !condition $FF and A> swap ?JMPBCK  cleanup ;
: (IF) ( cond -- [a] )  1 !args !condition $FF and 1 xor ?JMPFWD >A  cleanup ;
: (THEN) ( [a] -- )  A> resolve  cleanup ;
: (ELSE) ( [a1] -- [a2] )  A> JMPFWD >A resolve  cleanup ;
: (WHILE) ( cond [a1] -- [a2] [a1] ) (IF) A> A> swap >A >A  cleanup ;
: (REPEAT) ( [a2] [a1] -- )  (AGAIN) (THEN) ;
: (FOR) ( -- [a] )  (BEGIN) ;
: (NEXT) ( [a] -- )  &here 2 &+ A@ &- -128 128 within simblock? andn if
  A> # LOOP  else  RCX DEC  CNZ A> ?JMPBCK then  cleanup ;
: (NEXTIF) ( cond [a] -- )  1 !args !condition $FF and
  &here 2 &+ A@ &- -128 128 within simblock? andn if
  A> # swap ?LOOP  else  CONDLOOP_RANGE$ error  then  cleanup ;
: (IFUNLIKELY) ( cond -- [a] )  UNLIKELY (IF) ;
: (UNLESS) ( cond -- [a] )  1 xor (IF) ;
: (UNLESSUNLIKELY) ( cond -- [a] )  UNLIKELY (UNLESS) ;

: BEGIN (BEGIN) ;
: END (END) ;
: AGAIN (AGAIN) ;
: UNTIL (UNTIL) ;
: ASLONG (ASLONG) ;
: THEN (THEN) ;
: IF (IF) ;
: IFEVER (IFUNLIKELY) ;
: UNLESS (UNLESS) ;
: UNLESSEVER (UNLESSUNLIKELY) ;
: ELSE (ELSE) ;
: WHILE (WHILE) ;
: REPEAT (REPEAT) ;
: FOR (FOR) ;
: NEXT (NEXT) ;
: ?NEXT (NEXTIF) ;

: CATCH  JMPFWD ;

=== Condition Codes ===

: OV  $00 condition ;                      ( overflow )
: NO  $01 condition ;                      ( not overflow )
: U<  $02 condition ;                      ( below )
: CY  $02 condition ;                      ( carry )
: U≥  $03 condition ;                      ( above or equal )
: NC  $03 condition ;                      ( not carry )
: =   $04 condition ;                      ( equal )
: 0=  $04 condition ;                      ( zero )
: ≠   $05 condition ;                      ( not equal )
: 0≠  $05 condition ;                      ( not zero )
: 0-  $05 condition ;                      ( not zero )
: U≤  $06 condition ;                      ( below or equal )
: U>  $07 condition ;                      ( above )
: 0<  $08 condition ;                      ( negative )
: 0≥  $09 condition ;                      ( positive )
: PY  $0A condition ;                      ( parity )
: P=  $0A condition ;                      ( parity even )
: NP  $0B condition ;                      ( no parity )
: P≠  $0B condition ;                      ( parity odd )
: <   $0C condition ;                      ( less )
: ≥   $0D condition ;                      ( greater or equal )
: ≤   $0E condition ;                      ( less or equal )
: 0≤  $0E condition ;                      ( negative or zero )
: >   $0F condition ;                      ( greater )
: 0>  $0F condition ;                      ( positive and not zero )

: X<  $0A fcondition ;                     ( unordered )
: X>  $0B fcondition ;                     ( ordered )

vocabulary;
