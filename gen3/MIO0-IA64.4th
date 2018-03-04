require G0.4th
require M0-IA64.4th

/* FORCE I/O Macros for Intel Generation 6 (64-bit)
 * ================================================
 * version 0

 * The stack comments on the macros show their net effect on the generated code, not their effect
 * when executed, as these macros must not have a stack effect unless otherwise specified.
 */

require A0-IA64.4th
also Forcembler

: PRT-STDOUT$, ( a$ -- )  BYTE PTR 0 [RAX] RDX MOVZX ( length )
  1 [RAX] RSI LEA ( @buffer )  RDI RDI XOR  RDI INC ( stdout )  RAX RAX XOR  RAX INC ( write )
  SYSCALL  DROP, ;
: PRT-STDOUT, ( a # -- )  RSI POP  RAX RDX MOVZX ( length )  RDI RDI XOR  RDI INC ( stdout )
  RAX RAX XOR  RAX INC ( write )  SYSCALL  DROP, ;
: PRT-STDERR$, ( a$ -- )  BYTE PTR 0 [RAX] RDX MOVZX ( length )
  1 [RAX] RSI LEA ( @buffer )  2 # RDI MOV ( stderr )  RAX RAX XOR  RAX INC ( write )
  SYSCALL  DROP, ;
: PRT-STDERR, ( a # -- )  RSI POP  RAX RDX MOVZX ( length )  2 # RDI MOV ( stderr )
  RAX RAX XOR  RAX INC ( write )  SYSCALL  DROP, ;

previous
