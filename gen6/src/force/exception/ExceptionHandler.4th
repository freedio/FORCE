/**
  * The exception handler structure.
  */

package /force/exception

import /force/lang/Forth
import /force/structure/Fundamental

Fundamental structure ExceptionHandler

cell variable @hander             ( Address of the handler code. )
cell variable @cleanup            ( Address of the cleanup code. )
cell variable @Resume             ( Address of the resumption code. )
cell variable RefPSP              ( Reference parameter stack pointer. )
cell variable RefRSP              ( Reference return stack pointer. )
cell variable Current             ( Current exception. )
cell variable @Next               ( Address of next code block. )
cell variable Flags               ( Exception handler flags. )

( Flags: )
00 constant Blocked               ( Throwing is blocked. )
01 constant Consumed              ( Handler has been popped from the handler stack. )

structure;
export ExceptionHandler
