/* Module Management. */

vocabulary Module
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" LogLevel.voc"
  requires" UnixError.voc"
  requires" Heap.voc"
  requires" Referent.voc"
  requires" LinuxFile.voc"
  requires" Vocabulary.voc"
  requires" Relocation.voc"

create SOURCE$  256 0allot          ( Name of the source file [without extension] )
create OUTPUT$  256 0allot          ( Name of the output file [without extension] )
create MODULE$  256 0allot          ( Name of the module [with extension] )
create PACKAGE$ 256 0allot          ( Name of the current package )
create PATH$    256 0allot          ( Build area for the module path )

=== Module Header Structure ===

create MODULE_HEADER  128 0allot    ( Space for the modue header )

0000  dup constant MOD_@TEXT        ( File offset of text segment )
  4 + dup constant MOD_TEXT#        ( Length of text segment )
  4 + dup constant MOD_@DATA        ( File offset of data segment )
  4 + dup constant MOD_DATA#        ( Length of data segment )
  4 + dup constant MOD_@RELT        ( File offset of relocation table )
  4 + dup constant MOD_RELT#        ( Length of relocation table )
  4 + dup constant MOD_@DEPT        ( File offset of dependency table )
  4 + dup constant MOD_DEPT#        ( Length of dependency table )
  4 + dup constant MOD_@DBIN        ( File offset of debug information table )
  4 + dup constant MOD_DBIN#        ( Length of debug information table )

( Returns the source file as specified on the command line. )
: sourcefile@ ( -- a$|0 )  SOURCE$ dup c@ 0- and ;
( Returns the target file as specified on the command line. )
: targetfile@ ( -- a$|0 )  OUTPUT$ dup c@ unless  drop sourcefile@  then ;
( Returns the module name. )
: module@ ( -- a$|0 )  MODULE$ dup c@ 0- and ;

variable FINDMODULE                 ( Address of the findModule function )
create INITSTRUCT                   ( structure passed to initialization functions )
  0 ,                               ( Initial parameter stack pointer )
  0 ,                               ( Initial return stack pointer )
  0 ,                               ( Address of the sourceFilevariable )
  0 ,                               ( Address of the sourceLine variable )
  0 ,                               ( Address of the sourceColumn variable )
  0 ,                               ( Initial exception stack pointer )

( Prepares target vocabulary for saving as module m$ [no file extension!] by transforming all
  relocations to dependency-related format, adding dependency entries as needed, and finalizing the
  text segment. )
: freezeVocabulary ( m$ -- )
  buildFailed? if  "Current vocabulary has build errors: cannot freeze!"!  exit  then
  >strg &here swap dup c@ 1+ #, segment>  referentOffset dup §TEXT #segment@ TEXT.MODULE# + d!
  >dept d, targetVoc# d, segment>  §RELT #segment@# RELOCATION# u/ 0 do
  dup REL.TARGET + @ dup referentVocabulary >dependency referentVocabulary! over REL.TARGET + !
  dup REL.SOURCE + @ dup referentVocabulary >dependency referentVocabulary! over REL.SOURCE + !
  RELOCATION# + loop  drop  #CURRENTWORD @ §TEXT #segment@ TEXT.#WORDS + w! ;
( Updates the vocabulary references of all relocation entries in vocabulary #v. )
: updateRelocs ( -- :X: #v -- #v )  x@ #vocabulary@ §RELT @#segment@# RELOCATION# u/ 0 do
  dup REL.TARGET + dup @ dup referentVocabulary x@ #vocabulary@ §DEPT @#segment@ swap cells+ 4+ d@
  referentVocabulary! swap !
  dup REL.SOURCE + dup @ x@ referentVocabulary! swap !  RELOCATION# + loop drop ;
( Updates the vocabulary references of all symbol table entries in vocabulary #v. )
: updateSymbols ( -- :X: #v -- #v )  x@ #vocabulary@ §SYMS @#segment@# SYMBOL# u/ 0 do
  dup SYM.VALUE + dup @ x@ referentVocabulary! swap !  SYMBOL# + loop drop ;
( Resolves the dependencies in the dependency table of vocabulary #v and adjusts the vocabulary
  references in the relocation table.  This will load other vocabularies recursively in the majority
  of cases. )
: resolveDependencies ( #v -- )
  dup >x #vocabulary@ §DEPT @#segment@# cellu/ 0 do
  dup d@ x@ #vocabulary@ §STRG @#segment@ + Module FINDMODULE @ execute over 4+ d!  cell+ loop  drop
  updateRelocs updateSymbols x> drop ;
( Run initialization methods of vocabulary #v. )
: runInits ( #v -- )  #vocabulary@ §TEXT @#segment@# TEXT.VOCWORD +> begin dup while
  over d@ -rot 4 +> over c@ 1+ +> rot FLAG.INITCODE bit? if over 2+ INITSTRUCT swap exeqt drop then
  over w@ 2+ +> repeat  2drop ;

( Creates the module header for the current target vocabulary. )
: createHeader ( -- )  128 MODULE_HEADER dup 128 cellu/ 0 fill  #segments 0 do
  2dup d!  4+  i #segmentHeap# dup heap#  rot d!++  swap heap# 16 >|  rot + swap  loop  2drop ;

( Prefixes module name m$ with the package prefix. )
: +package$ ( m$ -- m$' ) PACKAGE$ swap $$+ ;
( Composes module path mp$ from module name m$. )
: composeModulePath ( m$ -- mp$ )  root@  MODULE$ tuck $! "mod/" $$+ swap $$+ ".voc" $$+ ;
( Looks up module with name mn$ in the FORCE roots and returns its complete path mp$. )
: locateModule ( mn$ -- mp$ )  PATH$ dup 0!  roots@# 0 do  dup 2pick $!
  "mod/" 2pick swap $$+  3pick $$+ ".voc" $$+  debug? if  cr dup 1 "Checking ‹%s›"|log  then
  fileExists if  drop nip unloop exit  then
  count +  loop  2drop  1 "Module «%s» not found in FORCE root"|abort ;
( Loads module m$ [no file extension!] and adds its vocabulary to the vocabulary list, returning its
  index #v. )
: loadModule ( m$ -- #v )  locateModule  debug? if  cr dup 1 "Loading module «%s»"|log  then
  newFile name! r/o openFile unlessever
    >errtext swap name@ 2 "Error while opening input module «%s»: %s!"|abort  then
  MODULE_HEADER dup 128 3pick readFile!  createVocabulary >vocabularies targetVoc!
  #segments 0 do  d@++ top-> 3pick seekFile unlessever
    >errtext 2pick name@ 2 "Error while seeking module «%s»: %s!"|abort  then
  drop d@++ ?dupif  i >segment  dup allot@ swap 3pick readFile! segment>  then  loop  drop
  discardFile  targetVoc# dup resolveDependencies  dup applyRelocations  dup voc>dict  debug? if  dup #vocabulary$ cr 1 "Running %s.init"|log  then  dup runInits
  dup targetVoc! ;
( Saves the target vocabulary as module m$ [no file extension!]. )
: saveModule ( m$ -- )  +package$ dup freezeVocabulary  composeModulePath  dup createPathComponents
  newFile name! w/o ?create ?truncate &644 mode! openFile unlessever
    >errtext swap name@ 2 "Error while opening output module «%s»: %s!"|abort  then
  createHeader  MODULE_HEADER 128 2pick writeFile!
  #segments 0 do  i #segment@# 16 >| 2pick writeFile!  loop  discardFile ;
( Looks up module with module name m$ [no file extension]; if the module is already loaded, returns
  its vocabulary index v#, otherwise loads the module. )
: findModule ( m$ -- v# )  ( cr dup 1 "Finding module «%s»"|. )  vocabularies@# 0 do
  i #module$ if  2pick $$= if  2drop i unloop exit  then  else  drop  then
  cell+ loop  drop  loadModule ;
( Initialization required to make Module module work. )
: initModule ( @ex -- )  tick findModule FINDMODULE !
  INITSTRUCT sp0 !++x  rp0 !++x  INFILENAME !++x  INLINE !++x  INCOLUMN !++x  !++  drop ;

vocabulary;
