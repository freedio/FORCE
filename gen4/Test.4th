/* Gen4 test suite */
vocabulary Test
  requires" FORTH.voc"
  requires" IO.voc"
  requires" OS.voc"
  requires" StringFormat.voc"

:: program ( -- )  INIT,
  "FORCE Scratch Test Suite 0.0". cr

  0 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -1 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +1 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -100 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +100 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -127 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +127 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -128 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +128 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -255 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +255 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -256 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +256 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -1000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +1000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -1000000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +1000000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -10000000000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +10000000000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  -100000000000000 dup nsize swap cr 2 "nsize(%d) = %d."|.
  +100000000000000 dup nsize swap cr 2 "nsize(%d) = %d."|.

  0 dup usize swap cr 2 "usize(%#d) = %d."|.
  -1 dup usize swap cr 2 "usize(%#d) = %d."|.
  +1 dup usize swap cr 2 "usize(%#d) = %d."|.
  -100 dup usize swap cr 2 "usize(%#d) = %d."|.
  +100 dup usize swap cr 2 "usize(%#d) = %d."|.
  -127 dup usize swap cr 2 "usize(%#d) = %d."|.
  +127 dup usize swap cr 2 "usize(%#d) = %d."|.
  -128 dup usize swap cr 2 "usize(%#d) = %d."|.
  +128 dup usize swap cr 2 "usize(%#d) = %d."|.
  -255 dup usize swap cr 2 "usize(%#d) = %d."|.
  +255 dup usize swap cr 2 "usize(%#d) = %d."|.
  -256 dup usize swap cr 2 "usize(%#d) = %d."|.
  +256 dup usize swap cr 2 "usize(%#d) = %d."|.
  -1000 dup usize swap cr 2 "usize(%#d) = %d."|.
  +1000 dup usize swap cr 2 "usize(%#d) = %d."|.
  -1000000 dup usize swap cr 2 "usize(%#d) = %d."|.
  +1000000 dup usize swap cr 2 "usize(%#d) = %d."|.
  -10000000000 dup usize swap cr 2 "usize(%#d) = %d."|.
  +10000000000 dup usize swap cr 2 "usize(%#d) = %d."|.
  -100000000000000 dup usize swap cr 2 "usize(%#d) = %d."|.
  +100000000000000 dup usize swap cr 2 "usize(%#d) = %d."|.

  "Hello, World" count 'o' cfind  cr 1 "First o in 'Hello, World' @ %d"|.
  "Hello, World" count 'o' rcfind  cr 1 "Last o in 'Hello, World' @ %d"|.
  "Hello, World" count 'q' cfind  cr 1 "First q in 'Hello, World' @ %d"|.
  "Hello, World" count 'q' rcfind  cr 1 "Last q in 'Hello, World' @ %d"|.
  cr "Sömé \t štrĳngə \\chårä¢tœřß≠\1000❮\xa7❯\u205D \u1f608  😂\n".
  cr .s bye ;;  >main

vocabulary;
