vocabulary Module
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" UnixError.voc"
  requires" LinuxFile.voc"
  requires" LogLevel.voc"

create SOURCE$  256 0allot          ( Name of the source file [without extension] )
create OUTPUT$  256 0allot          ( Name of the output file [without extension] )
create MODULE$  256 0allot          ( Name of the module [with extension] )

( Returns the source file as specified on the command line. )
: sourcefile@ ( -- a$|0 )  SOURCE$ dup c@ 0- and ;
( Returns the target file as specified on the command line. )
: targetfile@ ( -- a$|0 )  OUTPUT$ dup c@ unless  drop sourcefile@  then ;
( Returns the module name. )
: module@ ( -- a$|0 )  MODULE$ dup c@ 0- and ;

create MAGIC$   9 0allot          ( Buffer for the file magic number, incl. leading length byte )
create HEADER   120 0allot        ( Buffer for the module header )
create SPAREA   16 0allot         ( Spare area )
variable NEXTPOS                  ( Next position in module file )

( Positions module file at off bytes from the beginning.  Aborts with an appropriate error message
  if an error occurs.  Needs a fd on the X stack. )
: positionModule ( off -- :X: fd -- fd )  x@ seekFile unlessever
  >errtext x@ name@ 2 "Error while positioning to address in module «%s»: %s!"|!  abort then  drop ;
( Reads u1 bytes into buffer at address a.  Aborts with an appropriate error message if an error
  occurs.  Needs a fd on the X stack. )
: readModule ( a u1 -- :X: fd -- fd )  ?dupunless drop  else  tuck x@ readFile unlessever
  >errtext x@ name@ 2 "Error while reading module «%s»: %s!"|!  abort  then
  ≠??if  swap 2 "Requested to read %d bytes, but got only %d!"|!  abort  then
  debug? if  cr 2dup 2 "D: Read %d/%d bytes"|log  then  2drop then ;
( Writes u1 bytes from buffer at address a.  Aborts with an appropriate error message if an error
  occurs.  Needs a fd on the X stack. )
: writeModule ( a u1 -- :X: fd -- fd )  tuck x@ writeFile unlessever
  >errtext x@ name@ 2 "Error while reading module «%s»: %s!"|!  abort  then
  ≠??if  swap 2 "Requested to write %d bytes, but only %d were writtern!"|!  abort  then
  debug? if  cr 2dup 2 "D: Wrote %d/%d bytes"|log  then  2drop ;
( Aligns module to position u by reading u − NEXTPOS @ bytes into the [obsolete] header structure,
  and then updating NEXTPOS. )
: alignModule ( u -- )
  NEXTPOS 2dup @ − SPAREA swap debug? if  cr NEXTPOS @ over 2 "Aligning %d bytes to %08x."|log  then  readModule ! ;
( Loads module with name m$ into the # segments of vocabulary at address @v.  Aborts with a message
  if the module was not found or could not be loaded. )
: loadModule ( @v # m$ -- )  newFile name! r/o openFile unlessever
    >errtext swap name@ 2 "Error while opening module «%s»: %s!"|! abort  then
  >x MAGIC$ dup 1+ 128 readModule dup 8c+! "<4ceMod>" $$= unlessever
    x@ name@ 1 "Error: File «%s» seems to be no FORCE module!"|! abort  then
  NEXTPOS 128!
  MAGIC$ 1+ 128 hexdump
  HEADER swap 0 do
    d@++ alignModule  d@++ 0=?if  drop swap cell+ swap else
    createHeap selectHeap  dup NEXTPOS +!  dup allot@  swap readModule  selectedHeap rot !++ swap  then  loop
  2drop
  x@ closeFile unlessever  >errtext x@ name@ 2 "Error while closing module «%s»: %s"|!  abort  then
  x> drop ;
( Saves the # segments of vocabulary at address @v to module with name m$. )
: saveModule ( @v # m$ -- )  newFile name! w/o ?create ?truncate seq &644 mode! openFile unlessever
    >errtext swap name@ 2 "Error: Failed to create file «%s»: %s!"|! abort  then
  debug? if  cr x@ name@ 1 "D: Writing data to file «%s»"|log  then
  >x  HEADER 120 0 cfill  "<4ceMod>" MAGIC$ $!  NEXTPOS 128!  2dup  0 do
    NEXTPOS @ MAGIC$ count + d!  MAGIC$ 4c+!  dup @  -1≠?if  heap%  else  0and  then
    dup MAGIC$ count + d!  MAGIC$ 4c+! 16 >| NEXTPOS +!  cell+ loop  drop  MAGIC$ 1+ 128 writeModule
  0 do  dup @  -1≠?if  dup @heap% 16 >| writeModule  then drop  cell+ loop  drop
  x@ closeFile unlessever  >errtext x@ name@ 2 "Error while closing module «%s»: %s"|!  abort  then
  x> drop ;

vocabulary;
