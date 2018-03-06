/**
  * The Log is a static object capturing all logged information and redristibuting it the actual
  * loggers.
  */

import Forth
import Console
import StringFormat

vocabulary Log

=== API ===

--- Log Levels ---

0 constant DEBUG                  ( Log level DEBUG )
1 constant INFO                   ( Log level INFO )
2 constant WARNING                ( Log level WARNING )
3 constant ERROR                  ( Log level ERROR )

WARNING constant THRESHOLD        ( Forking threshold: below this → stdout, otherwise → stderr. )

--- Logging API ---

( Log formatted string f$ with # arguments ... at log level ll to standard log. )
: flog ( ... # f$ ll -- )  dup THRESHOLD < ( output FD ) Console fromChannel  dup >r  cr
  DEBUG =?if  drop "DEBUG"  else INFO =?if  drop "INFO "  else  WARNING =?if  drop "WARN "  else
    ERROR =?if  drop "ERROR"  else  "WTF??"  then  then  then  then
  count r@ write  #format$ count r> write ;

vocabulary;
export Log
