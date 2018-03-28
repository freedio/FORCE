/* Vocabulary of the FORCE REPL (read-eval-print-loop) */
vocabulary InterpreterWords
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" FileIO.voc"
  requires" LogLevel.voc"
  requires" Heap.voc"
  requires" Referent.voc"
  requires" Vocabulary.voc"
  requires" Relocation.voc"
  requires" Module.voc"
  requires" ParserControl.voc"
  requires" AsmBase-IA64.voc"
  requires" MacroForcembler-IA64.voc"
  requires" Compiler.voc"
  requires" FieldVar.voc"

=== Local Helpers ===

( Initializes vocabulary @v with name v$.  This will also make it the current target vocabulary. )
: initVocabulary ( v$ @v -- )  >vocabularies targetVoc!
  SCOPE.PUBLIC FLAG.STATIC bit+ SECTION-FLAGS !  >text  SCOPE.PRIVATE FIELD-FLAGS !
  0 , ( superclass )  -1 d, ( module name offset )  0 d, ( instance size )  0 w, ( word count )
  0 w, ( voc flags )  %VOC-WORD CURRENT-FLAGS !  createWord
  currentCode!  ENTER, targetVoc# selfRef ADDR, EXIT2, currentCode#! segment> ;
( Initializes class @c with name c$ and superclass @sc.  This will also make the class the current
  vocabulary. )
: initClass ( @sc c$ @c -- )  >vocabularies targetVoc!  SCOPE.PRIVATE SECTION-FLAGS !  >text
  0 , ( superclass )  over !classDef  SCOPE.PRIVATE FIELD-FLAGS !
  over @vocabulary# selfRef  targetVoc# 0 0 createReferent  REL.ABS64 reloc,
  -1 d, ( module name offset )  swap class# d, ( instance size )  0 w, ( word count )
  1 VOC%CLASS u<< w, ( voc flags )  %VOC-WORD CURRENT-FLAGS !  createWord
  currentCode!  ENTER, targetVoc# selfRef ADDR, EXIT, currentCode#!  segment> ;
: initStruct ( @ss c$ @s -- )  >vocabularies targetVoc!  SCOPE.PUBLIC SECTION-FLAGS !  >text
  0 , ( superstruct )  over !structDef  SCOPE.PUBLIC FIELD-FLAGS !
  over @vocabulary# selfRef  targetVoc# 0 0 createReferent  REL.ABS64 reloc,
  -1 d, ( module name offset )  swap class# d, ( struct size )  0 w, ( word count )
  1 VOC%STRUCT u<< w, ( voc flags )  %VOC-WORD CURRENT-FLAGS !  createWord
  currentCode!  ENTER, targetVoc# selfRef ADDR, EXIT, currentCode#!  segment> ;

( Marks the target vocabulary as a base for classes. )
: classbase ( -- )  §TEXT #segment@ TEXT.VOCFLAGS + VOC%CLASS bit+! ;
( Marks the target vocabulary as a base for structures. )
: structbase ( -- )  §TEXT #segment@ TEXT.VOCFLAGS + VOC%STRUCT bit+! ;

=== Module, Package, Class and Vocabulary Operations ===

( Sets the package name. )
: package ( >name -- )  readWord  info? if  espace dup "$"..  then
  dup c@ 1+ PACKAGE$ swap cmove ;

( Creates vocabulary <name>, adds it to the searchlist and makes it the current target vocabulary. )
: vocabulary ( >name -- )  readWord  info? if  espace dup "$"..  then
  createVocabulary initVocabulary ;
( Finishes vocabulary. )
: vocabulary; ( -- )  info? if  cr #CURRENTWORD @ 1 "%d words."|.  then ;

( Creates class "name" with superclass @class [or 0, if the class has no superclass], adds it to the
  searchlist and makes it the current vocabulary. )
: class ( @class|0 >name -- )  readWord  info? if  espace dup "$"..  then
  createVocabulary initClass ;
: class; ( -- )  info? if  cr #CURRENTWORD @ 1 "%d words."|.  then ;

: structure ( @struct >name -- )  readWord  info? if  espace dup "$"..  then
  createVocabulary initStruct ;
: structure; ( -- )  info? if  cr #CURRENTWORD @ 1 "%d words."|.  then ;

( Dumps heap #h, or prints "empty" if -1 was specified. )
: dumpHeap ( #h|-1 -- )
  -1=?if  drop "unused.". else  heap@# ?dup unless drop "empty.".  else  hexdump  then  then ;
( Dumps the current target vocabulary. )
: dump ( -- )  cr "Current Vocabulary:". targetVoc@ dup VOCABULARY# hexdump
  #segments 0 do  cr i 1 "Segment %d: "|. s@++ dumpHeap  loop  drop ;
: #dump ( #v -- )  cr dup 1 "Vocabulary #%d"|. #vocabulary@ dup VOCABULARY# hexdump
  #segments 0 do  cr i 1 "Segment %d: "|. s@++ dumpHeap  loop  drop ;
( Lists dictionary entry @e and everything hidden behind it. )
: _dicte. ( @e -- )  begin dup while  dup DICT.WORD + @ dup &@ 2pick DICT.NAME + @ &@
  3 " «%s» → %016x (%016x)"|.  DICT.NEXT + @  repeat  drop ;
( Dumps the code of the current vocabulary. )
: code. ( -- )  cr "Code:".  cr  TEXT.VOCWORD 0 do "90 ". loop
  §TEXT #segment@# TEXT.VOCWORD +> begin dup while  "90 90 90 90 ".  4 +>
  over c@ 1+ 0 do  "90 ". 1 +> loop  over w@ >r  2 +>  "90 90 ".  r> 0 do  over c@ 1 "%02x "|.  1 +>
  loop  repeat  2drop  cr ;
( Dumps the dictionary. )
: dict. ( -- )  cr "Dictionary:".
  dictionary@# cellu/ 0 do  dup @ ?dupif  cr i 1 "D%03x"|.  _dicte.  then  cell+ loop  drop ;
( Loads vocabulary from path m$, unless already loaded, and returns its vocabulary index #v. )
: load ( m$ -- #v )  info? if  espace dup "$"..  then
  findModule
  info? if  dup 1 " → vocabulary #%d"|.  then ;
( Saves the current vocabulary under path m$ )
: save ( m$ -- )  info? if  espace dup "$".. " ...".  then
  saveModule
  info? if  " done".  then ;
( Imports module "name" and adds its vocabulary to the dictionary. )
: import ( >name -- )
  readWord  load drop ;
( Exports module "name". )
: export ( >name -- )  readWord  save ;

( Displays the vocabulary list. )
: vocabularies. ( -- )  cr "Vocabulary list:".
  vocabularies@# 0 do  @++ @vocabulary$ i cr 2 "%3d: %s"|.  loop  drop ;

=== Word Operations ===

( Sets PRIVATE scope. )
: private ( -- )  CURRENT-FLAGS dup @ 3 andn SCOPE.PRIVATE or swap ! ;
( Sets PROTECTED scope. )
: protected ( -- )  CURRENT-FLAGS dup @ 3 andn SCOPE.PROTECTED or swap ! ;
( Sets PACKAGE LOCAL scope. )
: restricted ( -- )  CURRENT-FLAGS dup @ 3 andn SCOPE.PACKAGE or swap ! ;
( Sets PUBLIC scope. )
: public ( -- )  CURRENT-FLAGS dup @ 3 andn SCOPE.PUBLIC or swap ! ;
( Sets STATIC flag. )
: static ( -- )  CURRENT-FLAGS FLAG.STATIC bit+! ;
( Sets INIT flag. )
: init ( -- )  CURRENT-FLAGS FLAG.INITCODE bit+! ;

( Transfers the current flags to the section flags and skips the rest of the line as comment. )
: section ( -- )  CURRENT-FLAGS @ SECTION-FLAGS !  skip2EOL ;

=== Punching Constants ===

( Punches short string a$ into the data segment. )
: $, ( a$ -- )  >data $, segment> ;
( Punches word referent &w into the data segment and creates an absolute relocation for it. )
: ', ( &w -- )  >data &here over , segment> REL.ABS64 reloc, ;

=== I/O Operations ===

( Prints decimal int x to console. )
: . ( x -- )  debug? if  cr  then
  n>$ $>stdout cr ;
( Prints hex int x to console. )
: h. ( x -- )  debug? if  cr  then
  hu>$ $>stdout cr ;
( Prints string a$. )
: $. ( a$ -- )  debug? if  cr  then
  $>stdout cr ;
: ^. ( -- )  .s ;
: xdump ( a # -- )  hexdump ;


( Sets alternate vocabulary name n4. )
: >altername ( n$ -- )  ALTERNAME$ $!  FULLNAME-FLAGS FFF.ALTERNATE bit+! ;
( Sets vocabulary name to always prepend. )
: prepend ( -- )  FULLNAME-FLAGS FFF.PREPEND bit+! ;
( Sets vocabulary name as a string template. )
: template ( -- )  FULLNAME-FLAGS FFF.TEMPLATE bit+! ;

( Terminates FORCE. )
: bye ( -- )  depth if  .s  then  cr BYE, ;

( Leaves the interpreter for the compiler. )
: ] ( -- )  compile ;

=== Comments ===

( Skips parenthesis-comment [nested]. )
: (openpar) ( -- )
  1 begin  readChar ?dup while  '('=?if  drop 1+  else  ')'=if  1−  then  then  dup 0= until  then
  if  "EOF while reading comment"!  then ;
( Skips a === comment bracket. )
: === ( -- )  begin  readWord "==="  $$= until ;
( Skips a --- comment bracket. )
: --- ( -- )  begin  readWord "---"  $$= until ;
( Skips a block comment. )
: /* ( -- )  begin  readWord "*/"  $$= until ;
( Skips a block comment. )
: /** ( -- )  begin  readWord "*/"  $$= until ;

=== Definitions ===

: newWord ( w$ -- )  createWord  LINKER 0! ;

( Creates address "name". )
: create ( >name -- )  readWord  info? if  espace dup $..  then
  newWord currentCode! >text ENTER_FIELD,
  CURRENT-FLAGS @ FLAG.STATIC bit? unless  DOFIELD,  else  DOVAR,  then
  EXIT_FIELD, currentCode#!  segment> ;
( Defines variable "name".  Inside a class, variables must be typed, regardless of whether they are
  static or not; inside vocabularies, a size specifier [byte, word, ...] must precede. )
: variable ( type >name -- )  readWord  info? if  espace dup $..  then  LINKER 0!
  CURRENT-FLAGS @ FLAG.STATIC bit? unless  createField  else  createVariable  then ;
( Defines constant "name" with value val. )
: constant ( val >name -- )  LINKER 0!
  depth dup >r ADP+ readWord  info? if  espace dup $..  then  createConstant  r> 1− ADP- ;
( Starts colon definition "name". )
: (colon) ( >name -- )  readWord  info? if  espace dup $..  then
  newWord currentCode! >text ENTER,  instance? if  ENTER_INSTANCE,  then  compile ;
( Starts colon definition "name" w/o the ENTER code. )
: (doublecolon) ( >name -- )  readWord  info? if  espace dup $..  then
  newWord currentCode! >text compile ;
( Creates an alias for the last defined word.  Aliases inherit the original word's features such as
  visibility, and type. )
: alias ( >name -- )  readWord  info? if  espace dup $..  then
  dup @CURRENTWORD @ SYM.ALIAS over &@ c@ 3and createSymbol symbol>dict
  @CURRENTWORD @ dup &@ c@ 3and swap rot createFullNameSymbol symbol>dict ;
( Creates a symbol for deferred word "name". )
: defer ( >name -- )  readWord  info? if  espace dup $..  then
  targetVoc# 10 deferred# createReferent SYM.DEFERRED CURRENT-FLAGS @ %WORD.SCOPE and createSymbol
  symbol>dict  Unfulfilled 1+! ;
( Resolves deferred word "name". )
: fulfills ( >name -- )  readWord info? if  espace dup $..  then  @CURRENTWORD @ swap fulfill ;

=== References ===

( Returns the referent for target word "name". )
: ' ( >name -- &w )  readWord  info? if  espace dup $..  then
  getTargetWord ;

=== Heap Allocation ===

( Reserves u bytes in the data segment of the current target vocabulary. )
: allot ( u -- )  >data allot segment> ;
( Reserves u zero bytes in the data segment of the current target vocabulary. )
: allotz ( u -- )  >data allotz segment> ;

=== Simple Types ===

: byte ( -- -1 )  -1 ;
: word ( -- -2 )  -2 ;
: dword ( -- -4 )  -4 ;
: qword ( -- -8 )  -8 ;
: ubyte ( -- 1 )  1 ;
: uword ( -- 2 )  2 ;
: udword ( -- 4 )  4 ;
: uqword ( -- 8 )  8 ;

vocabulary;
