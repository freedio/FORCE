require G0.4th
require M0-IA64.4th

/* FORCE Linux Macros for Intel Generation 6 (64-bit)
 * ==================================================
 * version 0

 * The stack comments on the macros show their net effect on the generated code, not their effect
 * when executed, as these macros must not have a stack effect unless otherwise specified.

 * Linux system calls:
 *
 * Syscall#     RAX
 * Arg 1        RDI
 * Arg 2        RSI
 * Arg 3        RDX
 * Arg 4        R10
 * Arg 5        R08
 * Arg 6        R09
 * Returns      RAX
 * May change   RCX, R11
 * Invoke       SYSCALL

 * More info about the individual system calls:
 * - http://main.lv/notes/syscalls.md#toc-2
 * - Linux man pages: man 2 xxxx (for BYE, and TERMINATE, xxxx is _exit)
 */

: CELLA ( -- cell )  8 ;
: CELLAS ( u -- u*cells )  3 << ;

require A0-IA64.4th
also Forcembler

: >LINUX ( u -- )  # RAX MOV  SYSCALL ;

: >err1 ( 0|-errno -- t | errno f )  RAX NEG  0= UNLESSEVER  RAX PUSH  THEN  CMC  RAX RAX SBB ;
: >err2 ( x|-errno -- x t | errno f )
  RAX RAX TEST  0< IFEVER  RAX NEG  STC  THEN  RAX PUSH  CMC  RAX RAX SBB ;

:( Exits FORCE and returns to the operating system with exit code 0. )
: BYE, ( -- )   RDI RDI XOR  60 >LINUX ;
:( Exits FORCE and returns to the operating system with exit code u. )
: SYS_TERMINATE, ( u -- )  RAX RDI MOV  60 >LINUX ;
:( Reads u1 bytes from file descriptor fd to buffer a and reports the number of bytes actually
   read, or an error code if negative. )
: SYS_READ, ( a u1 fd -- u2|-errno )
  RSI CELLA [RSP] XCHG  RDX 0 [RSP] XCHG  RDI PUSH  RAX RDI MOV  0 >LINUX  RDI POP
  RDX POP  RSI POP ;
:( Writes u1 bytes from buffer a to file descriptor fd and reports the number of bytes actually
   written, or an error code if negative. )
: SYS_WRITE, ( a u1 fd -- u2|-errno )  RSI CELLA [RSP] XCHG  RDX 0 [RSP] XCHG  RDI PUSH  RAX RDI MOV
  1 >LINUX  RDI POP  RDX POP  RSI POP ;
:( Opens the file with zero-terminated file name fnz, flags fl and mode md and returns the file
   descriptor, or an error code if negative. )
: SYS_OPEN, ( fnz fl md -- fd|-errno )  RDI CELLA [RSP] XCHG  RSI 0 [RSP] XCHG  RAX RDX MOV
  2 >LINUX  RSI POP  RDI POP ;
:( Closes the file with file descriptor fd and returns the negative error code or 0 for success. )
: SYS_CLOSE, ( fd -- -errno )  RDI PUSH  RAX RDI MOV  3 >LINUX  RDI POP ;
:( Reports the status of file with zero-terminated name fnz in buffer a and returns the negative
   error code, or 0 for success. )
: SYS_STAT, ( a fnz -- -errno )  RSI 0 [RSP] XCHG  RDI PUSH  RAX RDI MOV  4 >LINUX
  RDI POP  RSI POP ;
:( Reports the status of file with descriptor fd in buffer a and returns the negative error code,
   or 0 for success. )
: SYS_FSTAT, ( a fd -- -errno )
  RSI 0 [RSP] XCHG  RDI PUSH  RAX RDI MOV  5 >LINUX  RDI POP  RSI POP ;
:( Reports the status of file with zero-terminated name fnz in buffer a and returns the negative
   error code, or 0 for success.  In contrast to STAT-FILE, it reports the stats of the link for
   links rather than the stats of the file the link refers to. )
: SYS_LSTAT, ( a fnz -- -error )  RSI 0 [RSP] XCHG  RDI PUSH  RAX RDI MOV  6 >LINUX
  RDI POP  RSI POP ;
:( Polls for events on an array of polling structures in @p[] with p# elements and a poll timeout of
   t, and returns number # of structures with events, the negative error code, or 0 if the
   request timed out without any events. )
: SYS_POLL, ( @p[] p# t -- #|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  7 >LINUX
  RSI POP  RDI POP ;
:( Sets the cursor of file descriptor fd u1 bytes from origin orig and returns the absolute
   cursor position u2 from the beginning of the file, or the negative error code. )
: SYS_SEEK, ( u1 orig fd -- u2|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  8 >LINUX  RDI POP  RSI POP ;
:( Maps the region with length # at offset u in file with descriptor fd to a memory location at or
   near a controlled by flags fl, protects the area with protection state pr and returns the exact
   location of the area, or the negative error code.  u must be a multiple of the page size, and
   the length of the mapped area will also be a multiple of the page size, but # needs not be. )
: SYS_MMAP, ( a # pr fl u fd -- a|-errno )  4 CELLAS [RSP] RDI XCHG  3 CELLAS [RSP] RSI XCHG
  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG  0 [RSP] R09 XCHG  R08 PUSH  RAX R08 MOV
  9 >LINUX  R08 POP  R09 POP  R10 POP  RDX POP  RSI POP  RDI POP ;
:( Sets memory protection state pr on the area of length # starting at address a, and returns 0 or
   the negative error number. )
: SYS_MPROTECT, ( a # pr -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  10 >LINUX  RSI POP  RDI POP ;
:( Unmaps the memory region of length # at address a, and returns 0 or the negative error code. )
: SYS_MUNMAP, ( a # -- -errno )  CELLA [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  11 >LINUX
  RSI POP  RDI POP ;
:( Sets the program break to address a, and returns 0 or the negative error code. )
: SYS_BRK, ( a -- -errno )  RDI PUSH  RAX RDI MOV  12 >LINUX  RDI POP ;
:( Sets the new action descriptor for signal u to a1 if a1 is not NIL and returns the old one in a0
   unless a0 is NIL.  The size of the SA_MASK field of the structures must be passed in #.  Returns
   0 or the negative error code. )
: SYS_SIGACTION, ( a1 a0 u # -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RDI XCHG  R10 PUSH  RAX R10 MOV  13 >LINUX  R10 POP  RDI POP  RDX POP  RSI POP ;
:( Gets [in the structure at a0] and/or sets [to the structure in a1] the masked signal set
   according to the action in u, and returns 0 or the negative error code.  If a1 is NIL, the masked
   signals will not change; if a0 is NIL, the masked signals will not be reported. )
: SYS_SIGPROCMASK, ( a1 a0 u -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RDI XCHG  R10 PUSH  RAX R10 MOV  14 >LINUX  R10 POP  RDI POP  RDX POP  RSI POP ;
:( Performs I/O command cmd with arguments @args on file descriptor fd, and returns a value or 0,
   or the negative error code. )
: SYS_IOCTL, ( @args cmd fd -- x|-errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  16 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Reads # bytes from absolute position u in file with descriptor fd to buffer at a and returns
   the number of bytes actually read, or the negative error code. )
: SYS_PREAD, ( a # u fd -- u3|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  17 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Writes # bytes to absolute position u in file with descriptor fd to buffer at a and returns
   the number of bytes actually written, or the negative error code. )
: SYS_PWRITE, ( a # u fd -- u3|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  18 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Reads data from file with descriptor fd into multiple buffers specified at structure @vec with
   # elements, and returns the total number of bytes read, or the negative error code. )
: SYS_READV, ( @vec # fd -- u|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  19 >LINUX  RDI POP  RSI POP ;
:( Writes data to file with descriptor fd from multiple buffers specified at structure @vec with
   # elements, and returns the total number of bytes written, or the negative error code. )
: SYS_WRITEV, ( @vec # fd -- u|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  20 >LINUX  RDI POP  RSI POP ;
:( Checks the caller access permissions mode on the file with zero-terminated name fnz, returning
   0 for success or the negative error code. )
: SYS_ACCESS, ( fnz mode -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  21 >LINUX
  RSI POP  RDI POP ;
:( Creates a pipe and writes the file descriptors for the reading end at @fds[0] and for the writing
   end at @fds[2].  Returns 0 for success, or the negative error code. )
: SYS_PIPE, ( @fds -- -errno )  RDI PUSH  RAX RDI MOV  22 >LINUX  RDI POP ;
:( Monitors file descriptor sets @in [input], @out [output] and @exc [exception] with highest file
   descriptor + 1 in fds whether the specified state has occurred or is ready for the specified fds
   within the specified timeout interval @to.  Returns the total number u of ready file descriptors
   in all 3 sets, or the negative error code. )
: SYS_SELECT, ( @in @out @exc @to fds -- u|-errno )  3 CELLAS [RSP] RSI XCHG
  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG  0 [RSP] R08 XCHG  RDI PUSH  RAX RDI MOV
  23 >LINUX  RDI POP  R08 POP  R10 POP  RDX POP  RSI POP ;
:( Causes the current thread to yield in favor of other processes of the same priority.  Returns
   0 on linux. )
: SYS_YIELD, ( -- 0 )  RAX PUSH  24 >LINUX ;
:( Expands or shrinks the memory area of size u0 at a0 to size u1 [at new address a1] using control
   flags fl, and returns the final address of the memory block a2, or the negative error code. )
: SYS_MREMAP, ( a0 a1 u0 u1 fl -- a2|-errno )  3 CELLAS [RSP] RDI XCHG  2 CELLAS [RSP] R08 XCHG
  CELLA [RSP] RSI XCHG  RDX POP  R10 PUSH  RAX R10 MOV  25 >LINUX  R10 POP  RSI POP
  R08 POP  RDI POP ;
:( Synchronizes the mmapped area of length # at address a with the underlying file according to
   flags fl, returning the negative  error code or 0 for success. )
: SYS_MSYNC, ( a # fl -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV  26 >LINUX
  RSI POP  RDI POP ;
:( Checks whether the memory between page-aligned address a and address a+# is currently resident in
   memory, reporting to structure @vec of at least [length+PAGE_SIZE-1] / PAGE_SIZE bytes, and
   returns 0 for success or the negative error code. )
: SYS_MINCORE, ( a # @vec -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  27 >LINUX  RSI POP  RDI POP ;
:( Gives hint fl about usage of memory block at address a with size #, and returns 0 for success or
   the negative error code. )
: SYS_MADVISE, ( a # fl -- -errno)  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV  28 >LINUX
  RSI POP  RDI POP ;
:( Returns identifier id of a shared memory segment associated with key key.  Under conditions
   in flags fl, a new shared memory area of size # is created.  Returns the identifier or the
   negative error code. )
: SYS_SHMGET, ( key # fl -- id|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  29 >LINUX  RSI POP  RDI POP ;
:( Attaches shared memory segment id to the address space of the calling process at address a1
   according to control flags fl, and returns the address of the attached segment, or the negative
   error code. )
: SYS_SHMAT, ( a1 id fl -- a2|-errno )  CELLA [RSP] RSI XCHG  0 [RSP] RDI XCHG  RAX RDX MOV
  30 >LINUX  RDI POP  RSI POP ;
:( Performs shared memory control operation cmd to shared memory segment with the specified using
   the shmid_ds structure at @buf.  Returns a result according to the cmd, or the negative error
   code. )
: SYS_SHMCTL, ( @buf id cmd -- x|-errno )  CELLA [RSP] RDX XCHG  0 [RSP] RDI XCHG  RDI PUSH
  RAX RSI MOV  31 >LINUX  RSI POP  RDI POP  RDX POP ;
:( Duplicates file descriptor fd1, returning new file descriptor fd2 or the negative error code. )
: SYS_DUPFD, ( fd1 -- fd2|-errno )  RDI PUSH  RAX RDI MOV  32 >LINUX  RDI POP ;
:( Duplicates file descriptor fd1 to fd2, returning fd2 or the negative error code. )
: SYS_DUP2, ( fd1 fd2 -- fd2|-errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  33 >LINUX
  RSI POP  RDI POP ;
:( Waits for a signal. )
: SYS_PAUSE, ( -- )  RAX PUSH  34 >LINUX  RAX POP ;
:( Suspends the execution of the calling thread for the time defined in structure at @t1, reporting
   remaining time at an interruption in @t2, and returns 0 for success or the negative error code.
   This is a relative time function with its problems when being interrupted.  See clock_nanosleep
   for an absolute time function. )
: SYS_NANOSLEEP, ( @t1 @t2 -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  35 >LINUX
  RSI POP  RDI POP ;
:( Returns the timer value of type tp in structure @tv, returning 0 for success or the negative
   error code. )
: SYS_GETITIMER, ( @tv tp -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  36 >LINUX
  RDI POP  RSI POP ;
:( Sets the alarm clock to u1 seconds, or cancels a pending alarm clock if u1 is 0, returning the
   number of seconds remaining until a previous alarm was due, or 0 if no previous alarm was set,
   or the negative error code.  ALARM, and SETITIMER, operate on the same timer. )
: SYS_ALARM, ( u1 -- u2|-errno )  RDI PUSH  RAX RDI MOV  37 >LINUX  RDI POP ;
:( Arms or disarms the timer of type tp using structure @tv1, reporting the previous setting in @tv0
   if is is not NIL, and returning 0 for success or the negative error code. )
: SYS_SETITIMER, ( @tv1 @tv0 tp -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  38 >LINUX  RDI POP  RSI POP ;
:( Returns the caller's process id.  The call cannot fail. )
: SYS_GETPID, ( -- pid )  RAX PUSH  39 >LINUX ;
:( Writes u1 bytes from mmappable file descriptor infd to mmappable file descriptor outfd, using and
   updating the file cursor at @u instead of the internal file position in infd if @u is not NIL.
   Returns the number of bytes written to outfd, or the negative error code. )
: SYS_SENDFILE, ( infd outfd @u u1 -- u2|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDI XCHG
  RDX POP  R10 PUSH  RAX R10 MOV  40 >LINUX  R10 POP  RDI POP  RSI POP ;
:( Creates a socket of family fam and type tp using protocol prot and returns file descriptor fd
   to refer to it, or the negative error code. )
: SYS_SOCKET, ( fam tp prot -- fd|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  41 >LINUX  RSI POP  RDI POP ;
:( Connects socket with file descriptor fd to the block with address a and length #, returning
    0 for success or the negative error code. )
: SYS_CONNECT, ( a # fd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  42 >LINUX  RDI POP  RSI POP ;
:( Creates a client socket for a connection request on server socket with file descriptor fd1, fills
   in the client address in structure a with length #, and returns the client socket's file
   descriptor fd2, or the negative error code. )
: SYS_ACCEPT, ( a # fd1 -- fd2|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  43 >LINUX  RDI POP  RSI POP ;
:( Sends # bytes from address a to socket with file descriptor fd [with socket address @s of length
   s#, used only by connection-less sockets and otherwise ignored and expected to be NIL and 0]
   according to flags fl.  Returns the number of bytes u actually transferred, or the negative error
   code. )
: SYS_SENDTO, ( a # @s s# fl fd -- u|-errno )  4 CELLAS [RSP] RSI XCHG  3 CELLAS [RSP] RDX XCHG
  2 CELLAS [RSP] R08 XCHG  CELLA [RSP] R09 XCHG  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  44 >LINUX
  RDI POP  R10 POP  R09 POP  R08 POP  RDX POP  RSI POP ;
:( Reads # bytes from socket with file descriptor fd [with socket address @s of length s#, used only
   by connection-less sockets and otherwise ignored and expected to be NIL and 0] to address a
   according to flags fl.  Returns the number of bytes u actually transferred, or the negative error
   code. )
: SYS_RECVFROM, ( a # @s s# fl fd -- u|-errno )  4 CELLAS [RSP] RSI XCHG  3 CELLAS [RSP] RDX XCHG
  2 CELLAS [RSP] R08 XCHG  CELLA [RSP] R09 XCHG  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  45 >LINUX
  RDI POP  R10 POP  R09 POP  R08 POP  RDX POP  RSI POP ;
:( Sends the message specified in message control block @msg according to flags fl to the socket
   with file descriptor fd, and returns the number of bytes u actually transferred or the negative
   error ocde. )
: SYS_SENDMSG, ( @msg fl fd -- u|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  46 >LINUX  RDI POP  RSI POP ;
:( Reads a message specified in message control block @msg according to flags fl from the socket
   with file descriptor fd, and returns the number of bytes u actually transferred or the negative
   error code. )
: SYS_RECVMSG, ( @msg fl fd -- u|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  47 >LINUX  RDI POP  RSI POP ;
:( Shuts down [part of] a full-duplex connection on socket with file descriptor fd according to type
   tp [0=receiving, 1=sending end, 2=both], and returns 0 for success or the negative error code. )
: SYS_SHUTDOWN, ( tp fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  48 >LINUX
  RDI POP  RSI POP ;
:( Binds the socket with file descriptor fd to socket descriptor a with length #, returning 0 for
   success or the negative error code. )
: SYS_BIND, ( a # fd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  49 >LINUX  RDI POP  RSI POP ;
:( Marks socket with file descriptor fd as passive, listening for incoming connection requests, with
   a maximum backlog of u, and returns 0 for success or the negative error code. )
: SYS_LISTEN, ( fd u -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  50 >LINUX
  RSI POP  RDI POP ;
:( Returns the current address to which the socket with file descriptor fd is bound in the structure
   at address a with size #, returning 0 for success or the negative error code. )
: SYS_GETSOCKNAME, ( a # fd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  51 >LINUX  RDI POP  RSI POP ;
:( Returns the current address to which the peer of socket with file descriptor fd is bound in the
   structure at address a with size #, returning 0 for success or the negative error code. )
: SYS_GETPEERNAME, ( a # fd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  51 >LINUX  RDI POP  RSI POP ;
:( Creates an unnamed socket pair connected in domain dom of type tp using optionally protocol prot,
   return the sockets file descriptor in sock[0] and sock[1] and 0 for success or the negative
   error code. )
: SYS_SOCKETPAIR, ( dom tp prot @sock -- -errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] RSI XCHG
  RDX POP  R10 PUSH  RAX R10 MOV  52 >LINUX  R10 POP  RSI POP  RDI POP ;
:( Sets socket options with "name" nm for socket with file descriptor fd on level lv from the buffer
   at a with length #, returning 0, a netfilter handler specific value x, or the negative error
   code. )
: SYS_SETSOCKOPT, ( a # nm lv fd -- x|0|-errno )  3 CELLAS [RSP] R10 XCHG  2 CELLAS [RSP] R08 XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  54 >LINUX  RDI POP  RSI POP
  RDX POP  R08 POP  R10 POP ;
:( Gets socket options with "name" nm from socket with file descriptor fd on level lv in the buffer
   at a with length #, returning 0, a netfilter handler specific value x, or the negative error
   code. )
: SYS_GETSOCKOPT, ( a # nm lv fd -- x|0|-errno )  3 CELLAS [RSP] R10 XCHG  2 CELLAS [RSP] R08 XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  54 >LINUX  RDI POP  RSI POP
  RDX POP  R08 POP  R10 POP ;
:( Creates a new process, in a way similar to fork, but allows the child to share parts of its
   execution context with the caller according to flags fl.  The child's stack is set to a and its
   thread id will be stored in the parent at @pt, in the child at @ct if the corresponding address
   is not NIL.  Returns the child's thread id or the negative error code. )
: SYS_CLONE, ( a @pt @ct fl -- tid|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  56 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Creates a new process "child" on a copy of the program environment "parent", and returns the
   child's process id pid to the parent, 0 to the child, or does not create a child process and
   returns the negative error code. )
: SYS_FORK, ( -- pid|0|-errno )  RAX PUSH  57 >LINUX ;
:( Creates a new process "child" on the same program environment as the "parent", halting the parent
   process until the child executes execve or terminates, and returns the child's process id pid to
   the parent, 0 to the child, or does not create a child process and returns the negative error
   code. )
: SYS_VFORK, ( -- pid|0|-errno )  RAX PUSH  58 >LINUX ;
:( Executes the program with zero-terminated name fnz, passing arguments @args and environment @env
   to the new program.  Does not return onsuccess , or returns the negative error code on failure. )
: SYS_EXECVE, ( fnz @args @env -- -errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] RSI XCHG
  RAX RDX MOV  59 >LINUX  RSI POP  RDI POP ;
:( Sends signal sig to process [group] pid, returning 0 on success or the negative error code. )
: SYS_KILL, ( pid sig -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  62 >LINUX
  RSI POP  RDI POP ;
:( Returns system information in the structure at a, returning 0 on success, or the negative error
   code. )
: SYS_UNAME, ( a -- -errno )  RDI PUSH  RAX RDI MOV  63 >LINUX  RDI POP ;
:( Returns the semaphore set id associated with key according to flags fl, creating a new semaphore
   set of size #sems under conditions specified in fl.  Returns the semaphore set id or the negative
   error code. )
: SYS_SEMGET, ( key #sems fl -- id|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  64 >LINUX  RSI POP  RDI POP ;
:( Atomically performs the #semops semaphore operations in @semops on semaphore set id, returning
   0 on success or the negative error code. )
: SYS_SEMOP, ( @semops #semops id -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  65 >LINUX  RDI POP  RSI POP ;
:( Performs 3-arg control operation cmd on [semaphore #sem of] semaphore set id an returns a command
   specific result r [positive] or 0 or the negative error code. )
: SYS_SEMCTL3, ( id #sem cmd -- r|0|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  66 >LINUX  RSI POP  RDI POP ;
:( Performs 4-arg control operation cmd on [semaphore #sem of] semaphore set id an returns a command
   specific result r [positive] or 0 or the negative error code. )
: SYS_SEMCTL4, ( x id #sem cmd -- r|0|-errno )  2 CELLAS [RSP] R10 XCHG  SYS_SEMCTL3,  R10 POP ;
:( Detaches shared memory area at a from the address space of the calling process, returning 0 on
   success, or the negative error code. )
: SYS_SHMDT, ( a -- -errno )  RDI PUSH  RAX RDI MOV  67 >LINUX  RDI POP ;
:( Returns the message queue identifier id for key k according to flags fl, returning the message
   queue id or the negative error code. )
: SYS_MSGGET, ( k fl -- id|-errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  68 >LINUX
  RSI POP  RDI POP ;
:( Sends message of length # at address a to message queue id according to control flags fl,
   returning 0 on success or the negative error code. )
: SYS_MSGSND, ( a # fl id -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  69 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Reads a message of type tp from message queue id according to flags fl into buffer of size #
   at address a and returns the number of bytes actually transferred, or the negative error code. )
: SYS_MSGRCV, ( a # tp fl id -- u|-errno )  3 CELLAS [RSP] RSI XCHG  2 CELLAS [RSP] RDX XCHG
  CELLA [RSP] R10 XCHG  0 [RSP] R08 XCHG  RDI PUSH  RAX RDI MOV  70 >LINUX  RDI POP  R08 POP
  R10 POP  RDX POP  RSI POP ;
:( Performs control operation cmd on message queue id using the structure at a, returning a cmd
   specific result r, 0, or the negative error code. )
: SYS_MSGCTL, ( a cmd id -- r|0|-errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  71 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Performs file descriptor control operation cmd on file descriptor fd, some of them using an
   additional argument arg [which can be almost anything depending on cmd and should be NIL/0 when
   not needed], returning a cmd specific positive result r, 0, or the negative error code. )
: SYS_FCNTL, ( arg cmd fd -- r|0|-errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  72 >LINUX  RDI POP  RDX POP  RDI POP ;
:( Applies or removes an advisory lock on file descriptor fd, returning 0 on success, or the
   negative error code. )
: SYS_FLOCK, ( cmd fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  73 >LINUX
  RDI POP  RSI POP ;
:( Flushes dirty in-core data and meta-data of file descriptor fd to the storage device, returning
   0 for success, or the negative error code. )
: SYS_FSYNC, ( fd -- -errno )  RDI PUSH  RAX RDI MOV  74 >LINUX  RDI POP ;
:( Flushes dirty in-core data [but not meta-data] of file descriptor fd to the storage device,
   returning 0 for success, or the negative error code. )
: SYS_FDATASYNC, ( fd -- -errno )  RDI PUSH  RAX RDI MOV  75 >LINUX  RDI POP ;
:( Sets the size of the file with zero-terminated name fnz to length # [filling with zeroes if the
   file was shorter], returning 0 for success, or the negative error code. )
: SYS_TRUNCATE, ( # fnz -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  76 >LINUX
  RDI POP  RSI POP ;
:( Sets the size of the file with file descriptor fd to length # [filling with zeroes if the
   file was shorter], returning 0 for success, or the negative error code. )
: SYS_FTRUNCATE, ( # fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  77 >LINUX
  RDI POP  RSI POP ;
:( Reads multiple dirent structures from directory with open file descriptor fd into the buffer of
   length # at address a, returning the number of bytes actually read, or the negative error code. )
: SYS_GETDENTS, ( a # fd -- u|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  78 >LINUX  RDI POP  RSI POP ;
:( Writes the current working directory into the buffer of size # at address a, or the negative
   error code. )
: SYS_GETCWD, ( a # -- a|-errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  79 >LINUX
  RSI POP  RDI POP ;
:( Changes the current working directory to the directory with zero-terminated name fnz, returning
   0 for success, or the negative error code. )
: SYS_CHDIR, ( fnz -- -errno )  RDI PUSH  RAX RDI MOV  80 >LINUX  RDI POP ;
:( Changes the current working directory to the directory with file descriptor fd, returning
   0 for success, or the negative error code. )
: SYS_FCHDIR, ( fd -- -errno )  RDI PUSH  RAX RDI MOV  81 >LINUX  RDI POP ;
:( Renames the file with zero-terminated path fnz1 to the zero-terminated path fnz2, moving it
   between directories if requested.  Returns 0 on success, or the negative error code. )
: SYS_RENAME, ( fnz1 fnz2 -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  82 >LINUX
  RSI POP  RDI POP ;
:( Creates directory with zero-terminated name fnz according to flags fl, returning 0 on success, or
   the negative error code. )
: SYS_MKDIR, ( fnz fl -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  83 >LINUX
  RSI POP  RDI POP ;
:( Removes directory with zero-terminated name fnz, returning 0 on success, or the negative error
   code. )
: SYS_RMDIR, ( fnz -- -errno )  RDI PUSH  RAX RDI MOV  84 >LINUX  RDI POP ;
:( Creates file with zero-terminated path and file access mode fl, returning the file descriptor fd
   of the new file, or the negative error code. )
: SYS_CREAT, ( fnz fl -- fd|-errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  85 >LINUX
  RSI POP  RDI POP ;
:( Creates the new file with zero-terminated name fnz2 referring to the same file with
   zero-terminated name fnz1, returning 0 on success, or the negative error code. )
: SYS_LINK, ( fnz1 fnz2 -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  86 >LINUX
  RSI POP  RDI POP ;
:( Removes the zero-terminated name fnz from the file system, and the file referring to it as well,
   if it was the last name referring to it. Returns 0 on success, or the negative error code. )
: SYS_UNLINK, ( fnz -- -errno )  RDI PUSH  RAX RDI MOV  87 >LINUX  RDI POP ;
:( Creates the symbolic link with zero-terminated name fnz2 referring to the zero-terminated name
   fnz1, returning 0 on success, or the negative error code. )
: SYS_SYMLINK, ( fnz1 fnz2 -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  88 >LINUX
  RSI POP  RDI POP ;
:( Reads the contents of the symbolic with zero-terminated path fnz into the buffer with size # at
   address a, returning the number of bytes u actually read, or the negative error code. )
: SYS_READLINK, ( a # fnz -- u|-errno ) CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  89 >LINUX  RDI POP  RSI POP ;
:( Changes the mode bits of the file with zero-terminated name fnz to mode, returning 0 for success,
   of the negative error code. )
: SYS_CHMOD, ( mode fnz -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  90 >LINUX
  RDI POP  RSI POP ;
:( Changes the mode bits of the file with file descriptor fd to mode, returning 0 for success,
   of the negative error code. )
: SYS_FCHMOD, ( mode fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  91 >LINUX
  RDI POP  RSI POP ;
:( Changes the ownership of file with zero-terminated name fnz to user uid and group gid, returning
   zero on success, or the negative error code. )
: SYS_CHOWN, ( uid gid fnz -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  92 >LINUX  RDI POP  RSI POP ;
:( Changes the ownership of file with file desciptor fd to user uid and group gid, returning
   zero on success, or the negative error code. )
: SYS_FCHOWN, ( uid gid fd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  93 >LINUX  RDI POP  RSI POP ;
:( Changes the ownership of link with zero-terminated name fnz to user uid and group gid, returning
   zero on success, or the negative error code. )
: SYS_LCHOWN, ( uid gid fnz -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  94 >LINUX  RDI POP  RSI POP ;
:( Changes the file creation mask to msk1, returning the previous value in msk2.  This call cannot
   fail. )
: SYS_UMASK, ( msk1 -- msk2 )  RDI PUSH  RAX RDI MOV  95 >LINUX  RDI POP ;
:( Returns the time of day and the time zone in buffers at @time and @zone respectively, both of
   which can be NIL if the corresponding information is irrelevant.  Returns 0 for success, or the
   negative error code. )
: SYS_GETTIMEOFDAY, ( @time @zone -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  96 >LINUX
  RSI POP  RDI POP ;
:( Sets the soft and hard limit of resource u to the values in structure @rlim, returning 0 for
   success, or the negative error code. )
: SYS_GETRLIMIT, ( @rlim u -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  97 >LINUX
  RDI POP  RSI POP ;
:( Returns current resource usage of who [self, children, thread] in buffer at a, returning 0
   on success, or the negative error code. )
: SYS_GETRUSAGE, ( a who -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  98 >LINUX
  RDI POP  RSI POP ;
:( Returns system information in buffer at a, returning 0 for success, or the negative error code. )
: SYS_GETSYSINFO, ( a -- -errno )  RDI PUSH  RAX RDI MOV  99 >LINUX  RDI POP ;
:( Fills the block at address a with the CPU times info, returning an arbitrary elapsed time or the
   negative error code. )
: SYS_TIMES, ( a -- t|-errno )  RDI PUSH  RAX RDI MOV  100 >LINUX  RDI POP ;
:( Control the execution of a tracee.  On success, returns a result for PEEK request [which also
   may be negative!], 0 for other requests, or the negative error code in case of failure. )
: SYS_PTRACE, ( a # pid req -- r|0|-errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  101 >LINUX  RDI POP  RSI POP  R10 POP  RDX POP ;
:( Returns the real user id uid of the calling process.  Cannot fail. )
: SYS_GETUID, ( -- uid )  RAX PUSH  102 >LINUX ;
:( Queries and controls the kernel log buffer by means of request req, using the buffer with length
   # at address to convey request parameters and return information.  Returns result r for certain
   requests, 0 for others, or the begative error code. )
: SYS_SYSLOG, ( a # req -- r|0|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  103 >LINUX  RDI POP  RSI POP ;
:( Returns the real group id gid of the calling process.  Cannot fail. )
: SYS_GETGID, ( -- gid )  RAX PUSH  104 >LINUX ;
:( Sets the real and/or effective user id of the caller to uid, returning 0 on success, or the
   negative error code. )
: SYS_SETUID, ( uid -- -errno )  RDI PUSH  RAX RDI MOV  105 >LINUX  RDI POP ;
:( Sets the real and/or effective group id of the caller to gid, returning 0 on success, or the
   negative error code. )
: SYS_SETGID, ( gid -- -errno )  RDI PUSH  RAX RDI MOV  106 >LINUX  RDI POP ;
:( Returns the effective user id uid of the calling process.  Cannot fail. )
: SYS_GETEUID, ( -- uid )  RAX PUSH  107 >LINUX ;
:( Returns the effective group id uid of the calling process.  Cannot fail. )
: SYS_GETEGID, ( -- gid )  RAX PUSH  108 >LINUX ;
:( Sets the group id of process pid to pgid, returning 0 for success, or the negative error ocde. )
: SYS_SETPGID, ( pgid pid -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  109 >LINUX
  RDI POP  RSI POP ;
:( Returns process ID ppid of the caller's parent process.  Cannot fail. )
: SYS_GETPPID, ( -- ppid )  RAX PUSH  110 >LINUX ;
:( Returns progress group id pgrp of the calling process.  Cannot fail. )
: SYS_GETPGRP, ( -- pgrp )  RAX PUSH  111 >LINUX ;
:( Creates a new session with the calling process acting as process group leader, returning session
   id sid of the new session, or the negative error code.  Cannot fail. )
: SYS_SETSID, ( -- sid )  RAX PUSH  112 >LINUX ;
:( Sets the real and/or effective user id of the calling process to ruid or euid respectively.
   Either or both uids can be set to -1, in which case the corresponding user id is not touched.
   Returns 0 on success, or the negative error code. )
: SYS_SETREUID, ( ruid euid -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  113 >LINUX
  RSI POP  RDI POP ;
:( Sets the real and/or effective group id of the calling process to rgid or egid respectively.
   Either or both gids can be set to -1, in which case the corresponding group id is not touched.
   Returns 0 on success, or the negative error code. )
: SYS_SETREGID, ( rgid egid -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  114 >LINUX
  RSI POP  RDI POP ;
:( Returns the list of supplementary group ids in list @gid[] with length #gid, failing if there are
   more gids than would fit in the list, unless list size is 0, in which case no error occurs.
   Returns the number of supplementary groups, or the negative error code. )
: SYS_GETGROUPS, ( @gid[] #gids -- u|-errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  115 >LINUX
  RDI POP  RSI POP ;
:( Sets the list of the caller's supplementary group ids to list @gid[] with length @gids.  Returns
   0 on success, or the negative error code. )
: SYS_SETGROUPS, ( @gid[] #gids -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  116 >LINUX
  RDI POP  RSI POP ;
:( Sets the real and/or effective and/or saved user id of the calling process to ruid, euid and suid
   respectively. Any of the uids can be set to -1, in which case the corresponding user id is not
   touched.  Returns 0 on success, or the negative error code. )
: SYS_SETRESUID, ( ruid euid suid -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  117 >LINUX  RSI POP  RDI POP ;
:( Returns the real, effective, and saved user id of the calling process in the variables as @ruid,
   @euid and @suid respectively.  Returns 0 on success, or the negative error code. )
: SYS_GETRESUID, ( @ruid @euid @suid -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG
  RAX RDX MOV  118 >LINUX  RSI POP  RDI POP ;
:( Sets the real and/or effective and/or saved group id of the calling process to rgid, egid and
   sgid respectively. Any of the gids can be set to -1, in which case the corresponding group id is
   not touched.  Returns 0 on success, or the negative error code. )
: SYS_SETRESGID, ( rgid egid sgid -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  119 >LINUX  RSI POP  RDI POP ;
:( Returns the real, effective, and saved group id of the calling process in the variables as @rgid,
   @egid and @sgid respectively.  Returns 0 on success, or the negative error code. )
: SYS_GETRESGID, ( @rgid @egid @sgid -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG
  RAX RDX MOV  120 >LINUX  RSI POP  RDI POP ;
:( Returns process group id pg for the process with process id pid [or the caller, if pid is 0],
   or the negative error code. )
: SYS_GETPGID, ( pid -- pg|-errno )  RDI PUSH  RAX RDI MOV  121 >LINUX  RDI POP ;
:( Returns the session id of process pid [or the calling process if pid is 0], or the negative error
   code. )
: SYS_GETSID, ( pid|0 -- sid|-errno )  RDI PUSH  RAX RDI MOV  124 >LINUX  RDI POP ;
:( Fills thread capabilities into structures @hdr and @data, returning 0 for success, or the
   negative error code. )
: SYS_CAPGET, ( @hdr @data -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  125 >LINUX
  RSI POP  RDI POP ;
:( Sets the thread capabilities according to structures @hdr and @data, returning 0 for success, or
   the negative error code. )
: SYS_CAPSET, ( @hdr @data -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  126 >LINUX
  RSI POP  RDI POP ;
:( Reports the set of pending signals in @sigs, returning 0 for success, or the negative error
   code. )
: SYS_SIGPENDING, ( @sigs -- -errno )  EDI PUSH  RAX RDI MOV  127 >LINUX  RDI POP ;
:( Waits according to the time specification in @tm for a signal from signal set @ss with length
   ss# to be risen, setting @si to the signal specification when that happens.  Returns signal
   number sig on success, or the negative error code. )
: SYS_SIGTIMEDWAIT, ( @tm @si @ss ss# -- sig|-errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] RSI XCHG
  0 [RSP] RDI XCHG  R10 PUSH  RAX R10 MOV  128 >LINUX  R10 POP  RDI POP  RSI POP  RDX POP ;
:( Queues signal sig with additional info in @si to be delivered to thread group tgid, returning 0
   on success, or the negative error code. )
: SYS_RT_SIGQUEUEINFO, ( @si sig tgid -- -errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  129 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Suspends the calling process until a signal in the signal set @ss with size ss# occurs.  Always
   fails, either with EINTR or EFAULT, returning the negative error code. )
: SYS_SIGSUSPEND, ( @ss ss# -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  130 >LINUX
  RSI POP  RDI POP ;
:( Defines and/or queries the alternate signal stack.  @ss is the address of a stack descriptor, or
   NIL if no alternate stack is to be set, @oss is the address of a stack descriptor to which the
   last alternate stack parameters are written, or NIL if no info is requested.  Returns 0 on
   success, or the negative error code. )
: SYS_SIGALTSTACK, ( @ss @oss -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  131 >LINUX
  RSI POP  RDI POP ;
:( Sets the last access and last modification dates of the file with zero-terminated name fnz to the
   values in the utime structure at @ut, return 0 on success, or the negative error code. )
: SYS_UTIME, ( @ut fnz -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  132 >LINUX
  RDI POP  RSI POP ;
:( Creates a filesystem node with the zero-terminated name fnz, file mode md and the device major /
   minor code dev [if the node to create is a char or block device, otherwise dev is ignored], and
   returns 0 on success, or the negative error code. )
: SYS_MKNOD, ( fnz md dev -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  133 >LINUX  RSI POP  RDI POP ;
:( Loads shared library with zero-terminated name fnz, return 0 on success, or the negative error
   code. )
: SYS_USELIB, ( fnz -- -errno )  RDI PUSH  RAX RDI MOV  134 >LINUX  RDI POP ;
:( Sets and gets the execution domain for each process to p1 [use -1 to not change the persoality].
   Returns the previous personality, or the negative error code. )
: SYS_PERSONALITY ( p1 -- p2|-errno )  RDI PUSH  RAX RDI MOV  135 >LINUX  RDI POP ;
:( OBSOLETE, use STATFS, instead.  Writes the file system statistics of mounted device dev into
   buffer at a.  Returns 0 on success, or the negative error code. )
: SYS_USTAT ( a #dev -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  136 >LINUX
  RDI POP  RSI POP ;
:( Reports the file system statistics of a mounted file system containing the file with
   zero-terminated name fnz in the buffer at a, returning 0 on success or the negative error code. )
: SYS_STATFS, ( a fnz -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  137 >LINUX
  RDI POP  RSI POP ;
:( Reports the file system statistics of a mounted file system containing the open file with file
   descriptor fd in the buffer at a, returning 0 on success, or the negative error code. )
: SYS_FSTATFS, ( a fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  138 >LINUX
  RDI POP  RSI POP ;
:( Reports various file system information according to option o [1, 2, or 3], see "man 2 sysfs".
   Returns info u dpending on option, or the negative error code. )
: SYS_SYSFS, ( x1 x2 o -- u|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  139 >LINUX  RDI POP  RSI POP ;
:( Returns the scheduling priority of tp [process, pgroup, user] with number id [pid, pgid, uid],
   using the current process, process group or real user if id is 0.  Returns the scheduling
   priority in the range 40..1, to be translated into nice value -20..19 for the requested entity,
   or the negative error code. )
: SYS_GETPRIORITY, ( tp id -- p|-errno )  0 [RSP] RSI XCHG  RSI PUSH  RAX RSI MOV  140 >LINUX
  RSI POP  RDI POP ;
:( Sets the scheduling priority of tp [process, pgroup, user] with number id [pid, pgid, uid] to p,
   using the current process, process group or real user if id is 0.  Node that scheduling priority
   is in the range 40..1, to be translated from nice value -20..19.  Returns 0 on success,
   or the negative error code. )
: SYS_SETPRIORITY, ( tp id p -- -errno )  CELLA [RSP] RSI XCHG  0 [RSP] RDI XCHG  RAX RDX MOV
  141 >LINUX  RDI POP  RSI POP ;
:( Sets the scheduling parameters of process pid [0: SYS_calling process] to the values in the
   structure at a, returning 0 for success, or the negative error code. )
: SYS_SCHED_SETPARAM, ( a pid -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  142 >LINUX
  RDI POP  RSI POP ;
:( Reports the scheduling parameters of process pid [0: SYS_calling process] in the structure at a,
   returning 0 for success, or the negative error code. )
: SYS_SCHED_GETPARAM, ( a pid -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  143 >LINUX
  RDI POP  RSI POP ;
:( Sets the scheduling policy pol with parameters in buffer a of process pid [0: SYS_calling
   process], returning 0 on success, or the negative error code. )
: SYS_SCHED_SETSCHEDULER ( a pol pid -- -errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  144 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Returns scheduling policy pol of process pid [0: SYS_calling process], or the negative error
   code. )
: SYS_SCHED_GETSCHEDULER ( pid -- pol|-errno )  RDI PUSH  RAX RDI MOV  145 >LINUX  RDI POP ;
:( Returns the maximum priority for scheduling policy pol, or the negative error code. )
: SYS_SCHED_GET_PRIORITY_MAX ( pol -- p|-errno )  RDI PUSH  RAX RDI MOV  146 >LINUX  RDI POP ;
:( Returns the minimum priority for scheduling policy pol, or the negative error code. )
: SYS_SCHED_GET_PRIORITY_MIN ( pol -- p|-errno )  RDI PUSH  RAX RDI MOV  147 >LINUX  RDI POP ;
:( Reports the round-robin time quantum for process pid [which should be running under the round
   robin scheduling policy], returning 0 on success, or the negative error code. )
: SYS_SCHED_RR_GET_INTERVAL ( @t pid -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV
  148 >LINUX  RDI POP  RSI POP ;
:( Locks # bytes of the calling process's virtual address range starting at a from being swapped,
   returning 0 on success, or the negative error code.  Locking is page-wise; all pages containing
   the specified address range will be locked. )
: SYS_MLOCK ( a # -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  149 >LINUX  RSI POP
  RDI POP ;
:( Unlocks # bytes of the calling process's virtual address range starting at a from being swapped,
   returning 0 on success, or the negative error code.  Unlocking is page-wise; all pages containing
   the specified address range will be unlocked. )
: SYS_MUNLOCK ( a # -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  150 >LINUX  RSI POP
  RDI POP ;
:( Locks the entire virtual address space of the calling process according to the specified flags,
   returning 0 on success, or the negative error code. )
: SYS_MLOCKALL ( fl -- -errno )  RDI PUSH  RAX RDI MOV  151 >LINUX  RDI POP ;
:( Unlocks the entire virtual address space of the calling process, returning 0 on success, or the
   negative error code. )
: SYS_MUNLOCKALL ( -- -errno )  RAX PUSH  152 >LINUX ;
:( Virtually hangs up the current terminal, returning 0 for success, or the negative error code. )
: SYS_VHANGUP ( -- -errno )  RAX PUSH  153 >LINUX ;
:( Sets or gets the local descriptor table from or in the descriptor of length # at address a,
   according to the command [0: SYS_read, 1: SYS_write], returning the number of bytes read for cmd
   0, 0 for cmd 1, or the negative error code. )
: SYS_MODIFY_LDT ( a # cmd -- u|0|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  154 >LINUX  RDI POP  RSI POP ;
:( Saves the old file system root of the calling process in @or and sets the new file system root
   to @nr; both pointers reference zero-terminated strings.  Returns 0 on success, or the negative
   error code. )
: SYS_PIVOT_ROOT, ( @or @nr -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  155 >LINUX
  RDI POP  RSI POP ;
:( Performs a process control operation cmd on the calling thread, using arguments x0, x1 and x2
   according to the cmd to get or set cmd arguments.  Returns a value for certain cmds, 0 for
   others, or the negative error code. )
: SYS_PRCTL, ( x3 x2 x1 x0 cmd -- r|0|-errno )  3 CELLAS [RSP] R08 XCHG  2 CELLAS [RSP] R10 XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  157 >LINUX  RDI POP  RSI POP
  RDX POP  R10 POP  R08 POP ;
:( Adjusts and reports timex algorithm parameter from and to the timex structure at address a,
   returning the clock state, or the negative error code. )
: SYS_ADJTIMEX ( a -- cs|-errno )  RDI PUSH  RAX RDI MOV  159 >LINUX  RDI POP ;
:( Returns the soft and hard limit of resource u from the values in structure @rlim, returning 0 for
   success, or the negative error code. )
: SYS_SETRLIMIT, ( @rlim u -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  160 >LINUX
  RDI POP  RSI POP ;
:( Changes the root directory of the calling process to zero-terminated path fnz, return 0 on
   success, or the negative error code. )
: SYS_CHROOT, ( fnz -- -errno )  RDI PUSH  RAX RDI MOV  161 >LINUX  RDI POP ;
:( Flushes all pending modifications and metadata to the underlying filesystem.  Cannot fail. )
: SYS_SYNC, ( -- )  RAX PUSH  162 >LINUX  RAX POP ;
:( Turns accounting on, logging records for each terminating process to the file with
   zero-terminated name fnz, or turns accounting off if fnz is NIL.  Returns 0 for success, or the
   negative error code. )
: SYS_ACCT, ( fnz|0 -- -errno )  RDI PUSH  RAX RDI MOV  163 >LINUX  RDI POP ;
:( Sets the time of day and the time zone from buffers at @time and @zone respectively, both of
   which can be NIL if the corresponding information is not to be set [@zone SHOULD actually be NIL,
   see NOTES in man 2 settimeofday].  Returns 0 for success, or the negative error code. )
: SYS_SETTIMEOFDAY, ( @time @zone -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  164 >LINUX
  RSI POP  RDI POP ;
:( Mounts the filesystem with zero-terminated type fstz in device with zero-terminated name devz
   on directory with zero-terminated name dirz, performing mount operations as specified in fl,
   using the file-system specific data at address @data, returning 0 on success, or the negative
   error code. )
: SYS_MOUNT, ( devz dirz fstz fl @data -- -errno )  3 CELLAS [RSP] RDI XCHG  2 CELLAS [RSP] RSI XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  R08 PUSH  RAX R08 MOV  165 >LINUX  R08 POP  R10 POP
  RDX POP  RSI POP  RDI POP ;
:( Unmounts the topmost file system mounted to target with zero-terminated name tgtz in the way
   indicated by flags fl, returning 0 on success, or the negative error code. )
: SYS_UMOUNT2, ( tgtz fl -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  166 >LINUX
  RSI POP  RDI POP ;
:( Sets the swap area to special file or block device with zero-terminated name sfnz with the
   priority specified in fl, returning 0 on success, or the negative error code. )
: SYS_SWAPON, ( sfnz fl -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  167 >LINUX
  RSI POP  RDI POP ;
:( Stops swapping to special file or block device with zero-terminated name sfnz, returning 0 on
   success, or the negative error code. )
: SYS_SWAPOFF, ( sfnz -- -errno )  RDI PUSH  RAX RDI MOV  168 >LINUX  RDI POP ;
:( Reboots the system, or enables/disables the reboot keystroke, returning 0 on success [if
   returning at all], or the negative error code. )
: SYS_REBOOT, ( cmd -- -errno )  RDI PUSH  RSI PUSH  R10 PUSH  $fee1dead # RDI MOV
  $28121969 # RSI MOV  R10 R10 XOR  RAX RDX MOV  169 >LINUX  R10 POP  RSI POP  RDI POP ;
:( Reboots the system using the zero-terminated command string cmdz, not returning unless on error,
   in which case the negative error code is returned. )
: SYS_REBOOTA, ( cmdz cmd -- -errno )  0 [RSP] R10 XCHG  RDI PUSH  RSI PUSH  $fee1dead # RDI MOV
  $28121969 # RSI MOV  RAX RDX MOV  169 >LINUX  RSI POP  RDI POP  R10 POP ;
:( Sets the host name to the string with length # at address a, returning 0 on success, or the
   negative error code. )
: SYS_SETHOSTNAME, ( a # -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  170 >LINUX
  RSI POP  RDI POP ;
:( Sets the NIS domain name to the string with length # at address a, returning 0 on success, or the
   negative error code. )
: SYS_SETDOMAINNAME, ( a # -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  171 >LINUX
  RSI POP  RDI POP ;
:( Changes the I/O privilege level of the calling process to lvl, returning 0 on success, or the
   negative error code. )
: SYS_IOPL, ( lvl -- -errno )  RDI PUSH  RAX RDI MOV  172 >LINUX  RDI POP ;
:( Changes raw I/O permissions for len ports starting with off to ? [0: SYS_off, non-0: SYS_on],
   returning 0 on success, or the negative error code. )
: SYS_IOPERM, ( off len ? )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV  173 >LINUX
  RSI POP  RDI POP ;
:( Loads Linux ELF kernel module image with length # at address a, initializing it with the
   zero-terminated parameter string prmz.  Returns 0 on success, orthe negative error code. )
: SYS_INIT_MODULE, ( a # prmz -- -errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  175 >LINUX  RSI POP  RDI POP ;
:( Removes Linux ELF kernel module with the zero-terminated name mnz according to flagsfl, returning
   0 on success, or the negative error code. )
: SYS_DELETE_MODULE, ( mnz fl -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  176 >LINUX
  RSI POP  RDI POP ;
:( Requests information from the kernel about loaded modules, reporting to buffer with size # at
   address a for module with zero-terminated name mnz [NIL for the kernel proper for some commands],
   using command cmd and reporting numbers in cell at @#.  Returns 0 on success, or the negaive
   error code. )
: SYS_QUERY_MODULE, ( mnz a # @# cmd -- -errno )  3 CELLAS [RSP] RDI XCHG  2 CELLAS [RSP] RDX XCHG
  CELLA [RSP] R10 XCHG  0 [RSP] R08 XCHG  RSI PUSH  RAX RSI MOV  178 >LINUX  RSI POP  R08 POP
  R10 POP  RDX POP  RDI POP ;
:( Manipulates disk quotas for mounted block device with zero-terminated name qdvz using command cmd
   for entity [user, group or project] id, using buffer at address a to pass in and out data for
   some of the command.  Returns 0 on success, or the negative error code. )
: SYS_QUOTACTL, ( a qdvz id cmd -- -errno )  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RSI XCHG  RDX POP
  RDI PUSH  RAX RDI MOV  179 >LINUX  RDI POP  RSI POP  R10 POP ;
:( Returns the thread id of the calling process.  Cannot fail. )
: SYS_GETTID, ( -- tid )  RAX PUSH  186 >LINUX ;
:( Initiates reading ahead len bytes at offset off from file descriptor fd in the background,
   returning 0 on success, or the negative error code.  off and len should be multiples of the page
   size, as readahead reads only whole pages. )
: SYS_READAHEAD, ( off len fd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  187 >LINUX  RDI POP  RSI POP ;
:( Sets extended attribute with zero-terminated name nmz for zero-terminated path fnz to the value
   with length val# at address @val, using flags fl to modify the default behavior.  Returns 0 on
   success, or the negative error code. )
: SYS_SETXATTR, ( fnz nmz @val val# fl -- -errno )  3 CELLAS [RSP] RDI XCHG  2 CELLAS [RSP] RSI XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  R08 PUSH  RAX R08 MOV  188 >LINUX  R08 POP  R10 POP
  RDX POP  RSI POP  RSI POP ;
:( Sets extended attribute with zero-terminated name nmz for zero-terminated link path fnz to the
  value with length val# at address @val, using flags fl to modify the default behavior.  Returns
   0 on success, or the negative error code. )
: SYS_LSETXATTR, ( fnz nmz @val val# fl -- -errno )  3 CELLAS [RSP] RDI XCHG
  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  R08 PUSH  RAX R08 MOV  189 >LINUX
  R08 POP  R10 POP  RDX POP  RSI POP  RSI POP ;
:( Sets extended attribute with zero-terminated name nmz file descriptor fd to the value
   with length val# at address @val, using flags fl to modify the default behavior.  Returns 0 on
   success, or the negative error code. )
: SYS_FSETXATTR, ( fd nmz @val val# fl -- -errno )  3 CELLAS [RSP] RDI XCHG  2 CELLAS [RSP] RSI XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  R08 PUSH  RAX R08 MOV  190 >LINUX  R08 POP  R10 POP
  RDX POP  RSI POP  RSI POP ;
:( Gets extended attribute with zero-terminated name nmz for zero-terminated path fnz in the buffer
   with size val# at address @val.  Returns the length of the reply, or the negative error code. )
: SYS_GETXATTR, ( fnz nmz @val val# -- # -errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] RSI XCHG
  RDX POP  R10 PUSH  RAX R10 MOV  191 >LINUX  R10 POP  RSI POP  RSI POP ;
:( Gets extended attribute with zero-terminated name nmz for zero-terminated link path fnz in the
   buffer with size val# at address @val.  Returns the length of the reply, or the negative error
   code. )
: SYS_LGETXATTR, ( fnz nmz @val val# -- # -errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] RSI XCHG
  RDX POP  R10 PUSH  RAX R10 MOV  192 >LINUX  R10 POP  RSI POP  RSI POP ;
:( Gets extended attribute with zero-terminated name nmz for file descriptor fd in the buffer
   with size val# at address @val.  Returns the length of the reply, or the negative error code. )
: SYS_FGETXATTR, ( fd nmz @val val# -- # -errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] RSI XCHG
  RDX POP  R10 PUSH  RAX R10 MOV  193 >LINUX  R10 POP  RSI POP  RSI POP ;
:( Retrieves the list of extended attributes for the file with zero-terminated name fnz as a
   contiguous series of zero-terminated names in buffer with size # at address a, returning the
   length of the attribute list, or the negative error code. )
: SYS_LISTXATTR, ( fnz a # -- u|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  194 >LINUX  RSI POP  RDI POP ;
:( Retrieves the list of extended attributes for the link with zero-terminated name fnz as a
   contiguous series of zero-terminated names in buffer with size # at address a, returning the
   length of the attribute list, or the negative error code. )
: SYS_LLISTXATTR, ( fnz a # -- u|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  195 >LINUX  RSI POP  RDI POP ;
:( Retrieves the list of extended attributes for file descriptor fd as a contiguous series of
   zero-terminated names in buffer with size # at address a, returning the length of the attribute
   list, or the negative error code. )
: SYS_FLISTXATTR, ( fd a # -- u|-errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  196 >LINUX  RSI POP  RDI POP ;
:( Removes extended attributes with zero-terminated name nmz from file with zero-terminated name
   fnz, returning 0 on success, or the negative error code. )
: SYS_REMOVEXATTR, ( fnz nmz -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  197 >LINUX
  RSI POP  RDI POP ;
:( Removes extended attributes with zero-terminated name nmz from link with zero-terminated name
   fnz, returning 0 on success, or the negative error code. )
: SYS_LREMOVEXATTR, ( fnz nmz -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  198 >LINUX
  RSI POP  RDI POP ;
:( Removes extended attributes with zero-terminated name nmz from file descriptor fd, returning 0 on
   success, or the negative error code. )
: SYS_FREMOVEXATTR, ( fd nmz -- -errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  199 >LINUX
  RSI POP  RDI POP ;
:( Returns the time in seconds since the Epoch.  Cannot fail. )
: SYS_TIME, ( -- u )  RDI PUSH  RDI RDI XOR  201 >LINUX  RDI POP ;
:( Performs futex blocking operation op with argument v to wait for a certain condition on the futex
   at @fx1, possibly with a timeout specified in @t or a second value v2, a second futex @fx2 and
   an additional value v3, returning a reply for some ops, 0 for others, or the negative error
   code. )
: SYS_FUTEX, ( @fx1 v op @t|v2 @fx2 v3 -- r|0|-errno )  4 CELLAS [RSP] RDI XCHG
  3 CELLAS [RSP] RDX XCHG  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] R10 XCHG  0 [RSP] R08 XCHG  R09 PUSH
  RAX R09 XCHG  202 >LINUX  R09 POP  R08 POP  R10 POP  RSI POP  RDX POP  RDI POP ;
:( Sets the CPU affinity of thread pid [0: SYS_calling thread] through the CPU set of length # at
   address a, returning 0 on success, or the negative error code. )
: SYS_SCHED_SETAFFINITY, ( a # pid -- -errno )  RDX POP  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV
  203 >LINUX  RDI POP  RSI POP ;
:( Reports the CPU affinity of thread pid [0: SYS_calling thread] in the CPU set buffer of length #
   at address a, returning 0 on success, or the negative error code. )
: SYS_SCHED_GETAFFINITY, ( a # pid -- -errno )  RDX POP  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV
  204 >LINUX  RDI POP  RSI POP ;
:( Sets a thread-local storage according to the descriptor in @udesc, returning 0 on success, or the
   negative error code. )
: SYS_SET_THREAD_AREA, ( @udesc -- -errno )  RDI PUSH  RAX RDI MOV  205 >LINUX  RDI POP ;
:( Creates an asynchronous I/O context for # operations returned in @aioc, which must be initialized
   to 0 before the call.  Returns 0 on success, or the negative errr code. )
: SYS_IO_SETUP, ( @aioc u -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  206 >LINUX
  RDI POP  RSI POP ;
:( Destroys asynchronous I/O context @aioc, after canceling all outstanding AIOps and blocking on
   completion of all uncancelable operations.  Returns 0 on success, or the negative error code. )
: SYS_IO_DESTROY, ( @aioc -- -errno )  RDI PUSH  RAX RDI MOV  207 >LINUX  RDI POP ;
:( Reads at least #1, but up to #2, events from asynchronous I/O context @aioc into the event buffer
   at @evt with at least #2 entries, returning the actual number of events read, or the negative
   error code. )
: SYS_IO_GETEVENTS, ( @evt[] @t #1 #2 @aioc -- #3|-errno )  3 CELLAS [RSP] R10 XCHG
  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] R08 XCHG  RDX POP  RDI PUSH  RAX RDI MOV  208 >LINUX  RDI POP
  R08 POP  RSI POP  R10 POP ;
:( Submits #1 events from the I/O control block array at @iocbpp to asynchronous I/O context @aioc,
   returning the number of events actually submitted, or the negative error code. )
: SYS_IO_SUBMIT, ( @iocbpp[] #1 @aioc -- #2|-errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  209 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Cancels event described in I/O control block @iocb in asynchronous I/O context @aoic, returning
   the cancelled event in @evt and 0 on success, or the negative error code. )
: SYS_IO_CANCEL, ( @evt @iocb @aioc -- -errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  210 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Reads the GDT thread local storage parameters of the entry designated in descriptor @udesc, and
   fills out the rest of the descriptor, returning 0 on success, or the negative error code. )
: SYS_GET_THREAD_AREA, ( @udesc -- -errno )  RDI PUSH  RAX RDI MOV  211 >LINUX  RDI POP ;
:( Creates an asynchronous I/O context for # operations returned in @aioc, which must be initialized
   to 0 before the call.  Returns 0 on success, or the negative errr code. )
:( Reports the full path of the directory entry specified by cook in buffer with length #1 at
   address a, returning length #2 of the path string, or the negative error code. )
: SYS_LOOKUP_DCOOKIE, ( a #1 cookie -- #2|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  212 >LINUX  RDI POP  RSI POP ;
:( Creates an epoll instance of at least size # [in newer kernels, this parameter is ignored, but
   must be > 0], returning a file descriptor, or the negative error code. )
: SYS_EPOLL_CREATE, ( # -- fd|-errno )  RDI PUSH  RAX RDI MOV  213 >LINUX  RDI POP ;
:( Reads several linux directory entries from directory fd into the buffer of size #1 at address
   @ident[], return length #2 of buffer used, or the negative error code. )
: SYS_GET_DENTS, ( @dent[] #1 fd -- #2|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  217 >LINUX  RDI POP  RSI POP ;
:( Sets the CLEAR_CHILD_TID for the calling thread, returning this thread's tid.  Cannot fail. )
: SYS_SET_TID_ADDRESS, ( a -- tid )  RDI PUSH  RAX RDI MOV  218 >LINUX  RDI POP ;
:( Performs the semaphora operations specified in array @nsops with #nsops entries on semaphore
   group semid within timeout @t, returning 0 on success, or the negative error code. )
: SYS_SEMTIMEDOP, ( @nsops #nsops @t semid -- -errno )  2 CELLAS [RSP] RSI XCHG
  CELLA [RSP] R10 XCHG  RDX POP  RDI PUSH  RAX RDI MOV  220 >LINUX  RDI POP  R10 POP  RSI POP ;
:( Announces the intention to access file data of length len at position off in file descriptor fd
   in the way declared as adv, returning 0 on success, or the negative error code. )
: SYS_FADVISE64, ( off len adv fd -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  221 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Creates a per-process timer of type clockid that produces event @evt when expired, reporting the
   timer specification in @timer and returning 0 on success, or the negative error code. )
: SYS_TIMER_CREATE, ( @timer @evt clockid -- -errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG
  RDI PUSH  RAX RDI MOV  222 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Arms timer tmr with the new interval @intv1 according to flags fl, while reporting the previous
   interval in @intv2 [unless it's NIL], return 0 on success, or the negative error code. )
: SYS_TIMER_SETTIME, ( @intv1 @intv2|0 tmr fl -- -errno )  2 CELLAS [RSP] RDX XCHG
  CELLA [RSP] R10 XCHG  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  223 >LINUX  RSI POP  RDI POP
  R10 POP  RDX POP ;
:( Reports current timer value of timer tmr in @intv, returning 0 on success, or the negative error
   code. )
: SYS_TIMER_GETTIME, ( @intv tmr -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  224 >LINUX
  RDI POP  RSI POP ;
:( Returns overrun count u of timer tmr, or the negative error code. )
: SYS_TIMER_GETOVERRUN, ( tmr -- u|-errno )  RDI PUSH  RAX RDI MOV  225 >LINUX  RDI POP ;
:( Deletes timer tmr; the timer is disarmed before being deleted.  Returns 0 on success, or the
   negative error code. )
: SYS_TIMER_DELETE, ( tmr -- -errno )  RDI PUSH  RAX RDI MOV  226 >LINUX  RDI POP ;
:( Sets the time of clock clk to @t, returning 0 on success, or the negative error code. )
: SYS_CLOCK_SETTIME, ( @t clk -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  227 >LINUX
  RDI POP  RSI POP ;
:( Reports the time of clock clk in @t, returning 0 on success, or the negative error code. )
: SYS_CLOCK_GETTIME, ( @t clk -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  228 >LINUX
  RDI POP  RSI POP ;
:( Reports the resolution of clock clk in @t, returning 0 on success, or the negative error code. )
: SYS_CLOCK_GETRES, ( @t clk -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  229 >LINUX
  RDI POP  RSI POP ;
:( Performs a high-precision sleep in nanoseconds for the time specified in @t interpreted as a
   relative time if fl is 0, or an absolute time if fl is 1] using clock clk, returning 0 on success
   or the negative error code. )
: SYS_CLOCK_NANOSLEEP, ( @tr @t fl clk -- -errno )  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  230 >LINUX  RDI POP  RSI POP  RDX POP  R10 POP ;
:( Exits FORCE and returns to the system, taking down all other threads of the process to which the
   calling thread belongs.  Does not return. )
: SYS_EXIT_GROUP, ( u -- )  RAX RDI MOV  231 >LINUX ;
:( Waits for at most evt# events on epoll file descriptor epfd within timeout tm [-1 for "forever";
   0 for "no wait", return what's there], to be reported in array @evt of size evt#.  Returns
   the number of events available in @evt[], or the negative error code. )
: SYS_EPOLL_WAIT, ( @evt[] evt# tm|-1|0 epfd -- u|-errno )  2 CELLAS [RSP] RSI XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  232 >LINUX  RDI POP  R10 POP
  RDX POP  RSI POP ;
:( Performs control operation op on target file descriptor fd on behalf of epoll file descriptor
   epfd associated with the event descriptor at @evt.  Returns 0 on success, or the negative error
   code. )
: SYS_EPOLL_CTL, ( @evt fd op epfd -- -errno )  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  233 >LINUX  RDI POP  RSI POP  RDX POP  R10 POP ;
:( Sends signal sig to target thread tid in thread group tgid, returning 0 on success, or the
   negative error code. )
: SYS_TGKILL, ( tgid tid sig -- --errno )  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV
  234 >LINUX  RSI POP  RDI POP ;
:( Sets the last accessed @tv[0] and last modified @tv[1] time of file with zero-terminated name fnz
   in millisecond precision, returning 0 on success, or the negative error code. )
: SYS_UTIMES, ( @tv[] fnz -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  235 >LINUX
  RDI POP  RSI POP ;
:( Sets the NUMA policy for memory range with length # at address a to mode md with flags fl,
   applied to the node mask at @nmsk consisting of #nmsk bits, returning 0 on success, or the
   negatve error code. )
: SYS_MBIND, ( @nmsk #nmsk fl md a # -- -errno )  4 CELLAS [RSP] R10 XCHG  3 CELLAS [RSP] R08 XCHG
  2 CELLAS [RSP] R09 XCHG  CELLA [RSP] RDX XCHG  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  237 >LINUX
  RSI POP  RDI POP  RDX POP  R09 POP  R08 POP  R10 POP ;
:( Sets the calling thread's default NUMA policy to md for #nmsk nodes in @nmsk, each one bit,
   return 0 on success, or the negatve error code. )
: SYS_SET_MEMPOLICY, ( @nmsk #nmsk md -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  238 >LINUX  RDI POP  RSI POP ;
:( Reports the calling thread's NUMA policy regarding flag fl possibly referring to address a in
   the node mask at @nmsk of size #nmsk and the mode in @mode, returning 0 on success, or the
   negative error code. )
: SYS_GET_MEMPOLICY, ( @nmsk #nmsk a fl @mode -- -errno )  3 CELLAS [RSP] RSI XCHG
  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG  0 [RSP] R08 XCHG  RDI PUSH  RAX RDI MOV  239 >LINUX
  RDI POP  R08 POP  R10 POP  RDX POP  RSI POP ;
:( Creates and/or opens POSIX message queue with zero-terminated name mnz with attributes @attr and
   permissions md for access mode fl, returning message queue descriptor mqd on success, or the
   negative error code. )
: SYS_MQ_OPEN, ( mnz @attr fl md -- mqd|-errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] R10 XCHG
  0 [RSP] RSI XCHG  RAX RDX MOV  240 >LINUX  RSI POP  R10 POP  RDI POP ;
:( Destroys POSIX message queue with zero-terminated name mnz, returning 0 on success, or the
   negatove error code. )
: SYS_MQ_UNLINK, ( mnz -- -errno )  RDI PUSH  RAX RDI MOV  241 >LINUX  RDI POP ;
:( Sends message @msg with length msg# with priority u to POSIX message queue mqd, waiting until
   absolute time @tm for a free slot, unless the queue is open in non-blocking mode.  Returns 0 on
   success, or the negatove error code. )
: SYS_MQ_TIMEDSEND, ( @tm @msg msg# u mqd -- -errno )  3 CELLAS [RSP] R08 XCHG
  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  242 >LINUX
  RDI POP  R10 POP  RDX POP  RSI POP  R08 POP ;
:( Removes the oldest message with the highest priority from POSIX message queue mgd and puts the
   message in buffer @msg with size msg# and the message priority in @u unless it is NIL, waiting
   until absolute time @tm on an empty queue for a message to arrive, unless the queue is open in
   non-blocking mode.  Returns the length of the message in @msg, or the negative error code. )
: SYS_MQ_TIMEDRECEIVE ( @tm @msg msg# @u|0 mqd -- #|-errno )  3 CELLAS [RSP] R08 XCHG
  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  243 >LINUX
  RDI POP  R10 POP  RDX POP  RSI POP  R08 POP ;
:( Registers or unregisters the calling process for asynchronous message delivery with POSIX message
   queue mqd using @sev to detail the event delivery mode.  Returns 0 on success, or the negative
   error code. )
: SYS_MQ_NOTIFY ( @sev|0 mqd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  244 >LINUX
  RDI POP  RSI POP ;
:( Sets attributes in @at1 in POSIX message queue mqd, and gets the previous set of attributes in
   @at0.  Returns 0 on success, or the negative error code. )
: SYS_MQ_GETSETATTR, ( @at1 @at0 mqd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  245 >LINUX  RDI POP  RSI POP ;
:( Loads the reboot- or crash-kernel according to flags fl, using #segs segments at address @segs as
   the kernel segments and @entry as its entry point.  Returns 0 on success, or the negative error
   code. )
: SYS_KEXEC_LOAD, ( @segs #segs @entry fl -- -errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] RSI XCHG
  0 [RSP] RDI XCHG  R10 PUSH  RAX R10 MOV  246 >LINUX  R10 POP  RDI POP  RSI POP  RDX POP ;
:( Waits for a state change in a child of type tp [with id pid] of the calling process controlled by
   options opt, and obtains info about the change in @sig and its resource usage in @rus, returning
   0 for success, or the negative error code. )
: SYS_WAITID, ( @rus @sig opt pid tp -- -errno )  3 CELLAS [RSP] R08 XCHG  2 CELLAS [RSP] RDX XCHG
  CELLA [RSP] R10 XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  247 >LINUX  RDI POP  RSI POP
  R10 POP  RDX POP  R08 POP ;
:( Creates or updates a kernel key of type @tp with #pl bytes of payload at @pl and attaches it to
   key ring kr, returnsing the key's serial number sn, or the negative error code. )
: SYS_ADD_KEY, ( @tp @desc @pl #pl kr -- sn|-errno )  3 CELLAS [RSP] RDI XCHG
  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG  0 [RSP] R10 XCHG  R08 PUSH  RAX R08 MOV  248 >LINUX
  R08 POP  R10 POP  RDX POP  RSI POP  RDI POP ;
:( Looks up key of type @tp with description @desc and attaches it to kernel key ring kr, looking
   further according to callout @co if the key is not found internally.  Returns the serial number
   of the key, or the negative error code. )
: SYS_REQUEST_KEY, ( @tp @desc @co kr -- sn|-errno )  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] RSI XCHG
  RDX POP  R10 PUSH  RAX R10 MOV  249 >LINUX  R10 POP  RSI POP  RDI POP ;
:( Performs key control operation opt using the specified arguments, returning the key's serial
   number sn, or the negative error code. )
: SYS_KEYCTL, ( arg2 arg3 arg4 arg5 opt -- sn|-errno )  3 CELLAS [RSP] R08 XCHG
  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  250 >LINUX
  RDI POP  RSI POP  RDX POP  R10 POP  R08 POP ;
:( Sets the I/O priority of process/process-group/user id [according to tp] to pr, returning 0
   on success, or the negative error code. )
: SYS_IOPRIO_SET, ( pr id tp -- -errno )  CELLA [RSP] RDX XCHG  0 [RSP] RSI XCHG  RDI PUSH
  RAX RDI MOV  251 >LINUX  RDI POP  RSI POP  RDX POP ;
:( Returns I/O priority pr of process/process-group/user id [according to tp], or the negative error
   code. )
: SYS_IOPRIO_GET, ( id tp -- pr|-errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  252 >LINUX
  RDI POP  RSI POP ;
:( Initializes a new inotify instance and returns its file descriptor fd, or the negative error
   code. )
: SYS_INOTIFY_INIT, ( -- fd|-errno )  RAX PUSH  253 >LINUX ;
:( Adds the file with zero-terminated name fnz to inotify instance fd for events specified in mask
   msk, returning watch descriptor wd, or the negative error code. )
: SYS_INOTIFY_ADD_WATCH, ( fnz msk fd -- wd|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  254 >LINUX  RDI POP  RSI POP ;
:( Removes watch descriptor wd from inotify instance fd, returning 0 on success, or the negative
   error code. )
: SYS_INOTIFY_RM_WATCH, ( wd fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  255 >LINUX
  RDI POP  RSI POP ;
:( Migrates #pgs pages of process pid in @old nodes to @new nodes, returning number u of
   unmigrated pages, or the negative error code. )
: SYS_MIGRATE_PAGES, ( @old @new #pgs pid -- u|-errno )  2 CELLAS [RSP] RDX XCHG
  CELLA [RSP] R10 XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  256 >LINUX  RDI POP  RSI POP
  R10 POP  RDX POP ;
:( Like OPEN, but uses dfd rather than CWD as the base for relative paths.  Returns the new file
   descriptor fd, or the negative error code. )
: SYS_OPENAT, ( fnz fl md dfd -- fd|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  257 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Like MKDIR, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code. )
: SYS_MKDIRAT, ( fnz md dfd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  258 >LINUX  RDI POP  RSI POP ;
:( Like MKNOD, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code. )
: SYS_MKNODAT, ( fnz md dev dfd -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  259 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Like CHOWNAT, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code.  fl gives additional semantics for dfd and pathname, should be 0. )
: SYS_FCHOWNAT, ( fl uid gid fnz dfd -- -errno )  3 CELLAS [RSP] R08 XCHG  2 CELLAS [RSP] RDX XCHG
  CELLA [RSP] R10 XCHG  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  260 >LINUX  RDI POP  RSI POP
  R10 POP  RDX POP  R08 POP ;
:( Like STAT, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code. )
: SYS_NEWFSTATAT, ( a fnz fl dfd -- -errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] RSI XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  262 >LINUX  RDI POP  R10 POP  RSI POP  RDX POP ;
:( Like UNLINK, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code. )
: SYS_UNLINKAT, ( fnz fl dfd -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  263 >LINUX  RDI POP  RSI POP ;
:( Like RENAME, but uses dfd1 and df2 thather than CWD as the base for relative path fnz1 and fnz2,
   respectively.  Returns 0 on success, or the negative error code. )
: SYS_RENAMEAT, ( fnz1 fnz2 dfd1 dfd2 -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] R10 XCHG
  0 [RSP] RDI XCHG  RAX RDX MOV  264 >LINUX  RDI POP  R10 POP  RSI POP ;
:( Like LINK, but uses dfd1 and df2 thather than CWD as the base for relative path fnz1 and fnz2,
   respectively.  Returns 0 on success, or the negative error code. )
: SYS_LINKAT, ( fnz1 fnz2 fl dfd1 dfd2 -- -errno )  3 CELLAS [RSP] RSI XCHG  2 CELLAS [RSP] R10 XCHG
  CELLA [RSP] R08 XCHG  0 [RSP] RDI XCHG  RAX RDX MOV  265 >LINUX  RDI POP  R08 POP  R10 POP
  RSI POP ;
:( Like SYMLINK, but uses dfd rather than CWD as the base for relative path fnz2.  Returns 0 on
   success, or the negative error code. )
: SYS_SYMLINKAT, ( fnz1 fnz2 dfd -- -errno )  CELLA [RSP] RDI XCHG  RDX POP  RSI PUSH  RAX RSI MOV
  266 >LINUX RSI POP  RDI POP ;
:( Like READLINK, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on
   success, or the negative error code. )
: SYS_READLINKAT, ( a # fnz dfd -- -errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  267 >LINUX  RDI POP  RSI POP  R10 POP  RDX POP ;
:( Like CHMOD, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code.  fl gives additional semantics for dfd and pathname, should be 0. )
: SYS_FCHMODAT, ( fl md fnz dfd -- -errno )  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  268 >LINUX  RDI POP  RSI POP  RDX POP  R10 POP ;
:( Like ACCESS, but uses dfd rather than CWD as the base for relative paths.  Returns 0 on success,
   or the negative error code.  fl gives additional semantics for dfd and pathname, should be 0. )
: SYS_FACCESSAT, ( fl fnz mode dfd -- -errno )  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RSI XCHG
  RDX POP  RDI PUSH  RAX RDI MOV  269 >LINUX  RDI POP  RSI POP  R10 POP ;
:( Like SELECT, but allows to temporarily use signal mask @sgm, which is set and then reset around
   the SELECT call atomically to prevent race conditions.  Returns the total number u of ready file
   descriptors in all 3 sets, or the negative error code. )
: SYS_PSELECT6, ( @sgm @in @out @exc @to fds -- u|-errno )  4 CELLAS [RSP] R09 XCHG
  3 CELLAS [RSP] RSI XCHG  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG  0 [RSP] R08 XCHG  RDI PUSH
  RAX RDI MOV  270 >LINUX  RDI POP  R08 POP  R10 POP  RDX POP  RSI POP  R09 POP ;
:( Almost like POLL, but allows to temporarily use signal mask @sgm with size in bytes sst#, which
   is set and the reset atomically around the POLL call to prevent race conditions.  Returns number
   # of structures with events, the negative error code, or 0 if the request timed out without any
   events. )
: SYS_PPOLL, ( sst# @sgm @p[] p# @to -- #|-errno )  3 CELLAS [RSP] R08 XCHG  2 CELLAS [RSP] R10 XCHG
  CELLA [RSP] RDI XCHG  0 [RSP] RSI XCHG  RAX RDX MOV  271 >LINUX  RSI POP  RDI POP
  R10 POP  R08 POP ;
:( Dissociate parts of shared memory structures in the execution context according to the flags in
   fl.  Returns 0 on success, or the negative error code. )
: SYS_UNSHARE, ( fl -- -errno )  RDI PUSH  RAX RDI MOV  272 >LINUX  RDI POP ;
:( Sets the head and length of robuts futexes of the calling thread to lst and lst# respectively,
   returning 0 on success, or the negative error code. )
: SYS_SET_ROBUST_LIST, ( lst lst# -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH  RAX RDI MOV
  273 >LINUX  RDI POP  RSI POP ;
:( Reports the head of the list of robust futexes of thread pid in @lst and its length in @lst#,
   returning 0 on success, or the negative error code. )
: SYS_GET_ROBUST_LIST, ( @lst @lst# pid -- -errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  274 >LINUX  RDI POP  RSI POP ;
:( Moves #1 bytes from offset @oli of fdi to offset @olo of fdo controlled by flags fl, returning
   number of bytes #2 actually moved, or the negatve error code. )
: SYS_SPLICE, ( #1 @oli fdi @olo fdo fl -- #2|-errno )  4 CELLAS [RSP] R08 XCHG
  3 CELLAS [RSP] RSI XCHG  2 CELLAS [RSP] RDI XCHG  CELLA [RSP] R10 XCHG  RDX POP  R09 PUSH
  RAX R09 MOV  275 >LINUX  R09 POP  R10 POP  RDI POP  RSI POP  R08 POP ;
:( Duplicates / branches off #1 bytes from pipe with file descriptor fdi to file descriptor fdo
   controlled by flags fl, returning the number of bytes actually duplicated, or the negative error
   code. )
: SYS_TEE, ( #1 fdi fdo fl -- #2|-errno )  2 CELLAS [RSP] RDX MOV  CELLA [RSP] RDI XCHG
  0 [RSP] RSI XCHG  R10 PUSH  RAX R10 MOV  276 >LINUX  R10 POP  RSI POP  RDI POP  RDX POP ;
:( Synchronizes # bytes at offset o in file with file descriptor fd with the underlying storage
   device controlled by flags fl, returning 0 on success, or the negative error code. )
: SYS_SYNC_FILE_RANGE, ( o # fl fd -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  277 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Maps @pgs virtual memory pages described by @iov to the pipe with file descriptor fd controlled
   by flags fl, returning number of bytes # written to the pipe, or the negatove error code. )
: SYS_VMSPLICE, ( @iov #pgs fl fd -- #|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  278 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Moves #pgs pages whose addresses are given in @pages[] of process pid [0 = calling process] to
   the nodes specified in nodes[] according to flags fl, and reports their status in stat[],
   returning 0 on success, or the negative error code. )
: SYS_MOVE_PAGES, ( @page[] nodes[] stat[] #pgs fl pid -- -errno )  4 CELLAS [RSP] RDX XCHG
  3 CELLAS [RSP] R10 XCHG  2 CELLAS [RSP] R08 XCHG  CELLA [RSP] RSI XCHG  0 [RSP] R09 XCHG  RDI PUSH
  RAX RDI MOV  279 >LINUX  RDI POP  R09 POP  RSI POP  R08 POP  R10 POP  RDX POP ;
:( Sets the last-accessed and last-modified times of the file with zero-terminated name fnz to t[0]
   and t[1] respectively according to flags fl, using the directory with file handle dfd as the
   base directory for relative paths.  Returns 0 on success, or the negative error code. )
: SYS_UTIMENSAT, ( fnz t[2] fl dfd -- -errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  280 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Waits for at most evt# events of the type specified signal mask in @sgm of size sigs# bytes on
   epoll file descriptor epfd within timeout tm [-1 for "forever"; 0 for "no wait", return what's
   there], to be reported in array @evt of size evt#.  Returns the number of events available in
   @evt[], or the negative error code. )
: SYS_EPOLL_PWAIT, ( @sgm sigs# @to @evt[] evt# epfd -- u|-errno )  4 CELLAS [RSP] R08 XCHG
  3 CELLAS [RSP] R09 XCHG  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  281 >LINUX  RDI POP  RSI POP  R10 POP  R09 POP  R08 POP ;
:( Creates [fd=-1] or updates an existing a signal file descriptor for the signals specified in
   @sgm with size in bytes @sigs directed to the caller, returning the new of same file descriptor,
   or the negative error code. )
: SYS_SIGNALFD, ( @sgm sigs# fd|-1 -- fd|-errno )  CELLA [RSP] RSI XCHG  RDX POP  RDI PUSH
  RAX RDI MOV  282 >LINUX  RDI POP  RSI POP ;
:( Creates a file descriptor based timer based on clock clk based on flags fl, returning a new
   file descriptor on success, or the negative error code. )
: SYS_TIMERFD_CREATE, ( clk fl -- fd|-errno )  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  283 >LINUX
  RSI POP  RDI POP ;
:( Creates an event file descriptor with the initial value of its count set to cnt, returning the
   new file descriptor, or the negative error code. )
: SYS_EVENTFD, ( cnt -- fd|-errno )  RDI PUSH  RAX RDI MOV  284 >LINUX  RDI POP ;
:( Manipulates the range of length len starting at offset off with file with descriptor fd according
   to the specified mode md, return 0 on success, or the negative error code. )
: SYS_FALLOCATE, ( off len md fd -- -errno )  2 CELLAS [RSP] RDX XCHG  CELLA [RSP] R10 XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  285 >LINUX  RDI POP  RSI POP  R10 POP  RDX POP ;
:( Arms or disarms the file descriptor based timer fd to value @new according to flags fl, and
   reports the previous timer value in @old unless it's NIL, returning 0 for success, or the
   negative error code. )
: SYS_TIMERFD_SETTIME ( @old|0 @new fl fd -- -errno )  2 CELLAS [RSP] R10 XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  286 >LINUX  RDI POP  RSI POP  RDX POP  R10 POP ;
:( Reports the current timer value on file descriptor based time fd in @cur, returning 0 on success,
   or the negative error code. )
: SYS_TIMERFD_GETTIME ( @cur fd -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  287 >LINUX
  RDI POP  RSI POP ;
:( Creates a client socket for a connection request on server socket with file descriptor fd1, fills
   in the client address in structure a with length #, sets the socket flags in fl, and returns the
   client socket's file descriptor fd2, or the negative error code. )
: SYS_ACCEPT4, ( a # fl fd1 -- fd2|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  288 >LINUX  RDI POP  r10 POP  RDX POP  RSI POP ;
:( Creates [fd=-1] or updates an existing a signal file descriptor with the specified flags set for
   the signals specified in @sgm with size in bytes @sigs directed to the caller, returning the new
   of same file descriptor, or the negative error code. )
: SYS_SIGNALFD4, ( @sgm sigs# fl fd|-1 -- fd|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] R10 XCHG  RDI PUSH  RAX RDI MOV  289 >LINUX  RDI POP  R10 POP  RDX POP  RSI POP ;
:( Creates an event file descriptor with the flags fl and the initial value of its count set to cnt,
   returning the new file descriptor, or the negative error code. )
: SYS_EVENTFD2, ( fl cnt -- fd|-errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  290 >LINUX
  RDI POP  RSI POP ;
:( Creates an epoll instance with the specified flags, returning a file descriptor, or the negative
   error code. )
: SYS_EPOLL_CREATE1, ( fl -- fd|-errno )  RDI PUSH  RAX RDI MOV  291 >LINUX  RDI POP ;
:( Same as DUP2, with the possibility to set flags in fd, in particular O_CLOEXEC. )
: SYS_DUP3, ( fl fd1 fd2 -- fd2|-errno )  CELLA [RSP] RDX XCHG  0 [RSP] RDI XCHG  RSI PUSH
  RAX RSI MOV  292 >LINUX  RSI POP  RDI POP ;
:( Creates a pipe fitted flags fl and writes the file descriptors for the reading end at @fds[0] and
   for the writing end at @fds[1], .  Returns 0 for success, or the negative error code. )
: SYS_PIPE2, ( @fds fl -- -errno )  0 [RSP] RSI XCHG  RDI PUSH  RAX RDI MOV  293 >LINUX
  RDI POP  RSI POP ;
:( Initializes a new inotify instance and returns its file descriptor fd, fitted with flags fl, or
   the negative error code. )
: SYS_INOTIFY_INIT, ( fl -- fd|-errno )  RDI PUSH  RAX RDI MOV  294 >LINUX  RDI POP ;
:( Reads data from file with descriptor fd off position u into multiple buffers specified at
   structure @vec with # elements, and returns the total number of bytes read, or the negative error
   code. )
: SYS_PREADV, ( @vec # u fd -- u|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RCX MOV  R10 PUSH  R08 PUSH  ECX R10 MOVSXD  RCX R08 MOV  32 # R08 SHR  RDI PUSH
  RAX RDI MOV  295 >LINUX  RDI POP  R08 POP  R10 POP  RDX POP  RSI POP ;
:( Writes data from multiple buffers specified at structure @vec with # elements to file with
   descriptor fd off position u , and returns the total number of bytes read, or the negative error
   code. )
: SYS_PWRITEV, ( @vec # u fd -- u|-errno )  2 CELLAS [RSP] RSI XCHG  CELLA [RSP] RDX XCHG
  0 [RSP] RCX MOV  R10 PUSH  R08 PUSH  ECX R10 MOVSXD  RCX R08 MOV  32 # R08 SHR  RDI PUSH
  RAX RDI MOV  296 >LINUX  RDI POP  R08 POP  R10 POP  RDX POP  RSI POP ;
:( Queues signal sig with additional info in @si to be delivered to thread tid in thread group tgid,
   returning 0 on success, or the negative error code. )
: SYS_RT_TGSIGQUEUEINFO, ( @si sig tgid tid -- -errno )  2 CELLAS [RSP] R10 XCHG
  CELLA [RSP] RDX XCHG  0 [RSP] RDI XCHG  RSI PUSH  RAX RSI MOV  297 >LINUX  RSI POP  RDI POP
  RDX POP  R10 POP ;

previous
