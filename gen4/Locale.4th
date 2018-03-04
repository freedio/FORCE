vocabulary Locale
  requires" FORTH.voc"

VARIABLE MANTISSA-GROUP-CHARACTER

( NOTE: All getters should be very fast, as they may be invoked from within tight loops! )

( Returns the mantissa group character for thousands' grouping in numeric formatting. )
: mantissaGroupChar@ ( -- uc )  ',' ;

vocabulary;
