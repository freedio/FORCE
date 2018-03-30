/*
 *  Internal test suite.
 */

package force/test/

import force/debug/Debug

vocabulary Test

: test1  1000.s ;
: test2  cr 0 20 −do i . space loop− cr ;
: test3  cr ?dupif  "yes " $.  else  "no " $.  then  depth . ;

vocabulary;
export Test
