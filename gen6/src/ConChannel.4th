/**
  * Wrapper for a file descriptor referring to a console object (stdin, stdout, stderr, ...)
  */

import File
import UTF8

File class ConChannel

public static section

10 constant NEWLINE

public section --- API

udword variable Line
uword variable Column
uword variable Page

=== Constructor ===

: construct ( u -- )  superconstruct  Descriptor! ;

=== API ===

( Emits unicode character uc to this console channel.  The cursor position is adjusted according to
  the type of character.  By default, the column is incremented, but for BS, VT, LF, FF, CR,
  the pagem line and column are adjusted according to their meanings, while the position remains
  unchanged for all other ucs below 20H. )
: emit ( uc [this] -- )  dup char>UTF8 write
  8=?if  Column 1w−!  else
  9=?if  Column@ 8 u→| Column!  else
  10=?if  Column 0w!  Line 1d+!  else
  12=?if  Page 1w+!  Column 0w!  Line 0d!  else
  13=?if  Column 0w!  else
  31u>?if  Column 1w+!  then  then  then  then  then  then  then  drop ;
( Sends a newline to this console channel, advances the line number by 1 and resets the column
  number to 0. )
: cr ( [this] -- )  NEWLINE me emit ;

class;
export ConChannel
