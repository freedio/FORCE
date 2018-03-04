/**
  * FORCOM Interpreter vocabulary.
  */

vocabulary Interpreter
  requires" FORTH.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" LogLevel.voc"
  requires" FileIO.voc"
  requires" CompSearchList.voc"
  requires" Module.voc"
  requires" Word.voc"
  requires" Vocabulary.voc"

create TARGET$  256 0allot        ( Target file name )
create IMPORT$  256 0allot        ( Name of module to import )
variable InterpreterState         ( Indicats state change if not 0 )
1 constant Interpreter>Compiler   ( Switch to compoiler )

=== Module Management ===

( Imports module <name>. )
: import ( >name -- )  readWord  IMPORT$ $!
  IMPORT$ hasExt? unless  IMPORT$ ".voc" $$+  then
  info? if  dup 1 cr "I: Importing module ‹%s› "|log  then
  createVocab dup >r vocab[] #SEGMENTS rot loadModule  r> dumpVoc search+ ;

=== Vocabulary and Class Definitions ===

( Creates target class <name>, adds it to the search context and makes it the current
  definition context. )
: class ( class >name -- )  readWord
  info? if  dup 1 cr "I: Creating class ‹%s› "|log  then
  module@ swap createClass
  debug? if  dup dup @text cr 2 "I: Class ‹%s› (#%d) successfully created."|log  then
  drop ;
( Saves the current class. )
: class; ( -- )
  targetfile@ TARGET$ tuck $!  ".voc" $$+
  info? if  dup currentVocabulary dup @text cr 3 "I: Saving class ‹%s› (#%d) to «%s»"|log  then
  dup currentVocabulary saveClass
  drop ;

=== Comments ===

( Starts a block quote ending with an isolated "*/". )
: /* ( >... */ )  begin  readWord empty$? swap "*/" $$= or until ;
( Starts a block quote ending with an isolated "*/". )
: /** ( >... */ )  begin  readWord empty$? swap "*/" $$= or until ;
( Starts a block quote ending with an isolated "===". )
: === ( >... === )  begin  readWord empty$? swap "===" $$= or until ;
( Starts a block quote ending with an isolated "---". )
: --- ( >... --- )  begin  readWord empty$? swap "---" $$= or until ;
( Starts a character quote ending with an isolated right parenthesis. )
: <lpar> ( >...)  debug? if  " → skipping comment: ( ".  then
  begin  readChar debug? if  dup emit  then  dup 0- swap ')' ≠ and  aslong ;

=== Word Attributes ===

( Sets the static attribute. )
: static ( -- )  CURRENT-FLAGS dup 0! WORD-STATIC bit+! ;
( Adds the static attribute. )
: +static ( -- )  CURRENT-FLAGS WORD-STATIC bit+! ;

( Transfers the current attributes to the section. )
: section ( -- )  CURRENT-FLAGS @ STANDARD-FLAGS ! ;

=== Word Creators ===

( Creates an address word. )
: create ( >name -- )  readWord
  debug? if  dup 1 " → creating address ‹%s›"|.  then  createAddress ;
( Creates a colon definition. )
: <colon> ( >name -- )  readWord
  debug? if  dup 1 " → creating function ‹%s›"|.  then  createFunction
  Interpreter>Compiler InterpreterState ! ;
( Creates the program entry point. )
: main: ( -- )  createStart  Interpreter>Compiler InterpreterState ! ;

=== Module Tests ===

: testModule ( a$ -- )  createVocab dup >r vocab[] #SEGMENTS rot loadModule  r> dumpVoc drop ;

vocabulary;
