vocabulary Relocation
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Referent.voc"
  requires" Heap.voc"
  requires" Vocabulary.voc"

=== Structure ===

--- Relocation Entry Structure ---

0000  dup constant REL.SOURCE     ( Source referent )
cell+ dup constant REL.TARGET     ( Target referent )
cell+ constant RELOCATION#        ( Size of a relocation entry )

--- Types ---

00 constant REL.ABS64             ( Absolute 64-bit relocation )
01 constant REL.ABS32             ( Absolute 32-bit relocation )
02 constant REL.ABS16             ( Absolute 16-bit relocation )
09 constant REL.REL32             ( Relative 32-bit relocation.  Source referent points at addr. )
10 constant REL.REL16             ( Relative 16-bit relocation.  Source referent points at addr. )

( Creates a relocation entry with target &t, source &s, and type tp, returning a referent to
  relocation entry &rel. )
: createRelocation ( &t &s tp -- &rel )  42.s REFERENT.EXTRA u<< or >relt &here -rot , , segment> ;
( Applies absolute 64-bit relocation @rel. )
: applyRelAbs64 ( @rel -- )  dup REL.TARGET + @ &@ swap REL.SOURCE + @ stripReferent &@ q! ;
( Applies absolute 32-bit relocation @rel. )
: applyRelAbs32 ( @rel -- )  dup REL.TARGET + @ &@ swap REL.SOURCE + @ stripReferent &@ d! ;
( Applies absolute 16-bit relocation @rel. )
: applyRelAbs16 ( @rel -- )  dup REL.TARGET + @ &@ swap REL.SOURCE + @ stripReferent &@ w! ;
( Applies relative 32-bit relocation @rel. )
: applyRelRel32 ( @rel -- )
  dup REL.TARGET + @ &@ swap REL.SOURCE + @ &@ stripReferent tuck 4+ − swap d! ;
( Applies relative 16-bit relocation @rel. )
: applyRelRel16 ( @rel -- )
  dup REL.TARGET + @ &@ swap REL.SOURCE + @ &@ stripReferent tuck 4+ − swap w! ;
( Applies the relocation referred to by &rel. )
: applyRelocation ( @rel -- )  dup REL.SOURCE + @ referentExtra
  0=?if  drop applyRelAbs64  else
  1=?if  drop applyRelAbs32  else
  2=?if  drop applyRelAbs16  else
  9=?if  drop applyRelRel32  else
  10=?if  drop applyRelRel16  else
  1 "Unknown relocation type: %d"|abort  then  then  then  then  then ;
: applyRelocation& ( &rel -- )  &@ applyRelocation ;
( Creates a relocation entry from source referent &s and target referent &t with type tp, and
  applies the relocation entry. )
: reloc, ( &t &s tp -- )  createRelocation applyRelocation& ;

( Applies all relocations in vocabulary #v. )
: applyRelocations ( #v -- )  #vocabulary@ §RELT @#segment@# RELOCATION# u/ 0 do
  dup applyRelocation  RELOCATION# + loop  drop ;

( For all entries of the relocation table with a target referent of &2, replace the target referent
  with &1 and re-apply the relocation. )
: updateRelocations ( &1 &2 -- )  §RELT #segment@# RELOCATION# u/ 0 do
  dup REL.TARGET + @  2pick = if  2pick over REL.TARGET + !  dup applyRelocation  then
  RELOCATION# + loop  3drop ;
( Fulfills deferred word with symbol name s$ with implementation &w. )
: fulfill ( &w s$ -- )  findSymbol unless  1 "Symbol «%s» not found!"|! abort  then
  2dup SYM.VALUE + xchg drop nip  updateRelocations ;

vocabulary;
