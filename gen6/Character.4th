/**
  * Character class
  *
  * Represents a unicode code point and provides methods for UTF-8 conversion.
  */

import Object

Object class Character

udword variable CodePoint

public static section --- API

( Constructs a new Character from the numeric unicode code point uc. )
: construct ( uc -- )  superconstruct  CodePoint! ;

class;
export Character
