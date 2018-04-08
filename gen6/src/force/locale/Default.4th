/**
  * Default locale.
  */

package force/locale/

import force/lang/Forth

vocabulary Default

public static section --- API --------------------

: mantissaGroupChar@ ( -- c )  ',' ;

vocabulary;
export Default
