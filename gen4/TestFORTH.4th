vocabulary TestFORCE

test: CharBitScan
  10111111B c0-> 6 expect
  11111110B c0-> 0 expect
  11111111B c0-> -1 expect
  test;

create CellBitScanMemoryArea  1024 0allot

test: CellBitScanMemory
  TEST 128  0 fill  TEST 16+ $40xor!  TEST 128 1<-@ 134 expect  TEST 128 1->@ 134 expect
  TEST 128 -1 fill  TEST 16+ $40xor!  TEST 128 0<-@ 134 expect  TEST 128 0->@ 134 expect
  test;

create OVRTEST  0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 ,
create OVRTEST2  128 0allot

test: move-with-risk-of-override
  OVRTEST dup cell+ swap 9 move    OVRTEST 8 cells+ @ 9 expect    OVRTEST @ 1 expect
  OVRTEST dup cell+ 9 move    OVRTEST 8 cells+ @ 8 expect    OVRTEST @ 1 expect

  "This is an example" dup OVRTEST2 over c@ 1+ cmove  OVRTEST2 swap $expect
  OVRTEST2 dup count 1- over 1+ -rot cmove    "his is an examplee" $expect
  OVRTEST2 dup count 1- over 1+ swap cmove    "hhis is an example" $expect
  test;

test: WithinBetween
  1 10 20 between false expect
  10 10 20 between true expect
  11 10 20 between true expect
  20 10 20 between false expect
  21 10 20 between false expect
  -1 -20 -10 between false expect
  -10 -20 -10 between false expect
  -11 -20 -10 between true expect
  -20 -20 -10 between true expect
  -21 -20 -10 between false expect
  1 10 20 within false expect
  10 10 20 within true expect
  11 10 20 within true expect
  20 10 20 within false expect
  21 10 20 within false expect
  -1 -20 -10 within false expect
  -10 -20 -10 within false expect
  -11 -20 -10 within true expect
  -20 -20 -10 within true expect
  -21 -20 -10 within false expect
  test;

test: NonDestructiveIf
  ( TODO:  x1 x2 =?if  x1 x2 ≠?if  x 0=?if  x 0≠if  x 0<?if  x 0>?if  x 0≤?if  x 0≥?if
    TODO:  same with unless, if-, if+, unless-, unless+ )
  cr  12 34 <??if   2drop  else  2drop "12 34 <?if   should be true." fail  then
  cr  -5 -1 <??if   2drop  else  2drop "-5 -1 <?if   should be true." fail  then
  cr  88 66 >??if   2drop  else  2drop "88 66 >?if   should be true." fail  then
  cr  -1 -8 >??if   2drop  else  2drop "-1 -8 >?if   should be true." fail  then
  cr  12 34 u<??if  2drop  else  2drop "12 34 u<?if  should be true." fail  then
  cr  -5 11 u>??if  2drop  else  2drop "-5 11 u<?if  should be true." fail  then
  cr  88 66 u>??if  2drop  else  2drop "88 66 u>?if  should be true." fail  then
  cr  11 -5 u<??if  2drop  else  2drop "11 -5 u<?if  should be true." fail  then
  test;

test: StringFormat
  "Hello, World!" 200 128 3 -1 5 "It's %B: %06d times (%d/%d%%) I said «%s»" |$|
    "It's TRUE: 000003 times (128/200%) I said «Hello, World!»" $expect
  "Hello, World!" 200 128 3 -1 5 "It's %B: %06d times (%d/%d%%) I said «%-20S»" |$|
    "It's     ON: 000003 times (128/200%) I said «HELLO, WORLD!       »" $expect
  -12345678900 1 "The balance is: %,+20d." |$| "The balance is:      -12,345,678,900." $expect
  -12345678900 1 "The balance is: %,_+(20d." |$| "The balance is: ____(12,345,678,900)." $expect
  -12345678900 1 "The balance is: %-*20d." |$| "The balance is: -12,345,678,900*****." $expect
  12345678900 1 "The balance is: %020d." |$| "The balance is: 00000000012345678900." $expect
  12345678900 1 "The balance is: %- d." |$| "The balance is:  12345678900." $expect

test: abs  34 abs 34 expect  -34 abs 34 expect  test;

test: nsize/usize
  0 nsize 0 expect
  -1 nsize 1 expect
  +1 nsize 1 expect
  -100 nsize 1 expect
  +100 nsize 1 expect
  -127 nsize 1 expect
  +127 nsize 1 expect
  -128 nsize 1 expect
  +128 nsize 2 expect
  -255 nsize 2 expect
  +255 nsize 2 expect
  -256 nsize 2 expect
  +256 nsize 2 expect
  -1000 nsize 2 expect
  +1000 nsize 2 expect
  -1000000 nsize 4 expect
  +1000000 nsize 4 expect
  -10000000000 nsize 8 expect
  +10000000000 nsize 8 expect
  -100000000000000 nsize 8 expect
  +100000000000000 nsize 8 expect

  0 usize 0 expect
  -1 usize 8 expect
  +1 usize 1 expect
  -100 usize 8 expect
  +100 usize 1 expect
  -127 usize 8 expect
  +127 usize 1 expect
  -128 usize 8 expect
  +128 usize 1 expect
  -255 usize 8 expect
  +255 usize 1 expect
  -256 usize 8 expect
  +256 usize 2 expect
  -1000 usize 8 expect
  +1000 usize 2 expect
  -1000000 usize 8 expect
  +1000000 usize 4 expect
  -10000000000 usize 8 expect
  +10000000000 usize 8 expect
  -100000000000000 usize 8 expect
  +100000000000000 usize 8 expect
  test;

vocabulary;
