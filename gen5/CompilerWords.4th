/* Immediate predefined compiler words. */
vocabulary CompilerWords
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"
  requires" Heap.voc"
  requires" FileIO.voc"
  requires" LogLevel.voc"
  requires" Vocabulary.voc"
  requires" ParserControl.voc"
  requires" MacroForcembler-IA64.voc"
  requires" Compiler.voc"

( Finishes the current colon definition. )
: (semicolon) ( -- )  LINKER @ if  @CURRENTWORD @ &@ FLAG.LINKER bit+!  then
  @CURRENTWORD @ &@ FLAG.STATIC bit@ unless  EXIT_INSTANCE,  then
  EXIT, currentCode#! segment>  interpret ;
( Finishes the current colon definition w/o exit code. )
: (doublesemicolon) ( -- )  LINKER @ if  @CURRENTWORD @ &@ FLAG.LINKER bit+!  then
  EXIT2,  currentCode#! segment>  interpret ;

( Switches to the interpreter. )
: [ ( -- )  interpret ;
( Skips parenthesis-comment [nested]. )
: (openpar) ( -- )
  1 begin  readChar ?dup while  '('=?if  drop 1+  else  ')'=if  1−  then  then  dup 0= until  then
  if  "EOF while reading comment"!  then ;

=== Object and Class Related Words ===

( Pushes the current object instance onto the parameter stack. )
: this ( -- @o )  THIS, ;  alias me  alias my
( Creates and initializes new instance o of class with vocabulary ^voc. )
: new ( ^voc -- Object:o )  createObject ;
( Invokes the superclass constructor, if sny. )
: superconstruct ( -- )
  §TEXT #segment@ TEXT.SUPER + @ ?dupif  findConstructor if  compileTarget  then  then
  @CURRENTWORD @ &@ FLAG.CONSTRUCTOR bit+! ;

=== Flow Control ===

( Exits the current function. )
: exit ( -- )  EXIT, ;
( Exits the current function and its caller. )
: 2exit ( -- )  RDROP,  EXIT, ;
( Exits one loop and the current function. )
: exitloop ( -- )  2RDROP,  EXIT, ;

=== Exception Handling ===

: try ( -- [&h] )  createExceptionHandler TRY, ;
: catch ( [&h] -- [&h] )  CATCH, ;
: finally ( [&h] -- [&h] )  FINALLY, ;
: resume ( [&h] -- )  RESUME, ;
: raise ( ^voc -- )  new  "throw" getTargetWord compileTarget ;

=== Blocks and Loops ===

: begin  BEGIN, ;
: end  END, ;
: again  AGAIN, ;
: until  UNTIL, ;
: aslong  ASLONG, ;
: while  WHILE, ;
: repeat  REPEAT, ;
: do  DO, ;
: udo  UDO, ;
: -do  DODOWN, ;
: loop  LOOP, ;

=== Conditional Expressions ===

: if  IF, ;
: ifever  IFEVER, ;
: unless  UNLESS, ;
: unlessever  UNLESSEVER, ;
: else  ELSE, ;
: then  THEN, ;

: ?dupif  DUPIF, ;
: ?dupunless  DUPUNLESS, ;

=== Conditional Terms ===

--- Likely ---

( Tests if x is zero and starts a likely conditional. )
: 0=if ( x -- )  IFZERO, ;  alias 0≠unless
( Tests if x is not zero and starts a likely conditional. )
: 0≠if ( x -- )  IFNOTZERO, ;  alias 0=unless
( Tests if x is negative and starts a likely conditional. )
: 0<if ( x -- )  IFNEGATIVE, ;  alias 0≥unless
( Tests if x is not negative and starts a likely conditional. )
: 0≥if ( x -- )  IFNEGATIVE, ;  alias 0<unless
( Tests if x is positive and starts a likely conditional. )
: 0>if ( x -- )  IFPOSITIVE, ;  alias 0≤unless
( Tests if x is not positive and starts a likely conditional. )
: 0≤if ( x -- )  IFNOTPOSITIVE, ;  alias 0>unless

( Tests if x₁ is equal to x₂ and starts a likely conditional. )
: =if ( x₁ x₂ -- )  IFEQUAL, ;  alias ≠unless
( Tests if x₁ is not equal to x₂ and starts a likely conditional. )
: ≠if ( x₁ x₂ -- )  IFNOTEQUAL, ;  alias =unless
( Tests if n₁ is less than n₂ and starts a likely conditional. )
: <if ( n₁ n₂ -- )  IFLESS, ;  alias ≥unless
( Tests if n₁ is not less than n₂ and starts a likely conditional. )
: ≥if ( n₁ n₂ -- )  IFLESS, ;  alias <unless
( Tests if n₁ is greater than n₂ and starts a likely conditional. )
: >if ( n₁ n₂ -- )  IFGREATER, ;  alias ≤unless
( Tests if n₁ is not greater than n₂ and starts a likely conditional. )
: ≤if ( n₁ n₂ -- )  IFNOTGREATER, ;  alias >unless
( Tests if u₁ is below u₂ and starts a likely conditional. )
: u<if ( u₁ u₂ -- )  IFBELOW, ;  alias u≥unless
( Tests if u₁ is not below u₂ and starts a likely conditional. )
: u≥if ( u₁ u₂ -- )  IFNOTBELOW, ;  alias u<unless
( Tests if u₁ is above u₂ and starts a likely conditional. )
: u>if ( u₁ u₂ -- )  IFABOVE, ;  alias u≤unless
( Tests if u₁ is not above u₂ and starts a likely conditional. )
: u≤if ( u₁ u₂ -- )  IFNOTABOVE, ;  alias u>unless

( Loops while x is zero and starts a likely conditional. )
: 0=while ( x -- )  WHILEZERO, ;
( Loops while x is not zero and starts a likely conditional. )
: 0≠while ( x -- )  WHILENOTZERO, ;
( Loops while x is negative and starts a likely conditional. )
: 0<while ( x -- )  WHILENEGATIVE, ;
( Loops while x is not negative and starts a likely conditional. )
: 0≥while ( x -- )  WHILENEGATIVE, ;
( Loops while x is positive and starts a likely conditional. )
: 0>while ( x -- )  WHILEPOSITIVE, ;
( Loops while x is not positive and starts a likely conditional. )
: 0≤while ( x -- )  WHILENOTPOSITIVE, ;

( Loops while x₁ is equal to x₂ and starts a likely conditional. )
: =while ( x₁ x₂ -- )  WHILEEQUAL, ;
( Loops while x₁ is not equal to x₂ and starts a likely conditional. )
: ≠while ( x₁ x₂ -- )  WHILENOTEQUAL, ;
( Loops while n₁ is less than n₂ and starts a likely conditional. )
: <while ( n₁ n₂ -- )  WHILELESS, ;
( Loops while n₁ is not less than n₂ and starts a likely conditional. )
: ≥while ( n₁ n₂ -- )  WHILELESS, ;
( Loops while n₁ is greater than n₂ and starts a likely conditional. )
: >while ( n₁ n₂ -- )  WHILEGREATER, ;
( Loops while n₁ is not greater than n₂ and starts a likely conditional. )
: ≤while ( n₁ n₂ -- )  WHILENOTGREATER, ;
( Loops while u₁ is below u₂ and starts a likely conditional. )
: u<while ( u₁ u₂ -- )  WHILEBELOW, ;
( Loops while u₁ is not below u₂ and starts a likely conditional. )
: u≥while ( u₁ u₂ -- )  WHILENOTBELOW, ;
( Loops while u₁ is above u₂ and starts a likely conditional. )
: u>while ( u₁ u₂ -- )  WHILEABOVE, ;
( Loops while u₁ is not above u₂ and starts a likely conditional. )
: u≤while ( u₁ u₂ -- )  WHILENOTABOVE, ;

--- Likely, preserving testee ---

( Tests if x is zero and starts a likely conditional. )
: 0=?if ( x -- )  DUPIFZERO, ;  alias 0≠?unless
( Tests if x is not zero and starts a likely conditional. )
: 0≠?if ( x -- )  DUPIFNOTZERO, ;  alias 0=?unless
( Tests if x is negative and starts a likely conditional. )
: 0<?if ( x -- )  DUPIFNEGATIVE, ;  alias 0≥?unless
( Tests if x is not negative and starts a likely conditional. )
: 0≥?if ( x -- )  DUPIFNEGATIVE, ;  alias 0<?unless
( Tests if x is positive and starts a likely conditional. )
: 0>?if ( x -- )  DUPIFPOSITIVE, ;  alias 0≤?unless
( Tests if x is not positive and starts a likely conditional. )
: 0≤?if ( x -- )  DUPIFNOTPOSITIVE, ;  alias 0>?unless

( Tests if x₁ is equal to x₂ and starts a likely conditional. )
: =?if ( x₁ x₂ -- )  DUPIFEQUAL, ;  alias ≠?unless
( Tests if x₁ is not equal to x₂ and starts a likely conditional. )
: ≠?if ( x₁ x₂ -- )  DUPIFNOTEQUAL, ;  alias =?unless
( Tests if n₁ is less than n₂ and starts a likely conditional. )
: <?if ( n₁ n₂ -- )  DUPIFLESS, ;  alias ≥?unless
( Tests if n₁ is not less than n₂ and starts a likely conditional. )
: ≥?if ( n₁ n₂ -- )  DUPIFLESS, ;  alias <?unless
( Tests if n₁ is greater than n₂ and starts a likely conditional. )
: >?if ( n₁ n₂ -- )  DUPIFGREATER, ;  alias ≤?unless
( Tests if n₁ is not greater than n₂ and starts a likely conditional. )
: ≤?if ( n₁ n₂ -- )  DUPIFNOTGREATER, ;  alias >?unless
( Tests if u₁ is below u₂ and starts a likely conditional. )
: u<?if ( u₁ u₂ -- )  DUPIFBELOW, ;  alias u≥?unless
( Tests if u₁ is not below u₂ and starts a likely conditional. )
: u≥?if ( u₁ u₂ -- )  DUPIFNOTBELOW, ;  alias u<?unless
( Tests if u₁ is above u₂ and starts a likely conditional. )
: u>?if ( u₁ u₂ -- )  DUPIFABOVE, ;  alias u≤?unless
( Tests if u₁ is not above u₂ and starts a likely conditional. )
: u≤?if ( u₁ u₂ -- )  DUPIFNOTABOVE, ;  alias u>?unless

( Loops while x is zero. )
: 0=?while ( x -- )  DUPWHILEZERO, ;
( Loops while x is not zero. )
: 0≠?while ( x -- )  DUPWHILENOTZERO, ;
( Loops while x is negative. )
: 0<?while ( x -- )  DUPWHILENEGATIVE, ;
( Loops while x is not negative. )
: 0≥?while ( x -- )  DUPWHILENEGATIVE, ;
( Loops while x is positive. )
: 0>?while ( x -- )  DUPWHILEPOSITIVE, ;
( Loops while x is not positive. )
: 0≤?while ( x -- )  DUPWHILENOTPOSITIVE, ;

( Loops while x₁ is equal to x₂. )
: =?while ( x₁ x₂ -- )  DUPWHILEEQUAL, ;
( Loops while x₁ is not equal to x₂. )
: ≠?while ( x₁ x₂ -- )  DUPWHILENOTEQUAL, ;
( Loops while n₁ is less than n₂. )
: <?while ( n₁ n₂ -- )  DUPWHILELESS, ;
( Loops while n₁ is not less than n₂. )
: ≥?while ( n₁ n₂ -- )  DUPWHILELESS, ;
( Loops while n₁ is greater than n₂. )
: >?while ( n₁ n₂ -- )  DUPWHILEGREATER, ;
( Loops while n₁ is not greater than n₂. )
: ≤?while ( n₁ n₂ -- )  DUPWHILENOTGREATER, ;
( Loops while u₁ is below u₂. )
: u<?while ( u₁ u₂ -- )  DUPWHILEBELOW, ;
( Loops while u₁ is not below u₂. )
: u≥?while ( u₁ u₂ -- )  DUPWHILENOTBELOW, ;
( Loops while u₁ is above u₂. )
: u>?while ( u₁ u₂ -- )  DUPWHILEABOVE, ;
( Loops while u₁ is not above u₂. )
: u≤?while ( u₁ u₂ -- )  DUPWHILENOTABOVE, ;

: 0=?until ( x -- x )  DUPUNTILZERO, ;

--- Unlikely ---

( Tests ifever x is zero and starts a likely conditional. )
: 0=ifever ( x -- )  IFEVERZERO, ;  alias 0≠unlessever
( Tests ifever x is not zero and starts a likely conditional. )
: 0≠ifever ( x -- )  IFEVERNOTZERO, ;  alias 0=unlessever
( Tests ifever x is negative and starts a likely conditional. )
: 0<ifever ( x -- )  IFEVERNEGATIVE, ;  alias 0≥unlessever
( Tests ifever x is not negative and starts a likely conditional. )
: 0≥ifever ( x -- )  IFEVERNEGATIVE, ;  alias 0<unlessever
( Tests ifever x is positive and starts a likely conditional. )
: 0>ifever ( x -- )  IFEVERPOSITIVE, ;  alias 0≤unlessever
( Tests ifever x is not positive and starts a likely conditional. )
: 0≤ifever ( x -- )  IFEVERNOTPOSITIVE, ;  alias 0>unlessever

( Tests if x₁ is equal to x₂ and starts an unlikely conditional. )
: =ifever ( x₁ x₂ -- )  IFEVEREQUAL, ;  alias ≠unlessever
( Tests if x₁ is not equal to x₂ and starts an unlikely conditional. )
: ≠ifever ( x₁ x₂ -- )  IFEVERNOTEQUAL, ;  alias =unlessever
( Tests if n₁ is less than n₂ and starts an unlikely conditional. )
: <ifever ( n₁ n₂ -- )  IFEVERLESS, ;  alias ≥unlessever
( Tests if n₁ is not less than n₂ and starts an unlikely conditional. )
: ≥ifever ( n₁ n₂ -- )  IFEVERLESS, ;  alias <unlessever
( Tests if n₁ is greater than n₂ and starts an unlikely conditional. )
: >ifever ( n₁ n₂ -- )  IFEVERGREATER, ;  alias ≤unlessever
( Tests if n₁ is not greater than n₂ and starts an unlikely conditional. )
: ≤ifever ( n₁ n₂ -- )  IFEVERNOTGREATER, ;  alias >unlessever
( Tests if u₁ is below u₂ and starts an unlikely conditional. )
: u<ifever ( u₁ u₂ -- )  IFEVERBELOW, ;  alias u≥unlessever
( Tests if u₁ is not below u₂ and starts an unlikely conditional. )
: u≥ifever ( u₁ u₂ -- )  IFEVERNOTBELOW, ;  alias u<unlessever
( Tests if u₁ is above u₂ and starts an unlikely conditional. )
: u>ifever ( u₁ u₂ -- )  IFEVERABOVE, ;  alias u≤unlessever
( Tests if u₁ is not above u₂ and starts an unlikely conditional. )
: u≤ifever ( u₁ u₂ -- )  IFEVERNOTABOVE, ;  alias u>unlessever

--- Unlikely, preserving testee ---

( Tests ifever x is zero and starts a likely conditional. )
: 0=?ifever ( x -- )  DUPIFEVERZERO, ;  alias 0≠?unlessever
( Tests ifever x is not zero and starts a likely conditional. )
: 0≠?ifever ( x -- )  DUPIFEVERNOTZERO, ;  alias 0=?unlessever
( Tests ifever x is negative and starts a likely conditional. )
: 0<?ifever ( x -- )  DUPIFEVERNEGATIVE, ;  alias 0≥?unlessever
( Tests ifever x is not negative and starts a likely conditional. )
: 0≥?ifever ( x -- )  DUPIFEVERNEGATIVE, ;  alias 0<?unlessever
( Tests ifever x is positive and starts a likely conditional. )
: 0>?ifever ( x -- )  DUPIFEVERPOSITIVE, ;  alias 0≤?unlessever
( Tests ifever x is not positive and starts a likely conditional. )
: 0≤?ifever ( x -- )  DUPIFEVERNOTPOSITIVE, ;  alias 0>?unlessever

( Tests if x₁ is equal to x₂ and starts an unlikely conditional. )
: =?ifever ( x₁ x₂ -- )  DUPIFEVEREQUAL, ;  alias ≠?unlessever
( Tests if x₁ is not equal to x₂ and starts an unlikely conditional. )
: ≠?ifever ( x₁ x₂ -- )  DUPIFEVERNOTEQUAL, ;  alias =?unlessever
( Tests if n₁ is less than n₂ and starts an unlikely conditional. )
: <?ifever ( n₁ n₂ -- )  DUPIFEVERLESS, ;  alias ≥?unlessever
( Tests if n₁ is not less than n₂ and starts an unlikely conditional. )
: ≥?ifever ( n₁ n₂ -- )  DUPIFEVERLESS, ;  alias <?unlessever
( Tests if n₁ is greater than n₂ and starts an unlikely conditional. )
: >?ifever ( n₁ n₂ -- )  DUPIFEVERGREATER, ;  alias ≤?unlessever
( Tests if n₁ is not greater than n₂ and starts an unlikely conditional. )
: ≤?ifever ( n₁ n₂ -- )  DUPIFEVERNOTGREATER, ;  alias >?unlessever
( Tests if u₁ is below u₂ and starts an unlikely conditional. )
: u<?ifever ( u₁ u₂ -- )  DUPIFEVERBELOW, ;  alias u≥?unlessever
( Tests if u₁ is not below u₂ and starts an unlikely conditional. )
: u≥?ifever ( u₁ u₂ -- )  DUPIFEVERNOTBELOW, ;  alias u<?unlessever
( Tests if u₁ is above u₂ and starts an unlikely conditional. )
: u>?ifever ( u₁ u₂ -- )  DUPIFEVERABOVE, ;  alias u≤?unlessever
( Tests if u₁ is not above u₂ and starts an unlikely conditional. )
: u≤?ifever ( u₁ u₂ -- )  DUPIFEVERNOTABOVE, ;  alias u>?unlessever

vocabulary;
