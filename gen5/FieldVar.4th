vocabulary FieldVar
  requires" FORTH.voc"
      requires" IO.voc"
      requires" StringFormat.voc"
  requires" Heap.voc"
  requires" Referent.voc"
  requires" Vocabulary.voc"
  requires" AsmBase-IA64.voc"
  requires" MacroForcembler-IA64.voc"

=== Variabe, Constant and Field Operations ===

create FIELDNAME$  256 0allot     ( Buffer for getter and setter name )

: assertType ( @o -- @o @C: @C -- )  @vocabulary# selfRef ASSERT_TYPE, ;

( Creates a field of type t with name f$. )
: createField ( t f$ -- )
  %WORD.SCOPE FIELD-FLAGS @ andn  CURRENT-FLAGS dup @ >r andn!  FIELDNAME$ tuck $!  1 ADP+
  createWord currentCode!  >text  ENTER_FIELD,  DOFIELD,  EXIT_FIELD,  currentCode#!  segment>
  FIELDNAME$ dup dup 1c+! count + 1- '@'c!  r@ CURRENT-FLAGS !
  createWord ( getter ) currentCode!  >text  ENTER_FIELD,  dup
  -1=?if  drop  FETCHBFIELD,  else
  1=?if  drop  FETCHCFIELD,  else
  -2=?if  drop  FETCHSFIELD,  else
  2=?if  drop  FETCHWFIELD,  else
  -4=?if  drop  FETCHIFIELD,  else
  4=?if  drop  FETCHDFIELD,  else
  -8=?if  drop  FETCHLFIELD,  else
  8=?if  drop  FETCHQFIELD,  else
  drop  FETCHQFIELD,  then then then then then then then then
  EXIT_FIELD, currentCode#!  segment>
  FIELDNAME$ dup count + 1- '!'c!  r@ CURRENT-FLAGS !
  createWord ( setter ) currentCode!  >text  ENTER_FIELD,  dup
  1=?if  drop  STORECFIELD,  else
  -1=?if  drop  STORECFIELD,  else
  2=?if  drop  STOREWFIELD,  else
  -2=?if  drop  STOREWFIELD,  else
  4=?if  drop  STOREDFIELD,  else
  -4=?if  drop  STOREDFIELD,  else
  8=?if  drop  STOREQFIELD,  else
  -8=?if  drop  STOREQFIELD,  else
  assertType  STOREQFIELD,  then then then then then then then then
  EXIT_FIELD,  currentCode#!  segment>
  §TEXT #segment@ TEXT.VOCFLAGS + VOC%STRUCT bit@ if
    r@ CURRENT-FLAGS !  FIELDNAME$ dup count + 1− '#'c!  r@ CURRENT-FLAGS !
    createWord ( offset ) currentCode!  >text
    ENTER_FIELD,  FIELDOFFSET,  EXIT_FIELD,  currentCode#!  segment>  then
  abs cell min class#+  r> drop  1 ADP- ;
: createVariable ( t v$ -- )
  %WORD.SCOPE FIELD-FLAGS @ andn  CURRENT-FLAGS dup @ >r andn!  FIELDNAME$ tuck $!  1 ADP+
  createWord currentCode!  >text  ENTER_FIELD,  DOVAR,  EXIT_FIELD, currentCode#!  segment>
  FIELDNAME$ dup dup 1c+! count + 1- '@'c!  r@ CURRENT-FLAGS !
  createWord ( getter ) currentCode!  >text  ENTER_FIELD,  dup
  -1=?if  drop  FETCHBVAR,  else
  1=?if  drop  FETCHCVAR,  else
  -2=?if  drop  FETCHSVAR,  else
  2=?if  drop  FETCHWVAR,  else
  -4=?if  drop  FETCHIVAR,  else
  4=?if  drop  FETCHDVAR,  else
  -8=?if  drop  FETCHLVAR,  else
  8=?if  drop  FETCHQVAR,  else
  drop  FETCHQVAR,  then then then then then then then then  EXIT_FIELD,  currentCode#!  segment>
  FIELDNAME$ dup count + 1- '!'c!  r@ CURRENT-FLAGS !
  createWord ( setter ) currentCode!  >text  ENTER_FIELD,  dup
  1=?if  drop  STORECVAR,  else
  -1=?if  drop  STORECVAR,  else
  2=?if  drop  STOREWVAR,  else
  -2=?if  drop  STOREWVAR,  else
  4=?if  drop  STOREDVAR,  else
  -4=?if  drop  STOREDVAR,  else
  8=?if  drop  STOREQVAR,  else
  -8=?if  drop  STOREQVAR,  else
  assertType  STOREQVAR,  then then then then then then then then  EXIT_FIELD,  currentCode#!
  segment>  >data abs cell min 0#, segment>  r> drop 1 ADP- ;
: createConstant ( value c$ -- )  createWord currentCode!
  >text  ENTER_FIELD,  DOCONST,  EXIT_FIELD,  currentCode#!  segment> ;
: createStatAddress ( a$ -- )
  createWord currentCode! >text ENTER_FIELD,
  CURRENT-FLAGS @ FLAG.STATIC bit? unless  DOFIELD,  else  DOVAR,  then
  EXIT_FIELD, currentCode#!  segment> ;
: createDynAddress ( a$ -- )  dup 1 ADP+ createStatAddress
  1 ADP- FIELDNAME$ tuck $!
  dup dup 1c+! count + 1− '#'c!  createWord currentCode! >text
  ENTER_FIELD,  FIELDOFFSET,  EXIT_FIELD,  currentCode#!  segment> ;

vocabulary;
