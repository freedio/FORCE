vocabulary Compiler
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Referent.voc"
  requires" Heap.voc"
  requires" Vocabulary.voc"
  requires" Relocation.voc"
  requires" AsmBase-IA64.voc"
  requires" MacroForcembler-IA64.voc"

=== Code Builder ===

( Inserts a call to the code of word &w and adds a relocation entry for its address. )
: callCode ( &w -- )  word>code REFCALL, ;
( Looks up word with name w$ in the target vocabularies and inserts a call to its code if found;
  otheriwse prints an error message and aborts. )
: callTarget ( w$ -- )  findTargetWord unless  1 "Word «%s» not found!"|abort  then  callCode ;

( Compiles a "load int" instruction for value x. )
: compileInt ( x -- )  INT, ;
( Compiles a "load Unicode char" instruction for unicode character uc. )
: compileChar ( uc -- )  CHAR, ;
( Compiles a "load float" instruction for float r. )
: compileFloat ( -- :F: r -- )  "(loadFloat)" callTarget 8 allot@ f! ;
( Compiles a "load string" instruction for quoted string a$. )
: compileString ( a$ -- )  STRING,  "$",  STREND, ;
( Compiles a "load string" instruction for unquoted string a$. )
: compileString2 ( a$ -- )  STRING,  $,  STREND, ;
( Compiles int clause &w with value x. )
: compileIntClause ( x &w -- ) "Don't know how to compile a target int clause!"abort ;
( Compiles char clause &w with value x. )
: compileCharClause ( x &w -- ) "Don't know how to compile a target char clause!"abort ;
( Compiles float clause &w with value r [on the float stack]. )
: compileFloatClause ( F:r &w -- ) "Don't know how to compile a target float clause!"abort ;
( Compiles string clause &w with value a$. )
: compileStringClause ( a$ &w -- ) "Don't know how to compile a target string clause!"abort ;

=== Compiler ===

7 constant ENTER#                 ( The length of the ENTER code in bytes )
5 constant EXIT#                  ( The length of the EXIT code in bytes )
8 constant EXIT2#                 ( The length of the EXIT2 code in bytes )
1 constant ENTER_FIELD#           ( The length of the ENTER_FIELD code in bytes )
2 constant EXIT_FIELD#            ( The length of the EXIT_FIELD code in bytes )
16 constant MAXCODE4COPY          ( Maximum net code size for copying in bytes )
variable CODEMODEL                ( Target code model: 0 = inline, 1 = direct, 2 = indirect )
variable LOC                      ( Location of copied code for relocations )

( Changes the offset of referent &w so that it points at the net code field [after ENTER]. )
: word>netcode ( &w -- &code )  dup &@ d@++ tuck ( fl a fl ) FLAG.ENTER bit? ENTER# and ( fl a u )
  rot FLAG.FIELD_ENTER bit? ENTER_FIELD# and + ( a u ) swap c@ 7+ + &+ ;
( Returns the overhead by ENTER and EXIT code in word &w. )
: stackOverhead ( &w -- u )
  &@ d@ 0 over FLAG.ENTER bit? ENTER# and +
  over FLAG.EXIT bit? EXIT# and +
  over FLAG.EXIT2 bit? EXIT2# and +
  over FLAG.FIELD_ENTER bit? ENTER_FIELD# and +
  swap FLAG.FIELD_EXIT bit? EXIT_FIELD# and + ;
( Returns net code size u of word &w. )
: Code# ( &w -- u )  dup &@ 4+ count + w@ swap stackOverhead − ;
( Returns net code address a and size u of word &w. )
: code@# ( &w -- a u )  dup word>netcode &@ swap Code# ;

( Transposes the relocations referring to code block of length # at &code to code at &r. )
: copyRelocations ( &code # &r -- )  2pick referentVocabulary dup assertDependency
  #vocabulary@ §RELT @#segment@# RELOCATION# u/ 0 do  dup REL.SOURCE + @
  stripReferent 4pick 4pick &within if  dup REL.SOURCE + @ referentOffset 4pick referentOffset −
    2pick swap &+ over REL.SOURCE + @ swap referentOffset! over REL.TARGET + @ swap splitReferent reloc,  then  RELOCATION# + loop  4drop ;
( Checks if the last contribution was a linker. )
: linker? ( -- ? )  LINKER @ ;
( Sets the LINKER variable if word &w is a linker. )
: ?linker ( &w -- &w )  dup &@ FLAG.LINKER bit@ LINKER ! ;
( If word &w is a joiner, checks if previous code size is >0 and the last contribution was a linker;
  if so, the length of the previous code is shortened by the linker size, and the pair a:u is
  advanced by the RAX PUSH code. )
: ?joiner ( &w a u -- &w a' u' )  2pick &@ FLAG.JOINER bit@ if
    2pick Code# 0≠if  linker? if  LINKERTAIL# unallot  JOINERHEAD# +>  LOC 2-!  then  then  then ;
( Appends the net code of word &w with net size u to the current word.  Also copies relocations and
  generates debug information for it.  Joiners [∢ FLAG.JOINER] are treated specially. )
: copyCode ( &w -- )
  &here LOC ! dup code@# ?joiner #,  ?linker  dup word>netcode swap Code# LOC @ copyRelocations ;
( Compiles word &w inline.  If the code fragment is small enough, it is copied, along with its
  relocations and debug info, otherwise a call is inserted. )
: punchInline ( &w -- )  deferred? if  callCode exit  then
  dup Code# MAXCODE4COPY ≤if  copyCode  else  callCode  then ;
( Punches a reference to the code of word &w into the code being built. )
: punchDirect ( &w -- ) word>code &here REL.ABS64 reloc, ;
( Punches a reference to word &w into the code being built. )
: punchIndirect ( &w -- ) &here REL.ABS64 reloc, ;

( Compiles word &w into the code. )
: compileTarget ( &w -- )  CODEMODEL @
  0=?if  drop punchInline exit  then
  1=?if  drop punchDirect exit  then
  2=?if  drop punchIndirect exit  then
  1 "Unknown code model: %d"|! ;

=== Object Management ===

( Inserts code to create a new object. )
: createObject ( ^voc -- Object:o )
  PushedVoc @ -1=?if  "Missing class name for ‹new›!"! abort  then
  #vocabulary@ dup §TEXT @#segment@ TEXT.VOCFLAGS + VOC%CLASS bit@ unless
    @vocabulary$ 1 "Vocabulary «%s» is not a class!"|! abort  then
  PushedVoc -1!  dup class# ALLOCOBJ,  findConstructor if  compileTarget  then ;

=== Stray Utils ===

: getDirectI/OTargetWord ( w$ -- &w )  findTargetWord unless
    1 "Word «%s» not found — import force/inout/DirectIO module!"|abort  then ;
: getFormatTargetWord ( w$ -- &w )  findTargetWord unless
    1 "Word «%s» not found — import force/string/Format module!"|abort  then ;

vocabulary;
