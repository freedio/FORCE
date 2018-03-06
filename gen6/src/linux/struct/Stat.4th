/**
  * Linux Stat structure.
  */

package /linux/struct

import /force/structure/Fundamental

Fundamental structure Stat

Device variable Device            ( describes the device on which this file resides. )
Inode variable Inode              ( file's inode number. )
Mode variable Mode                ( file type and mode. )
NLink variable NLink              ( number of hard links to the file. )
UID variable UID                  ( user ID of the owner of the file. )
GID variable GID                  ( ID of the group owner of the file. )
Device variable ReprDevice        ( device that this file (inode) represents. )
Filesize variable Size            ( size of the file in bytes.¹ )
BlockSize variable BlockSize      ( "preferred" block size for efficient filesystem I/O. )
BlockCount variable Blocks        ( number of blocks allocated to the file, in 512-byte units.² )
TimeSpec variable LastAccessed    ( last access timestamp. )
TimeSpec variable LastModified    ( last modification timestamp. )
TimeSpec variable LastStatChange  ( last status change timestamp. )

/**
  * Footnotes:
  *  ¹) the size of the file (if it is a regular file or a symbolic link) in bytes.  The size of a
        symbolic link is the length of the pathname it contains, without a terminating null byte.
  *  ²) This may be smaller than Size/512 when the file has holes.
  */

structure;
export Stat
