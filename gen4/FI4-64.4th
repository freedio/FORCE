/**
  * FORCE 64-bit interpreter, generation 4
  */

vocabulary FI4-64
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" FCargs.voc"
  requires" Interpreter.voc"
  requires" Parser.voc"

=== Interpreter ===

( Interprets source file word a$. )
: interpret ( a$ -- )  debug? if  cr "I> ". dup "$". then
  "(" over $$= if  drop "<lpar>"  else
  ":" over $$= if  drop "<colon>"  else
  Interpreter findWord if
    debug? if  " → executing".  then
    Interpreter swap execute  debug? if  " → done.".  then  exit  then  then  then
  int$? if  debug? if  dup 1 " → int %d."|.  then  exit  then
  float$? if  exit  then
  char$? if  exit  then
  stringClause$? if  Interpreter swap execute  then
  vocabulary$? if  exit  then
  debug? if  " → not found.".  then
  1 "I> Word «%s» not found!"|!  drop abort ;

vocabulary;
