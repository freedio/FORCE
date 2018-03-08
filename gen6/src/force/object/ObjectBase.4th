package force/object/

import force/lang/Forth

vocabulary ObjectBase

( Returns object instance @O's class @C. )
: class@ ( @O -- @C )  @ ;
( Returns superclass @C2 of class @C1, or 0 if @C1 has no superclass. )
: superclass ( @C1 -- @C2|0 ) @ ;

classbase vocabulary;
export ObjectBase
