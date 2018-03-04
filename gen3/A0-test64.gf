64 dup dup constant _ADDRSIZE constant _OPSIZE constant _ARCH
-1 constant _MMX  -1 constant _XMM  -1 constant _X87

require forceemu.4th
require A0-IA64.gf
also ForcemblerTools
also Forcembler

( Test operands )

test-mode  cr

$089A0B0C  12 11 10 9 8 !op

RAX                     00 #REGULAR #QWORD i64 #REGISTER !op    ¶
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

0 [EAX]                 I32_NOT_SUPPORTED$ !error                                        ¶
0 [RAX]                 00 #LINEAR 0 i64 #ADDRESS !op              0 0 !disp             ¶
-1 [BP+SI]              02 #INDEXED 0 i16 #ADDRESS !op             -1 #BYTE !disp        ¶
100 []                  $45 #INDEXED %MOD00 + 0 i64 #ADDRESS !op   100 #DWORD !disp      ¶
0 [RBX] [ESI]           ARCHITECTURE_MISMATCH$ !error                                    ¶
0 [RBX] [RSI]           $63 #INDEXED 0 i64 #ADDRESS !op            0 0 !disp             ¶
\ 2000 [RBX] [RSI] *2     $43 #SCALED2 0 i64 #ADDRESS !op          2000 #WORD !disp      ¶

( Test Operations )

hex

~ AAA                             LEGACY_OPCODE$ !error
~ AAD                             LEGACY_OPCODE$ !error
~ 10 # AAD                        LEGACY_OPCODE$ !error
~ AAM                             LEGACY_OPCODE$ !error
~ 10 # AAM                        LEGACY_OPCODE$ !error
~ AAS                             LEGACY_OPCODE$ !error
( testing logarop operand combinations by means of ADC: )
~ 10 # BL ADC                     80 D3 10 chk
~ 10 # BH ADC                     80 D7 10 chk
~ 10 # BX ADC                     66 83 D3 10 chk
~ 1000 # ES ADC                   STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX ADC                    83 D3 10 chk
~ 10 # RBX ADC                    48 83 D3 10 chk
~ 100 # RBX ADC                   48 81 D3 00 01 00 00 chk
~ 10 # 0 [ESP] ADC                I32_NOT_SUPPORTED$ !error
~ 10 # 0 [RSP] ADC                OPERAND_SIZE_UNKNOWN$ !error
~ 10 # BYTE PTR 0 [RBX] ADC       80 13 10 chk
~ 1000 # WORD PTR -1000 [RSP] ADC 66 81 94 24 00 F0 FF FF 00 10 chk
~ 10 # QWORD PTR 0 [RSI] ADC      48 83 16 10 chk
~ 10 # AL ADC                     14 10 chk
~ 10 # AX ADC                     66 15 10 00 chk
~ 10 # EAX ADC                    15 10 00 00 00 chk
~ 10 # RAX ADC                    48 15 10 00 00 00 chk
~ AL AH ADC                       10 C4 chk
~ AL AX ADC                       OPERAND_SIZE_MISMATCH$ !error
~ AX SI ADC                       66 11 C6 chk
~ AX ES ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ DS AX ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ AX ES ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ 1 # CS ADC                      STANDARD_R/M_EXPECTED$ !error
~ 10 # CR0 ADC                    STANDARD_R/M_EXPECTED$ !error
~ DR7 CR7 ADC                     STANDARD_REGISTER_EXPECTED$ !error
~ 5 # ST0 ADC                     STANDARD_R/M_EXPECTED$ !error
~ EAX AL ADC                      OPERAND_SIZE_MISMATCH$ !error
~ EBX ESI ADC                     11 DE chk
~ RBX RSI ADC                     48 11 DE chk
~ ST(0) ST1 ADC                   STANDARD_REGISTER_EXPECTED$ !error
~ CR0 DR7 ADC                     STANDARD_REGISTER_EXPECTED$ !error
~ AL 0 [RSI] [RCX] *1 ADC         10 04 0E chk
~ 0 [RSI] [RBX] *1 AL ADC         12 04 1E chk
~ BX -1 [RBP] *2 ADC              BASE_EBP_REQUIRED$ !error
~ BX -1 [RSI] *2 ADC              BASE_EBP_REQUIRED$ !error
~ BX -1 [RBP] [RSI] *2 ADC        66 11 5C 75 FF chk
~ BX 0 [RAX] [RBX] *2 ADC         66 11 1C 58 chk
~ 0 [RBP] RAX ADC                 48 13 45 00 chk
~ 0 [RBP] [RCX] *8 R10 ADC        4C 13 54 CD 00 chk
~ 1000 [] RAX ADC                 48 13 04 25 00 10 00 00 chk
~ RAX 0 [R13] ADC                 49 11 45 00 chk
~ R15 0 [R13] [RCX] *8 ADC        4D 11 7C CD 00 chk
~ R15W -1 [R13] *8 ADC            BASE_EBP_REQUIRED$ !error
~ R15W -1 [R13] [R13] *8 ADC      66 47 11 7C ED FF chk
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
~ DX -3000 [RDI] [RBP] *2 ADC     66 11 94 6F 00 D0 FF FF chk
~ 28000 [RBP] [RDI] *8 RAX ADC    48 13 84 FD 00 80 02 00 chk
~ RAX RSP ADD                     48 01 C4 chk
~ -8 [RSP] EAX ADD                03 44 24 F8 chk
~ 0 [BX] SI ADD                   66 67 03 37 chk
~ 0 [BP] SI ADD                   66 67 03 76 00 chk
~ -1 [BP] RSI ADD                 67 48 03 76 FF chk
~ 1000 [BX+SI] AL ADD             67 02 80 00 10 chk
~ 100000 [BX+SI] AL ADD           IMMEDIATE_TOO_BIG$ !error
~ CL 1000 [BX+SI] ADD             67 00 88 00 10 chk
~ DX 0 [BX+DI] ADD                66 67 01 11 chk
~ RAX RBX ADDPD                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDPD                  XMM_REGMEM128_EXPECTED$ !error
~ XMM1 XMM2 ADDPD                 66 0F 58 D1 chk
~ OWORD PTR 0 [RSI] XMM0 ADDPD    66 0F 58 06 chk
~ XMM7 OWORD PTR 0 [RSI] ADDPD    XMM_REGISTER_EXPECTED$ !error
~ RAX RBX ADDPS                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDPS                  XMM_REGMEM128_EXPECTED$ !error
~ XMM1 XMM2 ADDPS                 0F 58 D1 chk
~ OWORD PTR 0 [RSI] XMM0 ADDPS    0F 58 06 chk
~ XMM7 OWORD PTR 0 [RSI] ADDPS    XMM_REGISTER_EXPECTED$ !error
~ RAX RBX ADDSD                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDSD                  XMM_REGMEM64_EXPECTED$ !error
~ XMM1 XMM2 ADDSD                 F2 0F 58 D1 chk
~ QWORD PTR 0 [RSI] XMM0 ADDSD    F2 0F 58 06 chk
~ XMM7 QWORD PTR 0 [RSI] ADDSD    XMM_REGISTER_EXPECTED$ !error
~ RAX RBX ADDSS                   XMM_REGISTER_EXPECTED$ !error
~ RAX XMM2 ADDSS                  XMM_REGMEM32_EXPECTED$ !error
~ XMM1 XMM2 ADDSS                 F3 0F 58 D1 chk
~ DWORD PTR 0 [RSI] XMM0 ADDSS    F3 0F 58 06 chk
~ XMM7 QWORD PTR 0 [RSI] ADDSS    XMM_REGISTER_EXPECTED$ !error
~ XMM3 XMM4 ADDSUBPD              66 0F D0 E3 chk
~ OWORD PTR 0 [RSI] XMM0 ADDSUBPD 66 0F D0 06 chk
~ XMM3 XMM4 ADDSUBPS              F2 0F D0 E3 chk
~ OWORD PTR 0 [RSI] XMM0 ADDSUBPS F2 0F D0 06 chk
~ XMM1 XMM0 AESDEC                66 0F 38 DE C1 chk
~ OWORD PTR -1234 [] XMM7 AESDEC  66 0F 38 DE 3C 25 CC ED FF FF chk
~ XMM4 RAX AESDECLAST             XMM_REGISTER_EXPECTED$ !error
~ XMM2 XMM3 AESDECLAST            66 0F 38 DF DA chk
~ XMM1 XMM0 AESENC                66 0F 38 DC C1 chk
~ XMM7 OWORD PTR -1234 [] AESENC  XMM_REGISTER_EXPECTED$ !error
~ XMM4 CS AESENCLAST              XMM_REGISTER_EXPECTED$ !error
~ XMM2 XMM3 AESENCLAST            66 0F 38 DD DA chk
~ XMM1 XMM2 AESIMC                66 0F 38 DB D1 chk
~ 3 # XMM1 XMM6 AESKEYGENASSIST   66 0F 3A DF F1 03 chk
~ -1 # OWORD PTR 0 [EAX] [EBX] *4 XMM0 AESKEYGENASSIST  I32_NOT_SUPPORTED$ !error
~ -1 # OWORD PTR 0 [RAX] [RBX] *4 XMM0 AESKEYGENASSIST  66 0F 3A DF 04 98 FF chk
~ AL AH AND                       20 C4 chk
~ DX 0 [RSI] AND                  66 21 16 chk
~ AL BPL AND                      40 20 C5 chk
~ QWORD PTR -123 [BP+DI] RSI AND  67 48 23 B3 DD FE chk
~ XMM7 XMM1 AND                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP AND                       66 21 E4 chk
~ CR0 RAX AND                     OPERAND_SIZE_MISMATCH$ !error
~ CS DS AND                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 ANDPD                 66 0F 54 C0 chk
~ OWORD PTR 0 [R10] XMM7 ANDPS    41 0F 54 3A chk
~ OWORD PTR -1 [] XMM0 ANDNPD     66 0F 55 04 25 FF FF FF FF chk
~ XMM7 XMM6 ANDNPS                0F 55 F7 chk
~ AX BX ARPL                      LEGACY_OPCODE$ !error
~ 1000 # XMM0 XMM1 BLENDPD        IMMEDIATE8_OPERAND_EXPECTED$ !error
~ -1 # XMM0 XMM1 BLENDPD          66 0F 3A 0D C8 FF chk
~ 2 # OWORD PTR 0 [RAX] XMM1 BLENDPS
                                  66 0F 3A 0C 08 02 chk
~ EAX XMM1 EAX BLENDPS            XMM_REGISTER_EXPECTED$ !error
~ EAX XMM1 XMM0 BLENDPS           IMMEDIATE8_OPERAND_EXPECTED$ !error
~ XMM7 XMM5 BLENDVPD              66 0F 38 15 EF chk
~ XMM1 XMM3 BLENDVPS              66 0F 38 14 D9 chk
~ 0 [RSI] RAX BOUND               LEGACY_OPCODE$ !error
~ QWORD PTR -25 [RSI] [RBP] *4 RSI BSF      48 0F BC 74 AE DB chk
~ DWORD PTR -25 [RSI] [RBP] *4 ESI BSF      0F BC 74 AE DB chk
~ ESI -25 [RSI] [RBP] *4 BSF      STANDARD_REGISTER_EXPECTED$ !error
~ RSI RDI BSF                     48 0F BC FE chk
~ TBYTE PTR 0 [] ST(2) BSF        STANDARD_REGISTER_EXPECTED$ !error
~ QWORD PTR -25 [RSP] [RBP] *4 RSI BSR      48 0F BD 74 AC DB chk
~ RAX RCX BSR                     48 0F BD C8 chk
~ RDX BSWAP                       48 0F CA chk
~ QWORD PTR 0 [RSI] BSWAP         REGISTER_OPERAND_EXPECTED$ !error
~ RCX QWORD PTR 99 [RSI] BT       48 0F A3 8E 99 00 00 00 chk
~ RSI RDI BTS                     48 0F AB F7 chk
~ RDI 0 [RAX] BTS                 48 0F AB 38 chk
~ 78 # 0 [RDX] BTR                OPERAND_SIZE_UNKNOWN$ !error
~ 78 # WORD PTR 0 [RDX] BTR       66 0F BA 32 78 chk
~ 0 # QWORD PTR 0 [RAX] BT        48 0F BA 20 00 chk
~ -12 # ESI BTC                   0F BA FE EE chk
~ RCX DWORD PTR 99 [RSI] BT       OPERAND_SIZE_MISMATCH$ !error
~ there 10 + # CALL               E8 0B 00 00 00 chk
~ 0 [RBX] [RBX] *8 CALL           FF 14 DB chk
~ 0 [] CALL                       FF 14 25 00 00 00 00 chk
~ RBX CALL                        48 FF D3 chk
~ CBW                             66 98 chk
~ CWDE                            98 chk
~ CDQE                            48 98 chk
~ CLC                             F8 chk
~ CLD                             FC chk
~ 0 [RSI] *4 CLFLUSH              0F AE 3C B5 00 00 00 00 chk
~ RAX CLFLUSH                     ADDRESS_OPERAND_EXPECTED$ !error
~ CLI                             FA chk
~ CLTS                            0F 06 chk
~ CMC                             F5 chk
~ RBX RAX 0= ?MOV                 48 0F 44 C3 chk
~ 0 [RBX] EAX U< ?MOV             0F 42 03 chk
~ 0 [RIP] AL 0> ?MOV              0F 4F 05 00 00 00 00 chk
~ AX 0 [RSI] P= ?MOV              OPERAND_SIZE_UNKNOWN$ !error
~ AX WORD PTR 0 [RSI] P= ?MOV     STANDARD_REGISTER_EXPECTED$ !error
~ 1000 # RAX CMP                  48 3D 00 10 00 00 chk
~ 10 # WORD PTR -1 [RSI] CMP      66 83 7E FF 10 chk
~ RAX RCX CMP                     48 39 C1 chk
~ SIL 90 [RCX] CMP                40 38 B1 90 00 00 00 chk
~ 90 [RCX] DIL CMP                40 3A B9 90 00 00 00 chk
~ XMM1 XMM2 CMPPD                 66 0F C2 D1 chk
~ OWORD PTR 0 [RSI] XMM0 CMPPD    66 0F C2 06 chk
~ XMM1 XMM2 CMPPS                 0F C2 D1 chk
~ OWORD PTR 0 [RSI] XMM0 CMPPS    0F C2 06 chk
~ XMM1 XMM2 CMPSD                 F2 0F C2 D1 chk
~ QWORD PTR 0 [RSI] XMM0 CMPSD    F2 0F C2 06 chk
~ XMM1 XMM2 CMPSS                 F3 0F C2 D1 chk
~ DWORD PTR 0 [RSI] XMM0 CMPSS    F3 0F C2 06 chk
~ BYTE PTR CMPS                   A6 chk
~ WORD PTR CMPS                   66 A7 chk
~ DWORD PTR CMPS                  A7 chk
~ QWORD PTR CMPS                  48 A7 chk
~ AL DIL CMPXCHG                  40 0F B0 C7 chk
~ DX 0 [RSI] [R15] *2 CMPXCHG     66 42 0F B1 14 7E chk
~ 0 [RSI] [R15] *2 AX CMPXCHG     STANDARD_REGISTER_EXPECTED$ !error
~ EBX EDI CMPXCHG                 0F B1 DF chk
~ CR0 DR7 CMPXCHG                 STANDARD_REGISTER_EXPECTED$ !error
~ RBX 4 [RBX] CMPXCHG             48 0F B1 5B 04 chk
~ QWORD PTR 0 [] CMPXCHG8B        0F C7 0C 25 00 00 00 00 chk
~ XMM1 XMM2 COMISD                66 0F 2F D1 chk
~ QWORD PTR 0 [RSI] XMM0 COMISD   66 0F 2F 06 chk
~ XMM1 XMM2 COMISS                0F 2F D1 chk
~ DWORD PTR 0 [RSI] XMM0 COMISS   0F 2F 06 chk
~ CPUID                           0F A2 chk
~ BYTE PTR 5 [RBX] AL CRC32       REGISTER_32+_EXPECTED$ !error
~ BYTE PTR 5 [RBX] AX CRC32       REGISTER_32+_EXPECTED$ !error
~ BYTE PTR 5 [RBX] EAX CRC32      F2 0F 38 F0 43 05 chk
~ BYTE PTR 5 [RBX] RAX CRC32      F2 48 0F 38 F0 43 05 chk
~ BL CL CRC32                     REGISTER_32+_EXPECTED$ !error
~ BL CX CRC32                     REGISTER_32+_EXPECTED$ !error
~ BL ECX CRC32                    F2 0F 38 F0 CB chk
~ BL RCX CRC32                    F2 48 0F 38 F0 CB chk
~ WORD PTR 5 [RBX] EAX CRC32      66 F2 0F 38 F1 43 05 chk
~ WORD PTR 5 [RBX] RAX CRC32      66 F2 48 0F 38 F1 43 05 chk
~ BX ECX CRC32                    66 F2 0F 38 F1 CB chk
~ BX RCX CRC32                    66 F2 48 0F 38 F1 CB chk
~ DWORD PTR 5 [RBX] EAX CRC32     F2 0F 38 F1 43 05 chk
~ DWORD PTR 5 [RBX] RAX CRC32     F2 48 0F 38 F1 43 05 chk
~ EBX ECX CRC32                   F2 0F 38 F1 CB chk
~ EBX RCX CRC32                   F2 48 0F 38 F1 CB chk
~ QWORD PTR 5 [RBX] EAX CRC32     INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 5 [RBX] RAX CRC32     F2 48 0F 38 F1 43 05 chk
~ RBX ECX CRC32                   INVALID_OPERAND_COMBINATION$ !error
~ RBX RCX CRC32                   F2 48 0F 38 F1 CB chk
~ XMM7 XMM0 CVTDQ2PD              F3 0F E6 C7 chk
~ XMM7 EAX CVTDQ2PD               XMM_REGISTER_EXPECTED$ !error
~ XMM7 RAX CVTDQ2PD               XMM_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTDQ2PD XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTDQ2PD F3 0F E6 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTDQ2PD XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTDQ2PS              0F 5B C7 chk
~ QWORD PTR 0 [RSI] XMM0 CVTDQ2PS XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTDQ2PS 0F 5B 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTDQ2PS XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPD2DQ              F2 0F E6 C7 chk
~ QWORD PTR 0 [RSI] XMM0 CVTPD2DQ XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPD2DQ F2 0F E6 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPD2DQ XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPD2PI              66 0F 2D C7 chk
~ QWORD PTR 0 [RSI] XMM0 CVTPD2PI XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPD2PI 66 0F 2D 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPD2PI XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPD2PS              66 0F 5A C7 chk
~ QWORD PTR 0 [RSI] XMM0 CVTPD2PS XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPD2PS 66 0F 5A 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPD2PS XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPI2PD              66 0F 2A C7 chk
~ OWORD PTR 0 [RSI] XMM0 CVTPI2PD XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTPI2PD 66 0F 2A 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPI2PD XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPS2DQ              66 0F 5B C7 chk
~ QWORD PTR 0 [RSI] XMM0 CVTPS2DQ XMM_REGMEM128_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 CVTPS2DQ 66 0F 5B 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPS2DQ XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPS2PD              0F 5A C7 chk
~ OWORD PTR 0 [RSI] XMM0 CVTPS2PD XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTPS2PD 0F 5A 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPS2PD XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTPS2PI              0F 2D C7 chk
~ OWORD PTR 0 [RSI] XMM0 CVTPS2PI XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTPS2PI 0F 2D 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTPS2PI XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTSD2SI              REGISTER_32+_EXPECTED$ !error
~ XMM7 EAX CVTSD2SI               F2 0F 2D C7 chk
~ XMM7 RAX CVTSD2SI               F2 48 0F 2D C7 chk
~ OWORD PTR 0 [RSI] XMM0 CVTSD2SI REGISTER_32+_EXPECTED$ !error
~ QWORD PTR 0 [RSI] EAX CVTSD2SI  F2 0F 2D 06 chk
~ QWORD PTR 0 [RSI] RAX CVTSD2SI  F2 48 0F 2D 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTSD2SI REGISTER_32+_EXPECTED$ !error
~ XMM7 XMM0 CVTSD2SS              F2 0F 5A C7 chk
~ OWORD PTR 0 [RSI] XMM0 CVTSD2SS XMM_REGMEM64_EXPECTED$ !error
~ QWORD PTR 0 [RSI] XMM0 CVTSD2SS F2 0F 5A 06 chk
~ XMM0 OWORD PTR 0 [RSI] CVTSD2SS XMM_REGISTER_EXPECTED$ !error
~ XMM7 XMM0 CVTSI2SD              R/M_32+_EXPECTED$ !error
~ ESI XMM0 CVTSI2SD               F2 0F 2A C6 chk
~ RSI XMM0 CVTSI2SD               F2 48 0F 2A C6 chk
~ DWORD PTR 0 [RSI] XMM0 CVTSI2SD F2 0F 2A 06 chk
~ QWORD PTR 0 [RSI] XMM0 CVTSI2SD F2 48 0F 2A 06 chk
~ OWORD PTR 0 [RSI] XMM0 CVTSI2SD R/M_32+_EXPECTED$ !error
~ XMM0 OWORD PTR 0 [RSI] CVTSI2SD XMM_REGISTER_EXPECTED$ !error
~ CWD                             66 99 chk
~ CDQ                             99 chk
~ CQO                             48 99 chk
~ DAA                             LEGACY_OPCODE$ !error
~ DAS                             LEGACY_OPCODE$ !error
~ 1 # DEC                         INVALID_OPERAND_TYPE$ !error
~ AL DEC                          FE C8 chk
~ BX DEC                          66 FF CB chk
~ ECX DEC                         FF C9 chk
~ RDX DEC                         48 FF CA chk
~ BYTE PTR 0 [RAX] DEC            FE 08 chk
~ WORD PTR 0 [RBX] DEC            66 FF 0B chk
~ DWORD PTR 0 [RCX] DEC           FF 09 chk
~ QWORD PTR 0 [RDX] DEC           48 FF 0A chk
~ OWORD PTR 0 [RSI] DEC           INVALID_OPERAND_SIZE$ !error
~ 1 # DIV                         INVALID_OPERAND_TYPE$ !error
~ AL DIV                          F6 F0 chk
~ BX DIV                          66 F7 F3 chk
~ ECX DIV                         F7 F1 chk
~ RDX DIV                         48 F7 F2 chk
~ BYTE PTR 0 [RAX] DIV            F6 30 chk
~ WORD PTR 0 [RBX] DIV            66 F7 33 chk
~ DWORD PTR 0 [RCX] DIV           F7 31 chk
~ QWORD PTR 0 [RDX] DIV           48 F7 32 chk
~ OWORD PTR 0 [RSI] DIV           INVALID_OPERAND_SIZE$ !error
~ XMM1 XMM2 DIVPD                 66 0F 5E D1 chk
~ OWORD PTR 0 [RSI] XMM0 DIVPD    66 0F 5E 06 chk
~ XMM1 XMM2 DIVPS                 0F 5E D1 chk
~ OWORD PTR 0 [RSI] XMM0 DIVPS    0F 5E 06 chk
~ XMM1 XMM2 DIVSD                 F2 0F 5E D1 chk
~ QWORD PTR 0 [RSI] XMM0 DIVSD    F2 0F 5E 06 chk
~ XMM1 XMM2 DIVSS                 F3 0F 5E D1 chk
~ DWORD PTR 0 [RSI] XMM0 DIVSS    F3 0F 5E 06 chk
~ 10 # XMM1 XMM2 DPPD             66 0F 3A 41 D1 10 chk
~ -10 # OWORD PTR 0 [RSI] XMM0 DPPD  66 0F 3A 41 06 F0 chk
~ 10 # XMM1 XMM2 DPPS             66 0F 3A 40 D1 10 chk
~ -10 # OWORD PTR 0 [RSI] XMM0 DPPS  66 0F 3A 40 06 F0 chk
~ EMMS                            0F 77 chk
~ 10 2000 # ENTER                 C8 00 20 10 chk
~ 100 # ENTER                     MISSING_NESTING_LEVEL$ !error
~ 200 2000 # ENTER                NESTLEVEL_OPERAND_EXPECTED$ !error
~ 10 12345 # ENTER                IMMEDIATE16_OPERAND_EXPECTED$ !error
~ 0 1234 # ENTER                  C8 34 12 00 chk
~ 5 # XMM3 EAX EXTRACTPS          66 0F 3A 17 D8 05 chk
~ 1 # XMM4 DWORD PTR 0 [RSI] EXTRACTPS  66 0F 3A 17 26 01 chk
~ F2^X-1                          D9 F0 chk
~ FABS                            D9 E1 chk
~ ST2 FADD                        DC C2 chk
~ RAX FADD                        INVALID_OPERAND_TYPE$ !error
~ 25 # FADD                       INVALID_OPERAND_TYPE$ !error
~ 0 [RSI] FADD                    OPERAND_SIZE_UNKNOWN$ !error
~ WORD PTR 0 [RSI] FADD           INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FADD          D8 06 chk
~ QWORD PTR 0 [RSI] FADD          DC 06 chk
~ OWORD PTR 0 [RSI] FADD          INVALID_OPERAND_TYPE$ !error
~ 0 [RSI] RFADD                   FPU_REGISTER_EXPECTED$ !error
~ ST2 RFADD                       D8 C2 chk
~ RAX RFADD                       FPU_REGISTER_EXPECTED$ !error
~ 25 # RFADD                      FPU_REGISTER_EXPECTED$ !error
~ WORD PTR 0 [RSI] RFADD          FPU_REGISTER_EXPECTED$ !error
~ DWORD PTR 0 [RSI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [RSI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ FADDP                           DE C1 chk
~ ST(1) FADDP                     DE C1 chk
~ QWORD PTR 0 [RSI] FADDP         FPU_REGISTER_EXPECTED$ !error
~ RAX FADDP                       FPU_REGISTER_EXPECTED$ !error
~ 23 # FADDP                      FPU_REGISTER_EXPECTED$ !error
~ ST2 FIADD                       INVALID_OPERAND_TYPE$ !error
~ RAX FIADD                       INVALID_OPERAND_TYPE$ !error
~ 25 # FIADD                      INVALID_OPERAND_TYPE$ !error
~ 0 [RSI] FIADD                   OPERAND_SIZE_UNKNOWN$ !error
~ WORD PTR 0 [RSI] FIADD          DA 06 chk
~ DWORD PTR 0 [RSI] FIADD         DE 06 chk
~ QWORD PTR 0 [RSI] FIADD         INVALID_OPERAND_TYPE$ !error
~ OWORD PTR 0 [RSI] FIADD         INVALID_OPERAND_TYPE$ !error
~ 0 [RBX] FBLD                    OPERAND_SIZE_UNKNOWN$ !error
~ TBYTE PTR 0 [RBX] FBLD          DF 23 chk
~ QWORD PTR 0 [RBX] FBLD          ADDRESS_80_OPERAND_EXPECTED$ !error
~ ST(0) FBLD                      ADDRESS_80_OPERAND_EXPECTED$ !error
~ TBYTE PTR 0 [RSI] FBSTP         DF 36 chk
~ FCHS                            D9 E0 chk
~ FWAIT                           9B chk
~ FCLEX                           9B DB E2 chk
~ FNCLEX                          DB E2 chk
~ ST1 U< ?FMOV                    DA C1 chk
~ 0 [RSI] U< ?FMOV                FPU_REGISTER_EXPECTED$ !error
~ ST(2) = ?FMOV                   DA CA chk
~ RAX = ?FMOV                     FPU_REGISTER_EXPECTED$ !error
~ ST3 U≤ ?FMOV                    DA D3 chk
~ ST4 X< ?FMOV                    DA DC chk
~ ST5 U≥ ?FMOV                    DB C5 chk
~ ST6 ≠ ?FMOV                     DB CE chk
~ ST7 U> ?FMOV                    DB D7 chk
~ ST0 X> ?FMOV                    DB D8 chk
~ ST1 FCOMI                       DB F1 chk
~ ST2 FCOMIP                      DF F2 chk
~ ST(3) FUCOMI                    DB EB chk
~ ST(4) FUCOMIP                   DF EC chk
~ 0 [RDI] FUCOMI                  FPU_REGISTER_EXPECTED$ !error
~ FCOS                            D9 FF chk
~ FDECSTP                         D9 F6 chk
~ ST2 FDIV                        DC F2 chk
~ DWORD PTR 0 [RSI] FDIV          D8 36 chk
~ QWORD PTR 0 [RSI] FDIV          DC 36 chk
~ ST2 RFDIV                       D8 F2 chk
~ FDIVP                           DE F1 chk
~ ST(1) FDIVP                     DE F1 chk
~ WORD PTR 0 [RSI] FIDIV          DA 36 chk
~ DWORD PTR 0 [RSI] FIDIV         DE 36 chk
~ ST2 FDIVR                       DC FA chk
~ DWORD PTR 0 [RSI] FDIVR         D8 3E chk
~ QWORD PTR 0 [RSI] FDIVR         DC 3E chk
~ ST2 RFDIVR                      D8 FA chk
~ FDIVRP                          DE F9 chk
~ ST(1) FDIVRP                    DE F9 chk
~ WORD PTR 0 [RSI] FIDIVR         DA 3E chk
~ DWORD PTR 0 [RSI] FIDIVR        DE 3E chk
~ BYTE PTR 0 [RSI] FICOM          INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FICOM          DE 16 chk
~ DWORD PTR 0 [RSI] FICOM         DA 16 chk
~ QWORD PTR 0 [RSI] FICOM         INVALID_OPERAND_TYPE$ !error
~ ST(0) FICOM                     INVALID_OPERAND_TYPE$ !error
~ RAX FICOM                       INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FILD           INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FILD           DF 06 chk
~ DWORD PTR 0 [RSI] FILD          DB 06 chk
~ QWORD PTR 0 [RSI] FILD          DF 2E chk
~ ST(0) FILD                      INVALID_OPERAND_TYPE$ !error
~ RAX FILD                        INVALID_OPERAND_TYPE$ !error
~ FINCSTP                         D9 F7 chk
~ FINIT                           9B DB E3 chk
~ FNINIT                          DB E3 chk
~ BYTE PTR 0 [RSI] FIST           INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FIST           DF 16 chk
~ DWORD PTR 0 [RSI] FIST          DB 16 chk
~ QWORD PTR 0 [RSI] FIST          INVALID_OPERAND_TYPE$ !error
~ ST(0) FIST                      INVALID_OPERAND_TYPE$ !error
~ RAX FIST                        INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FISTP          INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FISTP          DF 1E chk
~ DWORD PTR 0 [RSI] FISTP         DB 1E chk
~ QWORD PTR 0 [RSI] FISTP         DF 3E chk
~ ST(0) FISTP                     INVALID_OPERAND_TYPE$ !error
~ RAX FISTP                       INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FISTTP         INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FISTTP         DF 0E chk
~ DWORD PTR 0 [RSI] FISTTP        DB 0E chk
~ QWORD PTR 0 [RSI] FISTTP        DD 0E chk
~ ST(0) FISTTP                    INVALID_OPERAND_TYPE$ !error
~ RAX FISTTP                      INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [RSI] FLD            INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FLD            INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FLD           D9 06 chk
~ QWORD PTR 0 [RSI] FLD           DD 06 chk
~ TBYTE PTR 0 [RSI] FLD           DB 2E chk
~ OWORD PTR 0 [RSI] FLD           INVALID_OPERAND_TYPE$ !error
~ ST(3) FLD                       D9 C3 chk
~ RAX FLD                         INVALID_OPERAND_TYPE$ !error
~ FLD1                            D9 E8 chk
~ FLDL2T                          D9 E9 chk
~ FLDL2E                          D9 EA chk
~ FLDPI                           D9 EB chk
~ FLDLG2                          D9 EC chk
~ FLDLN2                          D9 ED chk
~ FLD0                            D9 EE chk
~ ST(0) FLDCW                     ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FLDCW                   D9 2E chk
~ RAX FLDCW                       ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FLDENV                  D9 26 chk
~ ST2 FMUL                        DC CA chk
~ DWORD PTR 0 [RSI] FMUL          D8 0E chk
~ QWORD PTR 0 [RSI] FMUL          DC 0E chk
~ ST2 RFMUL                       D8 CA chk
~ FMULP                           DE C9 chk
~ ST(1) FMULP                     DE C9 chk
~ WORD PTR 0 [RSI] FIMUL          DA 0E chk
~ DWORD PTR 0 [RSI] FIMUL         DE 0E chk
~ FNOP                            D9 D0 chk
~ FPATAN                          D9 F3 chk
~ FPREM                           D9 F8 chk
~ FPREM1                          D9 F5 chk
~ FPTAN                           D9 F2 chk
~ FRNDINT                         D9 FC chk
~ 0 [RSI] FRSTOR                  DD 26 chk
~ ES: 0 [RDI] FSAVE               26 9B DD 37 chk
~ 0 [RDI] ES: FNSAVE              26 DD 37 chk
~ FSCALE                          D9 FD chk
~ FSIN                            D9 FE chk
~ FSINCOS                         D9 FB chk
~ FSQRT                           D9 FA chk
~ WORD PTR 0 [RSI] FST            INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FST           D9 16 chk
~ QWORD PTR 0 [RSI] FST           DD 16 chk
~ TBYTE PTR 0 [RSI] FST           INVALID_OPERAND_TYPE$ !error
~ ST(4) FST                       DD D4 chk
~ RAX FST                         INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [RSI] FSTP           INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [RSI] FSTP          D9 1E chk
~ QWORD PTR 0 [RSI] FSTP          DD 1E chk
~ TBYTE PTR 0 [RSI] FSTP          DB 3E chk
~ ST(4) FSTP                      DD DC chk
~ RAX FSTP                        INVALID_OPERAND_TYPE$ !error
~ AX FNSTCW                       ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FNSTCW                  D9 3E chk
~ 0 [RSI] FSTCW                   9B D9 3E chk
~ 0 [RSI] FNSTENV                 D9 36 chk
~ 0 [RSI] FSTENV                  9B D9 36 chk
~ AX FNSTSW                       DF E0 chk
~ 0 [RSI] FNSTSW                  DD 3E chk
~ EAX FNSTSW                      ADDRESS_OPERAND_EXPECTED$ !error
~ AL FNSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ BX FNSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ ST(0) FNSTSW                    ADDRESS_OPERAND_EXPECTED$ !error
~ AX FSTSW                        9B DF E0 chk
~ 0 [RSI] FSTSW                   9B DD 3E chk
~ EAX FSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ AL FSTSW                        ADDRESS_OPERAND_EXPECTED$ !error
~ BX FSTSW                        ADDRESS_OPERAND_EXPECTED$ !error
~ ST(0) FSTSW                     ADDRESS_OPERAND_EXPECTED$ !error
~ ST2 FSUB                        DC E2 chk
~ DWORD PTR 0 [RSI] FSUB          D8 26 chk
~ QWORD PTR 0 [RSI] FSUB          DC 26 chk
~ ST2 RFSUB                       D8 E2 chk
~ FSUBP                           DE E1 chk
~ ST(1) FSUBP                     DE E1 chk
~ WORD PTR 0 [RSI] FISUB          DA 26 chk
~ DWORD PTR 0 [RSI] FISUB         DE 26 chk
~ ST2 FSUBR                       DC EA chk
~ DWORD PTR 0 [RSI] FSUBR         D8 2E chk
~ QWORD PTR 0 [RSI] FSUBR         DC 2E chk
~ ST2 RFSUBR                      D8 EA chk
~ FSUBRP                          DE E9 chk
~ ST(1) FSUBRP                    DE E9 chk
~ WORD PTR 0 [RSI] FISUBR         DA 2E chk
~ DWORD PTR 0 [RSI] FISUBR        DE 2E chk
~ FTST                            D9 E4 chk
~ FUCOM                           DD E1 chk
~ ST(3) FUCOM                     DD E3 chk
~ 0 [RSI] FUCOM                   FPU_REGISTER_EXPECTED$ !error
~ RAX FUCOM                       FPU_REGISTER_EXPECTED$ !error
~ FUCOMP                          DD E9 chk
~ ST(3) FUCOMP                    DD EB chk
~ 0 [RSI] FUCOMP                  FPU_REGISTER_EXPECTED$ !error
~ RAX FUCOMP                      FPU_REGISTER_EXPECTED$ !error
~ FUCOMPP                         DA E9 chk
~ FXCH                            D9 C9 chk
~ 0 [RSI] FXRSTOR                 0F AE 0E chk
~ ST(0) FXRSTOR                   ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FXSAVE                  0F AE 06 chk
~ ST(0) FXSAVE                    ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FXRSTOR64               48 0F AE 0E chk
~ ST(0) FXRSTOR64                 ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] FXSAVE64                48 0F AE 06 chk
~ ST(0) FXSAVE64                  ADDRESS_OPERAND_EXPECTED$ !error
~ FXTRACT                         D9 F4 chk
~ FYL2X                           D9 F1 chk
~ FYL2XP1                         D9 F9 chk
~ OWORD PTR 0 [RSI] XMM0 HADDPD   66 0F 7C 06 chk
~ XMM1 XMM2 HADDPD                66 0F 7C D1 chk
~ OWORD PTR 0 [RSI] XMM0 HADDPS   F2 0F 7C 06 chk
~ XMM1 XMM2 HADDPS                F2 0F 7C D1 chk
~ HLT                             F4 chk
~ OWORD PTR 0 [RSI] XMM0 HSUBPD   66 0F 7D 06 chk
~ XMM1 XMM2 HSUBPD                66 0F 7D D1 chk
~ OWORD PTR 0 [RSI] XMM0 HSUBPS   F2 0F 7D 06 chk
~ XMM1 XMM2 HSUBPS                F2 0F 7D D1 chk
~ 1 # IDIV                        INVALID_OPERAND_TYPE$ !error
~ AL IDIV                         F6 F8 chk
~ BX IDIV                         66 F7 FB chk
~ ECX IDIV                        F7 F9 chk
~ RDX IDIV                        48 F7 FA chk
~ BYTE PTR 0 [RAX] IDIV           F6 38 chk
~ WORD PTR 0 [RBX] IDIV           66 F7 3B chk
~ DWORD PTR 0 [RCX] IDIV          F7 39 chk
~ QWORD PTR 0 [RDX] IDIV          48 F7 3A chk
~ OWORD PTR 0 [RSI] IDIV          INVALID_OPERAND_SIZE$ !error
~ 1 # IMUL                        INVALID_OPERAND_TYPE$ !error
~ AL IMUL                         F6 E8 chk
~ BX IMUL                         66 F7 EB chk
~ ECX IMUL                        F7 E9 chk
~ RDX IMUL                        48 F7 EA chk
~ BYTE PTR 0 [RAX] IMUL           F6 28 chk
~ WORD PTR 0 [RBX] IMUL           66 F7 2B chk
~ DWORD PTR 0 [RCX] IMUL          F7 29 chk
~ QWORD PTR 0 [RDX] IMUL          48 F7 2A chk
~ OWORD PTR 0 [RSI] IMUL          INVALID_OPERAND_SIZE$ !error
~ AL BL IMUL                      REGISTER_16+_EXPECTED$ !error
~ AX BX IMUL                      66 0F AF D8 chk
~ AL EBX IMUL                     OPERAND_SIZE_MISMATCH$ !error
~ 0 [RSI] RSI IMUL                48 0F AF 36 chk
~ RSI 0 [RSI] IMUL                REGISTER_16+_EXPECTED$ !error
~ 2 # AL CL IMUL                  REGISTER_16+_EXPECTED$ !error
~ -2 # EAX RBX IMUL               OPERAND_SIZE_MISMATCH$ !error
~ -2 # RAX RBX IMUL               48 6B D8 FE chk
~ 4 # 0 [RSI] EDX IMUL            6B 16 04 chk
~ AL 3 # BL IMUL                  REGISTER_16+_EXPECTED$ !error
~ AL BL CL DL IMUL                INVALID_OPERAND_COMBINATION$ !error
~ -2000 # RAX RBX IMUL            48 69 D8 00 E0 FF FF chk
~ 4000 # 0 [RSI] DX IMUL          66 69 16 00 40 chk
~ 10 # AL IN                      E4 10 chk
~ 1000 # AL IN                    IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 10 # AX IN                      66 E5 10 chk
~ 10 # EAX IN                     E5 10 chk
~ 10 # RAX IN                     INVALID_OPERAND_SIZE$ !error
~ 10 # BL IN                      ACCU_OPERAND_REQUIRED$ !error
~ DX AL IN                        EC chk
~ DX AX IN                        66 ED chk
~ DX EAX IN                       ED chk
~ DX RAX IN                       INVALID_OPERAND_SIZE$ !error
~ DX CL IN                        ACCU_OPERAND_REQUIRED$ !error
~ CX AL IN                        IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 1 # INC                         INVALID_OPERAND_TYPE$ !error
~ AL INC                          FE C0 chk
~ BX INC                          66 FF C3 chk
~ ECX INC                         FF C1 chk
~ RDX INC                         48 FF C2 chk
~ BYTE PTR 0 [RAX] INC            FE 00 chk
~ WORD PTR 0 [RBX] INC            66 FF 03 chk
~ DWORD PTR 0 [RCX] INC           FF 01 chk
~ QWORD PTR 0 [RDX] INC           48 FF 02 chk
~ OWORD PTR 0 [RSI] INC           INVALID_OPERAND_SIZE$ !error
~ BYTE PTR INS                    6C chk
~ WORD PTR INS                    66 6D chk
~ DWORD PTR INS                   6D chk
~ QWORD PTR INS                   48 6D chk
~ 10 # XMM1 XMM2 INSERTPS         66 0F 3A 21 D1 10 chk
~ -10 # DWORD PTR 0 [RSI] XMM0 INSERTPS  66 0F 3A 21 06 F0 chk
~ 1 u# INT                        CD 01 chk
~ 3 u# INT                        CC chk
~ FF u# INT                       CD FF chk
~ 1000 u# INT                     IMMEDIATE8_OPERAND_EXPECTED$ !error
~ RAX INT                         IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 0 [RSI] INVLPG                  0F 01 3E chk
~ RAX INVLPG                      ADDRESS_OPERAND_EXPECTED$ !error
~ OWORD PTR CS: 0 [RDI] INVLPG    2E 0F 01 3F chk
~ IRET                            48 CF chk
~ HERE 2+ # 0= ?JMP               74 00 chk
~ HERE 2+ # ≥ ?JMP                7D 00 chk
~ HERE 2+ # U< ?JMP               72 00 chk
~ HERE 100 - # U< ?JMP            TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ HERE 100 + # U< ?JMP            TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ HERE 10 + # JMP                 EB 0E chk
~ HERE 10 + # NEAR JMP            E9 0B 00 00 00 chk
~ HERE 1000 + # JMP               E9 FB 0F 00 00 chk
~ 0 [RBX] [RBX] *8 JMP            FF 24 DB chk
~ 0 [] JMP                        FF 24 25 00 00 00 00 chk
~ RBX JMP                         48 FF E3 chk
~ AX BX LAR                       66 0F 02 D8 chk
~ BX EAX LAR                      0F 02 C3 chk
~ CX RDX LAR                      48 0F 02 D1 chk
~ ECX ESI LAR                     R/M_16_EXPECTED$ !error
~ AX DL LAR                       REGISTER_16+_EXPECTED$ !error
~ AL BX LAR                       R/M_16_EXPECTED$ !error
~ WORD PTR 0 [RSI] EAX LAR        0F 02 06 chk
~ DWORD PTR 0 [RSI] RAX LAR       R/M_16_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 LDDQU    F2 0F F0 06 chk
~ DWORD PTR 0 [RSI] XMM0 LDDQU    ADDRESS_128_OPERAND_EXPECTED$ !error
~ 0 [RSI] XMM0 LDDQU              ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM1 XMM0 LDDQU                 ADDRESS_128_OPERAND_EXPECTED$ !error
~ RAX XMM0 LDDQU                  ADDRESS_128_OPERAND_EXPECTED$ !error
~ RAX LDMXCSR                     ADDRESS_32_OPERAND_EXPECTED$ !error
~ DWORD PTR 0 [RSI] LDMXCSR       0F AE 16 chk
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
~ 0 [RBX] SI LFS                  66 0F B4 33 chk
~ 0 [RBX] ESI LFS                 0F B4 33 chk
~ 0 [RBX] RSI LFS                 48 0F B4 33 chk
~ RAX RSI LFS                     ADDRESS_OPERAND_EXPECTED$ !error
~ RAX 0 [RBX] LFS                 REGISTER_16+_EXPECTED$ !error
~ 0 [RBX] SI LGS                  66 0F B5 33 chk
~ 0 [RBX] ESI LGS                 0F B5 33 chk
~ 0 [RBX] RSI LGS                 48 0F B5 33 chk
~ 0 [RBX] SI LSS                  66 0F B2 33 chk
~ 0 [RBX] ESI LSS                 0F B2 33 chk
~ 0 [RBX] RSI LSS                 48 0F B2 33 chk
~ 5 [RBX] [RCX] *8 SI LEA         66 8D 74 CB 05 chk
~ -12 [R14] ESI LEA               41 8D 76 EE chk
~ 0 [RIP] RSI LEA                 48 8D 35 00 00 00 00 chk
~ RAX RSI LEA                     ADDRESS_OPERAND_EXPECTED$ !error
~ RAX 0 [RBX] LEA                 REGISTER_16+_EXPECTED$ !error
~ 0 [RAX] *8 RAX LEA              48 8D 04 C5 00 00 00 00 chk
~ 0 [RAX] RAX LEA                 48 8D 00 chk
~ LEAVE                           C9 chk
~ LFENCE                          0F AE 28 chk
~ 0 [RSI] LGDT                    0F 01 16 chk
~ RAX LGDT                        ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [RSI] LIDT                    0F 01 1E chk
~ XMM1 LIDT                       ADDRESS_OPERAND_EXPECTED$ !error
~ AX LLDT                         0F 00 D0 chk
~ WORD PTR 0 [RSI] LLDT           0F 00 16 chk
~ 0 [RSI] LLDT                    R/M_16_EXPECTED$ !error
~ 1 # LLDT                        R/M_16_EXPECTED$ !error
~ AX LMSW                         0F 01 F0 chk
~ WORD PTR 0 [RSI] LMSW           0F 01 36 chk
~ LOCK                            F0 chk
~ BYTE PTR LODS                   AC chk
~ WORD PTR LODS                   66 AD chk
~ DWORD PTR LODS                  AD chk
~ QWORD PTR LODS                  48 AD chk
~ there # LOOP                    E2 FE chk
~ RAX LOOP                        IMMEDIATE_OPERAND_EXPECTED$ !error
~ HERE # 0= ?LOOP                 E1 FE chk
~ HERE # = ?LOOP                  E1 FE chk
~ 1 # RAX ?LOOP                   CONDITION_OPERAND_EXPECTED$ !error
~ HERE # ≠ ?LOOP                  E0 FE chk
~ HERE # < ?LOOP                  EQ_OR_NEQ_REQUIRED$ !error
~ XMM0 XMM1 MASKMOVDQU            66 0F F7 C8 chk
~ 0 [RSI] XMM2 MASKMOVDQU         XMM_REGISTER_EXPECTED$ !error
~ XMM3 0 [RSI] MASKMOVDQU         XMM_REGISTER_EXPECTED$ !error
~ MM0 MM1 MASKMOVQ                0F F7 C8 chk
~ MM2 0 [RSI] MASKMOVQ            MMX_REGISTER_EXPECTED$ !error
~ 0 [RSI] MM2 MASKMOVQ            MMX_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 MAXPD                 66 0F 5F D1 chk
~ OWORD PTR 0 [RSI] XMM0 MAXPD    66 0F 5F 06 chk
~ XMM1 XMM2 MAXPS                 0F 5F D1 chk
~ OWORD PTR 0 [RSI] XMM0 MAXPS    0F 5F 06 chk
~ XMM1 XMM2 MAXSD                 F2 0F 5F D1 chk
~ QWORD PTR 0 [RSI] XMM0 MAXSD    F2 0F 5F 06 chk
~ XMM1 XMM2 MAXSS                 F3 0F 5F D1 chk
~ DWORD PTR 0 [RSI] XMM0 MAXSS    F3 0F 5F 06 chk
~ MFENCE                          0F AE 30 chk
~ XMM1 XMM2 MINPD                 66 0F 5D D1 chk
~ OWORD PTR 0 [RSI] XMM0 MINPD    66 0F 5D 06 chk
~ XMM1 XMM2 MINPS                 0F 5D D1 chk
~ OWORD PTR 0 [RSI] XMM0 MINPS    0F 5D 06 chk
~ XMM1 XMM2 MINSD                 F2 0F 5D D1 chk
~ QWORD PTR 0 [RSI] XMM0 MINSD    F2 0F 5D 06 chk
~ XMM1 XMM2 MINSS                 F3 0F 5D D1 chk
~ DWORD PTR 0 [RSI] XMM0 MINSS    F3 0F 5D 06 chk
~ MONITOR                         0F 01 C8 chk
~ 0 [] AL MOV                     A0 00 00 00 00 00 00 00 00 chk
~ 0 [] AX MOV                     66 A1 00 00 00 00 00 00 00 00 chk
~ 0 [] EAX MOV                    A1 00 00 00 00 00 00 00 00 chk
~ 0 [] RAX MOV                    48 A1 00 00 00 00 00 00 00 00 chk
~ 0 [] XMM1 MOV                   INVALID_OPERAND_COMBINATION$ !error
~ 0 [] BL MOV                     8A 1C 25 00 00 00 00 chk
~ AL 0 [] MOV                     A2 00 00 00 00 00 00 00 00 chk
~ AX 0 [] MOV                     66 A3 00 00 00 00 00 00 00 00 chk
~ EAX 0 [] MOV                    A3 00 00 00 00 00 00 00 00 chk
~ RAX 0 [] MOV                    48 A3 00 00 00 00 00 00 00 00 chk
~ XMM1 0 [] MOV                   INVALID_OPERAND_COMBINATION$ !error
~ BL 0 [] MOV                     88 1C 25 00 00 00 00 chk
~ WORD PTR 0 [] ES MOV            66 8E 04 25 00 00 00 00 chk
~ AX DS MOV                       66 8E D8 chk
~ DWORD PTR 0 [RBX] [RCX] *2 DS MOV  8E 1C 4B chk
~ DX CS MOV                       INVALID_OPERAND_COMBINATION$ !error
~ WORD PTR 0 [RSP] [RDX] *4 CS MOV   INVALID_OPERAND_COMBINATION$ !error
~ CX SS MOV                       66 8E D1 chk
~ QWORD PTR 0 [RBP] [RAX] *8 SS MOV  48 8E 54 C5 00 chk
~ RDX FS MOV                      48 8E E2 chk
~ WORD PTR 0 [] FS MOV            66 8E 24 25 00 00 00 00 chk
~ EAX GS MOV                      8E E8 chk
~ WORD PTR -12 [BX+SI] GS MOV     66 67 8E 68 EE chk
~ AL ES MOV                       R/M_16+_EXPECTED$ !error
~ ES AX MOV                       66 8C C0 chk
~ ES WORD PTR 0 [] MOV            66 8C 04 25 00 00 00 00 chk
~ DS SI MOV                       66 8C DE chk
~ DS DWORD PTR 0 [RBX] [RCX] *2 MOV  8C 1C 4B chk
~ CS MM0 MOV                      R/M_16+_EXPECTED$ !error
~ CS WORD PTR 0 [RSP] [RDX] *4 MOV   66 8C 0C 94 chk
~ SS CX MOV                       66 8C D1 chk
~ SS QWORD PTR 0 [RBP] [RAX] *8 MOV  48 8C 54 C5 00 chk
~ FS RDX MOV                      48 8C E2 chk
~ FS QWORD PTR 0 [] MOV           48 8C 24 25 00 00 00 00 chk
~ GS EAX MOV                      8C E8 chk
~ GS DWORD PTR -12 [BX+SI] MOV    67 8C 68 EE chk
~ GS AL MOV                       R/M_16+_EXPECTED$ !error
~ EDX CR0 MOV                     0F 22 C2 chk
~ DWORD PTR 0 [RSI] CR4 MOV       0F 22 26 chk
~ DX CR0 MOV                      R/M_32+_EXPECTED$ !error
~ RCX CR1 MOV                     48 0F 22 C9 chk
~ CL CR1 MOV                      R/M_32+_EXPECTED$ !error
~ RBX CR8 MOV                     4C 0F 22 C3 chk
~ QWORD PTR 0 [RSI] CR8 MOV       4C 0F 22 06 chk
~ CR0 EDX MOV                     0F 20 C2 chk
~ CR0 DWORD PTR 0 [RSI] MOV       0F 20 06 chk
~ CR1 RCX MOV                     48 0F 20 C9 chk
~ CR8 RBX MOV                     4C 0F 20 C3 chk
~ CR8 DWORD PTR 0 [RSI] MOV       44 0F 20 06 chk
~ EDX DR0 MOV                     0F 23 C2 chk
~ DWORD PTR 0 [RSI] DR0 MOV       0F 23 06 chk
~ WORD PTR 0 [RSI] DR0 MOV        R/M_32+_EXPECTED$ !error
~ RCX DR1 MOV                     48 0F 23 C9 chk
~ QWORD PTR 0 CS: [RDI] DR1 MOV   2E 48 0F 23 0F chk
~ RBX DR8 MOV                     4C 0F 23 C3 chk
~ DR0 EDX MOV                     0F 21 C2 chk
~ DR1 RCX MOV                     48 0F 21 C9 chk
~ DR8 RBX MOV                     4C 0F 21 C3 chk
~ 0 [RSI] [RCX] BL MOV            8A 1C 0E chk
~ 0 [RSI] [RCX] *2 BX MOV         66 8B 1C 4E chk
~ 0 [RSI] [RCX] *4 EBX MOV        8B 1C 8E chk
~ 0 [RSI] [RCX] *8 RBX MOV        48 8B 1C CE chk
~ BL 0 [RSI] [RCX] MOV            88 1C 0E chk
~ BX 0 [RSI] [RCX] *2 MOV         66 89 1C 4E chk
~ EBX 0 [RSI] [RCX] *4 MOV        89 1C 8E chk
~ RBX 0 [RSI] [RCX] *8 MOV        48 89 1C CE chk
~ AL BL MOV                       8A D8 chk
~ AX BX MOV                       66 8B D8 chk
~ EBX EAX MOV                     8B C3 chk
~ RSI R08 MOV                     4C 8B C6 chk
~ AL EDX MOV                      OPERAND_SIZE_MISMATCH$ !error
~ XMM0 RAX MOV                    OPERAND_SIZE_MISMATCH$ !error
~ RAX XMM0 MOV                    OPERAND_SIZE_MISMATCH$ !error
~ 0 [RSI] MM0 MOV                 INVALID_OPERAND_COMBINATION$ !error
~ MM1 0 [RDI] MOV                 INVALID_OPERAND_COMBINATION$ !error
~ 10 # CL MOV                     B1 10 chk
~ 10 # CX MOV                     66 B9 10 00 chk
~ 10 # ECX MOV                    B9 10 00 00 00 chk
~ 10 # RCX MOV                    48 B9 10 00 00 00 00 00 00 00 chk
~ 10000 # CL MOV                  IMMEDIATE_TOO_BIG$ !error
~ 10000 # CX MOV                  IMMEDIATE_TOO_BIG$ !error
~ 10000 # ECX MOV                 B9 00 00 01 00 chk
~ 100000000 # ECX MOV             IMMEDIATE_TOO_BIG$ !error
~ 123456789 # RCX MOV             48 B9 89 67 45 23 01 00 00 00 chk
~ 0 # BYTE PTR 0 [RAX] MOV        C6 00 00 chk
~ 3 # WORD PTR 0 [RSI] MOV        66 C7 06 03 00 chk
~ 6 # DWORD PTR 0 [RBP] MOV       C7 45 00 06 00 00 00 chk
~ 6 # QWORD PTR 0 [RSP] MOV       48 C7 04 24 06 00 00 00 chk
~ -6 # QWORD PTR 0 [RDI] MOV      48 C7 07 FA FF FF FF chk
~ OWORD PTR 0 [RSI] XMM0 MOVAPD   66 0F 28 06 chk
~ XMM1 OWORD PTR 0 [RSI] MOVAPD   66 0F 29 0E chk
~ XMM2 XMM3 MOVAPD                66 0F 28 DA chk
~ OWORD PTR 0 [RSI] XMM0 MOVAPS   0F 28 06 chk
~ XMM1 OWORD PTR 0 [RSI] MOVAPS   0F 29 0E chk
~ XMM2 XMM3 MOVAPS                0F 28 DA chk
~ AX AX MOVBE                     ADDRESS_OPERAND_EXPECTED$ !error
~ WORD PTR 0 [RSI] AX MOVBE       66 0F 38 F0 06 chk
~ DWORD PTR 0 [RBX] EAX MOVBE     0F 38 F0 03 chk
~ QWORD PTR 0 [RAX] RCX MOVBE     48 0F 38 F0 08 chk
~ WORD PTR 0 [RSI] AX MOVBE       66 0F 38 F0 06 chk
~ DWORD PTR 0 [RBX] EAX MOVBE     0F 38 F0 03 chk
~ QWORD PTR 0 [RAX] RCX MOVBE     48 0F 38 F0 08 chk
~ 10 # OWORD PTR 0 [RSI] MOVBE    REGISTER_16+_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 MOVBE    REGISTER_16+_EXPECTED$ !error
~ EAX MM0 MOVD                    0F 6E C0 chk
~ DWORD PTR 0 [RSI] MM0 MOVD      0F 6E 06 chk
~ EAX XMM0 MOVD                   66 0F 6E C0 chk
~ DWORD PTR 0 [RSI] XMM0 MOVD     66 0F 6E 06 chk
~ MM0 EAX MOVD                    0F 7E C0 chk
~ MM0 DWORD PTR 0 [RSI] MOVD      0F 7E 06 chk
~ XMM0 EAX MOVD                   66 0F 7E C0 chk
~ XMM0 DWORD PTR 0 [RSI] MOVD     66 0F 7E 06 chk
~ MM0 QWORD PTR 0 [RSI] MOVD      R/M_32_EXPECTED$ !error
~ MM0 AX MOVD                     R/M_32_EXPECTED$ !error
~ RAX MM0 MOVQ                    48 0F 6E C0 chk
~ QWORD PTR 0 [RSI] MM0 MOVQ      48 0F 6E 06 chk
~ RAX XMM0 MOVQ                   66 48 0F 6E C0 chk
~ QWORD PTR 0 [RSI] XMM0 MOVQ     66 48 0F 6E 06 chk
~ MM0 RAX MOVQ                    48 0F 7E C0 chk
~ MM0 QWORD PTR 0 [RSI] MOVQ      48 0F 7E 06 chk
~ XMM0 RAX MOVQ                   66 48 0F 7E C0 chk
~ XMM0 QWORD PTR 0 [RSI] MOVQ     66 48 0F 7E 06 chk
~ MM0 OWORD PTR 0 [RSI] MOVQ      R/M_64_EXPECTED$ !error
~ MM0 AX MOVQ                     R/M_64_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM0 MOVDQA   66 0F 6F 06 chk
~ XMM1 OWORD PTR 0 [RSI] MOVDQA   66 0F 7F 0E chk
~ XMM2 XMM3 MOVDQA                66 0F 6F DA chk
~ OWORD PTR 0 [RSI] XMM0 MOVDQU   F3 0F 6F 06 chk
~ XMM1 OWORD PTR 0 [RSI] MOVDQU   F3 0F 7F 0E chk
~ XMM2 XMM3 MOVDQU                F3 0F 6F DA chk
~ XMM7 MM3 MOVDQ2Q                F2 0F D6 DF chk
~ QWORD PTR 0 [RSI] MM1 MOVDQ2Q   XMM_REGISTER_EXPECTED$ !error
~ XMM5 QWORD PTR 0 [RSI] MOVDQ2Q  MMX_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 MOVHLPS               0F 12 D1 chk
~ QWORD PTR 0 [RSI] XMM2 MOVHLPS  XMM_REGISTER_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVHLPS  XMM_REGISTER_EXPECTED$ !error
~ XMM1 XMM5 MOVHPD                ADDRESS_64_OPERAND_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVHPD   66 0F 17 0F chk
~ QWORD PTR 0 [RSI] XMM4 MOVHPD   66 0F 16 26 chk
~ MM1 QWORD PTR 0 [RDI] MOVHPD    XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM4 MOVHPD    XMM_REGISTER_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVHPS   0F 17 0F chk
~ QWORD PTR 0 [RSI] XMM4 MOVHPS   0F 16 26 chk
~ XMM1 XMM5 MOVLPD                ADDRESS_64_OPERAND_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVLPD   66 0F 13 0F chk
~ QWORD PTR 0 [RSI] XMM4 MOVLPD   66 0F 12 26 chk
~ MM1 QWORD PTR 0 [RDI] MOVLPD    XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM4 MOVLPD    XMM_REGISTER_EXPECTED$ !error
~ XMM1 QWORD PTR 0 [RDI] MOVLPS   0F 13 0F chk
~ QWORD PTR 0 [RSI] XMM4 MOVLPS   0F 12 26 chk
~ XMM1 AX MOVMSKPD                REGISTER_32+_EXPECTED$ !error
~ XMM1 EAX MOVMSKPD               66 0F 50 C1 chk
~ XMM1 RAX MOVMSKPD               66 48 0F 50 C1 chk
~ QWORD PTR 0 [RSI] EAX MOVMSKPD  XMM_REGISTER_EXPECTED$ !error
~ RAX EAX MOVMSKPD                XMM_REGISTER_EXPECTED$ !error
~ XMM1 DWORD PTR 0 [RSI] MOVMSKPD REGISTER_32+_EXPECTED$ !error
~ XMM1 EAX MOVMSKPS               0F 50 C1 chk
~ XMM1 RAX MOVMSKPS               48 0F 50 C1 chk
~ XMM1 XMM5 MOVNTDQA              ADDRESS_128_OPERAND_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM7 MOVNTDQA 66 0F 38 2A 3E chk
~ DWORD PTR 0 [RSI] XMM6 MOVNTDQA ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM7 OWORD PTR 0 [RSI] MOVNTDQA XMM_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [RSI] XMM7 MOVNTDQ  ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM6 DWORD PTR 0 [RSI] MOVNTDQ  ADDRESS_128_OPERAND_EXPECTED$ !error
~ XMM7 OWORD PTR 0 [RSI] MOVNTDQ  66 0F E7 3E chk
~ EBX DWORD PTR 0 [RSI] MOVNTI    0F C3 1E chk
~ DWORD PTR 0 [RSI] EBX MOVNTI    REGISTER_32+_EXPECTED$ !error
~ BX 0 [RSI] MOVNTI               REGISTER_32+_EXPECTED$ !error
~ RAX 0 [RSP] MOVNTI              48 0F C3 04 24 chk
~ XMM1 OWORD PTR -2500 [RBP] MOVNTPD    66 0F 2B 8D 00 DB FF FF chk
~ XMM1 OWORD PTR 2500 [RBP] MOVNTPS     0F 2B 8D 00 25 00 00 chk
~ MM0 QWORD PTR 1 [RCX] [RAX] *4 MOVNTQ    0F E7 44 81 01 chk
~ QWORD PTR 1 [RCX] [RAX] *4 MM0 MOVNTQ    ADDRESS_OPERAND_EXPECTED$ !error
~ MM0 MM1 MOVNTQ                  ADDRESS_OPERAND_EXPECTED$ !error
~ MM3 MM5 MOVQ                    0F 6F EB chk
~ XMM3 XMM5 MOVQ                  F3 0F 7E EB chk
~ BYTE PTR MOVS                   A4 chk
~ WORD PTR MOVS                   66 A5 chk
~ DWORD PTR MOVS                  A5 chk
~ QWORD PTR MOVS                  48 A5 chk
~ XMM2 XMM3 MOVSD                 F2 0F 10 DA chk
~ QWORD PTR 0 [RSI] XMM7 MOVSD    F2 0F 10 3E chk
~ XMM6 QWORD PTR 0 [RDI] MOVSD    F2 0F 11 37 chk
~ RAX XMM0 MOVSD                  XMM_REGMEM64_EXPECTED$ !error
~ 0 [RSI] XMM5 MOVSD              XMM_REGMEM64_EXPECTED$ !error
~ XMM1 DWORD PTR 0 [RDI] MOVSD    XMM_REGMEM64_EXPECTED$ !error
~ AL AL MOVSX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVSX                     66 0F BE C3 chk
~ BYTE PTR 0 [RSI] DX MOVSX       66 0F BE 16 chk
~ BL EBX MOVSX                    0F BE DB chk
~ BYTE PTR 0 [RSI] ECX MOVSX      0F BE 0E chk
~ AL RSI MOVSX                    48 0F BE F0 chk
~ BYTE PTR 0 [RSI] RBP MOVSX      48 0F BE 2E chk
~ AL WORD PTR 0 [RDI] MOVSX       REGISTER_16_EXPECTED$ !error
~ BX EDI MOVSX                    0F BF FB chk
~ WORD PTR 0 [RSI] ESP MOVSX      0F BF 26 chk
~ R12W R13 MOVSX                  4D 0F BF EC chk
~ WORD PTR 12 [RIP] R08 MOVSX     4C 0F BF 05 12 00 00 00 chk
~ EDI RAX MOVSXD                  48 63 C7 chk
~ DWORD PTR -7 [RSI] [RCX] *4 R15 MOVSXD   4C 63 7C 8E F9 chk
~ XMM6 XMM5 MOVUPD                66 0F 10 EE chk
~ OWORD PTR 0 [RSI] XMM0 MOVUPD   66 0F 10 06 chk
~ XMM1 OWORD PTR 0 [RDI] MOVUPD   66 0F 11 0F chk
~ XMM6 XMM5 MOVUPS                0F 10 EE chk
~ OWORD PTR 0 [RSI] XMM0 MOVUPS   0F 10 06 chk
~ XMM1 OWORD PTR 0 [RDI] MOVUPS   0F 11 0F chk
~ AH R13 MOVSX                    HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ AL AL MOVZX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVZX                     66 0F B6 C3 chk
~ BYTE PTR 0 [RSI] DX MOVZX       66 0F B6 16 chk
~ BL EBX MOVZX                    0F B6 DB chk
~ BYTE PTR 0 [RSI] ECX MOVZX      0F B6 0E chk
~ AL RSI MOVZX                    48 0F B6 F0 chk
~ BYTE PTR 0 [RSI] RBP MOVZX      48 0F B6 2E chk
~ AL WORD PTR 0 [RDI] MOVZX       REGISTER_16_EXPECTED$ !error
~ BX EDI MOVZX                    0F B7 FB chk
~ WORD PTR 0 [RSI] ESP MOVZX      0F B7 26 chk
~ R12W R13 MOVZX                  4D 0F B7 EC chk
~ WORD PTR 12 [RIP] R08 MOVZX     4C 0F B7 05 12 00 00 00 chk
~ AH R13 MOVZX                    HIBYTE_NOT_AVAILABLE_WITH_REX$ !error
~ 22 # XMM0 XMM1 MPSADBW          66 0F 3A 42 C8 22 chk
~ -9 # OWORD PTR 0 [RSI] XMM3 MPSADBW   66 0F 3A 42 1E F7 chk
~ 1 # MUL                         INVALID_OPERAND_TYPE$ !error
~ AL MUL                          F6 E0 chk
~ BX MUL                          66 F7 E3 chk
~ ECX MUL                         F7 E1 chk
~ RDX MUL                         48 F7 E2 chk
~ BYTE PTR 0 [RAX] MUL            F6 20 chk
~ WORD PTR 0 [RBX] MUL            66 F7 23 chk
~ DWORD PTR 0 [RCX] MUL           F7 21 chk
~ QWORD PTR 0 [RDX] MUL           48 F7 22 chk
~ OWORD PTR 0 [RSI] MUL           INVALID_OPERAND_SIZE$ !error
~ XMM1 XMM2 MULPD                 66 0F 59 D1 chk
~ OWORD PTR 0 [RSI] XMM0 MULPD    66 0F 59 06 chk
~ XMM1 XMM2 MULPS                 0F 59 D1 chk
~ OWORD PTR 0 [RSI] XMM0 MULPS    0F 59 06 chk
~ XMM1 XMM2 MULSD                 F2 0F 59 D1 chk
~ QWORD PTR 0 [RSI] XMM0 MULSD    F2 0F 59 06 chk
~ XMM1 XMM2 MULSS                 F3 0F 59 D1 chk
~ DWORD PTR 0 [RSI] XMM0 MULSS    F3 0F 59 06 chk
~ MWAIT                           0F 01 C9 chk
~ 1 # NEG                         INVALID_OPERAND_TYPE$ !error
~ AL NEG                          F6 D8 chk
~ BX NEG                          66 F7 DB chk
~ ECX NEG                         F7 D9 chk
~ RDX NEG                         48 F7 DA chk
~ BYTE PTR 0 [RAX] NEG            F6 18 chk
~ WORD PTR 0 [RBX] NEG            66 F7 1B chk
~ DWORD PTR 0 [RCX] NEG           F7 19 chk
~ QWORD PTR 0 [RDX] NEG           48 F7 1A chk
~ OWORD PTR 0 [RSI] NEG           INVALID_OPERAND_SIZE$ !error
~ NOP                             90 chk
~ -1 # NOP                        INVALID_NOP_SIZE$ !error
~ 1 # NOP                         90 chk
~ 2 # NOP                         66 90 chk
~ 3 # NOP                         0F 1F 00 chk
~ 4 # NOP                         0F 1F 40 00 chk
~ 5 # NOP                         0F 1F 44 00 00 chk
~ 6 # NOP                         66 0F 1F 44 00 00 chk
~ 7 # NOP                         0F 1F 80 00 00 00 00 chk
~ 8 # NOP                         0F 1F 84 00 00 00 00 00 chk
~ 9 # NOP                         66 0F 1F 84 00 00 00 00 00 chk
~ 13 # NOP                        INVALID_NOP_SIZE$ !error
~ 1 # NOT                         INVALID_OPERAND_TYPE$ !error
~ AL NOT                          F6 D0 chk
~ BX NOT                          66 F7 D3 chk
~ ECX NOT                         F7 D1 chk
~ RDX NOT                         48 F7 D2 chk
~ BYTE PTR 0 [RAX] NOT            F6 10 chk
~ WORD PTR 0 [RBX] NOT            66 F7 13 chk
~ DWORD PTR 0 [RCX] NOT           F7 11 chk
~ QWORD PTR 0 [RDX] NOT           48 F7 12 chk
~ OWORD PTR 0 [RSI] NOT           INVALID_OPERAND_SIZE$ !error
~ AL AH OR                        08 C4 chk
~ DX 0 [RSI] OR                   66 09 16 chk
~ AL BPL OR                       40 08 C5 chk
~ QWORD PTR -123 [BP+DI] RSI OR   67 48 0B B3 DD FE chk
~ XMM7 XMM1 OR                    STANDARD_REGISTER_EXPECTED$ !error
~ SP SP OR                        66 09 E4 chk
~ CR0 RAX OR                      OPERAND_SIZE_MISMATCH$ !error
~ CS DS OR                        STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 ANDPD                 66 0F 54 C0 chk
~ OWORD PTR 0 [R10] XMM7 ANDPS    41 0F 54 3A chk
~ AL 10 # OUT                     E6 10 chk
~ AL 1000 # OUT                   IMMEDIATE8_OPERAND_EXPECTED$ !error
~ AX 10 # OUT                     66 E7 10 chk
~ EAX 10 # OUT                    E7 10 chk
~ RAX 10 # OUT                    INVALID_OPERAND_SIZE$ !error
~ BL 10 # OUT                     ACCU_OPERAND_REQUIRED$ !error
~ AL DX OUT                       EE chk
~ AX DX OUT                       66 EF chk
~ EAX DX OUT                      EF chk
~ RAX DX OUT                      INVALID_OPERAND_SIZE$ !error
~ CL DX OUT                       ACCU_OPERAND_REQUIRED$ !error
~ AL CX OUT                       IMMEDIATE8_OPERAND_EXPECTED$ !error
~ BYTE PTR OUTS                   6E chk
~ WORD PTR OUTS                   66 6F chk
~ DWORD PTR OUTS                  6F chk
~ QWORD PTR OUTS                  48 6F chk
~ MM1 MM2 PABSB                   0F 38 1C D1 chk
~ QWORD PTR 0 [RSI] MM3 PABSB     0F 38 1C 1E chk
~ XMM1 XMM2 PABSB                 66 0F 38 1C D1 chk
~ OWORD PTR 0 [RBX] XMM3 PABSB    66 0F 38 1C 1B chk
~ MM1 QWORD PTR 0 [RSI] PABSB     INVALID_OPERAND_COMBINATION$ !error
~ XMM1 OWORD PTR 0 [RBX] PABSB    INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 0 [RSI] RAX PABSB     INVALID_OPERAND_COMBINATION$ !error
~ MM1 MM2 PABSW                   0F 38 1D D1 chk
~ QWORD PTR 0 [RSI] MM3 PABSW     0F 38 1D 1E chk
~ XMM1 XMM2 PABSW                 66 0F 38 1D D1 chk
~ OWORD PTR 0 [RBX] XMM3 PABSW    66 0F 38 1D 1B chk
~ MM1 MM2 PABSD                   0F 38 1E D1 chk
~ QWORD PTR 0 [RSI] MM3 PABSD     0F 38 1E 1E chk
~ XMM1 XMM2 PABSD                 66 0F 38 1E D1 chk
~ OWORD PTR 0 [RBX] XMM3 PABSD    66 0F 38 1E 1B chk
~ MM1 MM2 PACKSSWB                0F 63 D1 chk
~ QWORD PTR 0 [RSI] MM3 PACKSSWB  0F 63 1E chk
~ XMM1 XMM2 PACKSSWB              66 0F 63 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PACKSSWB 66 0F 63 1B chk
~ MM1 QWORD PTR 0 [RSI] PACKSSWB  INVALID_OPERAND_COMBINATION$ !error
~ XMM1 OWORD PTR 0 [RBX] PACKSSWB INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 0 [RSI] RAX PACKSSWB  INVALID_OPERAND_COMBINATION$ !error
~ OWORD PTR 0 [RBX] XMM3 PACKSSDW 66 0F 6B 1B chk
~ MM1 QWORD PTR 0 [RSI] PACKSSDW  INVALID_OPERAND_COMBINATION$ !error
~ XMM1 OWORD PTR 0 [RBX] PACKSSDW INVALID_OPERAND_COMBINATION$ !error
~ QWORD PTR 0 [RSI] RAX PACKSSDW  INVALID_OPERAND_COMBINATION$ !error
~ XMM6 XMM7 PACKUSDW              66 0F 38 2B FE chk
~ OWORD PTR 0 [RSI] XMM0 PACKUSDW 66 0F 38 2B 06 chk
~ MM1 MM2 PACKUSWB                0F 67 D1 chk
~ QWORD PTR 0 [RBX] MM3 PACKUSWB  0F 67 1B chk
~ XMM1 XMM2 PACKUSWB              66 0F 67 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PACKUSWB 66 0F 67 1B chk
~ MM1 MM2 PADDB                   0F FC D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDB     0F FC 1E chk
~ XMM1 XMM2 PADDB                 66 0F FC D1 chk
~ OWORD PTR 0 [RBX] XMM3 PADDB    66 0F FC 1B chk
~ MM1 MM2 PADDW                   0F FD D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDW     0F FD 1E chk
~ XMM1 XMM2 PADDW                 66 0F FD D1 chk
~ OWORD PTR 0 [RBX] XMM3 PADDW    66 0F FD 1B chk
~ MM1 MM2 PADDD                   0F FE D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDD     0F FE 1E chk
~ XMM1 XMM2 PADDD                 66 0F FE D1 chk
~ OWORD PTR 0 [RBX] XMM3 PADDD    66 0F FE 1B chk
~ MM1 MM2 PADDQ                   0F D4 D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDQ     0F D4 1E chk
~ XMM1 XMM2 PADDQ                 66 0F D4 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PADDQ    66 0F D4 1B chk
~ MM1 MM2 PADDSB                  0F EC D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDSB    0F EC 1E chk
~ XMM9 XMM8 PADDSB                66 45 0F EC C1 chk
~ OWORD PTR 0 [R13] XMM15 PADDSB  66 45 0F EC 7D 00 chk
~ MM1 MM2 PADDSW                  0F ED D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDSW    0F ED 1E chk
~ XMM1 XMM2 PADDSW                66 0F ED D1 chk
~ OWORD PTR 0 [RBX] XMM3 PADDSW   66 0F ED 1B chk
~ MM1 MM2 PADDUSB                 0F DC D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDUSB   0F DC 1E chk
~ XMM1 XMM2 PADDUSB               66 0F DC D1 chk
~ OWORD PTR 0 [RBX] XMM3 PADDUSB  66 0F DC 1B chk
~ MM1 MM2 PADDUSW                 0F DD D1 chk
~ QWORD PTR 0 [RSI] MM3 PADDUSW   0F DD 1E chk
~ XMM9 XMM8 PADDUSW               66 45 0F DD C1 chk
~ OWORD PTR 0 [R15] XMM15 PADDUSW 66 45 0F DD 3F chk
~ 11 # MM3 MM4 PALIGNR            0F 3A 0F E3 11 chk
~ 22 # QWORD PTR 4 [RSI] MM4 PALIGNR    0F 3A 0F 66 04 22 chk
~ -3 # XMM3 XMM4 PALIGNR          66 0F 3A 0F E3 FD chk
~ -9 # OWORD PTR 8 [RSI] XMM4 PALIGNR   66 0F 3A 0F 66 08 F7 chk
~ MM1 MM2 PAND                    0F DB D1 chk
~ QWORD PTR 0 [RSI] MM3 PAND      0F DB 1E chk
~ XMM1 XMM2 PAND                  66 0F DB D1 chk
~ OWORD PTR 0 [RBX] XMM3 PAND     66 0F DB 1B chk
~ MM1 MM2 PANDN                   0F DF D1 chk
~ QWORD PTR 0 [RSI] MM3 PANDN     0F DF 1E chk
~ XMM1 XMM2 PANDN                 66 0F DF D1 chk
~ OWORD PTR 0 [RBX] XMM3 PANDN    66 0F DF 1B chk
~ PAUSE                           F3 90 chk
~ MM1 MM2 PAVGB                   0F E0 D1 chk
~ QWORD PTR 0 [RSI] MM3 PAVGB     0F E0 1E chk
~ XMM1 XMM2 PAVGB                 66 0F E0 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PAVGB    66 0F E0 1B chk
~ MM1 MM2 PAVGW                   0F E3 D1 chk
~ QWORD PTR 0 [RSI] MM3 PAVGW     0F E3 1E chk
~ XMM1 XMM2 PAVGW                 66 0F E3 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PAVGW    66 0F E3 1B chk
~ XMM6 XMM12 PBLENDVB             66 44 0F 38 10 E6 chk
~ OWORD PTR 0 [RBX] XMM2 PBLENDVB 66 0F 38 10 13 chk
~ 4 # XMM0 XMM2 PBLENDW           66 0F 3A 0E D0 04 chk
~ 0 # OWORD PTR 0 [RAX] XMM0 PBLENDW    66 0F 3A 0E 00 00 chk
~ -25 # XMM4 XMM5 PCLMULQDQ       66 0F 3A 44 EC DB chk
~ 7F # OWORD PTR 0 [RSI] XMM2 PCLMULQDQ    66 0F 3A 44 16 7F chk
~ MM1 MM2 PCMPEQB                 0F 74 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPEQB   0F 74 1E chk
~ XMM1 XMM2 PCMPEQB               66 0F 74 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPEQB  66 0F 74 1B chk
~ MM1 MM2 PCMPEQW                 0F 75 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPEQW   0F 75 1E chk
~ XMM1 XMM2 PCMPEQW               66 0F 75 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPEQW  66 0F 75 1B chk
~ MM1 MM2 PCMPEQD                 0F 76 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPEQD   0F 76 1E chk
~ XMM1 XMM2 PCMPEQD               66 0F 76 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPEQD  66 0F 76 1B chk
~ MM1 MM2 PCMPEQQ                 XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM3 PCMPEQQ   XMM_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 PCMPEQQ               66 0F 38 29 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPEQQ  66 0F 38 29 1B chk
~ 4 # XMM0 XMM2 PCMPESTRI         66 0F 3A 61 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPESTRI  66 0F 3A 61 00 01 chk
~ 4 # XMM0 XMM2 PCMPESTRM         66 0F 3A 60 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPESTRM  66 0F 3A 60 00 01 chk
~ MM1 MM2 PCMPGTB                 0F 64 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPGTB   0F 64 1E chk
~ XMM1 XMM2 PCMPGTB               66 0F 64 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPGTB  66 0F 64 1B chk
~ MM1 MM2 PCMPGTW                 0F 65 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPGTW   0F 65 1E chk
~ XMM1 XMM2 PCMPGTW               66 0F 65 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPGTW  66 0F 65 1B chk
~ MM1 MM2 PCMPGTD                 0F 66 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPGTD   0F 66 1E chk
~ XMM1 XMM2 PCMPGTD               66 0F 66 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPGTD  66 0F 66 1B chk
~ MM1 MM2 PCMPGTQ                 XMM_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [RSI] MM3 PCMPGTQ   XMM_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 PCMPGTQ               66 0F 38 37 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPGTQ  66 0F 38 37 1B chk
~ 4 # XMM0 XMM2 PCMPISTRI         66 0F 3A 63 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPISTRI  66 0F 3A 63 00 01 chk
~ 4 # XMM0 XMM2 PCMPISTRM         66 0F 3A 62 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 PCMPISTRM  66 0F 3A 62 00 01 chk
~ MM1 MM2 PCMPGTB                 0F 64 D1 chk
~ QWORD PTR 0 [RSI] MM3 PCMPGTB   0F 64 1E chk
~ XMM1 XMM2 PCMPGTB               66 0F 64 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PCMPGTB  66 0F 64 1B chk
~ 1 # XMM1 CH PEXTRB              66 0F 3A 14 CD 01 chk
~ 2 # XMM2 BYTE PTR 0 [RSI] PEXTRB   66 0F 3A 14 16 02 chk
~ 3 # BYTE PTR 3 [RSI] XMM3 PEXTRB   R/M_8_EXPECTED$ !error
~ 4 # XMM4 EAX PEXTRB             R/M_8_EXPECTED$ !error
~ 5 # XMM5 ECX PEXTRD             66 0F 3A 16 E9 05 chk
~ 6 # XMM6 DWORD PTR 6 [RSI] PEXTRD  66 0F 3A 16 76 06 06 chk
~ 7 # DWORD PTR 7 [RSI] XMM7 PEXTRD  R/M_32_EXPECTED$ !error
~ 8 # XMM8 BYTE PTR 8 [RSI] PEXTRD   R/M_32_EXPECTED$ !error
~ 9 # XMM9 RSI PEXTRQ             66 4C 0F 3A 16 CE 09 chk
~ 10 # XMM10 QWORD PTR 10 [RSI] PEXTRQ  66 4C 0F 3A 16 56 10 10 chk
~ 11 # QWORD PTR 11 [RSI] XMM11 PEXTRQ   R/M_64_EXPECTED$ !error
~ 12 # XMM12 EAX PEXTRW           66 41 0F 3A 15 C4 12 chk
~ 13 # XMM13 WORD PTR 13 [RSI] PEXTRW    66 44 0F C5 6E 13 13 chk
~ 14 # XMM14 QWORD PTR 14 [RSI] PEXTRW   66 44 0F C5 76 14 14 chk
~ 15 # WORD PTR 15 [RSI] XMM15 PEXTRW    REGISTER_16+_EXPECTED$ !error
~ 1 # MM1 DX PEXTRW               0F C5 D1 01 chk
~ 2 # MM2 R10 PEXTRW              44 0F C5 D2 02 chk
~ 3 # MM3 WORD PTR 3 [RSI] PEXTRW REGISTER_16+_EXPECTED$ !error
~ MM1 MM2 PHADDW                  0F 38 01 D1 chk
~ QWORD PTR 0 [RSI] MM3 PHADDW    0F 38 01 1E chk
~ XMM1 XMM2 PHADDW                66 0F 38 01 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHADDW   66 0F 38 01 1B chk
~ MM1 MM2 PHADDD                  0F 38 02 D1 chk
~ QWORD PTR 0 [RSI] MM3 PHADDD    0F 38 02 1E chk
~ XMM1 XMM2 PHADDD                66 0F 38 02 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHADDD   66 0F 38 02 1B chk
~ MM1 MM2 PHADDSW                 0F 38 03 D1 chk
~ QWORD PTR 0 [RSI] MM3 PHADDSW   0F 38 03 1E chk
~ XMM1 XMM2 PHADDSW               66 0F 38 03 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHADDSW  66 0F 38 03 1B chk
~ XMM1 XMM2 PHMINPOSUW            66 0F 38 41 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHMINPOSUW  66 0F 38 41 1B chk
~ MM1 MM2 PHSUBW                  0F 38 05 D1 chk
~ QWORD PTR 0 [RSI] MM3 PHSUBW    0F 38 05 1E chk
~ XMM1 XMM2 PHSUBW                66 0F 38 05 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHSUBW   66 0F 38 05 1B chk
~ MM1 MM2 PHSUBD                  0F 38 06 D1 chk
~ QWORD PTR 0 [RSI] MM3 PHSUBD    0F 38 06 1E chk
~ XMM1 XMM2 PHSUBD                66 0F 38 06 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHSUBD   66 0F 38 06 1B chk
~ MM1 MM2 PHSUBSW                 0F 38 07 D1 chk
~ QWORD PTR 0 [RSI] MM3 PHSUBSW   0F 38 07 1E chk
~ XMM1 XMM2 PHSUBSW               66 0F 38 07 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PHSUBSW  66 0F 38 07 1B chk
~ 1 # CH XMM1 PINSRB              66 0F 3A 20 CD 01 chk
~ 2 # BYTE PTR 0 [RSI] XMM2 PINSRB   66 0F 3A 20 16 02 chk
~ 3 # XMM3 BYTE PTR 3 [RSI] PINSRB   XMM_REGISTER_EXPECTED$ !error
~ 4 # EAX XMM4 PINSRB             R/M_8_EXPECTED$ !error
~ 5 # ECX XMM5 PINSRD             66 0F 3A 22 E9 05 chk
~ 6 # DWORD PTR 6 [RSI] XMM6 PINSRD  66 0F 3A 22 76 06 06 chk
~ 7 # XMM7 DWORD PTR 7 [RSI] PINSRD  XMM_REGISTER_EXPECTED$ !error
~ 8 # BYTE PTR 8 [RSI] XMM8 PINSRD   R/M_32_EXPECTED$ !error
~ 9 # RSI XMM9 PINSRQ             66 4C 0F 3A 22 CE 09 chk
~ 10 # QWORD PTR 10 [RSI] XMM10 PINSRQ  66 4C 0F 3A 22 56 10 10 chk
~ 11 # XMM11 QWORD PTR 11 [RSI] PINSRQ   XMM_REGISTER_EXPECTED$ !error
~ 12 # EAX XMM12 PINSRW           66 44 0F C4 E0 12 chk
~ 13 # WORD PTR 13 [RSI] XMM13 PINSRW   66 44 0F C4 6E 13 13 chk
~ 14 # QWORD PTR 14 [RSI] XMM14 PINSRW  R32/M16_EXPECTED$ !error
~ 15 # XMM15 WORD PTR 15 [RSI] PINSRW   XMM_REGISTER_EXPECTED$ !error
~ 1 # EDX MM1 PINSRW              0F C4 CA 01 chk
~ 2 # R10 MM2 PINSRW              R32/M16_EXPECTED$ !error
~ 3 # WORD PTR 3 [RSI] MM3 PINSRW 0F C4 5E 03 03 chk
~ MM1 MM2 PMADDUBSW               0F 38 04 D1 chk
~ QWORD PTR 0 [RSI] MM3 PMADDUBSW 0F 38 04 1E chk
~ XMM1 XMM2 PMADDUBSW             66 0F 38 04 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMADDUBSW   66 0F 38 04 1B chk
~ MM1 MM2 PMADDWD                 0F F5 D1 chk
~ QWORD PTR 0 [RSI] MM3 PMADDWD   0F F5 1E chk
~ XMM1 XMM2 PMADDWD               66 0F F5 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMADDWD  66 0F F5 1B chk
~ XMM1 XMM2 PMAXSB                66 0F 38 3C D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMAXSB   66 0F 38 3C 1E chk
~ XMM1 XMM2 PMAXSD                66 0F 38 3D D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMAXSD   66 0F 38 3D 1E chk
~ MM1 MM2 PMAXSW                  0F EE D1 chk
~ QWORD PTR 0 [RSI] MM3 PMAXSW    0F EE 1E chk
~ XMM1 XMM2 PMAXSW                66 0F EE D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMAXSW   66 0F EE 1B chk
~ MM1 MM2 PMAXUB                  0F DE D1 chk
~ QWORD PTR 0 [RSI] MM3 PMAXUB    0F DE 1E chk
~ XMM1 XMM2 PMAXUB                66 0F DE D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMAXUB   66 0F DE 1B chk
~ XMM1 XMM2 PMAXUD                66 0F 38 3F D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMAXUD   66 0F 38 3F 1E chk
~ XMM1 XMM2 PMAXUW                66 0F 38 3E D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMAXUW   66 0F 38 3E 1E chk
~ XMM1 XMM2 PMINSB                66 0F 38 38 D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMINSB   66 0F 38 38 1E chk
~ XMM1 XMM2 PMINSD                66 0F 38 39 D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMINSD   66 0F 38 39 1E chk
~ MM1 MM2 PMINSW                  0F EA D1 chk
~ QWORD PTR 0 [RSI] MM3 PMINSW    0F EA 1E chk
~ XMM1 XMM2 PMINSW                66 0F EA D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMINSW   66 0F EA 1B chk
~ MM1 MM2 PMINUB                  0F DA D1 chk
~ QWORD PTR 0 [RSI] MM3 PMINUB    0F DA 1E chk
~ XMM1 XMM2 PMINUB                66 0F DA D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMINUB   66 0F DA 1B chk
~ XMM1 XMM2 PMINUD                66 0F 38 3B D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMINUD   66 0F 38 3B 1E chk
~ XMM1 XMM2 PMINUW                66 0F 38 3A D1 chk
~ OWORD PTR 0 [RSI] XMM3 PMINUW   66 0F 38 3A 1E chk
~ MM4 BX PMOVMSKB                 REGISTER_32+_EXPECTED$ !error
~ MM5 ECX PMOVMSKB                0F D7 E9 chk
~ MM6 RDX PMOVMSKB                48 0F D7 F2 chk
~ MM7 MM0 PMOVMSKB                REGISTER_32+_EXPECTED$ !error
~ XMM4 BX PMOVMSKB                REGISTER_32+_EXPECTED$ !error
~ XMM5 ECX PMOVMSKB               66 0F D7 E9 chk
~ XMM6 RDX PMOVMSKB               66 48 0F D7 F2 chk
~ XMM7 MM0 PMOVMSKB               REGISTER_32+_EXPECTED$ !error
~ XMM1 XMM2 PMOVSXBW              66 0F 38 20 D1 chk
~ QWORD PTR 0 [RSI] XMM3 PMOVSXBW 66 0F 38 20 1E chk
~ XMM1 XMM2 PMOVSXBD              66 0F 38 21 D1 chk
~ DWORD PTR 0 [RSI] XMM5 PMOVSXBD 66 0F 38 21 2E chk
~ XMM1 XMM2 PMOVSXBQ              66 0F 38 22 D1 chk
~ WORD PTR 0 [RSI] XMM7 PMOVSXBQ  66 0F 38 22 3E chk
~ QWORD PTR 0 [RSI] XMM7 PMOVSXBQ XMM_REGMEM16_EXPECTED$ !error
~ XMM1 XMM2 PMOVSXWD              66 0F 38 23 D1 chk
~ QWORD PTR 0 [RSI] XMM3 PMOVSXWD 66 0F 38 23 1E chk
~ XMM1 XMM2 PMOVSXWQ              66 0F 38 24 D1 chk
~ DWORD PTR 0 [RSI] XMM3 PMOVSXWQ 66 0F 38 24 1E chk
~ XMM1 XMM2 PMOVSXDQ              66 0F 38 25 D1 chk
~ QWORD PTR 0 [RSI] XMM3 PMOVSXDQ 66 0F 38 25 1E chk
~ XMM1 XMM2 PMOVZXBW              66 0F 38 30 D1 chk
~ QWORD PTR 0 [RSI] XMM3 PMOVZXBW 66 0F 38 30 1E chk
~ XMM1 XMM2 PMOVZXBD              66 0F 38 31 D1 chk
~ DWORD PTR 0 [RSI] XMM5 PMOVZXBD 66 0F 38 31 2E chk
~ XMM1 XMM2 PMOVZXBQ              66 0F 38 32 D1 chk
~ WORD PTR 0 [RSI] XMM7 PMOVZXBQ  66 0F 38 32 3E chk
~ QWORD PTR 0 [RSI] XMM7 PMOVZXBQ XMM_REGMEM16_EXPECTED$ !error
~ XMM1 XMM2 PMOVZXWD              66 0F 38 33 D1 chk
~ QWORD PTR 0 [RSI] XMM3 PMOVZXWD 66 0F 38 33 1E chk
~ XMM1 XMM2 PMOVZXWQ              66 0F 38 34 D1 chk
~ DWORD PTR 0 [RSI] XMM3 PMOVZXWQ 66 0F 38 34 1E chk
~ XMM1 XMM2 PMOVZXDQ              66 0F 38 35 D1 chk
~ QWORD PTR 0 [RSI] XMM3 PMOVZXDQ 66 0F 38 35 1E chk
~ XMM15 XMM14 PMULDQ              66 45 0F 38 28 F7 chk
~ OWORD PTR 0 [RCX] XMM5 PMULDQ   66 0F 38 28 29 chk
~ MM1 MM2 PMULHRSW                0F 38 0B D1 chk
~ QWORD PTR 0 [RSI] MM3 PMULHRSW  0F 38 0B 1E chk
~ XMM1 XMM2 PMULHRSW              66 0F 38 0B D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMULHRSW 66 0F 38 0B 1B chk
~ MM1 MM2 PMULHUW                 0F E4 D1 chk
~ QWORD PTR 0 [RSI] MM3 PMULHUW   0F E4 1E chk
~ XMM1 XMM2 PMULHUW               66 0F E4 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMULHUW  66 0F E4 1B chk
~ MM1 MM2 PMULHW                  0F E5 D1 chk
~ QWORD PTR 0 [RSI] MM3 PMULHW    0F E5 1E chk
~ XMM1 XMM2 PMULHW                66 0F E5 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMULHW   66 0F E5 1B chk
~ XMM15 XMM14 PMULLD              66 45 0F 38 40 F7 chk
~ OWORD PTR 0 [RCX] XMM5 PMULLD   66 0F 38 40 29 chk
~ MM1 MM2 PMULLW                  0F D5 D1 chk
~ QWORD PTR 0 [RSI] MM3 PMULLW    0F D5 1E chk
~ XMM1 XMM2 PMULLW                66 0F D5 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMULLW   66 0F D5 1B chk
~ MM1 MM2 PMULUDQ                 0F F4 D1 chk
~ QWORD PTR 0 [RSI] MM3 PMULUDQ   0F F4 1E chk
~ XMM1 XMM2 PMULUDQ               66 0F F4 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PMULUDQ  66 0F F4 1B chk
~ ES POP                          07 chk
~ CS POP                          CANNOT_POP_CS$ !error
~ DS POP                          1F chk
~ SS POP                          17 chk
~ FS POP                          0F A1 chk
~ GS POP                          0F A9 chk
~ BX POP                          INVALID_OPERAND_SIZE$ !error
~ ECX POP                         INVALID_OPERAND_SIZE$ !error
~ RDX POP                         5A chk
~ 0 [RSI] POP                     INVALID_OPERAND_SIZE$ !error
~ BYTE PTR -10 [RDI] POP          INVALID_OPERAND_SIZE$ !error
~ WORD PTR 11 [RDI] POP           INVALID_OPERAND_SIZE$ !error
~ DWORD PTR 12 [RDI] POP          INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 13 [RDI] POP          8F 47 13 chk
~ OWORD PTR -14 [RDI] POP         INVALID_OPERAND_SIZE$ !error
~ MM0 POP                         INVALID_OPERAND_TYPE$ !error
~ XMM1 POP                        INVALID_OPERAND_TYPE$ !error
~ CR2 POP                         INVALID_OPERAND_TYPE$ !error
~ DR3 POP                         INVALID_OPERAND_TYPE$ !error
~ 5 # POP                         CANNOT_POP_CONSTANT$ !error
~ WORD PTR POPA                   LEGACY_OPCODE$ !error
~ DWORD PTR POPA                  LEGACY_OPCODE$ !error
~ QWORD PTR POPA                  LEGACY_OPCODE$ !error
~ BX CX POPCNT                    66 F3 0F B8 CB chk
~ WORD PTR 88 [RIP] AX POPCNT     66 F3 0F B8 05 88 00 00 00 chk
~ EDX BX POPCNT                   OPERAND_SIZE_MISMATCH$ !error
~ EBX ECX POPCNT                  F3 0F B8 CB chk
~ DWORD PTR 0 [RDX] EAX POPCNT    F3 0F B8 02 chk
~ RAX RAX POPCNT                  F3 48 0F B8 C0 chk
~ QWORD PTR 22 [RSI] RDX POPCNT   F3 48 0F B8 56 22 chk
~ RAX QWORD PTR 44 [RDI] POPCNT   REGISTER_16+_EXPECTED$ !error
~ 1 [RAX] EAX POPCNT              F3 0F B8 40 01 chk
~ OWORD PTR 1 [RAX] EAX POPCNT    OPERAND_SIZE_MISMATCH$ !error
~ WORD PTR POPF                   66 9D chk
~ DWORD PTR POPF                  9D chk
~ QWORD PTR POPF                  48 9D chk
~ POPF                            9D chk
~ MM1 MM2 POR                     0F EB D1 chk
~ QWORD PTR 0 [RSI] MM3 POR       0F EB 1E chk
~ XMM1 XMM2 POR                   66 0F EB D1 chk
~ OWORD PTR 0 [RBX] XMM3 POR      66 0F EB 1B chk
~ 0 [RDI] PREFETCHT0              0F 18 0F chk
~ 5 [RSI] PREFETCHT1              0F 18 56 05 chk
~ -12 [RBX] PREFETCHT2            0F 18 5B EE chk
~ 1234567 [] PREFETCHNTA          0F 18 04 25 67 45 23 01 chk
~ MM1 MM2 PSADBW                  0F F6 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSADBW    0F F6 1E chk
~ XMM1 XMM2 PSADBW                66 0F F6 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSADBW   66 0F F6 1B chk
~ MM1 MM2 PSHUFB                  0F 38 00 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSHUFB    0F 38 00 1E chk
~ XMM1 XMM2 PSHUFB                66 0F 38 00 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSHUFB   66 0F 38 00 1B chk
~ 5 # XMM1 XMM2 PSHUFD            66 0F 70 D1 05 chk
~ -2 # OWORD PTR 0 [RBX] XMM3 PSHUFD    66 0F 70 1B FE chk
~ 5 # XMM1 XMM2 PSHUFHW           F3 0F 70 D1 05 chk
~ -2 # OWORD PTR 0 [RBX] XMM3 PSHUFHW   F3 0F 70 1B FE chk
~ 5 # XMM1 XMM2 PSHUFLW           F2 0F 70 D1 05 chk
~ -2 # OWORD PTR 0 [RBX] XMM3 PSHUFLW   F2 0F 70 1B FE chk
~ 5 # MM1 MM2 PSHUFW              0F 70 D1 05 chk
~ -2 # QWORD PTR 0 [RBX] MM3 PSHUFW     0F 70 1B FE chk
~ MM1 MM2 PSIGNB                  0F 38 08 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSIGNB    0F 38 08 1E chk
~ XMM1 XMM2 PSIGNB                66 0F 38 08 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSIGNB   66 0F 38 08 1B chk
~ MM1 MM2 PSIGNW                  0F 38 09 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSIGNW    0F 38 09 1E chk
~ XMM1 XMM2 PSIGNW                66 0F 38 09 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSIGNW   66 0F 38 09 1B chk
~ MM1 MM2 PSIGND                  0F 38 0A D1 chk
~ QWORD PTR 0 [RSI] MM3 PSIGND    0F 38 0A 1E chk
~ XMM1 XMM2 PSIGND                66 0F 38 0A D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSIGND   66 0F 38 0A 1B chk
~ 10 # MM1 PSLLDQ                 XMM_REGISTER_EXPECTED$ !error
~ 10 # XMM5 PSLLDQ                66 0F 73 FD 10 chk
~ 10 # OWORD PTR 0 [RBX] PSLLDQ   XMM_REGISTER_EXPECTED$ !error
~ MM1 MM2 PSLLW                   0F F1 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSLLW     0F F1 1E chk
~ XMM1 XMM2 PSLLW                 66 0F F1 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSLLW    66 0F F1 1B chk
~ 4 # MM2 PSLLW                   0F 71 F2 04 chk
~ 8 # XMM4 PSLLW                  66 0F 71 F4 08 chk
~ MM1 MM2 PSLLD                   0F F2 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSLLD     0F F2 1E chk
~ XMM1 XMM2 PSLLD                 66 0F F2 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSLLD    66 0F F2 1B chk
~ 4 # MM2 PSLLD                   0F 72 F2 04 chk
~ 8 # XMM4 PSLLD                  66 0F 72 F4 08 chk
~ MM1 MM2 PSLLQ                   0F F3 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSLLQ     0F F3 1E chk
~ XMM1 XMM2 PSLLQ                 66 0F F3 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSLLQ    66 0F F3 1B chk
~ 4 # MM2 PSLLQ                   0F 73 F2 04 chk
~ 8 # XMM4 PSLLQ                  66 0F 73 F4 08 chk
~ MM1 MM2 PSRAW                   0F E1 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSRAW     0F E1 1E chk
~ XMM1 XMM2 PSRAW                 66 0F E1 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSRAW    66 0F E1 1B chk
~ 4 # MM2 PSRAW                   0F 71 E2 04 chk
~ 8 # XMM4 PSRAW                  66 0F 71 E4 08 chk
~ MM1 MM2 PSRAD                   0F E2 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSRAD     0F E2 1E chk
~ XMM1 XMM2 PSRAD                 66 0F E2 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSRAD    66 0F E2 1B chk
~ 4 # MM2 PSRAD                   0F 72 E2 04 chk
~ 8 # XMM4 PSRAD                  66 0F 72 E4 08 chk
~ 10 # MM1 PSRLDQ                 XMM_REGISTER_EXPECTED$ !error
~ 10 # XMM5 PSRLDQ                66 0F 73 DD 10 chk
~ 10 # OWORD PTR 0 [RBX] PSRLDQ   XMM_REGISTER_EXPECTED$ !error
~ MM1 MM2 PSRLW                   0F D1 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSRLW     0F D1 1E chk
~ XMM1 XMM2 PSRLW                 66 0F D1 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSRLW    66 0F D1 1B chk
~ 4 # MM2 PSRLW                   0F 71 D2 04 chk
~ 8 # XMM4 PSRLW                  66 0F 71 D4 08 chk
~ MM1 MM2 PSRLD                   0F D2 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSRLD     0F D2 1E chk
~ XMM1 XMM2 PSRLD                 66 0F D2 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSRLD    66 0F D2 1B chk
~ 4 # MM2 PSRLD                   0F 72 D2 04 chk
~ 8 # XMM4 PSRLD                  66 0F 72 D4 08 chk
~ MM1 MM2 PSRLQ                   0F D3 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSRLQ     0F D3 1E chk
~ XMM1 XMM2 PSRLQ                 66 0F D3 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSRLQ    66 0F D3 1B chk
~ 4 # MM2 PSRLQ                   0F 73 D2 04 chk
~ 8 # XMM4 PSRLQ                  66 0F 73 D4 08 chk
~ MM1 MM2 PSUBB                   0F F8 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBB     0F F8 1E chk
~ XMM1 XMM2 PSUBB                 66 0F F8 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBB    66 0F F8 1B chk
~ MM1 MM2 PSUBW                   0F F9 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBW     0F F9 1E chk
~ XMM1 XMM2 PSUBW                 66 0F F9 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBW    66 0F F9 1B chk
~ MM1 MM2 PSUBD                   0F FA D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBD     0F FA 1E chk
~ XMM1 XMM2 PSUBD                 66 0F FA D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBD    66 0F FA 1B chk
~ MM1 MM2 PSUBQ                   0F FB D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBQ     0F FB 1E chk
~ XMM1 XMM2 PSUBQ                 66 0F FB D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBQ    66 0F FB 1B chk
~ MM1 MM2 PSUBSB                  0F E8 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBSB    0F E8 1E chk
~ XMM1 XMM2 PSUBSB                66 0F E8 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBSB   66 0F E8 1B chk
~ MM1 MM2 PSUBSW                  0F E9 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBSW    0F E9 1E chk
~ XMM1 XMM2 PSUBSW                66 0F E9 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBSW   66 0F E9 1B chk
~ MM1 MM2 PSUBUSB                 0F D8 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBUSB   0F D8 1E chk
~ XMM1 XMM2 PSUBUSB               66 0F D8 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBUSB  66 0F D8 1B chk
~ MM1 MM2 PSUBUSW                 0F D9 D1 chk
~ QWORD PTR 0 [RSI] MM3 PSUBUSW   0F D9 1E chk
~ XMM1 XMM2 PSUBUSW               66 0F D9 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PSUBUSW  66 0F D9 1B chk
~ XMM1 XMM2 PTEST                 66 0F 38 17 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PTEST    66 0F 38 17 1B chk
~ MM1 MM2 PUNPCKHBW               0F 68 D1 chk
~ QWORD PTR 0 [RSI] MM3 PUNPCKHBW    0F 68 1E chk
~ XMM1 XMM2 PUNPCKHBW             66 0F 68 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHBW   66 0F 68 1B chk
~ MM1 MM2 PUNPCKHWD               0F 69 D1 chk
~ QWORD PTR 0 [RSI] MM3 PUNPCKHWD    0F 69 1E chk
~ XMM1 XMM2 PUNPCKHWD             66 0F 69 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHWD   66 0F 69 1B chk
~ MM1 MM2 PUNPCKHDQ               0F 6A D1 chk
~ QWORD PTR 0 [RSI] MM3 PUNPCKHDQ    0F 6A 1E chk
~ XMM1 XMM2 PUNPCKHDQ             66 0F 6A D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHDQ   66 0F 6A 1B chk
~ XMM1 XMM2 PUNPCKHQDQ            66 0F 6D D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKHQDQ  66 0F 6D 1B chk
~ MM1 MM2 PUNPCKLBW               0F 60 D1 chk
~ QWORD PTR 0 [RSI] MM3 PUNPCKLBW    0F 60 1E chk
~ XMM1 XMM2 PUNPCKLBW             66 0F 60 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLBW   66 0F 60 1B chk
~ MM1 MM2 PUNPCKLWD               0F 61 D1 chk
~ QWORD PTR 0 [RSI] MM3 PUNPCKLWD    0F 61 1E chk
~ XMM1 XMM2 PUNPCKLWD             66 0F 61 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLWD   66 0F 61 1B chk
~ MM1 MM2 PUNPCKLDQ               0F 62 D1 chk
~ QWORD PTR 0 [RSI] MM3 PUNPCKLDQ    0F 62 1E chk
~ XMM1 XMM2 PUNPCKLDQ             66 0F 62 D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLDQ   66 0F 62 1B chk
~ XMM1 XMM2 PUNPCKLQDQ            66 0F 6C D1 chk
~ OWORD PTR 0 [RBX] XMM3 PUNPCKLQDQ  66 0F 6C 1B chk
~ ES PUSH                         06 chk
~ CS PUSH                         0E chk
~ DS PUSH                         1E chk
~ SS PUSH                         16 chk
~ FS PUSH                         0F A0 chk
~ GS PUSH                         0F A8 chk
~ BX PUSH                         INVALID_OPERAND_SIZE$ !error
~ ECX PUSH                        INVALID_OPERAND_SIZE$ !error
~ RDX PUSH                        52 chk
~ 0 [RSI] PUSH                    INVALID_OPERAND_SIZE$ !error
~ BYTE PTR -10 [RDI] PUSH         INVALID_OPERAND_SIZE$ !error
~ WORD PTR 11 [RDI] PUSH          INVALID_OPERAND_SIZE$ !error
~ DWORD PTR 12 [RDI] PUSH         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 13 [RDI] PUSH         FF 77 13 chk
~ OWORD PTR -14 [RDI] PUSH        INVALID_OPERAND_SIZE$ !error
~ MM0 PUSH                        INVALID_OPERAND_TYPE$ !error
~ XMM1 PUSH                       INVALID_OPERAND_TYPE$ !error
~ CR2 PUSH                        INVALID_OPERAND_TYPE$ !error
~ DR3 PUSH                        INVALID_OPERAND_TYPE$ !error
~ 5 # PUSH                        6A 05 chk
~ 100 # PUSH                      66 68 00 01 chk
~ 1234567 # PUSH                  68 67 45 23 01 chk
~ MM1 MM2 PXOR                    0F EF D1 chk
~ QWORD PTR 0 [RSI] MM3 PXOR      0F EF 1E chk
~ XMM1 XMM2 PXOR                  66 0F EF D1 chk
~ OWORD PTR 0 [RBX] XMM3 PXOR     66 0F EF 1B chk
~ CL AL RCL                       D2 D0 chk
~ CL BYTE PTR 1 [RSI] RCL         D2 56 01 chk
~ 1 # AL RCL                      D0 D0 chk
~ 1 # BYTE PTR 2 [RSI] RCL        D0 56 02 chk
~ 5 # AL RCL                      C0 D0 05 chk
~ 5 # BYTE PTR 3 [RSI] RCL        C0 56 03 05 chk
~ CL BX RCL                       66 D3 D3 chk
~ CL WORD PTR 4 [RSI] RCL         66 D3 56 04 chk
~ 1 # BX RCL                      66 D1 D3 chk
~ 1 # WORD PTR 5 [RSI] RCL        66 D1 56 05 chk
~ 5 # BX RCL                      66 C1 D3 05 chk
~ 5 # WORD PTR 6 [RSI] RCL        66 C1 56 06 05 chk
~ CL ECX RCL                      D3 D1 chk
~ CL DWORD PTR 7 [RSI] RCL        D3 56 07 chk
~ 1 # ECX RCL                     D1 D1 chk
~ 1 # DWORD PTR 8 [RSI] RCL       D1 56 08 chk
~ 5 # ECX RCL                     C1 D1 05 chk
~ 5 # DWORD PTR 9 [RSI] RCL       C1 56 09 05 chk
~ CL RDX RCL                      48 D3 D2 chk
~ CL QWORD PTR 0 [RSI] RCL        48 D3 16 chk
~ 1 # RDX RCL                     48 D1 D2 chk
~ 1 # QWORD PTR 1 [RSI] RCL       48 D1 56 01 chk
~ 5 # RDX RCL                     48 C1 D2 05 chk
~ 5 # QWORD PTR 2 [RSI] RCL       48 C1 56 02 05 chk
~ AL BL RCL                       INVALID_OPERAND_COMBINATION$ !error
~ CL CR0 RCL                      STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR 0 [RSI] EDX RCL        INVALID_OPERAND_COMBINATION$ !error
~ CL AL RCR                       D2 D8 chk
~ CL BYTE PTR 1 [RSI] RCR         D2 5E 01 chk
~ 1 # AL RCR                      D0 D8 chk
~ 1 # BYTE PTR 2 [RSI] RCR        D0 5E 02 chk
~ 5 # AL RCR                      C0 D8 05 chk
~ 5 # BYTE PTR 3 [RSI] RCR        C0 5E 03 05 chk
~ CL BX RCR                       66 D3 DB chk
~ CL WORD PTR 4 [RSI] RCR         66 D3 5E 04 chk
~ CL AL ROL                       D2 C0 chk
~ CL BYTE PTR 1 [RSI] ROL         D2 46 01 chk
~ 1 # AL ROL                      D0 C0 chk
~ 1 # BYTE PTR 2 [RSI] ROL        D0 46 02 chk
~ 5 # AL ROL                      C0 C0 05 chk
~ 5 # BYTE PTR 3 [RSI] ROL        C0 46 03 05 chk
~ CL BX ROL                       66 D3 C3 chk
~ CL WORD PTR 4 [RSI] ROL         66 D3 46 04 chk
~ CL AL ROR                       D2 C8 chk
~ CL BYTE PTR 1 [RSI] ROR         D2 4E 01 chk
~ 1 # AL ROR                      D0 C8 chk
~ 1 # BYTE PTR 2 [RSI] ROR        D0 4E 02 chk
~ 5 # AL ROR                      C0 C8 05 chk
~ 5 # BYTE PTR 3 [RSI] ROR        C0 4E 03 05 chk
~ CL BX ROR                       66 D3 CB chk
~ CL WORD PTR 4 [RSI] ROR         66 D3 4E 04 chk
~ CL AL SAL                       D2 E0 chk
~ CL BYTE PTR 1 [RSI] SAL         D2 66 01 chk
~ 1 # AL SAL                      D0 E0 chk
~ 1 # BYTE PTR 2 [RSI] SAL        D0 66 02 chk
~ 5 # AL SAL                      C0 E0 05 chk
~ 5 # BYTE PTR 3 [RSI] SAL        C0 66 03 05 chk
~ CL BX SAL                       66 D3 E3 chk
~ CL WORD PTR 4 [RSI] SAL         66 D3 66 04 chk
~ CL AL SAR                       D2 F8 chk
~ CL BYTE PTR 1 [RSI] SAR         D2 7E 01 chk
~ 1 # AL SAR                      D0 F8 chk
~ 1 # BYTE PTR 2 [RSI] SAR        D0 7E 02 chk
~ 5 # AL SAR                      C0 F8 05 chk
~ 5 # BYTE PTR 3 [RSI] SAR        C0 7E 03 05 chk
~ CL BX SAR                       66 D3 FB chk
~ CL WORD PTR 4 [RSI] SAR         66 D3 7E 04 chk
~ CL AL SHL                       D2 E0 chk
~ CL BYTE PTR 1 [RSI] SHL         D2 66 01 chk
~ 1 # AL SHL                      D0 E0 chk
~ 1 # BYTE PTR 2 [RSI] SHL        D0 66 02 chk
~ 5 # AL SHL                      C0 E0 05 chk
~ 5 # BYTE PTR 3 [RSI] SHL        C0 66 03 05 chk
~ CL BX SHL                       66 D3 E3 chk
~ CL WORD PTR 4 [RSI] SHL         66 D3 66 04 chk
~ CL AL SHR                       D2 E8 chk
~ CL BYTE PTR 1 [RSI] SHR         D2 6E 01 chk
~ 1 # AL SHR                      D0 E8 chk
~ 1 # BYTE PTR 2 [RSI] SHR        D0 6E 02 chk
~ 5 # AL SHR                      C0 E8 05 chk
~ 5 # BYTE PTR 3 [RSI] SHR        C0 6E 03 05 chk
~ CL BX SHR                       66 D3 EB chk
~ CL WORD PTR 4 [RSI] SHR         66 D3 6E 04 chk
~ XMM1 XMM2 RCPPS                 0F 53 D1 chk
~ OWORD PTR 0 [RBX] XMM3 RCPPS    0F 53 1B chk
~ XMM1 XMM2 RCPSS                 F3 0F 53 D1 chk
~ DWORD PTR 0 [RBX] XMM3 RCPSS    F3 0F 53 1B chk
~ RDMSR                           0F 32 chk
~ RDPMC                           0F 33 chk
~ RDTSC                           0F 31 chk
~ RDTSCP                          0F 01 F9 chk
~ REP BYTE PTR MOVS               F3 A4 chk
~ REPE WORD PTR SCAS              F3 66 AF chk
~ REPZ DWORD PTR CMPS             F3 A7 chk
~ REPNE QWORD PTR SCAS            F2 48 AF chk
~ REPNZ BYTE PTR CMPS             F2 A6 chk
~ RET                             C3 chk
~ FAR RET                         CB chk
~ 2000 # RET                      C2 00 20 chk
~ -1000 # FAR RET                 CA 00 F0 chk
~ 4 # XMM0 XMM2 ROUNDPD           66 0F 3A 09 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 ROUNDPD    66 0F 3A 09 00 01 chk
~ 4 # XMM0 XMM2 ROUNDPS           66 0F 3A 08 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 ROUNDPS    66 0F 3A 08 00 01 chk
~ 4 # XMM0 XMM2 ROUNDSD           66 0F 3A 0B D0 04 chk
~ 1 # QWORD PTR 0 [RAX] XMM0 ROUNDSD    66 0F 3A 0B 00 01 chk
~ 4 # XMM0 XMM2 ROUNDSS           66 0F 3A 0A D0 04 chk
~ 1 # DWORD PTR 0 [RAX] XMM0 ROUNDSS    66 0F 3A 0A 00 01 chk
~ RSM                             0F AA chk
~ XMM1 XMM2 RSQRTPS               0F 52 D1 chk
~ OWORD PTR 0 [RBX] XMM3 RSQRTPS  0F 52 1B chk
~ XMM1 XMM2 RSQRTSS               F3 0F 52 D1 chk
~ DWORD PTR 0 [RBX] XMM3 RSQRTSS  F3 0F 52 1B chk
~ SAHF                            LEGACY_OPCODE$ !error
~ AL AH SBB                       18 C4 chk
~ DX 0 [RSI] SBB                  66 19 16 chk
~ AL BPL SBB                      40 18 C5 chk
~ QWORD PTR -123 [BP+DI] RSI SBB  67 48 1B B3 DD FE chk
~ XMM7 XMM1 SBB                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP SBB                       66 19 E4 chk
~ CR0 RAX SBB                     OPERAND_SIZE_MISMATCH$ !error
~ CS DS SBB                       STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR SCAS                   AE chk
~ WORD PTR SCAS                   66 AF chk
~ DWORD PTR SCAS                  AF chk
~ QWORD PTR SCAS                  48 AF chk
~ AL 0= ?SET                      0F 94 C0 chk
~ BYTE PTR 0 [RSI] U< ?SET        0F 92 06 chk
~ RDX 0< ?SET                     R/M_8_EXPECTED$ !error
~ DWORD PTR 0 [RSI] PY ?SET       R/M_8_EXPECTED$ !error
~ SFENCE                          0F AE 38 chk
~ WORD PTR 0 [RSI] SGDT           66 0F 01 06 chk
~ 0 [RSI] SGDT                    0F 01 06 chk
~ 33 # AL BL SHLD                 REGISTER_16+_EXPECTED$ !error
~ 32 # WORD PTR 0 [RSI] CX SHLD   REGISTER_16+_EXPECTED$ !error
~ 31 # DX WORD PTR 0 [RDI] SHLD   66 0F A4 17 31 chk
~ 30 # AX BX SHLD                 66 0F A4 C3 30 chk
~ 29 # EDX ECX SHLD               0F A4 D1 29 chk
~ 28 # ESI 0 [RDI] SHLD           0F A4 37 28 chk
~ 27 # ESI DWORD PTR 0 [RDI] SHLD 0F A4 37 27 chk
~ 26 # RSI RDI SHLD               48 0F A4 F7 26 chk
~ 25 # RSI QWORD PTR 0 [RDI] SHLD 48 0F A4 37 25 chk
~ CL AL BL SHLD                   REGISTER_16+_EXPECTED$ !error
~ CL WORD PTR 0 [RSI] CX SHLD     REGISTER_16+_EXPECTED$ !error
~ CL DX WORD PTR 0 [RDI] SHLD     66 0F A5 17 chk
~ CL AX BX SHLD                   66 0F A5 C3 chk
~ CL EDX ECX SHLD                 0F A5 D1 chk
~ CL ESI 0 [RDI] SHLD             0F A5 37 chk
~ CL ESI DWORD PTR 0 [RDI] SHLD   0F A5 37 chk
~ CL RSI RDI SHLD                 48 0F A5 F7 chk
~ CL RSI QWORD PTR 0 [RDI] SHLD   48 0F A5 37 chk
~ 4 # XMM0 XMM2 SHUFPD            66 0F C6 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 SHUFPD  66 0F C6 00 01 chk
~ 4 # XMM0 XMM2 SHUFPS            0F C6 D0 04 chk
~ 1 # OWORD PTR 0 [RAX] XMM0 SHUFPS  0F C6 00 01 chk
~ ES: WORD PTR 20 [RSP] SIDT      26 66 0F 01 4C 24 20 chk
~ ES: 20 [RSP] SIDT               26 0F 01 4C 24 20 chk
~ AX SLDT                         0F 00 C0 chk
~ WORD PTR 20 [RSP] SLDT          0F 00 44 24 20 chk
~ AX SMSW                         0F 01 E0 chk
~ WORD PTR 20 [RSP] SMSW          0F 01 64 24 20 chk
~ XMM1 XMM2 SQRTPS                0F 51 D1 chk
~ OWORD PTR 0 [RSI] XMM0 SQRTPS   0F 51 06 chk
~ XMM1 XMM2 SQRTSD                F2 0F 51 D1 chk
~ QWORD PTR 0 [RSI] XMM0 SQRTSD   F2 0F 51 06 chk
~ XMM1 XMM2 SQRTSS                F3 0F 51 D1 chk
~ DWORD PTR 0 [RSI] XMM0 SQRTSS   F3 0F 51 06 chk
~ STC                             F9 chk
~ STD                             FD chk
~ STI                             FB chk
~ RAX STMXCSR                     ADDRESS_32_OPERAND_EXPECTED$ !error
~ DWORD PTR 0 [RSI] STMXCSR       0F AE 1E chk
~ BYTE PTR STOS                   AA chk
~ WORD PTR STOS                   66 AB chk
~ DWORD PTR STOS                  AB chk
~ QWORD PTR STOS                  48 AB chk
~ AX STR                          0F 00 C8 chk
~ WORD PTR 0 [RDI] STR            0F 00 0F chk
~ AL AH SUB                       28 C4 chk
~ DX 0 [RSI] SUB                  66 29 16 chk
~ AL BPL SUB                      40 28 C5 chk
~ QWORD PTR -123 [BP+DI] RSI SUB  67 48 2B B3 DD FE chk
~ XMM7 XMM1 SUB                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP SUB                       66 29 E4 chk
~ CR0 RAX SUB                     OPERAND_SIZE_MISMATCH$ !error
~ CS DS SUB                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM1 XMM2 SUBPD                 66 0F 5C D1 chk
~ OWORD PTR 0 [RSI] XMM0 SUBPD    66 0F 5C 06 chk
~ XMM1 XMM2 SUBPS                 0F 5C D1 chk
~ OWORD PTR 0 [RSI] XMM0 SUBPS    0F 5C 06 chk
~ XMM1 XMM2 SUBSD                 F2 0F 5C D1 chk
~ QWORD PTR 0 [RSI] XMM0 SUBSD    F2 0F 5C 06 chk
~ XMM1 XMM2 SUBSS                 F3 0F 5C D1 chk
~ DWORD PTR 0 [RSI] XMM0 SUBSS    F3 0F 5C 06 chk
~ SWAPGS                          0F 01 38 chk
~ SYSCALL                         0F 05 chk
~ SYSENTER                        0F 34 chk
~ SYSEXIT                         0F 35 chk
~ QWORD PTR SYSEXIT               48 0F 35 chk
~ SYSRET                          0F 07 chk
~ QWORD PTR SYSRET                48 0F 07 chk
~ 10 # BL TEST                    F6 C3 10 chk
~ 10 # BH TEST                    F6 C7 10 chk
~ 10 # BX TEST                    66 F7 C3 10 00 chk
~ 1000 # ES TEST                  STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX TEST                   F7 C3 10 00 00 00 chk
~ 10 # RBX TEST                   48 F7 C3 10 00 00 00 chk
~ 100 # RBX TEST                  48 F7 C3 00 01 00 00 chk
~ 10 # 0 [ESP] TEST               I32_NOT_SUPPORTED$ !error
~ 10 # 0 [RSP] TEST               OPERAND_SIZE_UNKNOWN$ !error
~ 10 # BYTE PTR 0 [RBX] TEST      F6 03 10 chk
~ 1000 # WORD PTR -1000 [RSP] TEST   66 F7 84 24 00 F0 FF FF 00 10 chk
~ 10 # QWORD PTR 0 [RSI] TEST     48 F7 06 10 00 00 00 chk
~ 10 # AL TEST                    A8 10 chk
~ 10 # AX TEST                    66 A9 10 00 chk
~ 10 # EAX TEST                   A9 10 00 00 00 chk
~ 10 # RAX TEST                   48 A9 10 00 00 00 chk
~ AL AH TEST                      84 C4 chk
~ AL AX TEST                      OPERAND_SIZE_MISMATCH$ !error
~ AX SI TEST                      66 85 C6 chk
~ AX ES TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ DS AX TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ AX ES TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ 1 # CS TEST                     STANDARD_R/M_EXPECTED$ !error
~ 10 # CR0 TEST                   STANDARD_R/M_EXPECTED$ !error
~ DR7 CR7 TEST                    STANDARD_REGISTER_EXPECTED$ !error
~ 5 # ST0 TEST                    STANDARD_R/M_EXPECTED$ !error
~ EAX AL TEST                     OPERAND_SIZE_MISMATCH$ !error
~ EBX ESI TEST                    85 DE chk
~ RBX RSI TEST                    48 85 DE chk
~ ST(0) ST1 TEST                  STANDARD_REGISTER_EXPECTED$ !error
~ CR0 DR7 TEST                    STANDARD_REGISTER_EXPECTED$ !error
~ AL 0 [RSI] [RCX] *1 TEST        84 04 0E chk
~ 0 [RSI] [RBX] *1 AL TEST        INVALID_OPERAND_COMBINATION$ !error
~ RAX 0 [RBP] TEST                48 85 45 00 chk
~ R10 0 [RBP] [RCX] *8 TEST       4C 85 54 CD 00 chk
~ RAX 1000 [] TEST                48 85 04 25 00 10 00 00 chk
~ RAX 0 [R13] TEST                49 85 45 00 chk
~ R15 0 [R13] [RCX] *8 TEST       4D 85 7C CD 00 chk
~ R15W -1 [R13] *2 TEST           BASE_EBP_REQUIRED$ !error
~ R15W -1 [RBP] [R13] *2 TEST     66 46 85 7C 6D FF chk
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
~ DX -3000 [RDI] [RBP] *2 TEST    66 85 94 6F 00 D0 FF FF chk
~ RAX 28000 [RDI] *8 TEST         BASE_EBP_REQUIRED$ !error
~ RAX 28000 [RBP] [RDI] *8 TEST   48 85 84 FD 00 80 02 00 chk
~ XMM1 XMM2 UCOMISD               66 0F 2E D1 chk
~ QWORD PTR 0 [RSI] XMM0 UCOMISD  66 0F 2E 06 chk
~ XMM1 XMM2 UCOMISS               0F 2E D1 chk
~ DWORD PTR 0 [RSI] XMM0 UCOMISS  0F 2E 06 chk
~ UD2                             0F 0B chk
~ XMM1 XMM2 UNPACKHPD             66 0F 15 D1 chk
~ OWORD PTR 0 [RSI] XMM0 UNPACKHPD   66 0F 15 06 chk
~ XMM1 XMM2 UNPACKHPS             0F 15 D1 chk
~ OWORD PTR 0 [RSI] XMM0 UNPACKHPS   0F 15 06 chk
~ XMM1 XMM2 UNPACKLPD             66 0F 14 D1 chk
~ OWORD PTR 0 [RSI] XMM0 UNPACKLPD   66 0F 14 06 chk
~ XMM1 XMM2 UNPACKLPS             0F 14 D1 chk
~ OWORD PTR 0 [RSI] XMM0 UNPACKLPS   0F 14 06 chk
~ AX VERR                         0F 00 E0 chk
~ WORD PTR 20 [RBX] VERR          0F 00 63 20 chk
~ AX VERW                         0F 00 E8 chk
~ WORD PTR 20 [RBX] VERW          0F 00 6B 20 chk
~ WBINVD                          0F 09 chk
~ WRMSR                           0F 30 chk
~ BL CL XADD                      0F C0 D9 chk
~ AL 0 [RSI] XADD                 0F C0 06 chk
~ 0 [RSI] AL XADD                 STANDARD_REGISTER_EXPECTED$ !error
~ BX CX XADD                      66 0F C1 D9 chk
~ AX 0 [RSI] XADD                 66 0F C1 06 chk
~ EBX ECX XADD                    0F C1 D9 chk
~ EAX 0 [RSI] XADD                0F C1 06 chk
~ RBX R13 XADD                    49 0F C1 DD chk
~ RAX 0 [RSI] XADD                48 0F C1 06 chk
~ ST(0) RAX XADD                  OPERAND_SIZE_MISMATCH$ !error
~ EBX CR0 XADD                    STANDARD_REGISTER_EXPECTED$ !error
~ AL BL XCHG                      86 C3 chk
~ BL AL XCHG                      86 C3 chk
~ AX BX XCHG                      66 93 chk
~ BX AX XCHG                      66 93 chk
~ EAX EBX XCHG                    93 chk
~ RAX RBX XCHG                    48 93 chk
~ AL 0 [RSI] XCHG                 86 06 chk
~ AX 0 [RSI] XCHG                 66 87 06 chk
~ EAX 0 [RSI] XCHG                87 06 chk
~ RAX 0 [RSI] XCHG                48 87 06 chk
~ 0 [RSI] BL XCHG                 86 1E chk
~ 0 [RSI] CX XCHG                 66 87 0E chk
~ 0 [RBP] ESP XCHG                87 65 00 chk
~ 0 [RSI] R13 XCHG                4C 87 2E chk
~ XGETBV                          0F 01 D0 chk
~ XLAT                            D7 chk
~ QWORD PTR XLAT                  48 D7 chk
~ WORD PTR XLAT                   66 D7 chk
~ AL AH XOR                       30 C4 chk
~ DX 0 [RSI] XOR                  66 31 16 chk
~ AL BPL XOR                      40 30 C5 chk
~ QWORD PTR -123 [BP+DI] RSI XOR  67 48 33 B3 DD FE chk
~ XMM7 XMM1 XOR                   STANDARD_REGISTER_EXPECTED$ !error
~ SP SP XOR                       66 31 E4 chk
~ CR0 RAX XOR                     OPERAND_SIZE_MISMATCH$ !error
~ CS DS XOR                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 XORPD                 66 0F 57 C0 chk
~ OWORD PTR 0 [R10] XMM7 XORPS    41 0F 57 3A chk
~ 0 [RSI] XRSTOR                  0F AE 2E chk
~ 0 [RSI] XRSTOR64                48 0F AE 2E chk
~ 0 [RDI] XSAVE                   0F AE 27 chk
~ 0 [RDI] XSAVE64                 48 0F AE 27 chk
~ XSETBV                          0F 01 D1 chk
~ NOP BEGIN  RAX RAX ADD  END  NOP   90 EB 05 E9 03 00 00 00 48 01 C0 90 chk
~ NOP BEGIN  RAX RAX SUB  AGAIN  NOP    90 EB 05 E9 05 00 00 00 48 29 C0 EB FB 90 chk
~ NOP BEGIN  RAX RAX XOR  U< UNTIL  NOP    90 EB 05 E9 06 00 00 00 48 31 C0 3E 73 FA 90 chk
~ NOP BEGIN  RAX NOT  simblock+ U< UNTIL  NOP
  90 EB 05 E9 0B 00 00 00 48 F7 D0 2E 72 05 E9 F5 FF FF FF 90 chk
~ NOP > IF  RAX RAX AND  THEN  NOP
  90 7F 05 E9 03 00 00 00 48 21 C0 90 chk
~ NOP < UNLESS  RAX RAX OR  ELSE  RAX RAX AND  THEN  NOP
  90 7D 05 E9 08 00 00 00 48 09 C0 E9 03 00 00 00 48 21 C0 90 chk
~ NOP > IFEVER  RAX RAX AND  THEN  NOP
  90 2E 7F 05 E9 03 00 00 00 48 21 C0 90 chk
~ NOP < UNLESSEVER  RAX RAX OR  ELSE  RAX RAX AND  THEN  NOP
  90 2E 7D 05 E9 08 00 00 00 48 09 C0 E9 03 00 00 00 48 21 C0 90 chk
~ NOP BEGIN  RAX RAX TEST  0> WHILE  RAX DEC  REPEAT  NOP
  90 EB 05 E9 10 00 00 00 48 85 C0 3E 7F 05 E9 05 00 00 00 48 FF C8 EB F0 90 chk
~ NOP  FOR  RAX RAX TEST  NEXT  NOP   90 EB 05 E9 05 00 00 00 48 85 C0 E2 FB 90 chk
~ NOP  FOR  RAX RAX TEST  simblock+ NEXT  NOP
  90 EB 05 E9 0D 00 00 00 48 85 C0 48 FF C9 74 05 E9 F3 FF FF FF 90 chk
~ NOP BEGIN  RAX RAX ADD  BREAK  RBX RBX SBB  END  NOP
  90 EB 05 E9 08 00 00 00 48 01 C0 EB F6 48 19 DB 90 chk
~ NOP BEGIN  RAX RAX ADD  CONTINUE  RBX RBX SBB  END  NOP
  90 EB 05 E9 08 00 00 00 48 01 C0 EB FB 48 19 DB 90 chk
~ NOP BEGIN  RAX RAX ADD  CY ?BREAK  RBX RBX ADC  END  NOP
  90 EB 05 E9 09 00 00 00 48 01 C0 2E 72 F5 48 11 DB 90 chk
~ NOP BEGIN  RAX RAX ADD  CY ?CONTINUE  RBX RBX ADC  END  NOP
  90 EB 05 E9 09 00 00 00 48 01 C0 2E 72 FA 48 11 DB 90 chk
~ NOP BEGIN  RAX RAX ADD  simblock+ CY ?BREAK  RBX RBX ADC  END  NOP
  90 EB 05 E9 0E 00 00 00 48 01 C0 3E 73 05 E9 F0 FF FF FF 48 11 DB 90 chk
~ NOP BEGIN  RAX RAX ADD  simblock+ CY ?CONTINUE  RBX RBX ADC  END  NOP
  90 EB 05 E9 0E 00 00 00 48 01 C0 3E 73 05 E9 F5 FF FF FF 48 11 DB 90 chk
~ CELL [RBP] RBP LEA  QWORD PTR -CELL [RBP] POP              48 8D 6D 08 8F 45 F8 chk
~ QWORD PTR -CELL [RBP] PUSH  -CELL [RBP] RBP LEA  RET       FF 75 F8 48 8D 6D F8 C3 chk

stackcheck
cr
bye
