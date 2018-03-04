/**
  * FORCOM Compiler vocabulary.
  */

vocabulary Compiler
  requires" FORTH.voc"
  requires" Char.voc"
  requires" FC4-64.voc"

( Finishes the current colon definition. )
: <semicolon> ( -- )
  debug? if  " → finishing function".  then  finishFunction ;

vocabulary;
