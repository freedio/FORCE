vocabulary LogLevel
  requires" FORTH.voc"

2 =variable LOG-LEVEL             ( Log level: 0 = DEBUG, 1 = INFO, 2 = WARN, 3 = ERROR )

( Checks if log level is LOG-LEVEL. )
: debug? ( -- ? )  LOG-LEVEL @ 0= ;
( Checks if logg level is INFO. )
: info? ( -- ? )  LOG-LEVEL @ 1≤ ;
( Checks if log level is WARN. )
: warn? ( -- ? )  LOG-LEVEL @ 2≤ ;
( Checks if log level is ERROR. )
: error? ( -- ? )  LOG-LEVEL @ 3≤ ;

vocabulary;
