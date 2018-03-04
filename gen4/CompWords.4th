/* Vocabulary of "immediate words" for the compiler. */
vocabulary CompWords
  requires" FORTH.voc"
  requires" AsmBase64.voc"
  requires" A4-IA64.voc"

( Inserts code for an address word referring to parameter &d. )
: create ( &d -- )  1 ADP+  RAX PUSH  1 ADP-  # RAX MOV ;

vocabulary;
