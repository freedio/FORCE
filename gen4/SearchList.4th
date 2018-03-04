vocabulary SearchList
  requires" FORTH.voc"
  requires" IO.voc"
  requires" Memory.voc"

variable _@SEARCHLIST             ( Address of the search list )
128 constant SEARCHLIST#          ( Capacity of the search list: should be more than ever needed! )
variable SEARCHLIST%              ( Length of the search list )

=== Search List Structure ===

( Simply one cell )

( Returns address @s[] of the search list. )
: searchList@ ( -- @s[] )
  _@SEARCHLIST @ ?dupunless-  cell SEARCHLIST# u* PAGE# 16− u≥??if
    16+ >| PAGE# u/ allocPages  else  drop allocate  then  dup _@SEARCHLIST !  then ;

=== Search List API ===

( Pushes vocabulary #v on top of the search list. )
: disclose ( #v -- )  searchList@ dup dup cell+ SEARCHLIST% @ move  !  SEARCHLIST% 1+! ;
( Removes vocabulary #v from the search list. )
: conceal ( #v -- )  searchList@ SEARCHLIST% @ rot find ?dupif
  SEARCHLIST% @ over -  searchList@ rot + dup cell-  flip cmove  then ;
( Returns address a and number of entries # of the search list. )
: @searchlist# ( -- a # )  searchList@ SEARCHLIST% @ ;

vocabulary;
