require forceemu.4th
require C0-64.4th

/* FORCE ELF Object File Generator
 * ===============================
 * version 0
 */

=== Configuration ===

variable TARGET-SIZE                ( 1 = 32 bits, 2 = 64 bits )
variable TARGET-FORMAT              ( 1 for little endian, 2 for big endian )
variable TARGET-SYSTEM              ( 0 for anything, $01..$ff for various systems, $03 = Linux )
variable ELF-ABI                    ( 0, at least on Linux )
variable MODULE-TYPE                ( 1 = relocatable, 2 = executable, 3 = shared, 4 = core )
variable TARGET-ISA                 ( $03 = x86, $32 = IA64, $3E = x86_64, $28 = ARM, ... )
variable TARGET-FLAGS               ( ?, 0 for now )
variable @ELF-PHDR                  ( = Program header table offset )
variable @ELF-SHDR                  ( = Section header table offset )
variable #ELF-SECTION-NAMES-TABLE   ( = Index of the section name table )
variable BASE-ADDR                  ( = File offset after EHDR, PHDR und SHDR )
variable @ENTRY                     ( = Program entry address )

=== ELF Constants ===

( Section types )
$00 constant SHT_NULL               ( Unused section header table entry )
$01 constant SHT_PROGBITS           ( Program data )
$02 constant SHT_SYMTAB             ( Symbol table )
$03 constant SHT_STRTAB             ( String table )
$04 constant SHT_RELA               ( Relocation entries with addends )
$05 constant SHT_HASH               ( Symbol hash table )
$06 constant SHT_DYNAMIC            ( Dynamic linking information )
$07 constant SHT_NOTE               ( Notes )
$08 constant SHT_NOBITS             ( Program space with no data [bss] )
$09 constant SHT_REL                ( Relocation entries, no addends )
$0A constant SHT_SHLIB              ( reserved )
$0B constant SHT_DYNSYM             ( Dynamic linker symbol table )
$0E constant SHT_INIT_ARRAY         ( Array of constructors )
$0F constant SHT_FINI_ARRAY         ( Array of destructors )
$10 constant SHT_PREINIT_ARRAY      ( Array of pre-constructors )
$11 constant SHT_GROUP              ( Section group )
$12 constant SHT_SYMTAB_SHNDX       ( Extended section indeces )
$13 constant SHT_NUM                ( Number of defined types )

( Section flags )
$0000 constant SHF_DEFAULT          ( Default [readable] )
$0001 constant SHF_WRITE            ( Writable )
$0002 constant SHF_ALLOC            ( Occupies memory during execution )
$0004 constant SHF_EXECINSTR        ( Executable )
$0010 constant SHF_MERGE            ( Might be merged )
$0020 constant SHF_STRINGS          ( Contains nul-terminated strings )
$0040 constant SHF_INFO_LINK        ( 'sh_info' contains SHT index )
$0080 constant SHF_LINK_ORDER       ( Preserve order after combining )
$0100 constant SHF_OS_NONCONFORMING ( Non-standard OS specific handling required )
$0200 constant SHF_GROUP            ( Section is member of a group )
$0400 constant SHF_TLS              ( Section hold thread-local data )

( Segment types )
$0000 constant PT_NULL              ( Unused program header table entry )
$0001 constant PT_LOAD              ( Loadable segment )
$0002 constant PT_DYNAMIC           ( Dynamic linking information )
$0003 constant PT_INTERP            ( Interpreter name )
$0004 constant PT_NOTE              ( Auxiliary information )
$0006 constant PT_PHDR              ( Program header table reference to load PHDR as segment )

( Segment flags )
$0001 constant PF_EXECUTE           ( Segment is executable )
$0002 constant PF_WRITE             ( Segment is writable )
$0004 constant PF_READ              ( Segment is readable )

( Symbol bindings )
$0000 constant STB_LOCAL            ( Local symbol )
$0001 constant STB_GLOBAL           ( Global symbol )
$0002 constant STB_WEAK             ( Global symbol with lower precedence )

( Symbol types )
$0000 constant STT_NOTYPE           ( Type unspecified )
$0001 constant STT_OBJECT           ( Data )
$0002 constant STT_FUNC             ( Code )
$0003 constant STT_SECTION          ( Section representative )
$0004 constant STT_FILE             ( Source file name )
$0005 constant STT_COMMON           ( Uninitialized common block )
$0006 constant STT_TLS              ( Thread local storage entity )

( Symbol visibility )
$0000 constant STV_DEFAULT          ( As declared by symbol binding )
$0002 constant STV_HIDDEN           ( Hide symbol, regardless of binding )
$0003 constant STV_PROTECTED        ( Protected symbol )
$0004 constant STV_EXPORTED         ( Ensure that GLOBAL symbol remains visible )
$0005 constant STV_SINGLETON        ( Ensure that GLOBAL symbol remains visible and unique )
$0006 constant STV_ELIMINATE        ( Remove symbol, regardless of binding )

=== ELF Parts ===

--- File structure ---

0000  dup constant @EHDR            ( Address of the ELF header segment )
cell+ dup constant #EHDR            ( Size of the ELF header segment )
cell+ dup constant EHDR#            ( Length of the ELF header segment )
cell+ dup constant @PHDR            ( Address of the program header table segment )
cell+ dup constant #PHDR            ( Size of the program header table segment )
cell+ dup constant PHDR#            ( Length of the program header table segment )
cell+ dup constant @SHDR            ( Address of the section header table segment )
cell+ dup constant #SHDR            ( Size of the section header table segment )
cell+ dup constant SHDR#            ( Length of the section header table segment )
cell+ dup constant @SECT            ( Address of the sections segment )
cell+ dup constant #SECT            ( Size of the sections segment )
cell+ dup constant SECT#            ( Length of the sections segment )
cell+ dup constant @$TAB            ( Address of the string table segment )
cell+ dup constant #$TAB            ( Size of the string table segment )
cell+ dup constant $TAB#            ( Length of the string table segment )
cell+ dup constant @SH$T            ( Address of the section header string table segment )
cell+ dup constant #SH$T            ( Size of the section header string table segment )
cell+ dup constant SH$T#            ( Length of the section header string table segment )
cell+ constant ELF#

( Segment numbers )
 0 dup constant §EHDR
1+ dup constant §PHDR
1+ dup constant §SHDR
1+ dup constant §SECT
1+ dup constant §$TAB
1+ dup constant §SH$T
1+ constant ELFsegments

( Segment names )
create §EHDR$ ," ELF header"
create §PHDR$ ," program header table"
create §SHDR$ ," section header table"
create §SECT$ ," sections segment"
create §$TAB$ ," string table"
create §SH$T$ ," section header string table"
create SEGNAMES §EHDR$ ,  §PHDR$ ,  §SHDR$ ,  §SECT$ ,  §$TAB$ , §SH$T$ ,

--- File structure methods ---

:( Switches to the ELF header segment )
: >ehdr ( -- )  §EHDR tseg! ;
:( Switches to the program header table segment )
: >phdr ( -- )  §PHDR tseg! ;
:( Switches to the section header table segment )
: >shdr ( -- )  §SHDR tseg! ;
:( Switches to the section segment )
: >sect ( -- )  §SECT tseg! ;
:( Switches to the string table segment )
: >$tab ( -- )  §$TAB tseg! ;
:( Switches to the section header string table segment )
: >sh$t ( -- )  §SH$T tseg! ;

: segments. ( -- )  ELFsegments 0 +do  tvoc@ i segment  cr i cells SEGNAMES + @ type$
  ." : " swap addr. space ." # " .  loop cr ;

=== Section Parameters ===

variable SECTION_VIRTUAL_ADDRESS        ( Virtual address of next section )
variable SECTION_FILE_OFFSET            ( Offset of the next section in the object file )
variable #SYMBOLS                       ( # of symbols in symbol table )
variable #LOCALS                        ( # of local symbols in symbol table )
variable SYMTAB#                        ( Length of symbol table )

( Each section parameter entity must define, in order, the following cell-sized parameters:
  • Address of the section name
  • Section type
  • Section flags aka attributes
  • Alignment size
  • Entry size, or 0 if entries vary in size
)

create dictname ," .dict"
create codename ," .text"
create dataname ," .data"
create textname ," .rodata"
create symsname ," .symtab"
create vrefname ," .rela.dict"
create crefname ," .rela.text"
create drefname ," .rela.data"
create trefname ," .rela.rodata"

create dictpara  dictname ,  SHT_PROGBITS ,  SHF_ALLOC ,  0 d, 0 d,  4 cells , 4 cells ,
create codepara  codename ,  SHT_PROGBITS ,  SHF_EXECINSTR SHF_ALLOC + ,  0 d, 0 d,  0 ,  0 ,
create datapara  dataname ,  SHT_PROGBITS ,  SHF_WRITE SHF_ALLOC + ,  0 d, 0 d,  cell ,  cell ,
create textpara  textname ,  SHT_PROGBITS ,  SHF_ALLOC ,  0 d, 0 d,  cell , 0 ,
create symspara  symsname ,  SHT_SYMTAB ,  0 ,  6 d, 0 d,  cell ,  3 cells ,
create refspara  vrefname ,  SHT_RELA , 0 ,  5 d, 3 d,  cell , 3 cells ,
                 crefname ,  SHT_RELA , 0 ,  5 d, 1 d,  cell , 3 cells ,
                 drefname ,  SHT_RELA , 0 ,  5 d, 2 d,  cell , 3 cells ,
                 trefname ,  SHT_RELA , 0 ,  5 d, 4 d,  cell , 3 cells ,

--- Section parameter methods ---

:( Copies the string at a$ to the string table and returns its string table offset )
: >>strings ( a$ -- u )  tseg# >r >$tab  target@ segment-length >r
  count dup target@ rot allotSpace swap cmove  0 tc, r> r> tseg! ;
  ( This can be optimized by first generating the NUL-terminated string, then searching the string
    table for an occurrence of it [including the NUL-byte] and returning the offset of the entry
    if one was found, and only adding the string if it was not found )
:( Copies the string at a$ to the section header string table and returns its offset )
: >>section-hdr ( a$ -- u )  tseg@ >r >sh$t  target@ segment-length >r
  count dup target@ rot allotSpace swap cmove  0 tc, r> r> tseg! ;
  ( This can be optimized by first generating the NUL-terminated string, then searching the string
    table for an occurrence of it [including the NUL-byte] and returning the offset of the entry
    if one was found, and only adding the string if it was not found )

defer .va!
defer .fo!
defer .vs+!
defer .fs+!
:( Creates a section header with the parameters at @para for segment #seg of vocabulary @voc,
   storing the virtual address/size and file offset/size at segment parameters @segmt )
: createSection ( @voc #seg @para @segmt -- )
  tseg# >r >r SECTION_VIRTUAL_ADDRESS @ r@ .va!  SECTION_FILE_OFFSET @ r@ .fo!
  @++ >>section-hdr  >shdr  td, ( sh_name )
  @++ td, ( sh_type )  @++ t, ( sh_flags )  SECTION_VIRTUAL_ADDRESS @ t, ( sh_addr )
  SECTION_FILE_OFFSET @ t, ( sh_offset )  -rot segment-length dup t, ( sh_size )
  dup SECTION_FILE_OFFSET +!  dup r@ .vs+!  dup r> .fs+!  >>pages SECTION_VIRTUAL_ADDRESS +!
  @d++ td, ( sh_link )  @d++ td, ( sh_info )  @++ t, ( sh_addralign )  @ t, ( sh_entsize )  r> tseg! ;
: createSymTabSection ( -- )
  c" .symtab" >>section-hdr >shdr td, ( sh_name ) SHT_SYMTAB td, ( sh_type )
  0 t, ( sh_flags )  0 t, ( sh_addr )  SECTION_FILE_OFFSET @ t, ( sh_offset )
  SYMTAB# @ dup t, ( sh_size ) SECTION_FILE_OFFSET +!  6 td, ( sh_link )
  #LOCALS @ td, ( sh_info )  cell t, ( sh_align )  5 TARGET-SIZE @ - cells t, ( sh_entsize ) ;
: createRelTabSection ( size @para -- )  tseg# >r  @++ >>section-hdr >shdr td, ( sh_name )
  @++ td, ( sh_type )  @++ t, ( sh_flags )  0 t, ( sh_addr )
  SECTION_FILE_OFFSET @ t, ( sh_offset )  over t, ( sh_size )  swap SECTION_FILE_OFFSET +!
  @d++ td, ( sh_link )  @d++ td, ( sh_info )  @++ t, ( sh_addralign )  @ t, ( sh_entsize )  r> tseg! ;

=== Section Generation ===

--- Symbol Table Generation ---

:( Adds symbol @sym to the symbol table and advances to next symbol @sym' )
: sym64, ( @sym -- )
  dup >>strings td, dup c@ 1+ +  dup SYM-VISIBILITY + c@ case
    SYM-PRIVATE of  STB_LOCAL  endof
    SYM-PROTECTED of  STB_WEAK  endof
    SYM-PUBLIC of  STB_GLOBAL  endof
    cr ." Invalid symbol visibility: " .  abort endcase
  4 << over SYM-TYPE + c@ case
    SYM-DATA of  STT_OBJECT  endof
    SYM-CODE of  STT_FUNC  endof
    cr ." Invalid symbol type: " .  abort endcase
  $f and + tc,  STV_DEFAULT tc,  dup SYM-SCOPE + c@ case
    §DICT of  3  endof
    §CODE of  1  endof
    §DATA of  2  endof
    §TEXT of  4  endof
    cr ." Invalid section index: " .  abort endcase
  over SYM-REF + c@ SYM-EXTERNAL = if  drop 0  then
  tw,  dup SYM-VALUE + @ t,  SYM-SIZE + @ t,
  #SYMBOLS 1+!  3 cells SYMTAB# +! ;
:( Writes the symbol table for 64-bit targets )
: syms64, ( @voc -- @voc )  c" " >>strings drop
  >sect  0 dup t, dup t, t,  #SYMBOLS 1+!  3 cells SYMTAB# !
  dup §SYMS segment begin ?dup while  over count +
    SYM-VISIBILITY + c@ SYM-PRIVATE = if  over sym64,  then
    over c@ 1+ SYM# + advance# repeat  drop  #SYMBOLS @ #LOCALS !
  dup §SYMS segment begin ?dup while  over count +
    SYM-VISIBILITY + c@ SYM-PRIVATE - if  over sym64,  then
    over c@ 1+ SYM# + advance#  repeat  drop  createSymTabSection ;
:( Adds symbol @sym to the symbol table and advances to next symbol @sym' )
: sym32, ( @sym -- )
  dup >>strings td, dup c@ 1+ +  dup SYM-VALUE + @ t,  dup SYM-SIZE + @ t,
  dup SYM-VISIBILITY + c@ case
    SYM-PRIVATE of  STB_LOCAL  endof
    SYM-PROTECTED of  STB_WEAK  endof
    SYM-PUBLIC of  STB_GLOBAL  endof
    cr ." Invalid symbol visibility: " .  abort endcase
  4 << over SYM-TYPE + c@ case
    SYM-DATA of  STT_OBJECT  endof
    SYM-CODE of  STT_FUNC  endof
    cr ." Invalid symbol type: " .  abort endcase
  $f and + tc,  STV_DEFAULT tc,  dup SYM-SCOPE + c@ case
    §DICT of  3  endof
    §CODE of  1  endof
    §DATA of  2  endof
    §TEXT of  4  endof
    cr ." Invalid section index: " .  abort endcase
  tw,  #SYMBOLS 1+!  4 cells SYMTAB# +! ;
:( Writes the symbol table for 32-bit targets )
: syms32, ( @voc -- @voc )  c" " >>strings drop
  >sect  0 dup t, dup t, dup t, t,  #SYMBOLS 1+!  4 cells SYMTAB# +!
  dup §SYMS segment begin ?dup while  over count +
    SYM-VISIBILITY + c@ SYM-PRIVATE = if  over sym32,  then
    over c@ 1+ SYM# + advance#  repeat  drop  #SYMBOLS @ #LOCALS !
  dup §SYMS segment begin ?dup while  over count +
    SYM-VISIBILITY + c@ SYM-PRIVATE - if  over sym32,  then
    over c@ 1+ SYM# + advance#  repeat  drop  createSymTabSection ;

--- Relocation Types ---

00 constant R_X86_64_NONE                 ( No relocation )
01 constant R_X86_64_64                   ( Direct 64 bit )
02 constant R_X86_64_PC32                 ( PC relative 32 bit signed )
03 constant R_X86_64_GOT32                ( 32 bit GOT entry )
04 constant R_X86_64_PLT32                ( 32 bit PLT address )
05 constant R_X86_64_COPY                 ( Copy symbol at runtime )
06 constant R_X86_64_GLOB_DAT             ( Create GOT entry )
07 constant R_X86_64_JUMP_SLOT            ( Create PLT entry )
08 constant R_X86_64_RELATIVE             ( Adjust by program base )
09 constant R_X86_64_GOTPCREL             ( 32 bit signed pc relative )
10 constant R_X86_64_32                   ( Direct 32 bit zero extended )
11 constant R_X86_64_32S                  ( Direct 32 bit sign extended )
12 constant R_X86_64_16                   ( Direct 16 bit zero extended )
13 constant R_X86_64_PC16                 ( 16 bit sign extended pc relative )
14 constant R_X86_64_8                    ( Direct 8 bit sign extended )
15 constant R_X86_64_PC8                  ( 8 bit sign extended pc relative )
16 constant R_X86_64#

create relocounts  0 , 0 , 0 , 0 ,

--- Relocation Table Generation ---

:( Counts the relocations targeting segment #seg [0..3] in vocabulary @voc )
: countRelocations ( @voc #seg -- @voc )  dup cell * relocounts + >B
  over §REFS segment RE# / 0 +do  2dup REL-REFSEG + w@ = B@ -!  RE# +  loop  2drop  B> drop ;
:( Creates the relocation table for target segment #seg [0..3] in vocabulary @voc )
: createRelocations ( @voc #seg -- @voc )  dup cell * relocounts + dup @ unless  2drop exit  then
  dup >B 0!  >$tab  over §REFS segment RE# / 0 +do  2dup REL-REFSEG + w@ = if
    dup REL-REFOFFSET + @ t,  dup REL-TGTSYMBOL + w@ 1+ 32 <<  over REL-FLAGS + w@ $7FFF and
    dup REL-RELATIVE and if  drop -4 R_X86_64_PC32  else $ff and case
      0 of  R_X86_64_NONE  endof
      REL-8 of   0 R_X86_64_8  endof
      REL-16 of  0 R_X86_64_16  endof
      REL-32 of  0 R_X86_64_32  endof
      REL-64 of  0 R_X86_64_64  endof
      cr ." Invalid relocation type (flags): " hex. abort  endcase  then
    rot or t, t,  3 cells B@ +!  then  RE# + loop  drop
  cr 6 * cells refspara + B> @ swap createRelTabSection ;

--- Section Generation Structures ---

create @EXECUTION  4 cells 0allot
create @VARIABLES  4 cells 0allot
create @CONSTANTS  4 cells 0allot
create @METAINFOS  4 cells allot

: ?! ( x a -- )  dup @ if  2drop  else  !  then ;
: .va@ ( @segmt -- x )  @ ;
:noname ( x @segmt -- )  ?! ; is .va!
: .fo@ ( @segmt -- x )  cell+ @ ;
:noname ( x @segmt -- )  cell+ ?! ; is .fo!
: .vs@ ( @segmt -- x )  2 cells + @ ;
:noname ( x @segmt -- )  2 cells + +! ; is .vs+!
: .fs@ ( @segmt -- x )  3 cells + @ ;
:noname ( x @segmt -- )  3 cells + +! ; is .fs+!

--- Section Generation Methods ---

:( Appends the data at a with length # to the sections segment )
: >sections ( a # -- )  >sect  target@ 2 pick allotSpace swap cmove ;

:( Writes the dictionary section )
: dict, ( @voc -- @voc )  dup §DICT 2dup dictpara @CONSTANTS createSection  segment >sections ;
:( Writes the code section )
: code, ( @voc -- @voc )  dup §CODE 2dup codepara @EXECUTION createSection  segment >sections ;
:( Writes the data section )
: data, ( @voc -- @voc )  dup §DATA 2dup datapara @VARIABLES createSection  segment >sections ;
:( Writes the text section )
: text, ( @voc -- @voc )  dup §TEXT 2dup textpara @CONSTANTS createSection  segment >sections ;
:( Writes the symbol table )
: syms, ( @voc -- @voc )  TARGET-SIZE @ case
  1 of  syms32,  endof
  2 of  syms64,  endof
  cr ." Invalid target size index: " .  abort endcase ;
:( Writes the relocation table )
: refs, ( @voc -- @voc )  4 0 do  i countRelocations  loop  4 0 do  i createRelocations  loop ;
:( Writes the dependencies section )
: deps, ( @voc -- @voc ) ;

=== Derived configuration parameters ===

:( Returns the size of a program header table entry )
: ELF-PHENTS@ ( -- u )  TARGET-SIZE @ 24 * 8 + ;
:( Returns the size of a section header table entry )
: ELF-SHENTS@ ( -- u )  TARGET-SIZE @ 24 * 16 + ;
:( Returns the number of program header table entries [so far] )
: #ELF-PHENTS@  tvoc@ §PHDR segment-length ELF-PHENTS@ u/ ;
:( Returns the number of section header table entries [so far] )
: #ELF-SHENTS@  tvoc@ §SHDR segment-length ELF-SHENTS@ u/ ;

=== ELF Header Methods ===

:( Appends the ELF magic number )
: ELFmagic, ( -- )  $7F tc, 'E' tc, 'L' tc, 'F' tc, ;
:( Appends the ELF file class )
: ELFclass, ( -- )  TARGET-SIZE @ tc, ;
:( Appends the ELF data format )
: ELFdata, ( -- )  TARGET-FORMAT @ tc, ;
:( Appends the ELF version )
: ELFversion, ( -- )  1 tc, ;
:( Appends the ELF identifier )
: ELFident, ( -- )  ELFmagic, ELFclass, ELFData, ELFversion, ;
:( Appends the target system )
: ELFsystem, ( -- )  TARGET-SYSTEm @ tc, ;
:( Appends the ABI )
: ELFABI, ( -- )  ELF-ABI @ tc, ;
:( Appends the padding to $10 )
: ELFpad, ( -- )  $10 talign, ;
:( Appends the module type )
: ELFtype, ( -- )  MODULE-TYPE @ tw, ;
:( Appends the instruction set architecture )
: ELFcode, ( -- )  TARGET-ISA @ tw, ;
:( Appends the ELF version )
: ELFversion2, ( -- )  1 td, ;
:( Appends the module entry point of vocabulary @voc )
: ELFentry, ( @voc -- @voc )  @ENTRY @ t, ;
:( Appends the program header table address )
: ELF@phdr, ( -- )  TARGET-SIZE @ 12 * 40 + dup @ELF-PHDR ! t, ;
:( Appends the segment header table address )
: ELF@shdr, ( -- )  @ELF-PHDR @ tvoc@ §PHDR segment-length + dup @ELF-SHDR ! t, ;
:( Appends the target flags )
: ELFflags, ( -- )  TARGET-FLAGS @ td, ;
:( Appends the ELF header size )
: ELFhsize, ( -- )  @ELF-PHDR @ tw, ;
:( Appends the size of a program header table entry )
: ELFphents, ( -- )  ELF-PHENTS@ tw, ;
:( Appends the number of program header table entries )
: ELFphent#, ( -- )  #ELF-PHENTS@ tw, ;
:( Appends the size of a section header table entry )
: ELFshents, ( -- )  ELF-SHENTS@ tw, ;
:( Appends the number of section header table entries )
: ELFshent#, ( -- )  #ELF-SHENTS@ tw, ;
:( Appends the index of the section header table entry with the section names )
: ELF#secname, ( -- )  #ELF-SECTION-NAMES-TABLE @ tw, ;
:( Appends the ELF header to the output structure )
: ELFheader, ( @voc -- @voc )  >ehdr
  ELFident, ELFsystem, ELFABI, ELFpad, ELFtype, ELFcode, ELFversion2, ELFentry, ELF@phdr, ELF@shdr,
  ELFflags, ELFhsize, ELFphents, ELFphent#, ELFshents, ELFshent#, ELF#secname, ;

=== Program Header Table Management ===

--- Program Header Table Structures ---

( Each segment parameter entity must define the following cell-sized parameters, in order:
  • Segment type
  • Segment flags
  • Segment align
)

create EXECUTION-SEGMENT  PT_LOAD ,  PF_EXECUTE PF_READ + ,  0 ,
create VARIABLES-SEGMENT  PT_LOAD ,  PF_READ PF_WRITE + ,  cell ,
create CONSTANTS-SEGMENT  PT_LOAD ,  PF_READ ,  1 ,

--- Program Header Table Methods ---

:( Creates a segment using parameters @para and segment parameters @segmt )
: createSegment ( @segmt @para -- )  tseg# >r >phdr  @++ td, ( p_type )
  TARGET-SIZE @ 2 = if  @++ td, ( p_flags 64 )  then
  over .fo@ t, ( p_offset )  over .va@ t, ( p_vaddr )  0 t, ( p_paddr )
  over .fs@ t, ( p_filesz )  swap .vs@ t, ( p_memsz )
  TARGET-SIZE @ 1 = if  @++ td, ( p_flags 32 )  then
  @ t, ( p_align )  r> tseg! ;
:( Creates the code segment header for vocabulary @voc )
: createExecutionSegment ( @voc -- @voc )  @EXECUTION EXECUTION-SEGMENT createSegment ;
:( Creates the data segment header for vocabulary @voc )
: createVariablesSegment ( @voc -- @voc )  @VARIABLES VARIABLES-SEGMENT createSegment ;
:( Creates the text segment header for vocabulary @voc )
: createConstantsSegment ( @voc -- @voc )  @CONSTANTS CONSTANTS-SEGMENT createSegment ;
:( Checks if the module has a main word.  If so, make it executable and set its entry-point to the
   code field address of the program entry point )
: checkEntry ( @voc -- @voc )  dup §DICT segment WORD# u/ 0 +do  dup .flg@ ^MAIN and if
    .cfa@  @EXECUTION .va@ + @ENTRY ! unloop exit  then
  WORD# + loop  drop 0 @ENTRY ! ;

:( Appends an empty section to the section header table )
: createEmptySection ( -- )  c" " >>section-hdr >shdr td, ( sh_name ) SHT_NULL td, ( sh_type )
  0 t, ( sh_flags )  0 t, ( sh_addr )  0 t, ( sh_offset )  0 t, ( sh_size )  0 td, ( sh_link )
  0 td, ( sh_link )  0 t, ( sh_align )  0 t, ( sh_entsize ) ;
:( Appends the section name table to the section header table )
: appendSectionNamesTable ( -- )  #ELF-SHENTS@ #ELF-SECTION-NAMES-TABLE !
  c" .shstrtab" >>section-hdr >shdr td, ( sh_name )  SHT_STRTAB td, ( sh_type )
  SHF_STRINGS t, ( sh_flags )  0 t, ( sh_addr )  SECTION_FILE_OFFSET @ t, ( sh_offset )
  tvoc@ §SH$T segment-length dup t, ( sh_size )  SECTION_FILE_OFFSET +!
  0 td, ( sh_link )  0 td, ( sh_info )  1 t, ( sh_align )  0 t, ( sh_ent_size ) ;
:( Appends the string table to the section header table )
: strs, ( -- )  c" .strtab" >>section-hdr >shdr td, ( sh_name )  SHT_STRTAB td, ( sh_type )
  SHF_STRINGS t, ( sh_flags )  0 t, ( sh_addr )  SECTION_FILE_OFFSET @ t, ( sh_offset )
  tvoc@ §$TAB segment-length dup t, ( sh_size )  SECTION_FILE_OFFSET +!
  0 td, ( sh_link )  0 td, ( sh_info )  1 t, ( sh_align )  0 t, ( sh_ent_size ) ;

:( Creates the program header table )
: PHtable, ( -- )  >phdr createExecutionSegment  createVariablesSegment  createConstantsSegment ;
:( Creates the section header table )
: SHtable, ( -- )  >shdr  appendSectionNamesTable ;
:( Updates the offsets of all segments and sections )
: updateOffsets ( -- )  BASE-ADDR 0!
  tvoc@ dup §EHDR segment-length BASE-ADDR +!  dup §PHDR segment-length BASE-ADDR +!
  §SHDR segment-length BASE-ADDR +!
  tvoc@ §PHDR segment ELF-PHENTS@ / 0 +do BASE-ADDR @ over cell+ +!  ELF-PHENTS@ + loop  drop
  tvoc@ §SHDR segment ELF-SHENTS@ / 0 +do BASE-ADDR @ over 2 cells + 8+ +! ELF-SHENTS@ + loop drop ;
: unrel ( @voc -- @voc )  dup §REFS segment RE# / 0 +do  2dup dereloc  RE# + loop  drop ;

=== Program Frame ===

variable OUTFD

:( Writes the generated object to file target$ )
: saveObject ( target$ -- )  cr ." Saving object " dup qtype$
  count w/o create-file throw OUTFD !
  ELFsegments 0 +do tvoc@ i segment  ( cr ." Segment " i . ." = " over addr. ." , " dup . )
  OUTFD @ write-file throw  loop  OUTFD @ close-file throw ;
:( Transforms the loaded module at address @voc into the ELF format )
: transformModule ( @voc -- )  createEmptySection  checkEntry
  unrel  code,  data,  dict,  text,  syms,  strs,  refs,  deps,  SHtable,  PHtable,  ELFheader,  drop
  updateOffsets ;
:( Transforms module source$ to object module target$ )
: transform ( target$ source$ -- )  ELF# createTable @TARGET-VOC !
  loadModule  newest-voc@ transformModule  saveObject ;
