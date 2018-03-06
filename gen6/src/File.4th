( Copyright )

/**
  * Captures and combines everything about operating system files.
  *
  * Every file is associated with a numeric file descriptor, an index into the processes array of
  * files.  Indices 0 to 3 are preallocated and reserved for stdin, stdout, stderr and stdlog, so
  * the first free-to-allocate file descriptor is usually 4.
  */

import Object

Object class File

protected dword variable Descriptor ( Unix file descriptor )

class;
export File
