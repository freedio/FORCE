require forceemu.4th
require G0.4th

/* FORCE Compiler (64-bit)
 * =======================
 * version 0
 */

=== Primitives ===

4096 constant PAGESIZE

--- Segment related primitives ---

defer segname.

:( Returns the address of the segment descriptor of segment #seg in table a )
: seg>> ( a #seg -- a )  3 cells * + ;
:( Addresses the length field of segment descriptor a )
: .seglen ( a -- a' )  cell+ cell+ ;
:( Addresses the size field of segment descriptor a )
: .segsize ( a -- a' )  cell+ ;
:( Returns the length of segment with descriptor a )
: .seglen@ ( a -- u )  .seglen @ ;
:( Returns the size of segment with descriptor a )
: .segsize@ ( a -- u )  .segsize @ ;
:( Returns the address of the next unused byte in segment @seg )
: segend ( @seg -- a )  dup @ swap .seglen@ + ;
:( Stores # bytes from x at address a )
: punch ( a x # -- )  0 udo  ++c!>  loop  2drop ;

--- Memory Management ---

variable SSS
defer v.

: >>pages ( u -- u' )  PAGESIZE 1- + PAGESIZE / PAGESIZE * ;
:( Enlarges u so that it represents a number of full pages )
: >pages ( u -- u' )  ?dup unless  PAGESIZE  then  >>pages ;
:( Allocates or resizes segment with descriptor @seg to size u )
: allocSegment ( @seg u -- ) >pages
  ( cr ." ---------- Allocating " dup hex. ." bytes for " SSS @ segname. )
  >r dup @ ?dup if  r@ resize throw  else  r@ allocate throw  then  over !  .segsize r> swap ! ;
:( Asserts that the segment has been allocated )
: !allocated ( @seg -- @seg )  dup @ unless  dup PAGESIZE allocSegment  then ;
:( Returns the allocated segment with descriptor @seg to the system and clears the descriptor )
: freeSegment ( @seg -- )  dup @ free throw  3 cells 0 cfill ;
:( Adds # to the length of segment #seg in table @table )
: extendSegment ( # @table #seg -- )  seg>> .seglen +! ;
:( Subtracts # from the length of segment #seg in table @table )
: reduceSegment ( # @table #seg -- )  seg>> .seglen -! ;
:( Makes sure that segment @seg has at least u spare bytes left.  If not, enlarges the segment. )
: assertSpace ( @seg u -- )
  >r dup .segsize@ over .seglen@ r@ + < if  dup .seglen@ r> + allocSegment  else  r> 2drop  then ;
:( Allots u bytes at the end of segment @seg and returns the address of the allotted block )
: allotSpace ( @voc seg# u -- a )  over SSS !
  ( cr ." +++ Allocating " dup . ." bytes in " over segname. space ." of vocabulary " 2 pick addr. )
  -rot seg>> swap 2dup assertSpace  over segend ( @seg u a ) rev .seglen +! ;
:( Creates a new table with size u and returns its address )
: createTable ( u -- a )  ( cr ." Create table for " dup . ) dup allocate throw  dup rot 0 cfill ;
:( Zeroes the length of segment #seg in vocabulary @voc )
: zeroSegment ( @voc #seg -- )
  seg>> 0 swap .seglen ! ;

--- Operations on Segments ---

:( Returns the address of the segment seg# in table @table )
: @segment-address ( @table seg# -- a )  seg>>  !allocated @ ;
:( Returns the address of the end of segment seg# in table @table )
: @segment-end ( @table seg# -- a )  seg>> !allocated segend ;
:( Returns the length of segment seg# in table @table )
: segment-length ( @table seg# -- u )  seg>> .seglen@ ;
:( Returns the size of segment seg# in table @table )
: segment-size ( @table seg# -- u )  seg>> .segsize@ ;
:( Transforms address a into an offset within segment seg# in table @table )
: segment-offset ( a @table seg# -- u )  @segment-address - ;
:( Returns the address and length of segment #seg in table @table )
: segment ( @table #seg -- a # )  seg>> !allocated dup @ swap .seglen@ ;

=== Vocabulary Table Management ===

--- Vocabulary Table Structure ---

0000  dup constant @VTE         ( Address of VocTab entry segment )
cell+ dup constant #VTE         ( Size of VocTab entry segment )
cell+ dup constant VTE#         ( Length of VocTab entry segment )
cell+ constant VT#

--- Vocabulary Table ---

create VOCTAB  VT# 0allot       ( Address of the vocabulary table )

--- Vocabulary Table Operations ---

:( Returns the address of the vocabulary table )
: vocabularies@ ( -- a )  VOCTAB ;
:( Returns vocabulary table entry # )
: vte#@ ( # -- @vte )  cells vocabularies@ 0 segment-length over u> unless
    cr ." Invalid vocabulary index " cell / . abort  then
  vocabularies@ 0 @segment-address + ;
:( Creates a new vocabulary table entry with vocabulary address a )
: createVTE ( a -- )  vocabularies@ 0 cell allotSpace ! ;

=== Vocabulary Management ===

--- Vocabulary Addresses ---

variable @TARGET-VOC            ( Address of the target vocabulary )
variable TARGET-SEGMENT         ( Number of the current target segment )
variable @CURRENT-VOC           ( Address of the current vocabulary )
variable CURRENT-SEGMENT        ( Number of the current segment )
variable @NEWEST-VOC            ( Address of the last created vocabulary )

--- Vocabulary Structure ---

0000  dup constant @DICT    ( Address of vocabulary segment )
cell+ dup constant #DICT    ( Size of vocabulary segment )
cell+ dup constant DICT#    ( Length of vocabulary segment )
cell+ dup constant @CODE    ( Address of code segment )
cell+ dup constant #CODE    ( Size of code segment )
cell+ dup constant CODE#    ( Length of code segment )
cell+ dup constant @DATA    ( Address of data segment )
cell+ dup constant #DATA    ( Size of data segment )
cell+ dup constant DATA#    ( Length of data segment )
cell+ dup constant @TEXT    ( Address of text segment )
cell+ dup constant #TEXT    ( Size of text segment )
cell+ dup constant TEXT#    ( Length of text segment )
cell+ dup constant @REFS    ( Address of relocation table )
cell+ dup constant #REFS    ( Size of relocation table )
cell+ dup constant REFS#    ( Length of relocation table )
cell+ dup constant @SYMS    ( Address of local symbol table )
cell+ dup constant #SYMS    ( Size of symbol table )
cell+ dup constant SYMS#    ( Length of symbol table )
cell+ dup constant @DEPS    ( Address of dependency table )
cell+ dup constant #DEPS    ( Size of dependency table )
cell+ dup constant DEPS#    ( Length of dependency table )
cell+ constant VOCABULARY#

( Segment Numbers [#segment] )
 0 dup constant §DICT
1+ dup constant §CODE
1+ dup constant §DATA
1+ dup constant §TEXT
1+ dup constant §REFS
1+ dup constant §SYMS
1+ dup constant §DEPS
1+ constant segments

( Segment Names [segment$] )
create §DICT$ ," dictionary"
create §CODE$ ," code segment"
create §DATA$ ," data segment"
create §TEXT$ ," text segment"
create §REFS$ ," relocation table"
create §SYMS$ ," symbol table"
create §DEPS$ ," dependency table"
create SEGNAMES §DICT$ , §CODE$ , §DATA$ , §TEXT$ , §REFS$ , §SYMS$ , §DEPS$ ,

--- Vocabulary Operations ---

defer ?removeVocabulary

:( Prints the name of segment seg# )
:noname ( seg# -- )  cells SEGNAMES + @  type$ ; is segname.
:( Returns the name of vocabulary @voc )
: vocabulary$ ( @voc -- a$ )  §TEXT @segment-address ;
:( Dumps vocabulary @voc to the console )
: vocabulary. ( @voc -- )
  cr ." Vocabulary " dup vocabulary$ qtype$ '@' emit dup addr. ':' emit
  segments 0 do  cr ." • Section " i dup . cells SEGNAMES + @ qtype$ ':' emit
    2 spaces '@' emit  dup i seg>> dup @ addr. ." , size: " dup .segsize@ hex.
    ." , length: " dup .seglen @ hex. drop  loop  drop ;
:noname @TARGET-VOC @ ?dup if  vocabulary.  then ; is v.

:( Creates a vocabulary with name a$ )
: createVocabulary ( a$ -- )  VOCABULARY# createTable dup @NEWEST-VOC !  createVTE
  dup c@ 1+ @NEWEST-VOC @ §TEXT  2 pick allotSpace swap cmove ;
:( Deletes vocabulary at @voc )
: deleteVocabulary ( @voc -- )  dup ?removeVocabulary segments 0 do dup @ ?dup if
    free throw  dup 0!  dup cell+ 0!  dup cell+ cell+ 0!  then  3 cells +  loop  drop ;
:( Deletes the #th vocabulary table entry )
: deleteVTE ( # -- )  vocabularies@ 0 @segment-address over cells +
  dup @ deleteVocabulary dup @ free throw
  swap 1+ cells vocabularies@ 0 segment-length swap 2dup > if
    - over cell- -rot cmove  else  3 #drop  then  cell vocabularies@ 0 reduceSegment ;
:( Returns the #th vocabulary in the vocabulary table )
: vocabulary#@ ( # -- a )  vte#@ @ ;
:( Looks up the vocabulary with name a$ in the vocabulary table.  Returns its address @voc or 0 if
   the vocabulary was not found )
: findVocabulary ( a$ -- @voc|0 )
  vocabularies@ 0 segment cell / 0 +do
  dup @ vocabulary$ 2 pick $$= if  nip @ unloop exit  then  cell+ loop  2drop 0 ;
:( Returns the address of the newest vocabulary, if any )
: newest-voc@ ( -- a )  @NEWEST-VOC @ ?dup unlessever  cr ." No newest vocabulary!" abort  then ;

:( Sets the specified vocabulary as the target vocabulary )
: target! ( @voc -- )  @TARGET-VOC ! ;
:( Sets the last newest vocabulary as the target vocabulary )
: defs ( -- )  @NEWEST-VOC @ target! ;
:( Returns the address of the current target vocabulary, if any )
: tvoc@ ( -- @voc )  @TARGET-VOC @ ?dup unlessever  cr ." No target vocabulary set!" abort  then ;
:( Returns the current target segment number )
: tseg# ( -- seg# )  TARGET-SEGMENT @ ;
:( Returns the current target vocabulary and its target segment )
: target@ ( -- voc@ seg# )  tvoc@ tseg# ;
:( Returns the segment address of the current target segment )
: tseg@ ( -- @seg )  target@ seg>> ;
:( Sets the target segment number to seg# )
: tseg! ( seg# -- )  TARGET-SEGMENT ! ;
:( Returns the length of target segment seg# )
: tseglen ( seg# -- u )  tvoc@ swap segment-length ;

:( Selects the dictionary as the current target segment )
: >dict ( -- )  §DICT tseg! ;
:( Selects the code segment as the current target segment )
: >code ( -- )  §CODE tseg! ;
:( Selects the data segment as the current target segment )
: >data ( -- )  §DATA tseg! ;
:( Selects the text segment as the current target segment )
: >text ( -- )  §TEXT tseg! ;
:( Selects the reference table as the current target segment )
: >refs ( -- )  §REFS tseg! ;
:( Selects the symbol table as the current target segment )
: >syms ( -- )  §SYMS tseg! ;

:( Makes sure that there remain at least u bytes in the current code segment; otherwise extends the
   segment. )
: assertCodeSpace ( u -- )  tvoc@ §CODE seg>> swap assertSpace ;

=== Vocabulary Entry Management ===

VARIABLE CURRENT-WORD
: current-word@  CURRENT-WORD ?dup unless  cr ." No current word!" abort  then @ ;

--- Word Structure ---

0000  dup constant CFA    ( Code field address )
cell+ dup constant PFA    ( Parameter field address )
cell+ dup constant NFA    ( Name field address )
cell+ dup constant FLG    ( Flags )
cell+ constant WORD#

--- Word Flags ---

%0000000000000001 constant ^IMMEDIATE   ( Immediate )
%0000000000000010 constant ^ENTER       ( Code starts with ENTER )
%0000000000000100 constant ^EXIT        ( Code ends with EXIT )
%0000000000001000 constant ^PARAMETER   ( Word has a parameter field )
%0000000000100000 constant ^RELOCS      ( Code field contains relations )
%0000000001000000 constant ^MAIN        ( Module entry point )
%0000000100000000 constant ^PRIVATE     ( Private )
%0000001000000000 constant ^HERITABLE   ( Heritable )
%0000010000000000 constant ^PROTECTED   ( Protected )
%0000100000000000 constant ^PUBLIC      ( Public )
%0001000000000000 constant ^STATIC      ( Static )

variable AUTO-FLAGS

--- Word Operations ---

:( Punches a$ into the text segment of the target vocabulary and returns its text segment offset u )
: punchText ( a$ -- u )  tseg# >r >text
  dup c@ 1+ target@ 2 pick allotSpace  dup >r swap cmove  r> target@ segment-offset  r> tseg! ;
:( Creates a word with name a$ in the current target vocabulary )
: createWord ( a$ -- )  ( cr ." Creating word " dup qtype$ )
  punchText  >dict  AUTO-FLAGS @ swap §DATA tseglen §CODE tseglen  target@ WORD# allotSpace
  dup CURRENT-WORD ! !++ !++ !++ ! ;
:( Returns the address of the last created word, if any )
: last-word@ ( -- @voc @word )  tvoc@ dup §DICT 2dup segment-length WORD# -
  dup 0< if  cr ." No last word!" abort  then  -rot  @segment-address + ;
:( Creates an alias of the last word in the same vocabulary with name a$ )
: createAlias ( a$ -- )  last-word@ nip >dict target@ WORD# allotSpace  dup CURRENT-WORD !
  WORD# cmove  punchText last-word@ nip NFA + ! ;
:( Returns the number of words n in vocabulary @voc )
: #words ( @voc -- n )  §DICT segment-length WORD# / ;
:( Returns the dictionary offset of word @word in vocabulary @voc )
: .dict@ ( @voc @word -- offs )  swap §DICT segment-offset ;
:( Returns code field offset offs of word @word )
: .cfa@ ( @word -- offs )  CFA + @ ;
:( Returns parameter field offset offs of word @word )
: .pfa@ ( @word -- offs )  PFA + @ ;
:( Returns name field offset offs of word @word )
: .nfa@ ( @word -- offs )  NFA + @ ;
:( Returns flags u of word @word )
: .flg@ ( @word -- u )  FLG + @ ;
:( Adds the specified bit-mask as flag on word @word )
: .flg! ( u @word -- )  FLG + or! ;
:( Returns name a$ of word @word in vocabulary @voc )
: @name ( @voc @word -- a$ )  .nfa@ swap §TEXT @segment-address + ;
:( ORs the flag of word @word in vocabulary @voc with the specified bitmask )
: setFlag ( u @word -- )  FLG + or! ;
:( Returns a code reference of word @word in vocabulary @voc )
: code> ( @voc @word -- @voc seg# a )  over §CODE @segment-address §CODE rot .cfa@ rot + ;
:( Returns a parameter reference of word @word in vocabulary @voc )
: data> ( @voc @word -- @voc seg# a )  over §DATA @segment-address §DATA rot .pfa@ rot + ;
:( Returns a name reference of word @word in vocabulary @voc )
: name> ( @voc @word -- @voc seg# a )  over §TEXT @segment-address §TEXT rot .nfa@ rot + ;
:( Returns a dictionary reference of word @word in vocabulary @voc )
: dict> ( @voc @word -- @voc seg# a )  2dup .dict@ §DICT rev drop ;
:( Looks up the word with name a$ in vocabulary @voc )
: findLocalWord ( a$ @voc -- @word t | a$ f )  dup >B swap >B dup §DICT segment over +
  ( B@ cr ." Looking for " qtype$ space ." in vocabulary " B2@ vocabulary$ qtype$ )
  begin 2dup < while  WORD# - 2 pick over @name B@ $$= if -rot 2drop B> B> 2drop  true exit then repeat
  3 #drop B> B> drop false ;

=== Target Storage ===

--- Addresses ---

:( Returns the end address of the current target segment )
: there ( -- a )
  target@ @segment-end ;
:( Returns the length of the current target segment )
: toff ( -- u )
  target@ segment-length ;
:( Translates code segment offset off to code segment address a. )
: >there ( off -- a )  target@ @segment-address + ;

--- Punching ---

( Punching is the action of appending data to a target segment [the current segment, if none is
  specified explicitly] )

:( Punches a character into the current target segment )
: tc, ( c -- )  target@ 1 allotSpace c! ;
:( Punches a word into the current target segment )
: tw, ( w -- )  target@ 2 allotSpace w! ;
:( Punches a double word into the current target segment )
: td, ( d -- )  target@ 4 allotSpace d! ;
:( Punches a cell into the current target segment )
: t, ( x -- )  target@ cell allotSpace ! ;
:( Punches a float into the current target segment )
: tf, ( -- F: r -- )  target@ 8 allotSpace df! ;
:( Punches counted string a$ into the current target segment )
: t$, ( a$ -- )  dup c@ 1+ dup target@ rot allotSpace swap cmove ;
:( Allots u zero-bytes in the current target segment )
: tzallot, ( u -- )  target@ 2 pick allotSpace swap 0 cfill ;
:( Aligns the current target segment to a multiple of u )
: talign, ( u -- )  target@ segment-length over umod ?dup if  - dup tzallot,  then  drop ;
:( Appends cell x to the code segment of vocabulary @voc )
: code, ( x @voc -- )  §CODE cell allotSpace ! ;

=== Search Order ===

--- Search Order Table Structure ---

0000  dup constant @SEARCH-ORDER    ( Address of search order segment )
cell+ dup constant #SEARCH-ORDER    ( Size of search order segment )
cell+ dup constant SEARCH-ORDER#    ( Length of search order segment )
cell+ constant SO#

--- Search Order Table Address ---

create SEARCH-ORDER  SO# 0allot     ( The search order segment )

--- Search Order Operations ---

:( Returns the address of the search order segment )
: searchOrder@ ( -- a )  SEARCH-ORDER ;
: _removeVocabulary_ ( @voc -- @voc ta sa )  searchOrder@ 0 segment swap dup rot 0 +do
  dup @ 3 pick = if  cell+  else  @++ rot tuck ! cell+ swap  then  cell +loop ;
:( Adds vocabulary @voc to the search order.  If the vocabulary is already registered,
   moves it to the end of the order )
: addVocabulary ( @voc -- )  _removeVocabulary_
  over = if  drop searchOrder@ 0 cell allotSpace  then ! ;
:( Removes vocabulary @voc from the search order )
: removeVocabulary ( @voc -- )  _removeVocabulary_
  = unless  cell searchOrder@ 0 reduceSegment  drop
    else  cr ." Warning: vocabulary " vocabulary$ qtype$ space ." not found in search order" then ;
:( Removes vocabulary @voc if it is in the search order )
:noname ( @voc -- )  _removeVocabulary_
  = unless  cell searchOrder@ 0 reduceSegment  then  drop ; is ?removeVocabulary
:( Prints the search order )
: searchOrder. ( -- )  cr ." Search Order (top is last):"
  searchOrder@ 0 segment  0 +do  @++ vocabulary$ space type$  cell +loop  drop ;

:( Looks up the word with name a$ in all vocabularies in the search order )
: findWord ( a$ -- @voc @word t | a$ f )  searchOrder@ 0 segment tuck + swap 0 +do
  @-- rot over findLocalWord if  rot drop true unloop exit  then  -rot drop  cell +loop  drop false ;
:( Looks up the word with name a$ in all vocabularies in the search order.  If not found,
   aborts with an appriate message )
: t' ( a$ -- @voc @word )  findWord unless  cr ." Word not found: " qtype$ abort  then ;

=== Dependency Management ===

--- Dependency Entry Structure ---

0000  dup constant @DEP-NAME        ( TEXT segment offset of the dependency name )
cell+ constant DEP#

--- Dependency Methods ---

:( Adds the vocabulary with name a$ as a dependency to the current target vocabulary and returns its
   dependency index u )
: addDependency ( a$ -- u )
  punchText tvoc@ §DEPS cell allotSpace tuck ! tvoc@ §DEPS segment-offset DEP# / ;
:( Returns the number of the dependency that vocabulary @voc is in the current target vocabulary,
   or -1 if @voc is the target vocabulary itself )
: findDependency ( @voc -- u|-1 )  dup tvoc@ = if  drop -1 exit  then
  vocabulary$  tvoc@ dup §TEXT @segment-address >B §DEPS segment DEP# / 0 +do  2dup @ B@ + $$= if
    2drop B> drop i unloop exit  then  DEP# + loop  B> 2drop  addDependency ;
  ( cr ." Dependency " qtype$ space ." not found in target vocabulary " tvoc@ vocabulary$ qtype$ )
:( Prints the name of dependency n in vocabulary @voc )
: dependency. ( @voc n -- )  dup 1+ unless  drop vocabulary$ type$ exit  then
  DEP# * over §DEPS @segment-address + @ swap §TEXT @segment-address + type$ ;
:( Adds dependency file a$ providing vocabulary @voc to the current target vocabulary, if any. )
: >dependency ( a$ @voc -- )  ( cr ." >dep " over qtype$ space ." → " dup vocabulary$ qtype$ )
  vocabulary$ punchText swap punchText drop
  tvoc@ §DEPS cell allotSpace ! ;
:( Returns vocabulary address @voc2 of the uth dependency in vocabulary @voc1.  Returns @voc1 if
   n is -1 )
: dependency@ ( @voc1 n -- @voc2 ) dup -1 = if  drop exit  then
  DEP# * over §DEPS segment rot 2dup > unless
  cr ." No dependency " DEP# / . drop ." found in vocabulary " dup vocabulary$ qtype$
    tvoc@ vocabulary. abort then
  nip + @ swap §TEXT @segment-address + findVocabulary ;

=== Symbol Table Management ===

--- Symbol Table Entry Structure ---

( Structure of a symbol after its name )
0000  dup constant SYM-SIZE         ( Symbol size, or 0 if unspecified )
cell+ dup constant SYM-VALUE        ( Symbol value )
cell+ dup constant SYM-TYPE         ( Symbol type = SYM-UNKTYPE | SYM-DATA | SYM-CODE )
   1+ dup constant SYM-SCOPE        ( Symbol scope / segment )
   1+ dup constant SYM-VISIBILITY   ( Symbol visibility = SYM-PUBLIC )
   1+ dup constant SYM-REF          ( Symbol reference = SYM-INTERNAL | SYM-EXTERNAL )
   1+ constant SYM#

create SYM-NAME  256 0allot
variable WORD-NAME                  ( Address of current word's name )
( Symbol visibility )
0 constant SYM-PRIVATE              ( Private symbol )
1 constant SYM-PROTECTED            ( Protected symbol )
2 constant SYM-PUBLIC               ( Public symbol )
( Symbol type )
0 constant SYM-UNKTYPE              ( Unknown symbol type )
1 constant SYM-DATA                 ( Data object )
2 constant SYM-CODE                 ( Code object )
( Symbol reference )
0 constant SYM-INTERNAL             ( local symbol )
1 constant SYM-EXTERNAL             ( library symbol )

--- Symbol table methods ---

defer code-size

:( Composes symname$ from prefix pfix@, the name of vocabulary @voc, and the current word name )
: >symname ( pfix$ @voc -- symname$ )  0 SYM-NAME tuck c!  rot append$
  swap ?dup if  vocabulary$ append$  c" ." append$  then  WORD-NAME @ append$ ;
:( Creates a symbol with the specified parameters )
: createSymbol ( ref vis scope type value size name$ -- )
  ( cr ." Creating symbol " dup qtype$ )
  tseg# >r >syms  t$, t, t, tc, tc, tc, tc, r> tseg! ;
: createExternalSymbol ( symtype a$ -- )
  >r >r SYM-EXTERNAL SYM-PUBLIC 0 r> 0 0 r> createSymbol ;
:( Creates a dictionary symbol for the word with offset u )
: createDictSymbol ( u -- )
  >r SYM-INTERNAL SYM-PUBLIC §DICT SYM-DATA r> WORD# c" d_" tvoc@ >symname createSymbol ;
:( Creates a code symbol for the code starting at offset u with length # )
: createCodeSymbol ( u # -- )
  >r >r SYM-INTERNAL SYM-PUBLIC §CODE SYM-CODE r> r> c" c_" tvoc@ >symname createSymbol ;
:( Creates a parameter symbol for the data starting at offset u with length # )
: createDataSymbol ( u # -- )
  >r >r SYM-INTERNAL SYM-PUBLIC §DATA SYM-DATA r> r> c" p_" tvoc@ >symname createSymbol ;
:( Creates a text symbol for the text starting at offset u )
: createTextSymbol ( u -- )
  >r SYM-INTERNAL SYM-PUBLIC §TEXT SYM-DATA r> 0 c" t_" tvoc@ >symname createSymbol ;
:( Creates a symbol for the code entry point. )
: createStartSymbol ( -- )  SYM-INTERNAL SYM-PUBLIC §CODE SYM-CODE last-word@
  tuck code-size swap .cfa@ swap c" _start" createSymbol ;
:( Creates a symbol for the dictionary itself. )
: createDictionarySymbol ( -- )  tvoc@ vocabulary$ WORD-NAME !
  SYM-INTERNAL SYM-PUBLIC §DICT SYM-DATA 0 0 c" d_" tvoc@ >symname createSymbol ;
:( Creates a symbol for the code segment itself. )
: createCodeSegmentSymbol ( -- )  tvoc@ vocabulary$ WORD-NAME !
  SYM-INTERNAL SYM-PUBLIC §CODE SYM-DATA 0 0 c" c_" tvoc@ >symname createSymbol ;
:( Creates a symbol for the data segment itself. )
: createDataSegmentSymbol ( -- )  tvoc@ vocabulary$ WORD-NAME !
  SYM-INTERNAL SYM-PUBLIC §DATA SYM-DATA 0 0 c" p_" tvoc@ >symname createSymbol ;
:( Creates a symbol for the text segment itself. )
: createTextSegmentSymbol ( -- )  tvoc@ vocabulary$ WORD-NAME !
  SYM-INTERNAL SYM-PUBLIC §TEXT SYM-DATA 0 0 c" n_" tvoc@ >symname createSymbol ;
: createDictNameSymbols ( @word -- @word )
  dup .nfa@ tvoc@ §TEXT @segment-address + WORD-NAME !
  dup tvoc@ §DICT @segment-address - createDictSymbol ;
:( Creates the symbols for word @word in target vocabulary )
: createWordSymbols ( @word -- )  createDictNameSymbols
  dup .cfa@ dup rot WORD# + .cfa@ r- createCodeSymbol ;
:( Creates the symbols for last dictionary word @word in target vocabulary )
: createLastWordSymbols ( @word -- )  createDictNameSymbols
  .cfa@ dup tvoc@ §CODE segment-length r- createCodeSymbol ;
:( Creates a parameter symbol for the last defined word )
: createParameterSymbol ( -- )
  last-word@ nip dup .nfa@ tvoc@ §TEXT @segment-address + WORD-NAME !
  .pfa@ dup tvoc@ §DATA segment-length r- createDataSymbol ;
:( Creates the symbols of the last defined word )
: createSymbols ( -- )  CURRENT-WORD @ createLastWordSymbols ;
:( Looks up symbol with name sym$ in vocabulary @voc and returns its index u;
   if not found, prints a message and aborts )
: lookupSymbol ( @voc sym$ -- u )
  ( cr ." Looking up symbol " dup qtype$ space ." in vocabulary " over vocabulary$ qtype$ )
  0 >r swap §SYMS segment begin dup while
    over 3 pick $$= if  3 #drop r> exit  then  over c@ 1+ SYM# + advance#  r> 1+ >r  repeat
  2drop rdrop cr ." Symbol " qtype$ space ." not found in vocabulary " vocabulary$ qtype$ abort ;
:( Looks up symbol with name sym$ in target vocabulary and returns its index u;
   if not found, prints a message and aborts )
: findSymbol ( sym$ -- u )  tvoc@ swap lookupSymbol ;
:( Looks up symbol with index u in vocabulary @voc and returns the address of the symbol which is
   the same as the address of its name )
: symbol@ ( @voc u -- sym )  ( cr ." Looking for symbol #" dup . ." in vocabulary " over vocabulary$ qtype$ )
  dup >r over §SYMS segment begin dup 0= 3 pick 0= or 0= while
    over c@ 1+ SYM# + advance#  rot 1- -rot  repeat  ( @voc u a # )
  drop swap if  cr ." Symbol " r@ . ." not found in vocabulary " drop qtype$ abort  then  nip r> drop ;
:( Returns the number of symbols in the target vocabulary )
: countSymbols ( -- u )
  0 tvoc@ §SYMS segment begin dup while  over c@ 1+ SYM# + advance#  rot 1+ -rot  repeat  2drop ;
:( Returns code symbol sym$ for word @word in vocabulary @voc )
: >codeSymbol ( @voc @word -- @voc sym$ )
  .nfa@ over §TEXT @segment-address + WORD-NAME !  c" c_" over >symname ;
:( Appends symbol @sym to the symbol table of the target vocabulary, makes it external, and returns
   its index u )
: appendSymbol ( @sym -- u )  countSymbols swap  dup c@ 1+ SYM# + tvoc@ §SYMS 2 pick allotSpace
  dup >r swap cmove  r> count + SYM-REF + SYM-EXTERNAL swap c! ;
:( Looks up symbol with name sym$ in vocabulary @voc.  If not found, prints a message and aborts,
   otherwise copies the symbol to the target vocabulary [unless @voc IS the target vocabulary],
   makes it external, and returns its index in the target vocabulary )
: copySymbol ( @voc sym$ -- @voc u )  over tvoc@ = if  findSymbol exit  then
  over §SYMS segment begin dup while
    over 3 pick $$= if  rot 2drop appendSymbol exit  then  over c@ 1+ SYM# + advance#  repeat
  2drop cr ." Symbol " qtype$ space ." not found in vocabulary " vocabulary$ qtype$ abort ;
: dumpSymbolTable ( -- )  tvoc@ vocabulary.
  cr ." Symbol table:"  0 >r
  tvoc@ §SYMS segment  cr 2dup hexdumpf
  begin dup while  r> dup cr . 1+ >r ." @" over hex. ." : "
  over qtype$ over c@ 1+ advance#  4 spaces
  over cell+ ." Value: " @ hex.  over ." , Size: " @ . 2 cells advance# ." , Type: " over c@ .
  advance ." , Scope: " over c@ .  advance ." , Visibility: " over c@ .
  advance ." , Ref: " over c@ . advance repeat  cr ." End of dump." 2drop  r> drop ;

=== Relocation management ===

--- Relocation Entry Structure ---

0000  dup constant REL-REFOFFSET    ( Referent offset )
cell+ dup constant REL-REFSEG       ( Referent segment )
  2 + dup constant REL-FLAGS        ( Relocation flags and size )
  2 + dup constant REL-TGTSYMBOL    ( Target symbol index )
  2 + dup constant REL-TGTDEP       ( Target library or module, dependency index or -1 )
  2 + constant RE#

$0000 constant REL-ABSINT           ( Unsized absolute internal relocation )
$0008 constant REL-64               ( 64-bit relocation )
$0004 constant REL-32               ( 32-bit relocation )
$0002 constant REL-16               ( 16-bit relocation )
$0001 constant REL-8                ( 8-bit relocation )
$1000 constant REL-RELATIVE         ( 0: Absolute, 1: Relative )
$2000 constant REL-EXTERNAL         ( 0: FORTH word, 1: external symbol )

0 constant REL-TYPE-CODE            ( Code relocation, REL_RELATIVE )
1 constant REL-TYPE-DATA            ( Parameter relocation, REL_ABSOLUTE )

--- Relocation Methods ---

:( Marks the current word as sticky, i.e. not inlineable )
: sticky! ( -- )  ^RELOCS CURRENT-WORD @ .flg! ;
:( Adds a relative internal relocation entry to code field of word a$ in vocabulary @voc for referent
   at offset in code segment of target vocabulary )
: intCodeReloc, ( @voc a$ offset -- )  tvoc@ 3 pick = if  3 #drop exit  then
  tseg# >r >refs  t, §CODE tw, REL-32 REL-RELATIVE + tw,
  WORD-NAME ! c" c_" over >symname copySymbol tw, findDependency tw, r> tseg! ;
:( Adds a relative relocation entry to external symbol a$ for referent at offset in code
   segment of target vocabulary )
: extCodeReloc, ( a$ offset -- )
  tseg# >r >refs  t, §CODE tw,  REL-32 REL-EXTERNAL + REL-RELATIVE + tw,
  findSymbol tw, -1 tw, r> tseg! ;
:( Adds an absolute internal relocation entry of size # to parameter field of word a$ in vocabulary
   @voc for referent at offset in code segment of target vocabulary )
: intDataReloc, ( @voc a$ offset # -- )  tseg# >r >refs  swap t, §CODE tw, REL-ABSINT + tw,
  WORD-NAME ! c" p_" over >symname copySymbol tw, findDependency tw, r> tseg! ;
:( Adds an absolute relocation entry of size # to external symbol a$ for referent at offset in data
   segment of target vocabulary )
: extDataReloc, ( a$ offset # -- )  tseg# >r >refs 0 swap t, §CODE tw, REL-EXTERNAL + tw,
  findSymbol tw, -1 tw, r> tseg! ;
:( Adds an absolute internal relocation entry to word a$ in vocabulary @voc for referent at offset
   in the current segment of the target vocabulary )
: intDictReloc, ( @voc a$ offset -- )
  tseg# >r >refs  t, r@ tw, REL-32 REL-ABSINT + tw,
  WORD-NAME ! c" d_" over >symname copySymbol tw, findDependency tw, r> tseg!  sticky! ;
:( Adds an absolute internal relocation entry to symbol a$ in vocabulary @voc for referent at offset
   in code segment of target vocabulary )
: intReloc, ( @voc a$ offset -- )
  tseg# >r >refs  t, §CODE tw, REL-32 REL-ABSINT + tw,
  copySymbol tw, findDependency tw, r> tseg!  sticky! ;
:( Adds an absolute internal relocation entry to symbol a$ in vocabulary @voc for referent at offset
   in data segment of target vocabulary )
: indReloc, ( @voc a$ offset -- )
  tseg# >r >refs  t, §DATA tw, REL-32 REL-ABSINT + tw,
  copySymbol tw, findDependency tw, r> tseg! ;
:( Adds a relative relocation entry to symbol a$ for referent at offset in code segment of the
   target vocabulary.  If @voc is 0, the symbol is external, otherwise the symbol wih a c_ prefix is
   to be found in vocabulary @voc )
: codeReloc, ( @voc a$ offset -- )
  2 pick if  intCodeReloc,  else  rot drop extCodeReloc,  then  sticky! ;
:( Adds an absolute relocation entry of size # to symbol a$ for referent at offset in code segment
   of the target vocabulary.  If @voc is 0, the symbol is external, otherwise the symbol wih a
   p_ prefix is to be found in vocabulary @voc )
: dataReloc, ( @voc a$ offset # -- )
  3 pick if  intDataReloc,  else  extDataReloc,  then  sticky! ;
:( Adds an absolute internal relocation entry for the dictionary segment itself for referent at
   offset in the current segment of the target vocabulary. )
: @dictionaryReloc, ( offset -- )  tvoc@ vocabulary$ WORD-NAME !
  tseg# >r >refs  t, r@ tw, REL-64 tw,  c" d_" tvoc@ >symname findSymbol tw, -1 tw, r> tseg! ;
:( Adds an absolute internal relocation entry for the code segment itself for referent at
   offset in the current segment of the target vocabulary. )
: @codeSegmentReloc, ( offset -- )  tvoc@ vocabulary$ WORD-NAME !
  tseg# >r >refs  t, r@ tw, REL-64 tw,  c" c_" tvoc@ >symname findSymbol tw, -1 tw, r> tseg! ;
:( Adds an absolute internal relocation entry for the data segment itself for referent at
   offset in the current segment of the target vocabulary. )
: @dataSegmentReloc, ( offset -- )  tvoc@ vocabulary$ WORD-NAME !
  tseg# >r >refs  t, r@ tw, REL-64 tw,  c" p_" tvoc@ >symname findSymbol tw, -1 tw, r> tseg! ;
:( Adds an absolute internal relocation entry for the text segment itself for referent at
   offset in the current segment of the target vocabulary. )
: @textSegmentReloc, ( offset -- )  tvoc@ vocabulary$ WORD-NAME !
  tseg# >r >refs  t, r@ tw, REL-64 tw,  c" n_" tvoc@ >symname findSymbol tw, -1 tw, r> tseg! ;
:( Adds an absolute internal relocation entry for the data segment of vocabulary with name a$ for
   referent at offset in the current segment of the target vocabulary. )
: @vocDataSegmentReloc, ( @voc a$ offset -- )  swap WORD-NAME !
  tseg# >r >refs  t, r@ tw, REL-64 tw,  c" p_" over >symname copySymbol tw, findDependency tw,
  r> tseg! ;
:( Stores absolute value d as a relative offset from a + 4 to address a )
: reld! ( ta a # -- )  drop tuck 4 + - swap d! ;
:( Returns the value of symbol @tsym in vocabulary @voc )
: >value ( @tvoc @tsym -- a )
  count + dup SYM-VALUE + @ swap SYM-SCOPE + c@ rot swap @segment-address + ;
:( Applies relocation with flags flg and size sz referring to symbol @tsym in vocabulary @tvoc
    to location a )
: applyReloc0 ( @tvoc @tsym a flgsz -- )
  2swap 2 pick REL-EXTERNAL and if  2drop 0  else  >value  then -rot
  dup $F and swap REL-RELATIVE AND if  reld!  else  #!  then ;
:( Resolves offset u in segment #seg of vocabulary @voc to address a )
: >addr ( @voc #seg u -- a )  -rot @segment-address + ;
:( Applies relocation with flags flg and size sz referring to symbol @tsym in vocabulary @tvoc to
   offset u in segment #rseg of vocabulary @rvoc )
: applyReloc ( @tvoc @tsym flgsz @rvoc #rseg u -- )  >addr swap applyReloc0 ;
:( Resolves relocation @rel in vocabulary @voc and applies it.  External symbols will become 0 )
: unreloc ( @voc @rel -- )  2dup REL-TGTDEP + s@ dependency@ -rot ( @tvoc @rvoc @rel )
  dup REL-TGTSYMBOL + w@ 2 pick swap symbol@ -rot  dup REL-FLAGS + w@ -rot  dup REL-REFSEG + w@ swap
  REL-REFOFFSET + @ applyReloc ;
:( Clears relocation with flags flg and size sz referring to symbol @tsym in vocabulary @tvoc
    in location a )
: clearReloc0 ( @tvoc @tsym a flgsz -- )
  2swap 2drop  0 -rot $F and #! ;
:( Clears relocation with flags flg and size sz referring to symbol @tsym in vocabulary @tvoc to
   offset u in segment #rseg of vocabulary @rvoc )
: clearReloc ( @tvoc @tsym flgsz @rvoc #rseg u -- )  >addr swap clearReloc0 ;
:( Resolves relocation @rel in vocabulary @voc and applies it.  Unresolved external symbols will
   become 0 )
: dereloc ( @voc @rel -- )  2dup REL-TGTDEP + s@ dependency@ -rot ( @tvoc @rvoc @rel )
  dup REL-TGTSYMBOL + w@ 2 pick swap symbol@ -rot  dup REL-FLAGS + w@ -rot  dup REL-REFSEG + w@ swap
  REL-REFOFFSET + @ clearReloc ;

=== Assembler ===

64 constant _ADDRSIZE
64 constant _OPSIZE
64 constant _ARCH
-1 constant _X87
-1 constant _MMX
-1 constant _XMM
require A0-IA64.4th
: <[  also Forcembler ;
: ]>  previous ;

=== Compiler ===

0 CONSTANT INDIRECT-THREADED    ( Create indirect threaded code )
1 CONSTANT DIRECT-THREADED      ( Create direct threaded code )
2 CONSTANT INLINED              ( Create inlined code )
INLINED =variable CODE-MODEL
: code-model@ ( -- cm ) CODE-MODEL @ ;
: code-model! ( cm -- ) CODE-MODEL ! ;

variable @COMP-WORDS
variable @CURRENT               ( Current code location )
variable @PREVIOUS              ( Previous code location )
variable INTVALUE               ( Last int value, if any )
variable CURRENTINT?            ( whether the current contribution is an int value )
variable LASTINT?               ( whether the last contribution was an int value )
variable CURRENTCOND            ( whether the current contribution is a condition )
variable CONDITION              ( whether the last contribution was a condition )

7 constant ENTER#               ( The length of the ENTER code in bytes )
8 constant EXIT#                ( The length of the EXIT code in bytes )
15 constant MAX-INLINE          ( Maximum net code size to inline )

:( Removes recent code back to @PREVIOUS )
: backup ( -- )  @PREVIOUS @ tvoc@ §CODE seg>> .seglen ! ;
:( Sets @CURRENT to the current location in the code segment )
: setCurrent ( -- )  toff @CURRENT ! ;
:( Copies the current / int / condition into previous and clears the current / int / condition )
: nextRound ( -- )  0 CURRENTCOND dup @ CONDITION ! !  0 CURRENTINT? dup @ LASTINT? ! !
  @CURRENT @ @PREVIOUS !  setCurrent ;
:( Checks if the flags have the ^ENTER bit set )
: enters? ( flags -- ? )  ^ENTER and ;
:( Checks if the flags have the ^EXIT bit set )
: exits? ( flags -- ? )  ^EXIT and ;
:( Returns the word immediately following @word1 in vocabulary @voc as @word2, or 0 if @word1 is the
   last word in the vocabulary )
: nextWord ( @voc @word1 -- @word2 )  WORD# + dup rot §DICT @segment-end ≠ and ;
:( Returns the word immediately following @word1 in vocabulary @voc as @word2, or 0 if @word1 is the
   last word in the vocabulary )
: nextNonAlias ( @voc @word1 -- @word2 )  begin  2dup nextWord ?dup unless  2drop 0 exit  then  ( @voc @word1 @word2 )
  2dup .cfa@ swap .cfa@ = while  ( @voc @word1 @word2 ) nip  repeat  -rot 2drop ;
:( Returns the net code length [i.e. w/o ENTER and terminal EXIT] of word @word in vocabulary @voc )
:noname ( @voc @word -- u )
  2dup nextNonAlias ?dup if  .cfa@ rot drop  else  swap §CODE segment-length  then
  swap dup .flg@ swap .cfa@ over enters? if  ENTER# +  then  swap exits? if  EXIT# +  then  - ;
  is code-size
:( Appends the net content of the code field of word @word in vocabulary @voc [already known to have
   length u] to the current target code segment.  The net content is the code after the ENTER code
   [if present] )
: copyCode ( @voc @word u -- )  rev tvoc@ §CODE 4 pick allotSpace  swap §CODE @segment-address
  rot dup .flg@ ^ENTER and 0- ENTER# and swap .cfa@ + + rev cmove ;
:( Appends a call to the code field of word @word in vocabulary @voc )
also Forcembler
: callWord ( @voc @word -- )  depth 2- dup >B ADP+
  2dup @name swap .cfa@ ( 2 pick §CODE @segment-address + ) <[ ## CALL ]>  B> ADP- ;
previous
:( Appends the code of reference word @rword in reference vocabulary @rvoc to the current target
   segment.  This makes sense only if the current target segment is the code segment!  If the code
   of the reference word is longer than MAX-INLINE, or if its code field contains relocations, a
   call to its code field is inserted instead. )
: word-inline, ( @rvoc @rword -- )
  2dup code-size dup MAX-INLINE > 2 pick .flg@ ^RELOCS and or if drop callWord else copyCode then ;
:( Appends the CFA of reference word @rword in reference vocabulary @rvoc to the current target
   segment, along with a relocation table entry.  This makes sense only if the current target
   segment is the code segment! )
: word-direct, ( @rvoc @rword -- )
  2dup over -rot @name toff intCodeReloc, .cfa@ swap tseg# cell allotSpace ! ;
:( Appends the offset of reference word @rword in reference vocabulary @rvoc to the current target
   segment, along with a relocation table entry )
: word-indirect, ( @rvoc @rword -- )
  2dup over -rot @name toff intDictReloc,  .dict@ tvoc@ tseg# cell allotSpace ! ;
:( Appends [a reference to] the code field of word @word in @voc to the code of the current word.
   Depending on the code model [indirect | direct thread, inlined] either a pointer or a call to
   the code, or the net code [without leading ENTER and trailing EXIT] is inserted )
:( Appends the word with address @word in vocabulary @voc to the current target code segment )
: punchWord ( @voc @word -- )  code-model@ case
  INDIRECT-THREADED of  word-indirect,  endof
  DIRECT-THREADED of  word-direct,  endof
  INLINED of  word-inline,  endof
  cr ." Unrecognized code model: " . abort  endcase ;

:( Executes compiler word a$ )
: compExec ( a$ -- )  dup count @COMP-WORDS @ search-wordlist if  nip
    depth 1- dup >B [ also Forcembler ] ADP+ execute B> ADP- [ previous ] exit  then
  cr ." Compiler word " qtype$ space ." not found!"  abort ;

:( Appends the address of word @rword in vocabulary @rvoc as a word literal to the code of the
   current word.  This makes sense only if the current target segment is the code segment! )
: wordaddr-inline, ( @rvoc @rword -- )
  2dup @name WORD-NAME !  c" d_" 2 pick >symname nip  c" LITA," compExec ;
:( Appends the CFA of reference word @rword in reference vocabulary @rvoc to the current target
   segment, along with a relocation table entry.  This makes sense only if the current target
   segment is the code segment! )
: wordaddr-direct, ( @rvoc @rword -- )
  ( TODO we currently don't fully support this code model
    2dup over -rot @name toff intCodeReloc, .cfa@ swap tseg# cell allotSpace ! ) ;
:( Appends the offset of reference word @rword in reference vocabulary @rvoc to the current target
   segment, along with a relocation table entry )
: wordaddr-indirect, ( @rvoc @rword -- )
  ( TODO we currently don;t fully support this code model
    2dup over -rot @name toff intDictReloc,  .dict@ tvoc@ tseg# cell allotSpace ! ) ;
:( Appends [a reference to] the code field of word @word in @voc to the code of the current word.
   Depending on the code model [indirect | direct thread, inlined] either a pointer or a call to
   the code, or the net code [without leading ENTER and trailing EXIT] is inserted )
:( Appends a literal for loading the word with address @word in vocabulary @voc to the code of the
   current word. )
: punchWordAddress ( @voc @word -- )  code-model@ case
  INDIRECT-THREADED of  wordaddr-indirect,  endof
  DIRECT-THREADED of  wordaddr-direct,  endof
  INLINED of  wordaddr-inline,  endof
  cr ." Unrecognized code model: " . abort  endcase ;

: int-indirect, ( n -- )  c" lit" findWord if  punchWord t, exit  then
  cr ." Word not found: " qtype$ abort ;
: int-direct, ( n -- )  c" lit" findWord if  punchWord t, exit  then
  cr ." Word not found: " qtype$ abort ;
: int-inline, ( n -- )  dup n.size case
  0 of  c" LIT0,"  endof
  1 of  c" LIT1,"  endof
  2 of  c" LIT2,"  endof
  3 of  c" LIT4,"  endof
  4 of  c" LIT8,"  endof
  cr ." Invalid literal size: " . abort  endcase
  compExec ;

variable STRING#
create STRING-NAME  256 allot
: >SYMNAME ( u -- )  tvoc@ vocabulary$ dup c@ 1+ STRING-NAME swap cmove
  '$' STRING-NAME count + c! STRING-NAME dup c1+! count + swap
  0 <<# #s #> dup STRING-NAME c+! rot swap cmove
  #>>  STRING-NAME WORD-NAME ! ;
: str-indirect, ( off -- )  c" addr" findWord if  punchWord t, exit  then
  cr ." Word not found: " qtype$ abort ;
: str-direct, ( off -- )  c" addr" findWord if  punchWord t, exit  then
  cr ." Word not found: " qtype$ abort ;
: str-inline, ( off -- )  STRING# dup @ swap 1+! >SYMNAME createTextSymbol tvoc@ SYM-NAME
  ( cr ." Symbol " dup qtype$ )  c" LITA," compExec ;

:( Appends integer literal n to the current target code segment )
: punchInt ( n -- )  dup INTVALUE !  CURRENTINT? ON  code-model@ case
  INDIRECT-THREADED of  int-indirect,  endof
  DIRECT-THREADED of  int-direct,   endof
  INLINED of  int-inline,  endof
  cr ." Unrecognized code model: " . abort  endcase ;

: float-indirect, ( -- F: r -- )  c" float" findWord if  punchWord tf, exit  then
  cr ." Word not found: " qtype$ abort ;
: float-direct, ( -- F: r -- )  c" float" findWord if  punchWord tf, exit  then
  cr ." Word not found: " qtype$ abort ;
: float-inline, ( -- F: r -- )  c" LITR," compExec ;
:( Appends  float literal r to the current target code segment )
: punchFloat ( -- F: r -- )  code-model@ case
  INDIRECT-THREADED of  float-indirect,  endof
  DIRECT-THREADED of  float-direct,  endof
  INLINED of  float-inline,  endof
  cr ." Unrecognized code model: " . abort  endcase ;

:( Appends charactere literal c to the current target code segment )
: punchChar ( c -- )  dup INTVALUE !  CURRENTINT? ON    code-model@ case
  INDIRECT-THREADED of  int-indirect,  endof
  DIRECT-THREADED of  int-direct,  endof
  INLINED of  int-inline,  endof
  cr ." Unrecognized code model: " . abort  endcase ;

:( Appends string literal a$ to the current text segment and compiles address loading. )
: punchString ( a$ -- )  >text target@ segment-length swap t$, >code  code-model@ case
  INDIRECT-THREADED of  str-indirect,  endof
  DIRECT-THREADED of  str-direct,   endof
  INLINED of  str-inline,  endof
  cr ." Unrecognized code model: " . abort  endcase ;

:( Appends string literal a$ to the current data segment. )
: punchString, ( a$ -- )  >data t$, ;

=== Source Management ===

--- Source Buffer ---

variable @BUFFER                    ( Address of the input buffer )
variable CURSOR                     ( Input buffer cursor )
variable LENGTH                     ( Input buffer length )
variable FILEID                     ( Current source file ID )
variable @FILENAME                  ( Address of the current source file name )
variable QUOTELOCK                  ( Parser NOT locked on double-quote? )

:( Closes the current source file and frees the associated buffer )
: closeFile ( -- )  FILEID dup @ ?dup if  close-file throw  then  0!
  @BUFFER dup @ ?dup if  free throw  then  0!  @FILENAME dup @ ?dup if  free throw  then  0! ;
:( Opens the file with the specified name )
: openFile ( a$ -- )  dup c@ 1+  dup allocate throw  dup @FILENAME !  swap cmove
  @FILENAME @ count r/o open-file throw FILEID !  CURSOR 0!  LENGTH 0! ;

--- Source Stack ---

create BUFFER-STACK  PAGESIZE allot ( The input buffer stack )
variable @BFR-STACK  BUFFER-STACK @BFR-STACK !

:( Checks if there are files on the stack )
: ?source ( -- ? )  @BFR-STACK @ BUFFER-STACK u> ;
:( Pushes the current source file on the input buffer stack )
: >source ( -- )
  @BUFFER @ CURSOR @ LENGTH @ FILEID @ @FILENAME @ @BFR-STACK @ !++ !++ !++ !++ !++ @BFR-STACK !
  @BUFFER 0!  CURSOR 0!  LENGTH 0!  FILEID 0!  @FILENAME 0! ;
:( Pops the last source file from the buffer stack )
: source> ( -- )  closeFile  ?source if
  @BFR-STACK @ --@ --@ --@ --@ --@ @BFR-STACK ! @FILENAME ! FILEID ! LENGTH ! CURSOR ! @BUFFER ! then ;

--- Input ---

:( Read from the specified source file )
: source ( a$ -- )  FILEID @ if  >source  then  openFile ;
:( Closes the source file and drops it from the source stack if appropriate )
: unsource ( -- )  source> ;
:( Checks if the input buffer has no more characters left )
: exhausted ( -- ? )  CURSOR @ LENGTH @ = ;
:( Floods the input buffer with the next page of data from the current file. )

: floodInputBuffer0 ( -- )  @BUFFER @ ?dup unlessever  PAGESIZE allocate throw dup @BUFFER !  then
  PAGESIZE FILEID @ read-file throw LENGTH !  CURSOR 0! ;
:( Floods the inout buffer if no more characters are left in the buffer )
: ?floodInputBuffer ( -- )  exhausted ifever  floodInputBuffer0  then ;
:( Floods the input buffer, over file boundaries if necessary )
: floodInputBuffer ( -- )
  floodInputBuffer0  begin  exhausted ?source and while  source>  ?floodInputBuffer  repeat ;
:( Returns the next character from the input source, or 0 if no more characters are available )
: nextChar ( -- c|0 )  exhausted ifever  floodInputBuffer  then
  CURSOR dup @ dup LENGTH @ u< unless  2drop 0  else  @BUFFER @ + c@ swap 1+!  then ;
:( Checks if the next character is a blank.  EOF is not a blank )
: ?blank ( c -- t | f )  $01 $21 within QUOTELOCK @ and ;
:( Pushes back the last character on the input stream )
: pushback ( -- )
  CURSOR 1-! ;
:( Switches the quote lock state if character c is a double-quote. )
: ?" ( c -- c )  dup $22 = if  QUOTELOCK ON  then ;
: "? ( a -- a )  nextchar ?dup if  $22 = if  $22 !c++ QUOTELOCK OFF  else  pushback  then  then ;

=== REPL ===

variable @EVAL

--- Read ---

create BUFFER  PAGESIZE allot           ( The "current word" buffer )

:( Initializes the input buffer and returns the next write address )
: buffer0!  ( -- a )  0 BUFFER c!++ ;
:( Skips blanks in the input stream until none are available anymore )
: >>bl ( -- )  begin  nextChar ?blank 0= until  pushback ;
:( Reads a whitespace-delimited word from the input source and returns it as a$ and true,
   or end of file and false )
: readWord ( -- a$ )  QUOTELOCK ON
  buffer0!  >>bl "? begin  nextChar ?" dup ?blank 0= over 0- and while  !c++  repeat  drop
(  QUOTELOCK @ if  $22 !c++  QUOTELOCK OFF  then )
  BUFFER 1+ - BUFFER tuck c! ;
:( Reads a c-delimited string from the input source and returns it in a$; a$ being an empty string
   upon end of file )
: readString ( c -- a$ )
  buffer0!  >>bl  begin over nextChar dup 0- -rot tuck ≠ rot and while  !c++  repeat  drop nip
  BUFFER 1+ - BUFFER tuck c! ;
: comment-bracket ( a$ -- )  begin readWord 2dup ( a$ in$ a$ in$)  c@ 0-  -rot $$= and until  drop ;

--- Eval ---

10 =variable RADIX      ( Default base )
variable XSIGN          ( -1: negate, 0: keep )
variable XRADIX         ( 10, 16, 2, n, default 10 )
variable XLEN           ( original buffer length )
variable XADDR          ( original buffer address )
variable XFAIL          ( -1: failed, 0: successful )
variable XINT           ( value of integer number )
variable XDIGITS        ( Digit count of XINT )
variable XINTPART       ( integer part of a float )
variable XFRACTION      ( fractional part of a float )
variable XPONENT        ( Absolute value of a float's exponent )
variable XPSIGN         ( sign of a float's exponent )
variable XMANTSGN       ( Sign of the mantissa )
variable XFRACSIZE      ( Digit count of fraction )
create X$  256 allot    ( String buffer )

: >intPart ( -- )  XINT @ XINTPART ! ;
: >fraction ( -- )  XINT @ XFRACTION !  XDIGITS @ XFRACSIZE ! ;
: >exponent ( -- )  XINT @ XPONENT ! ;
: >mantSign ( -- )  XSIGN @ XMANTSGN ! ;
: >expSign ( -- )  XSIGN @ XPSIGN ! ;

: next ( a # -- a+1 #-1 )  1- swap 1+ swap ;
: eatQuote ( a # -- a' #' )  -1 XFAIL !  2dup if  c@ $27 = if  0 XFAIL ! next  then else drop then ;
: eat" ( a # -- a' #' )  -1 XFAIL !  2dup if  c@ $22 = if  0 XFAIL ! next  then else drop then ;
: eatEsc ( a # -- a' #' c )  next  2dup if c@ case
  '0' of   0  endof
  'a' of   7  endof
  'b' of   8  endof
  'e' of  27  endof
  'f' of  12  endof
  'n' of  10  endof
  'r' of  13  endof
  't' of   9  endof
  dup endcase  else drop 0 then ;
: eatChar ( a # -- a' #' )
  -1 XFAIL !  2dup if  c@ dup '\' = if  drop eatEsc then  XINT !  0 XFAIL ! next  else  drop  then ;
: eatSign ( a # -- a' #' )  2dup if  c@ case
  '+' of   0 XSIGN ! next  endof
  '-' of  -1 XSIGN ! next  endof
  $2212 of  -1 XSIGN ! next  endof
  endcase  else drop then ;
: eatRadix ( a # -- a' # )  2dup if  c@ case
  '#' of  10 XRADIX ! next  endof
  '$' of  16 XRADIX ! next  endof
  '&' of   8 XRADIX ! next  endof
  '%' of   2 XRADIX ! next  endof
  endcase  else drop then ;
: eatRadix2 ( a # -- a' #' )  2dup if  over + 1- c@ case
  'H' of  XRADIX @ 17 < if  16 XRADIX ! 1- then  endof
  'h' of  XRADIX @ 17 < if  16 XRADIX ! 1- then  endof
  'D' of  XRADIX @ 13 < if  10 XRADIX ! 1- then  endof
  'd' of  XRADIX @ 13 < if  10 XRADIX ! 1- then  endof
  'B' of  XRADIX @ 11 < if   2 XRADIX ! 1- then  endof
  'b' of  XRADIX @ 11 < if   2 XRADIX ! 1- then  endof
  endcase  else drop then ;
: eatPoint ( a # -- a' #' )  over c@ '.' = if  next  then ;
: eatExponent ( a # -- a' #' )  over c@ dup 'e' = swap 'E' = or if  next  then ;
create DIGITS  ," 0123456789ABCDEF"
:( Returns the digit [according to DIGITS] for the specified character, or -1 if not a valid digit )
: >digit ( c -- u )  DIGITS count 0 do 2dup c@ = if  2drop i unloop exit  then  1+ loop  2drop -1 ;
: eatDigits ( a # -- a' #' )  -1 XFAIL !  0 XDIGITS !
  begin  2dup while
    c@ dup '`' > $20 and - >digit dup 0 XRADIX @ within unless  drop exit  then
    0 XFAIL !  XDIGITS 1+!  XINT @ XRADIX @ * + XINT ! next  repeat  drop ;
: eatChars ( a # -- a' #' )  XFAIL @ unless  0 X$ c!  begin 2dup while  c@ $22 = if  exit  then
  eatChar  XINT @ X$ count + c! X$ c1+! repeat  drop then ;
: xsetup ( a # -- a # -- a # f )
  2dup XLEN ! XADDR !  0 XSIGN !  RADIX @ XRADIX !  0 XINT !  0 XFAIL !  dup unless  2exit  then ;
: xfinish ( a # -- a' #' f | t )  nip  XFAIL @ or if  XADDR @ XLEN @ false  else  true  then ;
:( Tries to convert buffer a with length # to an int.  Returns the int and true if successful, else
   the buffer and false )
: $setup ( a # -- a # -- a # f )  dup 255 > if  cr ." String too long!" abort  then
  2dup XLEN ! XADDR !  0 XFAIL !  dup unless  2exit  then ;
: >int ( a # -- n|u t | a # f )  xsetup  eatSign  eatRadix  eatRadix2  eatDigits  xfinish
  dup if  XINT @ XSIGN @ if  negate then  swap  then ;
create CLAUSE-BUILDER  256 allot
:( Creates a float from the integer part, fraction part, sign, exponent and exponent sign )
create FLOATREPR  128 allot      ( A buffer for building a standard representation of the float )
: makeFloat ( -- F: -- r )  XINTPART @ s>d d>f  XFRACTION @ s>d d>f  10 s>d d>f
  XFRACSIZE @ s>d d>f f** f/ f+  XMANTSGN @ if fnegate then  10 s>d d>f  XPONENT @ s>d d>f  f** f* ;
:( Tries to convert buffer a with length # to a float.  Returns the float and true if successful,
   else the buffer and false )
: >float ( a # -- r t | a # f )
  xsetup  eatSign >mantSign  eatDigits >intPart  eatPoint  eatDigits >fraction  eatExponent
  eatSign >expSign  eatDigits  >exponent  xfinish dup if  makeFloat swap  then ;
:( Tries to convert buffer a with length # to a char.  Returns the char and true if successful,
   else the buffer and false )
: >char ( a # -- c t | a # f )  xsetup eatQuote eatChar eatQuote xfinish dup if  XINT @ swap  then ;
: >string ( a # -- a$ t | a # f )  $setup  eat" eatChars eat" xfinish  dup if  X$ swap  then ;
: findClause ( a # -- a' #' f | xt t )  XFAIL @ if  2drop XADDR @ XLEN @ false exit  then
  dup 1+ CLAUSE-BUILDER c!++ '#' !c++ swap cmove
  CLAUSE-BUILDER count @COMP-WORDS @ search-wordlist dup unless  XADDR @ XLEN @ rot  then ;
: findClause$ ( a # -- a' #' f | xt t )  XFAIL @ if  2drop XADDR @ XLEN @ false exit  then
  dup 1+ CLAUSE-BUILDER c!++ '}' !c++ swap cmove
  CLAUSE-BUILDER count @COMP-WORDS @ search-wordlist dup unless  XADDR @ XLEN @ rot  then ;
: >intClause ( a # -- n|u xt t | a # f )  xsetup  eatSign  eatRadix  eatDigits
  findClause  dup if  XINT @ XSIGN @ if  negate then  -rot  then ;
: >charClause ( a # -- n|u xt t | a # f )  xsetup  eatQuote eatChar eatQuote
  findClause  dup if  XINT @ XSIGN @ if  negate then  -rot  then ;
: >stringClause ( a # -- a$ xt t | a # f )
  $setup  eat" eatChars eat" findClause$  dup if  X$ -rot  then ;
: >cellClause ( a # -- n|u xt t | a # f )  xsetup  -1 XFAIL !  over 4 c" cell" count compare
  unless  0 XFAIL !  swap 4 + swap 4 -  then  findClause  dup if  cell  -rot  then ;
:( Processes interpreter word a$ )
: interpret ( a$ -- )  cr ." Interpreting " dup qtype$  count 2dup find-name
  ?dup if  -rot 2drop name>int execute  exit  then
  >int if  exit  then
  >float if  exit  then
  >char if  exit  then
  >stringClause if  execute exit  then
  2dup drop 1- findVocabulary ?dup if  nip exit  then
  cr ." Word not found: " qtype abort ;
:( Processes compiler word a$ )
: compile ( a$ -- )  nextRound
  cr ." Compiling " dup qtype$  findWord if  punchWord exit  then
  count >int if  punchInt exit  then
  >float if  punchFloat exit  then
  >char if  punchChar exit  then
  >string if  punchString exit  then
  >intClause if  ( cr ." Executing int clause " over . CLAUSE-BUILDER qtype$ )  execute exit  then
  >charClause if  ( cr ." Executing char clause " over . CLAUSE-BUILDER qtype$ )  execute exit  then
  >stringClause if  swap punchString  execute exit  then
  >cellClause if  ( cr ." Executing clause cell " CLAUSE-BUILDER qtype$ )  execute exit  then
  2dup @COMP-WORDS @ search-wordlist if  -rot  ( cr ." Executing " 2dup qtype )
    2drop [ also Forcembler ] depth 1- dup >B ADP+ execute B> ADP- [ previous ] exit  then
  cr ." Word not found: " qtype abort ;

--- Print ---

--- Loop ---

=== Module Management ===

( A module is a serialized vocabulary )

0000  dup constant @MODN                ( Module name table )
cell+ dup constant #MODN                ( Length of the module name table )
cell+ dup constant MODN#                ( Size of the module name table )
cell+ constant MODULES#

variable MODULES                        ( Address of the module table )
variable OUTFID                         ( Module output file ID )
create LOADVOC  256 allot               ( Name of the module: temp storage )

:( Returns the address of the module table )
: modules@ ( -- a )  MODULES @ ?dup unless  MODULES# createTable dup MODULES !  then ;
:( Creates output file with name a$ )
: createFile ( a$ -- )  count w/o create-file throw OUTFID ! ;
:( Opens input file with name a$ )
: readFile ( a$ -- )  ( cr ." Reading file " dup qtype$ ) dup count r/o open-file ?dup if
  nip cr ." Error while reading file " swap qtype$ ." : "  throw  then  nip ;
:( Write buffer at a with length # to the output file )
: >file ( a # -- )  OUTFID @ write-file throw ;
:( Read # bytes from the input file to address a )
: <file ( a # -- )  X@ read-file throw drop ;
:( Write # zeroes to the output file )
: 0>file ( # -- )  here over 0 fill  here swap >file ;
:( Serializes the header of vocabulary @voc and returns address a and length # of the block )
: serializeHeader ( @voc -- a # )  $100 here segments 0 do
    2dup d! 4+  2 pick .seglen@  tuck over d! 4+ -rot + rot 3 cells + -rot swap  loop
  here tuck -  2swap 2drop ;
:( Saves the current target vocabulary to the file with the specified name )
: saveModule ( a$ -- )  createFile  tvoc@  cr ." Saving vocabulary " dup vocabulary$ qtype$
  space ." -- " dup §DICT segment-length WORD# u/ . ." words."
(  dumpSymbolTable )
  dup §REFS segment RE# / 0 +do  tvoc@ over dereloc  RE# + loop  drop
  dup serializeHeader tuck >file  256 r- 0>file
  segments 0 do  dup i segment >file  loop  drop
  OUTFID @ close-file throw ;
:( Checks if the module with name a$ has already been loaded )
: loaded? ( a$ -- a$ f | t )  modules@ 0 segment begin dup while
  over 3 pick $$= if  3 #drop true exit  then  over c@ 1+ advance# repeat  nip ;
:( Marks the module with name a$ loaded )
: loaded! ( a$ -- )  dup c@ 1+ modules@ 0 rot allotSpace  over c@ 1+ cmove ;
:( Loads module a$ as vocabulary, resolving all dependencies and relocations )
: loadModule ( a$ -- )  loaded? unless  ( cr ." Loading module " dup qtype$ )  dup readFile >X
  LOADVOC 256 <file  VOCABULARY# createTable >B
  LOADVOC 4+ segments 0 do  dup d@ if B@ i 2 pick d@ allotSpace over d@ <file then  8+ loop
  B@ §DEPS segment DEP# / 0 +do  dup @  B@ §TEXT @segment-address + count + recurse cell+ loop  drop
  B@ §REFS segment RE# / 0 +do  B@ over unreloc  RE# + loop  2drop
  B> dup createVTE dup @NEWEST-VOC !  cr ." Vocabulary " vocabulary$ qtype$ space ." loaded"
  X> close-file throw  loaded!  then ;

:( Adds vocabulary @voc as a dependency, assuming its file name is the same as the vocabulary
   name with '.voc' appended. )
: makeDependency ( @voc -- )  dup vocabulary$ dup c@ 1+ SYM-NAME swap cmove  SYM-NAME c" .voc" append$
  swap >dependency ;

=== Compiler ===

variable inClass
variable addedVoc

defer insertEXIT
defer exitMethod

:( Assert that the A stack is empty -- if not, blocks are not balanced )
: !A0 ( -- )  A? if  cr ." Unbalanced blocks!" abort  then ;

: doInterpret ( -- )  ['] interpret @EVAL ! ;
: doCompile ( -- )  ['] compile @EVAL ! >code ;
: resolveExxit ( ae a -- ae )  ( 2dup '@' emit hex. ." : " hex. ) 2dup - swap 4- d! ;
:( Resolves all the unresolved addresses [on the X stack] pointing to the end of the net code block.
   Relocations are not generated, since these are all inside the same code block )
: resolveExxits ( -- )  ( cr ." -> Resolving " XDEPTH . ." exits: " )
  tvoc@ §CODE @segment-end  XDEPTH 0 +do  X> resolveExxit  loop  drop ;
vocabulary compiler
also compiler definitions  context @ @COMP-WORDS !

require MIO0-IA64.4th
require M0-IA64.4th
require MLinux0-IA64.4th

: tick ( >name -- )
  readWord findWord if  punchWordAddress  else  cr ." Word not found: " qtype$ abort  then ;
: if+ ( ? -- )  CONDITION @ if  ?IFLIKELY,  else  IFLIKELY,  then ;
: if- ( ? -- )  CONDITION @ if  ?IFUNLIKELY,  else  IFUNLIKELY,  then ; alias ifever
: unless+ ( ? -- )  CONDITION @ if  ?UNLESSLIKELY,  else  UNLESSLIKELY, then ;
: unless- ( ? -- )  CONDITION @ if  ?UNLESSUNLIKELY,  else  UNLESSUNLIKELY,  then ; alias unlessever
: begin ( -- )  BEGIN, ;
: end ( -- )  END, ;
: again ( -- )  AGAIN, ;
: until ( ? -- )  CONDITION @ if  ?UNTIL,  else  UNTIL,  then ;
: aslong ( ? -- )  CONDITION @ if  ?ASLONG,  else  ASLONG,  then ;
: while ( ? -- )  CONDITION @ if  ?WHILE,  else  WHILE,  then ;
: repeat ( -- )  REPEAT, ;
: exit ( -- )  EXXIT, ;
: 2exit ( -- )  RDROP, EXXIT, ;
: do ( limit index -- R: -- limit index )  DO, ;
: udo ( ulimit uindex -- R: -- ulimit uindex )  UDO, ;
: -do ( -limit -index -- R: -- limit index )  DODOWN, ; alias −do
: loop ( -- R: limit index -- limit index+1 | )  LOOP, ;
: ?loop ( ? -- R: limit index -- limit index+1 | )  CONDLOOP, ;
: loop- ( -- R: limit index -- limit index-1 | )  LOOPDOWN, ; alias loop−
: ?loop- ( ? -- R: limit index -- limit index-1 | )  CONDLOOPDOWN, ; alias ?loop−
: +loop ( n -- R: limit index -- limit index+n |  )  PLUSLOOP, ;
: ?+loop ( ? n -- R: limit index -- limit index+n |  )  CONDPLUSLOOP, ;
: -loop ( n -- R: limit index -- limit index-n |  )  MINUSLOOP, ; alias −loop
: ?-loop ( ? n -- R: limit index -- limit index-n |  )  CONDMINUSLOOP, ; alias ?−loop
: quitloop  2RDROP, BREAKLOOP, ;
: unless ( ? -- )  CONDITION @ if  ?UNLESS,  else  UNLESS,  then ;
: ?dupif ( x -- [x] )  ?DUPIF, ;
: ?dupif- ( x -- [x] )  ?DUPIFUNLIKELY, ;
: ?dupunless ( x -- [x] )  ?DUPUNLESS, ;
: ?dupunless- ( x -- [x] )  ?DUPUNLESSUNLIKELY, ;
: if ( ? -- )  CONDITION @ if  ?IF,  else  IF,  then ;
: else ( -- )  ELSE, ;
: then ( -- )  THEN, ;
: coda. ( -- )  tvoc@ §CODE segment-length cr ." ---> Code address offset = " hex. ;
: hex ( -- )  16 RADIX ! ;
: decimal ( -- )  10 RADIX ! ;
: , ( n -- )  t, ;
: === ( -- )  c" ===" comment-bracket ;
: --- ( -- )  c" ---" comment-bracket ;
: /* ( >*/ -- )  c" */" comment-bracket ;
: [[  also Forcembler  doInterpret ;
: (   ')' readString drop ;
: ;;  !A0 resolveExxits  exitMethod  createSymbols  doInterpret ;
: ;   !A0 resolveExxits  exitMethod  insertEXIT  createSymbols  doInterpret ;

previous definitions

also Forcembler
: insertENTER ( -- )  depth dup >B ADP+
  [ also compiler ] ENTER, [ previous ] B> ADP-  ^ENTER last-word@ nip setFlag ;
:noname ( -- )  [ also compiler ] EXIT,  [ previous ] ^EXIT last-word@ nip setFlag ; is insertEXIT
previous

=== Object Class Management ===

variable fields

:( Creates the vocabulary word. )
: createVocWord ( -- )  >dict  target@ @segment-address  0 t, 0 t, 0 t, 0 t,  CURRENT-WORD !
  >code  [ also compiler ]  GETDICT, [ previous ]  >data
  toff @dictionaryReloc, 0 t,  toff @codeSegmentReloc, 0 t,  toff @dataSegmentReloc, 0 t,
  toff @textSegmentReloc, 0 t,  0 td, 0 td, 0 td, 0 td, ;
:( Adds the vocabulary word giving access to all the segment pointers and lengths. )
: initStats ( -- )
  createDictionarySymbol  createCodeSegmentSymbol  createDataSegmentSymbol  createTextSegmentSymbol
  createVocWord ;
:( Updates the dictionary length in the class header. )
: updateStats ( -- )  tvoc@ §DATA @segment-address  4 cells +
  tvoc@ §DICT segment-length !d++  tvoc@ §CODE segment-length !d++  tvoc@ §DATA segment-length !d++
  tvoc@ §TEXT segment-length swap d! ;
:( Updates the field count of the class. )
: updateSize ( -- )  fields @ cells  tvoc@ §DATA @segment-address  5 cells + 16 + d! ;
:( Increments the number of fields )
: fields+! ( -- )  fields 1+! ;
:( Copies class vocabulary @voc to this class. )
: copyClass ( @voc -- ) ;

:( Inserts the code to initialize a method with 'this'. )
: initMethod ( -- )  inClass @ AUTO-FLAGS @ ^STATIC and 0= and if  depth dup >B [ also Forcembler ]
  ADP+  [ also compiler ] ENTER-METHOD, [ previous ] B> ADP- [ previous ]  then ;
:( Inserts the code to cleanup 'this' in a method. )
:noname ( -- )  inClass @ AUTO-FLAGS @ ^STATIC and 0= and if  depth dup >B [ also Forcembler ] ADP+
  [ also compiler ] 1 ADP- EXIT-METHOD, 1 ADP+ [ previous ] B> ADP- [ previous ]  then ; is exitMethod

=== Interpreter ===

: >methodComment ( a$ -- )  drop ;

vocabulary interpreter
also interpreter definitions

: import" ( >name" -- )  '"' readString source ;
: vocabulary ( >name -- )  readWord createVocabulary defs  newest-voc@ addVocabulary  initStats ;
: vocabulary; ( -- )  updateStats  tvoc@ removeVocabulary ;
: class ( super >name -- )  vocabulary  inClass ON  >data dup if dup
  makeDependency dup dup dup vocabulary$ 4 cells 16 + @vocDataSegmentReloc, t, ( superclass )
  copyClass  else  t, ( superclass )  0 td, ( #fields )  then ;
: endclass ( -- )  inClass OFF  updateSize  vocabulary; ;
: requires" ( >name" -- )
  '"' readString  dup loadModule
  newest-voc@ >dependency  newest-voc@ addVocabulary ;
: hide ( @voc -- )  cr 100 . .sh readWord cr 110 . .sh findVocabulary cr 120 . .sh ?dup if removeVocabulary  then ;
: alias ( >name -- )  readWord createAlias createSymbols ;
: externalFunction ( >name -- )  SYM-CODE readWord createExternalSymbol ;
: externalObject ( >name -- )  SYM-DATA readWord createExternalSymbol ;
: vocabulary. tvoc@ vocabulary. ;
: >main ( -- )  ^MAIN last-word@ nip .flg!  createStartSymbol ;
also Forcembler
: create ( >name -- )  readWord createWord createSymbols
  >code [ also compiler ] depth dup >B ADP+ CREATE, B> ADP- [ previous ] ;
: constant ( u >name -- )  readWord createWord createSymbols
  >code [ also compiler ] depth dup >B ADP+ DOCONST, B> ADP- [ previous ]  >data t, ;
: createField ( >name -- )  readWord createWord createSymbols
  >code  [ also compiler ] ENTER, initMethod
  depth dup >B ADP+ fields @ DOFIELD, B> ADP- exitMethod  EXIT, [ previous ]  fields+! ;
previous
: requires ( >name -- )  readWord dup findVocabulary swap c" .voc" append$ swap
  cr ." Adding dependency " over qtype$ space ." to vocabulary " dup vocabulary$ qtype$
  dup addVocabulary >dependency ;
: 0allot ( u -- )  >data tzallot, ;
: bloat ( n -- )  >code tzallot, ;
: variable ( >name -- )  inClass @ if  createField  else  create  cell 0allot  then ;
: =variable ( n >name -- )  create  >data t, ;
: 2variable ( >name -- )  create  2 cells 0allot ;
: bytevar ( >name -- )  create  1 0allot ;
: bit ( # -- u )  1 swap << ;
: bits ( # -- %u )  63 and 64 r- -1 swap u>> ;
: private ( -- m )  ^PRIVATE ;
: heritable ( -- m )  ^HERITABLE ;
: protected ( -- m )  ^PROTECTED ;
: public ( -- m )  ^PUBLIC ;
: static ( -- m )  ^STATIC ;
: section ( m -- )  AUTO-FLAGS ! ;
: hex ( -- )  16 RADIX ! ;
: decimal ( -- )  10 RADIX ! ;
: import ( >name -- )  readWord c" .voc" append$
  dup loadModule  newest-voc@ addVocabulary drop ;
: ' ( >name -- @voc @w )  readWord findWord unless  cr ." Word not found: " qtype$ abort  then ;
: ', ( @voc @w -- )  2dup @name slide >data target@ segment-length intDictReloc, t, ;
: c, ( c -- )  >data tc, ;
: w, ( c -- )  >data tw, ;
: d, ( c -- )  >data td, ;
: , ( x -- )  >data t, ;
: ," ( >text" -- )  '"' readString punchString, ;
: /* ( >*/ -- )  c" */" comment-bracket ;
: /** ( >*/ -- )  c" */" comment-bracket ;
: === ( >=== -- )  c" ===" comment-bracket ;
: --- ( >--- -- )  c" ---" comment-bracket ;
: :(   ')' readString >methodComment ;
: (   ')' readString drop ;
: ]]  previous  doCompile ;
: ]]#+ [ also compiler ] [PLUS], [ previous ] ]] ;
: ]]# [ also compiler ] LIT8, [ previous ] ]] ;
: ::  readWord  cr cr ." :: " dup type$  createWord  doCompile  initMethod ;
: :  readWord  cr cr ." : " dup type$  createWord  doCompile  insertENTER  initMethod ;

previous definitions

variable ?PROCESS

: process ( -- )  -1 ?PROCESS !  also interpreter
  begin  readWord  dup c@ ?PROCESS @ and  while  @EVAL @ execute  repeat drop  previous ;
