vocabulary AsmTestBase
  requires" FORTH.voc"

variable TH                       ( Target heap pointer )

( Sets the target heap pointer to a. )
: there! ( a -- )  TH ! ;
( Returns the target heap pointer. )
: there ( -- a )  TH @ ;
( Returns the distance from a1 to a2. )
: delta ( a1 a2 -- u )  − ;
( Punches a byte to the target heap. )
: tc, ( c -- )  TH tuck @ c! 1+! ;
( Punches a word to the target heap. )
: tw, ( w -- )  TH tuck @ w! 2+! ;
( Punches a double-word to the target heap. )
: td, ( d -- )  TH tuck @ d! 4+! ;
( Punches a quad-word to the target heap. )
: tq, ( q -- )  TH tuck @ q! 8+! ;
( Punches a ten-byte to the target heap.  Bytes 1 to 8 form the quad-word in tb, bytes 9 and 10 are
  the LSB of tb'. )
: tt, ( tb' tb -- )  tq,  tw, ;
( Punches an oct-word to the target heap.  The LS part is in to, the MS part in to'. )
: to, ( to' to -- )  tq,  tq, ;
( Makes sure that at least u bytes remain on the current heap; if not, extends the heap in a way to
  grant this condition. )
: assertSpace ( u -- )  drop ;

vocabulary;
