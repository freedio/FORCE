/**
  * Representation of a console with stdin, stdout, and stderr.
  */

import Object
import Consolator

Object class Console

 byte variable defout

=== Constructors ===

public static section --- Constructors

( Creates console c with default output channel stdout if -1, or stderr if 0. )
: fromChannel ( -1|0 -- Console:c )  2+ Console new tuck defout! ;
( Creates console c with default output set to stdout. )
: new ( -- Console:c )  default 1c! ;

=== API ===

public section --- API

( Emits unicode character uc to the current output channel. )
: emit ( uc -- )  defout@ #emitConsolator ;
( Carriage Return: Unconditionally moves the cursor to the beginning of the next line on the current
  output channel. )
: cr ( -- )  defout@ #crConsolator
( Moves the cursor to the beginning of the next line on the current output channel, unless it
  already /is/ on the leftmost column. )
: ?cr ( -- )  defout@ ?#crConsolator ;

class;
export Console
