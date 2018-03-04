32 dup dup constant _ADDRSIZE constant _OPSIZE constant _ARCH
-1 constant _MMX  0 constant _XMM  -1 constant _X87

require forcemu.4th
require A0-IA64.gf
also ForcemblerTools
also Forcembler

( Test operands )

test-mode  cr

decimal $089A0B0C  12 11 10 9 8 !op

EAX                     00 #REGULAR #DWORD i32 #REGISTER !op    ¶
DS                      03 #SEGMENT #WORD uni #REGISTER !op     ¶
CL                      01 #REGULAR #BYTE uni #REGISTER !op     ¶
DH                      06 #HI-BYTE #BYTE uni #REGISTER !op     ¶
XMM7                    XMM_NOT_SUPPORTED$ !error               ¶
MM4                     04 #MMX #QWORD mmx #REGISTER !op        ¶
CR7                     07 #CONTROL #DWORD ext #REGISTER !op    ¶
DR2                     02 #DEBUG #DWORD ext #REGISTER !op      ¶
ST(3)                   03 #FLOATING #TBYTE x87 #REGISTER !op   ¶

0 [EAX]                 00 #LINEAR 0 i32 #ADDRESS !op           0 0 !disp             ¶
-1 [BP+SI]              02 #INDEXED 0 i16 #ADDRESS !op          -1 #BYTE !disp        ¶
100 []                  05 #DIRECT 0 i32 #ADDRESS !op           100 #DWORD !disp      ¶
0 [EBX] [RSI]           ARCHITECTURE_MISMATCH$ !error                                 ¶
0 [EBX] [ESI]           $63 #INDEXED 0 i32 #ADDRESS !op         0 0 !disp             ¶
\ 2000 [EBX] [ESI] *2     $43 #SCALED2 0 i64 #ADDRESS !op         2000 #WORD !disp      ¶

( Test operations )

hex

~ AAA                             37 chk
~ AAD                             D5 0A chk
~ 10 # AAD                        D5 10 chk
~ AAM                             D4 0A chk
~ 4 # AAM                         D4 04 chk
~ AAS                             3F chk
( testing logarop operand combinations by means of ADC: )
~ 10 # BL ADC                     80 D3 10 chk
~ 10 # BH ADC                     80 D7 10 chk
~ 10 # BX ADC                     66 83 D3 10 chk
~ 1000 # ES ADC                   STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX ADC                    83 D3 10 chk
~ 10 # RBX ADC                    I64_NOT_SUPPORTED$ !error
~ 100 # RBX ADC                   I64_NOT_SUPPORTED$ !error
~ 10 # 0 [ESP] ADC                OPERAND_SIZE_UNKNOWN$ !error
~ 10 # 0 [RSP] ADC                I64_NOT_SUPPORTED$ !error
~ 10 # BYTE PTR 0 [EBX] ADC       80 13 10 chk
~ 1000 # WORD PTR -1000 [ESP] ADC 66 81 94 24 00 F0 FF FF 00 10 chk
~ 10 # QWORD PTR 0 [ESI] ADC      INVALID_OPERAND_SIZE$ !error
~ 10 # AL ADC                     14 10 chk
~ 10 # AX ADC                     66 15 10 00 chk
~ 10 # EAX ADC                    15 10 00 00 00 chk
~ 10 # RAX ADC                    I64_NOT_SUPPORTED$ !error
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
~ RBX RSI ADC                     I64_NOT_SUPPORTED$ !error
~ AL 0 [ESI] [ECX] *1 ADC         10 04 0E chk
~ 0 [ESI] [EBX] *1 AL ADC         12 04 1E chk
~ 0 [EBP] RAX ADC                 I64_NOT_SUPPORTED$ !error
~ 0 [EBP] [ECX] *8 R10 ADC        I64_NOT_SUPPORTED$ !error
~ 1000 [] EAX ADC                 13 05 00 10 00 00 chk
~ 0 [ECX] [ESP] *2 AL ADC         INVALID_ADDRESS_INDEX$ !error
~ BX 0 [ECX] [ESP] *2 ADC         INVALID_ADDRESS_INDEX$ !error
~ DX -3000 [EDI] [EBP] *2 ADC     66 11 94 6F 00 D0 FF FF chk
~ 28000 [EBP] [EDI] *8 EAX ADC    13 84 FD 00 80 02 00 chk
~ EAX ESP ADD                     01 C4 chk
~ -8 [ESP] EAX ADD                03 44 24 F8 chk
~ 0 [BX] SI ADD                   66 67 03 37 chk
~ 0 [BP] SI ADD                   66 67 03 76 00 chk
~ -1 [BP] ESI ADD                 67 03 76 FF chk
~ 1000 [BX+SI] AL ADD             67 02 80 00 10 chk
~ 100000 [BX+SI] AL ADD           IMMEDIATE_TOO_BIG$ !error
~ CL 1000 [BX+SI] ADD             67 00 88 00 10 chk
~ DX 0 [BX+DI] ADD                66 67 01 11 chk
~ EAX EBX ADDPD                   XMM_REGISTER_EXPECTED$ !error
~ EAX XMM2 ADDPD                  XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDPD                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [ESI] XMM0 ADDPD    XMM_NOT_SUPPORTED$ !error
~ XMM7 OWORD PTR 0 [ESI] ADDPD    XMM_NOT_SUPPORTED$ !error
~ EAX EBX ADDPS                   XMM_REGISTER_EXPECTED$ !error
~ EAX XMM2 ADDPS                  XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDPS                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [ESI] XMM0 ADDPS    XMM_NOT_SUPPORTED$ !error
~ XMM7 OWORD PTR 0 [ESI] ADDPS    XMM_NOT_SUPPORTED$ !error
~ EAX EBX ADDSD                   XMM_REGISTER_EXPECTED$ !error
~ EAX XMM2 ADDSD                  XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDSD                 XMM_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [ESI] XMM0 ADDSD    XMM_NOT_SUPPORTED$ !error
~ XMM7 QWORD PTR 0 [ESI] ADDSD    XMM_NOT_SUPPORTED$ !error
~ EAX EBX ADDSS                   XMM_REGISTER_EXPECTED$ !error
~ EAX XMM2 ADDSS                  XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDSS                 XMM_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [ESI] XMM0 ADDSS    XMM_NOT_SUPPORTED$ !error
~ XMM7 QWORD PTR 0 [ESI] ADDSS    XMM_NOT_SUPPORTED$ !error
~ XMM3 XMM4 ADDSUBPD              XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [ESI] XMM0 ADDSUBPD XMM_NOT_SUPPORTED$ !error
~ XMM3 XMM4 ADDSUBPS              XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [RSI] XMM0 ADDSUBPS I64_NOT_SUPPORTED$ !error
~ XMM1 XMM0 AESDEC                XMM_NOT_SUPPORTED$ !error
~ OWORD PTR -1234 [] XMM7 AESDEC  XMM_NOT_SUPPORTED$ !error
~ XMM4 RAX AESDECLAST             XMM_NOT_SUPPORTED$ !error
~ XMM2 XMM3 AESDECLAST            XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM0 AESENC                XMM_NOT_SUPPORTED$ !error
~ XMM7 OWORD PTR -1234 [] AESENC  XMM_NOT_SUPPORTED$ !error
~ XMM4 CS AESENCLAST              XMM_NOT_SUPPORTED$ !error
~ XMM2 XMM3 AESENCLAST            XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 AESIMC                XMM_NOT_SUPPORTED$ !error
~ 3 # XMM1 XMM6 AESKEYGENASSIST   XMM_NOT_SUPPORTED$ !error
~ -1 # OWORD PTR 0 [EAX] [EBX] *4 XMM0 AESKEYGENASSIST  XMM_NOT_SUPPORTED$ !error
~ AL AH AND                       20 C4 chk
~ DX 0 [RSI] AND                  I64_NOT_SUPPORTED$ !error
~ AL BPL AND                      I64_NOT_SUPPORTED$ !error
~ QWORD PTR -123 [BP+DI] RSI AND  I64_NOT_SUPPORTED$ !error
~ XMM7 XMM1 AND                   XMM_NOT_SUPPORTED$ !error
~ SP SP AND                       66 21 E4 chk
~ CR0 RAX AND                     I64_NOT_SUPPORTED$ !error
~ CS DS AND                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 ANDPD                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [R10] XMM7 ANDPS    I64_NOT_SUPPORTED$ !error
~ OWORD PTR -1 [] XMM0 ANDNPD     XMM_NOT_SUPPORTED$ !error
~ XMM7 XMM6 ANDNPS                XMM_NOT_SUPPORTED$ !error
~ AX BX ARPL                      66 63 C3 chk
~ SP 0 [ECX] ARPL                 66 63 21 chk
~ WORD PTR 0 [EBX] AX ARPL        REGISTER_OPERAND_EXPECTED$ !error
~ 1000 # XMM0 XMM1 BLENDPD        XMM_NOT_SUPPORTED$ !error
~ -1 # XMM0 XMM1 BLENDPD          XMM_NOT_SUPPORTED$ !error
~ 2 # OWORD PTR 0 [RAX] XMM1 BLENDPS
                                  I64_NOT_SUPPORTED$ !error
~ EAX XMM1 EAX BLENDPS            XMM_NOT_SUPPORTED$ !error
~ EAX XMM1 XMM0 BLENDPS           XMM_NOT_SUPPORTED$ !error
~ XMM7 XMM5 BLENDVPD              XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM3 BLENDVPS              XMM_NOT_SUPPORTED$ !error
~ 0 [ESI] EAX BOUND               62 06 chk
~ 0 [EBX] DX BOUND                66 62 13 chk
~ DWORD PTR -25 [ESI] [EBP] *4 ESI BSF      0F BC 74 AE DB chk
~ ESI -25 [ESI] [EBP] *4 BSF      STANDARD_REGISTER_EXPECTED$ !error
~ ESI EDI BSF                     0F BC FE chk
~ DWORD PTR -25 [ESP] [EBP] *4 ESI BSR      0F BD 74 AC DB chk
~ EAX ECX BSR                     0F BD C8 chk
~ EDX BSWAP                       0F CA chk
~ ECX DWORD PTR 99 [ESI] BT       0F A3 8E 99 00 00 00 chk
~ ESI EDI BTS                     0F AB F7 chk
~ 78 # 0 [EDX] BTR                OPERAND_SIZE_UNKNOWN$ !error
~ 78 # WORD PTR 0 [EDX] BTR       66 0F BA 32 78 chk
~ -12 # ESI BTC                   0F BA FE EE chk
~ ECX BYTE PTR 99 [ESI] BT        OPERAND_SIZE_MISMATCH$ !error
~ HERE 10 + # CALL                E8 0B 00 00 00 chk
~ 0 [EBX] [EBX] *8 CALL           FF 14 DB chk
~ 0 [] CALL                       FF 15 00 00 00 00 chk
~ EBX CALL                        FF D3 chk
~ CBW                             66 98 chk
~ CWDE                            98 chk
~ CDQE                            INVALID_OPERAND_SIZE$ !error
~ CLC                             F8 chk
~ CLD                             FC chk
~ 0 [ESI] *4 CLFLUSH              0F AE 3C B5 00 00 00 00 chk
~ AL CLFLUSH                      ADDRESS_OPERAND_EXPECTED$ !error
~ CLI                             FA chk
~ CLTS                            0F 06 chk
~ CMC                             F5 chk
~ EBX EAX 0= ?MOV                 0F 44 C3 chk
~ 0 [EBX] EAX U< ?MOV             0F 42 03 chk
~ 0 [RIP] AL 0> ?MOV              RIP_64_ONLY$ !error
~ 0 [] AL 0> ?MOV                 0F 4F 05 00 00 00 00 chk
~ AX 0 [ESI] P= ?MOV              OPERAND_SIZE_UNKNOWN$ !error
~ AX WORD PTR 0 [ESI] P= ?MOV     STANDARD_REGISTER_EXPECTED$ !error
~ 1000 # EAX CMP                  3D 00 10 00 00 chk
~ 10 # WORD PTR -1 [ESI] CMP      66 83 7E FF 10 chk
~ EAX ECX CMP                     39 C1 chk
~ AL 90 [ECX] CMP                 38 81 90 00 00 00 chk
~ 90 [ECX] BH CMP                 3A B9 90 00 00 00 chk
~ BYTE PTR CMPS                   A6 chk
~ WORD PTR CMPS                   66 A7 chk
~ DWORD PTR CMPS                  A7 chk
~ QWORD PTR CMPS                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [] CMPXCHG8B        0F C7 0D 00 00 00 00 chk
~ CPUID                           0F A2 chk
~ CWD                             66 99 chk
~ CDQ                             99 chk
~ CQO                             INVALID_OPERAND_SIZE$ !error
~ DAA                             27 chk
~ DAS                             2F chk
~ 1 # DEC                         INVALID_OPERAND_TYPE$ !error
~ AL DEC                          FE C8 chk
~ BX DEC                          66 4B chk
~ ECX DEC                         49 chk
~ RDX DEC                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] DEC            FE 08 chk
~ WORD PTR 0 [EBX] DEC            66 FF 0B chk
~ DWORD PTR 0 [ECX] DEC           FF 09 chk
~ QWORD PTR 0 [EDX] DEC           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] DEC           INVALID_OPERAND_SIZE$ !error
~ 1 # DIV                         INVALID_OPERAND_TYPE$ !error
~ AL DIV                          F6 F0 chk
~ BX DIV                          66 F7 F3 chk
~ ECX DIV                         F7 F1 chk
~ RDX DIV                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] DIV            F6 30 chk
~ WORD PTR 0 [EBX] DIV            66 F7 33 chk
~ DWORD PTR 0 [ECX] DIV           F7 31 chk
~ QWORD PTR 0 [EDX] DIV           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] DIV           INVALID_OPERAND_SIZE$ !error
~ 10 2000 # ENTER                 C8 00 20 10 chk
~ 100 # ENTER                     MISSING_NESTING_LEVEL$ !error
~ 200 2000 # ENTER                NESTLEVEL_OPERAND_EXPECTED$ !error
~ 10 12345 # ENTER                IMMEDIATE16_OPERAND_EXPECTED$ !error
~ 0 1234 # ENTER                  C8 34 12 00 chk
~ F2^X-1                          D9 F0 chk
~ FABS                            D9 E1 chk
~ ST2 FADD                        DC C2 chk
~ EAX FADD                        INVALID_OPERAND_TYPE$ !error
~ 25 # FADD                       INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FADD           INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [ESI] FADD          D8 06 chk
~ QWORD PTR 0 [ESI] FADD          DC 06 chk
~ OWORD PTR 0 [ESI] FADD          INVALID_OPERAND_TYPE$ !error
~ ST2 RFADD                       D8 C2 chk
~ EAX RFADD                       FPU_REGISTER_EXPECTED$ !error
~ 25 # RFADD                      FPU_REGISTER_EXPECTED$ !error
~ WORD PTR 0 [ESI] RFADD          FPU_REGISTER_EXPECTED$ !error
~ DWORD PTR 0 [ESI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ QWORD PTR 0 [ESI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ OWORD PTR 0 [ESI] RFADD         FPU_REGISTER_EXPECTED$ !error
~ FADDP                           DE C1 chk
~ ST(1) FADDP                     DE C1 chk
~ QWORD PTR 0 [ESI] FADDP         FPU_REGISTER_EXPECTED$ !error
~ EAX FADDP                       FPU_REGISTER_EXPECTED$ !error
~ 23 # FADDP                      FPU_REGISTER_EXPECTED$ !error
~ ST2 FIADD                       INVALID_OPERAND_TYPE$ !error
~ EAX FIADD                       INVALID_OPERAND_TYPE$ !error
~ 25 # FIADD                      INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FIADD          DA 06 chk
~ DWORD PTR 0 [ESI] FIADD         DE 06 chk
~ QWORD PTR 0 [ESI] FIADD         INVALID_OPERAND_TYPE$ !error
~ OWORD PTR 0 [ESI] FIADD         INVALID_OPERAND_TYPE$ !error
~ 0 [EBX] FBLD                    OPERAND_SIZE_UNKNOWN$ !error
~ TBYTE PTR 0 [EBX] FBLD          DF 23 chk
~ QWORD PTR 0 [EBX] FBLD          ADDRESS_80_OPERAND_EXPECTED$ !error
~ ST(0) FBLD                      ADDRESS_80_OPERAND_EXPECTED$ !error
~ TBYTE PTR 0 [ESI] FBSTP         DF 36 chk
~ FCHS                            D9 E0 chk
~ FWAIT                           9B chk
~ FCLEX                           9B DB E2 chk
~ FNCLEX                          DB E2 chk
~ ST1 U< ?FMOV                    DA C1 chk
~ 0 [ESI] U< ?FMOV                FPU_REGISTER_EXPECTED$ !error
~ ST(2) = ?FMOV                   DA CA chk
~ EAX = ?FMOV                     FPU_REGISTER_EXPECTED$ !error
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
~ 0 [EDI] FUCOMI                  FPU_REGISTER_EXPECTED$ !error
~ FCOS                            D9 FF chk
~ FDECSTP                         D9 F6 chk
~ ST2 FDIV                        DC F2 chk
~ DWORD PTR 0 [ESI] FDIV          D8 36 chk
~ QWORD PTR 0 [ESI] FDIV          DC 36 chk
~ ST2 RFDIV                       D8 F2 chk
~ FDIVP                           DE F1 chk
~ ST(1) FDIVP                     DE F1 chk
~ WORD PTR 0 [ESI] FIDIV          DA 36 chk
~ DWORD PTR 0 [ESI] FIDIV         DE 36 chk
~ DWORD PTR 0 [ESI] FDIVR         D8 3E chk
~ QWORD PTR 0 [ESI] FDIVR         DC 3E chk
~ ST2 RFDIVR                      D8 FA chk
~ FDIVRP                          DE F9 chk
~ ST(1) FDIVRP                    DE F9 chk
~ WORD PTR 0 [ESI] FIDIVR         DA 3E chk
~ DWORD PTR 0 [ESI] FIDIVR        DE 3E chk
~ BYTE PTR 0 [ESI] FICOM          INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FICOM          DE 16 chk
~ DWORD PTR 0 [ESI] FICOM         DA 16 chk
~ QWORD PTR 0 [ESI] FICOM         INVALID_OPERAND_TYPE$ !error
~ ST(0) FICOM                     INVALID_OPERAND_TYPE$ !error
~ EAX FICOM                       INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [ESI] FILD           INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FILD           DF 06 chk
~ DWORD PTR 0 [ESI] FILD          DB 06 chk
~ QWORD PTR 0 [ESI] FILD          DF 2E chk
~ ST(0) FILD                      INVALID_OPERAND_TYPE$ !error
~ EAX FILD                        INVALID_OPERAND_TYPE$ !error
~ FINCSTP                         D9 F7 chk
~ FINIT                           9B DB E3 chk
~ FNINIT                          DB E3 chk
~ BYTE PTR 0 [ESI] FIST           INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FIST           DF 16 chk
~ DWORD PTR 0 [ESI] FIST          DB 16 chk
~ QWORD PTR 0 [ESI] FIST          INVALID_OPERAND_TYPE$ !error
~ ST(0) FIST                      INVALID_OPERAND_TYPE$ !error
~ EAX FIST                        INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [ESI] FISTP          INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FISTP          DF 1E chk
~ DWORD PTR 0 [ESI] FISTP         DB 1E chk
~ QWORD PTR 0 [ESI] FISTP         DF 3E chk
~ ST(0) FISTP                     INVALID_OPERAND_TYPE$ !error
~ EAX FISTP                       INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [ESI] FISTTP         INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FISTTP         DF 0E chk
~ DWORD PTR 0 [ESI] FISTTP        DB 0E chk
~ QWORD PTR 0 [ESI] FISTTP        DD 0E chk
~ ST(0) FISTTP                    INVALID_OPERAND_TYPE$ !error
~ EAX FISTTP                      INVALID_OPERAND_TYPE$ !error
~ BYTE PTR 0 [ESI] FLD            INVALID_OPERAND_TYPE$ !error
~ WORD PTR 0 [ESI] FLD            INVALID_OPERAND_TYPE$ !error
~ DWORD PTR 0 [ESI] FLD           D9 06 chk
~ QWORD PTR 0 [ESI] FLD           DD 06 chk
~ TBYTE PTR 0 [ESI] FLD           DB 2E chk
~ OWORD PTR 0 [ESI] FLD           INVALID_OPERAND_TYPE$ !error
~ ST(3) FLD                       D9 C3 chk
~ EAX FLD                         INVALID_OPERAND_TYPE$ !error
~ FLD1                            D9 E8 chk
~ FLDL2T                          D9 E9 chk
~ FLDL2E                          D9 EA chk
~ FLDPI                           D9 EB chk
~ FLDLG2                          D9 EC chk
~ FLDLN2                          D9 ED chk
~ FLD0                            D9 EE chk
~ ST(0) FLDCW                     ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [ESI] FLDCW                   D9 2E chk
~ EAX FLDCW                       ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [ESI] FLDENV                  D9 26 chk
~ ST2 FMUL                        DC CA chk
~ DWORD PTR 0 [ESI] FMUL          D8 0E chk
~ QWORD PTR 0 [ESI] FMUL          DC 0E chk
~ ST2 RFMUL                       D8 CA chk
~ FMULP                           DE C9 chk
~ ST(1) FMULP                     DE C9 chk
~ WORD PTR 0 [ESI] FIMUL          DA 0E chk
~ DWORD PTR 0 [ESI] FIMUL         DE 0E chk
~ FNOP                            D9 D0 chk
~ FPATAN                          D9 F3 chk
~ FPREM                           D9 F8 chk
~ FPREM1                          D9 F5 chk
~ FPTAN                           D9 F2 chk
~ FRNDINT                         D9 FC chk
~ 0 [ESI] FRSTOR                  DD 26 chk
~ ES: 0 [EDI] FSAVE               26 9B DD 37 chk
~ 0 [EDI] ES: FNSAVE              26 DD 37 chk
~ FSCALE                          D9 FD chk
~ FSIN                            D9 FE chk
~ FSINCOS                         D9 FB chk
~ FSQRT                           D9 FA chk
~ AX FNSTSW                       DF E0 chk
~ 0 [ESI] FNSTSW                  DD 3E chk
~ EAX FNSTSW                      ADDRESS_OPERAND_EXPECTED$ !error
~ AL FNSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ BX FNSTSW                       ADDRESS_OPERAND_EXPECTED$ !error
~ ST(0) FNSTSW                    ADDRESS_OPERAND_EXPECTED$ !error
~ ST2 FSUB                        DC E2 chk
~ DWORD PTR 0 [ESI] FSUB          D8 26 chk
~ QWORD PTR 0 [ESI] FSUB          DC 26 chk
~ ST2 RFSUB                       D8 E2 chk
~ FSUBP                           DE E1 chk
~ ST(1) FSUBP                     DE E1 chk
~ WORD PTR 0 [ESI] FISUB          DA 26 chk
~ DWORD PTR 0 [ESI] FISUB         DE 26 chk
~ ST2 FSUBR                       DC EA chk
~ DWORD PTR 0 [ESI] FSUBR         D8 2E chk
~ QWORD PTR 0 [ESI] FSUBR         DC 2E chk
~ ST2 RFSUBR                      D8 EA chk
~ FSUBRP                          DE E9 chk
~ ST(1) FSUBRP                    DE E9 chk
~ WORD PTR 0 [ESI] FISUBR         DA 2E chk
~ DWORD PTR 0 [ESI] FISUBR        DE 2E chk
~ FTST                            D9 E4 chk
~ FUCOM                           DD E1 chk
~ ST(3) FUCOM                     DD E3 chk
~ 0 [ESI] FUCOM                   FPU_REGISTER_EXPECTED$ !error
~ EAX FUCOM                       FPU_REGISTER_EXPECTED$ !error
~ FUCOMP                          DD E9 chk
~ ST(3) FUCOMP                    DD EB chk
~ 0 [ESI] FUCOMP                  FPU_REGISTER_EXPECTED$ !error
~ EAX FUCOMP                      FPU_REGISTER_EXPECTED$ !error
~ FUCOMPP                         DA E9 chk
~ FXCH                            D9 C9 chk
~ 0 [ESI] FXRSTOR                 0F AE 0E chk
~ ST(0) FXRSTOR                   ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [ESI] FXSAVE                  0F AE 06 chk
~ ST(0) FXSAVE                    ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [ESI] FXRSTOR64               48 0F AE 0E chk
~ ST(0) FXRSTOR64                 ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [ESI] FXSAVE64                48 0F AE 06 chk
~ ST(0) FXSAVE64                  ADDRESS_OPERAND_EXPECTED$ !error
~ FXTRACT                         D9 F4 chk
~ FYL2X                           D9 F1 chk
~ FYL2XP1                         D9 F9 chk
~ OWORD PTR 0 [ESI] XMM0 HADDPD   XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 HADDPS                XMM_NOT_SUPPORTED$ !error
~ HLT                             F4 chk
~ OWORD PTR 0 [ESI] XMM0 HSUBPD   XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 HSUBPS                XMM_NOT_SUPPORTED$ !error
~ 1 # IDIV                        INVALID_OPERAND_TYPE$ !error
~ AL IDIV                         F6 F8 chk
~ BX IDIV                         66 F7 FB chk
~ ECX IDIV                        F7 F9 chk
~ RDX IDIV                        I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] IDIV           F6 38 chk
~ WORD PTR 0 [EBX] IDIV           66 F7 3B chk
~ DWORD PTR 0 [ECX] IDIV          F7 39 chk
~ QWORD PTR 0 [EDX] IDIV          INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] IDIV          INVALID_OPERAND_SIZE$ !error
~ 1 # IMUL                        INVALID_OPERAND_TYPE$ !error
~ AL IMUL                         F6 E8 chk
~ BX IMUL                         66 F7 EB chk
~ ECX IMUL                        F7 E9 chk
~ RDX IMUL                        I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] IMUL           F6 28 chk
~ WORD PTR 0 [EBX] IMUL           66 F7 2B chk
~ DWORD PTR 0 [ECX] IMUL          F7 29 chk
~ QWORD PTR 0 [EDX] IMUL          INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] IMUL          INVALID_OPERAND_SIZE$ !error
~ AL BL IMUL                      REGISTER_16+_EXPECTED$ !error
~ AX BX IMUL                      66 0F AF D8 chk
~ AL EBX IMUL                     OPERAND_SIZE_MISMATCH$ !error
~ 0 [ESI] ESI IMUL                0F AF 36 chk
~ ESI 0 [ESI] IMUL                REGISTER_16+_EXPECTED$ !error
~ 2 # AL CL IMUL                  REGISTER_16+_EXPECTED$ !error
~ -2 # EAX RBX IMUL               I64_NOT_SUPPORTED$ !error
~ -2 # EAX EBX IMUL               6B D8 FE chk
~ 4 # 0 [ESI] EDX IMUL            6B 16 04 chk
~ AL 3 # BL IMUL                  REGISTER_16+_EXPECTED$ !error
~ AL BL CL DL IMUL                INVALID_OPERAND_COMBINATION$ !error
~ -2000 # EAX EBX IMUL            69 D8 00 E0 FF FF chk
~ 4000 # 0 [ESI] DX IMUL          66 69 16 00 40 chk
~ 10 # AL IN                      E4 10 chk
~ 1000 # AL IN                    IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 10 # AX IN                      66 E5 10 chk
~ 10 # EAX IN                     E5 10 chk
~ 10 # RAX IN                     I64_NOT_SUPPORTED$ !error
~ 10 # BL IN                      ACCU_OPERAND_REQUIRED$ !error
~ DX AL IN                        EC chk
~ DX AX IN                        66 ED chk
~ DX EAX IN                       ED chk
~ DX RAX IN                       I64_NOT_SUPPORTED$ !error
~ DX CL IN                        ACCU_OPERAND_REQUIRED$ !error
~ CX AL IN                        IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 1 # INC                         INVALID_OPERAND_TYPE$ !error
~ AL INC                          FE C0 chk
~ BX INC                          66 43 chk
~ ECX INC                         41 chk
~ RDX INC                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] INC            FE 00 chk
~ WORD PTR 0 [EBX] INC            66 FF 03 chk
~ DWORD PTR 0 [ECX] INC           FF 01 chk
~ QWORD PTR 0 [EDX] INC           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] INC           INVALID_OPERAND_SIZE$ !error
~ BYTE PTR INS                    6C chk
~ WORD PTR INS                    66 6D chk
~ DWORD PTR INS                   6D chk
~ QWORD PTR INS                   INVALID_OPERAND_SIZE$ !error
~ 1 u# INT                        CD 01 chk
~ 3 u# INT                        CC chk
~ FF u# INT                       CD FF chk
~ 1000 u# INT                     IMMEDIATE8_OPERAND_EXPECTED$ !error
~ EAX INT                         IMMEDIATE8_OPERAND_EXPECTED$ !error
~ IRET                            CF chk
~ HERE 2+ # 0= ?JMP               74 00 chk
~ HERE 2+ # ≥ ?JMP                7D 00 chk
~ HERE 2+ # U< ?JMP               72 00 chk
~ HERE 100 - # U< ?JMP            TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ HERE 100 + # U< ?JMP            TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ HERE 10 + # JMP                 EB 0E chk
~ HERE 1000 + # JMP               E9 FB 0F 00 00 chk
~ 0 [EBX] [EBX] *8 JMP            FF 24 DB chk
~ 0 [] JMP                        FF 25 00 00 00 00 chk
~ EBX JMP                         FF E3 chk
~ AX BX LAR                       66 0F 02 D8 chk
~ BX EAX LAR                      0F 02 C3 chk
~ CX RDX LAR                      I64_NOT_SUPPORTED$ !error
~ ECX ESI LAR                     R/M_16_EXPECTED$ !error
~ AX DL LAR                       REGISTER_16+_EXPECTED$ !error
~ AL BX LAR                       R/M_16_EXPECTED$ !error
~ WORD PTR 0 [ESI] EAX LAR        0F 02 06 chk
~ DWORD PTR 0 [ESI] EAX LAR       R/M_16_EXPECTED$ !error
~ 0 [EBX] SI LDS                  66 C5 33 chk
~ 0 [EBX] ESI LDS                 C5 33 chk
~ 0 [EBX] RSI LDS                 I64_NOT_SUPPORTED$ !error
~ EAX ESI LDS                     ADDRESS_OPERAND_EXPECTED$ !error
~ EAX 0 [EBX] LDS                 REGISTER_16+_EXPECTED$ !error
~ 0 [EBX] SI LES                  66 C4 33 chk
~ 0 [EBX] ESI LES                 C4 33 chk
~ 0 [EBX] RSI LES                 I64_NOT_SUPPORTED$ !error
~ EAX ESI LES                     ADDRESS_OPERAND_EXPECTED$ !error
~ EAX 0 [EBX] LES                 REGISTER_16+_EXPECTED$ !error
~ 0 [EBX] SI LFS                  66 0F B4 33 chk
~ 0 [EBX] ESI LFS                 0F B4 33 chk
~ 0 [EBX] RSI LFS                 I64_NOT_SUPPORTED$ !error
~ EAX ESI LFS                     ADDRESS_OPERAND_EXPECTED$ !error
~ EAX 0 [EBX] LFS                 REGISTER_16+_EXPECTED$ !error
~ 0 [EBX] SI LGS                  66 0F B5 33 chk
~ 0 [EBX] ESI LGS                 0F B5 33 chk
~ 0 [EBX] SI LSS                  66 0F B2 33 chk
~ 0 [EBX] ESI LSS                 0F B2 33 chk
~ 5 [EBX] [ECX] *8 SI LEA         66 8D 74 CB 05 chk
~ 0 [EBP] ESI LEA                 8D 75 00 chk
~ EAX ESI LEA                     ADDRESS_OPERAND_EXPECTED$ !error
~ EAX 0 [EBX] LEA                 REGISTER_16+_EXPECTED$ !error
~ LEAVE                           C9 chk
~ LFENCE                          0F AE 28 chk
~ 0 [ESI] LGDT                    0F 01 16 chk
~ EAX LGDT                        ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [ESI] LIDT                    0F 01 1E chk
~ MM1 LIDT                        ADDRESS_OPERAND_EXPECTED$ !error
~ AX LLDT                         0F 00 D0 chk
~ WORD PTR 0 [ESI] LLDT           0F 00 16 chk
~ 0 [ESI] LLDT                    R/M_16_EXPECTED$ !error
~ 1 # LLDT                        R/M_16_EXPECTED$ !error
~ AX LMSW                         0F 01 F0 chk
~ WORD PTR 0 [ESI] LMSW           0F 01 36 chk
~ LOCK                            F0 chk
~ BYTE PTR LODS                   AC chk
~ WORD PTR LODS                   66 AD chk
~ DWORD PTR LODS                  AD chk
~ QWORD PTR LODS                  INVALID_OPERAND_SIZE$ !error
~ HERE # LOOP                     E2 FE chk
~ EAX LOOP                        IMMEDIATE_OPERAND_EXPECTED$ !error
~ HERE # 0= ?LOOP                 E1 FE chk
~ HERE # = ?LOOP                  E1 FE chk
~ 1 # EAX ?LOOP                   CONDITION_OPERAND_EXPECTED$ !error
~ HERE # ≠ ?LOOP                  E0 FE chk
~ HERE # < ?LOOP                  EQ_OR_NEQ_REQUIRED$ !error
~ MM0 MM1 MASKMOVQ                0F F7 C8 chk
~ MM2 0 [ESI] MASKMOVQ            MMX_REGISTER_EXPECTED$ !error
~ 0 [ESI] MM2 MASKMOVQ            MMX_REGISTER_EXPECTED$ !error
~ MFENCE                          0F AE 30 chk
~ MONITOR                         0F 01 C8 chk
~ 0 [] AL MOV                     A0 00 00 00 00 chk
~ 0 [] AX MOV                     66 A1 00 00 00 00 chk
~ 0 [] EAX MOV                    A1 00 00 00 00 chk
~ 0 [] RAX MOV                    I64_NOT_SUPPORTED$ !error
~ 0 [] XMM1 MOV                   XMM_NOT_SUPPORTED$ !error
~ 0 [] BL MOV                     8A 1D 00 00 00 00 chk
~ AL 0 [] MOV                     A2 00 00 00 00 chk
~ AX 0 [] MOV                     66 A3 00 00 00 00 chk
~ EAX 0 [] MOV                    A3 00 00 00 00 chk
~ RAX 0 [] MOV                    I64_NOT_SUPPORTED$ !error
~ XMM1 0 [] MOV                   XMM_NOT_SUPPORTED$ !error
~ BL 0 [] MOV                     88 1D 00 00 00 00 chk
~ WORD PTR 0 [] ES MOV            66 8E 05 00 00 00 00 chk
~ AX DS MOV                       66 8E D8 chk
~ DWORD PTR 0 [EBX] [ECX] *2 DS MOV  8E 1C 4B chk
~ DX CS MOV                       INVALID_OPERAND_COMBINATION$ !error
~ WORD PTR 0 [ESP] [EDX] *4 CS MOV   INVALID_OPERAND_COMBINATION$ !error
~ CX SS MOV                       66 8E D1 chk
~ QWORD PTR 0 [EBP] [EAX] *8 SS MOV  INVALID_OPERAND_SIZE$ !error
~ RDX FS MOV                      I64_NOT_SUPPORTED$ !error
~ WORD PTR 0 [] FS MOV            66 8E 25 00 00 00 00 chk
~ EAX GS MOV                      8E E8 chk
~ WORD PTR -12 [BX+SI] GS MOV     66 67 8E 68 EE chk
~ AL ES MOV                       R/M_16+_EXPECTED$ !error
~ ES AX MOV                       66 8C C0 chk
~ ES WORD PTR 0 [] MOV            66 8C 05 00 00 00 00 chk
~ DS SI MOV                       66 8C DE chk
~ DS DWORD PTR 0 [EBX] [ECX] *2 MOV  8C 1C 4B chk
~ CS MM0 MOV                      R/M_16+_EXPECTED$ !error
~ CS WORD PTR 0 [ESP] [EDX] *4 MOV   66 8C 0C 94 chk
~ SS CX MOV                       66 8C D1 chk
~ SS QWORD PTR 0 [EBP] [EAX] *8 MOV  INVALID_OPERAND_SIZE$ !error
~ FS RDX MOV                      I64_NOT_SUPPORTED$ !error
~ FS QWORD PTR 0 [] MOV           INVALID_OPERAND_SIZE$ !error
~ GS EAX MOV                      8C E8 chk
~ GS DWORD PTR -12 [BX+SI] MOV    67 8C 68 EE chk
~ GS AL MOV                       R/M_16+_EXPECTED$ !error
~ EDX CR0 MOV                     0F 22 C2 chk
~ DWORD PTR 0 [ESI] CR4 MOV       0F 22 26 chk
~ DX CR0 MOV                      R/M_32+_EXPECTED$ !error
~ RCX CR1 MOV                     I64_NOT_SUPPORTED$ !error
~ CL CR1 MOV                      R/M_32+_EXPECTED$ !error
~ EBX CR8 MOV                     I64_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [ESI] CR8 MOV       I64_NOT_SUPPORTED$ !error
~ CR0 EDX MOV                     0F 20 C2 chk
~ CR0 DWORD PTR 0 [ESI] MOV       0F 20 06 chk
~ CR1 RCX MOV                     I64_NOT_SUPPORTED$ !error
~ CR8 EBX MOV                     I64_NOT_SUPPORTED$ !error
~ CR8 DWORD PTR 0 [ESI] MOV       I64_NOT_SUPPORTED$ !error
~ EDX DR0 MOV                     0F 23 C2 chk
~ DWORD PTR 0 [ESI] DR0 MOV       0F 23 06 chk
~ WORD PTR 0 [ESI] DR0 MOV        R/M_32+_EXPECTED$ !error
~ RCX DR1 MOV                     I64_NOT_SUPPORTED$ !error
~ QWORD PTR 0 CS: [EDI] DR1 MOV   INVALID_OPERAND_SIZE$ !error
~ EBX DR8 MOV                     I64_NOT_SUPPORTED$ !error
~ DR0 EDX MOV                     0F 21 C2 chk
~ DR1 RCX MOV                     I64_NOT_SUPPORTED$ !error
~ DR8 EBX MOV                     I64_NOT_SUPPORTED$ !error
~ 0 [ESI] [ECX] BL MOV            8A 1C 0E chk
~ 0 [ESI] [ECX] *2 BX MOV         66 8B 1C 4E chk
~ 0 [ESI] [ECX] *4 EBX MOV        8B 1C 8E chk
~ 0 [ESI] [ECX] *8 RBX MOV        I64_NOT_SUPPORTED$ !error
~ BL 0 [ESI] [ECX] MOV            88 1C 0E chk
~ BX 0 [ESI] [ECX] *2 MOV         66 89 1C 4E chk
~ EBX 0 [ESI] [ECX] *4 MOV        89 1C 8E chk
~ RBX 0 [ESI] [ECX] *8 MOV        I64_NOT_SUPPORTED$ !error
~ AL BL MOV                       8A D8 chk
~ AX BX MOV                       66 8B D8 chk
~ EBX EAX MOV                     8B C3 chk
~ RSI R08 MOV                     I64_NOT_SUPPORTED$ !error
~ AL EDX MOV                      OPERAND_SIZE_MISMATCH$ !error
~ XMM0 EAX MOV                    XMM_NOT_SUPPORTED$ !error
~ EAX XMM0 MOV                    XMM_NOT_SUPPORTED$ !error
~ 0 [ESI] MM0 MOV                 INVALID_OPERAND_COMBINATION$ !error
~ MM1 0 [EDI] MOV                 INVALID_OPERAND_COMBINATION$ !error
~ AX AX MOVBE                     ADDRESS_OPERAND_EXPECTED$ !error
~ WORD PTR 0 [ESI] AX MOVBE       66 0F 38 F0 06 chk
~ DWORD PTR 0 [EBX] EAX MOVBE     0F 38 F0 03 chk
~ QWORD PTR 0 [EAX] RCX MOVBE     I64_NOT_SUPPORTED$ !error
~ WORD PTR 0 [ESI] AX MOVBE       66 0F 38 F0 06 chk
~ DWORD PTR 0 [EBX] EAX MOVBE     0F 38 F0 03 chk
~ QWORD PTR 0 [EAX] RCX MOVBE     I64_NOT_SUPPORTED$ !error
~ 10 # OWORD PTR 0 [ESI] MOVBE    REGISTER_16+_EXPECTED$ !error
~ OWORD PTR 0 [ESI] XMM0 MOVBE    XMM_NOT_SUPPORTED$ !error
~ EAX MM0 MOVD                    0F 6E C0 chk
~ DWORD PTR 0 [ESI] MM0 MOVD      0F 6E 06 chk
~ EAX XMM0 MOVD                   XMM_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [ESI] XMM0 MOVD     XMM_NOT_SUPPORTED$ !error
~ MM0 EAX MOVD                    0F 7E C0 chk
~ MM0 DWORD PTR 0 [ESI] MOVD      0F 7E 06 chk
~ XMM0 EAX MOVD                   XMM_NOT_SUPPORTED$ !error
~ XMM0 DWORD PTR 0 [ESI] MOVD     XMM_NOT_SUPPORTED$ !error
~ MM0 QWORD PTR 0 [ESI] MOVD      R/M_32_EXPECTED$ !error
~ MM0 AX MOVD                     R/M_32_EXPECTED$ !error
~ QWORD PTR 0 [ESI] MM0 MOVQ      INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [ESI] XMM0 MOVQ     XMM_NOT_SUPPORTED$ !error
~ EBX DWORD PTR 0 [ESI] MOVNTI    0F C3 1E chk
~ DWORD PTR 0 [ESI] EBX MOVNTI    REGISTER_32+_EXPECTED$ !error
~ BX 0 [ESI] MOVNTI               REGISTER_32+_EXPECTED$ !error
~ RAX 0 [ESP] MOVNTI              I64_NOT_SUPPORTED$ !error
~ BYTE PTR MOVS                   A4 chk
~ WORD PTR MOVS                   66 A5 chk
~ DWORD PTR MOVS                  A5 chk
~ QWORD PTR MOVS                  INVALID_OPERAND_SIZE$ !error
~ AL AL MOVSX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVSX                     66 0F BE C3 chk
~ BYTE PTR 0 [ESI] DX MOVSX       66 0F BE 16 chk
~ BL EBX MOVSX                    0F BE DB chk
~ BYTE PTR 0 [ESI] ECX MOVSX      0F BE 0E chk
~ AL RSI MOVSX                    I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [ESI] RBP MOVSX      I64_NOT_SUPPORTED$ !error
~ AL WORD PTR 0 [EDI] MOVSX       REGISTER_16_EXPECTED$ !error
~ BX EDI MOVSX                    0F BF FB chk
~ WORD PTR 0 [ESI] ESP MOVSX      0F BF 26 chk
~ R12W R13 MOVSX                  I64_NOT_SUPPORTED$ !error
~ EDI RAX MOVSXD                  I64_NOT_SUPPORTED$ !error
~ DWORD PTR -7 [ESI] [ECX] *4 R15 MOVSXD   I64_NOT_SUPPORTED$ !error
~ AH R13 MOVSX                    I64_NOT_SUPPORTED$ !error
~ AL AL MOVZX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVZX                     66 0F B6 C3 chk
~ BYTE PTR 0 [ESI] DX MOVZX       66 0F B6 16 chk
~ BL EBX MOVZX                    0F B6 DB chk
~ BYTE PTR 0 [ESI] ECX MOVZX      0F B6 0E chk
~ AL RSI MOVZX                    I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [ESI] RBP MOVZX      I64_NOT_SUPPORTED$ !error
~ AL WORD PTR 0 [EDI] MOVZX       REGISTER_16_EXPECTED$ !error
~ BX EDI MOVZX                    0F B7 FB chk
~ WORD PTR 0 [ESI] ESP MOVZX      0F B7 26 chk
~ R12W R13 MOVZX                  I64_NOT_SUPPORTED$ !error
~ AH R13 MOVZX                    I64_NOT_SUPPORTED$ !error
~ 1 # MUL                         INVALID_OPERAND_TYPE$ !error
~ AL MUL                          F6 E0 chk
~ BX MUL                          66 F7 E3 chk
~ ECX MUL                         F7 E1 chk
~ RDX MUL                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] MUL            F6 20 chk
~ WORD PTR 0 [EBX] MUL            66 F7 23 chk
~ DWORD PTR 0 [ECX] MUL           F7 21 chk
~ QWORD PTR 0 [EDX] MUL           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] MUL           INVALID_OPERAND_SIZE$ !error
~ MWAIT                           0F 01 C9 chk
~ 1 # NEG                         INVALID_OPERAND_TYPE$ !error
~ AL NEG                          F6 D8 chk
~ BX NEG                          66 F7 DB chk
~ ECX NEG                         F7 D9 chk
~ RDX NEG                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] NEG            F6 18 chk
~ WORD PTR 0 [EBX] NEG            66 F7 1B chk
~ DWORD PTR 0 [ECX] NEG           F7 19 chk
~ QWORD PTR 0 [EDX] NEG           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] NEG           INVALID_OPERAND_SIZE$ !error
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
~ RDX NOT                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [EAX] NOT            F6 10 chk
~ WORD PTR 0 [EBX] NOT            66 F7 13 chk
~ DWORD PTR 0 [ECX] NOT           F7 11 chk
~ QWORD PTR 0 [EDX] NOT           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [ESI] NOT           INVALID_OPERAND_SIZE$ !error
~ AL AH OR                        08 C4 chk
~ DX 0 [RSI] OR                   I64_NOT_SUPPORTED$ !error
~ AL BPL OR                       I64_NOT_SUPPORTED$ !error
~ QWORD PTR -123 [BP+DI] RSI OR   I64_NOT_SUPPORTED$ !error
~ XMM7 XMM1 OR                    XMM_NOT_SUPPORTED$ !error
~ SP SP OR                        66 09 E4 chk
~ CR0 RAX OR                      I64_NOT_SUPPORTED$ !error
~ CS DS OR                        STANDARD_REGISTER_EXPECTED$ !error
~ AL 10 # OUT                     E6 10 chk
~ AL 1000 # OUT                   IMMEDIATE8_OPERAND_EXPECTED$ !error
~ AX 10 # OUT                     66 E7 10 chk
~ EAX 10 # OUT                    E7 10 chk
~ RAX 10 # OUT                    I64_NOT_SUPPORTED$ !error
~ BL 10 # OUT                     ACCU_OPERAND_REQUIRED$ !error
~ AL DX OUT                       EE chk
~ AX DX OUT                       66 EF chk
~ EAX DX OUT                      EF chk
~ RAX DX OUT                      I64_NOT_SUPPORTED$ !error
~ CL DX OUT                       ACCU_OPERAND_REQUIRED$ !error
~ AL CX OUT                       IMMEDIATE8_OPERAND_EXPECTED$ !error
~ BYTE PTR OUTS                   6E chk
~ WORD PTR OUTS                   66 6F chk
~ DWORD PTR OUTS                  6F chk
~ QWORD PTR OUTS                  INVALID_OPERAND_SIZE$ !error
~ MM1 MM2 PABSB                   0F 38 1C D1 chk
~ QWORD PTR 0 [ESI] MM3 PABSB     0F 38 1C 1E chk
~ XMM1 XMM2 PABSB                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [EBX] XMM3 PABSB    XMM_NOT_SUPPORTED$ !error
~ ES POP                          07 chk
~ CS POP                          CANNOT_POP_CS$ !error
~ DS POP                          1F chk
~ SS POP                          17 chk
~ FS POP                          0F A1 chk
~ GS POP                          0F A9 chk
~ BX POP                          66 5B chk
~ ECX POP                         59 chk
~ RDX POP                         I64_NOT_SUPPORTED$ !error
~ 0 [ESI] POP                     R/M_16+_EXPECTED$ !error
~ BYTE PTR -10 [EDI] POP          R/M_16+_EXPECTED$ !error
~ WORD PTR 11 [EDI] POP           66 8F 47 11 chk
~ DWORD PTR 12 [EDI] POP          8F 47 12 chk
~ QWORD PTR 13 [EDI] POP          INVALID_OPERAND_SIZE$ !error
~ OWORD PTR -14 [EDI] POP         INVALID_OPERAND_SIZE$ !error
~ MM0 POP                         INVALID_OPERAND_TYPE$ !error
~ XMM1 POP                        XMM_NOT_SUPPORTED$ !error
~ CR2 POP                         INVALID_OPERAND_TYPE$ !error
~ DR3 POP                         INVALID_OPERAND_TYPE$ !error
~ 5 # POP                         CANNOT_POP_CONSTANT$ !error
~ POPA                            61 chk
~ WORD PTR POPA                   66 61 chk
~ DWORD PTR POPA                  61 chk
~ QWORD PTR POPA                  INVALID_OPERAND_SIZE$ !error
~ BX CX POPCNT                    66 F3 0F B8 CB chk
~ WORD PTR 88 [EBP] AX POPCNT     66 F3 0F B8 85 88 00 00 00 chk
~ EDX BX POPCNT                   OPERAND_SIZE_MISMATCH$ !error
~ EBX ECX POPCNT                  F3 0F B8 CB chk
~ DWORD PTR 0 [EDX] EAX POPCNT    F3 0F B8 02 chk
~ RAX RAX POPCNT                  I64_NOT_SUPPORTED$ !error
~ QWORD PTR 22 [ESI] RDX POPCNT   I64_NOT_SUPPORTED$ !error
~ EAX DWORD PTR 44 [EDI] POPCNT   REGISTER_16+_EXPECTED$ !error
~ 1 [EAX] EAX POPCNT              F3 0F B8 40 01 chk
~ OWORD PTR 1 [EAX] EAX POPCNT    OPERAND_SIZE_MISMATCH$ !error
~ WORD PTR POPF                   66 9D chk
~ DWORD PTR POPF                  9D chk
~ QWORD PTR POPF                  INVALID_OPERAND_SIZE$ !error
~ POPF                            9D chk
~ ES PUSH                         06 chk
~ CS PUSH                         0E chk
~ DS PUSH                         1E chk
~ SS PUSH                         16 chk
~ FS PUSH                         0F A0 chk
~ GS PUSH                         0F A8 chk
~ BX PUSH                         66 53 chk
~ ECX PUSH                        51 chk
~ RDX PUSH                        I64_NOT_SUPPORTED$ !error
~ 0 [ESI] PUSH                    R/M_16+_EXPECTED$ !error
~ BYTE PTR -10 [EDI] PUSH         R/M_16+_EXPECTED$ !error
~ WORD PTR 11 [EDI] PUSH          66 FF 77 11 chk
~ DWORD PTR 12 [EDI] PUSH         FF 77 12 chk
~ QWORD PTR 13 [EDI] PUSH         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR -14 [EDI] PUSH        INVALID_OPERAND_SIZE$ !error
~ MM0 PUSH                        INVALID_OPERAND_TYPE$ !error
~ XMM1 PUSH                       XMM_NOT_SUPPORTED$ !error
~ CR2 PUSH                        INVALID_OPERAND_TYPE$ !error
~ DR3 PUSH                        INVALID_OPERAND_TYPE$ !error
~ 5 # PUSH                        6A 05 chk
~ 100 # PUSH                      66 68 00 01 chk
~ 1234567 # PUSH                  68 67 45 23 01 chk
~ CL AL RCL                       D2 D0 chk
~ CL BYTE PTR 1 [ESI] RCL         D2 56 01 chk
~ 1 # AL RCL                      D0 D0 chk
~ 1 # BYTE PTR 2 [ESI] RCL        D0 56 02 chk
~ 5 # AL RCL                      C0 D0 05 chk
~ 5 # BYTE PTR 3 [ESI] RCL        C0 56 03 05 chk
~ CL BX RCL                       66 D3 D3 chk
~ CL WORD PTR 4 [ESI] RCL         66 D3 56 04 chk
~ 1 # BX RCL                      66 D1 D3 chk
~ 1 # WORD PTR 5 [ESI] RCL        66 D1 56 05 chk
~ 5 # BX RCL                      66 C1 D3 05 chk
~ 5 # WORD PTR 6 [ESI] RCL        66 C1 56 06 05 chk
~ CL ECX RCL                      D3 D1 chk
~ CL DWORD PTR 7 [ESI] RCL        D3 56 07 chk
~ 1 # ECX RCL                     D1 D1 chk
~ 1 # DWORD PTR 8 [ESI] RCL       D1 56 08 chk
~ 5 # ECX RCL                     C1 D1 05 chk
~ 5 # DWORD PTR 9 [ESI] RCL       C1 56 09 05 chk
~ CL RDX RCL                      I64_NOT_SUPPORTED$ !error
~ CL QWORD PTR 0 [ESI] RCL        INVALID_OPERAND_SIZE$ !error
~ 1 # RDX RCL                     I64_NOT_SUPPORTED$ !error
~ 1 # QWORD PTR 1 [ESI] RCL       INVALID_OPERAND_SIZE$ !error
~ 5 # RDX RCL                     I64_NOT_SUPPORTED$ !error
~ 5 # QWORD PTR 2 [ESI] RCL       INVALID_OPERAND_SIZE$ !error
~ AL BL RCL                       INVALID_OPERAND_COMBINATION$ !error
~ CL CR0 RCL                      STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR 0 [ESI] EDX RCL        INVALID_OPERAND_COMBINATION$ !error
~ CL AL RCR                       D2 D8 chk
~ CL BYTE PTR 1 [ESI] RCR         D2 5E 01 chk
~ 1 # AL RCR                      D0 D8 chk
~ 1 # BYTE PTR 2 [ESI] RCR        D0 5E 02 chk
~ 5 # AL RCR                      C0 D8 05 chk
~ 5 # BYTE PTR 3 [ESI] RCR        C0 5E 03 05 chk
~ CL BX RCR                       66 D3 DB chk
~ CL WORD PTR 4 [ESI] RCR         66 D3 5E 04 chk
~ CL AL ROL                       D2 C0 chk
~ CL BYTE PTR 1 [ESI] ROL         D2 46 01 chk
~ 1 # AL ROL                      D0 C0 chk
~ 1 # BYTE PTR 2 [ESI] ROL        D0 46 02 chk
~ 5 # AL ROL                      C0 C0 05 chk
~ 5 # BYTE PTR 3 [ESI] ROL        C0 46 03 05 chk
~ CL BX ROL                       66 D3 C3 chk
~ CL WORD PTR 4 [ESI] ROL         66 D3 46 04 chk
~ CL AL ROR                       D2 C8 chk
~ CL BYTE PTR 1 [ESI] ROR         D2 4E 01 chk
~ 1 # AL ROR                      D0 C8 chk
~ 1 # BYTE PTR 2 [ESI] ROR        D0 4E 02 chk
~ 5 # AL ROR                      C0 C8 05 chk
~ 5 # BYTE PTR 3 [ESI] ROR        C0 4E 03 05 chk
~ CL BX ROR                       66 D3 CB chk
~ CL WORD PTR 4 [ESI] ROR         66 D3 4E 04 chk
~ CL AL SAL                       D2 E0 chk
~ CL BYTE PTR 1 [ESI] SAL         D2 66 01 chk
~ 1 # AL SAL                      D0 E0 chk
~ 1 # BYTE PTR 2 [ESI] SAL        D0 66 02 chk
~ 5 # AL SAL                      C0 E0 05 chk
~ 5 # BYTE PTR 3 [ESI] SAL        C0 66 03 05 chk
~ CL BX SAL                       66 D3 E3 chk
~ CL WORD PTR 4 [ESI] SAL         66 D3 66 04 chk
~ CL AL SAR                       D2 F8 chk
~ CL BYTE PTR 1 [ESI] SAR         D2 7E 01 chk
~ 1 # AL SAR                      D0 F8 chk
~ 1 # BYTE PTR 2 [ESI] SAR        D0 7E 02 chk
~ 5 # AL SAR                      C0 F8 05 chk
~ 5 # BYTE PTR 3 [ESI] SAR        C0 7E 03 05 chk
~ CL BX SAR                       66 D3 FB chk
~ CL WORD PTR 4 [ESI] SAR         66 D3 7E 04 chk
~ CL AL SHL                       D2 E0 chk
~ CL BYTE PTR 1 [ESI] SHL         D2 66 01 chk
~ 1 # AL SHL                      D0 E0 chk
~ 1 # BYTE PTR 2 [ESI] SHL        D0 66 02 chk
~ 5 # AL SHL                      C0 E0 05 chk
~ 5 # BYTE PTR 3 [ESI] SHL        C0 66 03 05 chk
~ CL BX SHL                       66 D3 E3 chk
~ CL WORD PTR 4 [ESI] SHL         66 D3 66 04 chk
~ CL AL SHR                       D2 E8 chk
~ CL BYTE PTR 1 [ESI] SHR         D2 6E 01 chk
~ 1 # AL SHR                      D0 E8 chk
~ 1 # BYTE PTR 2 [ESI] SHR        D0 6E 02 chk
~ 5 # AL SHR                      C0 E8 05 chk
~ 5 # BYTE PTR 3 [ESI] SHR        C0 6E 03 05 chk
~ CL BX SHR                       66 D3 EB chk
~ CL WORD PTR 4 [ESI] SHR         66 D3 6E 04 chk
~ RDMSR                           0F 32 chk
~ RDPMC                           0F 33 chk
~ RDTSC                           0F 31 chk
~ RDTSCP                          0F 01 F9 chk
~ REP BYTE PTR MOVS               F3 A4 chk
~ REPE WORD PTR SCAS              F3 66 AF chk
~ REPZ DWORD PTR CMPS             F3 A7 chk
~ REPNE QWORD PTR SCAS            INVALID_OPERAND_SIZE$ !error
~ REPNZ BYTE PTR CMPS             F2 A6 chk
~ RET                             C3 chk
~ FAR RET                         CB chk
~ 2000 # RET                      C2 00 20 chk
~ -1000 # FAR RET                 CA 00 F0 chk
~ RSM                             0F AA chk
~ SAHF                            9E chk
~ AL AH SBB                       18 C4 chk
~ DX 0 [ESI] SBB                  66 19 16 chk
~ AL BPL SBB                      I64_NOT_SUPPORTED$ !error
~ DWORD PTR -123 [BP+DI] ESI SBB  67 1B B3 DD FE chk
~ XMM7 XMM1 SBB                   XMM_NOT_SUPPORTED$ !error
~ SP SP SBB                       66 19 E4 chk
~ CR0 AX SBB                      OPERAND_SIZE_MISMATCH$ !error
~ CS DS SBB                       STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR SCAS                   AE chk
~ WORD PTR SCAS                   66 AF chk
~ DWORD PTR SCAS                  AF chk
~ QWORD PTR SCAS                  INVALID_OPERAND_SIZE$ !error
~ AL 0= ?SET                      0F 94 C0 chk
~ BYTE PTR 0 [ESI] U< ?SET        0F 92 06 chk
~ EDX 0< ?SET                     R/M_8_EXPECTED$ !error
~ DWORD PTR 0 [ESI] PY ?SET       R/M_8_EXPECTED$ !error
~ SFENCE                          0F AE 38 chk
~ 33 # AL BL SHLD                 REGISTER_16+_EXPECTED$ !error
~ 32 # WORD PTR 0 [ESI] CX SHLD   REGISTER_16+_EXPECTED$ !error
~ 31 # DX WORD PTR 0 [EDI] SHLD   66 0F A4 17 31 chk
~ 30 # AX BX SHLD                 66 0F A4 C3 30 chk
~ 29 # EDX ECX SHLD               0F A4 D1 29 chk
~ 28 # ESI 0 [EDI] SHLD           0F A4 37 28 chk
~ 27 # ESI DWORD PTR 0 [EDI] SHLD 0F A4 37 27 chk
~ 26 # RSI RDI SHLD               I64_NOT_SUPPORTED$ !error
~ 25 # RSI QWORD PTR 0 [EDI] SHLD I64_NOT_SUPPORTED$ !error
~ CL AL BL SHLD                   REGISTER_16+_EXPECTED$ !error
~ CL WORD PTR 0 [ESI] CX SHLD     REGISTER_16+_EXPECTED$ !error
~ CL DX WORD PTR 0 [EDI] SHLD     66 0F A5 17 chk
~ CL AX BX SHLD                   66 0F A5 C3 chk
~ CL EDX ECX SHLD                 0F A5 D1 chk
~ CL ESI 0 [EDI] SHLD             0F A5 37 chk
~ CL ESI DWORD PTR 0 [EDI] SHLD   0F A5 37 chk
~ CL RSI RDI SHLD                 I64_NOT_SUPPORTED$ !error
~ CL RSI QWORD PTR 0 [EDI] SHLD   I64_NOT_SUPPORTED$ !error
~ ES: WORD PTR 20 [ESP] SIDT      26 66 0F 01 4C 24 20 chk
~ ES: 20 [ESP] SIDT               26 0F 01 4C 24 20 chk
~ AX SLDT                         0F 00 C0 chk
~ WORD PTR 20 [ESP] SLDT          0F 00 44 24 20 chk
~ AX SMSW                         0F 01 E0 chk
~ WORD PTR 20 [ESP] SMSW          0F 01 64 24 20 chk
~ STC                             F9 chk
~ STD                             FD chk
~ STI                             FB chk
~ EAX STMXCSR                     ADDRESS_32_OPERAND_EXPECTED$ !error
~ DWORD PTR 0 [ESI] STMXCSR       0F AE 1E chk
~ BYTE PTR STOS                   AA chk
~ WORD PTR STOS                   66 AB chk
~ DWORD PTR STOS                  AB chk
~ QWORD PTR STOS                  INVALID_OPERAND_SIZE$ !error
~ AX STR                          0F 00 C8 chk
~ WORD PTR 0 [EDI] STR            0F 00 0F chk
~ AL AH SUB                       28 C4 chk
~ DX 0 [ESI] SUB                  66 29 16 chk
~ AL BPL SUB                      I64_NOT_SUPPORTED$ !error
~ DWORD PTR -123 [BP+DI] ESI SUB  67 2B B3 DD FE chk
~ XMM7 XMM1 SUB                   XMM_NOT_SUPPORTED$ !error
~ SP SP SUB                       66 29 E4 chk
~ CR0 AX SUB                      OPERAND_SIZE_MISMATCH$ !error
~ CS DS SUB                       STANDARD_REGISTER_EXPECTED$ !error
~ SWAPGS                          0F 01 38 chk
~ SYSCALL                         0F 05 chk
~ SYSENTER                        0F 34 chk
~ SYSEXIT                         0F 35 chk
~ QWORD PTR SYSEXIT               INVALID_OPERAND_SIZE$ !error
~ SYSRET                          0F 07 chk
~ QWORD PTR SYSRET                INVALID_OPERAND_SIZE$ !error
~ 10 # BL TEST                    F6 C3 10 chk
~ 10 # BH TEST                    F6 C7 10 chk
~ 10 # BX TEST                    66 F7 C3 10 00 chk
~ 1000 # ES TEST                  STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX TEST                   F7 C3 10 00 00 00 chk
~ 10 # RBX TEST                   I64_NOT_SUPPORTED$ !error
~ 100 # RBX TEST                  I64_NOT_SUPPORTED$ !error
~ 10 # 0 [ESP] TEST               OPERAND_SIZE_UNKNOWN$ !error
~ 10 # BYTE PTR 0 [EBX] TEST      F6 03 10 chk
~ 1000 # WORD PTR -1000 [ESP] TEST   66 F7 84 24 00 F0 FF FF 00 10 chk
~ 10 # QWORD PTR 0 [ESI] TEST     INVALID_OPERAND_SIZE$ !error
~ 10 # AL TEST                    A8 10 chk
~ 10 # AX TEST                    66 A9 10 00 chk
~ 10 # EAX TEST                   A9 10 00 00 00 chk
~ 10 # RAX TEST                   I64_NOT_SUPPORTED$ !error
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
~ RBX RSI TEST                    I64_NOT_SUPPORTED$ !error
~ ST(0) ST1 TEST                  STANDARD_REGISTER_EXPECTED$ !error
~ CR0 DR7 TEST                    STANDARD_REGISTER_EXPECTED$ !error
~ AL 0 [ESI] [ECX] *1 TEST        84 04 0E chk
~ 0 [ESI] [EBX] *1 AL TEST        INVALID_OPERAND_COMBINATION$ !error
~ RAX 0 [EBP] TEST                I64_NOT_SUPPORTED$ !error
~ R10 0 [EBP] [ECX] *8 TEST       I64_NOT_SUPPORTED$ !error
~ RAX 1000 [] TEST                I64_NOT_SUPPORTED$ !error
~ BH SIL TEST                     I64_NOT_SUPPORTED$ !error
~ SPL AH TEST                     I64_NOT_SUPPORTED$ !error
~ AH R15L TEST                    I64_NOT_SUPPORTED$ !error
~ R10L CH TEST                    I64_NOT_SUPPORTED$ !error
~ AL 0 [ECX] [ESP] *2 TEST        INVALID_ADDRESS_INDEX$ !error
~ BX 0 [ECX] [ESP] *2 TEST        INVALID_ADDRESS_INDEX$ !error
~ DX -3000 [EDI] [EBP] *2 TEST    66 85 94 6F 00 D0 FF FF chk
~ RAX 28000 [EDI] *8 TEST         I64_NOT_SUPPORTED$ !error
~ UD2                             0F 0B chk
~ AX VERR                         0F 00 E0 chk
~ WORD PTR 20 [EBX] VERR          0F 00 63 20 chk
~ AX VERW                         0F 00 E8 chk
~ WORD PTR 20 [EBX] VERW          0F 00 6B 20 chk
~ BL CL XADD                      0F C0 D9 chk
~ AL 0 [ESI] XADD                 0F C0 06 chk
~ 0 [ESI] AL XADD                 STANDARD_REGISTER_EXPECTED$ !error
~ BX CX XADD                      66 0F C1 D9 chk
~ AX 0 [ESI] XADD                 66 0F C1 06 chk
~ EBX ECX XADD                    0F C1 D9 chk
~ EAX 0 [ESI] XADD                0F C1 06 chk
~ RBX R13 XADD                    I64_NOT_SUPPORTED$ !error
~ RAX 0 [ESI] XADD                I64_NOT_SUPPORTED$ !error
~ ST(0) EAX XADD                  OPERAND_SIZE_MISMATCH$ !error
~ EBX CR0 XADD                    STANDARD_REGISTER_EXPECTED$ !error
~ AL BL XCHG                      86 C3 chk
~ BL AL XCHG                      86 C3 chk
~ AX BX XCHG                      66 93 chk
~ BX AX XCHG                      66 93 chk
~ EAX EBX XCHG                    93 chk
~ RAX RBX XCHG                    I64_NOT_SUPPORTED$ !error
~ AL 0 [ESI] XCHG                 86 06 chk
~ AX 0 [ESI] XCHG                 66 87 06 chk
~ EAX 0 [ESI] XCHG                87 06 chk
~ RAX 0 [ESI] XCHG                I64_NOT_SUPPORTED$ !error
~ 0 [ESI] BL XCHG                 86 1E chk
~ 0 [ESI] CX XCHG                 66 87 0E chk
~ 0 [EBP] ESP XCHG                87 65 00 chk
~ 0 [ESI] R13 XCHG                I64_NOT_SUPPORTED$ !error
~ XGETBV                          0F 01 D0 chk
~ XLAT                            D7 chk
~ QWORD PTR XLAT                  INVALID_OPERAND_SIZE$ !error
~ WORD PTR XLAT                   66 D7 chk
~ AL AH XOR                       30 C4 chk
~ DX 0 [ESI] XOR                  66 31 16 chk
~ AL BPL XOR                      I64_NOT_SUPPORTED$ !error
~ DWORD PTR -123 [BP+DI] ESI XOR  67 33 B3 DD FE chk
~ XMM7 XMM1 XOR                   XMM_NOT_SUPPORTED$ !error
~ SP SP XOR                       66 31 E4 chk
~ CR0 AX XOR                      OPERAND_SIZE_MISMATCH$ !error
~ CS DS XOR                       STANDARD_REGISTER_EXPECTED$ !error
~ 0 [ESI] XRSTOR                  0F AE 2E chk
~ 0 [ESI] XRSTOR64                48 0F AE 2E chk
~ 0 [EDI] XSAVE                   0F AE 27 chk
~ 0 [EDI] XSAVE64                 48 0F AE 27 chk
~ XSETBV                          0F 01 D1 chk

stackcheck
cr
bye
