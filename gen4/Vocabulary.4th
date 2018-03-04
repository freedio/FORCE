vocabulary Vocabulary
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Memory.voc"
  requires" LogLevel.voc"
  requires" Heap.voc"
  requires" Symbol.voc"
  requires" Referent.voc"
  requires" Word.voc"
  requires" Relocation.voc"
  requires" Dependency.voc"
  requires" Module.voc"
  requires" CompSearchList.voc"
  requires" CompWords.voc"

variable _@VOCABULARIES           ( Address of the vocabulary array )
256 constant #VOCABULARIES        ( Capacity of the vocabulary array )
variable VOCABULARIES%            ( Length of the vocabulary array )
-1 =variable CURRENT-VOCAB        ( The currently selected vocabulary, a.k.a working vocabulary )
-1 =variable CURRENT-SEGMENT      ( The currently selected segment, a.k.a. working segmen )

=== Vocabulary Structure ===

0000  dup constant VOCA.DICT      ( Heap index of dictionary )
cell+ dup constant VOCA.CODE      ( Heap index of the code segment )
cell+ dup constant VOCA.DATA      ( Heap index of the data segment )
cell+ dup constant VOCA.TEXT      ( Heap index of the text segment )
cell+ dup constant VOCA.RELO      ( Heap index of the relocation table )
cell+ dup constant VOCA.LSYM      ( Heap index of the local symbol table )
cell+ dup constant VOCA.GSYM      ( Heap index of the global symbol table )
cell+ dup constant VOCA.DEPT      ( Heap index of the dependency table )
cell+ dup constant VOCA.STRG      ( Heap index of the string table )
cell+ dup constant VOCA.DBUG      ( Heap index of the debug information table )
cell+ constant VOCABULARY#

0  dup constant §DICT
1+ dup constant §CODE
1+ dup constant §DATA
1+ dup constant §TEXT
1+ dup constant §RELO
1+ dup constant §LSYM
1+ dup constant §GSYM
1+ dup constant §DEPT
1+ dup constant §STRG
1+ dup constant §DBUG
1+ constant #SEGMENTS

( Returns symbol prefix p$ for vocabulary segment #s )
: symbolPrefix ( #s -- p$ )
  §DICT =?if  drop "d_" exit  then
  §CODE =?if  drop "c_" exit  then
  §DATA =?if  drop "p_" exit  then
  §TEXT =?if  drop "t_" exit  then
  drop "x_" ;

( Returns address @v[] of the vocabulary array. )
: vocabs@ ( -- @v[] )
  _@VOCABULARIES @ ?dupunless-  VOCABULARY# #VOCABULARIES u* PAGE# 16− u≥??if
    16+ >| PAGE# u/ allocPages  else  drop allocate  then  dup _@VOCABULARIES !  then ;

( Returns the heap index @v.sgmt.h of the segment pointed at by @v.@sgmt, allocating a heap if
  necessary. )
: voca.addr@ ( @v.@sgmt -- @v.sgmt.h )  dup @ -1=?if  drop createHeap dup 2pick !  then  nip ;

: voca.dict ( @v -- @v.@dict )  VOCA.DICT + ;
: voca.code ( @v -- @v.@code )  VOCA.CODE + ;
: voca.data ( @v -- @v.@data )  VOCA.DATA + ;
: voca.text ( @v -- @v.@text )  VOCA.TEXT + ;
: voca.strg ( @v -- @v.@strg )  VOCA.STRG + ;
: voca.lsym ( @v -- @v.@lsym )  VOCA.LSYM + ;
: voca.gsym ( @v -- @v.@gsym )  VOCA.GSYM + ;
: voca.relo ( @v -- @v.@relo )  VOCA.RELO + ;
: voca.dept ( @v -- @v.@dept )  VOCA.DEPT + ;
( Returns heap index @v.dict.h of the dictionary of vocabulary @v. )
: voca.dict@ ( @v -- @v.dict.h )  voca.dict voca.addr@ ;
( Returns heap index @v.code.h of the code segment of vocabulary @v. )
: voca.code@ ( @v -- @v.code.h )  voca.data voca.addr@ ;
( Returns heap index @v.data.h of the data segment of vocabulary @v. )
: voca.data@ ( @v -- @v.data.h )  voca.data voca.addr@ ;
( Returns heap index @v.text.h of the text segment of vocabulary @v. )
: voca.text@ ( @v -- @v.text.h )  voca.text voca.addr@ ;
( Returns heap index @v.strg.h of the string table of vocabulary @v. )
: voca.strg@ ( @v -- @v.strg.h )  voca.strg voca.addr@ ;
( Returns heap index @v.lsym.h of the local symbol table of vocabulary @v. )
: voca.lsym@ ( @v -- @v.lsym.h )  voca.lsym voca.addr@ ;
( Returns heap index @v.gsym.h of the global symbol table of vocabulary @v. )
: voca.gsym@ ( @v -- @v.gsym.h )  voca.gsym voca.addr@ ;
( Returns heap index @v.relo.h of the relocation table of vocabulary @v. )
: voca.relo@ ( @v -- @v.relo.h )  voca.relo voca.addr@ ;
( Returns heap index @v.dept.h of the dependency table of vocabulary @v. )
: voca.dept@ ( @v -- @v.dept.h )  voca.dept voca.addr@ ;

=== Instance Management ===

--- Constructor ---

( Allocates a vocabulary instance and stores its address at @v. )
: _createVocab ( @v -- )  VOCABULARY# allocate tuck swap !  VOCABULARY# cell/ -1 fill ;
( Creates a vocabulary instance and returns its instance number v# )
: createVocab ( -- v# )  vocabs@ dup #VOCABULARIES 0 find ?dupunless-
    cr "Error: Out of vocabulary space!".. abort  then
  VOCABULARIES% @ u>?if  dup VOCABULARIES% !  then  1- tuck cells+ _createVocab
  debug? if  cr "D: Vocabulary created."log  then ;

--- Validation Operations ---

( Validates vocabulary index v#. )
: !v# ( v# -- v# )  dup 0 #VOCABULARIES between unless-
  ecr 1 "Error: Invalid vocabulary index %d!"|.. abort  then ;
( Asserts that #v is an allocated vocabulary. )
: !!v# ( v@ -- v# )  !v#  vocabs@ over cells+ unless
  ecr 1 "Error: Vocabulary %d not allocated!"|.. abort  then ;

--- Query and Update Operations ---

( Returns vocabulary v#'s structure @v.  Aborts if the specified vocabulary does not exist. )
: vocab[] ( v# -- @v )  !v#  vocabs@ swap cells+ @ ?dupunless
    ecr 1 "Error: Vocabulary %d not allocated!"|.. abort  then ;
( Returns the current vocabulary number #v.  Aborts if no vocabulary has been selected. )
: currentVocabulary ( -- #v )  CURRENT-VOCAB @ dup 0 #VOCABULARIES between unless
    drop ecr "Error: No vocabulary selected!".. abort  then ;
( Returns the structure of the current vocabulary.  Aborts if the specified vocabulary does not
  exist. )
: currentVocabulary[] ( -- @v )  currentVocabulary vocab[] ;
( Makes vocabulary #v the current working vocabulary. )
: selectVocabulary ( #v -- )  !!v# CURRENT-VOCAB ! ;
( Returns current segment index #§ in the working vocabulary. )
: currentSegment ( -- #§ )  CURRENT-SEGMENT @ -1=?if
    drop ecr "Error: No segment selected!".. abort  then ;
( Allocates a heap for segment #§ of the working vocabulary, if necessary. )
: ?allocate ( @§ -- @§ )  dup @ -1=if  createHeap over !  then ;
( Returns name §$ of segment #§. )
: segmentName ( #§ -- §$ )
  0=?if  drop "Dictionary" exit  then
  1=?if  drop "Code Segment" exit  then
  2=?if  drop "Data Segment" exit  then
  3=?if  drop "Text Segment" exit  then
  4=?if  drop "Relocation Table" exit  then
  5=?if  drop "Local Symbol Table" exit  then
  6=?if  drop "Global Symbol Table" exit  then
  7=?if  drop "Dependency Table" exit  then
  8=?if  drop "String Table" exit  then
  9=?if  drop "DebugInfo Table" exit  then
  drop "unknown segment" exit
  1 "unknown segment #%d" |$| ;

: dumpStrings ( h# -- )
  "\t\t".  @heap% begin dup 0> while  over dup $FFF and 2 "@$%02x: «%s»"|.  over c@ 1+ +>  dup if  ", ".  then  repeat
  0<?if  err+ dup 1 "... rest corrupted, length=%d"|. err-  then  2drop ;
: dumpVoc ( #v -- #v )  cr cr dup vocab[] over 2 "Vocabulary %d @ %016x:"|.
  dup vocab[] #SEGMENTS 0 do
    dup @ -1=?unless
      dup heap# over heap% 2pick @heap 4 roll i segmentName cr 5 "%:-20s: %4d @ %015x # %d/%d"|.  else
      drop i segmentName cr 1 "%:-20s: not allocated."|.  then
    i 3=if  dup @ dumpStrings  else  i 8=if  dup @ dumpStrings  then  then
    cell+ loop  drop
  cr ;

--- Accessors ---

( Returns heap index #h of segment #§ in vocabulary #v. )
: #segment ( #v #§ -- #h )  swap vocab[] swap cells+ @ ;
( Returns heap index #h of segment #§ in the working vocabulary. )
: #workingSegment ( #§ -- #h )  currentVocabulary[] swap cells+ ?allocate @ ;

create SEGMENT-STACK  127 0allot  ( A stack for 128 saved segments )
variable SEGMENT-SP               ( The segment stack pointer )
( Returns the segment stack pointer )
: segmentSP@ ( -- a )  SEGMENT-SP dup @ ?dupunless-  SEGMENT-STACK dup 2pick !  then  nip ;
( Pushes the previous segment and makes §seg the current segment. )
: >segment ( §seg -- )  debug? if  dup segmentName cr 1 "D: Switching to %s"|log  then
  CURRENT-SEGMENT @ segmentSP@ c!  SEGMENT-SP 1+!  dup CURRENT-SEGMENT !
  #workingSegment selectHeap ;
( Restores the previous working segment. )
: segment> ( -- )  SEGMENT-SP dup 1-! @ b@
  debug? if  dup segmentName cr 1 "D: Falling back to %s"|log  then
  dup CURRENT-SEGMENT !  -1=?unless  dup #workingSegment selectHeap  then  drop ;
( Restores the predecessor of the previous working segment. )
: segment>> ( -- )  SEGMENT-SP dup 2-! @ b@
  debug? if  dup segmentName cr 1 "D: Falling 2× back to %s"|log  then
  dup CURRENT-SEGMENT !  -1=?unless  dup #workingSegment selectHeap  then  drop ;

( Returns dictionary heap index #d of vocabulary #v. )
: #dict ( #v -- #d )  vocab[] voca.dict@ ;
( Returns text segment heap index #t of vocabulary #v. )
: #text ( #v -- #t )  vocab[] voca.text@ ;
( Returns string table heap index #$ of vocabulary #v. )
: #strg ( #v -- #$ )  vocab[] voca.strg@ ;
( Returns relocation table heap index #r of vocabulary #v. )
: #relo ( #v -- #r )  vocab[] voca.relo@ ;
( Returns dependency table heap index #d of vocabulary #v. )
: #dept ( #v -- #d )  vocab[] voca.dept@ ;
( Returns heap index #§ of current segment in the working vocabulary. )
: #currentSegment ( -- #§ )  currentVocabulary[] currentSegment cells+ ?allocate @ ;
( Returns dictionary heap index #d of the working vocabulary. )
: #currentDict ( -- #d )  currentVocabulary[] voca.dict@ ;
( Returns code segment heap index #d of the working vocabulary. )
: #currentCode ( -- #c )  currentVocabulary[] voca.code@ ;
( Returns data segment heap index #d of the working vocabulary. )
: #currentData ( -- #d )  currentVocabulary[] voca.data@ ;
( Returns text segment heap index #t of the working vocabulary. )
: #currentText ( -- #t )  currentVocabulary[] voca.text@ ;
( Returns string table heap index #s of the working vocabulary. )
: #currentStrg ( -- #s )  currentVocabulary[] voca.strg@ ;
( Returns local symbol table heap index #l of the working vocabulary. )
: #currentLsym ( -- #l )  currentVocabulary[] voca.lsym@ ;
( Returns global symbol table heap index #g of the working vocabulary. )
: #currentGsym ( -- #g )  currentVocabulary[] voca.gsym@ ;
( Returns relocation table heap index #r of the working vocabulary. )
: #currentRelo ( -- #r )  currentVocabulary[] voca.relo@ ;
( Returns dependency table heap index #d of the working vocabulary. )
: #currentDept ( -- #d )  currentVocabulary[] voca.dept@ ;

( Returns the heap address of segment #§ in vocabulary #v. )
: @segment ( #v #§ -- a )  #segment @heap ;
( Returns the heap address of segment #§ in the working vocabulary. )
: @workingSegment ( #§ -- a )  #workingSegment @heap ;
( Returns the heap address of the current segment in the working vocabulary. )
: @currentSegment ( -- a )  #currentSegment @heap ;
( Returns the heap address of the dictionary of vocabulary #v. )
: @dict ( #v -- a )  #dict @heap ;
( Returns the heap address of the text segment of vocabulary #v. )
: @text ( #v -- a )  #text @heap ;
( Returns the heap address of the string table of vocabulary #v. )
: @strg ( #v -- a )  #strg @heap ;
( Returns the heap address of the dependency table of vocabulary #v. )
: @dept ( #v -- a )  #dept @heap ;
( Returns the heap address of the text segment in the working vocabulary. )
: @currentText ( -- a )  #currentText @heap ;
( Returns the heap address of the string table in the working vocabulary. )
: @currentStrg ( -- a )  #currentStrg @heap ;
( Returns the heap address of the dependency table in the working vocabulary. )
: @currentDept ( -- a )  #currentDept @heap ;

( Returns length u of the current segment in the working vocabulary. )
: currentSegment% ( -- u )  #currentSegment heap% ;
( Returns length u of the text segment of vocabulary #v. )
: text% ( #v -- u )  #text heap% ;
( Returns length u of the string table of vocabulary #v. )
: strg% ( #v -- u )  #strg heap% ;
( Returns length u of the dictionary of the working vocabulary. )
: currentDict% ( -- u )  #currentDict heap% ;
( Returns length u of the code segment of the working vocabulary. )
: currentCode% ( -- u )  #currentCode heap% ;
( Returns length u of the data segment of the working vocabulary. )
: currentData% ( -- u )  #currentData heap% ;
( Returns length u of the text segment of the working vocabulary. )
: currentText% ( -- u )  #currentText heap% ;
( Returns length u of the string segment of the working vocabulary. )
: currentStrg% ( -- u )  #currentStrg heap% ;
( Returns length u of the code segment in the working vocabulary. )
: currentCode% ( -- u )  #currentCode heap% ;

( Returns current heap address a and length u of the dictionary in vocabulary #v. )
: @dict# ( #v -- a u )  #dict dup @heap swap heap% ;
( Returns current heap address a and length u of the text segment in vocabulary #v. )
: @text# ( #v -- a u )  #text dup @heap swap heap% ;
( Returns current heap address a and length u of the string table in vocabulary #v. )
: @strg# ( #v -- a u )  #strg dup @heap swap heap% ;
( Returns current heap address a and length u of the dependency table in vocabulary #v. )
: @dept# ( #v -- a u )  #dept dup @heap swap heap% ;
( Returns current heap address a and length u of the text segment in the working vocabulary. )
: @currentText# ( -- a u )  #currentText dup @heap swap heap% ;
( Returns current heap address a and length u of the string table in the working vocabulary. )
: @currentStrg# ( -- a u )  #currentStrg dup @heap swap heap% ;
( Returns current heap address a and length u of the local symbol table in the working vocabulary. )
: @currentLsym# ( -- a u )  #currentLsym dup @heap swap heap% ;
( Returns current heap address a and length u of global symbol table in the working vocabulary. )
: @currentGsym# ( -- a u )  #currentGsym dup @heap swap heap% ;
( Returns current heap address a and length u of relocation table in the working vocabulary. )
: @currentRelo# ( -- a u )  #currentRelo dup @heap swap heap% ;

( Returns current address @w of word #w in vocabulary #v. )
: @word ( #w #v -- @w )  @dict swap WORD# u*+ ;
( Returns current address @w of word #w in the working vocabulary. )
: @localWord ( #w -- @w )  currentVocabulary @word ;

--- Segment Selectors ---

( Makes the dictionary the current working segment. )
: >dict ( -- )  §DICT >segment ;
( Makes the dictionary the current working segment, and returns its current length. )
: >dict% ( -- )  >dict currentSegment% ;
( Makes the text segment the current working segment. )
: >text ( -- )  §TEXT >segment ;
( Makes the text segment the current working segment, and returns its current length. )
: >text% ( -- )  >text currentSegment% ;
( Makes the string table the current working segment. )
: >strg ( -- )  §STRG >segment ;
( Makes the string table the current working segment, and returns its current length. )
: >strg% ( -- )  >strg currentSegment% ;
( Makes the dependency table the current working segment. )
: >dept ( -- )  §DEPT >segment ;
( Makes the dependency table the current working segment, and returns its current entry count. )
: >dept# ( -- )  >dept currentSegment% DEPENDENCY# u/ ;

=== Strings ===

( Creates a string [in the string table of the working vocabulary] from a$, and returns its string
  table offset. )
: createString ( a$ -- n# )  >strg%  swap $,  segment> ;

=== Utilities ===

variable WORD-NAME                ( The name of the current word )
create STRING  260 0allot         ( Temporary area for string building )

: @name ( #§ off -- a$ )  swap @workingSegment + ;
( Looks up string a$ in name segment of vocabulary #v.  Returns name's offset n# and true if found,
  else the original string and false. )
: ##name ( a$ #v -- n# t | a$ f )  dup >x @strg# begin dup while
  -rot 2dup $$= if -rot 2drop x> @strg − true exit then  rot over c@ 1+ +> repeat  x> 3drop false ;
( Looks up string a$ in string segment of the current vocabulary.  Returns name's offset n# and true
  if found, else the original string and false. )
: #name ( a$ -- n# t | a$ f )  currentVocabulary ##name ;
( Looks up or creates a name-string for a$ in the working vocabulary, and returns its string table
  index #n. )
: >name ( a$ -- #n )  #name unless  createString  then ;
( Looks up or creates a name-string for a$, prefixed with p$, in the working vocabulary, and returns
  its string table index #n. )
: >prefixedName ( a$ p$ -- #n )  STRING $!  STRING swap $$+ >name ;
( Looks up or creates a name-string based on the string at offset off in the text segment of the
  working vocabulary, tailored to refer to segment #§, and returns its string table index #n. )
: text>name ( #§ off -- #§ #n )
  over symbolPrefix STRING $!  §TEXT swap @name STRING swap $$+ >name ;
( Looks up local symbol with name #n in the working vocabulary, returning symbol index #s and true
  if found, else false. )
: #localSymbol ( #n -- #s t | f)  @currentLsym# SYMBOL# u/ 0 do  2dup symbol.#name =if
  2drop i unloop true exit  then  loop  2drop false ;
( Looks up or creates local symbol #s of type tp [code or data] with name #n referring to offset off
  in segment #§. )
: >localSymbol ( off #§ #n tp -- off #§ #s )  over #localSymbol if  -rot 2drop  else
  SYMBOL-LOCAL swap  3 pick  5 pick  0  6 roll  #currentLsym createSymbol  then ;
( Looks up or creates the local data symbol of the current word, returning offset off in the data
  segment, data segment #§ and symbol #s. )
: >dataSymbol ( -- off #§ #s )
  currentData% §DATA WORD-NAME @ "p_" >prefixedName SYMBOL-DATA >localSymbol ;
( Looks up or creates the local code symbol of the current word, returning offset off in the code
  segment, code segment #§ and symbol #s. )
: >codeSymbol ( -- off #§ #s )
  currentCode% §CODE WORD-NAME @ "c_" >prefixedName SYMBOL-CODE >localSymbol ;
( Creates referent &a for the current location in the working segment of the current vocabulary. )
: &here ( -- &a )  currentSegment% currentSegment 0 0 createReferent ;
( Punches referent &a into the working segment and adds an absolute cell-sized relocation for the
  current location in the working segment to the relocation table. )
: a, ( &a -- )  dup &here cell #currentRelo absrelocate , ;
( Looks up the vocabulary table for the vocabulary with name n$.  If found, returns its vocabulary
  index and true, otherwise the original name and false. )
: findVocabulary ( n$ -- #v t | n$ f )  vocabs@ VOCABULARIES% @ 0 udo
  dup @  @text over $$= if  2drop i unloop exit  then  cell+  loop  drop false ;
( Looks up or loads vocabulary with [module] name at address @nm in the dependency style format,
  where the module name immediately follows the vocabulary name.  Returns the vocabulary index, or
  aborts with a message if the vocabulary was not resident and the module could not be loaded. )
: loadVocabulary ( @nm -- #v )  findVocabulary  unless
  count + createVocab dup >r vocab[] loadModule  r> then ;
( Replaces vocabulary #v1 with #v2, the #d-th dependency of #v1.  If #d is 0, returns #v1. )
: dep@ ( #v1 #d -- #v2 )
  ?dupif  over @dept swap DEPENDENCY# u*+ dept.name#  swap @text + loadVocabulary  then ;
( Resolves referent ref to address a in the context of vocabulary #v. )
: unref ( ref #v -- a )
  over referentDependency@ dep@  over referentSegment@ @segment  swap referentOffset@ + ;
( Looks up word with name a$ in vocabulary #v.  If found, returns its word index #w and true,
  otherwise just false. )
  ( TODO: find only public words, or protected if #v is a superclass of the working vocabulary,
    or package private if #v is in the same package as the working vocabulary )
: findLocalWord ( a$ #v -- #w t | f )  tuck @dict# WORD# u/ 0 udo  dup nfa  3pick unref
  2pick $$= if  3drop i unloop true exit  then  WORD# +  loop  rot 3drop false ;
( Looks up dependency index #d of vocabulary #v in the working vocabulary.  If found, returns
  dependency index #d and true, otherwise the original vocabulary index #v and false. )
: #dependency ( #v -- #d t | #v f )  @currentText >x  @dept# DEPENDENCY# +> DEPENDENCY# u/ 0 udo
  dup dept.name# x@ + loadVocabulary 2pick =if  x> 3drop i unloop  true exit  then
  DEPENDENCY# + loop  x> 2drop false ;
( Appends the vocabulary and module name of vocabulary #v to the text segment of the working
  vocabulary and returns their offset toff in the text segment. )
: appendDepRef$ ( #v -- toff )  @text >text% swap  dup $, count + $,  segment> ;
( Looks up or creates a dependency for vocabulary #v in the working vocabulary. )
: >dependency ( #v -- #d )  #dependency unless  dup appendDepRef$ >dept#  swap ,  segment>  then ;
( Looks up global symbol with name a$ in the working vocabulary.  If found, returns symbol index #s
  and true, otherwise false. )
: #globalSymbol ( a$ -- #s t | f )  @currentGsym# SYMBOL# u/ 0 do  2dup symbol.#name =if
  2drop i unloop true exit  then  loop  2drop false ;
( Looks up or creates global external symbol #s for the dictionary of vocabulary with name a$. )
: >globalDictSymbol ( a$ -- #s )  §DICT symbolPrefix STRING $!  STRING swap $$+ #globalSymbol unless
  SYMBOL-GLOBAL SYMBOL-DATA SYMBOL-EXTERNAL 0 WORD# STRING >name #currentGsym createSymbol  then ;
( Creates a dependency to vocabulary @s and returns referent &s to its dictionary. )
: superDep, ( @s -- &s )  text@ dup >globalDictSymbol swap loadVocabulary
  >dependency 0 SYMBOL-EXTERNAL  2swap createReferent ;
( Looks up or creates [external] word symbol for word with word index #w and name a$ in vocabulary
  #v in the working vocabulary, returning its symbol index #s. )
: >wordSymbol ( #w a$ #v -- #s )
  §DICT symbolPrefix STRING $!  STRING rot $$+  STRING #globalSymbol unless
    SYMBOL-GLOBAL SYMBOL-DATA SYMBOL-EXTERNAL 5pick WORD# u* WORD# STRING >name #currentGsym
    createSymbol  then  4 -roll 3drop ;
( If top is false, aborts the compiler with a message that word a$ was not found, otherwise pops the
  "true". )
: ?wordNotFound ( &w t | a$ f -- &w )  unless  1 "Error: Word ‹%s› not found!"|! abort  then ;
( Creates the relocation entries for NFA, CFA and PFA in word with index #w in the current
  dictionary.  All field addresses with value 0 are skipped. )
( Looks up word w$ in the search path.  If found, returns a referent to the word and true, otherwise
  the original name and false.  If the word was found in a loaded module which is not a dependency
  of the working vocabulary, a new dependency entry for the vocabulary and an external global symbol
  for the word are created. )
: lookupWord ( w$ -- &w t | a$ f ) @voclist# 0 udo  2dup @ findLocalWord if
    swap @ swap  WORD# u* §DICT over 4pick 4pick >wordSymbol 3pick >dependency  createReferent
    -rot 2drop unloop  true exit  then  cell+ loop  drop false  ;
( Looks up word w$ across vocabularies and adds references, like lookupWord, but fails if the word
  was not found. )
: getWord ( w$ -- &w )  lookupWord ?wordNotFound ;
( Punches flags fl and name a$ into the current text segment and returns referent &n for it. )
: name, ( a$ fl -- &n )  over WORD-NAME !  currentText% >text swap d,  over $, segment>
  §TEXT swap >name SYMBOL-DATA >localSymbol 0 createReferent ;
( Creates the relocations for word #w. )
: wordRelocations, ( #w -- )  currentVocabulary dumpVoc drop
  dup WORD# u* swap @localWord  cr dup WORD# hexdump  dup nfa referentOffset@ >r
  ?cfa if  dup cfa 2pick @cfa §DICT r@ text>name SYMBOL-DATA >localSymbol 0 createReferent
    cell #currentRelo  absrelocate  then
  ?nfa if  dup nfa 2pick @nfa §DICT r@ text>name SYMBOL-DATA >localSymbol 0 createReferent
    cell #currentRelo  absrelocate  then
  r> 3drop ;

--- Standard Referents ---

( Returns a referent to the current location in the data segment.  Also creates the data symbol. )
: &data ( -- &d )  >dataSymbol 0 createReferent ;
( Returns a referent to the current location in the code segment.  Also creates the code symbol. )
: &code ( -- &c )  >codeSymbol 0 createReferent ;

--- Referent Resolution and Operations ---

( Resolves referent &a to physical address a. )
: resolveReferent ( &a -- a )  currentVocabulary unref ;
( Stores double-word d at address referred to referent &a. )
: &d! ( d &a -- )  resolveReferent d! ;

--- Word Operations ---

( Returns the referent of next word &w2 after &w1 in the current dictionary and true, or false if
  &w1 is the last word [so far]. )
: nextWord ( &w1 -- &w2 t | f )
  dup WORD# + swap referentOffset@ currentDict% ≠ ?dupunless  nip  then ;
( Returns the gross code size [including ENTER and EXIT code] of word &w. )
: codeSize ( &w -- u )  dup resolveReferent cfa referentOffset@ swap nextWord if
  referentOffset@  else  currentCode%  then  r− ;
( Returns the address and length of the code field of word &w,without the ENTER and EXIT code. )
: codeBlock@# ( &w -- a # )  dup cfa resolveReferent swap codeSize  ENTER# +> EXIT# − ;
( Copies relocation entry @rel with a source delta of Δ. )
: copyRelocation ( @rel Δ -- @rel )  over 2@ rot + 2, ;
( Copies the relocations referring to the code range of length # at referent &a to the a new source
  range with a Δ of d )
: copyRelocations ( &a # d -- )  >r  @currentRelo# RELOC# u/ 0 do  dup relocationSource@
  2over &within if  r@ copyRelocation  then  RELOC# + loop  r> 2drop ;
( Appends the code of word &w to the current code segment, without the leading ENTER and trailing
  EXIT part of it.  Also copies the relocations. )
: copyCode ( &w -- )  dup codeBlock@# dup allot@ swap cmove  copyRelocations ;

=== Vocabulary Operations ===

create WORD$  256 0allot

( Creates the initial empty name. )
: name0, ( -- )  >strg  0 c,  segment> ;
( Creates the null symbol in the local symbol table. )
: symbol0, ( -- )  0 0 0 0 0 0 #currentLsym createSymbol drop ;
( Creates the self-reference dependency with vocabulary name n$ and module name m$. )
: dep0, ( m$ n$ -- )  currentText%  >dept  ,  >text  $, $,  segment>> ;
( Creates the vocabulary word. )
: word0, ( -- )  >dict
  0 §CODE over text>name SYMBOL-CODE >localSymbol 0 createReferent a,
  0 §TEXT over text>name SYMBOL-CODE >localSymbol 0 createReferent a,
  >text %WORD-DICTWORD ,  segment>> ;
( Creates the superclass word from superclass reference @s. )
: superRef, ( @voc -- )  ?dupif  superDep,  "super" WORD-STATIC bit %WORD-PRIVATE or name,
  swap "_const" getWord  #currentDict createWord  wordRelocations, then ;

=== Vocabulary and Class API ===

( Creates vocabulary with module name m$ and vocabulary name n$. Returns its vocabulary index v#. )
: createVocabulary ( m$ n$ -- v# )  createVocab selectVocabulary  name0, symbol0, dep0, word0,
  currentVocabulary  debug? if  log+ dumpVoc log- then ;
( Creates class with module name m$, vocabulary name n$, and superclass @s.  Returns its vocabulary
  index v#. )
: createClass ( &s m$ n$ -- v# )  createVocabulary  swap superRef, ;
( Saves class #v to file m$. )
: saveClass ( m$ #v -- )  vocab[] #SEGMENTS rot saveModule ;
( Creates a parameter word.  Parameter words have the vocabulary name as prefix. )
: createParameterWord ( a$ -- )
  wordFlags@ WORD-PARAMETER bit+ name, &code #currentDict createWord  wordRelocations,
( Creates a function word.  Functions words have the vocabulary name as suffix. )
: createFunctionWord ( a$ -- )
  wordFlags@ WORD-PARAMETER bit- name, &code #currentDict createWord  wordRelocations,
( Creates an address word [FORTH: CREATE]. )
: createAddress ( a$ -- )  createParameterWord "create" CompWords findWord unless
  ecr "«create» not found in CompWords vocabulary."..  abort  then
  >code CompWords swap execute ;
( Creates a function word [FORTH: :]. )
: createFunction ( a$ -- )  createFunctionWord ;
( Finishes a function definition. )
: finishFunction ( -- ) ;
( Creates the initial startup function. )
: createStart ( -- )  WORD-INIT wordFlag!  createFunction ;

vocabulary;
