/**
  * Command line processor.
  */

vocabulary CmdLine
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"

create arg$  256 0allot                     ( Buffer to store counted argument name )
variable #args                              ( Number of command line arguments )
variable #envs                              ( Number of environment variables )
create @args  128 cells 0allot              ( Argument vector )
create @envs  256 cells 0allot              ( Environment vector )

create USAGE$ ," Usage: "
create WHERE$ ," where: "

create ARGUMENT$ ," argument"               ( Name of argument processing method in definition )
create SWITCH?$ ," switch?"                 ( Name of switch testing method in definition )

:( Returns the u-th command line argument [0th is the program invocation].  Returns an empty string
   if u is beyond the number of actual arguments. )
: arg@ ( u -- a$ )
  dup #args @ u≥if  arg$ 0c!  else  cells @args + @ 0count arg$ 2dup c! 1+ swap cmove  then  arg$ ;

:( Splits option a with length #1 into a <name> at a with length #2 and a <value> at a+#2+1 with
   length #1−#2−1, then invokes word with name <name> in vocabulary @def, passing it the counted
   string constructed from <value>. )
: argval2 ( @def a #1 #2 -- )  2pick over 1- arg$ 128+ >$ >r  +> arg$ >$  r> rot tuck findWord
  if  execute  else  ecr "Unrecognized option: ".. edquo $.. edquo  2drop  then ;
:( Invokes word with name in buffer at a with length # in vocabulary @def passing it an empty
   argument. )
: argname2 ( @def a # -- )
  arg$ -rot 2pick 0c!++ >$ rot tuck findWord if  execute  else
    ecr "Unrecognized option: ".. edquo $.. edquo  2drop  then ;
:( Checks if character c is a switch. )
: isswitch ( @def a -- @def a ? )
  dup c@ SWITCH?$ 3pick findWord if  3pick swap execute  else  2drop false  then ;
:( Invokes switch with name c, prefixed with  '-'. )
: switch ( @def a -- @def a+1 )  c@++ arg$ 2c!++ '-'c!++ c!  arg$ 2pick findWord if
  2pick swap execute  else  ecr "Unrecognized switch: ".. edquo $.. edquo  then ;
:( Invokes option a[0] with leading '-' and argument a[1:-1]. )
: -option ( @def a # -- )  ?dupif  over c@ arg$ 2c!++ '-'c!++ c!++ -rot 1+> rot >$ arg$ rot tuck
  findWord if execute exit then  then
  ecr "Unrecognized option: " $.. edquo $.. edquo  2drop ;
:( Processes long option a with length # [contains the leading "--"]. )
: --arg ( @def a # -- )  2dup '=' cfind ?dupif  argval2  else  argname2  then ;
:( Processes short option a with length # [contains the leading "-"]. )
: -arg ( @def a # -- )
  0 do  isswitch if  switch  else  limit i − -option unloop exit  then  loop  2drop ;
:( Processes non-option argument a with length #. )
: arg ( @def a # -- )  arg$ >$ ARGUMENT$ rot tuck findWord if  execute  else  4drop  then ;
:( Processess command line argument a with length #. )
: processArg ( @def a # -- )  ?dupunless  drop exit  then ( empty argument )
  dup 1>if  over dup c@ '-' = swap 1+ c@ '-' = and if  --arg  exit  then ( --option )
  over c@ '-' =if  1+> -arg  ( -option )  else  arg  then  else  3drop  then ;

:( Parses the command line for arguments using command line definition @def. )
: parseCommandLine ( @def -- )
  @args cell+ #args @ 1 do @++ 0count  3pick -rot processArg loop  2drop ;

( Copies string a of length # to a$ and returns arg$. )
: z>$ ( a # a$ -- a$ )  dup >r 2dup c! 1+ swap cmove  r> ;
( Looks up environment variable with name n$.  If found, returns its value v$ and true, otherwise
  the original name and false. )
: $env ( n$ -- v$ t | n$ f )  @envs #envs @ 0 do
  dup @ 0count ( n$ @envs @env #env )  3 pick count rot ( n$ @envs @env @n n# #env ) u<?if
  aa#= if @ nip 0count 2dup '=' cfind +> arg$ z>$ true unloop exit then else 3drop then  cell+  loop
  drop false ;

:( Prints the command line and environment arguments to stdout. )
: cmdline>stdout ( -- )
  cr "#args: ".  #args @ .
  cr "arg[]: ".  @args #args @ 0 do  dup @ 0count dquo >stdout dquo space  cell+ loop  drop
  cr "#envs: ".  #envs @ .
  cr "env[]: ".  @envs #envs @ 0 do  dup @ 0count cr dquo >stdout dquo  cell+ loop  drop ;

vocabulary;
