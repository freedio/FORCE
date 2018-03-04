vocabulary Word
  requires" FORTH.voc"
  requires" Referent.voc"
  requires" Heap.voc"

=== Word Structure ===

( A word in the dictionary consists of a code field address [CFA] and a name field address [NFA];
  the CFA points to the code in the code segment, sometimes also referred to as 'text', the NFA
  points to the 32-bit flags immediately followed by the name, a counted UTF-8 string, in the text
  segment, also referred to as 'ro' [read only data].  The PFA [parameter field address] pointing to
  the parameter field of the word, is always implicit, embedded into the code of variables and
  constants. )

0000  dup constant WORD.CFA       ( Code field address )
cell+ dup constant WORD.NFA       ( Name field address )
cell+ constant WORD#

( Flags bits )
( 00-01 reserved for visibility )
02 constant WORD-STATIC           ( 0: Instance word, 1: Class word )
03 constant WORD-IMMEDIATE        ( 0: Intepreter semantics, 1: Compiler semantics )
04 constant WORD-DICTWORD         ( 0: a regular word, 1: the dictionary word )
05 constant WORD-INIT             ( 1: the initial startup word of the vocabulary )
06 constant WORD-PARAMETER        ( 0: Function word, 1: Parameter word )

( Visibility bitmasks )
00 constant %WORD-PRIVATE          ( Visibility: private )
01 constant %WORD-PROTECTED        ( Visibility: protected )
02 constant %WORD-PACKAGE          ( Visibility: package private )
03 constant %WORD-PUBLIC           ( Visibility: public )
04 bit  02 bit or
   constant %WORD-DICTWORD         ( Bit mask for the dictionary word )

=== Instance Management ===

--- Constructor ---

( Creates a word with NFA &n and CFA &c on dictionary heap #d, returning word index #w in the
  dictionary. )
: createWord ( &n &c #d -- #w )  selectedHeap >r  dup selectHeap heap% >r
  swap ,  swap ,  r>  WORD# u/ r> selectHeap ;

--- Query ---

( Returns address @cfa of the CFA of word @w. )
: @cfa ( @w -- @cfa )  WORD.CFA + ;
( Returns code field address a of word @w. )
: cfa ( @w -- a )  @cfa @ ;
( Returns address @nfa of the NFA of word @w. )
: @nfa ( @w -- @nfa )  WORD.NFA + ;
( Returns name field address a of word @w. )
: nfa ( @w -- a )  @nfa @ ;

( Checks if the code field address of word @w is a referent, returning true if so, else false. )
: ?cfa ( @w -- @w ? )  dup cfa 0- ;
( Checks if the name field address of word @w is a referent, returning true if so, else false. )
: ?nfa ( @w -- @w ? )  dup nfa 0- ;

=== Flags ===

variable STANDARD-FLAGS
variable CURRENT-FLAGS

( Returns the current word flags. )
: wordFlags@ ( -- fl )  STANDARD-FLAGS @ CURRENT-FLAGS xchg drop ;
( Sets a particular current flag. )
: wordFlag! ( fl -- )  CURRENT-FLAGS swap bit+! ;

vocabulary;
