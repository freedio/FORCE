/**
  * Short string formatter utility.
  *
  * In its final stage, the formatter supports placeholders of the following structure in the
  * template string (currently only a limited set is available):
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
  *         p           produces a plural-s, if the value is ≠ 1
  *                     if width is omitted or 1, produces an 's'
  *                     if width is 2, produces 'es'
  *                     if width is 3, produces 'y' if value =1, else 'ies'
  *         P           produces a plural-s, converted to uppercase
  *                     if width is omitted or 1, produces an 'S'
  *                     if width is 2, produces 'ES'
  *                     if width is 3, produces 'Y' if value =1, else 'IES'
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

package force/string/

import force/lang/Forth
import force/inout/DirectIO
import force/debug/Debug
import force/lang/Xstack
import force/convert/Char
import my/OS
import my/Locale

vocabulary Format

private static section --- Utils and State

create Rendering  256 allot       ( Rendering area. )
create NumBuffer  128 allot       ( Buffer for numeric argument conversion. )
create @NumBuffer   1 allot       ( Right edge of numeric buffer. )

  cell variable CharBuffer        ( Buffer for a Unicode character. )
  cell variable Digits            ( Number of digits in numeric conversion. )
  cell variable NextArg           ( Index of the next argument. )
  cell variable PadWidth          ( Width of the numeric part w/o sign, or 0 if no padding. )
udword variable Control           ( Collected flags. )
 ubyte variable Width             ( Parsed field width. )
 ubyte variable Precision         ( Parsed field precision. )
 ubyte variable #Args             ( Number of arguments to process. )
 ubyte variable Arg#              ( Index of the argument to use. )

 0 constant .LeftAlign            ( true if field is left-aligned. )
 1 constant .Alternate            ( true if alternate form requested. )
 2 constant .ForceSign            ( true if sign is forced even when positive. )
 3 constant .LeadSpace            ( true if a leading space on non-negative numbers is required. )
 4 constant .PadZeroes            ( true if buffer is padded with zeroes. )
 5 constant .PadPeriod            ( true if buffer is padded with periods. )
 6 constant .PadAsters            ( true if buffer is padded with asterisks. )
 7 constant .PadScores            ( true if buffer is padded with underscore. )
 8 constant .GroupNums            ( true if numbers should include the group separator. )
 9 constant .Parenthes            ( true if minus sign is replaced with parentheses. )
10 constant .?ReuseArg            ( true if last argument should be re-used. )

16 constant .?Negative            ( true if the current number is negative. )
18 constant .Uppercase            ( true if letters should be converted to upper case. )

--- Methods ---

( Parses the flags of a parameter. )
: parseFlags ( a # -- a' #' )  0 Control!  begin dup while
  "-#+ 0:*_,(<" count 3pick c@ cfind ?dupunless  exit  then  1− Control swap bit+!  1+>  repeat ;
( Parses the width of a parameter. )
: parseWidth ( a # -- a' #' )  0 Width!  begin dup while
  over c@ dup '0' ':' within unless  drop exit  then  '0' − Width 10c*+!  1+>  repeat ;
( Parses the precision of a parameter. )
: parsePrecision ( a # -- a' #' )  begin dup while
  over c@ dup '0' ':' within unless  drop exit  then  '0' − Precision 10c*+!  1+>  repeat ;
( Parses the argument index of a parameter. )
: parseArg# ( a # -- a' #' )  begin dup while
  over c@ dup '0' ':' within unless  drop exit  then  '0' − Arg# 10c*+!  1+>  repeat ;

( Prepares rendering area at address a. )
: prepare ( -- a :X: a -- a )  x@ count + dup Width@ ␣
  Control .PadAsters bit@ifever  drop '*'  then
  Control .PadScores bit@ifever  drop '_'  then
  Control .PadPeriod bit@ifever  drop '.'  then
  cfill ;
( Limits amount of characters # to insert. )
: limit$ ( a # -- a #' )  Precision@ ?dupif  min  then ;
( Aligns string sa with length # in rendering area ta. )
: align$ ( sa # ta -- sa # ta' )  Width@ 2pick − 0 max Control .LeftAlign bit@ andn + ;
( Inserts short string a$ to rendering area at a. )
: insert$ ( a$ -- :X: a -- a )  ( cr dup "Inserting «" $. $. '»' emit )
  count limit$ dup Width@ max >r prepare align$ swap cmove  r> x@ c+! ;
( Inserts short string a$, converted to uppercase, to rendering area at a. )
: INSERT$ ( a$ -- :X: a -- a )
  count limit$ dup Width@ max >r prepare align$ -rot  begin dup while ( ta sa # )
    c$>++ >upper ( ta sa # uc ) 4roll c$!++ -rot repeat
  3drop r> x@ c+! ;
( Appends character c to rendering area and decrements width. )
: >char ( c -- :X: a -- a )  x@ dup count + swap 1c+! !  Width@ 1− 0 max Width! ;
( Appends a plural-s, -es, or -ies. )
: plural$ ( u -- :X: a -- a )  1=if
  Width@ 3=if  'y' >char  then  else
  Width@ 2<?if  drop 's' >char  else
  2=?if  drop "es" insert$  else
  3=if  "ies" insert$  then  then  then  then ;
( Appends an uppercase plural-s, -es, or -ies. )
: PLURAL$ ( u -- :X: a -- a )  1=if
  Width@ 3=if  'Y' >char  then  else
  Width@ 2<?if  drop 'S' >char  else
  Width@ 2=?if  drop "ES" insert$  else
  Width@ 3=if  drop "IES" insert$  then  then  then  then ;

( Converts digit n > 9 to a hex letter a..f, or A..F if uppercase flag is set. )
: ?+hexoffset ( n -- n' )  9u>?if  $27+  Control .Uppercase bit@ $20 and −  then ;
( Returns the absolute value of n, and sets the negative flag if n was negative. )
: >abs ( n -- |n| )
  0<?if  ±  Control dup .?Negative bit+! dup .LeadSpace bit−!  .ForceSign bit−!  else
  Control .Parenthes bit−!  then ;
( Sets PadWidth from Width. )
: padwidth! ( -- )  Width@  Control .?Negative bit@if
  -1  Control .Parenthes bit@ +  else  Control dup .LeadSpace bit@ swap .ForceSign bit@ or  then
  + 0 max PadWidth! ;
( If PadZeroes flag is set, inserts leading zeroes into buffer at a with length # until # equals
  PadWidth; otherwise does nothing. )
: pad0 ( # a -- #' a' )
  Control .PadZeroes bit@if  over PadWidth@ r− 0 do  '0' --!c nxt  loop  then ;
( Inserts character c in front of a$ and returns its new address. )
: prefix ( a$ c -- a$' )  swap dup c@ 1+ -rot c!-- tuck c! ;
( Appends character c to a$. )
: suffix ( a$ c -- a$ )  over count + c!  dup 1c+! ;

( Creates the string repreentation of u with radix r in NumBuffer nd returns its address a$. )
: unsigned$ ( u r -- a$ :X: a -- a )  >r padwidth! 4 Control .GroupNums bit@ and 1− Digits!
  0 @NumBuffer ( u # a )  begin rot r@ u÷% ?+hexoffset '0'+ 2swap ( u' c # a )
  Digits 1@−! 0=if  mantissaGroupChar@ --!c nxt  then  rot --!c nxt ( u' # a )  2pick aslong
  pad0  1− tuck c!  swap r> 2drop ;
( Formats unsigned number u with radix r. )
: >unsigned ( u r -- :X: a -- a )  unsigned$ insert$ ;
( Formats signed number n with radix r. )
: >signed ( n r -- :X: a -- a )  swap >abs swap unsigned$
  Control .Parenthes bit@if  '(' prefix  ')' suffix  else
  Control .?Negative bit@if  '-' prefix  else
  Control .ForceSign bit@if  '+' prefix  else
  Control .LeadSpace bit@if  ␣ prefix  then  then  then  then
  insert$ r> drop ;

( Returns index # of the next argument. )
: nextArg ( -- # )  Arg#@ ?dupunless  NextArg dup @ swap 1+!  then ;

: >on/off ( ... a # -- ... a # )  nextArg pick if  "on"  else  "off"  then  insert$  ;
: >ON/OFF ( ... a # -- ... a # )  nextArg pick if  "ON"  else  "OFF"  then  insert$  ;
: >yes/no ( ... a # -- ... a # )  nextArg pick if  "yes"  else  "no"  then  insert$  ;
: >YES/NO ( ... a # -- ... a # )  nextArg pick if  "YES"  else  "NO"  then  insert$  ;

--- Rules ---

( Formats a boolean parameter as lowercase. )
: >bool ( ... a # -- ... a # )
  Control .Alternate bit@ifever >yes/no  else  Control .PadZeroes bit@ifever  >on/off  else
    nextArg pick if  "true"  else  "false"  then  insert$  then  then ;
( Formats a boolean parameter as UPPERCASE. )
: >BOOL ( ... a # -- ... a # )
  Control .Alternate bit@ifever >YES/NO  else  Control .PadZeroes bit@ifever  >ON/OFF  else
    nextArg pick if  "TRUE"  else  "FALSE"  then  insert$  then  then ;
( Formats a string parameter as lowercase. )
: >string ( ... a # -- ... a # )  nextArg pick insert$ ;
( Formats a string parameter as UPPERCASE. )
: >STRING ( ... a # -- ... a # )  nextArg pick INSERT$ ;
( Formats an integer parameter as lowercase plural. )
: >plural ( ... a # -- ... a # )  nextArg pick abs plural$ ;
( Formats an integer parameter as UPPERCASE plural. )
: >PLURAL ( ... a # -- ... a # )  nextArg pick abs PLURAL$ ;
( Formats a char parameter as lowercase. )
: >char ( ... a # -- ... a # )  nextArg pick 8u<< 1+ CharBuffer tuck !  insert$ ;
( Formats a char parameter as UPPERCASE. )
: >CHAR ( ... a # -- ... a # )  nextArg pick 8u<< 1+ CharBuffer tuck !  INSERT$ ;
( Formats an integer parameter as decimal lowercase. )
: >decimal ( ... a # -- ... a # )
  nextArg pick  10 Control .Alternate bit@ifever  >unsigned  else  >signed  then ;  alias >DECIMAL
( Formats an integer parameter as octal lowercase. )
: >octal ( ... a # -- ... a # )
  nextArg pick  8 Control .Alternate bit@ifever  >unsigned  else  >signed  then ;  alias >OCTAL
( Formats an integer parameter as hexadecimal lowercase. )
: >hexadec ( ... a # -- ... a # )
  nextArg pick  16 Control .Alternate bit@ifever  >unsigned  else  >signed  then ;
( Formats an integer parameter as hexadecimal UPPERCASE. )
: >HEXADEC ( ... a # -- ... a # )  Control .Uppercase bit+!  >hexadec ;
( Formats a FPU parameter as exponential lowercase. )
: >expon ( ... a # -- ... a # )  ... ;
( Formats a FPU parameter as exponential UPPERCASE. )
: >EXPON ( ... a # -- ... a # )  ... ;
( Formats a FPU parameter as floating point lowercase. )
: >float ( ... a # -- ... a # )  ... ;
( Formats a FPU parameter as floating point UPPERCASE. )
: >FLOAT ( ... a # -- ... a # )  ... ;
( Formats a FPU parameter as scientific lowercase. )
: >scient ( ... a # -- ... a # )  ... ;
( Formats a FPU parameter as scientific UPPERCASE. )
: >SCIENT ( ... a # -- ... a # )  ... ;
( Formats a timedate parameter as date/time lowercase. )
: >time ( ... a # -- ... a # )  ... ;
( Formats a timedate parameter as date/time UPPERCASE. )
: >TIME ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as percentage. )
: >percent ( ... a # -- ... a # )  '%' usize swap 8u<< + CharBuffer tuck !  insert$ ;
( Formats an integer parameter as permillage. )
: >permille ( ... a # -- ... a # )  '‰' usize swap 8u<< + CharBuffer tuck !  insert$ ;
( Inserts a platfor-specific newline sequence. )
: >newline ( ... a # -- ... a # )  cNEWLINE usize swap 8u<< + CharBuffer tuck !  insert$ ;

create Rules                      ( The list of rules. )
  ' >bool ', ' >BOOL ',           ( b and B )
  ' >string ', ' >STRING ',       ( s and S )
  ' >plural ', ' >PLURAL ',        ( p and P )
  ' >char ', ' >CHAR ',           ( c and C )
  ' >decimal ', ' >DECIMAL ',     ( d and D )
  ' >octal ', ' >OCTAL ',         ( o and O )
  ' >hexadec ', ' >HEXADEC ',     ( h and H )
  ' >expon ', ' >EXPON ',         ( e and E )
  ' >float ', ' >FLOAT ',         ( f and F )
  ' >scient ', ' >SCIENT ',       ( g and G )
  ' >percent ', ' >permille ',    ( % and ‰ )
  ' >time ', ' >TIME ',           ( t and T )
  ' >newline ',                   ( n )

( Formats argument [NextArg] according to the specification following at address a with length #,
  consuming the specification. )
: formatArg ( ... a # -- ... a' #' )  parseFlags  parseWidth
  0 Precision!  0≠?if  over c@ '.'=if  parsePrecision  then  then
  0 Arg#!  0≠?if  over c@ ':'=if  parseArg#  then  then
  Control .?ReuseArg bit@− if  NextArg@ 1− 0 max NextArg!  then
  0≠?if  over c@ "bBsSpPcCdDoOxXeEfFgG%‰tTn" count rot cfind ?dupunless
    ecr "\e[1mWarning: Unknown formatting rule '" $.. over c@ eemit "' skipped.\e[22m" $.. exit then
  >r 1+> Rules r> 1− cells+ @ executeWord ;

public static section --- API

( Formats template f$ using # arguments ... into buffer b$ with expected size 256. )
: format$ ( ... # f$ b$ -- )  dup >x 256 0 cfill   ( ... # f$ ) swap #Args!  2 NextArg!  0 Control!
  count begin ?dup while
    x@ c@ 255=if  x> #Args@ 1+ udrop exit  then  ( Buffer overflow protection )
    over c@ '%'=if  1+> formatArg  else  over c@ x@ count + c!  x@ 1c+!  1?+>  then  repeat drop
  x> #Args@ 1+ udrop ;

( Formats template f$ using # arguments ... into a temporary buffer, and returns address a$ of the
  rendered result. )
: format ( ... # f$ -- a$ )  Rendering format$  Rendering ;

vocabulary;
export Format
