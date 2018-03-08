/**
  * FORCE, generation 1
  * version 0
  */

vocabulary F1
  requires" FORTH.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" OS.voc"
  requires" LogLevel.voc"
  requires" Memory.voc"
  requires" CmdLine.voc"
  requires" LinuxFile.voc"
  requires" FileIO.voc"
  requires" UTF-8.voc"
  requires" Referent.voc"
  requires" Heap.voc"
  requires" Vocabulary.voc"
  requires" Relocation.voc"
  requires" Module.voc"
  requires" F1args.voc"
  requires" ParserControl.voc"
  requires" AsmBase-IA64.voc"
  requires" MacroForcembler-IA64.voc"
  requires" Compiler.voc"
  requires" InterpreterWords.voc"
  requires" CompilerWords.voc"
  requires" Clauses.voc"

50000 assertCodeSpace

: @Interpreter InterpreterWords ;
: @Compiler CompilerWords ;
: @Clauses Clauses ;

hide InterpreterWords
hide CompilerWords
hide Clauses

=== Parser ===

variable $ADDR                    ( Original address of the counted string )
variable $SIGN                    ( Sign: -1: '-', 0: '+' or none )
variable $RADIX                   ( Numeric radix, default 10 )
variable $INT                     ( The parsed integer number )
variable $OUTCOME                 ( Outcome: 0 = OK, -1 = parsing failed )
variable $#DIGITS                 ( Number of digits parsed )
variable $STRING                  ( Address of the string )
variable #STRING                  ( Length of the string )

create $DIGITS  16 d,  '0' d,  '1' d,  '2' d,  '3' d,  '4' d,  '5' d,  '6' d,  '7' d,
                       '8' d,  '9' d,  'A' d,  'B' d,  'C' d,  'D' d,  'E' d,  'F' d,

--- Parser Primitives ---

( Applies the parsed sign to u, converting it into a signed intger. )
: applySign ( u -- n )  $SIGN @ if  negate  then ;
( Converts Unicode character uc to a digit, or -1 if it is not a valid hex digit. )
: >digit ( uc -- u )  $DIGITS d@++ rot dfind 1- ;
( Calculates number # of Unicode octets to expect from the initial octet c, including it, as well as
  net value c' of c. )
: unicode# ( c -- c' # )  -1 $FF xor over or 0-> tuck bits and swap 7 r− ;

( Eats the next character from the buffer and sets $SIGN if it is any of '+', '-', or '−' [MINUS]. )
: eatSign ( a # -- a' #' )  dup if  2dup uc>
  '+'=?if  drop 2nip  $SIGN  0!  exit  then
  '-'=?if  drop 2nip  $SIGN -1!  exit  then
  $2212=if  2nip  $SIGN -1!  else  2drop  then  then ;
( Eats the next character from the buffer and sets $RADIX if it is a prefix radix [any of '#' for
  decimal, '$' for hex, '%' for binary, or '&' for octal]. )
: eatRadixPrefix ( a # -- a' #' )  dup if  2dup uc>
  '#'=?if  drop 2nip  $RADIX 10!  exit  then
  '$'=?if  drop 2nip  $RADIX 16!  exit  then
  '%'=?if  drop 2nip  $RADIX  2!  exit  then
  '&'=if  2nip  $RADIX  8!  else  2drop  then  then ;
( Eats digits in the current radix from the buffer, cumulating the resulting number in $INT, as long
  as there are valid digits.  Marks the parsing operation failed if no digits were found at all. )
: eatDigits ( a # -- a' #' )  $OUTCOME -1!  $#DIGITS 0!
  begin  dup while  2dup uc> dup '`' > $20 and − >digit dup 0 $RADIX @ between unless  3drop exit  then
  $OUTCOME 0!  $#DIGITS 1+!  $RADIX @ $INT u*+!  2nip repeat ;
( Eats a single quote [or apostrophe] character. )
: eatQuote ( a # -- a' #' )  over c@ $27 − over 0= or dup $OUTCOME !  unless 1 +> then ;
( Eats a double quote character. )
: eatDblQuote ( a # -- a' #' )  over c@ $22 − over 0= or dup $OUTCOME !  unless 1 +> then ;
( Eats a character escape [the leading backslash has already been eaten, and expected outcome is
  negative]. )
: eatEscape ( a # -- a' #' )  dup if  over c@
  '0'=?if  drop $00  else
  'a'=?if  drop $07  else
  'b'=?if  drop $08  else
  'e'=?if  drop $1B  else
  'f'=?if  drop $0C  else
  'n'=?if  drop $0A  else
  'r'=?if  drop $0D  else
  't'=?if  drop $09  else
  $5c=?if  drop $5C  else
  $27=?if  drop $27  else
  dup 1 "Warning: Unknown character escape sequence: \\%c: backslash ignored."|.
  then  then  then  then  then  then  then  then  then  then  $INT !  $OUTCOME 0! 1 +> then ;
( Eats a single unicode character or escape sequence and puts it into $INT. )
: eatChar ( a # -- a' #' )  $OUTCOME -1!  dup if  over c@ '\\'=?if  drop 1 +> eatEscape exit  then
  -rot 1 +> rot  $OUTCOME 0!  unicode# swap $INT ! ?dupif
  $OUTCOME -1!  1− 0 do
    over c@ dup $c0 and $80 =unless  "Error: Invalid Unicode character encountered!"abort  then
    $3F and 64 $INT u*+!  1 +>  loop  then  then ;
( Eats characters until a double-quote is encountered. )
: eatChars ( a # -- a' #' )  $OUTCOME -1!  over $STRING !  #STRING 0!
  begin dup while  over c@ $22 = if  1 +> exit  then  1 +> #STRING 1+!  repeat ;

--- Setup ---

create CLAUSE$  256 0allot        ( Buffer for building a clause )

( Sets up the word parser to operate on buffer with length # at address a containing the word to
  parse.  If the buffer is all empty, exits the caller and returns false, otherwise returns the
  start of the buffer to parse. )
: beginParse ( a$ -- a # -- a$ f )  dup $ADDR ! count $SIGN 0! $RADIX 10! $INT 0! $OUTCOME 0!
  ?dupunless  drop $ADDR @ false 2exit  then ;
( Evaluates the parsing operation: if there are still characters left in the buffer [# ≠ 0], or if
  the operation was failed, returns the original buffer a$ and false, otherwise drops the empty
  buffer and returns true. )
: endParse ( a # -- a$ f | t )  nip $OUTCOME @ or 0= dup unless  $ADDR @ swap  then ;
( Looks up a clause with prefix p$ and name continuation at address a with length # in the target
  vocabularies, which must be an IMMEDIATE word.  If one is found, returns its word referent &w and
  true, otherwise the original name from $ADDR and false. )
: findTargetClause ( a # p$ -- &w t | a$ f )  CLAUSE$ tuck $!  2dup c+! swap cmove
  CLAUSE$ findTargetWord unless  drop $ADDR @ false exit  then
  dup &@ FLAG.IMMEDIATE bit@ if  true exit  then
  CLAUSE$ 1 "Warning: Found target clause «%s», but it's not immediate."|.  drop $ADDR false ;
( Looks up a clause with prefix p$ and name continuation at address a with length # in the clause
  vocabulary.  If one is found, returns its address @w and true, otherwise the original name
  from $ADDR and false. )
: findClause ( a # p$ -- @w t | a$ f )  CLAUSE$ tuck $!  2dup count + 2swap c+! swap cmove
  ( cr CLAUSE$ 1 "Looking for clause «%s»"|. )
  CLAUSE$ @Clauses findWord ?dup unless  drop $ADDR @ false exit  then ;

--- Main Checks/Converters ---

( Checks if a$ represents a valid signed or unsigned integer.  If so, returns decoded value x and
  true, otherwise the input string and false. )
: int$? ( a$ -- x t | a$ f )
  beginParse eatSign eatRadixPrefix eatDigits endParse dup if  $INT @ applySign  swap  then ;
( Cheks if a$ represents a valid floating point number.  If so, returns decoded value r [on the
  float stack] and true, otherwise the input string and false. )
: float$? ( a$ -- F:r t | a$ f )  false ( TODO: document and implement ) ;
( Checks if a$ represents a valid Unicode character.  If so, returns its code point uc and true,
  otherwise the input string and false. )
: char$? ( a$ -- uc t | a$ f )
  beginParse eatQuote eatChar eatQuote endParse dup if  $INT @ swap  then ;
( Checks if a$ represents a valid string.  If so, returns the string and true, otherwise the input
  string and false. )
: string$? ( a$ -- a$ t | a$ f )
  dup c@ 2≥if  dup 1+ c@ '"' = over count + 1− c@ '"' = and  else  false  then ;
( Checks if a$ represents a known int clause.  If so, returns the value part x, the clause word
  address @w and true, otherwise the input string and false. )
: intClause$? ( a$ -- x @w t | a$ f )
  beginParse eatSign eatRadixPrefix eatDigits "_#" findClause dup if  $INT @ applySign  -rot  then ;
( Checks if a$ represents a known target int clause.  If so, returns the value part x, the clause
  word referent &w and true, otherwise the input string and false. )
: targetIntClause$? ( a$ -- x &w t | a$ f )  beginParse eatSign eatRadixPrefix eatDigits
  "_#" findTargetClause dup if  $INT @ applySign  -rot  then ;
( Checks if a$ represents a known char clause.  If so, returns the value part uc, the clause word
  referent &w and true, otherwise the input string and false.  Note: char clauses are the same as
  int clauses, but the character needs to parsed differently. )
: charClause$? ( a$ -- uc @w t | a$ f )
  beginParse eatQuote eatChar eatQuote "_#" findClause dup if  $INT @ applySign  -rot  then ;
( Checks if a$ represents a known target char clause.  If so, returns the value part uc, the clause
  word referent &w and true, otherwise the input string and false. )
: targetCharClause$? ( a$ -- uc &w t | a$ f )  beginParse eatQuote eatChar eatQuote
  "_#" findTargetClause dup if  $INT @ applySign  -rot  then ;
( Checks if a$ represents a known float clause.  If so, returns the value part r [on the float
  stack], the clause word referent &w and true, otherwise the input string and false. )
: floatClause$? ( a$ -- F:r &w t | a$ f )  false ( TODO: document and implement ) ;
( Checks if a$ represents a known string clause.  If so, returns the value part v$, the clause word
  referent &w and true, otherwise the input string and false. )
: stringClause$? ( a$ -- v$ &w t | a$ f )  beginParse eatDblQuote eatChars eatDblQuote
  "_$" findClause dup if  $STRING @ #STRING @ 1+ dup allocate tuck >r cmove r> -rot  then ;
( Checks if a$ is the name of loaded vocabulary.  If so, returns the vocabulary number and true,
  otherwise the inoput string and false. )
: vocabulary$? ( a$ -- #voc t | a$ f )  false ( TODO: document and implement ) ;

( Translates certain inputs into an alternate, non-coflicting form. )
: translate ( a$ -- a$' )
  dup ":" $$=if  drop "(colon)"  exit then
  dup "::" $$=if  drop "(doublecolon)"  exit then
  dup ";" $$=if  drop "(semicolon)"  exit then
  dup ";;" $$=if  drop "(doublesemicolon)"  exit then
  dup "(" $$=if  drop "(openpar)" exit  then ;
( Checks if string a$ is empty. )
: ?empty$ ( a$ -- a$ ? )  dup c@ 0= ;

=== Compiler ===

( Evaluates input string in$ in Compiler mode. )
: compiler ( in$ -- )
  info? if  ecr dup 1 "C> %s"|..  then translate
  findTargetVocabulary if  pushVocabulary  exit  then
  @Compiler findWord if  @Compiler swap execute  handleUnusedVocabulary exit  then
  findTargetWord if  compileTarget  exit  then
  MacroForcembler-IA64 findWord if  MacroForcembler-IA64 swap execute  exit  then
  int$? if  compileInt exit  then
  char$? if compileChar exit  then
  float$? if  compileFloat exit  then
  string$? if  compileString exit  then
  intClause$? if  @Clauses swap execute exit  then
  charClause$? if  @Clauses swap execute exit  then
  floatClause$? if  @Clauses swap execute exit  then
  stringClause$? if  @Clauses swap execute exit  then
  1 "C> «%s» not found!"|!  buildFailed! ;

=== Interpreter ===

( Copies string a$ to a safe place w/o its surrounding double quotes, and returns its address a2$. )
: saveString ( a1$ -- a2$ )  count 1- dup allocate >r 1 +> r@ 2dup c! 1+ swap cmove r> ;

( Evaluates input string in$ in Interpreter mode. )
: interpreter ( in$ -- )
  info? if  ecr dup 1 "I> %s"|.. then translate
  findTargetWord if  executeTarget exit  then
  @Interpreter findWord if  @Interpreter swap execute  exit  then
  FORTH findWord if  FORTH swap execute exit  then
  int$? if  exit  then
  char$? if  exit  then
  string$? if  saveString exit  then
  float$? if  exit  then
  1 "I> «%s» not found!"|!  buildFailed! ;

=== Main Program ===

( Sets the FORCE roots to r$. )
: setRoots ( r$ -- )  info? if  cr dup 1 "FORTH root = ‹%s›"|.  then
  count  begin  2dup ':' cfind dup while  2pick over 1− roots+ +>  repeat  drop roots+
  debug? if  listRoots  then ;
( Determines the FORTh root and sets the environment for it. )
: froot ( -- )
  ROOT$ dup c@ if  setRoots  exit  then
  drop "ROOT4CE=" $env unless
    "FORTH root (environment var ROOT4CE, or command line argument --root) not present"abort  then
  setRoots ;
( Looks up source file with name sn$ in the FORCE roots and returns its complete path sp$. )
: locateSource ( sn$ -- sp$ )  PATH$ dup 0!  roots@# 0 do  dup 2pick $!
  "src/" 2pick swap $$+  3pick $$+  debug? if  cr dup 1 "Checking ‹%s›"|.  then
  fileExists if  drop nip unloop exit  then
  count +  loop  2drop  1 "Source file «%s» not found in FORCE root"|abort ;

( Main program )
:: program ( -- )  INITPROG,
  "FORCE 1.0.0α". cr
  F1args parseCommandLine
  froot  initA4  prod-mode  1 allocPages PAGE# + initModule
  tick compiler COMPARSER !  tick interpreter IMPARSER !  interpret
  openConsole sourcefile@ ?dupif
    MODULE$ tuck over c@ 1+ cmove  dup hasExt? unless  ".4th" $$+  then
    locateSource  info? if  cr dup 1 "Source Module: %s."|log  then  source
    else  info? if  cr "No source file → Interpreter".  then then
  begin  readWord  ?empty$ not while  F1 PARSER @ execute  repeat  drop
  debug? if  cr "Good-bye!". then  bye ;; >main

vocabulary;
