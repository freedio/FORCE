/**
  * A referent is a symbolic target address inside a vocabulary, consisting of the following parts:
  *   • dependency index: defines the vocabulary part (0 = self reference → current dictionary)
  *   • segment index: the segment within the vocabulary
  *   • offset: the offset within the segment
  *   • symbol index: the symbol associated with the referent.
  * A referent with the value -1 is a NULL-pointer, referring to nothing.
  */

vocabulary Referent
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"

=== Referent Structure ===

0000  dup constant REFA.OFFSET    ( LSB position of offset )
 32 + dup constant REFA.#SGM      ( LSB position of segment index )
  4 + dup constant REFA.#DEP      ( LSB position of dependency index )
 12 + dup constant REFA.#SYM      ( LSB position of symbol index )
 16 + constant REFERENT#          ( Total size of referent, must not exceed cell size )

( Returns number of bits off% in the offset )
: referentOffset% ( -- off% )  REFA.#SGM REFA.OFFSET − ;
( Returns number of bits seg% in the segment index )
: referentSegment% ( -- seg% )  REFA.#DEP REFA.#SGM − ;
( Returns number of bits dep% in the dependency index )
: referentDependency% ( -- seg% )  REFA.#SYM REFA.#DEP − ;
( Returns number of bits sym% in the symbol index )
: referentSymbol% ( -- sym% )  REFERENT# REFA.#SYM − ;

( Returns bit mask %off of the offset part. )
: %referentOffset ( -- %off )  referentOffset% bits ;
( Returns bit mask %seg of the segment index part. )
: %referentSegment ( -- %off )  referentSegment% bits ;
( Returns bit mask %dep of the dependency index part. )
: %referentDependency ( -- %dep )  referentDependency% bits ;
( Returns bit mask %sym of the symbol index part. )
: %referentSymbol ( -- %sym )  referentSymbol% bits ;
( Returns bit mask %offseg of the combined offset and segment parts. )
: %referentOffSeg ( -- %offseg )  REFA.#DEP bits ;
( Returns bit mask %offsegdep of the referent withut the symbol part. )
: %referentNoSymbol ( -- %offsegdep )  REFA.#SYM bits ;

--- Validation ---

( Asserts that dependency index #d is in range. )
: !refa.#dep ( #d -- #d )  dup REFA.#SYM REFA.#DEP − bits andn if
  1 "Error: Dependency index %d out of range!"|! abort  then ;
( Asserts that symbol index #s is in range. )
: !refa.#sym ( #s -- #s )  dup REFERENT# REFA.#SYM − bits andn if
  1 "Error: Symbol index %d out of range!"|! abort  then ;
( Asserts that segment index §s is in range. )
: !refa.#sgm ( #§ -- #§ )  dup REFA.#DEP REFA.#SGM − bits andn if
  1 "Error: Segment index %d out of range!"|! abort  then ;
( Asserts that offset u is in range. )
: !refa.offset ( u -- u )  dup REFA.#SGM REFA.OFFSET − bits andn if
  1 "Error: Offset %d out of range!"|! abort  then ;

=== Instant Management ===

--- Constructor ---

( Creates referent ref referring to offset off in segment #§ of dependency #d with symbol #s. )
: createReferent ( off #§ #s #d -- ref )
  !refa.#dep REFA.#DEP u<<  swap
  !refa.#sym REFA.#SYM u<< or  swap
  !refa.#sgm REFA.#SGM u<< or  swap
  !refa.offset REFA.OFFSET u<< or ;
( Creates a null-pointer referent. )
: createNullReferent ( -- ref )  -1 ;

=== API ===

( Extracts offset u from referent ref. )
: referentOffset@ ( ref -- u )  -1=?if  drop 0  else  REFA.OFFSET u>> %referentOffset and  then ;
( replaces the offset part of referent ref with offset off. )
: referentOffset! ( ref off -- ref )  %referentOffset and swap -1 %referentOffset xor and or ;
( Extracts segment index #§ from referent ref. )
: referentSegment@ ( ref -- #§ )  -1=?if  drop -1 else  REFA.#SGM u>> %referentSegment and  then ;
( Extracts dependency index #d from referent ref. )
: referentDependency@ ( ref -- #d )
  -1=?if  drop 0 else  REFA.#DEP u>> %referentDependency and  then ;
( Extracts symbol index #s from referent ref. )
: referentSymbol@ ( ref -- #s )  -1=?if  drop 0  else  REFA.#SYM u>> %referentSymbol and  then ;
( Returns the location [dependency + segment] of the referent. )
: referentLocation@ ( ref -- #d#s )
  -1=?if  drop 0  else  %referentNoSymbol and REFA.#SGM u>>  then ;
( Returns the distance from &1 to &2.  Takes only the offset into account, not comparing dependency,
  or segment. )
: &Δ ( &1 &2 -- &1−&2 )  swap referentOffset@ swap referentOffset@ − ;
( Clears the symbol and dependency part of the referent. )
: referentNoSymDep ( ref -- ref' )  -1=?unless  %referentOffSeg and  then ;
( Adds offset u to referent &r. )
: &+ ( &r u -- &r' )  over referentOffset@ + referentOffset! ;
( Checks if &1 is in the same location [i.e. segment of the same dependency] as &2, then if the
  offset of &1 is within the range defined by &2 and &2+#. )
: &within ( &1 &2 # -- ? )  -rot over referentLocation@ over referentLocation@ =unless  3drop false
  else  swap referentOffset@ swap referentOffset@ rot over + within  then ;

vocabulary;
