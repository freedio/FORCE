vocabulary LinuxFile
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" UnixError.voc"
  requires" StringFormat.voc"
  requires" Memory.voc"

create FILES  128 cells 0allot    ( Addresses of 128 files )

=== File structure ===

0000  dup constant HANDLE         ( The Unix file handle. )
cell+ dup constant @NAME          ( Address of the zero-terminated + counted file name. )
cell+ dup constant FLAGS          ( File access and status flags. )
cell+ dup constant MODE           ( File mode, used only for CREATE or TMPFILE. )
cell+ dup constant STATE          ( File state )
cell+ constant FILE#

: .handle ( a -- a.handle )  HANDLE + ;
: .name ( a -- a.name )  @NAME + ;
: .flg ( a -- a.flags )  FLAGS + ;
: .mode ( a -- a.mode )  MODE + ;
: .state ( a -- a.state )  STATE + ;
: .handle! ( handle a -- )  .handle ! ;
: .handle@ ( a -- handle ) .handle @ ;
: .name@ ( a -- name )  .name @ ;
: .name0@ ( a -- name0 )  .name @ 1+ ;
: .name! ( n$ a -- )  .name ! ;
: .flags@ ( a -- flags )  .flg @ ;
: .mode@ ( a -- mode )  .mode @ ;
: .mode! ( u a -- )  .mode ! ;
: .name@+ ( a -- name a )  dup .name@ swap ;
: .name0@+ ( a -- name0 a )  dup .name0@ swap ;
: .flags@+ ( a -- flags a )  dup .flags@ swap ;
: .mode@+ ( a -- mode a )  dup .mode@ swap ;

: .open? ( a -- ? )  .state 0bit@ ;
: .open+ ( a -- )  .state 0bit+! ;
: .open− ( a -- )  .state 0bit−! ;

=== Instance Management ===

--- Constructor ---

( Creates a file instance and stores its address at a. )
: _newFile ( a -- )  FILE# allocate swap ! ;
( Creates a new file instance and returns its instance number. )
: newFile ( -- # )  FILES 128 0 do  dup @ 0=if  _newFile i unloop exit  then  cell+ loop
  cr "Error: Out of file space!".. abort ;

--- Instance Address ---

( Returns address @file of instance #. )
: file[] ( # -- @file )
  dup FILES swap cells+ @ ?dupunless 1 "Error: Invalid file instance: %d"|! abort  then  nip ;

=== Getting and Setting File Attributes ===

( Returns handle u of file instance #. )
: handle@ ( # -- u )  file[] .handle@ ;
( Returns name n$ of file instance #. )
: name@ ( # -- n$ )  file[] .name@ ;
( Returns name n$ of file instance #, chain variant. )
: name@+ ( # -- n$ # )  dup name@ swap ;
( Sets the file name of instance # to n$. )
: name! ( n$ # -- # )  dup file[]
  rot dup c@ 1+ dup  allocate ( # @file n$ n# a ) dup 5 roll  .name! swap  cmove  ;
( Sets file access mode of instance # to read only. )
: r/o ( # -- # )  dup file[] .flg -4and! ;
( Sets file access mode of instance # to write only. )
: w/o ( # -- # )  dup file[] .flg dup -4and! 1or! ;
( Sets file access mode of instance # to read and write. )
: r/w ( # -- # )  dup file[] .flg dup -4and! 2or! ;
( Sets conditional create mode. )
: ?create ( # -- # )  dup file[] .flg &100or! ;
( Sets conditional trancate mode. )
: ?truncate ( # -- # )  dup file[] .flg &1000or! ;
( Indicates sequential-only access on file instance # as a hint to optimize read-ahead on open. )
: seq ( # -- # ) ;
: mode! ( # u -- # )  over file[] .mode! ;

( Seek origins: )
: top-> ( -- 0 ) 0 ;
: cur-> ( -- 1 ) 1 ;
: end-> ( -- 2 ) 2 ;

=== File Operations ===

--- Validation ---

( Checks if # is a valid file number. )
: validFile? ( # -- ? )  dup 0 128 within if  FILES swap cells+ @ 0-  else  drop false  then ;

--- Open / Create / Close File ---

( Opens file #, assuming that its file name, access flags and file mode have already been set,
   returning the file instance and true, or a UNIX error code and false. )
: openFile ( # -- # t | # errno f )  dup file[] dup .open? if  drop true exit  then
  .name0@+ .flags@+ .mode@+ >r
  sysOpenFile  dup if  swap r@ .handle! r@ .open+  then  r> drop ;
( Closes file # if it is open, returning true or a UNIX error code and false. )
: closeFile ( # -- t | errno f )  file[] dup >r .open? if
  r@ .handle@ sysCloseFile dup if r@ .open− then  else  2drop false  then  rdrop ;
( Closes file # if it is still open, ignoring errors. )
: ?closeFile ( # -- )  closeFile unless  drop  then ;
( Discards file #, closing it if it's open. )
: discardFile ( # -- )  dup ?closeFile  dup file[] .name@+ free free  FILES swap cells+ 0! ;

--- Read / Write File ---

( Requests to read u1 bytes from file # to buffer a, assuming the file is open for reading.  Returns
  the actual number u2 of bytes read and true, or a UNIX error code and false. )
: readFile ( a u1 # -- u2 t | errno f )  handle@ sysReadFile ;
( Requests to write u1 bytes from buffer a to file #, assuming the file is open for writing. Returns
  the actual number u2 of bytes written and true, or a UNIX error code and false. )
: writeFile ( a u1 # -- u2 t | errno f )  handle@ sysWriteFile ;
( Sets the cursor of file # at off bytes after orig [top->: from beginning of file, cur->: from the
  current position, end-> from the end of file], returning the new absolute cursor position and true
  or a UNIX error code and false. )
: seekFile ( off orig # -- pos t | errno f )  handle@ sysSeekFile ;

( Requests to read u bytes from file # into buffer a, assuming the file is open for reading.  If an
  error occurs, prints an appropriate error message and aborts.  If the file is shorter than u
  bytes, also aborts with a suitable error message. )
: readFile! ( a u # -- )  2dup >r >r readFile unlessever
  r> drop >errtext r> name@ 2 "Error while reading file «%s»: %s!"|abort  then
  r> 2dup ≠ifever
    swap r> name@ 3 "Error while reading file «%s»: only %d bytes of %d were read!"|abort  then
  r> 3drop ;
( Requests to write u bytes from buffer a to file #, assuming the file is open for writing.  If an
  error occurs, prints an appropriate error message and aborts.  If less than u bytes could be
  written, also aborts with a suitable error message. )
: writeFile! ( a u # -- )  2dup >r >r writeFile unlessever
  r> drop >errtext r> name@ 2 "Error while writing file «%s»: %s!"|abort  then
  r> 2dup ≠ifever
    swap r> name@ 3 "Error while writing file «%s»: only %d bytes of %d were written!"|abort  then
  r> 3drop ;

create FILENAME$   256 0allot     ( Buffer for the FNZ name. )
create FILENAMEZ   256 0allot     ( Buffer for the filename. )
: $>z ( f$ -- fnz )  FILENAME$ tuck 256 0 cfill  count FILENAME$ swap cmove ;
( Checks if file with path fn$ exists. )
: fileExists ( fn$ -- ? )  $>z  4 SYS_ACCESS, 0= ;

( Creates directory with path fnz. )
: mkdir ( fnz -- )  dup 0count FILENAMEZ 2dup c! 1+ swap cmove
  sysMakeDirectory unless  17=?if  drop exit  then
    >errtext FILENAMEZ 2 "Error while creating directory ‹%s›: %s"|abort  then ;
( Creates all non-existant directories of path fnz with length #. )
: mkdirs ( fnz # -- )  ?dupunless  drop exit  then  2dup '/' rcfind ?dup if  nip ( fnz u )
  1− 2dup + 0c!  2dup mkdirs  2dup + '/'c!  then  drop mkdir ;

( Creates the non-existent intermediate directories of path p$.  This stops at the last slash,
  i.e. in a path of "./a/b/", both a and b are deemed intermediate. )
: createPathComponents ( p$ -- )
  dup $>z swap c@  2dup '/' rcfind ?dup if  1− nip dup 2pick swap + 0c!  2dup mkdirs  then  2drop ;

vocabulary;
