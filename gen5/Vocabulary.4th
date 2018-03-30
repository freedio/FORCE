/** Vocabulary Management */

vocabulary Vocabulary
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" Char.voc"
  requires" StringFormat.voc"
  requires" LogLevel.voc"
  requires" Memory.voc"
  requires" Heap.voc"
  requires" Referent.voc"
  requires" Exception.voc"

=== FORCE root ===

variable @ROOTS                   ( Heap number of list of FORCE roots )
variable #ROOTS                   ( Number of FORCE roots )

( Returns FORCE root list heap #h. )
: roots ( -- #h )  @ROOTS ?heap @ ;
( Returns address a of FORCE root list and the number of entries in the list. )
: roots@# ( -- a # )  roots heap@ #ROOTS @ ;
( Adds string with address a and length # to the roots. )
: roots+ ( a # -- )  dup dup 1+ roots heapAllot@ c!++ swap cmove  #ROOTS 1+! ;
( Lists all the roots to the console. )
: listRoots ( -- )  roots@# 0 do  dup cr 1 "• %s"|.  count +  loop  drop ;
( Returns the primary FORCE root, or aborts if no roots are specified. )
: root@ ( -- r$ )  roots@# 0=if  "No FORCE root specified!"abort  then ;

=== Vocabulary List Maintenance ===

variable @VOCABULARIES            ( Heap number of list of loaded vocabularies )

( Returns loaded vocabulary list heap #h. )
: vocabularies ( -- #h )  @VOCABULARIES ?heap @ ;
( Returns address a and number of entries # of the vocabulary list. )
: vocabularies@# ( -- a # )  vocabularies heap@# cellu/ ;
( Returns address @v of vocabulary #v. )
: #vocabulary@ ( #v -- @v )  vocabularies heap@ swap cells+ @ ;
( Returns vocabulary number #v of vocabulary @v and true, if found, else the vocabulary address and
  false. )
: @vocabulary# ( @v -- #v|-1 )  vocabularies heap@# cellu/ 0 do
  @++  2pick = if  2drop i unloop exit  then  loop  2drop -1 ;

( Adds vocabulary @v to the vocabulary list and returns its index #v. )
: >vocabularies ( @v -- #v )  vocabularies heap# swap cell vocabularies heapAllot@ !  cellu/ ;

=== Target Vocabulary and Current Segment Management ===

-1 =variable #TARGETVOC           ( Target vocabulary index in the vocabulary list )

( Returns index #v of the currnt target vocabulary. )
: targetVoc# ( -- #v )  #TARGETVOC @ -1=?ifever  "No target vocabulary appointed!"abort  then ;
( Returns address @v of the current target vocabulary. )
: targetVoc@ ( -- @v )  targetVoc# #vocabulary@ ;
( Sets the target vocabulary to #v. )
: targetVoc! ( #v -- )  #TARGETVOC ! ;

=== Vocabulary Structure ===

0000  dup constant VOC.TEXT       ( Heap index of the r/x data segment [constants and code] )
  2 + dup constant VOC.DATA       ( Heap index of the r/w data segment [static state] )
  2 + dup constant VOC.RELT       ( Heap index of the relocation table )
  2 + dup constant VOC.DEPT       ( Heap index of the dependency table )
  2 + dup constant VOC.SYMS       ( Heap index of the symbol table )
  2 + dup constant VOC.STRG       ( Heap index of the string table )
  2 + dup constant VOC.DBIN       ( Heap index of the debug information table )
  2 + constant VOCABULARY#        ( Size of the vocabulary )

( Segment index of the text segment. )
: §TEXT ( -- # )  VOC.TEXT 2u/ ;
( Segment index of the data segment. )
: §DATA ( -- # )  VOC.DATA 2u/ ;
( Segment index of the relocation table. )
: §RELT ( -- # )  VOC.RELT 2u/ ;
( Segment index of the dependency table. )
: §DEPT ( -- # )  VOC.DEPT 2u/ ;
( Segment index of the symbol table. )
: §SYMS ( -- # )  VOC.SYMS 2u/ ;
( Segment index of the string table. )
: §STRG ( -- # )  VOC.STRG 2u/ ;
( Segment index of the debug information table. )
: §DBIN ( -- # )  VOC.DBIN 2u/ ;
( Number of segments )
: #segments ( -- # )  VOCABULARY# 2u/ ;

=== Segment Management ===

-1 =variable #CURRENTSGMT         ( Index of the current segment in the target vocabulary )
create SGMTSTACK  16 0allot       ( Stack to save previous segments )
variable SGMTSTKPT                ( Segment stack pointer )

( Returns index # of the current segment in the target vocabulary. )
: #segment ( -- #seg )  #CURRENTSGMT @ -1=?ifever  "No current segment appointed!"abort  then ;
( Returns heap index #h associated with segment #seg in vocabulary @voc. )
: @#segmentHeap# ( @voc #seg -- #h )  2u* + dup s@ -1=ifever  createHeap over w!  then  s@ ;
( Returns heap start address a associated with segment #seg in vocabulary @voc. )
: @#segment@ ( @voc #seg -- a )  @#segmentHeap# heap@ ;
( Returns heap length u associated with segment #seg in vocabulary @voc. )
: @#segment# ( @voc #seg -- u )  @#segmentHeap# heap# ;
( Returns heap start address a and length u associated with segment #seg in vocabulary @voc. )
: @#segment@# ( @voc #seg -- a u )  @#segmentHeap# heap@# ;
( Returns heap index #h associated with segment #seg in the target vocabulary. )
: #segmentHeap# ( #seg -- #h )  targetVoc@ swap @#segmentHeap# ;
( Returns heap start address @h associated with segment #seg in the target vocabulary. )
: #segment@ ( #seg -- @h )  #segmentHeap# heap@ ;
( Returns heap start address a and length u associated with segment #seg in the target vocabulary. )
: #segment@# ( #seg -- a u )  #segmentHeap# heap@# ;
( Returns heap length u associated with segment #seg in the target vocabulary. )
: #segment# ( #seg -- a u )  #segmentHeap# heap# ;
( Returns heap start address a and size u associated with segment #seg in the target vocabulary. )
: #segment@## ( @voc #seg -- a u )  #segmentHeap# heap@## ;
( Returns heap index #h associated with the current target segment. )
: segmentHeap# ( -- #h )  #segment #segmentHeap# ;
( Returns heap start address @h associated with the current target segment. )
: segment@ ( -- @h )  #segment #segment@ ;
( Returns heap length u associated with the current target segment. )
: segment# ( -- u )  #segment #segment# ;
( Sets the current segment in the target vocabulary to #seg. )
: segment! ( #seg -- )  dup #CURRENTSGMT !  -1=?unless  drop segmentHeap# then  currentHeap! ;
( Saves the current segment and sets #seg as the current segment in the target vocabukary. )
: >segment ( #seg -- )  #CURRENTSGMT @ SGMTSTACK SGMTSTKPT dup b@ swap 1+! + ! segment! ;
( Restores the previous segment of the target vocabulary. )
: segment> ( -- )
  SGMTSTACK SGMTSTKPT dup 1-! @ 0<?if  "Segment stack underflow!"abort  then  + @ segment! ;

( Selects the text segment as current segment. )
: >text ( -- )  §TEXT >segment ;
( Selects the data segment as current segment. )
: >data ( -- )  §DATA >segment ;
( Selects the relocation table as current segment. )
: >relt ( -- )  §RELT >segment ;
( Selects the dependency table as current segment. )
: >dept ( -- )  §DEPT >segment ;
( Selects the symbol table as current segment. )
: >syms ( -- )  §SYMS >segment ;
( Selects the string table as current segment. )
: >strg ( -- )  §STRG >segment ;
( Selects the debug information table as current segment. )
: >dbin ( -- )  §DBIN >segment ;

=== Locations ===

( Returns referent &h to the end of the current segment. )
: &here ( -- &h )  targetVoc# #segment segment# createReferent ;
( Resolves referent &r to physical address a. )
: &@ ( &r -- a )  dup referentSegment 10=if  drop 0 exit  then
  stripReferent dup referentVocabulary #vocabulary@ over referentSegment
  15=?if  drop  else  @#segment@  then  swap referentOffset + ;
( Calculates the distance between &r1 and &r2 [&r1-&r2]. )
: &- ( &r1 &r2 -- offs )  &@ swap &@ r− ; alias &−

=== Word Handling ===

variable CURRENT-FLAGS            ( Current word flags )
variable SECTION-FLAGS            ( Current section flags )
variable FIELD-FLAGS              ( Visibility of fields )

( Word structure:
  • FLAGS   32 bits
  • NAME    8-bit counted UTF-8 string
  • CODE    16-bit counted byte array
)

( Visibility/scope: )
00 constant SCOPE.PRIVATE
01 constant SCOPE.PROTECTED
02 constant SCOPE.PACKAGE
03 constant SCOPE.PUBLIC
03 constant %WORD.SCOPE

( 30 Flags: )
( bits 0 and 1 reserved for visibility )
02 constant FLAG.ALIAS            ( 1: word is alias or deferred, CODE = 32 bit offset to code )
03 constant FLAG.IMMEDIATE        ( 1: word is immediate )
04 constant FLAG.COMPILER         ( 1: word is compile-only )
05 constant FLAG.VOCWORD          ( 1: word is vocabulary word. )
06 constant FLAG.STATIC           ( 1: word is static, 0: word is related to an instance )
07 constant FLAG.ENTER            ( 1: code has leading ENTER )
08 constant FLAG.EXIT             ( 1: code has trailing EXIT )
09 constant FLAG.EXIT2            ( 1: code has trailing EXIT2 )
10 constant FLAG.INITCODE         ( 1: word is initialization method )
11 constant FLAG.FIELD_ENTER      ( 1: word is a field with the ENTER_FIELD code )
12 constant FLAG.FIELD_EXIT       ( 1: word is a field with the EXIT_FIELD code )
13 constant FLAG.CONSTRUCTOR      ( 1: word is the constructor of the class )
14 constant FLAG.JOINER           ( 1: word starts with a PSP PUSH before a load operation on RAX )
15 constant FLAG.LINKER           ( 1: word ends with a PSP POP instruction )

--- Word Related Methods ---

( Creates word referent &w from vocabulary index #voc, segment number #seg, offset offs and word
  index #w. )
: &w ( #voc #seg offs #w -- &w )  createExtendedReferent ;
( Returns name rferent of word &w. )
: &wordName& ( &w -- &n )  4 &+ ;
( Returns name w$ of word &w. )
: &wordName$ ( &w -- w$ )  &wordName& &@ ;

( Changes the offset of referent &w so that it points at the code field. )
: word>code ( &w -- &code )  dup referentSegment 10=unless  dup &@ 4+ c@ 7+ &+  then ;
( For 0, returns a referent to the end of the target text segment, otherwise performs word>code. )
: ?word>code ( &w|0 -- &code )
  ?dupif  word>code  else  targetVoc# §TEXT dup segment# createReferent  then ;

=== Text Segment Management ===

( The text segment starts with the following constants:
  • MODULE#   32-bit offset to module name in strings segment.
  • #WORDS    16-bit number of words in the vocabulary
  • VOCWORD   First word in text segment is vocabulary word
)

0000  dup constant TEXT.SUPER     ( Superclass reference/address )
  8 + dup constant TEXT.MODULE#   ( Offset of module name in string segment )
  4 + dup constant TEXT.INSTANCE# ( Instance size )
  4 + dup constant TEXT.#WORDS    ( Number of words in the vocabulary )
  2 + dup constant TEXT.VOCFLAGS  ( Vocabulary flags )
  2 + constant TEXT.VOCWORD       ( Start of first word )

00 constant VOC%CLASS             ( Vocabulary is a class definition )
01 constant VOC%STRUCT            ( Vocabulary is a structure definition )
15 constant VOC%ERRORS            ( Errors have been occurred during vocabulary building )

--- Vocabulary Methods ---

( Returns name v$ of vocabulary @v. )
: @vocabulary$ ( @v -- v$ )  §TEXT @#segment@ TEXT.VOCWORD 4+ + ;
( Returns name v$ of vocabulary #v. )
: #vocabulary$ ( #v -- v$ )  #vocabulary@ @vocabulary$ ;

( Returns instance size u of class @c. )
: class# ( @v -- u )  §TEXT @#segment@ TEXT.INSTANCE# + d@ ;
( Adds ud to the current class size. )
: class#+ ( ud -- )  §TEXT #segment@ TEXT.INSTANCE# + d+! ;
( Returns number # of words in the current target vocabulary. )
: #words ( -- # )  §TEXT #segment@ TEXT.#WORDS + w@ ;

( Executes target word with referent &w. )
: executeTarget ( &w -- )
  word>code &@ debug? if  dup cr 1 "Executing code at address %016x."|log  then  exeqt ;

( Checks if the build failed, i.e. if the vocabulary has build errors. )
: buildFailed? ( -- ? )  §TEXT #segment@ TEXT.VOCFLAGS + VOC%ERRORS bit@ ;
( Indicates that the build of the vocabulary failed due to build errors. )
: buildFailed! ( -- )  §TEXT #segment@ TEXT.VOCFLAGS + VOC%ERRORS bit+! ;

( Makes sure that vocabulary @v is a class definition. )
: !classDef ( @v -- )  dup §TEXT @#segment@ TEXT.VOCFLAGS + VOC%CLASS bit@ unless
  @vocabulary$ 1 "Vocabulary «%s» specified as superclass is not a class definition"|!  abort  then
  drop ;
( Makes sure that vocabulary @v is a structure definition. )
: !structDef ( @v -- )  dup §TEXT @#segment@ TEXT.VOCFLAGS + VOC%STRUCT bit@ unless  @vocabulary$ 1
    "Vocabulary «%s» specified as superstruct is not a structure definition"|!  abort  then
  drop ;

=== Dictionary Management ===

variable @DICTIONARY              ( Heap number of the dictionary )
variable DICTIONARY#              ( Number of slots in the dictionary, must be a multiple of 256 )

--- Dictionary Entry Structure ---

0000  dup constant DICT.WORD      ( Referent to word )
cell+ dup constant DICT.NAME      ( Referent to name )
cell+ dup constant DICT.NEXT      ( Address of next hash entry with same hash value )
cell+ constant DICTENTRY#         ( Size of a dictionary entry )

--- Dictionary Methods ---

( Returns the dictionary heap number )
: dictionary ( -- #h )
  @DICTIONARY dup @ unlessever  PAGE# createHeap tuck heapAllot over !  512 DICTIONARY# !  then  @ ;
( Returns current address a of the dictionary. )
: dictionary@ ( -- a )  dictionary heap@ ;
( Returns current address a and length u of the dictionary. )
: dictionary@# ( -- a u )  dictionary heap@# ;

( Creates hash value u for name w$. )
: createHashValue ( w$ -- u )  count 0 -rot 0 do  c@++ rot 4<u< + swap  loop  drop
  0 8 0 do  over DICTIONARY# @ 1− and xor swap 8u>> swap  loop  nip ;
( Adds word &w to the dictionary. )
: word>dict ( &w -- )  dup &wordName$ createHashValue  DICTENTRY# allocate  dictionary@
  rot cells+ xchg @ tuck DICT.NEXT + !  over &wordName& over DICT.NAME + !  DICT.WORD + ! ;

-1 =variable PushedVoc

( Looks up word w$ in vocabulary #v; if found, returns the word referent, otherwise the original
  name. )
: findLocalWord ( #v w$ -- &w t | w$ f )  dictionary@ over createHashValue  cells+ @
  begin dup while  dup DICT.NAME + @ &@ 2pick $$=if  dup DICT.WORD + @ referentVocabulary
  3pick = if  DICT.WORD + @ nip true exit  then then  DICT.NEXT + @  repeat  rot drop ;
( Looks up word w$ in the psuhed vocabulary, or absent it in the loaded target vocabularies; if
  found, returns the word referent, otherwise the original name. )
: findTargetWord ( w$ -- &w t | w$ f )
  PushedVoc @ -1≠if  PushedVoc @ swap findLocalWord  unless
    PushedVoc @ #vocabulary$ swap 2 "Word «%s» not found in vocabulary «%s»!"|! abort  then  then
  PushedVoc -1!  dictionary@ over createHashValue  cells+ @
  begin dup while  dup DICT.NAME + @ &@ 2pick $$=if  DICT.WORD + @ nip true exit  then
  DICT.NEXT + @  repeat ;
( Returns referent &w of target word w$, or aborts with a failure if the word was not found. )
: getTargetWord ( w$ -- &w )  findTargetWord unless  1 "Word «%s» not found!"|abort  then ;

=== Symbol Table Management ===

--- Symbol Structure ---

variable Unfulfilled              ( Number of deferred words w/o resolution )

0000  dup constant SYM.VALUE      ( Symbol value )
cell+ dup constant SYM.@NAME      ( Offset of symbol name in String table )
  4 + dup constant SYM.TYPE       ( Symbol type )
  1 + dup constant SYM.SCOPE      ( Symbol scope / visibility )
  1 + constant SYMBOL#            ( Symbol size )

( Symbol type: )
00 constant SYM.FULLNAME          ( Symbol is a full-name, value = word referent )
01 constant SYM.ALIAS             ( Symbol is an alias, value = original word referent )
02 constant SYM.DEFERRED          ( Symbol refers to a word defined later in the same code. )

create ALTERNAME$ 256 0allot      ( Buffer for an alternative to the vocabulary name. )
create FULLNAME$  256 0allot      ( Buffer for the full name )
variable FULLNAME-FLAGS           ( Full name building flags. )

00 constant FFF.ALTERNATE         ( Use vocabulary name alternative rather than vocabulary name. )
02 constant FFF.PREPEND           ( Always prepend vocabulary name. )
03 constant FFF.TEMPLATE          ( Use vocabulary name as a template )

--- Constructors ---

( Creates symbol &s with name s$, value sv, type st and scope ss in the target symbol table. )
: createSymbol ( s$ sv st ss -- &s )  >syms  &here >r  rot , §STRG #segment# d, swap c, c,  segment>
  >strg dup c@ 1+ #, segment>  r> ;

( Returns symbol name referent &sn of symbol &s. )
: &symName& ( &s -- &sn )  dup referentVocabulary §STRG rot &@ SYM.@NAME + d@ createReferent ;
( Returns name s$ of symbol &s. )
: &symName$ ( &s -- s$ )  &symName& &@ ;
( Returns value sv of symbol &s. )
: &symValue ( &s -- sv )  &@ SYM.VALUE + @ ;

( Constructs full name fn$ from word name w$ and vocabulary name v$. )
: buildFullName ( w$ v$ -- fn$ )  FULLNAME-FLAGS FFF.ALTERNATE bit@ if  drop ALTERNAME$  then
  FULLNAME-FLAGS FFF.TEMPLATE bit@ if  1 swap |$|  FULLNAME$ $!  FULLNAME$ else
    over 1+ c@ lowerCase? FULLNAME-FLAGS FFF.PREPEND bit@ andn if  swap  then
    FULLNAME$ tuck $! swap $$+  then ;
( Creates full name symbol &s for word w$ with referent &w and scope ss in the target vocabulary. )
: createFullNameSymbol ( ss &w w$ -- &s )  dup c@ unless  3drop 0 exit  then ( not for empty name! )
  targetVoc# #vocabulary$  2dup $$=if  4drop 0 exit  then ( not for vocabulary name itself! )
  ( 2dup 2 cr "«%s.%s»"|. )  buildFullName  ( dup 1 " → «%s»"|. ) swap SYM.FULLNAME
  4 roll createSymbol ;
( Adds symbol &s to dictionary. )
: symbol>dict ( &s -- )  dup &symName$ createHashValue  DICTENTRY# allocate  dictionary@
  rot cells+ xchg @ tuck DICT.NEXT + !  over &symName& over DICT.NAME + !
  swap &symValue swap DICT.WORD + ! ;
( Looks up symbol s$ in the current target sybol table, returning  the address of the symbol and
  true if found, otherwise the original symbol name and false. )
: findSymbol ( s$ -- @s t | s$ f )  §STRG #segment@  §SYMS #segment@# SYMBOL# u/ 0 do ( s$ @strg @sym )
  dup SYM.@NAME + d@ ( s$ @strg @sym n# )  2pick + 3pick $$= if  -rot 2drop  unloop  true exit  then
  SYMBOL# + loop  2drop false ;

variable Deferred
( Returns the number of the next deferred word. )
: deferred# ( -- # )  Deferred dup @ swap 1+! ;

=== Dependency Management ===

--- Dependency Structure ---

0000  dup constant DEP.NAME       ( Offset of dependency name in the text segment )
  4 + dup constant DEP.INDEX      ( Index of the dependency in the vocabulary table )
  4 + constant DEPENDENCY#        ( Size of a dependency entry )

--- Dependency Table Methods ---

( Returns module name m$ of vocabulary #v, or the vocabulary index if a module name is not [yet]
  available. )
: #module$ ( #v -- m$ t | #v f )
  dup #vocabulary@ dup §TEXT @#segment@ TEXT.MODULE# + i@ -1=?ifever drop   false exit  then
  swap §STRG @#segment@ + nip true ;

( Returns the dependency table index for vocabulary #v, creating a new entry if necessary. )
: >dependency ( #v -- #d )  dup #module$ unlessever 1 "Vocabulary %d has no module name!"|abort then
  §DEPT #segment@# cellu/ 0 do  dup d@ §STRG #segment@ + 2pick $$=if  3drop i unloop exit  then
  cell+ loop  rot 2drop
  §DEPT #segment# tuck §STRG #segment#  >dept d, d, segment> >strg dup c@ 1+ #, segment> cellu/ ;

( Adds vocabulary #voc as a dependency of the target vocabulary. )
: addDependency ( #voc -- )  targetVoc# =?if  drop exit  then
  >dept  §STRG #segment# d,  dup d,  segment>
  >strg #module$ unless  1 "Vocabulary %d has no module name!"|abort  then  dup c@ 1+ #,  segment> ;
( Assert that vocabulary #voc is registered as a dependency in the target vocabulary. )
: assertDependency ( #voc -- )  §DEPT #segment@# DEPENDENCY# u/ 0 do
  dup DEP.INDEX + d@ ( #voc dep[] d# ) 2pick =if  2drop unloop exit  then  DEPENDENCY# + loop  drop
  addDependency ;

=== Word Maintenance ===

/* Word structure:

 udword FLAGS
 string NAME
  uword CODELENGTH
 #bytes CODE

 */

variable #CURRENTWORD             ( Number of complete words in the target vocabulary. )
variable @CURRENTWORD             ( Referent to first byte of the current word )
variable @CURRENTCODE             ( Referent to first byte of code being entered )

--- Constructor ---

( Creates word with name w$ in the target vocabulary, adds it to the dictionary.  If the word is
  not private, also creates its full name symbol and adds that to the dictionary. )
: createWord ( w$ -- )
  >text  &here @CURRENTWORD !  segment# >r CURRENT-FLAGS @ d,  dup c@ 1+ #, 0 w, segment>
  targetVoc# §TEXT r> #CURRENTWORD dup @ swap 1+! createExtendedReferent  dup word>dict
  CURRENT-FLAGS @ 3and if  dup dup &wordName$ CURRENT-FLAGS @ 3 and -rot createFullNameSymbol
    ?dupif symbol>dict  then then  drop
  SECTION-FLAGS @ CURRENT-FLAGS ! ;

--- Word Methods ---

( Sets the ENTER flag on the current word. )
: ENTER+ ( -- )  @CURRENTWORD @ &@ FLAG.ENTER bit+! ;
( Sets the FIELD_ENTER flag on the current word. )
: FIELD_ENTER+ ( -- )  @CURRENTWORD @ &@ FLAG.FIELD_ENTER bit+! ;
( Sets the EXIT flag on the current word. )
: EXIT+ ( -- )  @CURRENTWORD @ &@ FLAG.EXIT bit+! ;
( Sets the EXIT2 flag on the current word. )
: EXIT2+ ( -- )  @CURRENTWORD @ &@ FLAG.EXIT2 bit+! ;
( Sets the FIELD_EXIT flag on the current word. )
: FIELD_EXIT+ ( -- )  @CURRENTWORD @ &@ FLAG.FIELD_EXIT bit+! ;
( Checks if the current word is an instance method. )
: instance? ( -- ? )  @CURRENTWORD @ &@ d@ FLAG.STATIC bit? not ;

--- Current Code Methods ---

( Returns current code address a. )
: currentCode@ ( -- a )  @CURRENTCODE @ &@ ;
( Returns current code length u. )
: currentCode# ( -- u )  targetVoc@ §TEXT @#segment# @CURRENTCODE @ referentOffset − ;
( Sets the current code variable to the current location in the target vocabulary's text segment.
  The code length word is just 2 bytes back of this. )
: currentCode! ( -- )  targetVoc# §TEXT targetVoc@ over @#segment# createReferent @CURRENTCODE ! ;
( Updates the current code length. )
: currentCode#! ( -- )  currentCode# currentCode@ 2− w! ;

=== Vocabulary Management ===

( Returns the vocabulary word flags. )
: %VOC-WORD ( -- fl )  SCOPE.PUBLIC FLAG.VOCWORD bit+ ;
( Returns a reference to the vocabulary itself. )
: selfRef  15 0 createReferent ;
( Checks if &w is a vocabulary word. )
: vocWord? ( &w -- ? )  &@ FLAG.VOCWORD bit@ ;

( Looks up target vocabulary with name v$.  If found, returns its vocabulary number #v and true,
  otherwise its original name and false. )
: findTargetVocabulary ( v$ -- #v t | v$ f )
  vocabularies@# 0 do  @++ @vocabulary$ 2pick $$= if  2drop i unloop true exit  then  loop
  drop false ;

--- Constructor ---

( Creates a vocabulary and returns its address @v )
: createVocabulary ( -- @v )  VOCABULARY# dup allocate tuck -rot -1 cfill ;

: ++> ( off @w # u -- off+u @w+u #-u )  4 roll over + 4 -roll +> ;
( Adds the words and word symbols of vocabulary #v to the dictionary. )
: voc>dict ( #v -- )
  dup >x #vocabulary@ 0 TEXT.VOCWORD rot §TEXT @#segment@# TEXT.VOCWORD +> begin  dup while
    over d@ %WORD.SCOPE and SCOPE.PRIVATE =unless
      x@ §TEXT 4pick 6pick createExtendedReferent  word>dict  then
    4 ++> over c@ 1+ ++> over w@ 2+ ++>  4 roll 1+ 4 -roll repeat  4drop
  x@ #vocabulary@ §SYMS @#segment# 0 do  x@ §SYMS i createReferent symbol>dict  SYMBOL# +loop
  x> drop ;

=== Exception Handler ===

( Creates an exception handler structure in the data segment and returns its referent. )
: createExceptionHandler ( -- &h )  >data &here EXCEPT# allotz segment> ;

=== Object Related Stuff ===

( Pushes vocabulary #v. )
: pushVocabulary ( #v -- )  PushedVoc dup @ -1=unless
  "Trying to push multiple vocabularies doesn't make sense!"! abort  then  ! ;
( Handles the case where a vocabulary was pushed, then a compiler word was executed, but the
  compiler word did not use the vocabulary. )
: handleUnusedVocabulary ( -- )
  PushedVoc @ -1=?unless  #vocabulary$ 1 "Vocabulary «%s» was not used!"|!  abort  then  drop ;

( Makes sure word with referent &w is a constructor. )
: !constructor ( &w -- &w )  dup &@ FLAG.CONSTRUCTOR bit@ unless
  &wordName$ 1 "Word «%s» is supposed to be a constructor, but isn't"|! abort  then ;
( Looks up the constructor in vocaulary @v or a superclass of it, returning referent &w of the
  constructor and true, or false if none of the classes in the class hierarchy has a constructor. )
: findConstructor ( @voc -- &w t | f )
  begin  dup @vocabulary# "construct" findLocalWord  0= while
    drop  §TEXT @#segment@ TEXT.SUPER + @ 0=?if  exit  then  repeat  !constructor -rot 2drop true ;

vocabulary;
