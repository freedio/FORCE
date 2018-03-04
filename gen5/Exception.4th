vocabulary Exception
  requires" FORTH.voc"

=== Exception Handler Structure ===

0000  dup constant EXCEPT.@HCODE  ( Address of the handler code [catch] )
cell+ dup constant EXCEPT.@CCODE  ( Address of the cleanup code [finally] )
cell+ dup constant EXCEPT.@RCODE  ( Address of the resumption code [resume] )
cell+ dup constant EXCEPT.REFPSP  ( Reference parameter stack pointer )
cell+ dup constant EXCEPT.REFRSP  ( Reference return stack pointer )
cell+ dup constant EXCEPT.CURRENT ( The current exception object )
cell+ dup constant EXCEPT.NEXT    ( Address of next code block )
cell+ dup constant EXCEPT.FLAGS   ( Exception handler flags )
cell+ constant EXCEPT#            ( Size of an exception handler entry )

( Flags: )
00 constant EXCEPT_BLOCKED        ( Throwing is blocked )
01 constant EXCEPT_CONSUMED       ( Handler has been popped from the excpetion handler stack )

vocabulary;
