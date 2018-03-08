/* FORCE Linux API Vocabulary (64-bit)
 * ===================================
 * version 0
 */

vocabulary OS
requires" FORTH.voc"
requires" IO.voc"

:( Returns length # of a zero-terminated string at address a.  Returns -1 if the string is not
   zero-terminated! )
: 0count ( a -- a # )  dup -1 0 cfind 1− ;

:( Returns to the operating system with exit code 0. )
: bye ( -- )  cr BYE, ;
:( Returns to the operating system with exit code n. )
: terminate ( n -- )  cr SYS_TERMINATE, ;
:( Aborts the program with error code 1. )
: abort ( -- )  "Aborting ... stack trace:"!
  rdepth 0 do  r> r> r>  cr a.  >r >r  loop
  cr 1 terminate ;

:( Opens file with zero-terminated name fnz, flags fl and file mode md, returning file descriptor
   fd. )
: sysOpenFile ( fnz fl md -- fd t | errno f )  SYS_OPEN, >err2 ;
: sysCloseFile ( fd -- t | errno f )  SYS_CLOSE, >err1 ;
:( Reads # bytes from file descriptor fd to buffer a, returning the amount of bytes actually read. )
: sysReadFile ( a # fd -- u t | errno f )  SYS_READ, >err2 ;
( Sets the cursor of file descriptor fd at off bytes past origin orig [0: beginning, 1: current pos,
  2: end of file], returnsing the new apsolute position. )
: sysSeekFile ( off orig fd -- u t | errno f )  SYS_SEEK, >err2 ;
:( Writes # bytes from buffer a to file descriptor fd, returning the amount of bytes actually
   written. )
: sysWriteFile ( a # fd -- u t | errno f )  SYS_WRITE, >err2 ;
: sysMakeDirectory ( fnz -- t | errno f )  &755 SYS_MKDIR, >err1 ;

:( Sets the program break to u1 [or queries it if 0], returning the new [or current] break u2. )
: pgmbrk ( u1|0 -- u2 )  SYS_BRK, ;

=== Missing Code ===

: ... ( -- )  "Not implemented!"abort ;

vocabulary;
