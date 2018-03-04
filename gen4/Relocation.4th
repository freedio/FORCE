vocabulary Relocation
  requires" FORTH.voc"
  requires" IO.voc"
  requires" Heap.voc"
  requires" Referent.voc"

=== Relocation Entry Structure ===

0000  dup constant RELOC.SOURCE   ( The location where the relocation is to apply )
cell+ dup constant RELOC.TARGET   ( The location the source is referring to )
cell+ constant RELOC#

( The relocation flags are embedded in the REFA.#DEP amd REF.#SYM fields of RELOC-SOURCE, because
  these fields are not actually used and would always be 0. )

( Flags in REFA.#DEP of RELOC.SOURCE = relocation size )
$0000 constant RELOC-0              ( Unsized relocation )
$0008 constant RELOC-64             ( 64-bit relocation )
$0004 constant RELOC-32             ( 32-bit relocation )
$0002 constant RELOC-16             ( 16-bit relocation )
$0001 constant RELOC-8              ( 8-bit relocation )

( Flags in REFA.#SYM of RELOC.SOURCE = relocation type )
$0000 constant RELOC-ABSOLUTE       ( Absolute relocation )
$0001 constant RELOC-RELATIVE       ( Code relative relocation )

( Returns source referent &s of the relocation entry. )
: relocationSource@ ( rel -- &s )  RELOC.SOURCE + @ referentNoSymDep ;
( Returns target referent &t of the relocation entry. )
: relocationTarget@ ( rel -- &t )  RELOC.TARGET + @ ;

=== Relocation Methods ===

--- "Constructor" ---

( Creates a relocation entry of size s and type t with source referent &s and target referent &t on
  heap #h. )
: relocate ( &t &s s t #h -- )  selectedHeap >r  selectHeap
  rot -1=?if  "Error: null-pointer source referent in relocation!"!  then
  dup referentOffset@ swap referentSegment@ 2swap swap createReferent  ,  ,  r> selectHeap ;
( Creates an absolute relocation entry of size s with source reference &s and target referent &t on
  heap #h. )
: absrelocate ( &t &s s #h -- )  RELOC-ABSOLUTE swap relocate ;

vocabulary;
