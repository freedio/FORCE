/**
  * FORCE 64-bit compiler, generation 4
  */

vocabulary FC4-64
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" LogLevel.voc"
  requires" Compiler.voc"
  requires" Vocabulary.voc"

=== Code Generation ===

( Punches code to load an integer literal. )
: punchInt ( n -- )  "#_," lookupWord unless  1 "C> Word «%s» not found!"|! abort  then
  debug? if  dup 1 " → would punch %d"|.  then
  drop ( TODO implement execute ) ;
( Punches condition c$. )
: punchCondition ( c$ -- )  lookupWord unless  1 "C> Condition «%s» not found!"|! abort  then
  debug? if  dup " → would punch".  then
  drop ( TODO punch condition ) ;
: punchWord ( w$ -- ) ;

( Interprets assembler language term a$. )
: assemble ( a$ -- )
  ;

=== Compiler ===

variable INTHOLD                  ( Holding bay for an int )
variable CONDHOLD                 ( Holding bay for a condition )
variable MINDER                   ( Knows about what is in the holding bays )

0 constant INTHELD                ( An int is in the holding bay )
1 constant CONDHELD               ( A condition is in the holding bay )

create COMPOSITE  256 allot       ( Area to compose clauses and terms )

( Puts number i into the holding bay to either be consumed by the next word, or be punched as a
  literal. )
: holdInt ( i -- )  INTHOLD !  MINDER INTHELD bit+! ;
( Puts condition c into the holding bay to either be consumed by the next word, or be punched as a
  condition. )
: holdCondition ( c -- )  CONDHOLD !  MINDER CONDHELD bit+! ;
( Looks up composite word a$ in the composite vocabulary.  If found, returns its address and true,
  otherwise false. )
: findComposite ( a$ -- @w t | f )  drop false ( TODO: Search composite vocabulary ) ;
( Executes term word @w with determinant x. )
: executeTerm ( x @w -- ) 2drop ( TODO: execute target code ) ;
( Checks the bays if something is held that could be released as a term with the next word a$.  If
  not, punches the isolated determinant, returns the string and false, otherwise processes the term
  and returns true. )
: ?releaseBays ( a$ -- t | a$ f )
  MINDER INTHELD bit-@ if  "#_" COMPOSITE $!  COMPOSITE over $$+  findComposite if
    INTHOLD @  debug? if  COMPOSITE count 2 +> over 1c-! 1- over 2 over " → punch %d %s."|.  then
    swap executeTerm  true exit  else
    INTHOLD @  debug? if  dup 1 " → punch %d"|.  then  punchInt  false exit  then  then
  MINDER CONDHELD bit-@ if  "?_" COMPOSITE $!  COMPOSITE over $$+  findComposite if
    CONDHOLD @  debug? if
      COMPOSITE count 2 +> over 1c-!  1- over 2 over " → punch %s %s"|.  then
      swap executeTerm  true exit  else
    CONDHOLD @  debug? if  dup 1 " → punch %s"|.  then  punchCondition  false exit  then  then
  false ;

( Compiles source file word a$. )
: compile ( a$ -- )
  ?releaseBays if  exit  then
  debug? if  cr "C> ". dup "$". then
  "(" over $$= if  drop "<lpar>"  else
  ";" over $$= if  drop "<semicolon>"  then  then  then
  lookupWord if  ( TODO: execute if immediate )
    debug? if  " → compiling.".  then  punchWord  exit  then
  int$? if  debug? if  dup 1 " → int %d."|.  then  holdInt exit  then
  char$? if  debug? if  dup 1 " → char '%c'."|.  then  holdInt exit  then
  float$? if  debug? if  dup 1 " → float %f."|.  then  holdFloat exit  then
  vocabulary$? if  debug? if  " → vocabulary ‹%s›!"  then  unimplemented!  then
  condition? if  dup 1 " → condition ‹%s›."|.  then  cond> holdCondition exit  then
  intClause$? if  Compiler swap execute  then
  charClause$? if  Compiler swap execute  then
  stringClause$? if  Compiler swap execute  then
  cellClause$? if  Compiler swap execute  then
  Compiler findWord if
    debug? if  " → executing".  then
    Compiler swap exeute  debug? if  " → done.".  then  exit  then
  debug? if  " → not found.".  then
  1 "C> Word «%s» not found!"|!  drop abort ;

vocabulary;
