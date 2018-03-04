vocabulary ParserControl
  requires" FORTH.voc"

variable PARSER                   ( Current parser function )
variable IMPARSER                 ( Interpreter parser )
variable COMPARSER                ( Compiler parser )

( Switches the parser to the interpreter. )
: interpret ( -- )  IMPARSER @ PARSER ! ;
( Switches the parser to the compiler. )
: compile ( -- )  COMPARSER @ PARSER ! ;

vocabulary;
