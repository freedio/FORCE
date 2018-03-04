/**
  * Implementation of a heap.
  */

import Object

Object class Heap

 cell variable Address            ( Base address of the heap )
dword variable Length             ( Number of bytes used on the heap )
dword variable Size               ( Total capacity of the heap in bytes )

public section --- API

( Allots # bytes at the current heap cursor. )
: allot ( # -- )  Length d+! ;

vocabulary;
export Heap
