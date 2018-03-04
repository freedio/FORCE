vocabulary CompSearchList
  requires" FORTH.voc"
  requires" IO.voc"
  requires" Memory.voc"

variable _@COMPSEARCHLIST         ( Address of the compiler search list )
128 constant COMPSEARCHLIST#      ( Capacity of the compiler search list )
variable COMPSEARCHLIST%          ( Length of the compilersearch list )

=== Search List Structure ===

( Simply one cell )

( Returns address @s[] of the compiler search list. )
: vocList@ ( -- @s[] )
  _@COMPSEARCHLIST @ ?dupunless-  cell COMPSEARCHLIST# u* PAGE# 16− u≥??if
    16+ >| PAGE# u/ allocPages  else  drop allocate  then  dup _@COMPSEARCHLIST !  then ;

=== Search List API ===

( Pushes vocabulary #v on top of the search list. )
: search+ ( #v -- )  vocList@ dup dup cell+ COMPSEARCHLIST% @ move  !  COMPSEARCHLIST% 1+! ;
( Removes vocabulary #v from the search list. )
: search- ( #v -- )  vocList@ COMPSEARCHLIST% @ rot find ?dupif
  COMPSEARCHLIST% @ over -  vocList@ rot + dup cell-  flip cmove  then ;
( Returns address a and number of entries # of the search list. )
: @voclist# ( -- a # )  vocList@ COMPSEARCHLIST% @ ;

vocabulary;
