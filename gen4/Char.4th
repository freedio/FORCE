vocabulary Char
  requires" FORTH.voc"

create BLANKS  31 d,              ( Definition of "blank" a.k.a. word-breaking space )
    0 d, 9 d, 10 d, 11 d, 12 d, 13 d, 1CH d, 1DH d, 1EH d, 1FH d,  20H d,
    2000H d, 2001H d, 2002H d, 2003H d, 2004H d, 2005H d, 2006H d, 2007H d, 2008H d, 2009H d,
    200AH d, 200BH d, 200EH d, 200EH d, 200FH d, 2028H d, 2029H d, 205FH d, 2063H d, 2064H d,

( Converts unicode letter uc to uppercase letter UC. )
: >upper ( uc -- UC )
  ( TODO there is a lot more to do here ...! )
  dup 'a' '{' between if  $20−  then ;
( Checks if unicode character uc is of class Whitespace. )
: whitespace? ( uc -- ? )
  ( TODO there is a lot more to do here ...! )
  BLANKS d@++ rot dfind 0- ;
( Tests if unicode character uc is to be considered lower-case. )
: lowerCase? ( uc -- ? )
  ( TODO there is a lot more to do here ...! )
  dup 'a' '{' between  swap DFH 100H between or ;

vocabulary;
