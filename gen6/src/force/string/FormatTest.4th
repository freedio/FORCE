/**
  * Test suite for the short string formatter
  */

package force/string/

import force/lang/Forth
import force/testing/TestBase
import force/string/Format

vocabulary FormatTest

create Buffer  256 allot          ( Result bufer. )

( Tests various forms of the string placeholder. )
: test1
  "Test" 1 "%s" Buffer format$
      Buffer "Test" expect$
  "World" 1 "Hello, %s!" Buffer format$
      Buffer "Hello, World!" expect$
  20 "World" 2 "Hello, % s, it's a beautiful %-:<10s!" Buffer format$
      Buffer "Hello, World, it's a beautiful World.....!" expect$
  "time" "mørning" 2 "Good %S, it's %*10S to wake up!" Buffer format$
      Buffer "Good MØRNING, it's ******TIME to wake up!" expect$
  ;

( Tests various forms of the decimal placeholder. )
: test2
  42 1 "The answer is %d." Buffer format$
      Buffer "The answer is 42." expect$
  -42 1 "The answer is %d." Buffer format$
      Buffer "The answer is -42." expect$
  42 1 "The answer is %+d." Buffer format$
      Buffer "The answer is +42." expect$
  -42 1 "The answer is %+d." Buffer format$
      Buffer "The answer is -42." expect$
  42 1 "The answer is %06d." Buffer format$
      Buffer "The answer is 000042." expect$
  -42 1 "The answer is %06d." Buffer format$
      Buffer "The answer is -00042." expect$
  42 1 "The answer is %+06d." Buffer format$
      Buffer "The answer is +00042." expect$
  -42 1 "The answer is %+06d." Buffer format$
      Buffer "The answer is -00042." expect$
  42 1 "The answer is % 6d." Buffer format$
      Buffer "The answer is     42." expect$
  -42 1 "The answer is % 6d." Buffer format$
      Buffer "The answer is    -42." expect$
  42 1 "The answer is %*9d." Buffer format$
      Buffer "The answer is *******42." expect$
  -42 1 "The answer is %*9d." Buffer format$
      Buffer "The answer is ******-42." expect$
  42 1 "The answer is %+-_4d." Buffer format$
      Buffer "The answer is +42_." expect$
  -42 1 "The answer is %+-_4d." Buffer format$
      Buffer "The answer is -42_." expect$
  42 1 "The answer is %+-:4d." Buffer format$
      Buffer "The answer is +42.." expect$
  -42 1 "The answer is %+-:4d." Buffer format$
      Buffer "The answer is -42.." expect$
  42 1 "The answer is %(d." Buffer format$
      Buffer "The answer is 42." expect$
  -42 1 "The answer is %(d." Buffer format$
      Buffer "The answer is (42)." expect$
  42 1 "The answer is %+(d." Buffer format$
      Buffer "The answer is +42." expect$
  -42 1 "The answer is %+(d." Buffer format$
      Buffer "The answer is (42)." expect$
  ;

: test3
  1 1 "Got %d answer%<p." Buffer format$
      Buffer "Got 1 answer." expect$
  5 1 "Got %d answer%<p." Buffer format$
      Buffer "Got 5 answers." expect$
  0 1 "Got %d answer%<p." Buffer format$
      Buffer "Got 0 answers." expect$
  -1 1 "Got %d answer%<p." Buffer format$
      Buffer "Got -1 answer." expect$
  -5 1 "Got %d answer%<p." Buffer format$
      Buffer "Got -5 answers." expect$
  1 1 "Got %d class%<2p." Buffer format$
      Buffer "Got 1 class." expect$
  5 1 "Got %d class%<2p." Buffer format$
      Buffer "Got 5 classes." expect$
  1 1 "Got %d memor%<3p." Buffer format$
      Buffer "Got 1 memory." expect$
  5 1 "Got %d memor%<3p." Buffer format$
      Buffer "Got 5 memories." expect$
  ;

private init : init ( -- )  test1 test2 test3 resumee. endTest ;

vocabulary;
export FormatTest
