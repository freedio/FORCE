vocabulary Parser
  requires" FORTH.voc"
  requires" UTF-8.voc"

=== Input Parser and Conversions ===

variable $ADDR                    ( Original address of the counted string )
variable $SIGN                    ( Sign: -1: '-', 0: '+' or none )
variable $RADIX                   ( Numeric radix, default 10 )
variable $INT                     ( The parsed integer number )
variable $OUTCOME                 ( Outcome: 0 = OK, -1 = parsing failed )
variable $#DIGITS                 ( Number of digits parsed )

create $DIGITS  16 d,  '0' d,  '1' d,  '2' d,  '3' d,  '4' d,  '5' d,  '6' d,  '7' d,
                       '8' d,  '9' d,  'A' d,  'B' d,  'C' d,  'D' d,  'E' d,  'F' d,

--- Parser Primitives ---

( Applies the parsed sign to u, converting it into a signed intger. )
: applySign ( u -- n )  $SIGN @ if  negate  then ;
( Converts Unicode character uc to a digit, or -1 if it is not a valid hex digit. )
: >digit ( uc -- u )  $DIGITS d@++ rot dfind 1- ;

( Eats the next character from the buffer and sets $SIGN if it is any of '+', '-', or '−' [MINUS]. )
: eatSign ( a # -- a' #' )  ?dupif  2dup uc>
  '+'=?if  drop 2nip  $SIGN  0!  exit  then
  '-'=?if  drop 2nip  $SIGN -1!  exit  then
  $2212=if  2nip  $SIGN -1!  else  2drop  then  then ;
( Eats the next character from the buffer and sets $RADIX if it is a prefix radix [any of '#' for
  decimal, '$' for hex, '%' for binary, or '&' for octal]. )
: eatRadixPrefix ( a # -- a' #' )  ?dupif  2dup uc>
  '#'=?if  drop 2nip  $RADIX 10!  exit  then
  '$'=?if  drop 2nip  $RADIX 16!  exit  then
  '%'=?if  drop 2nip  $RADIX  2!  exit  then
  '&'=if  2nip  $RADIX  8!  else  2drop  then  then ;
( Eats digits in the current radix from the buffer, cumulating the resulting number in $INT, as long
  as there are valid digits.  Marks the parsing operation failed if no digits were found at all. )
: eatDigits ( a # -- a' #' )  $OUTCOME -1!  $#DIGITS 0!
  begin  dup while  2dup uc> dup '`' > $20 and − >digit dup 0 $RADIX @ between unless  3drop exit  then
  $OUTCOME 0!  $#DIGITS 1+!  $RADIX @ $INT u*+!  2nip repeat ;

--- Setup ---

( Sets up the word parser to operate on buffer with length # at address a containing the word to
  parse.  If the buffer is all empty, exits the caller and returns false, otherwise returns the
  start of the buffer to parse. )
: beginParse ( a$ -- a # -- a$ f )  dup $ADDR ! count $SIGN 0! $RADIX 10! $INT 0! $OUTCOME 0!
  ?dupunless  drop $ADDR @ false 2exit  then ;
( Evaluates the parsing operation: if there are still characters left in the buffer [# ≠ 0], or if
  the operation was failed, returns the original buffer a$ and false, otherwise drops the empty
  buffer and returns true. )
: endParse ( a # -- a$ f | t )  nip $OUTCOME @ or 0= dup unless  $ADDR @ swap  then ;

--- Main Checks/Converters ---

( Checks if a$ represents a valid signed or unsigned integer.  If so, returns decoded value x and
  true, otherwise the input string and false. )
: int$? ( a$ -- x t | a$ f )
  beginParse eatSign eatRadixPrefix eatDigits endParse dup if  $INT @ applySign  swap  then ;
: float$? ( a$ -- r t | a$ f )  false ( TODO: document and implement ) ;
: char$? ( a$ -- c t | a$ f )  false ( TODO: document and implement ) ;
: stringClause$? ( a$ -- @w t | a$ f )  false ( TODO: document and implement ) ;
: vocabulary$? ( a$ -- @voc t | a$ f )  false ( TODO: document and implement ) ;

vocabulary;
