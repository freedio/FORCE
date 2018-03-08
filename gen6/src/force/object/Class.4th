package force/object/

import force/object/Object
import force/exception/TypeCastException
import force/memory/Memory

Object class Class

public section --- API

 cell variable SuperClass
dword variable Module#
dword variable Instance#
 word variable #Words

( Checks if object instance @o is an instance of type @T. )
: instance? ( @o @T -- ? )
  swap class@ begin dup while  over =?if  2drop true exit  then  superclass  repeat  2drop false ;
( Asserts that object instance @o is of type @T. )
: !instance ( @o @T -- @o )
  2dup instance? unlessever  swap class@ TypeCastException raise  then  drop ;

class;
export Class
