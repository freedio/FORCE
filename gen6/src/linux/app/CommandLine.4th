/**
  * Application command line and environment.
  */

/*
 * In the following code, @v (referred to as "vocabulary") actually means the address of the text
 * segment of the specified vocabulary.
 */

package linux/app/

import force/lang/Forth
import force/inout/DirectIO
import force/string/Format
import force/lang/Vocabulary
import force/debug/Debug

vocabulary CommandLine

private static section --- Interna --------------------------------

cell variable @Args               ( Address of the command line argument vector. )
cell variable @Envs               ( Address of the environment variable vector. )
uword variable #Args              ( Command line argument count. )
uword variable #Envs              ( Environment variabe count. )
create tempbuf$  256 allot        ( Temporary volatile buffer for arguments. )

( Method names invoked in the command line object. )
create argument$  "argument" $,
create isswitch$  "switch?" $,

( Prints an error about unrecognized option a$. )
: ?!option ( a$ -- )  1 "Unrecognized option: ‹%s›!"|! ;
( Reads next unicode character from a, increments a beyond the character, and returns short string
  a$ of it with a leading '-' with a$=tempbuf$. )
: ucSwitch ( a -- a' a$ )  uc@++ usize tempbuf$ 2dup nxt c! 1+ '-' !c++ swap #!  tempbuf$ ;
( Checks in vocabulary @v if the unicode character at a is a switch. )
: switch? ( @v a -- @v a ? )
  dup uc@ isswitch$ 3pick findWord dupif  execWord  else  2drop  false  then ;
( Invokes switch with leading '-' and unicode character at a, swallowing it. )
: switch ( @v a -- @v a' )
  ucSwitch 2pick findWord ?dupif  execWord  else  tempbuf$ 1 "Unrecognized switch: ‹%s›!"|!  then ;
( Invokes option with leading '-' and unicode character at a, passing the rest of the buffer at a
  with length #' as argument. )
: -option ( @v a # -- )  ?dupif  over ucSwitch dup >r c@ 1− +> r@ count + 2dup c! 1+ rot cmove
  r> dup count + swap rot findWord dupif  execWord exit  then  then  3drop ;
( Invokes word with name in buffer at a with length # in vocabulary @v passing it an empty
  argument. )
: argname2 ( @v a # -- )  tempbuf$ -rot 2pick 0c!++ a#>$ rot findWord ?dupif  execWord  else
  drop tempbuf$ 1+ ?!option  then ;
( Splits option at a with total length #1 into a name at a with length #2 and a value at a+#2+1 with
  length #1−#2−1, then invokes word with name ‹name› in vocabulary @v , passing it argument
  ‹value›. )
: argval2 ( @v a #1 #2 -- )  -rot tempbuf$ a#>$  dup c@  dup 3pick − 1−  over 2swap c! tuck count +
  tuck c!  swap rot findWord ?dupif  execWord  else  drop  tempbuf$ ?!option  then ;

( Processes anonymous argument with length # at address a. )
: arg ( @v a # -- )  tempbuf$ a#>$ argument$ rot findWord dupif  execWord  else  2drop  then ;
( Processes short option a with length # [does not contain the leading dash]. )
: -arg ( @v a # -- )
  0 do  switch? if  switch  else  limit i − -option exitloop  then  loop  2drop ;
( Processes long option a with length # [contains the leading dash-dash]. )
: --arg ( @v a # -- )  2dup '=' cfind ?dupif  argval2  else  argname2  then ;
( Processes argument with length # at address a invoking methods in vocabulary @v. )
: processArg ( @v a # -- )  ?dupunless  2drop exit  then
  1>?if  over dup c@ '-'= swap 1+ c@ '-'= and if  --arg  exit  then
  over c@ '-'=if  1+> -arg  else  arg  then  else  3drop  then ;

public static section --- API -------------------------------------

--- Command Line ---

( Parses the command line, invoking methods in vocabulary @v for each entry. )
: parse ( @v -- )  @Args@ cell+ #Args@ 1 do  @++ dup -1 0 cfind 1- ( 0count ) 3pick -rot processArg  loop  2drop ;

( Returns the number of command line arguments. )
: Args ( -- u )  #Args@ ;
( Returns the #th command line argument in volatile buffer a$. )
: Arg ( # -- a$ )  dup 0 #Args@ within unless
  #Args@ 0 rot 3 "Invalid argument number %d: must be in the range [%d;%d)!"|abort  then
  @Args@ swap cells+ @ tempbuf$ z>$ ;

--- Environment ---

( Returns the number of environment variables. )
: EnvVars ( -- u )  #Envs@ ;
( Returns the #th environment variable in volatile buffer a$. )
: EnvVar ( # -- a$ )  dup 0 #Envs@ within unless
  #Envs@ 0 rot 3 "Invalid environment variable number %d: must be in the range [%d;%d)!"|abort  then
  @Envs@ swap cells+ @ tempbuf$ z>$ ;

--- Utilities ---

( Prints the command line arguments and environment variables to stdout. )
: cmdline. ( -- )
  cr Args 1 "Command line: %d arguments:"|.
  @Args@ #Args@ 0 do  dup @ 0count cr i 1 "Arg[%d]: "|. a#.  cell+ loop  drop
  cr EnvVars 1 "Environment: %d variables"|.
  @Envs@ #Envs@ 0 do  dup @ 0count cr i 1 "Var[%d]: "|. a#.  cell+ loop  drop ;

private init : init ( @init$ -- @init$ )
  dup 6 cells+ @++ #Args!  @++ @Args!  @++ #Envs!  @ @Envs! ;

vocabulary;
export CommandLine
