/**
  * Vocabulary to convert numbers in various format to string and vice versa.
  */

package force/convert/

import force/lang/Forth

vocabulary NumString

( Converts unsigned cell-sized number u to its decimal representation in buffer at address a.
  The buffer should be at least 24 bytes long.  Returns the start address of the resulting counted
  short string. )
: u>$ ( u a -- a$ )  24+ dup >r swap 10÷% -rot '0'+ swap --c! over 0=until  nip r@ over − --c! ;
( Converts signed cell-sized number n to its decimal representation in buffer at address a.
  The buffer should be at least 24 bytes long.  Returns the start address of the resulting counted
  short string. )
: n>$ ( n a -- a$ )  swap dup 0< swap abs rot
  24+ dup >r swap 10÷% -rot '0'+ swap --c! over 0=until  rot if  '−' c
  nip r@ over − --c! ;

vocabulary;
export NumString
