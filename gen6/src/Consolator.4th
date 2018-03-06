/**
  * The Consolator is a static factory for creating Console objects.
  */

import ConChannel

vocabulary Consolator

=== Internal Structures ===

create Channels                   ( Frames the array of channels below )
ConChannel variable StdIn         ( Standard input channel )
ConChannel variable StdOut        ( Standard output channel )
ConChannel variable StdErr        ( Standard error channel )
ConChannel variable StdLog        ( Standard logging channel )

private static section

( Returns channel c associated with index #. )
: >channel ( # -- ConChannel:c )  3and  Channels swap cells+ @ ConChannel ;

public static section --- API

( Unconditionally moves the cursor of channel # to the beginning of the next line. )
: #cr ( # -- )  >channel cr ;
( Moves the cursor of channel # to the beginning of the next line, unless it already is on the
  leftmost column of a line. )
: ?#cr ( # -- )  >channel ?cr ;

( Initializes the vocabulary from initialization structure at address @initstr when loading. )
private init : initConsolator ( @initstr -- @initstr )
  0 Conchannel new StdIn!
  1 ConChannel new StdOut!
  2 ConChannel new StdErr!
  3 ConChannel new StdLog! ;

vocabulary;
export Consolator
