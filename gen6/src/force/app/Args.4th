/**
  * Standard argument processor.
  */

package force/app/

import force/lang/Forth
import force/debug/Debug
import my/CommandLine

vocabulary Args

private static section --- Interna ---------------------

00 constant #DEBUG                ( Shows all information. )
01 constant #INFO                 ( Shows informative information. )
02 constant #WARN                 ( Shows warnings and errors only.  Default log level. )
03 constant #ERROR                ( Shows errors only. )

public static section --- API --------------------------

 ubyte variable LogLevel          ( Log level. )

: switch? ( c -- ? )  "DIWE" count rot cfind ;

( Sets log level to DEBUG. )
: -D ( -- )  #DEBUG LogLevel! ;
( Sets log level to INFO. )
: -I ( -- )  #INFO LogLevel! ;
( Sets log level to WARNING. )
: -W ( -- )  #WARN LogLevel! ;
( Sets log level to ERROR. )
: -E ( -- )  #ERROR LogLevel! ;

( Checks if the log level is DEBUG. )
: debug? ( -- ? )  LogLevel@ #DEBUG ≤ ;
( Checks if the log level is INFO. )
: info? ( -- ? )  LogLevel@ #INFO ≤ ;
( Checks if the log level is WARNING. )
: warning? ( -- ? )  LogLevel@ #WARN ≤ ;
( Checks if the log level is ERROR. )
: error? ( -- ? )  LogLevel@ #ERROR ≤ ;

private init : init ( init$ -- init$ )  #WARN LogLevel!  Args .text parseCommandLine ;

vocabulary;
export Args
