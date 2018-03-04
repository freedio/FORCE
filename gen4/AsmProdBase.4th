vocabulary AsmProdBase
  requires" FORTH.voc"
  requires" Heap.voc"
  requires" Referent.voc"
  requires" Vocabulary.voc"

( Sets the target heap pointer to a. )
: there! ( a -- )  drop ;
( Returns the target heap pointer. )
: there ( -- a )  currentCode% ;
( Returns the distance from 'there' to a. )
: delta ( a -- u )  &Δ ;
( Punches a byte to the target heap. )
: tc, ( c -- )  c, ;
( Punches a word to the target heap. )
: tw, ( w -- )  w, ;
( Punches a double-word to the target heap. )
: td, ( d -- )  d, ;
( Punches a quad-word to the target heap. )
: tq, ( q -- )  q, ;
( Punches a ten-byte to the target heap.  Bytes 1 to 8 form the quad-word in tb, bytes 9 and 10 are
  the LSB of tb'. )
: tt, ( tb' tb -- )  t, ;
( Punches an oct-word to the target heap.  The LS part is in to, the MS part in to'. )
: to, ( to' to -- )  o, ;
( Makes sure that at least u bytes remain on the current heap; if not, extends the heap in a way to
  grant this condition. )
: assertSpace ( u -- )  assertHeapSpace ;

vocabulary;
