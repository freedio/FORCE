vocabulary A4-test64
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" AsmTestBase.voc"
  requires" AsmBase64.voc"
  requires" AsmTestUtil.voc"
  requires" A4-IA64.voc"

64 dup dup constant _ADDRSIZE constant _OPSIZE constant _ARCH
-1 constant _MMX  -1 constant _XMM  -1 constant _X87

:: testsuite ( -- )  INIT,
  "Forcembler Test Suite 4 for IA64". cr

(  8 TARGET-ARCH !
  8 TARGET-ADDRSIZE !
  tick error>> A4-test64 ERRHANDLER 2! )
  initA4  test-mode
  "A4-test64.4th" INFILENAME !  0 INCOLUMN !  23 INLINE !

RAX                    00 #REGULAR #QWORD i64 #REGISTER !op    ¶
DS                      03 #SEGMENT #WORD uni #REGISTER !op     ¶
CL                      01 #REGULAR #BYTE uni #REGISTER !op     ¶
DH                      06 #HI-BYTE #BYTE uni #REGISTER !op     ¶
XMM7                    07 #XMM #OWORD xmm #REGISTER !op        ¶
MM4                     04 #MMX #QWORD mmx #REGISTER !op        ¶
CR8                     08 #CONTROL #DWORD i64 #REGISTER !op    ¶
DR2                     02 #DEBUG #DWORD ext #REGISTER !op      ¶
R09                     09 #REGULAR #QWORD i64 #REGISTER !op    ¶
R13D                    13 #REGULAR #DWORD i64 #REGISTER !op    ¶
ST(3)                   03 #FLOATING #TBYTE x87 #REGISTER !op   ¶
¶
0 [EAX]                 I32_NOT_SUPPORTED$ !error                                        ¶
0 [RAX]                 00 #LINEAR 0 i64 #ADDRESS !op              0 0 !disp             ¶
-1 [BP+SI]              02 #INDEXED 0 i16 #ADDRESS !op             -1 #BYTE !disp        ¶
100 []                  $45 #INDEXED %MOD00 + 0 i64 #ADDRESS !op   100 #DWORD !disp      ¶
0 [RBX] [ESI]           ARCHITECTURE_MISMATCH$ !error                                    ¶
0 [RBX] [RSI]           $63 #INDEXED 0 i64 #ADDRESS !op            0 0 !disp             ¶
( 2000 [RBX] [RSI] *2     $43 #SCALED2 0 i64 #ADDRESS !op          2000 #WORD !disp      ¶ )

( Test Operations )

46 INLINE !  hex

~ AAA                             LEGACY_OPCODE$ !error
~ AAD                             LEGACY_OPCODE$ !error
~ 10 # AAD                        LEGACY_OPCODE$ !error
~ AAM                             LEGACY_OPCODE$ !error
~ 10 # AAM                        LEGACY_OPCODE$ !error
~ AAS                             LEGACY_OPCODE$ !error
~ ( testing logarop operand combinations by means of ADC: )
~ 10 # BL ADC                     « 80 D3 10 »
~ 10 # BH ADC                     « 80 D7 10 »
~ 10 # BX ADC                     « 66 83 D3 10 »
~ 1000 # ES ADC                   STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX ADC                    « 83 D3 10 »
~ 10 # RBX ADC                    « 48 83 D3 10 »
~ 100 # RBX ADC                   « 48 81 D3 00 01 00 00 »
~ 10 # 0 [ESP] ADC                I32_NOT_SUPPORTED$ !error
~ 10 # 0 [RSP] ADC                OPERAND_SIZE_UNKNOWN$ !error
~ 10 # BYTE PTR 0 [RBX] ADC       « 80 13 10 »
~ 1000 # WORD PTR -1000 [RSP] ADC « 66 81 94 24 00 F0 FF FF 00 10 »
~ 10 # QWORD PTR 0 [RSI] ADC      « 48 83 16 10 »
~ 10 # AL ADC                     « 14 10 »
~ 10 # AX ADC                     « 66 83 D0 10 »
~ 10 # EAX ADC                    « 83 D0 10 »
~ 10 # RAX ADC                    « 48 83 D0 10 »
~ AL AH ADC                       « 10 C4 »
~ AL AX ADC                       OPERAND_SIZE_MISMATCH$ !error
~ AX SI ADC                       « 66 11 C6 »
~ AX ES ADC                       STANDARD_R/M_EXPECTED$ !error
~ DS AX ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ AX ES ADC                       STANDARD_R/M_EXPECTED$ !error
~ 1 # CS ADC                      STANDARD_R/M_EXPECTED$ !error
~ 10 # CR0 ADC                    STANDARD_R/M_EXPECTED$ !error
~ DR7 CR7 ADC                     STANDARD_REGISTER_EXPECTED$ !error
~ 5 # ST0 ADC                     STANDARD_R/M_EXPECTED$ !error
~ EAX AL ADC                      OPERAND_SIZE_MISMATCH$ !error
~ EBX ESI ADC                     « 11 DE »
~ RBX RSI ADC                     « 48 11 DE »
~ ST(0) ST1 ADC                   STANDARD_REGISTER_EXPECTED$ !error
~ CR0 DR7 ADC                     STANDARD_REGISTER_EXPECTED$ !error
~ AL 0 [RSI] [RCX] ADC            « 10 04 0E »
~ 0 [RSI] [RBX] *1 AL ADC         « 12 04 1E »
~ BX -1 [RBP] *2 ADC              BASE_EBP_REQUIRED$ !error
~ BX -1 [RSI] *2 ADC              BASE_EBP_REQUIRED$ !error
~ BX -1 [RBP] [RSI] *2 ADC        « 66 11 5C 75 FF »
~ BX 0 [RAX] [RBX] *2 ADC         « 66 11 1C 58 »
~ 0 [RBP] RAX ADC                 « 48 13 45 00 »
~ 0 [RBP] [RCX] *8 R10 ADC        « 4C 13 54 CD 00 »
~ 1000 [] RAX ADC                 « 48 13 04 25 00 10 00 00 »
~ RAX 0 [R13] ADC                 « 49 11 45 00 »
~ R15 0 [R13] [RCX] *8 ADC        « 4D 11 7C CD 00 »
~ R15W -1 [R13] *8 ADC            BASE_EBP_REQUIRED$ !error
~ R15W -1 [R13] [R13] *8 ADC      « 66 47 11 7C ED FF »
~ BH SIL ADC                      HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ SPL AH ADC                      HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ AH R15L ADC                     HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ R10L CH ADC                     HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ 0 [RSI] [R10] AH ADC            HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ BH -25 [R10] ADC                HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ 0 [RCX] [RSP] *2 AL ADC         INVALID_ADDRESS_INDEX$ !error
~ 0 [RCX] [R12] *2 AL ADC         INVALID_ADDRESS_INDEX$ !error
~ BX 0 [RCX] [RSP] *2 ADC         INVALID_ADDRESS_INDEX$ !error
~ BX 0 [RCX] [R12] *2 ADC         INVALID_ADDRESS_INDEX$ !error
~ DX -3000 [RDI] [RBP] *2 ADC     « 66 11 94 6F 00 D0 FF FF »
~ 28000 [RBP] [RDI] *8 RAX ADC    « 48 13 84 FD 00 80 02 00 »
~ RAX RSP ADD                     « 48 01 C4 »
~ -8 [RSP] EAX ADD                « 03 44 24 F8 »
~ 0 [BX] SI ADD                   « 66 67 03 37 »
~ 0 [BP] SI ADD                   « 66 67 03 76 00 »
~ -1 [BP] RSI ADD                 « 67 48 03 76 FF »
~ 1000 [BX+SI] AL ADD             « 67 02 80 00 10 »
~ 100000 [BX+SI] AL ADD           IMMEDIATE_TOO_BIG$ !error
~ CL 1000 [BX+SI] ADD             « 67 00 88 00 10 »
~ DX 0 [BX+DI] ADD                « 66 67 01 11 »
~ RAX RBX ADDPD                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDPD                  XMM_REGMEM128_EXPECTED$ !error
~ XMM1 XMM2 ADDPD                 « 66 0F 58 D1 »
~ OWORD PTR 0 [RSI] XMM0 ADDPD    « 66 0F 58 06 »
~ XMM7 OWORD PTR 0 [RSI] ADDPD    XMM_REGISTER_EXPECTED$ !error
~ RAX RBX ADDPS                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDPS                  XMM_REGMEM128_EXPECTED$ !error
~ XMM1 XMM2 ADDPS                 « 0F 58 D1 »
~ OWORD PTR 0 [RSI] XMM0 ADDPS    « 0F 58 06 »
~ XMM7 OWORD PTR 0 [RSI] ADDPS    XMM_REGISTER_EXPECTED$ !error
~ RAX RBX ADDSD                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDSD                  XMM_REGMEM64_EXPECTED$ !error
~ XMM1 XMM2 ADDSD                 « F2 0F 58 D1 »
~ QWORD PTR 0 [RSI] XMM0 ADDSD    « F2 0F 58 06 »
~ XMM7 QWORD PTR 0 [RSI] ADDSD    XMM_REGISTER_EXPECTED$ !error
~ RAX RBX ADDSS                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDSS                  XMM_REGMEM32_EXPECTED$ !error
~ XMM1 XMM2 ADDSS                 « F3 0F 58 D1 »
~ DWORD PTR 0 [RSI] XMM0 ADDSS    « F3 0F 58 06 »
~ XMM7 QWORD PTR 0 [RSI] ADDSS    XMM_REGISTER_EXPECTED$ !error
~ XMM3 XMM4 ADDSUBPD              « 66 0F D0 E3 »
~ OWORD PTR 0 [RSI] XMM0 ADDSUBPD « 66 0F D0 06 »
~ XMM3 XMM4 ADDSUBPS              « F2 0F D0 E3 »
~ OWORD PTR 0 [RSI] XMM0 ADDSUBPS « F2 0F D0 06 »
~ XMM1 XMM0 AESDEC                « 66 0F 38 DE C1 »
~ OWORD PTR -1234 [] XMM7 AESDEC  « 66 0F 38 DE 3C 25 CC ED FF FF »
~ XMM4 RAX AESDECLAST             XMM_REGISTER_EXPECTED$ !error
~ XMM2 XMM3 AESDECLAST            « 66 0F 38 DF DA »
~ XMM1 XMM0 AESENC                « 66 0F 38 DC C1 »
~ XMM7 OWORD PTR -1234 [] AESENC  XMM_REGISTER_EXPECTED$ !error
~ XMM4 CS AESENCLAST              XMM_REGISTER_EXPECTED$ !error
~ XMM2 XMM3 AESENCLAST            « 66 0F 38 DD DA »
~ XMM1 XMM2 AESIMC                « 66 0F 38 DB D1 »
~ 3 # XMM1 XMM6 AESKEYGENASSIST   « 66 0F 3A DF F1 03 »
~ -1 # OWORD PTR 0 [EAX] [EBX] *4 XMM0 AESKEYGENASSIST  I32_NOT_SUPPORTED$ !error
~ -1 # OWORD PTR 0 [RAX] [RBX] *4 XMM0 AESKEYGENASSIST  « 66 0F 3A DF 04 98 FF »
~ AL AH AND                       « 20 C4 »
~ DX 0 [RSI] AND                  « 66 21 16 »
~ AL BPL AND                      « 40 20 C5 »
~ QWORD PTR -123 [BP+DI] RSI AND  « 67 48 23 B3 DD FE »
~ XMM7 XMM1 AND                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP AND                       « 66 21 E4 »
~ CR0 RAX AND                     STANDARD_REGISTER_EXPECTED$ !error
~ CS DS AND                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 ANDPD                 « 66 0F 54 C0 »
~ OWORD PTR 0 [R10] XMM7 ANDPS    « 41 0F 54 3A »
~ OWORD PTR -1 [] XMM0 ANDNPD     « 66 0F 55 04 25 FF FF FF FF »
~ XMM7 XMM6 ANDNPS                « 0F 55 F7 »
~ AX BX ARPL                      LEGACY_OPCODE$ !error
~ 1000 # XMM0 XMM1 BLENDPD        IMMEDIATE8_OPERAND_EXPECTED$ !error
~ -1 # XMM0 XMM1 BLENDPD          « 66 0F 3A 0D C8 FF »
~ 2 # OWORD PTR 0 [RAX] XMM1 BLENDPS  « 66 0F 3A 0C 08 02 »
~ EAX XMM1 EAX BLENDPS            XMM_REGISTER_EXPECTED$ !error
~ EAX XMM1 XMM0 BLENDPS           IMMEDIATE8_OPERAND_EXPECTED$ !error
~ XMM7 XMM5 BLENDVPD              « 66 0F 38 15 EF »
~ XMM1 XMM3 BLENDVPS              « 66 0F 38 14 D9 »
~ 0 [RSI] RAX BOUND               LEGACY_OPCODE$ !error
~ QWORD PTR -25 [RSI] [RBP] *4 RSI BSF      « 48 0F BC 74 AE DB »
~ DWORD PTR -25 [RSI] [RBP] *4 ESI BSF      « 0F BC 74 AE DB »
~ ESI -25 [RSI] [RBP] *4 BSF      STANDARD_REGISTER_EXPECTED$ !error
~ RSI RDI BSF                     « 48 0F BC FE »
~ TBYTE PTR 0 [] ST(2) BSF        INVALID_OPERAND_SIZE$ !error
~ QWORD PTR -25 [RSP] [RBP] *4 RSI BSR      « 48 0F BD 74 AC DB »
~ RAX RCX BSR                     « 48 0F BD C8 »
~ RDX BSWAP                       « 48 0F CA »
~ QWORD PTR 0 [RSI] BSWAP         REGISTER_OPERAND_EXPECTED$ !error
~ RCX QWORD PTR 99 [RSI] BT       « 48 0F A3 8E 99 00 00 00 »
~ RSI RDI BTS                     « 48 0F AB F7 »
~ RDI 0 [RAX] BTS                 « 48 0F AB 38 »
~ 78 # 0 [RDX] BTR                OPERAND_SIZE_UNKNOWN$ !error
~ 78 # WORD PTR 0 [RDX] BTR       « 66 0F BA 32 78 »
~ 0 # QWORD PTR 0 [RAX] BT        « 48 0F BA 20 00 »
~ -12 # ESI BTC                   « 0F BA FE EE »
~ RCX DWORD PTR 99 [RSI] BT       OPERAND_SIZE_MISMATCH$ !error
~ there 10 + # CALL               « E8 0B 00 00 00 »
~ 0 [RBX] [RBX] *8 CALL           « FF 14 DB »
~ 0 [] CALL                       « FF 14 25 00 00 00 00 »
~ RBX CALL                        « 48 FF D3 »
~ CBW                             « 66 98 »
~ CWDE                            « 98 »
~ CDQE                            « 48 98 »
~ CLC                             « F8 »
~ CLD                             « FC »
~ 0 [RSI] *4 CLFLUSH              « 0F AE 3C B5 00 00 00 00 »
~ RAX CLFLUSH                     ADDRESS_OPERAND_EXPECTED$ !error
~ CLI                             « FA »
~ CLTS                            « 0F 06 »
~ CMC                             « F5 »
~ RBX RAX 0= ?MOV                 « 48 0F 44 C3 »
~ 0 [RBX] EAX U< ?MOV             « 0F 42 03 »
~ 0 [RIP] AL 0> ?MOV              « 0F 4F 05 00 00 00 00 »
~ AX 0 [RSI] P= ?MOV              OPERAND_SIZE_UNKNOWN$ !error
~ AX WORD PTR 0 [RSI] P= ?MOV     STANDARD_REGISTER_EXPECTED$ !error
~ 1000 # RAX CMP                  « 48 3D 00 10 00 00 »
~ 10 # WORD PTR -1 [RSI] CMP      « 66 83 7E FF 10 »
~ RAX RCX CMP                     « 48 39 C1 »
~ SIL 90 [RCX] CMP                « 40 38 B1 90 00 00 00 »
~ 90 [RCX] DIL CMP                « 40 3A B9 90 00 00 00 »
~ XMM1 XMM2 CMPPD                 « 66 0F C2 D1 »
~ OWORD PTR 0 [RSI] XMM0 CMPPD    « 66 0F C2 06 »
~ XMM1 XMM2 CMPPS                 « 0F C2 D1 »
~ OWORD PTR 0 [RSI] XMM0 CMPPS    « 0F C2 06 »
~ XMM1 XMM2 CMPSD                 « F2 0F C2 D1 »
~ QWORD PTR 0 [RSI] XMM0 CMPSD    « F2 0F C2 06 »
~ XMM1 XMM2 CMPSS                 « F3 0F C2 D1 »
~ DWORD PTR 0 [RSI] XMM0 CMPSS    « F3 0F C2 06 »
~ BYTE PTR CMPS                   « A6 »
~ WORD PTR CMPS                   « 66 A7 »
~ DWORD PTR CMPS                  « A7 »
~ QWORD PTR CMPS                  « 48 A7 »
~ AL DIL CMPXCHG                  « 40 0F B0 C7 »
~ DX 0 [RSI] [R15] *2 CMPXCHG     « 66 42 0F B1 14 7E »
~ 0 [RSI] [R15] *2 AX CMPXCHG     STANDARD_REGISTER_EXPECTED$ !error
~ EBX EDI CMPXCHG                 « 0F B1 DF »
~ CR0 DR7 CMPXCHG                 STANDARD_REGISTER_EXPECTED$ !error
~ RBX 4 [RBX] CMPXCHG             « 48 0F B1 5B 04 »
~ QWORD PTR 0 [] CMPXCHG8B        « 0F C7 0C 25 00 00 00 00 »
~ XMM1 XMM2 COMISD                « 66 0F 2F D1 »
~ QWORD PTR 0 [RSI] XMM0 COMISD   « 66 0F 2F 06 »
~ XMM1 XMM2 COMISS                « 0F 2F D1 »
~ DWORD PTR 0 [RSI] XMM0 COMISS   « 0F 2F 06 »
~ CPUID                           « 0F A2 »
~ BYTE PTR 5 [RBX] AL CRC32       REGISTER_32+_EXPECTED$ !error
~ BYTE PTR 5 [RBX] AX CRC32       REGISTER_32+_EXPECTED$ !error
~ BYTE PTR 5 [RBX] EAX CRC32      « F2 0F 38 F0 43 05 »
~ BYTE PTR 5 [RBX] RAX CRC32      « F2 48 0F 38 F0 43 05 »
~ BL CL CRC32                     REGISTER_32+_EXPECTED$ !error
~ BL CX CRC32                     REGISTER_32+_EXPECTED$ !error
~ BL ECX CRC32                    « F2 0F 38 F0 CB »
~ BL RCX CRC32                    « F2 48 0F 38 F0 CB »
~ WORD PTR 5 [RBX] EAX CRC32      « 66 F2 0F 38 F1 43 05 »
~ WORD PTR 5 [RBX] RAX CRC32      « 66 F2 48 0F 38 F1 43 05 »
~ BX ECX CRC32                    « 66 F2 0F 38 F1 CB »
~ BX RCX CRC32                    « 66 F2 48 0F 38 F1 CB »
~ DWORD PTR 5 [RBX] EAX CRC32     « F2 0F 38 F1 43 05 »
~ DWORD PTR 5 [RBX] RAX CRC32     « F2 48 0F 38 F1 43 05 »
~ EBX ECX CRC32                   « F2 0F 38 F1 CB »
~ EBX RCX CRC32                   « F2 48 0F 38 F1 CB »
~ QWORD PTR 5 [RBX] EAX CRC32     INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 5 [RBX] RAX CRC32     « F2 48 0F 38 F1 43 05 »
~ RBX ECX CRC32                   INVALID_OPERAND_COMBINATION$ !error
~ RBX RCX CRC32                   « F2 48 0F 38 F1 CB »
~ XMM7 XMM0 CVTDQ2PD              « F3 0F E6 C7 »
~ XMM7 EAX CVTDQ2PD               XMM_REGISTER_EXPECTED$ !error
~ XMM7 RAX CVTDQ2PD               XMM_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTDQ2PD XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTDQ2PD « F3 0F E6 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTDQ2PD XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTDQ2PS              « 0F 5B C7 »
~ QWORD PTR 0 [RSI] XMM0 CVTDQ2PS XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTDQ2PS « 0F 5B 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTDQ2PS XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPD2DQ              « F2 0F E6 C7 »
~ QWORD PTR 0 [RSI] XMM0 CVTPD2DQ XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPD2DQ « F2 0F E6 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPD2DQ XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPD2PI              « 66 0F 2D C7 »
~ QWORD PTR 0 [RSI] XMM0 CVTPD2PI XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPD2PI « 66 0F 2D 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPD2PI XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPD2PS              « 66 0F 5A C7 »
~ QWORD PTR 0 [RSI] XMM0 CVTPD2PS XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPD2PS « 66 0F 5A 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPD2PS XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPI2PD              « 66 0F 2A C7 »
~ OWORD PTR 0 [RSI] XMM0 CVTPI2PD XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTPI2PD « 66 0F 2A 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPI2PD XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPS2DQ              « 66 0F 5B C7 »
~ QWORD PTR 0 [RSI] XMM0 CVTPS2DQ XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPS2DQ « 66 0F 5B 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPS2DQ XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPS2PD              « 0F 5A C7 »
~ OWORD PTR 0 [RSI] XMM0 CVTPS2PD XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTPS2PD « 0F 5A 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPS2PD XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPS2PI              « 0F 2D C7 »
~ OWORD PTR 0 [RSI] XMM0 CVTPS2PI XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTPS2PI « 0F 2D 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTPS2PI XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTSD2SI              REGISTER_32+_EXPECTED$ !error
~ XMM7 EAX CVTSD2SI               « F2 0F 2D C7 »
~ XMM7 RAX CVTSD2SI               « F2 48 0F 2D C7 »
~ OWORD PTR 0 [RSI] XMM0 CVTSD2SI REGISTER_32+_EXPECTED$ !error
~ QWORD PTR 0 [RSI] EAX CVTSD2SI  « F2 0F 2D 06 »
~ QWORD PTR 0 [RSI] RAX CVTSD2SI  « F2 48 0F 2D 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTSD2SI REGISTER_32+_EXPECTED$ !error
~ XMM7 XMM0 CVTSD2SS              « F2 0F 5A C7 »
~ OWORD PTR 0 [RSI] XMM0 CVTSD2SS XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTSD2SS « F2 0F 5A 06 »
~ XMM0 OWORD PTR 0 [RSI] CVTSD2SS XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTSI2SD              R/M_32+_EXPECTED$ !error
~ ESI XMM0 CVTSI2SD               « F2 0F 2A C6 »
~ RSI XMM0 CVTSI2SD               « F2 48 0F 2A C6 »
~ DWORD PTR 0 [RSI] XMM0 CVTSI2SD « F2 0F 2A 06 »
~ QWORD PTR 0 [RSI] XMM0 CVTSI2SD « F2 48 0F 2A 06 »
~ OWORD PTR 0 [RSI] XMM0 CVTSI2SD R/M_32+_EXPECTED$ !error
~ XMM0 OWORD PTR 0 [RSI] CVTSI2SD XMM_REGISTER_EXPECTED$ !error
~ CWD                             « 66 99 »
~ CDQ                             « 99 »
~ CQO                             « 48 99 »
~ DAA                             LEGACY_OPCODE$ !error
~ DAS                             LEGACY_OPCODE$ !error
~ 1 # DEC                         STANDARD_R/M_EXPECTED$ !error
~ AL DEC                          « FE C8 »
~ BX DEC                          « 66 FF CB »
~ ECX DEC                         « FF C9 »
~ RDX DEC                         « 48 FF CA »
~ BYTE PTR 0 [RAX] DEC            « FE 08 »
~ WORD PTR 0 [RBX] DEC            « 66 FF 0B »
~ DWORD PTR 0 [RCX] DEC           « FF 09 »
~ QWORD PTR 0 [RDX] DEC           « 48 FF 0A »
~ OWORD PTR 0 [RSI] DEC           STANDARD_R/M_EXPECTED$ !error
~ 1 # DIV                         INVALID_OPERAND_TYPE$ !error
~ AL DIV                          « F6 F0 »
~ BX DIV                          « 66 F7 F3 »
~ ECX DIV                         « F7 F1 »
~ RDX DIV                         « 48 F7 F2 »
~ BYTE PTR 0 [RAX] DIV            « F6 30 »
~ WORD PTR 0 [RBX] DIV            « 66 F7 33 »
~ DWORD PTR 0 [RCX] DIV           « F7 31 »
~ QWORD PTR 0 [RDX] DIV           « 48 F7 32 »
~ OWORD PTR 0 [RSI] DIV           INVALID_OPERAND_SIZE$ !error
~ XMM1 XMM2 DIVPD                 « 66 0F 5E D1 »
~ OWORD PTR 0 [RSI] XMM0 DIVPD    « 66 0F 5E 06 »
~ XMM1 XMM2 DIVPS                 « 0F 5E D1 »
~ OWORD PTR 0 [RSI] XMM0 DIVPS    « 0F 5E 06 »
~ XMM1 XMM2 DIVSD                 « F2 0F 5E D1 »
~ QWORD PTR 0 [RSI] XMM0 DIVSD    « F2 0F 5E 06 »
~ XMM1 XMM2 DIVSS                 « F3 0F 5E D1 »
~ DWORD PTR 0 [RSI] XMM0 DIVSS    « F3 0F 5E 06 »
~ 10 # XMM1 XMM2 DPPD             « 66 0F 3A 41 D1 10 »
~ -10 # OWORD PTR 0 [RSI] XMM0 DPPD  « 66 0F 3A 41 06 F0 »
~ 10 # XMM1 XMM2 DPPS             « 66 0F 3A 40 D1 10 »
~ -10 # OWORD PTR 0 [RSI] XMM0 DPPS  « 66 0F 3A 40 06 F0 »
~ EMMS                            « 0F 77 »
~ 10 2000 # ENTER                 « C8 00 20 10 »
~ 100 # ENTER                     MISSING_NESTING_LEVEL$ !error
~ 200 2000 # ENTER                NESTLEVEL_OPERAND_EXPECTED$ !error
~ 10 12345 # ENTER                IMMEDIATE16_OPERAND_EXPECTED$ !error
~ 0 1234 # ENTER                  « C8 34 12 00 »
~ 5 # XMM3 EAX EXTRACTPS          « 66 0F 3A 17 D8 05 »
~ 1 # XMM4 DWORD PTR 0 [RSI] EXTRACTPS  « 66 0F 3A 17 26 01 »
~ F2^X-1                          « D9 F0 »
~ FABS                            « D9 E1 »
~ ST2 FADD                        « DC C2 »
~ RAX FADD                        INVALID_OPERAND_TYPE$ !error
~ 25 # FADD                       INVALID_OPERAND_TYPE$ !error
~ 0 [RSI] FADD                    OPERAND_SIZE_UNKNOWN$ !error
~ WORD PTR 0 [RSI] FADD           INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FADD          « D8 06 »
~ QWORD PTR 0 [RSI] FADD          « DC 06 »
~ OWORD PTR 0 [RSI] FADD          INVALID_OPERAND_SIZE$ !error
~ 0 [RSI] RFADD                   FPU_REGISTER_EXPECTED$ !error
~ ST2 RFADD                       « D8 C2 »
~ RAX RFADD                       FPU_REGISTER_EXPECTED$ !error
~ 25 # RFADD                      FPU_REGISTER_EXPECTED$ !error
~ WORD PTR 0 [RSI] RFADD          FPU_REGISTER_EXPECTED$ !error
~ DWORD PTR 0 [RSI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [RSI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ FADDP                           « DE C1 »
~ ST(1) FADDP                     « DE C1 »
~ QWORD PTR 0 [RSI] FADDP         FPU_REGISTER_EXPECTED$ !error
~ RAX FADDP                       FPU_REGISTER_EXPECTED$ !error
~ 23 # FADDP                      FPU_REGISTER_EXPECTED$ !error
~ ST2 FIADD                       INVALID_OPERAND_TYPE$ !error
~ RAX FIADD                       INVALID_OPERAND_TYPE$ !error
~ 25 # FIADD                      INVALID_OPERAND_TYPE$ !error
~ 0 [RSI] FIADD                   OPERAND_SIZE_UNKNOWN$ !error
~ WORD PTR 0 [RSI] FIADD          « DA 06 »
~ DWORD PTR 0 [RSI] FIADD         « DE 06 »
~ QWORD PTR 0 [RSI] FIADD         INVALID_OPERAND_TYPE$ !error
~ OWORD PTR 0 [RSI] FIADD         INVALID_OPERAND_SIZE$ !error
~ 0 [RBX] FBLD                    OPERAND_SIZE_UNKNOWN$ !error
~ TBYTE PTR 0 [RBX] FBLD          « DF 23 »
~ QWORD PTR 0 [RBX] FBLD          ADDRESS_80_OPERAND_EXPECTED$ !error
~ ST(0) FBLD                      ADDRESS_80_OPERAND_EXPECTED$ !error
~ TBYTE PTR 0 [RSI] FBSTP         « DF 36 »
~ FCHS                            « D9 E0 »
~ FWAIT                           « 9B »
~ FCLEX                           « 9B DB E2 »
~ FNCLEX                          « DB E2 »
~ ST1 U< ?FMOV                    « DA C1 »
~ 0 [RSI] U< ?FMOV                FPU_REGISTER_EXPECTED$ !error
~ ST(2) = ?FMOV                   « DA CA »
~ RAX = ?FMOV                     FPU_REGISTER_EXPECTED$ !error
~ ST3 U≤ ?FMOV                    « DA D3 »
~ ST4 X< ?FMOV                    « DA DC »
~ ST5 U≥ ?FMOV                    « DB C5 »
~ ST6 ≠ ?FMOV                     « DB CE »
~ ST7 U> ?FMOV                    « DB D7 »
~ ST0 X> ?FMOV                    « DB D8 »
~ ST1 FCOMI                       « DB F1 »
~ ST2 FCOMIP                      « DF F2 »
~ ST(3) FUCOMI                    « DB EB »
~ ST(4) FUCOMIP                   « DF EC »
~ 0 [RDI] FUCOMI                  FPU_REGISTER_EXPECTED$ !error
~ FCOS                            « D9 FF »
~ FDECSTP                         « D9 F6 »
~ ST2 FDIV                        « DC F2 »
~ DWORD PTR 0 [RSI] FDIV          « D8 36 »
~ QWORD PTR 0 [RSI] FDIV          « DC 36 »
~ ST2 RFDIV                       « D8 F2 »
~ FDIVP                           « DE F1 »
~ ST(1) FDIVP                     « DE F1 »
~ WORD PTR 0 [RSI] FIDIV          « DA 36 »
~ DWORD PTR 0 [RSI] FIDIV         « DE 36 »
~ ST2 FDIVR                       « DC FA »
~ DWORD PTR 0 [RSI] FDIVR         « D8 3E »
~ QWORD PTR 0 [RSI] FDIVR         « DC 3E »
~ ST2 RFDIVR                      « D8 FA »
~ FDIVRP                          « DE F9 »
~ ST(1) FDIVRP                    « DE F9 »
~ WORD PTR 0 [RSI] FIDIVR         « DA 3E »
~ DWORD PTR 0 [RSI] FIDIVR        « DE 3E »
~ BYTE PTR 0 [RSI] FICOM          INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FICOM          « DE 16 »
~ DWORD PTR 0 [RSI] FICOM         « DA 16 »
~ QWORD PTR 0 [RSI] FICOM         INVALID_OPERAND_TYPE$ !error
~ ST(0) FICOM                     INVALID_OPERAND_TYPE$ !error
~ RAX FICOM                       INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FILD           INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FILD           « DF 06 »
~ DWORD PTR 0 [RSI] FILD          « DB 06 »
~ QWORD PTR 0 [RSI] FILD          « DF 2E »
~ ST(0) FILD                      INVALID_OPERAND_TYPE$ !error
~ RAX FILD                        INVALID_OPERAND_TYPE$ !error
~ FINCSTP                         « D9 F7 »
~ FINIT                           « 9B DB E3 »
~ FNINIT                          « DB E3 »
~ BYTE PTR 0 [RSI] FIST           INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FIST           « DF 16 »
~ DWORD PTR 0 [RSI] FIST          « DB 16 »
~ QWORD PTR 0 [RSI] FIST          INVALID_OPERAND_TYPE$ !error
~ ST(0) FIST                      INVALID_OPERAND_TYPE$ !error
~ RAX FIST                        INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FISTP          INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FISTP          « DF 1E »
~ DWORD PTR 0 [RSI] FISTP         « DB 1E »
~ QWORD PTR 0 [RSI] FISTP         « DF 3E »
~ ST(0) FISTP                     INVALID_OPERAND_TYPE$ !error
~ RAX FISTP                       INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FISTTP         INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FISTTP         « DF 0E »
~ DWORD PTR 0 [RSI] FISTTP        « DB 0E »
~ QWORD PTR 0 [RSI] FISTTP        « DD 0E »
~ ST(0) FISTTP                    INVALID_OPERAND_TYPE$ !error
~ RAX FISTTP                      INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FLD            INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FLD            INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FLD           « D9 06 »
~ QWORD PTR 0 [RSI] FLD           « DD 06 »
~ TBYTE PTR 0 [RSI] FLD           « DB 2E »
~ OWORD PTR 0 [RSI] FLD           INVALID_OPERAND_TYPE$ !error
~ ST(3) FLD                       « D9 C3 »
~ RAX FLD                         INVALID_OPERAND_TYPE$ !error
~ FLD1                            « D9 E8 »
~ FLDL2T                          « D9 E9 »
~ FLDL2E                          « D9 EA »
~ FLDPI                           « D9 EB »
~ FLDLG2                          « D9 EC »
~ FLDLN2                          « D9 ED »
~ FLD0                            « D9 EE »
~ ST(0) FLDCW                     ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FLDCW                   « D9 2E »
~ RAX FLDCW                       ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FLDENV                  « D9 26 »
~ ST2 FMUL                        « DC CA »
~ DWORD PTR 0 [RSI] FMUL          « D8 0E »
~ QWORD PTR 0 [RSI] FMUL          « DC 0E »
~ ST2 RFMUL                       « D8 CA »
~ FMULP                           « DE C9 »
~ ST(1) FMULP                     « DE C9 »
~ WORD PTR 0 [RSI] FIMUL          « DA 0E »
~ DWORD PTR 0 [RSI] FIMUL         « DE 0E »
~ FNOP                            « D9 D0 »
~ FPATAN                          « D9 F3 »
~ FPREM                           « D9 F8 »
~ FPREM1                          « D9 F5 »
~ FPTAN                           « D9 F2 »
~ FRNDINT                         « D9 FC »
~ 0 [RSI] FRSTOR                  « DD 26 »
~ ES: 0 [RDI] FSAVE               « 26 9B DD 37 »
~ 0 [RDI] ES: FNSAVE              « 26 DD 37 »
~ FSCALE                          « D9 FD »
~ FSIN                            « D9 FE »
~ FSINCOS                         « D9 FB »
~ FSQRT                           « D9 FA »
~ WORD PTR 0 [RSI] FST            INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FST           « D9 16 »
~ QWORD PTR 0 [RSI] FST           « DD 16 »
~ TBYTE PTR 0 [RSI] FST           INVALID_OPERAND_TYPE$ !error
~ ST(4) FST                       « DD D4 »
~ RAX FST                         INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FSTP           INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FSTP          « D9 1E »
~ QWORD PTR 0 [RSI] FSTP          « DD 1E »
~ TBYTE PTR 0 [RSI] FSTP          « DB 3E »
~ ST(4) FSTP                      « DD DC »
~ RAX FSTP                        INVALID_OPERAND_TYPE$ !error
~ AX FNSTCW                       ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FNSTCW                  « D9 3E »
~ 0 [RSI] FSTCW                   « 9B D9 3E »
~ 0 [RSI] FNSTENV                 « D9 36 »
~ 0 [RSI] FSTENV                  « 9B D9 36 »
~ AX FNSTSW                       « DF E0 »
~ 0 [RSI] FNSTSW                  « DD 3E »
~ EAX FNSTSW                      ADDRESS_OPERAND_EXPECTED$ !error
~ AL FNSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ BX FNSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ ST(0) FNSTSW                    ADDRESS_OPERAND_EXPECTED$ !error
~ AX FSTSW                        « 9B DF E0 »
~ 0 [RSI] FSTSW                   « 9B DD 3E »
~ EAX FSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ AL FSTSW                        ADDRESS_OPERAND_EXPECTED$ !error
~ BX FSTSW                        ADDRESS_OPERAND_EXPECTED$ !error
~ ST(0) FSTSW                     ADDRESS_OPERAND_EXPECTED$ !error
~ ST2 FSUB                        « DC E2 »
~ DWORD PTR 0 [RSI] FSUB          « D8 26 »
~ QWORD PTR 0 [RSI] FSUB          « DC 26 »
~ ST2 RFSUB                       « D8 E2 »
~ FSUBP                           « DE E1 »
~ ST(1) FSUBP                     « DE E1 »
~ WORD PTR 0 [RSI] FISUB          « DA 26 »
~ DWORD PTR 0 [RSI] FISUB         « DE 26 »
~ ST2 FSUBR                       « DC EA »
~ DWORD PTR 0 [RSI] FSUBR         « D8 2E »
~ QWORD PTR 0 [RSI] FSUBR         « DC 2E »
~ ST2 RFSUBR                      « D8 EA »
~ FSUBRP                          « DE E9 »
~ ST(1) FSUBRP                    « DE E9 »
~ WORD PTR 0 [RSI] FISUBR         « DA 2E »
~ DWORD PTR 0 [RSI] FISUBR        « DE 2E »
~ FTST                            « D9 E4 »
~ FUCOM                           « DD E1 »
~ ST(3) FUCOM                     « DD E3 »
~ 0 [RSI] FUCOM                   FPU_REGISTER_EXPECTED$ !error
~ RAX FUCOM                       FPU_REGISTER_EXPECTED$ !error
~ FUCOMP                          « DD E9 »
~ ST(3) FUCOMP                    « DD EB »
~ 0 [RSI] FUCOMP                  FPU_REGISTER_EXPECTED$ !error
~ RAX FUCOMP                      FPU_REGISTER_EXPECTED$ !error
~ FUCOMPP                         « DA E9 »
~ FXCH                            « D9 C9 »
~ 0 [RSI] FXRSTOR                 « 0F AE 0E »
~ ST(0) FXRSTOR                   ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FXSAVE                  « 0F AE 06 »
~ ST(0) FXSAVE                    ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FXRSTOR64               « 48 0F AE 0E »
~ ST(0) FXRSTOR64                 ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FXSAVE64                « 48 0F AE 06 »
~ ST(0) FXSAVE64                  ADDRESS_OPERAND_EXPECTED$ !error
~ FXTRACT                         « D9 F4 »
~ FYL2X                           « D9 F1 »
~ FYL2XP1                         « D9 F9 »
~ OWORD PTR 0 [RSI] XMM0 HADDPD   « 66 0F 7C 06 »
~ XMM1 XMM2 HADDPD                « 66 0F 7C D1 »
~ OWORD PTR 0 [RSI] XMM0 HADDPS   « F2 0F 7C 06 »
~ XMM1 XMM2 HADDPS                « F2 0F 7C D1 »
~ HLT                             « F4 »
~ OWORD PTR 0 [RSI] XMM0 HSUBPD   « 66 0F 7D 06 »
~ XMM1 XMM2 HSUBPD                « 66 0F 7D D1 »
~ OWORD PTR 0 [RSI] XMM0 HSUBPS   « F2 0F 7D 06 »
~ XMM1 XMM2 HSUBPS                « F2 0F 7D D1 »
~ 1 # IDIV                        INVALID_OPERAND_TYPE$ !error
~ AL IDIV                         « F6 F8 »
~ BX IDIV                         « 66 F7 FB »
~ ECX IDIV                        « F7 F9 »
~ RDX IDIV                        « 48 F7 FA »
~ BYTE PTR 0 [RAX] IDIV           « F6 38 »
~ WORD PTR 0 [RBX] IDIV           « 66 F7 3B »
~ DWORD PTR 0 [RCX] IDIV          « F7 39 »
~ QWORD PTR 0 [RDX] IDIV          « 48 F7 3A »
~ OWORD PTR 0 [RSI] IDIV          INVALID_OPERAND_SIZE$ !error
~ 1 # IMUL                        INVALID_OPERAND_TYPE$ !error
~ AL IMUL                         « F6 E8 »
~ BX IMUL                         « 66 F7 EB »
~ ECX IMUL                        « F7 E9 »
~ RDX IMUL                        « 48 F7 EA »
~ BYTE PTR 0 [RAX] IMUL           « F6 28 »
~ WORD PTR 0 [RBX] IMUL           « 66 F7 2B »
~ DWORD PTR 0 [RCX] IMUL          « F7 29 »
~ QWORD PTR 0 [RDX] IMUL          « 48 F7 2A »
~ OWORD PTR 0 [RSI] IMUL          INVALID_OPERAND_SIZE$ !error
~ AL BL IMUL                      REGISTER_16+_EXPECTED$ !error
~ AX BX IMUL                      « 66 0F AF D8 »
~ AL EBX IMUL                     OPERAND_SIZE_MISMATCH$ !error
~ 0 [RSI] RSI IMUL                « 48 0F AF 36 »
~ RSI 0 [RSI] IMUL                REGISTER_16+_EXPECTED$ !error
~ 2 # AL CL IMUL                  REGISTER_16+_EXPECTED$ !error
~ -2 # EAX RBX IMUL               OPERAND_SIZE_MISMATCH$ !error
~ -2 # RAX RBX IMUL               « 48 6B D8 FE »
~ 4 # 0 [RSI] EDX IMUL            « 6B 16 04 »
~ AL 3 # BL IMUL                  REGISTER_16+_EXPECTED$ !error
~ AL BL CL DL IMUL                INVALID_OPERAND_COMBINATION$ !error
~ -2000 # RAX RBX IMUL            « 48 69 D8 00 E0 FF FF »
~ 4000 # 0 [RSI] DX IMUL          « 66 69 16 00 40 »
~ 10 # AL IN                      « E4 10 »
~ 1000 # AL IN                    IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 10 # AX IN                      « 66 E5 10 »
~ 10 # EAX IN                     « E5 10 »
~ 10 # RAX IN                     INVALID_OPERAND_SIZE$ !error
~ 10 # BL IN                      ACCU_OPERAND_REQUIRED$ !error
~ DX AL IN                        « EC »
~ DX AX IN                        « 66 ED »
~ DX EAX IN                       « ED »
~ DX RAX IN                       INVALID_OPERAND_SIZE$ !error
~ DX CL IN                        ACCU_OPERAND_REQUIRED$ !error
~ CX AL IN                        IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 1 # INC                         STANDARD_R/M_EXPECTED$ !error
~ AL INC                          « FE C0 »
~ BX INC                          « 66 FF C3 »
~ ECX INC                         « FF C1 »
~ RDX INC                         « 48 FF C2 »
~ BYTE PTR 0 [RAX] INC            « FE 00 »
~ WORD PTR 0 [RBX] INC            « 66 FF 03 »
~ DWORD PTR 0 [RCX] INC           « FF 01 »
~ QWORD PTR 0 [RDX] INC           « 48 FF 02 »
~ OWORD PTR 0 [RSI] INC           STANDARD_R/M_EXPECTED$ !error
~ BYTE PTR INS                    « 6C »
~ WORD PTR INS                    « 66 6D »
~ DWORD PTR INS                   « 6D »
~ QWORD PTR INS                   « 48 6D »
~ 10 # XMM1 XMM2 INSERTPS         « 66 0F 3A 21 D1 10 »
~ -10 # DWORD PTR 0 [RSI] XMM0 INSERTPS  « 66 0F 3A 21 06 F0 »
~ 1 u# INT                        « CD 01 »
~ 3 u# INT                        « CC »
~ FF u# INT                       « CD FF »
~ 1000 u# INT                     IMMEDIATE8_OPERAND_EXPECTED$ !error
~ RAX INT                         IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 0 [RSI] INVLPG                  « 0F 01 3E »
~ RAX INVLPG                      ADDRESS_OPERAND_EXPECTED$ !error
~ OWORD PTR CS: 0 [RDI] INVLPG    « 2E 0F 01 3F »
~ IRET                            « 48 CF »
~ there 2+ # 0= ?JMP              « 74 00 »
~ there 2+ # ≥ ?JMP               « 7D 00 »
~ there 2+ # U< ?JMP              « 72 00 »
~ there 100 - # U< ?JMP           TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ there 100 + # U< ?JMP           TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ there 10 + # JMP                « EB 0E »
~ there 10 + # NEAR JMP           « E9 0B 00 00 00 »
~ there 1000 + # JMP              « E9 FB 0F 00 00 »
~ 0 [RBX] [RBX] *8 JMP            « FF 24 DB »
~ 0 [] JMP                        « FF 24 25 00 00 00 00 »
~ RBX JMP                         « 48 FF E3 »
~ AX BX LAR                       « 66 0F 02 D8 »
~ BX EAX LAR                      « 0F 02 C3 »
~ CX RDX LAR                      « 48 0F 02 D1 »
~ ECX ESI LAR                     R/M_16_EXPECTED$ !error
~ AX DL LAR                       REGISTER_16+_EXPECTED$ !error
~ AL BX LAR                       R/M_16_EXPECTED$ !error
~ WORD PTR 0 [RSI] EAX LAR        « 0F 02 06 »
~ DWORD PTR 0 [RSI] RAX LAR       R/M_16_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 LDDQU    « F2 0F F0 06 »
~ DWORD PTR 0 [RSI] XMM0 LDDQU    ADDRESS_128_OPERAND_EXPECTED$ !error
~ 0 [RSI] XMM0 LDDQU              ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM1 XMM0 LDDQU                 ADDRESS_128_OPERAND_EXPECTED$ !error
~ RAX XMM0 LDDQU                  ADDRESS_128_OPERAND_EXPECTED$ !error
~ RAX LDMXCSR                     ADDRESS_32_OPERAND_EXPECTED$ !error
~ DWORD PTR 0 [RSI] LDMXCSR       « 0F AE 16 »
~ 0 [RBX] SI LDS                  LEGACY_OPCODE$ !error
~ 0 [RBX] ESI LDS                 LEGACY_OPCODE$ !error
~ 0 [RBX] RSI LDS                 LEGACY_OPCODE$ !error
~ RAX RSI LDS                     LEGACY_OPCODE$ !error
~ RAX 0 [RBX] LDS                 LEGACY_OPCODE$ !error
~ 0 [RBX] SI LES                  LEGACY_OPCODE$ !error
~ 0 [RBX] ESI LES                 LEGACY_OPCODE$ !error
~ 0 [RBX] RSI LES                 LEGACY_OPCODE$ !error
~ RAX RSI LES                     LEGACY_OPCODE$ !error
~ RAX 0 [RBX] LES                 LEGACY_OPCODE$ !error
~ 0 [RBX] SI LFS                  « 66 0F B4 33 »
~ 0 [RBX] ESI LFS                 « 0F B4 33 »
~ 0 [RBX] RSI LFS                 « 48 0F B4 33 »
~ RAX RSI LFS                     ADDRESS_OPERAND_EXPECTED$ !error
~ RAX 0 [RBX] LFS                 REGISTER_16+_EXPECTED$ !error
~ 0 [RBX] SI LGS                  « 66 0F B5 33 »
~ 0 [RBX] ESI LGS                 « 0F B5 33 »
~ 0 [RBX] RSI LGS                 « 48 0F B5 33 »
~ 0 [RBX] SI LSS                  « 66 0F B2 33 »
~ 0 [RBX] ESI LSS                 « 0F B2 33 »
~ 0 [RBX] RSI LSS                 « 48 0F B2 33 »
~ 5 [RBX] [RCX] *8 SI LEA         « 66 8D 74 CB 05 »
~ -12 [R14] ESI LEA               « 41 8D 76 EE »
~ 0 [RIP] RSI LEA                 « 48 8D 35 00 00 00 00 »
~ RAX RSI LEA                     ADDRESS_OPERAND_EXPECTED$ !error
~ RAX 0 [RBX] LEA                 REGISTER_16+_EXPECTED$ !error
~ 0 [RAX] *8 RAX LEA              « 48 8D 04 C5 00 00 00 00 »
~ 0 [RAX] RAX LEA                 « 48 8D 00 »
~ LEAVE                           « C9 »
~ LFENCE                          « 0F AE 28 »
~ 0 [RSI] LGDT                    « 0F 01 16 »
~ RAX LGDT                        ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] LIDT                    « 0F 01 1E »
~ XMM1 LIDT                       ADDRESS_OPERAND_EXPECTED$ !error
~ AX LLDT                         « 0F 00 D0 »
~ WORD PTR 0 [RSI] LLDT           « 0F 00 16 »
~ 0 [RSI] LLDT                    R/M_16_EXPECTED$ !error
~ 1 # LLDT                        R/M_16_EXPECTED$ !error
~ AX LMSW                         « 0F 01 F0 »
~ WORD PTR 0 [RSI] LMSW           « 0F 01 36 »
~ LOCK                            « F0 »
~ BYTE PTR LODS                   « AC »
~ WORD PTR LODS                   « 66 AD »
~ DWORD PTR LODS                  « AD »
~ QWORD PTR LODS                  « 48 AD »
~ there # LOOP                    « E2 FE »
~ RAX LOOP                        IMMEDIATE_OPERAND_EXPECTED$ !error
~ there # 0= ?LOOP                « E1 FE »
~ there # = ?LOOP                 « E1 FE »
~ 1 # RAX ?LOOP                   CONDITION_OPERAND_EXPECTED$ !error
~ there # ≠ ?LOOP                 « E0 FE »
~ there # < ?LOOP                 EQ_OR_NEQ_REQUIRED$ !error
~ XMM0 XMM1 MASKMOVDQU            « 66 0F F7 C8 »
~ 0 [RSI] XMM2 MASKMOVDQU         XMM_REGISTER_EXPECTED$ !error
~ XMM3 0 [RSI] MASKMOVDQU         XMM_REGISTER_EXPECTED$ !error
~ MM0 MM1 MASKMOVQ                « 0F F7 C8 »
~ MM2 0 [RSI] MASKMOVQ            MMX_REGISTER_EXPECTED$ !error
~ 0 [RSI] MM2 MASKMOVQ            MMX_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 MAXPD                 « 66 0F 5F D1 »
~ OWORD PTR 0 [RSI] XMM0 MAXPD    « 66 0F 5F 06 »
~ XMM1 XMM2 MAXPS                 « 0F 5F D1 »
~ OWORD PTR 0 [RSI] XMM0 MAXPS    « 0F 5F 06 »
~ XMM1 XMM2 MAXSD                 « F2 0F 5F D1 »
~ QWORD PTR 0 [RSI] XMM0 MAXSD    « F2 0F 5F 06 »
~ XMM1 XMM2 MAXSS                 « F3 0F 5F D1 »
~ DWORD PTR 0 [RSI] XMM0 MAXSS    « F3 0F 5F 06 »
~ MFENCE                          « 0F AE 30 »
~ XMM1 XMM2 MINPD                 « 66 0F 5D D1 »
~ OWORD PTR 0 [RSI] XMM0 MINPD    « 66 0F 5D 06 »
~ XMM1 XMM2 MINPS                 « 0F 5D D1 »
~ OWORD PTR 0 [RSI] XMM0 MINPS    « 0F 5D 06 »
~ XMM1 XMM2 MINSD                 « F2 0F 5D D1 »
~ QWORD PTR 0 [RSI] XMM0 MINSD    « F2 0F 5D 06 »
~ XMM1 XMM2 MINSS                 « F3 0F 5D D1 »
~ DWORD PTR 0 [RSI] XMM0 MINSS    « F3 0F 5D 06 »
~ MONITOR                         « 0F 01 C8 »
~ 0 [] AL MOV                     « A0 00 00 00 00 00 00 00 00 »
~ 0 [] AX MOV                     « 66 A1 00 00 00 00 00 00 00 00 »
~ 0 [] EAX MOV                    « A1 00 00 00 00 00 00 00 00 »
~ 0 [] RAX MOV                    « 48 A1 00 00 00 00 00 00 00 00 »
~ 0 [] XMM1 MOV                   INVALID_OPERAND_COMBINATION$ !error
~ 0 [] BL MOV                     « 8A 1C 25 00 00 00 00 »
~ AL 0 [] MOV                     « A2 00 00 00 00 00 00 00 00 »
~ AX 0 [] MOV                     « 66 A3 00 00 00 00 00 00 00 00 »
~ EAX 0 [] MOV                    « A3 00 00 00 00 00 00 00 00 »
~ RAX 0 [] MOV                    « 48 A3 00 00 00 00 00 00 00 00 »
~ XMM1 0 [] MOV                   INVALID_OPERAND_COMBINATION$ !error
~ BL 0 [] MOV                     « 88 1C 25 00 00 00 00 »
~ WORD PTR 0 [] ES MOV            « 66 8E 04 25 00 00 00 00 »
~ AX DS MOV                       « 66 8E D8 »
~ DWORD PTR 0 [RBX] [RCX] *2 DS MOV  « 8E 1C 4B »
~ DX CS MOV                       INVALID_OPERAND_COMBINATION$ !error
~ WORD PTR 0 [RSP] [RDX] *4 CS MOV   INVALID_OPERAND_COMBINATION$ !error
~ CX SS MOV                       « 66 8E D1 »
~ QWORD PTR 0 [RBP] [RAX] *8 SS MOV  « 48 8E 54 C5 00 »
~ RDX FS MOV                      « 48 8E E2 »
~ WORD PTR 0 [] FS MOV            « 66 8E 24 25 00 00 00 00 »
~ EAX GS MOV                      « 8E E8 »
~ WORD PTR -12 [BX+SI] GS MOV     « 66 67 8E 68 EE »
~ AL ES MOV                       R/M_16+_EXPECTED$ !error
~ ES AX MOV                       « 66 8C C0 »
~ ES WORD PTR 0 [] MOV            « 66 8C 04 25 00 00 00 00 »
~ DS SI MOV                       « 66 8C DE »
~ DS DWORD PTR 0 [RBX] [RCX] *2 MOV  « 8C 1C 4B »
~ CS MM0 MOV                      R/M_16+_EXPECTED$ !error
~ CS WORD PTR 0 [RSP] [RDX] *4 MOV   « 66 8C 0C 94 »
~ SS CX MOV                       « 66 8C D1 »
~ SS QWORD PTR 0 [RBP] [RAX] *8 MOV  « 48 8C 54 C5 00 »
~ FS RDX MOV                      « 48 8C E2 »
~ FS QWORD PTR 0 [] MOV           « 48 8C 24 25 00 00 00 00 »
~ GS EAX MOV                      « 8C E8 »
~ GS DWORD PTR -12 [BX+SI] MOV    « 67 8C 68 EE »
~ GS AL MOV                       R/M_16+_EXPECTED$ !error
~ EDX CR0 MOV                     « 0F 22 C2 »
~ DWORD PTR 0 [RSI] CR4 MOV       « 0F 22 26 »
~ DX CR0 MOV                      R/M_32+_EXPECTED$ !error
~ RCX CR1 MOV                     « 48 0F 22 C9 »
~ CL CR1 MOV                      R/M_32+_EXPECTED$ !error
~ RBX CR8 MOV                     « 4C 0F 22 C3 »
~ QWORD PTR 0 [RSI] CR8 MOV       « 4C 0F 22 06 »
~ CR0 EDX MOV                     « 0F 20 C2 »
~ CR0 DWORD PTR 0 [RSI] MOV       « 0F 20 06 »
~ CR1 RCX MOV                     « 48 0F 20 C9 »
~ CR8 RBX MOV                     « 4C 0F 20 C3 »
~ CR8 DWORD PTR 0 [RSI] MOV       « 44 0F 20 06 »
~ EDX DR0 MOV                     « 0F 23 C2 »
~ DWORD PTR 0 [RSI] DR0 MOV       « 0F 23 06 »
~ WORD PTR 0 [RSI] DR0 MOV        R/M_32+_EXPECTED$ !error
~ RCX DR1 MOV                     « 48 0F 23 C9 »
~ QWORD PTR 0 CS: [RDI] DR1 MOV   « 2E 48 0F 23 0F »
~ RBX DR8 MOV                     « 4C 0F 23 C3 »
~ DR0 EDX MOV                     « 0F 21 C2 »
~ DR1 RCX MOV                     « 48 0F 21 C9 »
~ DR8 RBX MOV                     « 4C 0F 21 C3 »
~ 0 [RSI] [RCX] BL MOV            « 8A 1C 0E »
~ 0 [RSI] [RCX] *2 BX MOV         « 66 8B 1C 4E »
~ 0 [RSI] [RCX] *4 EBX MOV        « 8B 1C 8E »
~ 0 [RSI] [RCX] *8 RBX MOV        « 48 8B 1C CE »
~ BL 0 [RSI] [RCX] MOV            « 88 1C 0E »
~ BX 0 [RSI] [RCX] *2 MOV         « 66 89 1C 4E »
~ EBX 0 [RSI] [RCX] *4 MOV        « 89 1C 8E »
~ RBX 0 [RSI] [RCX] *8 MOV        « 48 89 1C CE »
~ AL BL MOV                       « 8A D8 »
~ AX BX MOV                       « 66 8B D8 »
~ EBX EAX MOV                     « 8B C3 »
~ RSI R08 MOV                     « 4C 8B C6 »
~ AL EDX MOV                      OPERAND_SIZE_MISMATCH$ !error
~ XMM0 RAX MOV                    OPERAND_SIZE_MISMATCH$ !error
~ RAX XMM0 MOV                    INVALID_OPERAND_SIZE$ !error
~ 0 [RSI] MM0 MOV                 INVALID_OPERAND_COMBINATION$ !error
~ MM1 0 [RDI] MOV                 INVALID_OPERAND_COMBINATION$ !error
~ 10 # CL MOV                     « B1 10 »
~ 10 # CX MOV                     « 66 B9 10 00 »
~ 10 # ECX MOV                    « B9 10 00 00 00 »
~ 10 # RCX MOV                    « 48 B9 10 00 00 00 00 00 00 00 »
~ 10000 # CL MOV                  IMMEDIATE_TOO_BIG$ !error
~ 10000 # CX MOV                  IMMEDIATE_TOO_BIG$ !error
~ 10000 # ECX MOV                 « B9 00 00 01 00 »
~ 100000000 # ECX MOV             IMMEDIATE_TOO_BIG$ !error
~ 123456789 # RCX MOV             « 48 B9 89 67 45 23 01 00 00 00 »
~ 0 # BYTE PTR 0 [RAX] MOV        « C6 00 00 »
~ 3 # WORD PTR 0 [RSI] MOV        « 66 C7 06 03 00 »
~ 6 # DWORD PTR 0 [RBP] MOV       « C7 45 00 06 00 00 00 »
~ 6 # QWORD PTR 0 [RSP] MOV       « 48 C7 04 24 06 00 00 00 »
~ -6 # QWORD PTR 0 [RDI] MOV      « 48 C7 07 FA FF FF FF »
~ OWORD PTR 0 [RSI] XMM0 MOVAPD   « 66 0F 28 06 »
~ XMM1 OWORD PTR 0 [RSI] MOVAPD   « 66 0F 29 0E »
~ XMM2 XMM3 MOVAPD                « 66 0F 28 DA »
~ OWORD PTR 0 [RSI] XMM0 MOVAPS   « 0F 28 06 »
~ XMM1 OWORD PTR 0 [RSI] MOVAPS   « 0F 29 0E »
~ XMM2 XMM3 MOVAPS                « 0F 28 DA »
~ AX AX MOVBE                     ADDRESS_OPERAND_EXPECTED$ !error
~ WORD PTR 0 [RSI] AX MOVBE       « 66 0F 38 F0 06 »
~ DWORD PTR 0 [RBX] EAX MOVBE     « 0F 38 F0 03 »
~ QWORD PTR 0 [RAX] RCX MOVBE     « 48 0F 38 F0 08 »
~ WORD PTR 0 [RSI] AX MOVBE       « 66 0F 38 F0 06 »
~ DWORD PTR 0 [RBX] EAX MOVBE     « 0F 38 F0 03 »
~ QWORD PTR 0 [RAX] RCX MOVBE     « 48 0F 38 F0 08 »
~ 10 # OWORD PTR 0 [RSI] MOVBE    INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [RSI] XMM0 MOVBE    INVALID_OPERAND_SIZE$ !error
~ EAX MM0 MOVD                    « 0F 6E C0 »
~ DWORD PTR 0 [RSI] MM0 MOVD      « 0F 6E 06 »
~ EAX XMM0 MOVD                   « 66 0F 6E C0 »
~ DWORD PTR 0 [RSI] XMM0 MOVD     « 66 0F 6E 06 »
~ MM0 EAX MOVD                    « 0F 7E C0 »
~ MM0 DWORD PTR 0 [RSI] MOVD      « 0F 7E 06 »
~ XMM0 EAX MOVD                   « 66 0F 7E C0 »
~ XMM0 DWORD PTR 0 [RSI] MOVD     « 66 0F 7E 06 »
~ MM0 QWORD PTR 0 [RSI] MOVD      R/M_32_EXPECTED$ !error
~ MM0 AX MOVD                     R/M_32_EXPECTED$ !error
~ RAX MM0 MOVQ                    « 48 0F 6E C0 »
~ QWORD PTR 0 [RSI] MM0 MOVQ      « 48 0F 6E 06 »
~ RAX XMM0 MOVQ                   « 66 48 0F 6E C0 »
~ QWORD PTR 0 [RSI] XMM0 MOVQ     « 66 48 0F 6E 06 »
~ MM0 RAX MOVQ                    « 48 0F 7E C0 »
~ MM0 QWORD PTR 0 [RSI] MOVQ      « 48 0F 7E 06 »
~ XMM0 RAX MOVQ                   « 66 48 0F 7E C0 »
~ XMM0 QWORD PTR 0 [RSI] MOVQ     « 66 48 0F 7E 06 »
~ MM0 OWORD PTR 0 [RSI] MOVQ      R/M_64_EXPECTED$ !error
~ MM0 AX MOVQ                     R/M_64_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 MOVDQA   « 66 0F 6F 06 »
~ XMM1 OWORD PTR 0 [RSI] MOVDQA   « 66 0F 7F 0E »
~ XMM2 XMM3 MOVDQA                « 66 0F 6F DA »
~ OWORD PTR 0 [RSI] XMM0 MOVDQU   « F3 0F 6F 06 »
~ XMM1 OWORD PTR 0 [RSI] MOVDQU   « F3 0F 7F 0E »
~ XMM2 XMM3 MOVDQU                « F3 0F 6F DA »
~ XMM7 MM3 MOVDQ2Q                « F2 0F D6 DF »
~ QWORD PTR 0 [RSI] MM1 MOVDQ2Q   XMM_REGISTER_EXPECTED$ !error
~ XMM5 QWORD PTR 0 [RSI] MOVDQ2Q  MMX_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 MOVHLPS               « 0F 12 D1 »
~ QWORD PTR 0 [RSI] XMM2 MOVHLPS  XMM_REGISTER_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVHLPS  XMM_REGISTER_EXPECTED$ !error
~ XMM1 XMM5 MOVHPD                ADDRESS_64_OPERAND_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVHPD   « 66 0F 17 0F »
~ QWORD PTR 0 [RSI] XMM4 MOVHPD   « 66 0F 16 26 »
~ MM1 QWORD PTR 0 [RDI] MOVHPD    XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM4 MOVHPD    XMM_REGISTER_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVHPS   « 0F 17 0F »
~ QWORD PTR 0 [RSI] XMM4 MOVHPS   « 0F 16 26 »
~ XMM1 XMM5 MOVLPD                ADDRESS_64_OPERAND_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVLPD   « 66 0F 13 0F »
~ QWORD PTR 0 [RSI] XMM4 MOVLPD   « 66 0F 12 26 »
~ MM1 QWORD PTR 0 [RDI] MOVLPD    XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM4 MOVLPD    XMM_REGISTER_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVLPS   « 0F 13 0F »
~ QWORD PTR 0 [RSI] XMM4 MOVLPS   « 0F 12 26 »
~ XMM1 AX MOVMSKPD                REGISTER_32+_EXPECTED$ !error
~ XMM1 EAX MOVMSKPD               « 66 0F 50 C1 »
~ XMM1 RAX MOVMSKPD               « 66 48 0F 50 C1 »
~ QWORD PTR 0 [RSI] EAX MOVMSKPD  XMM_REGISTER_EXPECTED$ !error
~ RAX EAX MOVMSKPD                XMM_REGISTER_EXPECTED$ !error
~ XMM1 DWORD PTR 0 [RSI] MOVMSKPD REGISTER_32+_EXPECTED$ !error
~ XMM1 EAX MOVMSKPS               « 0F 50 C1 »
~ XMM1 RAX MOVMSKPS               « 48 0F 50 C1 »
~ XMM1 XMM5 MOVNTDQA              ADDRESS_128_OPERAND_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM7 MOVNTDQA « 66 0F 38 2A 3E »
~ DWORD PTR 0 [RSI] XMM6 MOVNTDQA ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM7 OWORD PTR 0 [RSI] MOVNTDQA XMM_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM7 MOVNTDQ  ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM6 DWORD PTR 0 [RSI] MOVNTDQ  ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM7 OWORD PTR 0 [RSI] MOVNTDQ  « 66 0F E7 3E »
~ EBX DWORD PTR 0 [RSI] MOVNTI    « 0F C3 1E »
~ DWORD PTR 0 [RSI] EBX MOVNTI    REGISTER_32+_EXPECTED$ !error
~ BX 0 [RSI] MOVNTI               REGISTER_32+_EXPECTED$ !error
~ RAX 0 [RSP] MOVNTI              « 48 0F C3 04 24 »
~ XMM1 OWORD PTR -2500 [RBP] MOVNTPD    « 66 0F 2B 8D 00 DB FF FF »
~ XMM1 OWORD PTR 2500 [RBP] MOVNTPS     « 0F 2B 8D 00 25 00 00 »
~ MM0 QWORD PTR 1 [RCX] [RAX] *4 MOVNTQ    « 0F E7 44 81 01 »
~ QWORD PTR 1 [RCX] [RAX] *4 MM0 MOVNTQ    ADDRESS_OPERAND_EXPECTED$ !error
~ MM0 MM1 MOVNTQ                  ADDRESS_OPERAND_EXPECTED$ !error
~ MM3 MM5 MOVQ                    « 0F 6F EB »
~ XMM3 XMM5 MOVQ                  « F3 0F 7E EB »
~ BYTE PTR MOVS                   « A4 »
~ WORD PTR MOVS                   « 66 A5 »
~ DWORD PTR MOVS                  « A5 »
~ QWORD PTR MOVS                  « 48 A5 »
~ XMM2 XMM3 MOVSD                 « F2 0F 10 DA »
~ QWORD PTR 0 [RSI] XMM7 MOVSD    « F2 0F 10 3E »
~ XMM6 QWORD PTR 0 [RDI] MOVSD    « F2 0F 11 37 »
~ RAX XMM0 MOVSD                  XMM_REGMEM64_EXPECTED$ !error
~ 0 [RSI] XMM5 MOVSD              XMM_REGMEM64_EXPECTED$ !error
~ XMM1 DWORD PTR 0 [RDI] MOVSD    XMM_REGMEM64_EXPECTED$ !error
~ AL AL MOVSX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVSX                     « 66 0F BE C3 »
~ BYTE PTR 0 [RSI] DX MOVSX       « 66 0F BE 16 »
~ BL EBX MOVSX                    « 0F BE DB »
~ BYTE PTR 0 [RSI] ECX MOVSX      « 0F BE 0E »
~ AL RSI MOVSX                    « 48 0F BE F0 »
~ BYTE PTR 0 [RSI] RBP MOVSX      « 48 0F BE 2E »
~ AL WORD PTR 0 [RDI] MOVSX       REGISTER_16_EXPECTED$ !error
~ BX EDI MOVSX                    « 0F BF FB »
~ WORD PTR 0 [RSI] ESP MOVSX      « 0F BF 26 »
~ R12W R13 MOVSX                  « 4D 0F BF EC »
~ WORD PTR 12 [RIP] R08 MOVSX     « 4C 0F BF 05 12 00 00 00 »
~ EDI RAX MOVSXD                  « 48 63 C7 »
~ DWORD PTR -7 [RSI] [RCX] *4 R15 MOVSXD   « 4C 63 7C 8E F9 »
~ XMM6 XMM5 MOVUPD                « 66 0F 10 EE »
~ OWORD PTR 0 [RSI] XMM0 MOVUPD   « 66 0F 10 06 »
~ XMM1 OWORD PTR 0 [RDI] MOVUPD   « 66 0F 11 0F »
~ XMM6 XMM5 MOVUPS                « 0F 10 EE »
~ OWORD PTR 0 [RSI] XMM0 MOVUPS   « 0F 10 06 »
~ XMM1 OWORD PTR 0 [RDI] MOVUPS   « 0F 11 0F »
~ AH R13 MOVSX                    HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ AL AL MOVZX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVZX                     « 66 0F B6 C3 »
~ BYTE PTR 0 [RSI] DX MOVZX       « 66 0F B6 16 »
~ BL EBX MOVZX                    « 0F B6 DB »
~ BYTE PTR 0 [RSI] ECX MOVZX      « 0F B6 0E »
~ AL RSI MOVZX                    « 48 0F B6 F0 »
~ BYTE PTR 0 [RSI] RBP MOVZX      « 48 0F B6 2E »
~ AL WORD PTR 0 [RDI] MOVZX       REGISTER_16_EXPECTED$ !error
~ BX EDI MOVZX                    « 0F B7 FB »
~ WORD PTR 0 [RSI] ESP MOVZX      « 0F B7 26 »
~ R12W R13 MOVZX                  « 4D 0F B7 EC »
~ WORD PTR 12 [RIP] R08 MOVZX     « 4C 0F B7 05 12 00 00 00 »
~ AH R13 MOVZX                    HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ 22 # XMM0 XMM1 MPSADBW          « 66 0F 3A 42 C8 22 »
~ -9 # OWORD PTR 0 [RSI] XMM3 MPSADBW   « 66 0F 3A 42 1E F7 »
~ 1 # MUL                         INVALID_OPERAND_TYPE$ !error
~ AL MUL                          « F6 E0 »
~ BX MUL                          « 66 F7 E3 »
~ ECX MUL                         « F7 E1 »
~ RDX MUL                         « 48 F7 E2 »
~ BYTE PTR 0 [RAX] MUL            « F6 20 »
~ WORD PTR 0 [RBX] MUL            « 66 F7 23 »
~ DWORD PTR 0 [RCX] MUL           « F7 21 »
~ QWORD PTR 0 [RDX] MUL           « 48 F7 22 »
~ OWORD PTR 0 [RSI] MUL           INVALID_OPERAND_SIZE$ !error
~ XMM1 XMM2 MULPD                 « 66 0F 59 D1 »
~ OWORD PTR 0 [RSI] XMM0 MULPD    « 66 0F 59 06 »
~ XMM1 XMM2 MULPS                 « 0F 59 D1 »
~ OWORD PTR 0 [RSI] XMM0 MULPS    « 0F 59 06 »
~ XMM1 XMM2 MULSD                 « F2 0F 59 D1 »
~ QWORD PTR 0 [RSI] XMM0 MULSD    « F2 0F 59 06 »
~ XMM1 XMM2 MULSS                 « F3 0F 59 D1 »
~ DWORD PTR 0 [RSI] XMM0 MULSS    « F3 0F 59 06 »
~ MWAIT                           « 0F 01 C9 »
~ 1 # NEG                         INVALID_OPERAND_TYPE$ !error
~ AL NEG                          « F6 D8 »
~ BX NEG                          « 66 F7 DB »
~ ECX NEG                         « F7 D9 »
~ RDX NEG                         « 48 F7 DA »
~ BYTE PTR 0 [RAX] NEG            « F6 18 »
~ WORD PTR 0 [RBX] NEG            « 66 F7 1B »
~ DWORD PTR 0 [RCX] NEG           « F7 19 »
~ QWORD PTR 0 [RDX] NEG           « 48 F7 1A »
~ OWORD PTR 0 [RSI] NEG           INVALID_OPERAND_SIZE$ !error
~ NOP                             « 90 »
~ -1 # NOP                        INVALID_NOP_SIZE$ !error
~ 1 # NOP                         « 90 »
~ 2 # NOP                         « 66 90 »
~ 3 # NOP                         « 0F 1F 00 »
~ 4 # NOP                         « 0F 1F 40 00 »
~ 5 # NOP                         « 0F 1F 44 00 00 »
~ 6 # NOP                         « 66 0F 1F 44 00 00 »
~ 7 # NOP                         « 0F 1F 80 00 00 00 00 »
~ 8 # NOP                         « 0F 1F 84 00 00 00 00 00 »
~ 9 # NOP                         « 66 0F 1F 84 00 00 00 00 00 »
~ 13 # NOP                        INVALID_NOP_SIZE$ !error
~ 1 # NOT                         INVALID_OPERAND_TYPE$ !error
~ AL NOT                          « F6 D0 »
~ BX NOT                          « 66 F7 D3 »
~ ECX NOT                         « F7 D1 »
~ RDX NOT                         « 48 F7 D2 »
~ BYTE PTR 0 [RAX] NOT            « F6 10 »
~ WORD PTR 0 [RBX] NOT            « 66 F7 13 »
~ DWORD PTR 0 [RCX] NOT           « F7 11 »
~ QWORD PTR 0 [RDX] NOT           « 48 F7 12 »
~ OWORD PTR 0 [RSI] NOT           INVALID_OPERAND_SIZE$ !error
~ AL AH OR                        « 08 C4 »
~ DX 0 [RSI] OR                   « 66 09 16 »
~ AL BPL OR                       « 40 08 C5 »
~ QWORD PTR -123 [BP+DI] RSI OR   « 67 48 0B B3 DD FE »
~ XMM7 XMM1 OR                    STANDARD_REGISTER_EXPECTED$ !error
~ SP SP OR                        « 66 09 E4 »
~ CR0 RAX OR                      STANDARD_REGISTER_EXPECTED$ !error
~ CS DS OR                        STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 ANDPD                 « 66 0F 54 C0 »
~ OWORD PTR 0 [R10] XMM7 ANDPS    « 41 0F 54 3A »
~ AL 10 # OUT                     « E6 10 »
~ AL 1000 # OUT                   IMMEDIATE8_OPERAND_EXPECTED$ !error
~ AX 10 # OUT                     « 66 E7 10 »
~ EAX 10 # OUT                    « E7 10 »
~ RAX 10 # OUT                    INVALID_OPERAND_SIZE$ !error
~ BL 10 # OUT                     ACCU_OPERAND_REQUIRED$ !error
~ AL DX OUT                       « EE »
~ AX DX OUT                       « 66 EF »
~ EAX DX OUT                      « EF »
~ RAX DX OUT                      INVALID_OPERAND_SIZE$ !error
~ CL DX OUT                       ACCU_OPERAND_REQUIRED$ !error
~ AL CX OUT                       IMMEDIATE8_OPERAND_EXPECTED$ !error
~ BYTE PTR OUTS                   « 6E »
~ WORD PTR OUTS                   « 66 6F »
~ DWORD PTR OUTS                  « 6F »
~ QWORD PTR OUTS                  « 48 6F »
~ MM1 MM2 PABSB                   « 0F 38 1C D1 »
~ QWORD PTR 0 [RSI] MM3 PABSB     « 0F 38 1C 1E »
~ XMM1 XMM2 PABSB                 « 66 0F 38 1C D1 »
~ OWORD PTR 0 [RBX] XMM3 PABSB    « 66 0F 38 1C 1B »
~ MM1 QWORD PTR 0 [RSI] PABSB     INVALID_OPERAND_COMBINATION$ !error
~ XMM1 OWORD PTR 0 [RBX] PABSB    INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 0 [RSI] RAX PABSB     INVALID_OPERAND_COMBINATION$ !error
~ MM1 MM2 PABSW                   « 0F 38 1D D1 »
~ QWORD PTR 0 [RSI] MM3 PABSW     « 0F 38 1D 1E »
~ XMM1 XMM2 PABSW                 « 66 0F 38 1D D1 »
~ OWORD PTR 0 [RBX] XMM3 PABSW    « 66 0F 38 1D 1B »
~ MM1 MM2 PABSD                   « 0F 38 1E D1 »
~ QWORD PTR 0 [RSI] MM3 PABSD     « 0F 38 1E 1E »
~ XMM1 XMM2 PABSD                 « 66 0F 38 1E D1 »
~ OWORD PTR 0 [RBX] XMM3 PABSD    « 66 0F 38 1E 1B »
~ MM1 MM2 PACKSSWB                « 0F 63 D1 »
~ QWORD PTR 0 [RSI] MM3 PACKSSWB  « 0F 63 1E »
~ XMM1 XMM2 PACKSSWB              « 66 0F 63 D1 »
~ OWORD PTR 0 [RBX] XMM3 PACKSSWB « 66 0F 63 1B »
~ MM1 QWORD PTR 0 [RSI] PACKSSWB  INVALID_OPERAND_COMBINATION$ !error
~ XMM1 OWORD PTR 0 [RBX] PACKSSWB INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 0 [RSI] RAX PACKSSWB  INVALID_OPERAND_COMBINATION$ !error
~ OWORD PTR 0 [RBX] XMM3 PACKSSDW « 66 0F 6B 1B »
~ MM1 QWORD PTR 0 [RSI] PACKSSDW  INVALID_OPERAND_COMBINATION$ !error
~ XMM1 OWORD PTR 0 [RBX] PACKSSDW INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 0 [RSI] RAX PACKSSDW  INVALID_OPERAND_COMBINATION$ !error
~ XMM6 XMM7 PACKUSDW              « 66 0F 38 2B FE »
~ OWORD PTR 0 [RSI] XMM0 PACKUSDW « 66 0F 38 2B 06 »
~ MM1 MM2 PACKUSWB                « 0F 67 D1 »
~ QWORD PTR 0 [RBX] MM3 PACKUSWB  « 0F 67 1B »
~ XMM1 XMM2 PACKUSWB              « 66 0F 67 D1 »
~ OWORD PTR 0 [RBX] XMM3 PACKUSWB « 66 0F 67 1B »
~ MM1 MM2 PADDB                   « 0F FC D1 »
~ QWORD PTR 0 [RSI] MM3 PADDB     « 0F FC 1E »
~ XMM1 XMM2 PADDB                 « 66 0F FC D1 »
~ OWORD PTR 0 [RBX] XMM3 PADDB    « 66 0F FC 1B »
~ MM1 MM2 PADDW                   « 0F FD D1 »
~ QWORD PTR 0 [RSI] MM3 PADDW     « 0F FD 1E »
~ XMM1 XMM2 PADDW                 « 66 0F FD D1 »
~ OWORD PTR 0 [RBX] XMM3 PADDW    « 66 0F FD 1B »
~ MM1 MM2 PADDD                   « 0F FE D1 »
~ QWORD PTR 0 [RSI] MM3 PADDD     « 0F FE 1E »
~ XMM1 XMM2 PADDD                 « 66 0F FE D1 »
~ OWORD PTR 0 [RBX] XMM3 PADDD    « 66 0F FE 1B »
~ MM1 MM2 PADDQ                   « 0F D4 D1 »
~ QWORD PTR 0 [RSI] MM3 PADDQ     « 0F D4 1E »
~ XMM1 XMM2 PADDQ                 « 66 0F D4 D1 »
~ OWORD PTR 0 [RBX] XMM3 PADDQ    « 66 0F D4 1B »
~ MM1 MM2 PADDSB                  « 0F EC D1 »
~ QWORD PTR 0 [RSI] MM3 PADDSB    « 0F EC 1E »
~ XMM9 XMM8 PADDSB                « 66 45 0F EC C1 »
~ OWORD PTR 0 [R13] XMM15 PADDSB  « 66 45 0F EC 7D 00 »
~ MM1 MM2 PADDSW                  « 0F ED D1 »
~ QWORD PTR 0 [RSI] MM3 PADDSW    « 0F ED 1E »
~ XMM1 XMM2 PADDSW                « 66 0F ED D1 »
~ OWORD PTR 0 [RBX] XMM3 PADDSW   « 66 0F ED 1B »
~ MM1 MM2 PADDUSB                 « 0F DC D1 »
~ QWORD PTR 0 [RSI] MM3 PADDUSB   « 0F DC 1E »
~ XMM1 XMM2 PADDUSB               « 66 0F DC D1 »
~ OWORD PTR 0 [RBX] XMM3 PADDUSB  « 66 0F DC 1B »
~ MM1 MM2 PADDUSW                 « 0F DD D1 »
~ QWORD PTR 0 [RSI] MM3 PADDUSW   « 0F DD 1E »
~ XMM9 XMM8 PADDUSW               « 66 45 0F DD C1 »
~ OWORD PTR 0 [R15] XMM15 PADDUSW « 66 45 0F DD 3F »
~ 11 # MM3 MM4 PALIGNR            « 0F 3A 0F E3 11 »
~ 22 # QWORD PTR 4 [RSI] MM4 PALIGNR    « 0F 3A 0F 66 04 22 »
~ -3 # XMM3 XMM4 PALIGNR          « 66 0F 3A 0F E3 FD »
~ -9 # OWORD PTR 8 [RSI] XMM4 PALIGNR   « 66 0F 3A 0F 66 08 F7 »
~ MM1 MM2 PAND                    « 0F DB D1 »
~ QWORD PTR 0 [RSI] MM3 PAND      « 0F DB 1E »
~ XMM1 XMM2 PAND                  « 66 0F DB D1 »
~ OWORD PTR 0 [RBX] XMM3 PAND     « 66 0F DB 1B »
~ MM1 MM2 PANDN                   « 0F DF D1 »
~ QWORD PTR 0 [RSI] MM3 PANDN     « 0F DF 1E »
~ XMM1 XMM2 PANDN                 « 66 0F DF D1 »
~ OWORD PTR 0 [RBX] XMM3 PANDN    « 66 0F DF 1B »
~ PAUSE                           « F3 90 »
~ MM1 MM2 PAVGB                   « 0F E0 D1 »
~ QWORD PTR 0 [RSI] MM3 PAVGB     « 0F E0 1E »
~ XMM1 XMM2 PAVGB                 « 66 0F E0 D1 »
~ OWORD PTR 0 [RBX] XMM3 PAVGB    « 66 0F E0 1B »
~ MM1 MM2 PAVGW                   « 0F E3 D1 »
~ QWORD PTR 0 [RSI] MM3 PAVGW     « 0F E3 1E »
~ XMM1 XMM2 PAVGW                 « 66 0F E3 D1 »
~ OWORD PTR 0 [RBX] XMM3 PAVGW    « 66 0F E3 1B »
~ XMM6 XMM12 PBLENDVB             « 66 44 0F 38 10 E6 »
~ OWORD PTR 0 [RBX] XMM2 PBLENDVB « 66 0F 38 10 13 »
~ 4 # XMM0 XMM2 PBLENDW           « 66 0F 3A 0E D0 04 »
~ 0 # OWORD PTR 0 [RAX] XMM0 PBLENDW    « 66 0F 3A 0E 00 00 »
~ -25 # XMM4 XMM5 PCLMULQDQ       « 66 0F 3A 44 EC DB »
~ 7F # OWORD PTR 0 [RSI] XMM2 PCLMULQDQ    « 66 0F 3A 44 16 7F »
~ MM1 MM2 PCMPEQB                 « 0F 74 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPEQB   « 0F 74 1E »
~ XMM1 XMM2 PCMPEQB               « 66 0F 74 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPEQB  « 66 0F 74 1B »
~ MM1 MM2 PCMPEQW                 « 0F 75 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPEQW   « 0F 75 1E »
~ XMM1 XMM2 PCMPEQW               « 66 0F 75 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPEQW  « 66 0F 75 1B »
~ MM1 MM2 PCMPEQD                 « 0F 76 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPEQD   « 0F 76 1E »
~ XMM1 XMM2 PCMPEQD               « 66 0F 76 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPEQD  « 66 0F 76 1B »
~ MM1 MM2 PCMPEQQ                 XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM3 PCMPEQQ   XMM_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 PCMPEQQ               « 66 0F 38 29 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPEQQ  « 66 0F 38 29 1B »
~ 4 # XMM0 XMM2 PCMPESTRI         « 66 0F 3A 61 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPESTRI  « 66 0F 3A 61 00 01 »
~ 4 # XMM0 XMM2 PCMPESTRM         « 66 0F 3A 60 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPESTRM  « 66 0F 3A 60 00 01 »
~ MM1 MM2 PCMPGTB                 « 0F 64 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPGTB   « 0F 64 1E »
~ XMM1 XMM2 PCMPGTB               « 66 0F 64 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPGTB  « 66 0F 64 1B »
~ MM1 MM2 PCMPGTW                 « 0F 65 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPGTW   « 0F 65 1E »
~ XMM1 XMM2 PCMPGTW               « 66 0F 65 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPGTW  « 66 0F 65 1B »
~ MM1 MM2 PCMPGTD                 « 0F 66 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPGTD   « 0F 66 1E »
~ XMM1 XMM2 PCMPGTD               « 66 0F 66 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPGTD  « 66 0F 66 1B »
~ MM1 MM2 PCMPGTQ                 XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM3 PCMPGTQ   XMM_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 PCMPGTQ               « 66 0F 38 37 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPGTQ  « 66 0F 38 37 1B »
~ 4 # XMM0 XMM2 PCMPISTRI         « 66 0F 3A 63 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPISTRI  « 66 0F 3A 63 00 01 »
~ 4 # XMM0 XMM2 PCMPISTRM         « 66 0F 3A 62 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPISTRM  « 66 0F 3A 62 00 01 »
~ MM1 MM2 PCMPGTB                 « 0F 64 D1 »
~ QWORD PTR 0 [RSI] MM3 PCMPGTB   « 0F 64 1E »
~ XMM1 XMM2 PCMPGTB               « 66 0F 64 D1 »
~ OWORD PTR 0 [RBX] XMM3 PCMPGTB  « 66 0F 64 1B »
~ 1 # XMM1 CH PEXTRB              « 66 0F 3A 14 CD 01 »
~ 2 # XMM2 BYTE PTR 0 [RSI] PEXTRB   « 66 0F 3A 14 16 02 »
~ 3 # BYTE PTR 3 [RSI] XMM3 PEXTRB   R/M_8_EXPECTED$ !error
~ 4 # XMM4 EAX PEXTRB             R/M_8_EXPECTED$ !error
~ 5 # XMM5 ECX PEXTRD             « 66 0F 3A 16 E9 05 »
~ 6 # XMM6 DWORD PTR 6 [RSI] PEXTRD  « 66 0F 3A 16 76 06 06 »
~ 7 # DWORD PTR 7 [RSI] XMM7 PEXTRD  R/M_32_EXPECTED$ !error
~ 8 # XMM8 BYTE PTR 8 [RSI] PEXTRD   R/M_32_EXPECTED$ !error
~ 9 # XMM9 RSI PEXTRQ             « 66 4C 0F 3A 16 CE 09 »
~ 10 # XMM10 QWORD PTR 10 [RSI] PEXTRQ  « 66 4C 0F 3A 16 56 10 10 »
~ 11 # QWORD PTR 11 [RSI] XMM11 PEXTRQ   R/M_64_EXPECTED$ !error
~ 12 # XMM12 EAX PEXTRW           « 66 41 0F 3A 15 C4 12 »
~ 13 # XMM13 WORD PTR 13 [RSI] PEXTRW    « 66 44 0F C5 6E 13 13 »
~ 14 # XMM14 QWORD PTR 14 [RSI] PEXTRW   « 66 44 0F C5 76 14 14 »
~ 15 # WORD PTR 15 [RSI] XMM15 PEXTRW    REGISTER_16+_EXPECTED$ !error
~ 1 # MM1 DX PEXTRW               « 0F C5 D1 01 »
~ 2 # MM2 R10 PEXTRW              « 44 0F C5 D2 02 »
~ 3 # MM3 WORD PTR 3 [RSI] PEXTRW REGISTER_16+_EXPECTED$ !error
~ MM1 MM2 PHADDW                  « 0F 38 01 D1 »
~ QWORD PTR 0 [RSI] MM3 PHADDW    « 0F 38 01 1E »
~ XMM1 XMM2 PHADDW                « 66 0F 38 01 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHADDW   « 66 0F 38 01 1B »
~ MM1 MM2 PHADDD                  « 0F 38 02 D1 »
~ QWORD PTR 0 [RSI] MM3 PHADDD    « 0F 38 02 1E »
~ XMM1 XMM2 PHADDD                « 66 0F 38 02 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHADDD   « 66 0F 38 02 1B »
~ MM1 MM2 PHADDSW                 « 0F 38 03 D1 »
~ QWORD PTR 0 [RSI] MM3 PHADDSW   « 0F 38 03 1E »
~ XMM1 XMM2 PHADDSW               « 66 0F 38 03 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHADDSW  « 66 0F 38 03 1B »
~ XMM1 XMM2 PHMINPOSUW            « 66 0F 38 41 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHMINPOSUW  « 66 0F 38 41 1B »
~ MM1 MM2 PHSUBW                  « 0F 38 05 D1 »
~ QWORD PTR 0 [RSI] MM3 PHSUBW    « 0F 38 05 1E »
~ XMM1 XMM2 PHSUBW                « 66 0F 38 05 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHSUBW   « 66 0F 38 05 1B »
~ MM1 MM2 PHSUBD                  « 0F 38 06 D1 »
~ QWORD PTR 0 [RSI] MM3 PHSUBD    « 0F 38 06 1E »
~ XMM1 XMM2 PHSUBD                « 66 0F 38 06 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHSUBD   « 66 0F 38 06 1B »
~ MM1 MM2 PHSUBSW                 « 0F 38 07 D1 »
~ QWORD PTR 0 [RSI] MM3 PHSUBSW   « 0F 38 07 1E »
~ XMM1 XMM2 PHSUBSW               « 66 0F 38 07 D1 »
~ OWORD PTR 0 [RBX] XMM3 PHSUBSW  « 66 0F 38 07 1B »
~ 1 # CH XMM1 PINSRB              « 66 0F 3A 20 CD 01 »
~ 2 # BYTE PTR 0 [RSI] XMM2 PINSRB   « 66 0F 3A 20 16 02 »
~ 3 # XMM3 BYTE PTR 3 [RSI] PINSRB   XMM_REGISTER_EXPECTED$ !error
~ 4 # EAX XMM4 PINSRB             R/M_8_EXPECTED$ !error
~ 5 # ECX XMM5 PINSRD             « 66 0F 3A 22 E9 05 »
~ 6 # DWORD PTR 6 [RSI] XMM6 PINSRD  « 66 0F 3A 22 76 06 06 »
~ 7 # XMM7 DWORD PTR 7 [RSI] PINSRD  XMM_REGISTER_EXPECTED$ !error
~ 8 # BYTE PTR 8 [RSI] XMM8 PINSRD   R/M_32_EXPECTED$ !error
~ 9 # RSI XMM9 PINSRQ             « 66 4C 0F 3A 22 CE 09 »
~ 10 # QWORD PTR 10 [RSI] XMM10 PINSRQ  « 66 4C 0F 3A 22 56 10 10 »
~ 11 # XMM11 QWORD PTR 11 [RSI] PINSRQ   XMM_REGISTER_EXPECTED$ !error
~ 12 # EAX XMM12 PINSRW           « 66 44 0F C4 E0 12 »
~ 13 # WORD PTR 13 [RSI] XMM13 PINSRW   « 66 44 0F C4 6E 13 13 »
~ 14 # QWORD PTR 14 [RSI] XMM14 PINSRW  R32/M16_EXPECTED$ !error
~ 15 # XMM15 WORD PTR 15 [RSI] PINSRW   XMM_REGISTER_EXPECTED$ !error
~ 1 # EDX MM1 PINSRW              « 0F C4 CA 01 »
~ 2 # R10 MM2 PINSRW              R32/M16_EXPECTED$ !error
~ 3 # WORD PTR 3 [RSI] MM3 PINSRW « 0F C4 5E 03 03 »
~ MM1 MM2 PMADDUBSW               « 0F 38 04 D1 »
~ QWORD PTR 0 [RSI] MM3 PMADDUBSW « 0F 38 04 1E »
~ XMM1 XMM2 PMADDUBSW             « 66 0F 38 04 D1 »
~ OWORD PTR 0 [RBX] XMM3 PMADDUBSW   « 66 0F 38 04 1B »
~ MM1 MM2 PMADDWD                 « 0F F5 D1 »
~ QWORD PTR 0 [RSI] MM3 PMADDWD   « 0F F5 1E »
~ XMM1 XMM2 PMADDWD               « 66 0F F5 D1 »
~ OWORD PTR 0 [RBX] XMM3 PMADDWD  « 66 0F F5 1B »
~ XMM1 XMM2 PMAXSB                « 66 0F 38 3C D1 »
~ OWORD PTR 0 [RSI] XMM3 PMAXSB   « 66 0F 38 3C 1E »
~ XMM1 XMM2 PMAXSD                « 66 0F 38 3D D1 »
~ OWORD PTR 0 [RSI] XMM3 PMAXSD   « 66 0F 38 3D 1E »
~ MM1 MM2 PMAXSW                  « 0F EE D1 »
~ QWORD PTR 0 [RSI] MM3 PMAXSW    « 0F EE 1E »
~ XMM1 XMM2 PMAXSW                « 66 0F EE D1 »
~ OWORD PTR 0 [RBX] XMM3 PMAXSW   « 66 0F EE 1B »
~ MM1 MM2 PMAXUB                  « 0F DE D1 »
~ QWORD PTR 0 [RSI] MM3 PMAXUB    « 0F DE 1E »
~ XMM1 XMM2 PMAXUB                « 66 0F DE D1 »
~ OWORD PTR 0 [RBX] XMM3 PMAXUB   « 66 0F DE 1B »
~ XMM1 XMM2 PMAXUD                « 66 0F 38 3F D1 »
~ OWORD PTR 0 [RSI] XMM3 PMAXUD   « 66 0F 38 3F 1E »
~ XMM1 XMM2 PMAXUW                « 66 0F 38 3E D1 »
~ OWORD PTR 0 [RSI] XMM3 PMAXUW   « 66 0F 38 3E 1E »
~ XMM1 XMM2 PMINSB                « 66 0F 38 38 D1 »
~ OWORD PTR 0 [RSI] XMM3 PMINSB   « 66 0F 38 38 1E »
~ XMM1 XMM2 PMINSD                « 66 0F 38 39 D1 »
~ OWORD PTR 0 [RSI] XMM3 PMINSD   « 66 0F 38 39 1E »
~ MM1 MM2 PMINSW                  « 0F EA D1 »
~ QWORD PTR 0 [RSI] MM3 PMINSW    « 0F EA 1E »
~ XMM1 XMM2 PMINSW                « 66 0F EA D1 »
~ OWORD PTR 0 [RBX] XMM3 PMINSW   « 66 0F EA 1B »
~ MM1 MM2 PMINUB                  « 0F DA D1 »
~ QWORD PTR 0 [RSI] MM3 PMINUB    « 0F DA 1E »
~ XMM1 XMM2 PMINUB                « 66 0F DA D1 »
~ OWORD PTR 0 [RBX] XMM3 PMINUB   « 66 0F DA 1B »
~ XMM1 XMM2 PMINUD                « 66 0F 38 3B D1 »
~ OWORD PTR 0 [RSI] XMM3 PMINUD   « 66 0F 38 3B 1E »
~ XMM1 XMM2 PMINUW                « 66 0F 38 3A D1 »
~ OWORD PTR 0 [RSI] XMM3 PMINUW   « 66 0F 38 3A 1E »
~ MM4 BX PMOVMSKB                 REGISTER_32+_EXPECTED$ !error
~ MM5 ECX PMOVMSKB                « 0F D7 E9 »
~ MM6 RDX PMOVMSKB                « 48 0F D7 F2 »
~ MM7 MM0 PMOVMSKB                REGISTER_32+_EXPECTED$ !error
~ XMM4 BX PMOVMSKB                REGISTER_32+_EXPECTED$ !error
~ XMM5 ECX PMOVMSKB               « 66 0F D7 E9 »
~ XMM6 RDX PMOVMSKB               « 66 48 0F D7 F2 »
~ XMM7 MM0 PMOVMSKB               REGISTER_32+_EXPECTED$ !error
~ XMM1 XMM2 PMOVSXBW              « 66 0F 38 20 D1 »
~ QWORD PTR 0 [RSI] XMM3 PMOVSXBW « 66 0F 38 20 1E »
~ XMM1 XMM2 PMOVSXBD              « 66 0F 38 21 D1 »
~ DWORD PTR 0 [RSI] XMM5 PMOVSXBD « 66 0F 38 21 2E »
~ XMM1 XMM2 PMOVSXBQ              « 66 0F 38 22 D1 »
~ WORD PTR 0 [RSI] XMM7 PMOVSXBQ  « 66 0F 38 22 3E »
~ QWORD PTR 0 [RSI] XMM7 PMOVSXBQ XMM_REGMEM16_EXPECTED$ !error
~ XMM1 XMM2 PMOVSXWD              « 66 0F 38 23 D1 »
~ QWORD PTR 0 [RSI] XMM3 PMOVSXWD « 66 0F 38 23 1E »
~ XMM1 XMM2 PMOVSXWQ              « 66 0F 38 24 D1 »
~ DWORD PTR 0 [RSI] XMM3 PMOVSXWQ « 66 0F 38 24 1E »
~ XMM1 XMM2 PMOVSXDQ              « 66 0F 38 25 D1 »
~ QWORD PTR 0 [RSI] XMM3 PMOVSXDQ « 66 0F 38 25 1E »
~ XMM1 XMM2 PMOVZXBW              « 66 0F 38 30 D1 »
~ QWORD PTR 0 [RSI] XMM3 PMOVZXBW « 66 0F 38 30 1E »
~ XMM1 XMM2 PMOVZXBD              « 66 0F 38 31 D1 »
~ DWORD PTR 0 [RSI] XMM5 PMOVZXBD « 66 0F 38 31 2E »
~ XMM1 XMM2 PMOVZXBQ              « 66 0F 38 32 D1 »
~ WORD PTR 0 [RSI] XMM7 PMOVZXBQ  « 66 0F 38 32 3E »
~ QWORD PTR 0 [RSI] XMM7 PMOVZXBQ XMM_REGMEM16_EXPECTED$ !error
~ XMM1 XMM2 PMOVZXWD              « 66 0F 38 33 D1 »
~ QWORD PTR 0 [RSI] XMM3 PMOVZXWD « 66 0F 38 33 1E »
~ XMM1 XMM2 PMOVZXWQ              « 66 0F 38 34 D1 »
~ DWORD PTR 0 [RSI] XMM3 PMOVZXWQ « 66 0F 38 34 1E »
~ XMM1 XMM2 PMOVZXDQ              « 66 0F 38 35 D1 »
~ QWORD PTR 0 [RSI] XMM3 PMOVZXDQ « 66 0F 38 35 1E »
~ XMM15 XMM14 PMULDQ              « 66 45 0F 38 28 F7 »
~ OWORD PTR 0 [RCX] XMM5 PMULDQ   « 66 0F 38 28 29 »
~ MM1 MM2 PMULHRSW                « 0F 38 0B D1 »
~ QWORD PTR 0 [RSI] MM3 PMULHRSW  « 0F 38 0B 1E »
~ XMM1 XMM2 PMULHRSW              « 66 0F 38 0B D1 »
~ OWORD PTR 0 [RBX] XMM3 PMULHRSW « 66 0F 38 0B 1B »
~ MM1 MM2 PMULHUW                 « 0F E4 D1 »
~ QWORD PTR 0 [RSI] MM3 PMULHUW   « 0F E4 1E »
~ XMM1 XMM2 PMULHUW               « 66 0F E4 D1 »
~ OWORD PTR 0 [RBX] XMM3 PMULHUW  « 66 0F E4 1B »
~ MM1 MM2 PMULHW                  « 0F E5 D1 »
~ QWORD PTR 0 [RSI] MM3 PMULHW    « 0F E5 1E »
~ XMM1 XMM2 PMULHW                « 66 0F E5 D1 »
~ OWORD PTR 0 [RBX] XMM3 PMULHW   « 66 0F E5 1B »
~ XMM15 XMM14 PMULLD              « 66 45 0F 38 40 F7 »
~ OWORD PTR 0 [RCX] XMM5 PMULLD   « 66 0F 38 40 29 »
~ MM1 MM2 PMULLW                  « 0F D5 D1 »
~ QWORD PTR 0 [RSI] MM3 PMULLW    « 0F D5 1E »
~ XMM1 XMM2 PMULLW                « 66 0F D5 D1 »
~ OWORD PTR 0 [RBX] XMM3 PMULLW   « 66 0F D5 1B »
~ MM1 MM2 PMULUDQ                 « 0F F4 D1 »
~ QWORD PTR 0 [RSI] MM3 PMULUDQ   « 0F F4 1E »
~ XMM1 XMM2 PMULUDQ               « 66 0F F4 D1 »
~ OWORD PTR 0 [RBX] XMM3 PMULUDQ  « 66 0F F4 1B »
~ ES POP                          « 07 »
~ CS POP                          CANNOT_POP_CS$ !error
~ DS POP                          « 1F »
~ SS POP                          « 17 »
~ FS POP                          « 0F A1 »
~ GS POP                          « 0F A9 »
~ BX POP                          INVALID_OPERAND_SIZE$ !error
~ ECX POP                         INVALID_OPERAND_SIZE$ !error
~ RDX POP                         « 5A »
~ 0 [RSI] POP                     INVALID_OPERAND_SIZE$ !error
~ BYTE PTR -10 [RDI] POP          INVALID_OPERAND_SIZE$ !error
~ WORD PTR 11 [RDI] POP           INVALID_OPERAND_SIZE$ !error
~ DWORD PTR 12 [RDI] POP          INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 13 [RDI] POP          « 8F 47 13 »
~ OWORD PTR -14 [RDI] POP         INVALID_OPERAND_SIZE$ !error
~ MM0 POP                         INVALID_OPERAND_TYPE$ !error
~ XMM1 POP                        INVALID_OPERAND_TYPE$ !error
~ CR2 POP                         INVALID_OPERAND_TYPE$ !error
~ DR3 POP                         INVALID_OPERAND_TYPE$ !error
~ 5 # POP                         CANNOT_POP_CONSTANT$ !error
~ WORD PTR POPA                   LEGACY_OPCODE$ !error
~ DWORD PTR POPA                  LEGACY_OPCODE$ !error
~ QWORD PTR POPA                  LEGACY_OPCODE$ !error
~ BX CX POPCNT                    « 66 F3 0F B8 CB »
~ WORD PTR 88 [RIP] AX POPCNT     « 66 F3 0F B8 05 88 00 00 00 »
~ EDX BX POPCNT                   OPERAND_SIZE_MISMATCH$ !error
~ EBX ECX POPCNT                  « F3 0F B8 CB »
~ DWORD PTR 0 [RDX] EAX POPCNT    « F3 0F B8 02 »
~ RAX RAX POPCNT                  « F3 48 0F B8 C0 »
~ QWORD PTR 22 [RSI] RDX POPCNT   « F3 48 0F B8 56 22 »
~ RAX QWORD PTR 44 [RDI] POPCNT   REGISTER_16+_EXPECTED$ !error
~ 1 [RAX] EAX POPCNT              « F3 0F B8 40 01 »
~ OWORD PTR 1 [RAX] EAX POPCNT    OPERAND_SIZE_MISMATCH$ !error
~ WORD PTR POPF                   « 66 9D »
~ DWORD PTR POPF                  « 9D »
~ QWORD PTR POPF                  « 48 9D »
~ POPF                            « 9D »
~ MM1 MM2 POR                     « 0F EB D1 »
~ QWORD PTR 0 [RSI] MM3 POR       « 0F EB 1E »
~ XMM1 XMM2 POR                   « 66 0F EB D1 »
~ OWORD PTR 0 [RBX] XMM3 POR      « 66 0F EB 1B »
~ 0 [RDI] PREFETCHT0              « 0F 18 0F »
~ 5 [RSI] PREFETCHT1              « 0F 18 56 05 »
~ -12 [RBX] PREFETCHT2            « 0F 18 5B EE »
~ 1234567 [] PREFETCHNTA          « 0F 18 04 25 67 45 23 01 »
~ MM1 MM2 PSADBW                  « 0F F6 D1 »
~ QWORD PTR 0 [RSI] MM3 PSADBW    « 0F F6 1E »
~ XMM1 XMM2 PSADBW                « 66 0F F6 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSADBW   « 66 0F F6 1B »
~ MM1 MM2 PSHUFB                  « 0F 38 00 D1 »
~ QWORD PTR 0 [RSI] MM3 PSHUFB    « 0F 38 00 1E »
~ XMM1 XMM2 PSHUFB                « 66 0F 38 00 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSHUFB   « 66 0F 38 00 1B »
~ 5 # XMM1 XMM2 PSHUFD            « 66 0F 70 D1 05 »
~ -2 # OWORD PTR 0 [RBX] XMM3 PSHUFD    « 66 0F 70 1B FE »
~ 5 # XMM1 XMM2 PSHUFHW           « F3 0F 70 D1 05 »
~ -2 # OWORD PTR 0 [RBX] XMM3 PSHUFHW   « F3 0F 70 1B FE »
~ 5 # XMM1 XMM2 PSHUFLW           « F2 0F 70 D1 05 »
~ -2 # OWORD PTR 0 [RBX] XMM3 PSHUFLW   « F2 0F 70 1B FE »
~ 5 # MM1 MM2 PSHUFW              « 0F 70 D1 05 »
~ -2 # QWORD PTR 0 [RBX] MM3 PSHUFW     « 0F 70 1B FE »
~ MM1 MM2 PSIGNB                  « 0F 38 08 D1 »
~ QWORD PTR 0 [RSI] MM3 PSIGNB    « 0F 38 08 1E »
~ XMM1 XMM2 PSIGNB                « 66 0F 38 08 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSIGNB   « 66 0F 38 08 1B »
~ MM1 MM2 PSIGNW                  « 0F 38 09 D1 »
~ QWORD PTR 0 [RSI] MM3 PSIGNW    « 0F 38 09 1E »
~ XMM1 XMM2 PSIGNW                « 66 0F 38 09 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSIGNW   « 66 0F 38 09 1B »
~ MM1 MM2 PSIGND                  « 0F 38 0A D1 »
~ QWORD PTR 0 [RSI] MM3 PSIGND    « 0F 38 0A 1E »
~ XMM1 XMM2 PSIGND                « 66 0F 38 0A D1 »
~ OWORD PTR 0 [RBX] XMM3 PSIGND   « 66 0F 38 0A 1B »
~ 10 # MM1 PSLLDQ                 XMM_REGISTER_EXPECTED$ !error
~ 10 # XMM5 PSLLDQ                « 66 0F 73 FD 10 »
~ 10 # OWORD PTR 0 [RBX] PSLLDQ   XMM_REGISTER_EXPECTED$ !error
~ MM1 MM2 PSLLW                   « 0F F1 D1 »
~ QWORD PTR 0 [RSI] MM3 PSLLW     « 0F F1 1E »
~ XMM1 XMM2 PSLLW                 « 66 0F F1 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSLLW    « 66 0F F1 1B »
~ 4 # MM2 PSLLW                   « 0F 71 F2 04 »
~ 8 # XMM4 PSLLW                  « 66 0F 71 F4 08 »
~ MM1 MM2 PSLLD                   « 0F F2 D1 »
~ QWORD PTR 0 [RSI] MM3 PSLLD     « 0F F2 1E »
~ XMM1 XMM2 PSLLD                 « 66 0F F2 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSLLD    « 66 0F F2 1B »
~ 4 # MM2 PSLLD                   « 0F 72 F2 04 »
~ 8 # XMM4 PSLLD                  « 66 0F 72 F4 08 »
~ MM1 MM2 PSLLQ                   « 0F F3 D1 »
~ QWORD PTR 0 [RSI] MM3 PSLLQ     « 0F F3 1E »
~ XMM1 XMM2 PSLLQ                 « 66 0F F3 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSLLQ    « 66 0F F3 1B »
~ 4 # MM2 PSLLQ                   « 0F 73 F2 04 »
~ 8 # XMM4 PSLLQ                  « 66 0F 73 F4 08 »
~ MM1 MM2 PSRAW                   « 0F E1 D1 »
~ QWORD PTR 0 [RSI] MM3 PSRAW     « 0F E1 1E »
~ XMM1 XMM2 PSRAW                 « 66 0F E1 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSRAW    « 66 0F E1 1B »
~ 4 # MM2 PSRAW                   « 0F 71 E2 04 »
~ 8 # XMM4 PSRAW                  « 66 0F 71 E4 08 »
~ MM1 MM2 PSRAD                   « 0F E2 D1 »
~ QWORD PTR 0 [RSI] MM3 PSRAD     « 0F E2 1E »
~ XMM1 XMM2 PSRAD                 « 66 0F E2 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSRAD    « 66 0F E2 1B »
~ 4 # MM2 PSRAD                   « 0F 72 E2 04 »
~ 8 # XMM4 PSRAD                  « 66 0F 72 E4 08 »
~ 10 # MM1 PSRLDQ                 XMM_REGISTER_EXPECTED$ !error
~ 10 # XMM5 PSRLDQ                « 66 0F 73 DD 10 »
~ 10 # OWORD PTR 0 [RBX] PSRLDQ   XMM_REGISTER_EXPECTED$ !error
~ MM1 MM2 PSRLW                   « 0F D1 D1 »
~ QWORD PTR 0 [RSI] MM3 PSRLW     « 0F D1 1E »
~ XMM1 XMM2 PSRLW                 « 66 0F D1 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSRLW    « 66 0F D1 1B »
~ 4 # MM2 PSRLW                   « 0F 71 D2 04 »
~ 8 # XMM4 PSRLW                  « 66 0F 71 D4 08 »
~ MM1 MM2 PSRLD                   « 0F D2 D1 »
~ QWORD PTR 0 [RSI] MM3 PSRLD     « 0F D2 1E »
~ XMM1 XMM2 PSRLD                 « 66 0F D2 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSRLD    « 66 0F D2 1B »
~ 4 # MM2 PSRLD                   « 0F 72 D2 04 »
~ 8 # XMM4 PSRLD                  « 66 0F 72 D4 08 »
~ MM1 MM2 PSRLQ                   « 0F D3 D1 »
~ QWORD PTR 0 [RSI] MM3 PSRLQ     « 0F D3 1E »
~ XMM1 XMM2 PSRLQ                 « 66 0F D3 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSRLQ    « 66 0F D3 1B »
~ 4 # MM2 PSRLQ                   « 0F 73 D2 04 »
~ 8 # XMM4 PSRLQ                  « 66 0F 73 D4 08 »
~ MM1 MM2 PSUBB                   « 0F F8 D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBB     « 0F F8 1E »
~ XMM1 XMM2 PSUBB                 « 66 0F F8 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBB    « 66 0F F8 1B »
~ MM1 MM2 PSUBW                   « 0F F9 D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBW     « 0F F9 1E »
~ XMM1 XMM2 PSUBW                 « 66 0F F9 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBW    « 66 0F F9 1B »
~ MM1 MM2 PSUBD                   « 0F FA D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBD     « 0F FA 1E »
~ XMM1 XMM2 PSUBD                 « 66 0F FA D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBD    « 66 0F FA 1B »
~ MM1 MM2 PSUBQ                   « 0F FB D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBQ     « 0F FB 1E »
~ XMM1 XMM2 PSUBQ                 « 66 0F FB D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBQ    « 66 0F FB 1B »
~ MM1 MM2 PSUBSB                  « 0F E8 D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBSB    « 0F E8 1E »
~ XMM1 XMM2 PSUBSB                « 66 0F E8 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBSB   « 66 0F E8 1B »
~ MM1 MM2 PSUBSW                  « 0F E9 D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBSW    « 0F E9 1E »
~ XMM1 XMM2 PSUBSW                « 66 0F E9 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBSW   « 66 0F E9 1B »
~ MM1 MM2 PSUBUSB                 « 0F D8 D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBUSB   « 0F D8 1E »
~ XMM1 XMM2 PSUBUSB               « 66 0F D8 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBUSB  « 66 0F D8 1B »
~ MM1 MM2 PSUBUSW                 « 0F D9 D1 »
~ QWORD PTR 0 [RSI] MM3 PSUBUSW   « 0F D9 1E »
~ XMM1 XMM2 PSUBUSW               « 66 0F D9 D1 »
~ OWORD PTR 0 [RBX] XMM3 PSUBUSW  « 66 0F D9 1B »
~ XMM1 XMM2 PTEST                 « 66 0F 38 17 D1 »
~ OWORD PTR 0 [RBX] XMM3 PTEST    « 66 0F 38 17 1B »
~ MM1 MM2 PUNPCKHBW               « 0F 68 D1 »
~ QWORD PTR 0 [RSI] MM3 PUNPCKHBW    « 0F 68 1E »
~ XMM1 XMM2 PUNPCKHBW             « 66 0F 68 D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHBW   « 66 0F 68 1B »
~ MM1 MM2 PUNPCKHWD               « 0F 69 D1 »
~ QWORD PTR 0 [RSI] MM3 PUNPCKHWD    « 0F 69 1E »
~ XMM1 XMM2 PUNPCKHWD             « 66 0F 69 D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHWD   « 66 0F 69 1B »
~ MM1 MM2 PUNPCKHDQ               « 0F 6A D1 »
~ QWORD PTR 0 [RSI] MM3 PUNPCKHDQ    « 0F 6A 1E »
~ XMM1 XMM2 PUNPCKHDQ             « 66 0F 6A D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHDQ   « 66 0F 6A 1B »
~ XMM1 XMM2 PUNPCKHQDQ            « 66 0F 6D D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHQDQ  « 66 0F 6D 1B »
~ MM1 MM2 PUNPCKLBW               « 0F 60 D1 »
~ QWORD PTR 0 [RSI] MM3 PUNPCKLBW    « 0F 60 1E »
~ XMM1 XMM2 PUNPCKLBW             « 66 0F 60 D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLBW   « 66 0F 60 1B »
~ MM1 MM2 PUNPCKLWD               « 0F 61 D1 »
~ QWORD PTR 0 [RSI] MM3 PUNPCKLWD    « 0F 61 1E »
~ XMM1 XMM2 PUNPCKLWD             « 66 0F 61 D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLWD   « 66 0F 61 1B »
~ MM1 MM2 PUNPCKLDQ               « 0F 62 D1 »
~ QWORD PTR 0 [RSI] MM3 PUNPCKLDQ    « 0F 62 1E »
~ XMM1 XMM2 PUNPCKLDQ             « 66 0F 62 D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLDQ   « 66 0F 62 1B »
~ XMM1 XMM2 PUNPCKLQDQ            « 66 0F 6C D1 »
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLQDQ  « 66 0F 6C 1B »
~ ES PUSH                         « 06 »
~ CS PUSH                         « 0E »
~ DS PUSH                         « 1E »
~ SS PUSH                         « 16 »
~ FS PUSH                         « 0F A0 »
~ GS PUSH                         « 0F A8 »
~ BX PUSH                         INVALID_OPERAND_SIZE$ !error
~ ECX PUSH                        INVALID_OPERAND_SIZE$ !error
~ RDX PUSH                        « 52 »
~ 0 [RSI] PUSH                    INVALID_OPERAND_SIZE$ !error
~ BYTE PTR -10 [RDI] PUSH         INVALID_OPERAND_SIZE$ !error
~ WORD PTR 11 [RDI] PUSH          INVALID_OPERAND_SIZE$ !error
~ DWORD PTR 12 [RDI] PUSH         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 13 [RDI] PUSH         « FF 77 13 »
~ OWORD PTR -14 [RDI] PUSH        INVALID_OPERAND_SIZE$ !error
~ MM0 PUSH                        INVALID_OPERAND_TYPE$ !error
~ XMM1 PUSH                       INVALID_OPERAND_TYPE$ !error
~ CR2 PUSH                        INVALID_OPERAND_TYPE$ !error
~ DR3 PUSH                        INVALID_OPERAND_TYPE$ !error
~ 5 # PUSH                        « 6A 05 »
~ 100 # PUSH                      « 66 68 00 01 »
~ 1234567 # PUSH                  « 68 67 45 23 01 »
~ MM1 MM2 PXOR                    « 0F EF D1 »
~ QWORD PTR 0 [RSI] MM3 PXOR      « 0F EF 1E »
~ XMM1 XMM2 PXOR                  « 66 0F EF D1 »
~ OWORD PTR 0 [RBX] XMM3 PXOR     « 66 0F EF 1B »
~ CL AL RCL                       « D2 D0 »
~ CL BYTE PTR 1 [RSI] RCL         « D2 56 01 »
~ 1 # AL RCL                      « D0 D0 »
~ 1 # BYTE PTR 2 [RSI] RCL        « D0 56 02 »
~ 5 # AL RCL                      « C0 D0 05 »
~ 5 # BYTE PTR 3 [RSI] RCL        « C0 56 03 05 »
~ CL BX RCL                       « 66 D3 D3 »
~ CL WORD PTR 4 [RSI] RCL         « 66 D3 56 04 »
~ 1 # BX RCL                      « 66 D1 D3 »
~ 1 # WORD PTR 5 [RSI] RCL        « 66 D1 56 05 »
~ 5 # BX RCL                      « 66 C1 D3 05 »
~ 5 # WORD PTR 6 [RSI] RCL        « 66 C1 56 06 05 »
~ CL ECX RCL                      « D3 D1 »
~ CL DWORD PTR 7 [RSI] RCL        « D3 56 07 »
~ 1 # ECX RCL                     « D1 D1 »
~ 1 # DWORD PTR 8 [RSI] RCL       « D1 56 08 »
~ 5 # ECX RCL                     « C1 D1 05 »
~ 5 # DWORD PTR 9 [RSI] RCL       « C1 56 09 05 »
~ CL RDX RCL                      « 48 D3 D2 »
~ CL QWORD PTR 0 [RSI] RCL        « 48 D3 16 »
~ 1 # RDX RCL                     « 48 D1 D2 »
~ 1 # QWORD PTR 1 [RSI] RCL       « 48 D1 56 01 »
~ 5 # RDX RCL                     « 48 C1 D2 05 »
~ 5 # QWORD PTR 2 [RSI] RCL       « 48 C1 56 02 05 »
~ AL BL RCL                       INVALID_OPERAND_COMBINATION$ !error
~ CL CR0 RCL                      STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR 0 [RSI] EDX RCL        INVALID_OPERAND_COMBINATION$ !error
~ CL AL RCR                       « D2 D8 »
~ CL BYTE PTR 1 [RSI] RCR         « D2 5E 01 »
~ 1 # AL RCR                      « D0 D8 »
~ 1 # BYTE PTR 2 [RSI] RCR        « D0 5E 02 »
~ 5 # AL RCR                      « C0 D8 05 »
~ 5 # BYTE PTR 3 [RSI] RCR        « C0 5E 03 05 »
~ CL BX RCR                       « 66 D3 DB »
~ CL WORD PTR 4 [RSI] RCR         « 66 D3 5E 04 »
~ CL AL ROL                       « D2 C0 »
~ CL BYTE PTR 1 [RSI] ROL         « D2 46 01 »
~ 1 # AL ROL                      « D0 C0 »
~ 1 # BYTE PTR 2 [RSI] ROL        « D0 46 02 »
~ 5 # AL ROL                      « C0 C0 05 »
~ 5 # BYTE PTR 3 [RSI] ROL        « C0 46 03 05 »
~ CL BX ROL                       « 66 D3 C3 »
~ CL WORD PTR 4 [RSI] ROL         « 66 D3 46 04 »
~ CL AL ROR                       « D2 C8 »
~ CL BYTE PTR 1 [RSI] ROR         « D2 4E 01 »
~ 1 # AL ROR                      « D0 C8 »
~ 1 # BYTE PTR 2 [RSI] ROR        « D0 4E 02 »
~ 5 # AL ROR                      « C0 C8 05 »
~ 5 # BYTE PTR 3 [RSI] ROR        « C0 4E 03 05 »
~ CL BX ROR                       « 66 D3 CB »
~ CL WORD PTR 4 [RSI] ROR         « 66 D3 4E 04 »
~ CL AL SAL                       « D2 E0 »
~ CL BYTE PTR 1 [RSI] SAL         « D2 66 01 »
~ 1 # AL SAL                      « D0 E0 »
~ 1 # BYTE PTR 2 [RSI] SAL        « D0 66 02 »
~ 5 # AL SAL                      « C0 E0 05 »
~ 5 # BYTE PTR 3 [RSI] SAL        « C0 66 03 05 »
~ CL BX SAL                       « 66 D3 E3 »
~ CL WORD PTR 4 [RSI] SAL         « 66 D3 66 04 »
~ CL AL SAR                       « D2 F8 »
~ CL BYTE PTR 1 [RSI] SAR         « D2 7E 01 »
~ 1 # AL SAR                      « D0 F8 »
~ 1 # BYTE PTR 2 [RSI] SAR        « D0 7E 02 »
~ 5 # AL SAR                      « C0 F8 05 »
~ 5 # BYTE PTR 3 [RSI] SAR        « C0 7E 03 05 »
~ CL BX SAR                       « 66 D3 FB »
~ CL WORD PTR 4 [RSI] SAR         « 66 D3 7E 04 »
~ CL AL SHL                       « D2 E0 »
~ CL BYTE PTR 1 [RSI] SHL         « D2 66 01 »
~ 1 # AL SHL                      « D0 E0 »
~ 1 # BYTE PTR 2 [RSI] SHL        « D0 66 02 »
~ 5 # AL SHL                      « C0 E0 05 »
~ 5 # BYTE PTR 3 [RSI] SHL        « C0 66 03 05 »
~ CL BX SHL                       « 66 D3 E3 »
~ CL WORD PTR 4 [RSI] SHL         « 66 D3 66 04 »
~ CL AL SHR                       « D2 E8 »
~ CL BYTE PTR 1 [RSI] SHR         « D2 6E 01 »
~ 1 # AL SHR                      « D0 E8 »
~ 1 # BYTE PTR 2 [RSI] SHR        « D0 6E 02 »
~ 5 # AL SHR                      « C0 E8 05 »
~ 5 # BYTE PTR 3 [RSI] SHR        « C0 6E 03 05 »
~ CL BX SHR                       « 66 D3 EB »
~ CL WORD PTR 4 [RSI] SHR         « 66 D3 6E 04 »
~ XMM1 XMM2 RCPPS                 « 0F 53 D1 »
~ OWORD PTR 0 [RBX] XMM3 RCPPS    « 0F 53 1B »
~ XMM1 XMM2 RCPSS                 « F3 0F 53 D1 »
~ DWORD PTR 0 [RBX] XMM3 RCPSS    « F3 0F 53 1B »
~ RDMSR                           « 0F 32 »
~ RDPMC                           « 0F 33 »
~ RDTSC                           « 0F 31 »
~ RDTSCP                          « 0F 01 F9 »
~ REP BYTE PTR MOVS               « F3 A4 »
~ REPE WORD PTR SCAS              « F3 66 AF »
~ REPZ DWORD PTR CMPS             « F3 A7 »
~ REPNE QWORD PTR SCAS            « F2 48 AF »
~ REPNZ BYTE PTR CMPS             « F2 A6 »
~ RET                             « C3 »
~ FAR RET                         « CB »
~ 2000 # RET                      « C2 00 20 »
~ -1000 # FAR RET                 « CA 00 F0 »
~ 4 # XMM0 XMM2 ROUNDPD           « 66 0F 3A 09 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 ROUNDPD    « 66 0F 3A 09 00 01 »
~ 4 # XMM0 XMM2 ROUNDPS           « 66 0F 3A 08 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 ROUNDPS    « 66 0F 3A 08 00 01 »
~ 4 # XMM0 XMM2 ROUNDSD           « 66 0F 3A 0B D0 04 »
~ 1 # QWORD PTR 0 [RAX] XMM0 ROUNDSD    « 66 0F 3A 0B 00 01 »
~ 4 # XMM0 XMM2 ROUNDSS           « 66 0F 3A 0A D0 04 »
~ 1 # DWORD PTR 0 [RAX] XMM0 ROUNDSS    « 66 0F 3A 0A 00 01 »
~ RSM                             « 0F AA »
~ XMM1 XMM2 RSQRTPS               « 0F 52 D1 »
~ OWORD PTR 0 [RBX] XMM3 RSQRTPS  « 0F 52 1B »
~ XMM1 XMM2 RSQRTSS               « F3 0F 52 D1 »
~ DWORD PTR 0 [RBX] XMM3 RSQRTSS  « F3 0F 52 1B »
~ SAHF                            LEGACY_OPCODE$ !error
~ AL AH SBB                       « 18 C4 »
~ DX 0 [RSI] SBB                  « 66 19 16 »
~ AL BPL SBB                      « 40 18 C5 »
~ QWORD PTR -123 [BP+DI] RSI SBB  « 67 48 1B B3 DD FE »
~ XMM7 XMM1 SBB                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP SBB                       « 66 19 E4 »
~ CR0 RAX SBB                     STANDARD_REGISTER_EXPECTED$ !error
~ CS DS SBB                       STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR SCAS                   « AE »
~ WORD PTR SCAS                   « 66 AF »
~ DWORD PTR SCAS                  « AF »
~ QWORD PTR SCAS                  « 48 AF »
~ AL 0= ?SET                      « 0F 94 C0 »
~ BYTE PTR 0 [RSI] U< ?SET        « 0F 92 06 »
~ RDX 0< ?SET                     R/M_8_EXPECTED$ !error
~ DWORD PTR 0 [RSI] PY ?SET       R/M_8_EXPECTED$ !error
~ SFENCE                          « 0F AE 38 »
~ WORD PTR 0 [RSI] SGDT           « 66 0F 01 06 »
~ 0 [RSI] SGDT                    « 0F 01 06 »
~ 33 # AL BL SHLD                 REGISTER_16+_EXPECTED$ !error
~ 32 # WORD PTR 0 [RSI] CX SHLD   REGISTER_16+_EXPECTED$ !error
~ 31 # DX WORD PTR 0 [RDI] SHLD   « 66 0F A4 17 31 »
~ 30 # AX BX SHLD                 « 66 0F A4 C3 30 »
~ 29 # EDX ECX SHLD               « 0F A4 D1 29 »
~ 28 # ESI 0 [RDI] SHLD           « 0F A4 37 28 »
~ 27 # ESI DWORD PTR 0 [RDI] SHLD « 0F A4 37 27 »
~ 26 # RSI RDI SHLD               « 48 0F A4 F7 26 »
~ 25 # RSI QWORD PTR 0 [RDI] SHLD « 48 0F A4 37 25 »
~ CL AL BL SHLD                   REGISTER_16+_EXPECTED$ !error
~ CL WORD PTR 0 [RSI] CX SHLD     REGISTER_16+_EXPECTED$ !error
~ CL DX WORD PTR 0 [RDI] SHLD     « 66 0F A5 17 »
~ CL AX BX SHLD                   « 66 0F A5 C3 »
~ CL EDX ECX SHLD                 « 0F A5 D1 »
~ CL ESI 0 [RDI] SHLD             « 0F A5 37 »
~ CL ESI DWORD PTR 0 [RDI] SHLD   « 0F A5 37 »
~ CL RSI RDI SHLD                 « 48 0F A5 F7 »
~ CL RSI QWORD PTR 0 [RDI] SHLD   « 48 0F A5 37 »
~ 4 # XMM0 XMM2 SHUFPD            « 66 0F C6 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 SHUFPD  « 66 0F C6 00 01 »
~ 4 # XMM0 XMM2 SHUFPS            « 0F C6 D0 04 »
~ 1 # OWORD PTR 0 [RAX] XMM0 SHUFPS  « 0F C6 00 01 »
~ ES: WORD PTR 20 [RSP] SIDT      « 26 66 0F 01 4C 24 20 »
~ ES: 20 [RSP] SIDT               « 26 0F 01 4C 24 20 »
~ AX SLDT                         « 0F 00 C0 »
~ WORD PTR 20 [RSP] SLDT          « 0F 00 44 24 20 »
~ AX SMSW                         « 0F 01 E0 »
~ WORD PTR 20 [RSP] SMSW          « 0F 01 64 24 20 »
~ XMM1 XMM2 SQRTPS                « 0F 51 D1 »
~ OWORD PTR 0 [RSI] XMM0 SQRTPS   « 0F 51 06 »
~ XMM1 XMM2 SQRTSD                « F2 0F 51 D1 »
~ QWORD PTR 0 [RSI] XMM0 SQRTSD   « F2 0F 51 06 »
~ XMM1 XMM2 SQRTSS                « F3 0F 51 D1 »
~ DWORD PTR 0 [RSI] XMM0 SQRTSS   « F3 0F 51 06 »
~ STC                             « F9 »
~ STD                             « FD »
~ STI                             « FB »
~ RAX STMXCSR                     ADDRESS_32_OPERAND_EXPECTED$ !error
~ DWORD PTR 0 [RSI] STMXCSR       « 0F AE 1E »
~ BYTE PTR STOS                   « AA »
~ WORD PTR STOS                   « 66 AB »
~ DWORD PTR STOS                  « AB »
~ QWORD PTR STOS                  « 48 AB »
~ AX STR                          « 0F 00 C8 »
~ WORD PTR 0 [RDI] STR            « 0F 00 0F »
~ AL AH SUB                       « 28 C4 »
~ DX 0 [RSI] SUB                  « 66 29 16 »
~ AL BPL SUB                      « 40 28 C5 »
~ QWORD PTR -123 [BP+DI] RSI SUB  « 67 48 2B B3 DD FE »
~ XMM7 XMM1 SUB                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP SUB                       « 66 29 E4 »
~ CR0 RAX SUB                     STANDARD_REGISTER_EXPECTED$ !error
~ CS DS SUB                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 SUBPD                 « 66 0F 5C D1 »
~ OWORD PTR 0 [RSI] XMM0 SUBPD    « 66 0F 5C 06 »
~ XMM1 XMM2 SUBPS                 « 0F 5C D1 »
~ OWORD PTR 0 [RSI] XMM0 SUBPS    « 0F 5C 06 »
~ XMM1 XMM2 SUBSD                 « F2 0F 5C D1 »
~ QWORD PTR 0 [RSI] XMM0 SUBSD    « F2 0F 5C 06 »
~ XMM1 XMM2 SUBSS                 « F3 0F 5C D1 »
~ DWORD PTR 0 [RSI] XMM0 SUBSS    « F3 0F 5C 06 »
~ SWAPGS                          « 0F 01 38 »
~ SYSCALL                         « 0F 05 »
~ SYSENTER                        « 0F 34 »
~ SYSEXIT                         « 0F 35 »
~ QWORD PTR SYSEXIT               « 48 0F 35 »
~ SYSRET                          « 0F 07 »
~ QWORD PTR SYSRET                « 48 0F 07 »
~ 10 # BL TEST                    « F6 C3 10 »
~ 10 # BH TEST                    « F6 C7 10 »
~ 10 # BX TEST                    « 66 F7 C3 10 00 »
~ 1000 # ES TEST                  STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX TEST                   « F7 C3 10 00 00 00 »
~ 10 # RBX TEST                   « 48 F7 C3 10 00 00 00 »
~ 100 # RBX TEST                  « 48 F7 C3 00 01 00 00 »
~ 10 # 0 [ESP] TEST               I32_NOT_SUPPORTED$ !error
~ 10 # 0 [RSP] TEST               OPERAND_SIZE_UNKNOWN$ !error
~ 10 # BYTE PTR 0 [RBX] TEST      « F6 03 10 »
~ 1000 # WORD PTR -1000 [RSP] TEST   « 66 F7 84 24 00 F0 FF FF 00 10 »
~ 10 # QWORD PTR 0 [RSI] TEST     « 48 F7 06 10 00 00 00 »
~ 10 # AL TEST                    « A8 10 »
~ 10 # AX TEST                    « 66 A9 10 00 »
~ 10 # EAX TEST                   « A9 10 00 00 00 »
~ 10 # RAX TEST                   « 48 A9 10 00 00 00 »
~ AL AH TEST                      « 84 C4 »
~ AL AX TEST                      OPERAND_SIZE_MISMATCH$ !error
~ AX SI TEST                      « 66 85 C6 »
~ AX ES TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ DS AX TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ AX ES TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ 1 # CS TEST                     STANDARD_R/M_EXPECTED$ !error
~ 10 # CR0 TEST                   STANDARD_R/M_EXPECTED$ !error
~ DR7 CR7 TEST                    STANDARD_REGISTER_EXPECTED$ !error
~ 5 # ST0 TEST                    INVALID_OPERAND_SIZE$ !error
~ EAX AL TEST                     OPERAND_SIZE_MISMATCH$ !error
~ EBX ESI TEST                    « 85 DE »
~ RBX RSI TEST                    « 48 85 DE »
~ ST(0) ST1 TEST                  INVALID_OPERAND_SIZE$ !error
~ CR0 DR7 TEST                    STANDARD_REGISTER_EXPECTED$ !error
~ AL 0 [RSI] [RCX] *1 TEST        « 84 04 0E »
~ 0 [RSI] [RBX] *1 AL TEST        INVALID_OPERAND_COMBINATION$ !error
~ RAX 0 [RBP] TEST                « 48 85 45 00 »
~ R10 0 [RBP] [RCX] *8 TEST       « 4C 85 54 CD 00 »
~ RAX 1000 [] TEST                « 48 85 04 25 00 10 00 00 »
~ RAX 0 [R13] TEST                « 49 85 45 00 »
~ R15 0 [R13] [RCX] *8 TEST       « 4D 85 7C CD 00 »
~ R15W -1 [R13] *2 TEST           BASE_EBP_REQUIRED$ !error
~ R15W -1 [RBP] [R13] *2 TEST     « 66 46 85 7C 6D FF »
~ BH SIL TEST                     HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ SPL AH TEST                     HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ AH R15L TEST                    HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ R10L CH TEST                    HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ AH 0 [RSI] [R10] TEST           HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ BH -25 [R10] TEST               HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ AL 0 [RCX] [RSP] *2 TEST        INVALID_ADDRESS_INDEX$ !error
~ AL 0 [RCX] [R12] *2 TEST        INVALID_ADDRESS_INDEX$ !error
~ BX 0 [RCX] [RSP] *2 TEST        INVALID_ADDRESS_INDEX$ !error
~ BX 0 [RCX] [R12] *2 TEST        INVALID_ADDRESS_INDEX$ !error
~ DX -3000 [RDI] [RBP] *2 TEST    « 66 85 94 6F 00 D0 FF FF »
~ RAX 28000 [RDI] *8 TEST         BASE_EBP_REQUIRED$ !error
~ RAX 28000 [RBP] [RDI] *8 TEST   « 48 85 84 FD 00 80 02 00 »
~ XMM1 XMM2 UCOMISD               « 66 0F 2E D1 »
~ QWORD PTR 0 [RSI] XMM0 UCOMISD  « 66 0F 2E 06 »
~ XMM1 XMM2 UCOMISS               « 0F 2E D1 »
~ DWORD PTR 0 [RSI] XMM0 UCOMISS  « 0F 2E 06 »
~ UD2                             « 0F 0B »
~ XMM1 XMM2 UNPACKHPD             « 66 0F 15 D1 »
~ OWORD PTR 0 [RSI] XMM0 UNPACKHPD   « 66 0F 15 06 »
~ XMM1 XMM2 UNPACKHPS             « 0F 15 D1 »
~ OWORD PTR 0 [RSI] XMM0 UNPACKHPS   « 0F 15 06 »
~ XMM1 XMM2 UNPACKLPD             « 66 0F 14 D1 »
~ OWORD PTR 0 [RSI] XMM0 UNPACKLPD   « 66 0F 14 06 »
~ XMM1 XMM2 UNPACKLPS             « 0F 14 D1 »
~ OWORD PTR 0 [RSI] XMM0 UNPACKLPS   « 0F 14 06 »
~ AX VERR                         « 0F 00 E0 »
~ WORD PTR 20 [RBX] VERR          « 0F 00 63 20 »
~ AX VERW                         « 0F 00 E8 »
~ WORD PTR 20 [RBX] VERW          « 0F 00 6B 20 »
~ WBINVD                          « 0F 09 »
~ WRMSR                           « 0F 30 »
~ BL CL XADD                      « 0F C0 D9 »
~ AL 0 [RSI] XADD                 « 0F C0 06 »
~ 0 [RSI] AL XADD                 STANDARD_REGISTER_EXPECTED$ !error
~ BX CX XADD                      « 66 0F C1 D9 »
~ AX 0 [RSI] XADD                 « 66 0F C1 06 »
~ EBX ECX XADD                    « 0F C1 D9 »
~ EAX 0 [RSI] XADD                « 0F C1 06 »
~ RBX R13 XADD                    « 49 0F C1 DD »
~ RAX 0 [RSI] XADD                « 48 0F C1 06 »
~ ST(0) RAX XADD                  OPERAND_SIZE_MISMATCH$ !error
~ EBX CR0 XADD                    STANDARD_REGISTER_EXPECTED$ !error
~ AL BL XCHG                      « 86 C3 »
~ BL AL XCHG                      « 86 C3 »
~ AX BX XCHG                      « 66 93 »
~ BX AX XCHG                      « 66 93 »
~ EAX EBX XCHG                    « 93 »
~ RAX RBX XCHG                    « 48 93 »
~ AL 0 [RSI] XCHG                 « 86 06 »
~ AX 0 [RSI] XCHG                 « 66 87 06 »
~ EAX 0 [RSI] XCHG                « 87 06 »
~ RAX 0 [RSI] XCHG                « 48 87 06 »
~ 0 [RSI] BL XCHG                 « 86 1E »
~ 0 [RSI] CX XCHG                 « 66 87 0E »
~ 0 [RBP] ESP XCHG                « 87 65 00 »
~ 0 [RSI] R13 XCHG                « 4C 87 2E »
~ XGETBV                          « 0F 01 D0 »
~ XLAT                            « D7 »
~ QWORD PTR XLAT                  « 48 D7 »
~ WORD PTR XLAT                   « 66 D7 »
~ AL AH XOR                       « 30 C4 »
~ DX 0 [RSI] XOR                  « 66 31 16 »
~ AL BPL XOR                      « 40 30 C5 »
~ QWORD PTR -123 [BP+DI] RSI XOR  « 67 48 33 B3 DD FE »
~ XMM7 XMM1 XOR                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP XOR                       « 66 31 E4 »
~ CR0 RAX XOR                     STANDARD_REGISTER_EXPECTED$ !error
~ CS DS XOR                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 XORPD                 « 66 0F 57 C0 »
~ OWORD PTR 0 [R10] XMM7 XORPS    « 41 0F 57 3A »
~ 0 [RSI] XRSTOR                  « 0F AE 2E »
~ 0 [RSI] XRSTOR64                « 48 0F AE 2E »
~ 0 [RDI] XSAVE                   « 0F AE 27 »
~ 0 [RDI] XSAVE64                 « 48 0F AE 27 »
~ XSETBV                          « 0F 01 D1 »
~  NOP BEGIN  RAX RAX ADD  END  NOP   « 90 48 01 C0 90 »
~  NOP BEGIN  RAX RAX SUB  AGAIN  NOP    « 90 48 29 C0 EB FB 90 »
~  NOP  BEGIN   RAX RAX XOR   U<  UNTIL   NOP     « 90 48 31 C0 73 FB 90 »
~ NOP BEGIN  RAX NOT  simblock+ U< UNTIL  NOP
  « 90 48 F7 D0 0F 83 F7 FF FF FF 90 »
~~ NOP > IF  RAX RAX AND  THEN  NOP
  « 90 0F 8E 03 00 00 00 48 21 C0 90 »
~~ NOP < UNLESS  RAX RAX OR  ELSE  RAX RAX AND  THEN  NOP
  « 90 0F 8C 08 00 00 00 48 09 C0 E9 03 00 00 00 48 21 C0 90 »
~~ NOP > IFEVER  RAX RAX AND  THEN  NOP
  « 90 2E 0F 8E 03 00 00 00 48 21 C0 90 »
~~ NOP < UNLESSEVER  RAX RAX OR  ELSE  RAX RAX AND  THEN  NOP
  « 90 2E 0F 8C 08 00 00 00 48 09 C0 E9 03 00 00 00 48 21 C0 90 »
~~ NOP BEGIN  RAX RAX TEST  0> WHILE  RAX DEC  REPEAT  NOP
  « 90 48 85 C0 0F 8E 05 00 00 00 48 FF C8 EB F2 90 »
~~ NOP  FOR  RAX RAX TEST  NEXT  NOP   « 90 48 85 C0 E2 FB 90 »
~ NOP  FOR  RAX RAX TEST  simblock+ NEXT  NOP
  « 90 48 85 C0 48 FF C9 75 F8 90 »
~~ CELL [RBP] RBP LEA  QWORD PTR -8 [RBP] POP              « 48 8D 6D 08 8F 45 F8 »
~ QWORD PTR -8 [RBP] PUSH  -8 [RBP] RBP LEA  RET       « FF 75 F8 48 8D 6D F8 C3 »
/*
~ NOP BEGIN  RAX RAX ADD  BREAK  RBX RBX SBB  END  NOP
  « 90 EB 05 E9 08 00 00 00 48 01 C0 EB F6 48 19 DB 90 »
~ NOP BEGIN  RAX RAX ADD  CONTINUE  RBX RBX SBB  END  NOP
  « 90 EB 05 E9 08 00 00 00 48 01 C0 EB FB 48 19 DB 90 »
~ NOP BEGIN  RAX RAX ADD  CY ?BREAK  RBX RBX ADC  END  NOP
  « 90 EB 05 E9 09 00 00 00 48 01 C0 2E 72 F5 48 11 DB 90 »
~ NOP BEGIN  RAX RAX ADD  CY ?CONTINUE  RBX RBX ADC  END  NOP
  « 90 EB 05 E9 09 00 00 00 48 01 C0 2E 72 FA 48 11 DB 90 »
~ NOP BEGIN  RAX RAX ADD  simblock+ CY ?BREAK  RBX RBX ADC  END  NOP
  « 90 EB 05 E9 0E 00 00 00 48 01 C0 3E 73 05 E9 F0 FF FF FF 48 11 DB 90 »
~ NOP BEGIN  RAX RAX ADD  simblock+ CY ?CONTINUE  RBX RBX ADC  END  NOP
  « 90 EB 05 E9 0E 00 00 00 48 01 C0 3E 73 05 E9 F5 FF FF FF 48 11 DB 90 »
*/

  cr ERRORS @ 1 "Test suite completed with %d error(s)."|.
  depth if cr .s then  bye ;; >main

vocabulary;
