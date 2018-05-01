/**
  * Command line arguments for FORCOM.
  */

vocabulary F1args
  requires" FORTH.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" CmdLine.voc"
  requires" LogLevel.voc"
  requires" Module.voc"

1 =variable TTYPE                   ( Target type: 1 = voc, 3 = obj, 7 = lib, 11 = prg )
create LIBFILE$ 256 0allot          ( Name of the library file )
create ROOT$ 256 0allot             ( FORCE root )

:( Prints the usage information to stderr. )
: usage ( -- )
  ecr "Usage: ".. 0 arg@ e$. espace
  "[-L|--loglevel=<level>] [-t|--type=<type>] [-o|--output=<output>] [-m|model=<model> "..
  "[-l|--library=<lib>] [-a|--arch=<arch>] [-s|--system=<os>] [-r|--root=<root>] [<source>[.4th]]"..
  ecr "where: <level>  is the debug level, any of (debug|info|warn|error), default: WARN"..
  ecr "       <type>   is the target type, any of (voc|obj|lib|pgm), default: voc"..
  ecr "       <output> is the output file name w/o its extension (assigned automatically)"..
  ecr "                if not specified, output file name is the same as input file name"..
  ecr "       <model>  is the threading model, any of (direct|indirect|inline), default: inline"..
  ecr "       <lib>    is the library to which to add the object file, default: force.lib"..
  ecr "       <arch>   is the target architecture, see below, default: current¹ architecture"..
  ecr "       <root>   is the FORCE root path (overrides ROOT4CE environment variable)"..
  ecr "       <os>     is the target operating system, any of (Linux|Windows|OSX|iOS|Android)"..
  ecr "                default is the current¹ OS"..
  ecr "       <source> is the source file name; extension is optional and defaults to .4th"..
  ecr "                If <source> is not specified, takes input from stdin, using <source>='out'"..
  ecr
  ecr "       -D, -I, -W, -E are shorthands for --loglevel=debug, ...=info, ...=warn, ...=error,"..
  ecr "                respectively."..
  ecr "       -?, -h or --help prints this usage information."..
  ecr
  ecr "Compiles the FORCE code in <source>, creating first a vocabulary <output>.voc,"..
  ecr "then — depending on the specified target type — creates an object file <output>.o, then"..
  ecr "adds the object file to library <lib> (replacing a previous version if it exists); unless"..
  ecr "a program is to be built, in which case it creates program <output>[.exe] in the standard"..
  ecr "platform format (ELF on Linux, PE on Windows, Mach-O on MacOS/iOS)."..
  ecr
  ecr "FORCE supports 3 threading models.  See the manual for further explanation."..
  ecr
  ecr "The FORCE compiler currently supports the following target architectures:"..
  ecr " - IA16     plain Intel 16-bit architecture (x286+x287)"..
  ecr " - IA32     plain Intel 32-bit architecture (x386+x387)"..
  ecr " - IA64     plain Intel 64-bit architecture (x686+x687)"..
  ecr " - IA64m23  plain Intel 32-bit architecture with MMX, SSE2 and SSE3"..
  ecr
  ecr "Further target architectures are explained in the manual."..
  ecr ;

:( Processes the log level option. )
: -L ( a$ -- )  ( cr "Log level: ".  dquo dup $. dquo )
  dup "debug" $$=if  drop LOG-LEVEL 0! exit  then
  dup "info" $$=if  drop LOG-LEVEL 1! exit  then
  dup "warn" $$=if  drop LOG-LEVEL 2! exit  then
  dup "error" $$=if  drop LOG-LEVEL 3! exit  then
  ecr "Invalid log level: ".. edquo $. edquo ;  alias --loglevel
:( Processes the type option. )
: -t ( a$ -- )  ( cr "Target type: ".  dquo dup $. dquo )
  dup "voc" $$=if  drop TTYPE 1! exit  then
  dup "obj" $$=if  drop TTYPE 3! exit  then
  dup "lib" $$=if  drop TTYPE 7! exit  then
  dup "pgm" $$=if  drop TTYPE 11! exit  then
  ecr "Invalid target type option: ".. edquo e$. edquo ;  alias --type
:( Processes the help option. )
: --help ( a$ -- )  drop usage ;
:( Processes the output file option. )
: -o ( a$ -- )  ( cr "Output file: " $.  dquo dup $. dquo )
  dup c@ unless  drop ecr "No output file specified!".. exit  then
  OUTPUT$ over c@ 1+ cmove ;  alias --out
:( Processes the library file option. )
: -l ( a$ -- )  ( cr "Library: " $.  dquo dup $. dquo )
  dup c@ unless  drop ecr "No library specified!".. exit  then
  LIBFILE$ over c@ 1+ cmove ;  alias --library  alias --lib
:( Processes the FORCE root option. )
: -r ( a$ -- )  ( cr "Root: " $.  dquo dup $. dquo )
  dup c@ unless  drop ecr "No root specified!".. exit  then
  ROOT$ over c@ 1+ cmove ;  alias --root
:( Processes the input file argument. )
: argument ( a$ -- )  ( cr "Input File: " $.  dquo dup $. dquo )
  dup c@ unless  drop ecr "No source file specified!".. exit  then
  SOURCE$ over c@ 1+ cmove ;

: switch? ( c -- ? )  "DIWE?T" count rot cfind ;

: -T ( -- )  0 TTYPE ! ;
: -D ( -- )  LOG-LEVEL 0! ;
: -I ( -- )  LOG-LEVEL 1! ;
: -W ( -- )  LOG-LEVEL 2! ;
: -E ( -- )  LOG-LEVEL 3! ;
: -? ( -- )  usage ;  alias -h

vocabulary;
