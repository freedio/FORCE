vocabulary Dependency
  requires" FORTH.voc"

=== Structure ===

0000  dup constant DEP.NAME#      ( Offset into the text segment of a pair of strings )
cell+ constant DEPENDENCY#

: dept.@name# ( @d -- @d.@name )  DEP.NAME# + ;
: dept.name# ( @d -- @d.name )  dept.@name# @ ;

vocabulary;
