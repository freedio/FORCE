package /force/exception

import Forth
import Exception

Exception class TypeCastException

public section

cell variable Actual
cell variable Expected

( Constructor of class TypeCastException. )
: construct ( Class:expected Class:actual this -- )  superconstruct  my Actual!  my Expected! ;

class;
export TypeCastException