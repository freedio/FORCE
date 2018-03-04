vocabulary HelloWorld
requires" FORTH.voc"
requires" IO.voc"
requires" OS.voc"

create HelloWorld$  "Hello, World!",
create Counting$  ," Counting from "
create To$  ," to "
create AndInHex$  ," And in hex:"
create Depth$  ," Depth: "
create Break$  ," Program break: "
create VOCA$  ," Vocabulary: "
create DICT$  ," Dictionary: "
create CODE$  ," Code section: "
create DATA$  ," Data section: "
create TEXT$  ," Text section: "
create SIZE$  ," , #"
create #WORDS$  ," , #words: "

:: helloworld ( -- )  INIT, HelloWorld$ $>stdout
   cr Depth$ $>stdout  depth .
   cr Counting$ $>stdout  -100 dup .  space To$ $>stdout  abs .
   cr 101 -100 do  i . space  loop
   cr AndInHex$ $>stdout
   cr 101 -100 do  i hc. space  loop
   0 0 0 cr Depth$ $>stdout  depth . .s space sp0 hu. space sp@ hu.
   3drop cr Depth$ $>stdout  depth .
   cr Break$ $>stdout  0 pgmbrk dup hu. 1000H + pgmbrk space hu.
   cr VOCA$ $>stdout  HelloWorld hu.  #WORDS$ $>stdout  HelloWorld #words u.
   cr DICT$ $>stdout  HelloWorld dict@ hu.  SIZE$ $>stdout  HelloWorld dict# hu.
   cr CODE$ $>stdout  HelloWorld code@ hu.  SIZE$ $>stdout  HelloWorld code# hu.
   cr DATA$ $>stdout  HelloWorld data@ hu.  SIZE$ $>stdout  HelloWorld data# hu.
   cr TEXT$ $>stdout  HelloWorld text@ hu.  SIZE$ $>stdout  HelloWorld text# hu.
   cr DATA$ $>stdout
   HelloWorld dup data@ swap data# hexdump
   cr TEXT$ $>stdout
   HelloWorld dup text@ swap text# hexdump

   cr VOCA$ $>stdout  FORTH hu.  #WORDS$ $>stdout  FORTH #words u.
   cr DICT$ $>stdout  FORTH dict@ hu.  SIZE$ $>stdout  FORTH dict# hu.
   cr CODE$ $>stdout  FORTH code@ hu.  SIZE$ $>stdout  FORTH code# hu.
   cr DATA$ $>stdout  FORTH data@ hu.  SIZE$ $>stdout  FORTH data# hu.
   cr TEXT$ $>stdout  FORTH text@ hu.  SIZE$ $>stdout  FORTH text# hu.
   cr DATA$ $>stdout
   FORTH dup data@ swap data# hexdump
   cr TEXT$ $>stdout
   FORTH dup text@ swap text# hexdump

   bye ;;  >main

vocabulary;
