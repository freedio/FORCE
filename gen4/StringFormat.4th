/**
  * The FORCE Enhanced printf String Formatter

  * General format of the formatting instructions:
  *
  * %[flags][width][.precision][:argindex]conversion
  *
  * where:  [flags] is a series of the following flags in any order [duplicates ignored]:
  *         - (dash)    makes the result left-justified
  *         # (hash)    uses conversion dependent alternate form (see formatter)
  *         + (plus)    forces a sign on numeric results, even when positive or zero (signed only)
  *           (space)   forces a leading space on positive and zero numeric results (signed only)
  *         0 (zero)    pads the result with zeroes
  *         : (ellips)  pads the result with dots
  *         _ (ellips)  pads the result with underscores
  *         * (aster)   pads the result with asterisks
  *         , (comma)   includes locale specific grouping characters
  *         ( (lpar)    forces negative numbers to be enclosed in parentheses rather than being
  *                     preceded with a minus sign
  *         < (again)   reuse last argument index
  *
  *         [width] is the minimum number of characters written to the output
  *
  *         [precision] in general is the maximum number of characters written to the output; for
  *                     floating point values of the e and f conversion, it is the number of digits
  *                     after the decimal separator; for scientific values of the g conversion, it
  *                     is the total number of digits in the magnitude after rounding.
  *         [argindex]  is the argument number to be used instead of the next argument.  If the
  *                     argument index is specified, the argument index will not be incremented,
  *                     if it is absent, the next argument according to the argument index will be
  *                     used, after which the index is incremented.
  *
  *         [width], [precision] and [argindex] must be a positive unsigned decimal number or zero,
  *         except for [width]. [argindex] refers to the arguments on the stack, top-down, i.e.
  *         0 refers to the last specified argument, and the argument index also grows from 0 up
  *         (arguments are fetched using "pick").
  *
  *         [conversion] is a letter defining the kind of conversion, sometimes followed by further
  *                     conversion characters as described below:
  *         b           produces either 'true' or 'false' (locale dependent)
  *                     if the hash flag is set, produces 'yes' or 'no' instead (locale dependent)
  *                     if the zero flag is set, produces 'on' or 'off' instead (locale dependent)
  *         B           produces either 'TRUE' or 'FALSE' (locale dependent)
  *                     if the hash flag is set, produces 'YES' or 'NO' instead (locale dependent)
  *                     if the zero flag is set, produces 'ON' or 'OFF' instead (locale dependent)
  *         s           produces a string
  *         S           produces a string, converted to uppercase
  *         c           produces a single Unicode character
  *         C           produces a single uppercase Unicode character
  *         d           produces a signed decimal integer
  *         D           same
  *                     if the hash flag ist set for d or D formats, an unsigned decimal is produced
  *         o           produces an unsigned octal integer
  *         O           same
  *         x           produces an unsigned hexadecimal integer with letters 'a' .. 'f' for digit>9
  *         X           produces an unsigned hexadecimal integer with letters 'A' .. 'F' for digit>9
  *                     if the hash flag ist set for any of the o, O, x or X formats, a signed
  *                         number is produced
  *         e           produces a floating point value in the format ±x.xxx...e±xxx
  *         E           produces a floating point value in the format ±x.xxx...E±xxx
  *         f           produces a floating point value avoiding the e±xxx part until too large
  *         F           produces a floating point value avoiding the E±xxx part until too large
  *         g           produces a floating point value in scientific notation.
  *         G           produces a floating point value in scientific notation (uppercase E).
  *         %           produces a percentage with a trailing '%'
  *         ‰           produces a permillage with a trailing '‰'
  *         n           produces a platform specific new line (flags/width/precision are ignored)
  *         t           produces a date, time or instant according to trailing format specifiers:
  *             h       hour of day in 24-hour clock (0..23)
  *             hh      hour of day in 24-hour clock (00..23)
  *             H       hour of day in 12-hour clock (1..12)
  *             HH      hour of day in 12-hour clock (01..12)
  *             m       minute of hour (0..59)
  *             mm      minute of hour (00..59)
  *             s       second of minute (0..59)
  *             ss      second of minute (00..59)
  *             S       millisecond of second (0..999)
  *             SS      millisecond of second (000..999)
  *             n       nanosecond of millisecond (0..999999)
  *             nn      nanosecond of millisecond (000000..999999)
  *             p       am/pm
  *             P       AM/PM
  *             z       time zone in ±00.00 format
  *             Z       time zone name, including daylight saving when appropriate
  *             Y       year (no leading zeroes)
  *             YY      year with 2 digits, no century
  *             YYY     4-digit year
  *             YYYY    same
  *             M       month of year (1..12)
  *             MM      month of year (01..12)
  *             MMM     month as abbreviated name in current locale
  *             MMMM    month as full name in current locale
  *             w       week of year (1..52)
  *             ww      week of year (01..52)
  *             D       day of month (1..31)
  *             DD      day of month (01..31)
  *             d       day of year (1..366)
  *             dd      day of year (001..366)
  *             t       full time 24, formatted like hh:mm
  *             T       full time 12, formatted like HH:mmp
  *             f       full time 24 with seconds, formatted like hh:mm:ss
  *             F       full time 12 with seconds, formatted like HH:mm:ssp
  *                     if the hash flag is set, the ':' in the above 4 formats are suppressed.
  *             a       American date, formatted like MM/DD/YY
  *             A       American date with century, formatted like MM/DD/YYYY
  *             i       ISO 8601 date, formatted like ±YYYY-MM-DD
  *             I       ISO 8601 datetime, formatted like ±YYYY-MM-DD'T'hh:mm
  *             II      ISO 8601 datetime, formatted like ±YYYY-MM-DD'T'hh:mm:ss
  *             III     ISO 8601 datetime, formatted like ±YYYY-MM-DD'T'hh:mm:ss.f
  *                     if the hash flag is set, the datetime separator 'T' is replaced with a space
  */

vocabulary StringFormat
  requires" FORTH.voc"
  requires" Char.voc"
  requires" IO.voc"
  requires" Locale.voc"

VARIABLE NEXTARG
VARIABLE CTRL
VARIABLE WIDTH
VARIABLE PRECISION
VARIABLE ARG#
VARIABLE ARGINDEX
VARIABLE GROUPCH
CREATE FORMATTED  1000 0allot
CREATE INTBUFFER  128 0allot

VARIABLE CHAR
VARIABLE DIGITS

 0 constant LEFTALIGN
 1 constant ALTERNATE
 2 constant FORCESIGN
 3 constant LEADSPACE
 4 constant PADZEROES
 5 constant PADW/DOTS
 6 constant PADW/STAR
 7 constant UNDERSCOR
 8 constant GROUPNUMS
 9 constant PARENTHES
10 constant ?NEGATIVE
11 constant REUSE_ARG

60 constant UPPERCASE

=== Classic Formatting ===

=== sprintf Formatting ===

--- Primitives ---

( Returns number # of argument to pick. )
: arg# ( -- # )  ARGINDEX @ ?dupunless  NEXTARG dup @ swap 1+!  then ;

--- Low Level Formatting Words ---

( Appends c to the format area. )
: >format ( c -- )  FORMATTED tuck count + c! 1c+! ;
( Parses the flags )
: parseFlags ( a # -- a' #' )  CTRL 0!  begin dup while
    "-#+ 0:*_,(<" count 3pick c@ cfind ?dupunless  exit  then
    1- CTRL swap bit+!  1+>  repeat ;
( Parses the width )
: parseWidth ( a # -- a' #' )  WIDTH 0!  begin dup while
    over c@ dup '0' ':' between unless  drop  exit  then
    '0'- WIDTH 10u*+!  1+>  repeat ;
( Parses the precision )
: parsePrecision ( a # -- a' #' )  begin dup while
    over c@ dup '0' ':' between unless  drop exit  then
    '0'- WIDTH 10u*+!  1+>  repeat ;
( Parses the argument index )
: parseArgindex ( a # -- a' #' )  begin dup while
    over c@ dup '0' ':' between unless  drop exit  then
    '0'- ARGINDEX 10u*+!  1+>  repeat ;
( Prepares the rendering area at address a. )
: prepare ( -- a )  FORMATTED count +  dup WIDTH @  ␣
  CTRL PADZEROES bit@if  drop '0'  then  CTRL PADW/DOTS bit@if  drop '.'  then
  CTRL PADW/STAR bit@if  drop '*'  then  CTRL UNDERSCOR bit@if  drop '_'  then  cfill ;
( Limits the amount of characters to insert for strings. )
: limit$ ( a # -- a #' )  PRECISION @ ?dupif  min  then ;
( Aligns string sa with length # in the rendering area ta. )
: align$ ( sa # ta -- sa # ta' )  WIDTH @ 2pick − 0 max CTRL LEFTALIGN bit@ not and + ;
( Appends string a$ to the result. )
: insert$ ( a$ -- )
  count limit$ dup WIDTH @ max >r prepare align$ swap dup FORMATTED c+! cmove  r> FORMATTED c+! ;
: INSERT$ ( a$ -- ) count limit$ dup WIDTH @ max >r prepare align$ swap 0 do
  over c@ >upper  !++c  nxt  loop  2drop  r> FORMATTED c+! ;
( Check if digit n is above 9 -- if so, add the offset between '9' and 'A' ... or 'a', if not
  uppercase. )
: ?+hexoffset ( n -- n' )  9u>?if  $27+ CTRL UPPERCASE bit@ $20 and −  then ;
( Appends unsigned number u with radix r to rendering area. )
: >unsigned ( u r -- )  4 CTRL GROUPNUMS bit@ and 1- DIGITS !
  >r INTBUFFER 128+ tuck  begin  swap r@ u/mod swap  ?+hexoffset  '0'+ rot
  DIGITS 1@-! 0=if  mantissaGroupChar@ --!c  DIGITS 2!  then   --c!  over aslong
  nip tuck − swap --c!  r> drop  insert$ ;
( Appends signed number n with radix r to rendering area. )
: >signed ( n r -- )  >r  4 CTRL GROUPNUMS bit@ and 1- DIGITS !  INTBUFFER 128+ tuck  swap
  0<?if  abs CTRL ?NEGATIVE bit+!  CTRL PARENTHES bit@if  ')' rot --c! swap  then  then  swap
  begin  swap r@ u/mod swap  ?+hexoffset  '0'+  rot
  DIGITS 1@-! 0=if  mantissaGroupChar@ --!c  DIGITS 2!  then   --c!  over aslong
  nip  CTRL ?NEGATIVE bit@if  '-' CTRL PARENTHES bit@ 5and − swap --c!  else
    CTRL FORCESIGN bit@if
      '+' swap --c!  else  CTRL LEADSPACE bit@if  ␣ swap --c!  then  then  then
  tuck − swap --c!  r> drop insert$ ;

$100 bloat

--- Formatting Rules ---

: >on/off ( ... a # -- ... a # )  arg# pick if  "on"  else  "off"  then  insert$  ;
: >ON/OFF ( ... a # -- ... a # )  arg# pick if  "ON"  else  "OFF"  then  insert$  ;
: >yes/no ( ... a # -- ... a # )  arg# pick if  "yes"  else  "no"  then  insert$  ;
: >YES/NO ( ... a # -- ... a # )  arg# pick if  "YES"  else  "NO"  then  insert$  ;
: >bool ( ... a # -- ... a # )
  CTRL ALTERNATE bit-@ if  >yes/no  else  CTRL PADZEROES bit-@ if  >on/off  else
    arg# pick if  "true"  else  "false"  then  insert$  then  then ;
: >BOOL ( ... a # -- ... a # )
  CTRL ALTERNATE bit-@ if  >YES/NO  else  CTRL PADZEROES bit-@ if  >ON/OFF  else
    arg# pick if  "TRUE"  else  "FALSE"  then  insert$  then  then ;
: >string ( ... a # -- ... a # )  arg# pick insert$ ;
: >STRING ( ... a # -- ... a # )  arg# pick INSERT$ ;
: >char ( ... a # -- ... a # )  arg# pick  8u<< 1+ CHAR tuck !  insert$ ;
: >CHAR ( ... a # -- ... a # )  arg# pick  >upper 8u<< 1+ CHAR tuck !  insert$ ;
: >decimal ( ... a # -- ... a # )
  arg# pick  10 CTRL ALTERNATE bit@if  >unsigned  else  >signed  then ;  alias >DECIMAL
: >octnum ( ... a # -- ... a # )
  arg# pick  8 CTRL ALTERNATE bit@if  >signed  else  >unsigned  then ;  alias >OCTNUM
: >hexnum ( ... a # -- ... a # )
  arg# pick  16 CTRL ALTERNATE bit@if  >signed  else  >unsigned  then ;
: >HEXNUM ( ... a # -- ... a # )  CTRL UPPERCASE bit+!  >hexnum ;
: >percent ( ... a # -- ... a # ) '%' 8u<< 1+ CHAR tuck !  insert$ ;

( TODO: )

: >expon ( ... a # -- ... a # ) ;
: >EXPON ( ... a # -- ... a # ) ;
: >float ( ... a # -- ... a # ) ;
: >FLOAT ( ... a # -- ... a # ) ;
: >scient ( ... a # -- ... a # ) ;
: >SCIENT ( ... a # -- ... a # ) ;
: >newline ( ... a # -- ... a # ) ;
: >time ( ... a # -- ... a # ) ;

--- The Formatter ---

create RULES  ' >bool ', ' >BOOL ', ' >string ', ' >STRING ', ' >char ', ' >CHAR ',
              ' >decimal ', ' >DECIMAL ', ' >octnum ', ' >OCTNUM ',  ' >hexnum ', ' >HEXNUM ',
              ' >expon ', ' >EXPON ',  ' >float ', ' >FLOAT ',  ' >scient ', ' >SCIENT ',
              ' >percent ', ' >newline ', ' >time ',

( Starts a formatter. )
: format ( ... a # -- ... a' #' )  parseFlags  parseWidth
  PRECISION 0!  dup if over c@ '.'=if  parsePrecision  then  then
  ARGINDEX 0!  dup if over c@ ':'=if  parseArgindex  then  then
  CTRL REUSE_ARG bit-@ if  NEXTARG dup @ 1- 0 max swap !  then
  dup if over c@ "bBsScCdDoOxXeEfFgG%nt" count rot cfind ?dupunless
    "Warning: Unknown formatting rule '".. eemit sourceFile@ ?dupif
     "' in ".. e. '(' eemit sourceLine@ .. '.' eemit  sourceColumn@ "): skipped."..
     then  exit  then  then
  >r 1+> StringFormat RULES r> 1- cells+ @ execute ;
( Appends character c to rendering area. )
: append ( c -- )  FORMATTED tuck count + c! 1+! ;

--- API ---

( Formats arguments ... according to format a$ and returns result a$.  The result is overwritten
   with the next formatting operation. )
: |$| ( ... # f$ -- a$ )
  FORMATTED 1000 0 cfill  swap ARG# !  2 NEXTARG !  FORMATTED 0c!  CTRL 0!  count begin ?dup while
  over c@ '%'=if 1+> format  else  over c@ append  1+> then  repeat drop  ARG# @ udrop  FORMATTED ;

vocabulary;
