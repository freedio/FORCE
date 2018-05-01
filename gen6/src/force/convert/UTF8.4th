/**
  * UTF8 converter vocabulary.
  */

package force/convert/

import force/lang/Forth

vocabulary UTF8

private static section --- Interna

public static section --- API

create Buffer  256 allotz

: uc>utf8 ( uc -- utf8 )  TOUTF8, ;
( Appends unicode character uc as a UTF8-character to small string in buffer at a$. )
: uc>utf8$ ( uc a$ -- )  swap  TOUTF8,  begin  swap 2dup c>$ swap  8u>>  0=?until  2drop ;
( Loads unicode character uc from address a and moves a past the character. )
: uc@++ ( a -- a' uc )  FETCHUC$INC, ;
( Loads unicode character uc from address a. )
: uc@ ( a -- uc )  uc@++ nip ;

vocabulary;
export UTF8
