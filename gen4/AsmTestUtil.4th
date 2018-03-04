vocabulary AsmTestUtil
  requires" FORTH.voc"
  requires" IO.voc"
  requires" StringFormat.voc"
  requires" AsmTestBase.voc"
  requires" AsmBase64.voc"

variable ERRORS
create SHOULD  128 0allot
variable MUSTSHOW
create TESTPAD  256 0allot
variable D₀

: !op ( op code mode size arch type -- )
  4<< + 4<< + 8<< + 8<< + 2dup = unless
    2dup .line 2 ": expected op %08x, but got %08x"| then  2drop  ;
: clerinc ( -- ) ERRORS 1+!  ERRMSG 0! ;
: ¶ ( -- )  cleanup  INLINE 1+!  ERRMSG @ ?dupif  .error  clerinc  then ;
: !error ( e$ -- )  ERRMSG @ unless  clerinc sourceFile@ sourceColumn@ sourceLine@ 4 roll
    4 "Expected error «\e[22m%s\e[1m» on line %d.%d in «%s», but there was no error!"|!  else
    ERRMSG @ ≠??if
      sourceFile@ sourceColumn@ sourceLine@ 5 roll
      cr err+ "Expected error «". err- $. err+ "» on line ". . '.' emit . " in «". $.
      "», but got «". err- $. err+ "»!". err-  clerinc then  then  ERRMSG 0!  sp0 sp! ;
: !disp ( n # -- )  dispsize@ ≠??if
    2dup swap 2 "Expected displacement size %d, but got %d"|.. then  2drop
  disp@ ≠??if  2dup swap 2 "Expected displacement %d, but got %d"|.. then  2drop ;
: ~ ( -- )  ERRMSG @ ?dupif  .error  clerinc  then  MUSTSHOW off  TESTPAD there!  INLINE 1+!
  cr INLINE @ 1 "Line %d: "|. ;
: ~~ ( -- )  INLINE 1+! ~ ;
: « ( -- )  depth D₀ ! ;
: » ( ... -- )  depth D₀ @ - dup SHOULD c!  SHOULD over 1+ + swap 0 do  --c!  loop  drop
  there TESTPAD - SHOULD c@ ≠??if  2dup 2 "Expected %d bytes, but got %d"|!  MUSTSHOW on  then
  min  TESTPAD SHOULD 1+ 2 pick csame not MUSTSHOW or!  MUSTSHOW @ if  "  : ".
  ( SHOULD count cr "SHOULD: ". hexbytes.  TESTPAD over ", TESTPAD: ". hexbytes. )
    SHOULD 1+ TESTPAD rot 0 do  space  over c@ over c@  ≠??if
      err+  hc. "≠". hc. err-  else  hc. drop  then  1+ swap 1+ swap loop  drop  then  drop ;

vocabulary;
