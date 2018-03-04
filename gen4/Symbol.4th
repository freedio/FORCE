vocabulary Symbol
  requires" FORTH.voc"
  requires" IO.voc"
  requires" Heap.voc"

=== Symbol Structure ===

0000  dup constant SYMBOL.VALUE   ( The symbol value, an offset into a segment )
cell+ dup constant SYMBOL.SIZE    ( The entity size, or 0 if unknown or irrelevant )
   4+ dup constant SYMBOL.#NAME   ( The symbol name index into the string table )
   2+ dup constant SYMBOL.SCOPE   ( The symbol scope: a segment index, or $80 for external )
   1+ dup constant SYMBOL.FLAGS   ( The symbol flags: LSD = type, MSD = visibility )
   1+ constant SYMBOL#

( Symbol types )
$00 constant SYMBOL-UNKNOWN
$01 constant SYMBOL-DATA
$02 constant SYMBOL-CODE
( Symbol visibilities )
$00 constant SYMBOL-LOCAL
$01 constant SYMBOL-WEAK
$02 constant SYMBOL-GLOBAL
( Scopes )
$80 constant SYMBOL-EXTERNAL

: symbol.@#name ( @s -- @s.@#name )  SYMBOL.#NAME + ;
: symbol.#name ( @s -- @s.#name )  symbol.@#name @ ;

=== Instance Management ===

--- Constructor ---

( Creates a symbol with visibility vis, type typ, scope scp, value val, size len, and name index #n
  on heap #h, and returns symbol index #s [in #h]. )
: createSymbol ( vis typ scp val len #n #h -- #s )  selectedHeap >r  dup selectHeap  heap% >r
  rot , swap d, w, c, swap 4u<< or c,  r> SYMBOL# u/  r> selectHeap ;

=== API ===

vocabulary;
