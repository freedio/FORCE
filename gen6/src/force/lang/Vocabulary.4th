/**
  * Vocabulary Management
  */

package force/lang/

import force/lang/Forth
import force/lang/Xstack
import force/structure/TextHeader
import force/inout/DirectIO
import force/debug/Debug

vocabulary Vocabulary

public static section --- Constants ------------------------------

00 constant %private              ( Visibility private. )
01 constant %protected            ( Visibility protected. )
02 constant %package              ( Visibility package-private. )
03 constant %public               ( Visibility public. )
03 constant %visibility           ( Visibility mask. )

private static section --- Interna -------------------------------

( Checks if word @w is public. )
: public? ( @w -- ? )  w@ %visibility and %public = ;
( Checks if word at address @w has name w$. )
: named? ( w$ @w -- ? )  4+ $= ;
( Returns address @w2 of word following word @w1. )
: >next ( @w1 -- @w2 )  4+ dup c@ 1+ + dup w@ + 2+ ;

public static section --- API ------------------------------------

( Looks up last word with name w$ in text segment at address @t.  If found, returns
  address @w of the word, else 0. )
: findWord ( w$ @t -- @w|0 )  0 >x dup Contents# +  swap #Words@ 0 do
  dup public? if  2dup named? if  x> smash >x  then  then  >next  loop  2drop x> ;

vocabulary;
export Vocabulary
