16 dup dup constant _ADDRSIZE constant _OPSIZE constant _ARCH
0 constant _MMX  0 constant _XMM  0 constant _X87

require forcemu.4th
require A0-IA64.gf
also ForcemblerTools
also Forcembler

( Test operands )

test-mode  cr

decimal $089A0B0C  12 11 10 9 8 !op

EAX                     I32_NOT_SUPPORTED$ !error                                     ¶
DS                      03 #SEGMENT #WORD uni #REGISTER !op                           ¶
CL                      01 #REGULAR #BYTE uni #REGISTER !op                           ¶
DH                      06 #HI-BYTE #BYTE uni #REGISTER !op                           ¶
XMM7                    XMM_NOT_SUPPORTED$ !error                                     ¶
MM4                     MMX_NOT_SUPPORTED$ !error                                     ¶
CR8                     I64_NOT_SUPPORTED$ !error                                     ¶
DR2                     INVALID_TARGET_ARCHITECTURE$ !error                           ¶
R09                     I64_NOT_SUPPORTED$ !error                                     ¶
R13D                    I64_NOT_SUPPORTED$ !error                                     ¶
ST(3)                   X87_NOT_SUPPORTED$ !error                                     ¶

0 [EAX]                 I32_NOT_SUPPORTED$ !error                                     ¶
-1 [BP+SI]              02 #INDEXED 0 i16 #ADDRESS !op          -1 #BYTE !disp        ¶
100 []                  06 #DIRECT 0 i16 #ADDRESS !op           100 #WORD !disp       ¶

( Test Operations )

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
~ 10 # BX ADC                     83 D3 10 chk
~ 1000 # ES ADC                   STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX ADC                    I32_NOT_SUPPORTED$ !error
~ 10 # RBX ADC                    I64_NOT_SUPPORTED$ !error
~ 100 # RBX ADC                   I64_NOT_SUPPORTED$ !error
~ 10 # 0 [ESP] ADC                I32_NOT_SUPPORTED$ !error
~ 10 # 0 [RSP] ADC                I64_NOT_SUPPORTED$ !error
~ 10 # BYTE PTR 0 [EBX] ADC       I32_NOT_SUPPORTED$ !error
~ 1000 # WORD PTR -1000 [ESP] ADC I32_NOT_SUPPORTED$ !error
~ 10 # QWORD PTR 0 [ESI] ADC      I32_NOT_SUPPORTED$ !error
~ 10 # AL ADC                     14 10 chk
~ 10 # AX ADC                     15 10 00 chk
~ 10 # EAX ADC                    I32_NOT_SUPPORTED$ !error
~ 10 # RAX ADC                    I64_NOT_SUPPORTED$ !error
~ AL AH ADC                       10 C4 chk
~ AL AX ADC                       OPERAND_SIZE_MISMATCH$ !error
~ AX SI ADC                       11 C6 chk
~ AX ES ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ DS AX ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ AX ES ADC                       STANDARD_REGISTER_EXPECTED$ !error
~ 1 # CS ADC                      STANDARD_R/M_EXPECTED$ !error
~ 10 # CR0 ADC                    INVALID_TARGET_ARCHITECTURE$ !error
~ DR7 CR7 ADC                     INVALID_TARGET_ARCHITECTURE$ !error
~ 5 # ST0 ADC                     X87_NOT_SUPPORTED$ !error
~ EAX AL ADC                      I32_NOT_SUPPORTED$ !error
~ EBX ESI ADC                     I32_NOT_SUPPORTED$ !error
~ RBX RSI ADC                     I64_NOT_SUPPORTED$ !error
~ AL 0 [ESI] [ECX] *1 ADC         I32_NOT_SUPPORTED$ !error
~ 0 [ESI] [EBX] *1 AL ADC         I32_NOT_SUPPORTED$ !error
~ 0 [EBP] RAX ADC                 I32_NOT_SUPPORTED$ !error
~ 0 [EBP] [ECX] *8 R10 ADC        I32_NOT_SUPPORTED$ !error
~ 1000 [] AX ADC                  13 06 00 10 chk
~ 0 [ECX] [ESP] *2 AL ADC         I32_NOT_SUPPORTED$ !error
~ BX 0 [ECX] [ESP] *2 ADC         I32_NOT_SUPPORTED$ !error
~ DX -3000 [EDI] [EBP] *2 ADC     I32_NOT_SUPPORTED$ !error
~ 28000 [EDI] *8 EAX ADC          I32_NOT_SUPPORTED$ !error
~ EAX ESP ADD                     I32_NOT_SUPPORTED$ !error
~ -8 [ESP] EAX ADD                I32_NOT_SUPPORTED$ !error
~ 0 [BX] SI ADD                   03 37 chk
~ 0 [BP] SI ADD                   03 76 00 chk
~ -1 [BP] ESI ADD                 I32_NOT_SUPPORTED$ !error
~ 1000 [BX+SI] AL ADD             02 80 00 10 chk
~ 100000 [BX+SI] AL ADD           IMMEDIATE_TOO_BIG$ !error
~ CL 1000 [BX+SI] ADD             00 88 00 10 chk
~ DX 0 [BX+DI] ADD                01 11 chk
~ EAX EBX ADDPD                   I32_NOT_SUPPORTED$ !error
~ EAX XMM2 ADDPD                  I32_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDPD                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [ESI] XMM0 ADDPD    I32_NOT_SUPPORTED$ !error
~ XMM7 OWORD PTR 0 [ESI] ADDPD    XMM_NOT_SUPPORTED$ !error
~ EAX EBX ADDPS                   I32_NOT_SUPPORTED$ !error
~ EAX XMM2 ADDPS                  I32_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDPS                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [ESI] XMM0 ADDPS    I32_NOT_SUPPORTED$ !error
~ XMM7 OWORD PTR 0 [ESI] ADDPS    XMM_NOT_SUPPORTED$ !error
~ EAX EBX ADDSD                   I32_NOT_SUPPORTED$ !error
~ EAX XMM2 ADDSD                  I32_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDSD                 XMM_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [ESI] XMM0 ADDSD    I32_NOT_SUPPORTED$ !error
~ XMM7 QWORD PTR 0 [ESI] ADDSD    XMM_NOT_SUPPORTED$ !error
~ EAX EBX ADDSS                   I32_NOT_SUPPORTED$ !error
~ EAX XMM2 ADDSS                  I32_NOT_SUPPORTED$ !error
~ XMM1 XMM2 ADDSS                 XMM_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [ESI] XMM0 ADDSS    I32_NOT_SUPPORTED$ !error
~ XMM7 QWORD PTR 0 [ESI] ADDSS    XMM_NOT_SUPPORTED$ !error
~ XMM3 XMM4 ADDSUBPD              XMM_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [ESI] XMM0 ADDSUBPD I32_NOT_SUPPORTED$ !error
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
~ -1 # OWORD PTR 0 [EAX] [EBX] *4 XMM0 AESKEYGENASSIST  I32_NOT_SUPPORTED$ !error
~ AL AH AND                       20 C4 chk
~ DX 0 [RSI] AND                  I64_NOT_SUPPORTED$ !error
~ AL BPL AND                      I64_NOT_SUPPORTED$ !error
~ QWORD PTR -123 [BP+DI] RSI AND  I64_NOT_SUPPORTED$ !error
~ XMM7 XMM1 AND                   XMM_NOT_SUPPORTED$ !error
~ SP SP AND                       21 E4 chk
~ CR0 RAX AND                     INVALID_TARGET_ARCHITECTURE$ !error
~ CS DS AND                       STANDARD_REGISTER_EXPECTED$ !error
~ XMM0 XMM0 ANDPD                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [R10] XMM7 ANDPS    I64_NOT_SUPPORTED$ !error
~ OWORD PTR -1 [] XMM0 ANDNPD     XMM_NOT_SUPPORTED$ !error
~ XMM7 XMM6 ANDNPS                XMM_NOT_SUPPORTED$ !error
~ AX BX ARPL                      63 C3 chk
~ AX 0 [SI] ARPL                  63 04 chk
~ WORD PTR 0 [BX] AX ARPL         REGISTER_OPERAND_EXPECTED$ !error
~ 1000 # XMM0 XMM1 BLENDPD        XMM_NOT_SUPPORTED$ !error
~ -1 # XMM0 XMM1 BLENDPD          XMM_NOT_SUPPORTED$ !error
~ 2 # OWORD PTR 0 [RAX] XMM1 BLENDPS
                                  I64_NOT_SUPPORTED$ !error
~ EAX XMM1 EAX BLENDPS            I32_NOT_SUPPORTED$ !error
~ EAX XMM1 XMM0 BLENDPS           I32_NOT_SUPPORTED$ !error
~ XMM7 XMM5 BLENDVPD              XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM3 BLENDVPS              XMM_NOT_SUPPORTED$ !error
~ 0 [SI] AX BOUND                 62 04 chk
~ 0 [ESI] AX BOUND                I32_NOT_SUPPORTED$ !error
~ WORD PTR -25 [SI] SI BSF        0F BC 74 DB chk
~ SI -25 [SI] BSF                 STANDARD_REGISTER_EXPECTED$ !error
~ SI DI BSF                       0F BC FE chk
~ WORD PTR -25 [BX+SI] SI BSR     0F BD 70 DB chk
~ AX CX BSR                       0F BD C8 chk
~ DX BSWAP                        OPERATION_NOT_SUPPORTED<486$ !error
~ CX WORD PTR 99 [SI] BT          0F A3 8C 99 00 chk
~ SI DI BTS                       0F AB F7 chk
~ 78 # 0 [BP+DI] BTR              OPERAND_SIZE_UNKNOWN$ !error
~ 78 # WORD PTR 0 [BP+DI] BTR     0F BA 33 78 chk
~ -12 # SI BTC                    0F BA FE EE chk
~ CX BYTE PTR 99 [DI] BT          OPERAND_SIZE_MISMATCH$ !error
~ HERE 10 + # CALL                E8 0D 00 chk
~ 0 [BP+SI] CALL                  FF 12 chk
~ 0 [] CALL                       FF 16 00 00 chk
~ BX CALL                         FF D3 chk
~ CBW                             98 chk
~ CWDE                            INVALID_OPERAND_SIZE$ !error
~ CDQE                            INVALID_OPERAND_SIZE$ !error
~ CLC                             F8 chk
~ CLD                             FC chk
~ 0 [SI] CLFLUSH                  OPERATION_NOT_SUPPORTED<586$ !error
~ AX CLFLUSH                      OPERATION_NOT_SUPPORTED<586$ !error
~ CLI                             FA chk
~ CLTS                            OPERATION_NOT_SUPPORTED<586$ !error
~ CMC                             F5 chk
~ BX AX 0= ?MOV                   OPERATION_NOT_SUPPORTED<586$ !error
~ 0 [BX] AX U< ?MOV               OPERATION_NOT_SUPPORTED<586$ !error
~ 0 [RIP] AL 0> ?MOV              RIP_64_ONLY$ !error
~ 0 [] AL 0> ?MOV                 OPERATION_NOT_SUPPORTED<586$ !error
~ AX 0 [SI] P= ?MOV               OPERATION_NOT_SUPPORTED<586$ !error
~ AX WORD PTR 0 [SI] P= ?MOV      OPERATION_NOT_SUPPORTED<586$ !error
~ 1000 # AX CMP                   3D 00 10 chk
~ 10 # WORD PTR -1 [SI] CMP       83 7C FF 10 chk
~ AX CX CMP                       39 C1 chk
~ AL 90 [BX+DI] CMP               38 81 90 00 chk
~ 90 [BP+SI] BH CMP               3A BA 90 00 chk
~ BYTE PTR CMPS                   A6 chk
~ WORD PTR CMPS                   A7 chk
~ QWORD PTR 0 [] CMPXCHG8B        OPERATION_NOT_SUPPORTED<586$ !error
~ CPUID                           OPERATION_NOT_SUPPORTED<586$ !error
~ CWD                             99 chk
~ CDQ                             INVALID_OPERAND_SIZE$ !error
~ CQO                             INVALID_OPERAND_SIZE$ !error
~ DAA                             27 chk
~ DAS                             2F chk
~ 1 # DEC                         INVALID_OPERAND_TYPE$ !error
~ AL DEC                          FE C8 chk
~ BX DEC                          4B chk
~ ECX DEC                         I32_NOT_SUPPORTED$ !error
~ RDX DEC                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] DEC             FE 0C chk
~ WORD PTR 0 [BX] DEC             FF 0F chk
~ DWORD PTR 0 [BX+SI] DEC         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BX+DI] DEC         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [BP+SI] DEC         INVALID_OPERAND_SIZE$ !error
~ AL DIV                          F6 F0 chk
~ BX DIV                          F7 F3 chk
~ ECX DIV                         I32_NOT_SUPPORTED$ !error
~ RDX DIV                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] DIV             F6 34 chk
~ WORD PTR 0 [BX] DIV             F7 37 chk
~ DWORD PTR 0 [BX+SI] DIV         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BX+DI] DIV         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [BP+DI] DIV         INVALID_OPERAND_SIZE$ !error
~ 10 2000 # ENTER                 C8 00 20 10 chk
~ 100 # ENTER                     MISSING_NESTING_LEVEL$ !error
~ 200 2000 # ENTER                NESTLEVEL_OPERAND_EXPECTED$ !error
~ 10 12345 # ENTER                IMMEDIATE16_OPERAND_EXPECTED$ !error
~ 0 1234 # ENTER                  C8 34 12 00 chk
~ F2^X-1                          X87_NOT_SUPPORTED$ !error
~ FABS                            X87_NOT_SUPPORTED$ !error
~ 0 [BX] FBLD                     X87_NOT_SUPPORTED$ !error
~ ST2 FADD                        X87_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] FADD           X87_NOT_SUPPORTED$ !error
~ ST2 RFADD                       X87_NOT_SUPPORTED$ !error
~ FADDP                           X87_NOT_SUPPORTED$ !error
~ WORD PTR 0 [SI] FIADD           X87_NOT_SUPPORTED$ !error
~ TBYTE PTR 0 [BX] FBLD           X87_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [BX] FBLD           X87_NOT_SUPPORTED$ !error
~ ST(0) FBLD                      X87_NOT_SUPPORTED$ !error
~ TBYTE PTR 0 [SI] FBSTP          X87_NOT_SUPPORTED$ !error
~ FCHS                            X87_NOT_SUPPORTED$ !error
~ ST1 U< ?FMOV                    X87_NOT_SUPPORTED$ !error
~ 0 [SI] U< ?FMOV                 X87_NOT_SUPPORTED$ !error
~ ST(2) = ?FMOV                   X87_NOT_SUPPORTED$ !error
~ AX = ?FMOV                      X87_NOT_SUPPORTED$ !error
~ ST3 U≤ ?FMOV                    X87_NOT_SUPPORTED$ !error
~ ST4 X< ?FMOV                    X87_NOT_SUPPORTED$ !error
~ ST5 U≥ ?FMOV                    X87_NOT_SUPPORTED$ !error
~ ST6 ≠ ?FMOV                     X87_NOT_SUPPORTED$ !error
~ ST7 U> ?FMOV                    X87_NOT_SUPPORTED$ !error
~ ST0 X> ?FMOV                    X87_NOT_SUPPORTED$ !error
~ ST1 FCOMI                       X87_NOT_SUPPORTED$ !error
~ ST2 FCOMIP                      X87_NOT_SUPPORTED$ !error
~ ST(3) FUCOMI                    X87_NOT_SUPPORTED$ !error
~ ST(4) FUCOMIP                   X87_NOT_SUPPORTED$ !error
~ 0 [DI] FUCOMI                   X87_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] FICOM           X87_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] FILD            X87_NOT_SUPPORTED$ !error
~ WORD PTR 0 [SI] FISTP           X87_NOT_SUPPORTED$ !error
~ WORD PTR 0 [SI] FISTTP          X87_NOT_SUPPORTED$ !error
~ ST(3) FLD                       X87_NOT_SUPPORTED$ !error
~ FLD1                            X87_NOT_SUPPORTED$ !error
~ FLDL2T                          X87_NOT_SUPPORTED$ !error
~ FLDL2E                          X87_NOT_SUPPORTED$ !error
~ FLDPI                           X87_NOT_SUPPORTED$ !error
~ FLDLG2                          X87_NOT_SUPPORTED$ !error
~ FLDLN2                          X87_NOT_SUPPORTED$ !error
~ FLD0                            X87_NOT_SUPPORTED$ !error
~ 0 [SI] FLDCW                    X87_NOT_SUPPORTED$ !error
~ 0 [SI] FLDENV                   X87_NOT_SUPPORTED$ !error
~ AX FNSTSW                       X87_NOT_SUPPORTED$ !error
~ 0 [SI] FNSTSW                   X87_NOT_SUPPORTED$ !error
~ FTST                            X87_NOT_SUPPORTED$ !error
~ FUCOM                           X87_NOT_SUPPORTED$ !error
~ FUCOMP                          X87_NOT_SUPPORTED$ !error
~ FUCOMPP                         X87_NOT_SUPPORTED$ !error
~ FXCH                            X87_NOT_SUPPORTED$ !error
~ 0 [SI] FXRSTOR                  X87_NOT_SUPPORTED$ !error
~ 0 [SI] FXSAVE                   X87_NOT_SUPPORTED$ !error
~ 0 [SI] FXRSTOR64                X87_NOT_SUPPORTED$ !error
~ 0 [SI] FXSAVE64                 X87_NOT_SUPPORTED$ !error
~ FXTRACT                         X87_NOT_SUPPORTED$ !error
~ FYL2X                           X87_NOT_SUPPORTED$ !error
~ FYL2XP1                         X87_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [SI] XMM0 HADDPD    XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 HADDPD                XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [SI] XMM0 HADDPS    XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 HADDPS                XMM_NOT_SUPPORTED$ !error
~ HLT                             F4 chk
~ OWORD PTR 0 [SI] XMM0 HSUBPD    XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 HSUBPD                XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [SI] XMM0 HSUBPS    XMM_NOT_SUPPORTED$ !error
~ XMM1 XMM2 HSUBPS                XMM_NOT_SUPPORTED$ !error
~ 1 # IDIV                        INVALID_OPERAND_TYPE$ !error
~ AL IDIV                         F6 F8 chk
~ BX IDIV                         F7 FB chk
~ ECX IDIV                        I32_NOT_SUPPORTED$ !error
~ RDX IDIV                        I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [BX+SI] IDIV         F6 38 chk
~ WORD PTR 0 [BX] IDIV            F7 3F chk
~ DWORD PTR 0 [BX+SI] IDIV        INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [DI] IDIV           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [SI] IDIV           INVALID_OPERAND_SIZE$ !error
~ HLT                             F4 chk
~ 1 # IMUL                        INVALID_OPERAND_TYPE$ !error
~ AL IMUL                         F6 E8 chk
~ BX IMUL                         F7 EB chk
~ ECX IMUL                        I32_NOT_SUPPORTED$ !error
~ RDX IMUL                        I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [BX+SI] IMUL         F6 28 chk
~ WORD PTR 0 [BX] IMUL            F7 2F chk
~ DWORD PTR 0 [BP+SI] IMUL        INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BP+DI] IMUL        INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [SI] IMUL           INVALID_OPERAND_SIZE$ !error
~ AL BL IMUL                      REGISTER_16+_EXPECTED$ !error
~ AX BX IMUL                      0F AF D8 chk
~ AL EBX IMUL                     I32_NOT_SUPPORTED$ !error
~ 0 [SI] SI IMUL                  0F AF 34 chk
~ SI 0 [SI] IMUL                  REGISTER_16+_EXPECTED$ !error
~ 2 # AL CL IMUL                  REGISTER_16+_EXPECTED$ !error
~ -2 # AL BX IMUL                 OPERAND_SIZE_MISMATCH$ !error
~ -2 # AX BX IMUL                 6B D8 FE chk
~ 4 # 0 [SI] DX IMUL              6B 14 04 chk
~ AL 3 # BL IMUL                  REGISTER_16+_EXPECTED$ !error
~ AL BL CL DL IMUL                INVALID_OPERAND_COMBINATION$ !error
~ -2000 # AX BX IMUL              69 D8 00 E0 chk
~ 4000 # 0 [SI] DX IMUL           69 14 00 40 chk
~ 10 # AL IN                      E4 10 chk
~ 1000 # AL IN                    IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 10 # AX IN                      E5 10 chk
~ 10 # EAX IN                     I32_NOT_SUPPORTED$ !error
~ 10 # RAX IN                     I64_NOT_SUPPORTED$ !error
~ 10 # BL IN                      ACCU_OPERAND_REQUIRED$ !error
~ DX AL IN                        EC chk
~ DX AX IN                        ED chk
~ DX EAX IN                       I32_NOT_SUPPORTED$ !error
~ DX RAX IN                       I64_NOT_SUPPORTED$ !error
~ DX CL IN                        ACCU_OPERAND_REQUIRED$ !error
~ CX AL IN                        IMMEDIATE8_OPERAND_EXPECTED$ !error
~ 1 # INC                         INVALID_OPERAND_TYPE$ !error
~ AL INC                          FE C0 chk
~ BX INC                          43 chk
~ ECX INC                         I32_NOT_SUPPORTED$ !error
~ RDX INC                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [BX+SI] INC          FE 00 chk
~ WORD PTR 0 [BX] INC             FF 07 chk
~ DWORD PTR 0 [BP+DI] INC         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BX+DI] INC         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [SI] INC            INVALID_OPERAND_SIZE$ !error
~ 1 u# INT                        CD 01 chk
~ 3 u# INT                        CC chk
~ FF u# INT                       CD FF chk
~ 1000 u# INT                     IMMEDIATE8_OPERAND_EXPECTED$ !error
~ AL INT                          IMMEDIATE8_OPERAND_EXPECTED$ !error
~ IRET                            CF chk
~ HERE 2+ # 0= ?JMP               74 00 chk
~ HERE 2+ # ≥ ?JMP                7D 00 chk
~ HERE 2+ # U< ?JMP               72 00 chk
~ HERE 100 - # U< ?JMP            TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ HERE 100 + # U< ?JMP            TARGET_ADDRESS_OUT_OF_RANGE$ !error
~ HERE 10 + # JMP                 EB 0E chk
~ HERE 1000 + # JMP               E9 FD 0F chk
~ 0 [BP+SI] JMP                   FF 22 chk
~ 0 [] JMP                        FF 26 00 00 chk
~ BX JMP                          FF E3 chk
~ AX BX LAR                       0F 02 D8 chk
~ BX EAX LAR                      I32_NOT_SUPPORTED$ !error
~ CX RDX LAR                      I64_NOT_SUPPORTED$ !error
~ ECX ESI LAR                     I32_NOT_SUPPORTED$ !error
~ AX DL LAR                       REGISTER_16+_EXPECTED$ !error
~ AL BX LAR                       R/M_16_EXPECTED$ !error
~ WORD PTR 0 [SI] AX LAR          0F 02 04 chk
~ DWORD PTR 0 [BX] AX LAR         R/M_16_EXPECTED$ !error
~ 0 [BX] SI LDS                   C5 37 chk
~ 0 [BX] ESI LDS                  I32_NOT_SUPPORTED$ !error
~ 0 [BX] RSI LDS                  I64_NOT_SUPPORTED$ !error
~ AX SI LDS                       ADDRESS_OPERAND_EXPECTED$ !error
~ AX 0 [BX] LDS                   REGISTER_16+_EXPECTED$ !error
~ 0 [BX] SI LES                   C4 37 chk
~ 0 [BX] ESI LES                  I32_NOT_SUPPORTED$ !error
~ 0 [BX] RSI LES                  I64_NOT_SUPPORTED$ !error
~ AX SI LES                       ADDRESS_OPERAND_EXPECTED$ !error
~ AX 0 [BX] LES                   REGISTER_16+_EXPECTED$ !error
~ 0 [BX] SI LFS                   0F B4 37 chk
~ 0 [BX] ESI LFS                  I32_NOT_SUPPORTED$ !error
~ 0 [BX] RSI LFS                  I64_NOT_SUPPORTED$ !error
~ AX SI LFS                       ADDRESS_OPERAND_EXPECTED$ !error
~ AX 0 [BX] LFS                   REGISTER_16+_EXPECTED$ !error
~ 0 [BX] SI LGS                   0F B5 37 chk
~ 0 [BX] SI LSS                   0F B2 37 chk
~ 5 [BX+DI] SI LEA                8D 71 05 chk
~ 0 [BP] SI LEA                   8D 76 00 chk
~ AX SI LEA                       ADDRESS_OPERAND_EXPECTED$ !error
~ AX 0 [BX] LEA                   REGISTER_16+_EXPECTED$ !error
~ LEAVE                           C9 chk
~ LFENCE                          0F AE 28 chk
~ 0 [SI] LGDT                     0F 01 14 chk
~ AX LGDT                         ADDRESS_OPERAND_EXPECTED$ !error
~ 0 [SI] LIDT                     0F 01 1C chk
~ AX LLDT                         0F 00 D0 chk
~ WORD PTR 0 [SI] LLDT            0F 00 14 chk
~ 0 [SI] LLDT                     R/M_16_EXPECTED$ !error
~ 1 # LLDT                        R/M_16_EXPECTED$ !error
~ AX LMSW                         0F 01 F0 chk
~ WORD PTR 0 [SI] LMSW            0F 01 34 chk
~ LOCK                            F0 chk
~ BYTE PTR LODS                   AC chk
~ WORD PTR LODS                   AD chk
~ DWORD PTR LODS                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR LODS                  INVALID_OPERAND_SIZE$ !error
~ HERE # LOOP                     E2 FE chk
~ AX LOOP                         IMMEDIATE_OPERAND_EXPECTED$ !error
~ HERE # 0= ?LOOP                 E1 FE chk
~ HERE # = ?LOOP                  E1 FE chk
~ 1 # AX ?LOOP                    CONDITION_OPERAND_EXPECTED$ !error
~ HERE # ≠ ?LOOP                  E0 FE chk
~ HERE # < ?LOOP                  EQ_OR_NEQ_REQUIRED$ !error
~ MM0 MM1 MASKMOVQ                MMX_NOT_SUPPORTED$ !error
~ MM2 0 [SI] MASKMOVQ             MMX_NOT_SUPPORTED$ !error
~ 0 [SI] MM2 MASKMOVQ             MMX_NOT_SUPPORTED$ !error
~ MFENCE                          0F AE 30 chk
~ MONITOR                         0F 01 C8 chk
~ 0 [] AL MOV                     A0 00 00 chk
~ 0 [] AX MOV                     A1 00 00 chk
~ 0 [] EAX MOV                    I32_NOT_SUPPORTED$ !error
~ 0 [] RAX MOV                    I64_NOT_SUPPORTED$ !error
~ 0 [] XMM1 MOV                   XMM_NOT_SUPPORTED$ !error
~ 0 [] BL MOV                     8A 1E 00 00 chk
~ AL 0 [] MOV                     A2 00 00 chk
~ AX 0 [] MOV                     A3 00 00 chk
~ EAX 0 [] MOV                    I32_NOT_SUPPORTED$ !error
~ RAX 0 [] MOV                    I64_NOT_SUPPORTED$ !error
~ XMM1 0 [] MOV                   XMM_NOT_SUPPORTED$ !error
~ BL 0 [] MOV                     88 1E 00 00 chk
~ WORD PTR 0 [] ES MOV            8E 06 00 00 chk
~ AX DS MOV                       8E D8 chk
~ WORD PTR 0 [BX+SI] DS MOV       8E 18 chk
~ DX CS MOV                       INVALID_OPERAND_COMBINATION$ !error
~ WORD PTR 0 [SI] CS MOV          INVALID_OPERAND_COMBINATION$ !error
~ CX SS MOV                       8E D1 chk
~ QWORD PTR 0 [EBP] [EAX] *8 SS MOV  I32_NOT_SUPPORTED$ !error
~ RDX FS MOV                      I64_NOT_SUPPORTED$ !error
~ WORD PTR 0 [] FS MOV            8E 26 00 00 chk
~ AX GS MOV                       8E E8 chk
~ WORD PTR -12 [BX+SI] GS MOV     8E 68 EE chk
~ AL ES MOV                       R/M_16+_EXPECTED$ !error
~ ES AX MOV                       8C C0 chk
~ ES WORD PTR 0 [] MOV            8C 06 00 00 chk
~ DS SI MOV                       8C DE chk
~ DS WORD PTR 0 [BP+DI] MOV       8C 1B chk
~ CS MM0 MOV                      MMX_NOT_SUPPORTED$ !error
~ CS WORD PTR 0 [BX] MOV          8C 0F chk
~ SS CX MOV                       8C D1 chk
~ SS QWORD PTR 0 [EBP] [EAX] *8 MOV  I32_NOT_SUPPORTED$ !error
~ FS RDX MOV                      I64_NOT_SUPPORTED$ !error
~ FS QWORD PTR 0 [] MOV           INVALID_OPERAND_SIZE$ !error
~ GS EAX MOV                      I32_NOT_SUPPORTED$ !error
~ GS WORD PTR -12 [BX+SI] MOV     8C 68 EE chk
~ GS AL MOV                       R/M_16+_EXPECTED$ !error
~ EDX CR0 MOV                     I32_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] CR4 MOV        INVALID_TARGET_ARCHITECTURE$ !error
~ DX CR0 MOV                      INVALID_TARGET_ARCHITECTURE$ !error
~ RCX CR1 MOV                     I64_NOT_SUPPORTED$ !error
~ CL CR1 MOV                      INVALID_TARGET_ARCHITECTURE$ !error
~ EBX CR8 MOV                     I32_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] CR8 MOV        I64_NOT_SUPPORTED$ !error
~ CR0 EDX MOV                     INVALID_TARGET_ARCHITECTURE$ !error
~ CR0 DWORD PTR 0 [SI] MOV        INVALID_TARGET_ARCHITECTURE$ !error
~ CR1 RCX MOV                     INVALID_TARGET_ARCHITECTURE$ !error
~ CR8 EBX MOV                     I64_NOT_SUPPORTED$ !error
~ CR8 DWORD PTR 0 [SI] MOV        I64_NOT_SUPPORTED$ !error
~ EDX DR0 MOV                     I32_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] DR0 MOV        INVALID_TARGET_ARCHITECTURE$ !error
~ WORD PTR 0 [SI] DR0 MOV         INVALID_TARGET_ARCHITECTURE$ !error
~ RCX DR1 MOV                     I64_NOT_SUPPORTED$ !error
~ QWORD PTR 0 CS: [DI] DR1 MOV    INVALID_TARGET_ARCHITECTURE$ !error
~ EBX DR8 MOV                     I32_NOT_SUPPORTED$ !error
~ DR0 EDX MOV                     INVALID_TARGET_ARCHITECTURE$ !error
~ DR1 RCX MOV                     INVALID_TARGET_ARCHITECTURE$ !error
~ DR8 EBX MOV                     I64_NOT_SUPPORTED$ !error
~ 0 [BP+SI] BL MOV                8A 1A chk
~ 0 [BX+SI] BX MOV                8B 18 chk
~ 0 [BP+DI] EBX MOV               I32_NOT_SUPPORTED$ !error
~ 0 [DI] RBX MOV                  I64_NOT_SUPPORTED$ !error
~ BL 0 [BP+SI] MOV                88 1A chk
~ BX 0 [BX+SI] MOV                89 18 chk
~ EBX 0 [BP+DI] MOV               I32_NOT_SUPPORTED$ !error
~ RBX 0 [DI] MOV                  I64_NOT_SUPPORTED$ !error
~ AL BL MOV                       8A D8 chk
~ AX BX MOV                       8B D8 chk
~ EBX EAX MOV                     I32_NOT_SUPPORTED$ !error
~ RSI R08 MOV                     I64_NOT_SUPPORTED$ !error
~ AL DX MOV                       OPERAND_SIZE_MISMATCH$ !error
~ XMM0 AX MOV                     XMM_NOT_SUPPORTED$ !error
~ AX XMM0 MOV                     XMM_NOT_SUPPORTED$ !error
~ 0 [SI] MM0 MOV                  MMX_NOT_SUPPORTED$ !error
~ MM1 0 [DI] MOV                  MMX_NOT_SUPPORTED$ !error
~ AX AX MOVBE                     ADDRESS_OPERAND_EXPECTED$ !error
~ WORD PTR 0 [SI] AX MOVBE        0F 38 F0 04 chk
~ DWORD PTR 0 [BX] EAX MOVBE      I32_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [BX+SI] RCX MOVBE   I64_NOT_SUPPORTED$ !error
~ WORD PTR 0 [SI] AX MOVBE        0F 38 F0 04 chk
~ DWORD PTR 0 [BX] EAX MOVBE      I32_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [BX+SI] RCX MOVBE   I64_NOT_SUPPORTED$ !error
~ 10 # OWORD PTR 0 [SI] MOVBE     REGISTER_16+_EXPECTED$ !error
~ OWORD PTR 0 [SI] XMM0 MOVBE     XMM_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] MM0 MOVD       MMX_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] XMM0 MOVD      XMM_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [SI] MM0 MOVQ       MMX_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [SI] XMM0 MOVQ      XMM_NOT_SUPPORTED$ !error
~ BYTE PTR MOVS                   A4 chk
~ WORD PTR MOVS                   A5 chk
~ DWORD PTR MOVS                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR MOVS                  INVALID_OPERAND_SIZE$ !error
~ AL AL MOVSX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVSX                     0F BE C3 chk
~ BYTE PTR 0 [SI] DX MOVSX        0F BE 14 chk
~ BL EBX MOVSX                    I32_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] ECX MOVSX       I32_NOT_SUPPORTED$ !error
~ AL RSI MOVSX                    I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] RBP MOVSX       I64_NOT_SUPPORTED$ !error
~ AL WORD PTR 0 [DI] MOVSX        REGISTER_16_EXPECTED$ !error
~ BX EDI MOVSX                    I32_NOT_SUPPORTED$ !error
~ WORD PTR 0 [SI] ESP MOVSX       I32_NOT_SUPPORTED$ !error
~ R12W R13 MOVSX                  I64_NOT_SUPPORTED$ !error
~ EDI RAX MOVSXD                  I32_NOT_SUPPORTED$ !error
~ DWORD PTR -7 [BX+SI] R15 MOVSXD   I64_NOT_SUPPORTED$ !error
~ AH R13 MOVSX                    I64_NOT_SUPPORTED$ !error
~ AL AL MOVZX                     REGISTER_16_EXPECTED$ !error
~ BL AX MOVZX                     0F B6 C3 chk
~ BYTE PTR 0 [SI] DX MOVZX        0F B6 14 chk
~ BL EBX MOVZX                    I32_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] ECX MOVZX       I32_NOT_SUPPORTED$ !error
~ AL RSI MOVZX                    I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] RBP MOVZX       I64_NOT_SUPPORTED$ !error
~ AL WORD PTR 0 [DI] MOVZX        REGISTER_16_EXPECTED$ !error
~ BX EDI MOVZX                    I32_NOT_SUPPORTED$ !error
~ WORD PTR 0 [SI] ESP MOVZX       I32_NOT_SUPPORTED$ !error
~ R12W R13 MOVZX                  I64_NOT_SUPPORTED$ !error
~ AH R13 MOVZX                    I64_NOT_SUPPORTED$ !error
~ AL MUL                          F6 E0 chk
~ BX MUL                          F7 E3 chk
~ ECX MUL                         I32_NOT_SUPPORTED$ !error
~ RDX MUL                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] MUL             F6 24 chk
~ WORD PTR 0 [BX] MUL             F7 27 chk
~ DWORD PTR 0 [BX+SI] MUL         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BX+DI] MUL         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [BP+DI] MUL         INVALID_OPERAND_SIZE$ !error
~ MWAIT                           0F 01 C9 chk
~ AL NEG                          F6 D8 chk
~ BX NEG                          F7 DB chk
~ ECX NEG                         I32_NOT_SUPPORTED$ !error
~ RDX NEG                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] NEG             F6 1C chk
~ WORD PTR 0 [BX] NEG             F7 1F chk
~ DWORD PTR 0 [BX+SI] NEG         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BX+DI] NEG         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [BP+DI] NEG         INVALID_OPERAND_SIZE$ !error
~ NOP                             90 chk
~ -1 # NOP                        INVALID_NOP_SIZE$ !error
~ 1 # NOP                         90 chk
~ 2 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 3 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 4 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 5 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 6 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 7 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 8 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 9 # NOP                         NOP#_NOT_SUPPORTED$ !error
~ 13 # NOP                        NOP#_NOT_SUPPORTED$ !error
~ AL NOT                          F6 D0 chk
~ BX NOT                          F7 D3 chk
~ ECX NOT                         I32_NOT_SUPPORTED$ !error
~ RDX NOT                         I64_NOT_SUPPORTED$ !error
~ BYTE PTR 0 [SI] NOT             F6 14 chk
~ WORD PTR 0 [BX] NOT             F7 17 chk
~ DWORD PTR 0 [BX+SI] NOT         INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 0 [BX+DI] NOT         INVALID_OPERAND_SIZE$ !error
~ OWORD PTR 0 [BP+DI] NOT         INVALID_OPERAND_SIZE$ !error
~ AL AH OR                        08 C4 chk
~ DX 0 [RSI] OR                   I64_NOT_SUPPORTED$ !error
~ AL BPL OR                       I64_NOT_SUPPORTED$ !error
~ QWORD PTR -123 [BP+DI] RSI OR   I64_NOT_SUPPORTED$ !error
~ XMM7 XMM1 OR                    XMM_NOT_SUPPORTED$ !error
~ SP SP OR                        09 E4 chk
~ CR0 RAX OR                      INVALID_TARGET_ARCHITECTURE$ !error
~ CS DS OR                        STANDARD_REGISTER_EXPECTED$ !error
~ AL 10 # OUT                     E6 10 chk
~ AL 1000 # OUT                   IMMEDIATE8_OPERAND_EXPECTED$ !error
~ AX 10 # OUT                     E7 10 chk
~ EAX 10 # OUT                    I32_NOT_SUPPORTED$ !error
~ RAX 10 # OUT                    I64_NOT_SUPPORTED$ !error
~ BL 10 # OUT                     ACCU_OPERAND_REQUIRED$ !error
~ AL DX OUT                       EE chk
~ AX DX OUT                       EF chk
~ EAX DX OUT                      I32_NOT_SUPPORTED$ !error
~ RAX DX OUT                      I64_NOT_SUPPORTED$ !error
~ CL DX OUT                       ACCU_OPERAND_REQUIRED$ !error
~ AL CX OUT                       IMMEDIATE8_OPERAND_EXPECTED$ !error
~ BYTE PTR OUTS                   6E chk
~ WORD PTR OUTS                   6F chk
~ DWORD PTR OUTS                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR OUTS                  INVALID_OPERAND_SIZE$ !error
~ MM1 MM2 PABSB                   MMX_NOT_SUPPORTED$ !error
~ QWORD PTR 0 [SI] MM3 PABSB      MMX_NOT_SUPPORTED$ !error
~ XMM1 XMM2 PABSB                 XMM_NOT_SUPPORTED$ !error
~ OWORD PTR 0 [BX] XMM3 PABSB     XMM_NOT_SUPPORTED$ !error
~ ES POP                          07 chk
~ CS POP                          CANNOT_POP_CS$ !error
~ DS POP                          1F chk
~ SS POP                          17 chk
~ FS POP                          0F A1 chk
~ GS POP                          0F A9 chk
~ BX POP                          5B chk
~ ECX POP                         I32_NOT_SUPPORTED$ !error
~ RDX POP                         I64_NOT_SUPPORTED$ !error
~ 0 [SI] POP                      R/M_16+_EXPECTED$ !error
~ BYTE PTR -10 [DI] POP           R/M_16+_EXPECTED$ !error
~ WORD PTR 11 [DI] POP            8F 45 11 chk
~ DWORD PTR 12 [DI] POP           INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 13 [DI] POP           INVALID_OPERAND_SIZE$ !error
~ OWORD PTR -14 [DI] POP          INVALID_OPERAND_SIZE$ !error
~ MM0 POP                         MMX_NOT_SUPPORTED$ !error
~ XMM1 POP                        XMM_NOT_SUPPORTED$ !error
~ CR2 POP                         INVALID_TARGET_ARCHITECTURE$ !error
~ DR3 POP                         INVALID_TARGET_ARCHITECTURE$ !error
~ 5 # POP                         CANNOT_POP_CONSTANT$ !error
~ POPA                            61 chk
~ WORD PTR POPA                   61 chk
~ DWORD PTR POPA                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR POPA                  INVALID_OPERAND_SIZE$ !error
~ BX CX POPCNT                    F3 0F B8 CB chk
~ WORD PTR 88 [BP] AX POPCNT      F3 0F B8 86 88 00 chk
~ DL BX POPCNT                    OPERAND_SIZE_MISMATCH$ !error
~ EBX ECX POPCNT                  I32_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [BX] EAX POPCNT     I32_NOT_SUPPORTED$ !error
~ RAX RAX POPCNT                  I64_NOT_SUPPORTED$ !error
~ QWORD PTR 22 [SI] RDX POPCNT    I64_NOT_SUPPORTED$ !error
~ AX 44 [DI] POPCNT               REGISTER_16+_EXPECTED$ !error
~ 1 [BX+SI] EAX POPCNT            I32_NOT_SUPPORTED$ !error
~ DWORD PTR 1 [BP+DI] AX POPCNT   OPERAND_SIZE_MISMATCH$ !error
~ WORD PTR POPF                   9D chk
~ DWORD PTR POPF                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR POPF                  INVALID_OPERAND_SIZE$ !error
~ POPF                            9D chk
~ ES PUSH                         06 chk
~ CS PUSH                         0E chk
~ DS PUSH                         1E chk
~ SS PUSH                         16 chk
~ FS PUSH                         0F A0 chk
~ GS PUSH                         0F A8 chk
~ BX PUSH                         53 chk
~ ECX PUSH                        I32_NOT_SUPPORTED$ !error
~ RDX PUSH                        I64_NOT_SUPPORTED$ !error
~ 0 [SI] PUSH                     R/M_16+_EXPECTED$ !error
~ BYTE PTR -10 [DI] PUSH          R/M_16+_EXPECTED$ !error
~ WORD PTR 11 [DI] PUSH           FF 75 11 chk
~ DWORD PTR 12 [DI] PUSH          INVALID_OPERAND_SIZE$ !error
~ QWORD PTR 13 [DI] PUSH          INVALID_OPERAND_SIZE$ !error
~ OWORD PTR -14 [DI] PUSH         INVALID_OPERAND_SIZE$ !error
~ MM0 PUSH                        MMX_NOT_SUPPORTED$ !error
~ XMM1 PUSH                       XMM_NOT_SUPPORTED$ !error
~ CR2 PUSH                        INVALID_TARGET_ARCHITECTURE$ !error
~ DR3 PUSH                        INVALID_TARGET_ARCHITECTURE$ !error
~ 5 # PUSH                        6A 05 chk
~ 100 # PUSH                      68 00 01 chk
~ 1234567 # PUSH                  INVALID_OPERAND_SIZE$ !error
~ CL AL RCL                       D2 D0 chk
~ CL BYTE PTR 1 [SI] RCL          D2 54 01 chk
~ 1 # AL RCL                      D0 D0 chk
~ 1 # BYTE PTR 2 [SI] RCL         D0 54 02 chk
~ 5 # AL RCL                      C0 D0 05 chk
~ 5 # BYTE PTR 3 [SI] RCL         C0 54 03 05 chk
~ CL BX RCL                       D3 D3 chk
~ CL WORD PTR 4 [SI] RCL          D3 54 04 chk
~ 1 # BX RCL                      D1 D3 chk
~ 1 # WORD PTR 5 [SI] RCL         D1 54 05 chk
~ 5 # BX RCL                      C1 D3 05 chk
~ 5 # WORD PTR 6 [SI] RCL         C1 54 06 05 chk
~ CL ECX RCL                      I32_NOT_SUPPORTED$ !error
~ CL DWORD PTR 7 [SI] RCL         INVALID_OPERAND_SIZE$ !error
~ 1 # ECX RCL                     I32_NOT_SUPPORTED$ !error
~ 1 # DWORD PTR 8 [SI] RCL        INVALID_OPERAND_SIZE$ !error
~ 5 # ECX RCL                     I32_NOT_SUPPORTED$ !error
~ 5 # DWORD PTR 9 [SI] RCL        INVALID_OPERAND_SIZE$ !error
~ CL RDX RCL                      I64_NOT_SUPPORTED$ !error
~ CL QWORD PTR 0 [SI] RCL         INVALID_OPERAND_SIZE$ !error
~ 1 # RDX RCL                     I64_NOT_SUPPORTED$ !error
~ 1 # QWORD PTR 1 [SI] RCL        INVALID_OPERAND_SIZE$ !error
~ 5 # RDX RCL                     I64_NOT_SUPPORTED$ !error
~ 5 # QWORD PTR 2 [SI] RCL        INVALID_OPERAND_SIZE$ !error
~ AL BL RCL                       INVALID_OPERAND_COMBINATION$ !error
~ CL CR0 RCL                      INVALID_TARGET_ARCHITECTURE$ !error
~ BYTE PTR 0 [SI] DX RCL          INVALID_OPERAND_COMBINATION$ !error
~ CL AL RCR                       D2 D8 chk
~ CL BYTE PTR 1 [SI] RCR          D2 5C 01 chk
~ 1 # AL RCR                      D0 D8 chk
~ 1 # BYTE PTR 2 [SI] RCR         D0 5C 02 chk
~ 5 # AL RCR                      C0 D8 05 chk
~ 5 # BYTE PTR 3 [SI] RCR         C0 5C 03 05 chk
~ CL BX RCR                       D3 DB chk
~ CL WORD PTR 4 [SI] RCR          D3 5C 04 chk
~ CL AL ROL                       D2 C0 chk
~ CL BYTE PTR 1 [SI] ROL          D2 44 01 chk
~ 1 # AL ROL                      D0 C0 chk
~ 1 # BYTE PTR 2 [SI] ROL         D0 44 02 chk
~ 5 # AL ROL                      C0 C0 05 chk
~ 5 # BYTE PTR 3 [SI] ROL         C0 44 03 05 chk
~ CL BX ROL                       D3 C3 chk
~ CL WORD PTR 4 [SI] ROL          D3 44 04 chk
~ CL AL ROR                       D2 C8 chk
~ CL BYTE PTR 1 [SI] ROR          D2 4C 01 chk
~ 1 # AL ROR                      D0 C8 chk
~ 1 # BYTE PTR 2 [SI] ROR         D0 4C 02 chk
~ 5 # AL ROR                      C0 C8 05 chk
~ 5 # BYTE PTR 3 [SI] ROR         C0 4C 03 05 chk
~ CL BX ROR                       D3 CB chk
~ CL WORD PTR 4 [SI] ROR          D3 4C 04 chk
~ CL AL SAL                       D2 E0 chk
~ CL BYTE PTR 1 [SI] SAL          D2 64 01 chk
~ 1 # AL SAL                      D0 E0 chk
~ 1 # BYTE PTR 2 [SI] SAL         D0 64 02 chk
~ 5 # AL SAL                      C0 E0 05 chk
~ 5 # BYTE PTR 3 [SI] SAL         C0 64 03 05 chk
~ CL BX SAL                       D3 E3 chk
~ CL WORD PTR 4 [SI] SAL          D3 64 04 chk
~ CL AL SAR                       D2 F8 chk
~ CL BYTE PTR 1 [SI] SAR          D2 7C 01 chk
~ 1 # AL SAR                      D0 F8 chk
~ 1 # BYTE PTR 2 [SI] SAR         D0 7C 02 chk
~ 5 # AL SAR                      C0 F8 05 chk
~ 5 # BYTE PTR 3 [SI] SAR         C0 7C 03 05 chk
~ CL BX SAR                       D3 FB chk
~ CL WORD PTR 4 [SI] SAR          D3 7C 04 chk
~ CL AL SHL                       D2 E0 chk
~ CL BYTE PTR 1 [SI] SHL          D2 64 01 chk
~ 1 # AL SHL                      D0 E0 chk
~ 1 # BYTE PTR 2 [SI] SHL         D0 64 02 chk
~ 5 # AL SHL                      C0 E0 05 chk
~ 5 # BYTE PTR 3 [SI] SHL         C0 64 03 05 chk
~ CL BX SHL                       D3 E3 chk
~ CL WORD PTR 4 [SI] SHL          D3 64 04 chk
~ CL AL SHR                       D2 E8 chk
~ CL BYTE PTR 1 [SI] SHR          D2 6C 01 chk
~ 1 # AL SHR                      D0 E8 chk
~ 1 # BYTE PTR 2 [SI] SHR         D0 6C 02 chk
~ 5 # AL SHR                      C0 E8 05 chk
~ 5 # BYTE PTR 3 [SI] SHR         C0 6C 03 05 chk
~ CL BX SHR                       D3 EB chk
~ CL WORD PTR 4 [SI] SHR          D3 6C 04 chk
~ RDMSR                           OPERATION_NOT_SUPPORTED<586$ !error
~ RDPMC                           OPERATION_NOT_SUPPORTED<586$ !error
~ RDTSC                           OPERATION_NOT_SUPPORTED<586$ !error
~ RDTSCP                          0F 01 F9 chk
~ REP BYTE PTR MOVS               F3 A4 chk
~ REPE WORD PTR SCAS              F3 AF chk
~ REPZ DWORD PTR CMPS             INVALID_OPERAND_SIZE$ !error
~ REPNE QWORD PTR SCAS            INVALID_OPERAND_SIZE$ !error
~ REPNZ BYTE PTR CMPS             F2 A6 chk
~ RET                             C3 chk
~ FAR RET                         CB chk
~ 2000 # RET                      C2 00 20 chk
~ -1000 # FAR RET                 CA 00 F0 chk
~ RSM                             OPERATION_NOT_SUPPORTED<586$ !error
~ SAHF                            9E chk
~ AL AH SBB                       18 C4 chk
~ DX 0 [SI] SBB                   19 14 chk
~ AL BPL SBB                      I64_NOT_SUPPORTED$ !error
~ WORD PTR -123 [BP+DI] SI SBB    1B B3 DD FE chk
~ XMM7 XMM1 SBB                   XMM_NOT_SUPPORTED$ !error
~ SP SP SBB                       19 E4 chk
~ CR0 AX SBB                      INVALID_TARGET_ARCHITECTURE$ !error
~ CS DS SBB                       STANDARD_REGISTER_EXPECTED$ !error
~ BYTE PTR SCAS                   AE chk
~ WORD PTR SCAS                   AF chk
~ DWORD PTR SCAS                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR SCAS                  INVALID_OPERAND_SIZE$ !error
~ AL 0= ?SET                      0F 94 C0 chk
~ BYTE PTR 0 [SI] U< ?SET         0F 92 04 chk
~ EDX 0< ?SET                     I32_NOT_SUPPORTED$ !error
~ DWORD PTR 0 [SI] PY ?SET        INVALID_OPERAND_SIZE$ !error
~ SFENCE                          0F AE 38 chk
~ 33 # AL BL SHLD                 REGISTER_16+_EXPECTED$ !error
~ 32 # WORD PTR 0 [SI] CX SHLD    REGISTER_16+_EXPECTED$ !error
~ 31 # DX WORD PTR 0 [DI] SHLD    0F A4 15 31 chk
~ 30 # AX BX SHLD                 0F A4 C3 30 chk
~ 29 # EDX ECX SHLD               I32_NOT_SUPPORTED$ !error
~ 28 # ESI 0 [DI] SHLD            I32_NOT_SUPPORTED$ !error
~ 27 # ESI DWORD PTR 0 [DI] SHLD  I32_NOT_SUPPORTED$ !error
~ 26 # RSI RDI SHLD               I64_NOT_SUPPORTED$ !error
~ 25 # RSI QWORD PTR 0 [DI] SHLD  I64_NOT_SUPPORTED$ !error
~ CL AL BL SHLD                   REGISTER_16+_EXPECTED$ !error
~ CL WORD PTR 0 [SI] CX SHLD      REGISTER_16+_EXPECTED$ !error
~ CL DX WORD PTR 0 [DI] SHLD      0F A5 15 chk
~ CL AX BX SHLD                   0F A5 C3 chk
~ CL EDX ECX SHLD                 I32_NOT_SUPPORTED$ !error
~ CL ESI 0 [DI] SHLD              I32_NOT_SUPPORTED$ !error
~ CL ESI DWORD PTR 0 [DI] SHLD    I32_NOT_SUPPORTED$ !error
~ CL RSI RDI SHLD                 I64_NOT_SUPPORTED$ !error
~ CL RSI QWORD PTR 0 [DI] SHLD    I64_NOT_SUPPORTED$ !error
~ ES: WORD PTR 20 [BX+SI] SIDT    26 0F 01 48 20 chk
~ ES: 20 [BX+SI] SIDT             26 0F 01 48 20 chk
~ AX SLDT                         0F 00 C0 chk
~ WORD PTR 20 [BX+SI] SLDT        0F 00 40 20 chk
~ AX SMSW                         0F 01 E0 chk
~ WORD PTR 20 [BX+SI] SMSW        0F 01 60 20 chk
~ STC                             F9 chk
~ STD                             FD chk
~ STI                             FB chk
~ AX STMXCSR                      ADDRESS_32_OPERAND_EXPECTED$ !error
~ DWORD PTR 0 [SI] STMXCSR        0F AE 1C chk
~ BYTE PTR STOS                   AA chk
~ WORD PTR STOS                   AB chk
~ DWORD PTR STOS                  INVALID_OPERAND_SIZE$ !error
~ QWORD PTR STOS                  INVALID_OPERAND_SIZE$ !error
~ AX STR                          0F 00 C8 chk
~ WORD PTR 0 [DI] STR             0F 00 0D chk
~ AL AH SUB                       28 C4 chk
~ DX 0 [SI] SUB                   29 14 chk
~ AL BPL SUB                      I64_NOT_SUPPORTED$ !error
~ WORD PTR -123 [BP+DI] SI SUB    2B B3 DD FE chk
~ XMM7 XMM1 SUB                   XMM_NOT_SUPPORTED$ !error
~ SP SP SUB                       29 E4 chk
~ CR0 AX SUB                      INVALID_TARGET_ARCHITECTURE$ !error
~ CS DS SUB                       STANDARD_REGISTER_EXPECTED$ !error
~ SWAPGS                          0F 01 38 chk
~ SYSCALL                         OPERATION_NOT_SUPPORTED<586$ !error
~ SYSENTER                        OPERATION_NOT_SUPPORTED<586$ !error
~ SYSEXIT                         OPERATION_NOT_SUPPORTED<586$ !error
~ QWORD PTR SYSEXIT               INVALID_OPERAND_SIZE$ !error
~ SYSRET                          OPERATION_NOT_SUPPORTED<586$ !error
~ QWORD PTR SYSRET                INVALID_OPERAND_SIZE$ !error
~ 10 # BL TEST                    F6 C3 10 chk
~ 10 # BH TEST                    F6 C7 10 chk
~ 10 # BX TEST                    F7 C3 10 00 chk
~ 1000 # ES TEST                  STANDARD_R/M_EXPECTED$ !error
~ 10 # EBX TEST                   I32_NOT_SUPPORTED$ !error
~ 10 # RBX TEST                   I64_NOT_SUPPORTED$ !error
~ 100 # RBX TEST                  I64_NOT_SUPPORTED$ !error
~ 10 # 0 [BX+SI] TEST             OPERAND_SIZE_UNKNOWN$ !error
~ 10 # BYTE PTR 0 [BX] TEST       F6 07 10 chk
~ 1000 # WORD PTR -1000 [BP+DI] TEST    F7 83 00 F0 00 10 chk
~ 10 # QWORD PTR 0 [SI] TEST      INVALID_OPERAND_SIZE$ !error
~ 10 # AL TEST                    A8 10 chk
~ 10 # AX TEST                    A9 10 00 chk
~ 10 # EAX TEST                   I32_NOT_SUPPORTED$ !error
~ 10 # RAX TEST                   I64_NOT_SUPPORTED$ !error
~ AL AH TEST                      84 C4 chk
~ AL AX TEST                      OPERAND_SIZE_MISMATCH$ !error
~ AX SI TEST                      85 C6 chk
~ AX ES TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ DS AX TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ AX ES TEST                      STANDARD_REGISTER_EXPECTED$ !error
~ 1 # CS TEST                     STANDARD_R/M_EXPECTED$ !error
~ 10 # CR0 TEST                   INVALID_TARGET_ARCHITECTURE$ !error
~ DR7 CR7 TEST                    INVALID_TARGET_ARCHITECTURE$ !error
~ 5 # ST0 TEST                    X87_NOT_SUPPORTED$ !error
~ AX AL TEST                      OPERAND_SIZE_MISMATCH$ !error
~ EBX ESI TEST                    I32_NOT_SUPPORTED$ !error
~ RBX RSI TEST                    I64_NOT_SUPPORTED$ !error
~ ST(0) ST1 TEST                  X87_NOT_SUPPORTED$ !error
~ CR0 DR7 TEST                    INVALID_TARGET_ARCHITECTURE$ !error
~ RAX 0 [BP] TEST                 I64_NOT_SUPPORTED$ !error
~ RAX 1000 [] TEST                I64_NOT_SUPPORTED$ !error
~ BH SIL TEST                     I64_NOT_SUPPORTED$ !error
~ SPL AH TEST                     I64_NOT_SUPPORTED$ !error
~ AH R15L TEST                    I64_NOT_SUPPORTED$ !error
~ R10L CH TEST                    I64_NOT_SUPPORTED$ !error
~ UD2                             OPERATION_NOT_SUPPORTED<586$ !error
~ AX VERR                         0F 00 E0 chk
~ WORD PTR 20 [BX] VERR           0F 00 67 20 chk
~ AX VERW                         0F 00 E8 chk
~ WORD PTR 20 [BX] VERW           0F 00 6F 20 chk
~ BL CL XADD                      0F C0 D9 chk
~ AL 0 [SI] XADD                  0F C0 04 chk
~ 0 [SI] AL XADD                  STANDARD_REGISTER_EXPECTED$ !error
~ BX CX XADD                      0F C1 D9 chk
~ AX 0 [SI] XADD                  0F C1 04 chk
~ EBX ECX XADD                    I32_NOT_SUPPORTED$ !error
~ EAX 0 [SI] XADD                 I32_NOT_SUPPORTED$ !error
~ RBX R13 XADD                    I64_NOT_SUPPORTED$ !error
~ RAX 0 [SI] XADD                 I64_NOT_SUPPORTED$ !error
~ ST(0) EAX XADD                  X87_NOT_SUPPORTED$ !error
~ BX CR0 XADD                     INVALID_TARGET_ARCHITECTURE$ !error
~ AL BL XCHG                      86 C3 chk
~ BL AL XCHG                      86 C3 chk
~ AX BX XCHG                      93 chk
~ BX AX XCHG                      93 chk
~ EAX EBX XCHG                    I32_NOT_SUPPORTED$ !error
~ RAX RBX XCHG                    I64_NOT_SUPPORTED$ !error
~ AL 0 [SI] XCHG                  86 04 chk
~ AX 0 [SI] XCHG                  87 04 chk
~ EAX 0 [SI] XCHG                 I32_NOT_SUPPORTED$ !error
~ RAX 0 [SI] XCHG                 I64_NOT_SUPPORTED$ !error
~ 0 [SI] BL XCHG                  86 1C chk
~ 0 [SI] CX XCHG                  87 0C chk
~ 0 [BP] ESP XCHG                 I32_NOT_SUPPORTED$ !error
~ 0 [SI] R13 XCHG                 I64_NOT_SUPPORTED$ !error
~ XGETBV                          0F 01 D0 chk
~ XLAT                            D7 chk
~ QWORD PTR XLAT                  INVALID_OPERAND_SIZE$ !error
~ WORD PTR XLAT                   D7 chk
~ AL AH XOR                       30 C4 chk
~ DX 0 [SI] XOR                   31 14 chk
~ AL BPL XOR                      I64_NOT_SUPPORTED$ !error
~ WORD PTR -123 [BP+DI] SI XOR    33 B3 DD FE chk
~ XMM7 XMM1 XOR                   XMM_NOT_SUPPORTED$ !error
~ SP SP XOR                       31 E4 chk
~ CR0 AX XOR                      INVALID_TARGET_ARCHITECTURE$ !error
~ CS DS XOR                       STANDARD_REGISTER_EXPECTED$ !error
~ 0 [SI] XRSTOR                   0F AE 2C chk
~ 0 [SI] XRSTOR64                 OPERATION_NOT_SUPPORTED<586$ !error
~ 0 [DI] XSAVE                    0F AE 25 chk
~ 0 [DI] XSAVE64                  OPERATION_NOT_SUPPORTED<586$ !error
~ XSETBV                          0F 01 D1 chk


stackcheck
cr
bye
