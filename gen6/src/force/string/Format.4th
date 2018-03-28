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

vocabulary Format

private static section --- Utils and State

create NumBuffer  128 allot       ( Buffer for numeric argument conversion. )

  cell variable Char              ( Buffer for a Unicode character. )
  cell variable Digits            ( Number of digits in numeric conversion. )
  cell variable NextArg           ( Index of the next argument. )
udword variable Control           ( Collected flags. )
 ubyte variable Width             ( Parsed field width. )
 ubyte variable Precision         ( Parsed field precision. )
 ubyte variable #Args             ( Number of arguments to process. )
 ubyte variable Arg#              ( Index of the argument to use. )
 ubyte variable PadChar           ( ASCII character to pad the field with. )

 0 constant .LeftAlign            ( true if field is left-aligned. )
 1 constant .Alternate            ( true if alternate form requested. )
 2 constant .ForceSign            ( true if sign is forced even when positive. )
 3 constant .DoPadding            ( true if buffer is padded with PadChar. )
 4 constant .GroupNums            ( true if numbers should include the group separator. )
 5 constant .Parenthes            ( true if minus sign is replaced with parentheses. )
 6 constant .?Negative            ( true if the current number is negative. )
 7 constant .?ReuseArg            ( true if last argument should be re-used. )

10 constant .Uppercase            ( true if letters should be converted to upper case. )

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


--- Rules ---

( Formats a boolean parameter as lowercase. )
: >bool ( ... a # -- ... a # )  ... ;
( Formats a boolean parameter as UPPERCASE. )
: >BOOL ( ... a # -- ... a # )  ... ;
( Formats a string parameter as lowercase. )
: >string ( ... a # -- ... a # )  ... ;
( Formats a string parameter as UPPERCASE. )
: >STRING ( ... a # -- ... a # )  ... ;
( Formats a char parameter as lowercase. )
: >char ( ... a # -- ... a # )  ... ;
( Formats a char parameter as UPPERCASE. )
: >CHAR ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as decimal lowercase. )
: >decimal ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as decimal UPPERCASE. )
: >DECIMAL ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as octal lowercase. )
: >octal ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as octal UPPERCASE. )
: >OCTAL ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as hexadecimal lowercase. )
: >hexadec ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as hexadecimal UPPERCASE. )
: >HEXADEC ( ... a # -- ... a # )  ... ;
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
: >percent ( ... a # -- ... a # )  ... ;
( Formats an integer parameter as permillage. )
: >permille ( ... a # -- ... a # )  ... ;
( Inserts a platfor-specific newline sequence. )
: >newline ( ... a # -- ... a # )  ... ;

create Rules                      ( The list of rules. )
  ' >bool ', ' >BOOL ',           ( b and B )
  ' >string ', ' >STRING ',       ( s and S )
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
  0≠?if  over c@ "bBsScCdDoOxXeEfFgG%‰tTn" count rot cfind ?dupunless
    ecr "\e[1mWarning: Unknown formatting rule '" e$. eemit "' skipped.\e[22m" e$.  exit  then
  >r 1+> Rules r> 1− cells+ @ execute ;

public static section --- API

( Formats template f$ using # arguments ... into buffer b$ with expected size 256. )
: format$ ( ... # f$ b$ -- )  dup 256 0 cfill  >r  swap #Args!  2 NextArg!  0 Control!
  count begin ?dup while
    r@ c@ 255=if  r> #Args@ 1+ udrop exit  then  ( Buffer overflow protection )
    over c@ '%'=if  1+> formatArg  else  over c@ r@ count + c!  r@ 1c+!  then  repeat drop
  r> #Args@ 1+ udrop ;

vocabulary;
export Format
