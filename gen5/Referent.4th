vocabulary Referent
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"

=== Structure ===

0000  dup constant REFERENT.OFFSET        ( Offset within the segment )
 32 + dup constant REFERENT.SEGMENT       ( Segment within the vocabulary. 15 = vocabulary proper )
  4 + dup constant REFERENT.VOCABULARY    ( Index of the vocabulary in the vocabulary table )
 12 + dup constant REFERENT.EXTRA         ( Extra information, up to 16 bits )
 16 + constant REFERENT#                  ( Size of a referent in bits )

32 bits constant %REFERENT.OFFSET
 4 bits constant %REFERENT.SEGMENT
12 bits constant %REFERENT.VOCABULARY
16 bits constant %REFERENT.EXTRA

=== Constructors ===

( Creates a referent with vocabulary index #voc, segment number #seg and offset offs. )
: createReferent ( #voc #seg offs -- )  %REFERENT.OFFSET and  REFERENT.OFFSET u<<
  swap %REFERENT.SEGMENT and  REFERENT.SEGMENT u<< or
  swap %REFERENT.VOCABULARY and  REFERENT.VOCABULARY u<< or ;
( Creates a referent with vocabulary index #voc, segment number #seg, offset offs and extra field
  xtra. )
: createExtendedReferent ( #voc #seg offs xtra -- )  %REFERENT.EXTRA and  REFERENT.EXTRA u<<
  swap %REFERENT.OFFSET and  REFERENT.OFFSET u<< or
  swap %REFERENT.SEGMENT and  REFERENT.SEGMENT u<< or
  swap %REFERENT.VOCABULARY and  REFERENT.VOCABULARY u<< or ;

=== Extractors ===

( Extracts offset offs of referent &r. )
: referentOffset ( &r -- offs )  REFERENT.OFFSET u>>  %REFERENT.OFFSET and ;
( Replaces offset of referent &r with offs. )
: referentOffset! ( &r offs -- )  %REFERENT.OFFSET and swap -1 %REFERENT.OFFSET xor and or ;
( Extracts segment #seg of referent &r. )
: referentSegment ( &r -- #seg )  REFERENT.SEGMENT u>>  %REFERENT.SEGMENT and ;
( Extracts vocabulary index #voc of referent &r. )
: referentVocabulary ( &r -- #voc )  REFERENT.VOCABULARY u>>  %REFERENT.VOCABULARY and ;
( Replaces vocabulary reference of referent &r with #voc. )
: referentVocabulary! ( &r #voc -- )  %REFERENT.VOCABULARY and REFERENT.VOCABULARY u<<
  swap -1 %REFERENT.VOCABULARY REFERENT.VOCABULARY u<< xor and or ;
( Returns extra information xtra in referent &r. )
: referentExtra ( &r -- xtra )  REFERENT.EXTRA u>>  %REFERENT.EXTRA and ;
( Removes the extra field from referent &r so that only offset, segment and vocabulary remain. )
: stripReferent ( &r -- &r' )  REFERENT.EXTRA bits and ;
( Returns domain [vocabulary and segment] d of referent &r. )
: referentDomain ( &r -- d )  stripReferent REFERENT.SEGMENT u>> ;
( Checks if referents &r1 and &r2 refer to the same segment in the same vocabulary. )
: &sameDomain ( &r1 &r2 -- ? )  referentDomain swap referentDomain = ;
( Checks if referent &r1 lies in the range [&r2;&r2+#[. )
: &within ( &r1 &r2 # -- ? )  -rot 2dup &sameDomain if
  referentOffset swap referentOffset -rot tuck + within  else  3drop false  then ;
( Asserts that &r1 and &r2 are in the same domain; aborts otherwise. )
: !sameDomain ( &r1 &r2 -- &r1 &r2 )  2dup referentDomain swap referentDomain =unless
  2 "Referents are of different domains: %016x-%016x!"|abort  then ;
( Adds offset offs to referent &r. )
: &+ ( &r offs -- )  over referentOffset + %REFERENT.OFFSET and swap %REFERENT.OFFSET andn or ;
( Returns the distance between &r1 and &r2 by subtracting the offset of &r2 from the one of &r1.
  Both referents must be in the same domain. )

--- Referent Methods ---

( Splits extended referent &rx into regular referent &r and extra field xtra. )
: splitReferent ( &rx -- &r xtra )  REFERENT.EXTRA bits 1+ u/mod ;

vocabulary;
