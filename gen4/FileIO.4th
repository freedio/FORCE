vocabulary FileIO
  requires" FORTH.voc"
  requires" Char.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" OS.voc"
  requires" Memory.voc"
  requires" UnixError.voc"
  requires" LinuxFile.voc"

=== File Management ===

variable @INBUFFER                ( Address of current input buffer )
variable INFILE                   ( Instance number of current input file )
variable CURSOR                   ( Cursor into the current input buffer )
variable LENGTH                   ( Length of the current input buffer )

variable OUTFILE                  ( Instance number of current output file )

( Opens source file a$ for input. )
: openSource ( a$ -- )  newFile  name!  r/o seq  openFile  unlessever
    >errtext swap name@ 2 "Error: Failed to open file «%s»: %s!"|! abort  then
   dup INFILE !  name@ INFILENAME !  CURSOR 0!  LENGTH 0!  @INBUFFER 0!  ;
( Closes and discards the current source file. )
: closeSource ( -- )  INFILE @ validFile? if  INFILE @ discardFile ( unlessever
  >errtext INFILE @ name@+ handle@ 3 "Warn: Failed to close handle %d of file %s: %s"|.. abort  then )
  INFILE 0! then ;
( Opens target file a$ for output, creating it if it doesn't exist. )
: openTarget ( a$ -- )
  newFile  name!  w/o ?create ?truncate seq &644 mode!  openFile unlessever
    >errtext swap name@ 2 "Error: Failed to create file «%s»: %s!"|! abort  then
  OUTFILE ! ;
( Closes and discards the current target file. )
: closeTarget ( -- )  OUTFILE @ validFile? if  OUTFILE @ discardFile ( unlessever
  >errtext INFILE @ name@+ handle@ 3 "Warn: Failed to close handle %d of file %s: %s"|.. abort  then )
  OUTFILE 0! then ;
( Opens the console for input. )
: openConsole ( -- )  "Console" INFILENAME !  CURSOR 0!  LENGTH 0!  @INBUFFER 0!
  0 newFile file[] tuck .handle! .open+ ;

=== Source File Stack ===

variable @SOURCE-STACK            ( Address of the source stack )
variable @SOURCE-SP               ( Address of the source stack pointer )

( Returns address a of the source stack, allocating the stack if necessary. )
: sourceStack@ ( -- a )  @SOURCE-STACK dup @ unlessever  1 allocPages over !  then  @ ;
( Returns source stack pointer a, initializing it if necessary. )
: sourceSP@ ( -- a )  @SOURCE-SP dup @ unlessever  sourceStack@ over !  then  @ ;
( Saves a to source stack pointer. )
: sourceSP! ( a -- )  @SOURCE-SP ! ;
( Checks if there are files on the stack. )
: source? ( -- ? )  sourceStack@ @SOURCE-SP @ u< ;
( Pushes the current source file on the source file stack. )
: source> ( -- )
  @INBUFFER @  CURSOR @  LENGTH @  INPAGE @  INLINE @  INCOLUMN @  INFILE @  INFILENAME @
  sourceSP@  8 0 udo !++ loop  sourceSP!
  @INBUFFER 0!  CURSOR 0!  LENGTH 0!  INPAGE 0!  INLINE 0!  INCOLUMN 0!  INFILE 0!  INFILENAME 0! ;
( Pops the current source file from the source file stack. )
: >source ( -- )  closeSource  source? if
    sourceSP@  8 0 udo --@ loop  sourceSP!
    INFILENAME !  INFILE !  INCOLUMN !  INLINE !  INPAGE !  LENGTH !  CURSOR !  @INBUFFER !  then ;

=== Reading the Source File ===

( Starts reading from source file a$. )
: source ( a$ -- )  INFILE @ if  source>  then  openSource ;
( Stops reading from the current source file — closes the file and pops it from the source stack. )
: unsource ( -- )  >source ;
( Checks if the input buffer has no more characters left. )
: bufferEmpty? ( -- ? )  CURSOR @ LENGTH @ = ;
( Starts reading from the console. )

--- Buffer Management ---

( Returns current input buffer a, allocating it if necessary. )
: inbuffer@ ( -- a )  @INBUFFER dup @  unlessever   1 allocPages  over  !  then  @  ;
( Floods the current input buffer.  Actually, only half of the buffer is read after moving the
  lower half up — this allows for simpler pushbacks. )
: __flood ( -- )
  CURSOR @ PAGE# 2u/ − 0>?if  dup inbuffer@ 2dup + ( # ta sa ) flip PAGE# r− cmove  then
  0 max dup CURSOR −! LENGTH −!  LENGTH @ inbuffer@ over + PAGE# rot − INFILE @  readFile unlessever
     >errtext INFILENAME @ INFILE @ 3 "Error: Failed to read from handle %d (file «%s»): %s"|! abort
    then  LENGTH +!  ;
( Floods the current input buffer.  If STDIN is read, a prompt is written to the console first. )
: _flood ( -- )  INFILE @ unless  cr "> ".  then  __flood ;
( Floods the input buffer if no more characters are left in the buffer. )
: ?flood ( -- )  bufferEmpty? ifever  _flood  then ;
( Floods the input buffer — over file boundaries, if necessary. )
: flood ( -- ) _flood  begin  bufferEmpty?  source?  and while  >source  ?flood  repeat  ;

--- Reading Raw Characters ---

( Returns the next character from the input source, or 0 if no more characters are available. )
: _getChar ( -- c|0 )  bufferEmpty?  ifever  flood  then
   CURSOR dup @ dup LENGTH @  u<unless   2drop 0  else  inbuffer@ +  c@ swap 1+!  then  ;

--- Reading UTF-8 Characters ---

( Reads the next UTF-8 byte, "adds" it to uc and returns the combination uc'. )
: utf8+ ( uc -- uc' )  _getChar dup $C0 and $80=if  $3F and swap 6u<< +  else
    INFILENAME @ INCOLUMN @ INLINE @ 4 roll
    4 "Error: Invalid UTF-8 code byte 2 %x at %d.%d in file «%s»!"|! abort  then ;
( Reads and returns UTF-8 2-byte sequence uc with prefix c. )
: utf8-2 ( c -- uc )  1FH and  utf8+ ;
( Reads and returns UTF-8 3-byte sequence uc with prefix c. )
: utf8-3 ( c -- uc )  0FH and  utf8+  utf8+ ;
( Reads and returns UTF-8 4-byte sequence uc with prefix c. )
: utf8-4 ( c -- uc )  07H and  utf8+  utf8+  utf8+ ;
( Reads and returns UTF-8 5-byte sequence uc with prefix c. )
: utf8-5 ( c -- uc )  03H and  utf8+  utf8+  utf8+  utf8+ ;
( Reads and returns UTF-8 6-byte sequence uc with prefix c. )
: utf8-6 ( c -- uc )  01H and  utf8+  utf8+  utf8+  utf8+  utf8+ ;
( Reads and returns UTF-8 7-byte sequence uc with prefix c. )
: utf8-7 ( c -- uc )  00H and  utf8+  utf8+  utf8+  utf8+  utf8+  utf8+ ;
( Reads and returns UTF-8 8-byte sequence uc with prefix c. )
: utf8-8 ( c -- uc )  00H and  utf8+  utf8+  utf8+  utf8+  utf8+  utf8+  utf8+ ;
( Returns the next Unicode character from the source, or 0 if no more characters are available. )
: _nextChar ( -- uc|0 )
  begin  _getChar  7#?unless  exit  then  dup c0->
    5=?if  drop utf8-2 exit  then
    4=?if  drop utf8-3 exit  then
    3=?if  drop utf8-4 exit  then
    2=?if  drop utf8-5 exit  then
    1=?if  drop utf8-6 exit  then
    0=?if  drop utf8-7 exit  then
    -1=?if  drop utf8-8 exit  then
     INFILENAME @ INCOLUMN @ INLINE @ 4 roll
    4 "Warn: Invalid UTF-8 code %x at %d.%d in file %s: skipped!"|.  again ;
( Returns the next Unicode character from the source, or 0 if no more characters are available.
  Updates the position. )
: nextChar ( -- uc|0 )  _nextChar   13=?unless
   10=?if  INLINE 1+!  INCOLUMN 0!  else
   12=?if  INPAGE 1+!  INLINE 0!  INCOLUMN 0!  else
   INCOLUMN 1+!  then  then  then ;

( Checks if the character at cursor x is a UTF-8 prefix byte [first byte of a UTF-8 sequence]. )
: UTF8-prefix? ( x -- x ? )  dup inbuffer@ + c@ $C0 and $80≠ ;
( Pushes the last unicode character back to the source file.  Also updates the position. )
: pushback ( -- )  CURSOR @ ?dupif  begin  1- UTF8-prefix?  until  CURSOR !  INCOLUMN 1-!  then ;

--- Parsing C-Style and Unicode Character Escape Sequences ---

create ESCAPE-LETTERS  10 d, 'a' d, 'b' d, 'e' d, 'f' d, 'n' d, 'r' d, 't' d, 5CH d, 27H d, 22H d,
create LETTER-ESCAPES  10 d,   7 d,   8 d,  27 d,  12 d,  10 d,  13 d,   9 d, 5CH d, 27H d, 22H d,
variable ESCAPED
variable CHAR-VALUE

: octal? ( uc -- uc ? )  dup '0' '8' between ;
( Parses an octal escape sequence that started with the Unicode digit u, reading and processing
  at most 3 characters until the next character is no longer a digit between 0 and 7. )
: parseOctalEscape ( u -- uc|0 )
  0 swap 3 0 do  '0'- 8u*+  nextChar octal?  ?loop  drop  pushback ;
: hex? ( uc -- uc -? )  "0123456789ABCDEFabcdef" count 2pick cfind ;
( Converts digit letter uc into binary hex digit u. )
: >hex ( uc -- u )  dup '`'> 32and -  '0'-  dup 9> 7and - ;
( Parses a hex escape sequence that started with '\x', reading and processing at most 2 characters
  until the next character is no longer a digit between 0 and 9 or a letter between 'a' and 'f' or
  'A' and 'F'. )
: parseHexEscape ( -- uc|0 )
  0  2 0 do  nextChar hex? unless  drop pushback  quitloop  then  >hex 16u*+  loop ;
( Parses a unicode escape sequence that started with '\u', reading 4 to 6 hex digits of the Unicode
  code point. )
: parseUnicodeEscape ( -- uc|0 )  0  4 0 do  nextChar hex? unless
    "4 to 6 hex digits expected for a Unicode escape!"! abort  then  >hex 16u*+  loop
  2 0 do  nextChar hex? unless  drop pushback  quitloop  then  >hex 16u*+  loop ;

150 bloat ( TODO remove )

( Parses an escape sequence [without the leading escape] from the source, returning the resulting
  unicode character, or 0 for a dangling backslash at the end of a source file.  If no valid escape
  sequence came after the leading backslash, the backslash itself is returned. )
: parseEscape ( -- uc|0 )  bufferEmpty? ifever  0 exit  then  nextChar
  octal? if  parseOctalEscape exit  then
  'x'=?if  drop parseHexEscape exit  then
  'u'=?if  drop parseUnicodeEscape exit  then
  ESCAPE-LETTERS d@++ 2pick dfind ?dupif  nip 4* LETTER-ESCAPES + d@  ESCAPED on  exit  then
  5CH ;

--- Reading Cooked Characters ---

( Returns the next Unicode character or escape sequence from the source, or 0 if no more characters
  are available.  If the character was a character escape, ESCAPED is set to on — this may be used
  to distinguish a plain double or single quote or backslash from an escaped one. )
: readChar ( -- uc|0 )  ESCAPED off  nextChar  '\\'=?if  drop parseEscape  then  ;

--- Reading Words ---

create BUFFER  256 0allot         ( The "current word" buffer )
variable QUOTE-LOCK               ( Boolean indicating if white-space is significant for token )

( Prevents whiteSpaceDelimiter from triggering until another double-quote character appeared if uc
  is a double-quote character. )
: quoteLock ( uc -- uc )  dup '"'= QUOTE-LOCK ! ;
( Re-enables whiteSpaceDelimiter triggering if uc is a double-quote character. )
: quoteUnlock ( uc -- uc )  dup '"'=if  QUOTE-LOCK 0!  then ;
( Resets the current word to length 0 and returns the address of the first position. )
: buffer0! ( -- a )  BUFFER 0! ;
( Checks if unicode character uc is the same as delimier character dc.  If so, returns 0 [false],
  otherwise returns the original arguments. )
: explicitDelimiter ( dc uc -- dc uc | 0 )  2dup ≠ and  0=?if  nip  then ;
( Checks if unicode character uc is white-space.  If QUOTE-LOCK is not set and uc is white-space,
  returns it and true, otherwise returns false, i.e. the token is complete. )
: whiteSpaceDelimiter ( uc -- uc | 0 )  dup whitespace? not QUOTE-LOCK @ or and ;
( Reads characters from the source file into buffer a$ until the specified delimiter method reports
  that enough characters have been read, then returns the buffer.  In strict mode, this method will
  fail when EOF is reached before the delimiter method reported true. )
: readChars ( ... 'delimiterMethod -- )  begin  readChar ?dup while
  FileIO 2pick execute  dup if  quoteUnlock dup BUFFER uc$+  then  aslong  then ;
( Checks if unicode character uc belongs to class whitespace.  If so, returns 0 and false, otherwise
  the character itself and non-false. )
: nonblank ( uc -- uc ~f | 0 f )  dup whitespace? not and ;
( Skips white-space characters in the source stream until either a non-white-space was found or EOF
  was reached.  Returns the non-blank character [already added to the BUFFER] or 0 for EOF. )
: skipBlanks ( -- uc|0 )  begin  readChar dup while  nonblank ?dup until  dup BUFFER uc$+  then ;
( Skips white-space, then reads white-space delimited word a$ from the source stream, returning the
  buffer containing the counted word -- which may be an empty string if no more words are available,
  i.e. on EOF.
    In strict compiler mode, this method will fail and abort the compiler if a delimiting
  white-space character was not found after at least one non-white-space character was encountered.
    Note that this buffer is volatile and will be overwritten when the next call to readWord or
  readString starts. )
: readWord ( -- a$ )
  buffer0!  skipBlanks quoteLock if  FileIO tick whiteSpaceDelimiter readChars 2drop  then  BUFFER ;
( Reads word delimited by unicode character uc from the source stack, returning an empty string if
  no more characters are available -- which means that this method was incoked at the end of the
  source stack.
    In strict compiler mode the method will fail and abort the compiler if the terminating character
  was not encountered before the end of the file.
    Note that this buffer is volatile and will be overwritten when the next call to readWord or
  readString starts. )
: readString ( uc -- a$ )  buffer0!  FileIO tick explicitDelimiter readChars  2drop  BUFFER ;
( Skips the rest of the current line, if the cursor is not at the beginning of a new line. )
: skip2EOL ( -- )  begin  INCOLUMN @ while  readChar drop  repeat ;

=== Writing the Target File ===

( Writes the buffer of # bytes at address a to the target file. )
: writeTarget ( a # -- )  OUTFILE @ writeFile unlessever
  >errtext OUTFILE @ dup name@ swap 3 "Error: Failed to write to handle %d (file «%s»): %s"|!
  abort  then ;


vocabulary;
