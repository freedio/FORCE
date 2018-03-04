/**
  * FORCE compiler, generation 4
  * version 0
  */

vocabulary FORCOM
  requires" FORTH.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" OS.voc"
  requires" CmdLine.voc"
  requires" FCargs.voc"
  requires" FileIO.voc"
  requires" SearchList.voc"
  requires" Interpreter.voc"
  requires" Compiler.voc"
  requires" UTF-8.voc"
  requires" Composites.voc"
  requires" FC4-64.voc"
  requires" FI4-64.voc"

=== State and Context Primitives ===

variable PROCESS
2variable PARSER

( Checks if the REPL has been terminated. )
: processing? ( -- ? )  PROCESS @ ;
( Switches to the interpreter. )
: >interpreter ( -- )  FC4-64 conceal FI4-64 disclose FI4-64 tick interpret PARSER 2! ;
( Switches to the compiler. )
: >compiler ( -- )  FI4-64 conceal FC4-64 disclose FC4-64 tick compile PARSER 2! ;

=== Main Program ===

( Main program )
:: program ( -- )  INITPROG,
  "FORCOM (FORCE compiler) 4.0.0α". cr
  FCargs parseCommandLine

  TTYPE @ unless
    sourcefile@ ?dupunless  "Error: No module file specified!"! abort  then
    MODULE$ tuck over c@ 1+ cmove  dup hasExt? unless  ".voc" $$+  then
    info? if  cr dup 1 "Input Module: %s."|log  then
    testModule bye  then

  sourcefile@ ?dupunless  "Error: No source file specified!"! abort  then
  MODULE$ tuck over c@ 1+ cmove  dup hasExt? unless  ".4th" $$+  then
  info? if  cr dup 1 "Source Module: %s."|log  then

  targetfile@ hasExt? if  targetfile@ dup count '.' rcfind 1- swap c!  then

  source  >interpreter
  PROCESS on  Interpreter disclose
  begin  readWord  dup c@ processing? and while  PARSER 2@ execute  repeat  drop
  unsource  Interpreter conceal
  info? if  cr cr "Goodbye.".  then
  depth if .s  then  bye ;; >main

vocabulary;
