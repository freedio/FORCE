/**
  * Character conversions.
  */

package force/convert/

import force/lang/Forth

vocabulary Char

( Converts unicode character uc to its uppercase equivalent UC.  If there is no uppercase
  equivalent, simply returns uc. )
: >upper ( uc -- UC|uc )
  dup 'a' '{' within if  $20− exit  then
  $DF=?if  drop $1E9E exit  then
  dup $E0 $FF within if  $20− exit  then
  $100<?if  exit  then
  dup $100 $17F within over 1and and if  1− exit  then
  dup $182 $186 within over 1and and if  1− exit  then
  $188=?if  1− exit  then
  $18C=?if  1− exit  then
  $192=?if  1− exit  then
  $199=?if  1− exit  then
  dup $1A0 $1A6 within over 1and and if  1− exit  then
  $1A8=?if  1− exit  then
  $1AD=?if  1− exit  then
  dup $1B3 $1B7 within over 1and 1− and if  1− exit  then
  $1B9=?if  1− exit  then
  $1BD=?if  1− exit  then
  $1C6=?if  2− exit  then
  $1C9=?if  2− exit  then
  $1CC=?if  2− exit  then
  dup $1CD $1DD within over 1and and if  1− exit  then
  dup $1DE $1F0 within over 1and and if  1− exit  then
  $1F3=?if  2− exit  then
  $1F5=?if  1− exit  then
  dup $1F8 $220 within over 1and and if  1− exit  then
  $200<?if  exit  then
  dup $222 #234 within over 1and and if  1− exit  then
  $23C=?if  1− exit  then
  dup $246 $250 within over 1and and if  1− exit  then
  $300<?if  exit  then
  dup $370 $378 within over 1and and if  1− exit  then
  $3C2=?if  1+  then
  dup $3B1 $3CA within if  $20− exit  then
  $3D0=?if  drop $392 exit  then
  $3D1=?if  drop $398 exit  then
  $3D5=?if  drop $3A6 exit  then
  $3D6=?if  drop $3A0 exit  then
  dup $3D8 $3DE within  over 1and and if  1− exit  then
  $3DE=?if  6− exit  then
  $3DF=?if  7− exit  then
  dup $3E0 $3F0 within over 1and and if  1− exit  then
  $3F0=?if  drop $39A exit  then
  $3F1=?if  drop $3A1 exit  then
  $3F2=?if  7+ exit  then
  $3F3=?if  drop $37F exit  then
  $3F5=?if  drop $395 exit  then
  $3F8=?if  1− exit  then
  $3FB=?if  1− exit  then
  $400<?if  exit  then
  dup $450 $460 within if  $50− exit  then
  dup $430 $450 within if  $20− exit  then
  dup $460 $482 within over 1and and if  1− exit  then
  dup $48A $4C0 within over 1and and if  1− exit  then
  $4CF=?if  15− exit  then
  dup $4C1 $4CF within over 1and 1− and if  1− exit  then
  dup $4D0 $530 within over 1and and if  1− exit  then
  $500<?if  exit  then
  dup $560 $587 within if  $30− exit  then
  $1000<?if  exit  then
  dup $10D0 $10F6 within if  $30− exit  then
  $10F7=?if  $30− exit  then
  $10FD=?if  $30− exit  then
  dup $1E00 $1E96 within over 1and and if  1− exit  then
  dup $1EA0 $1F00 within over 1and and if  1− exit  then
  dup $1F00 $1F08 within if  8+ exit  then
  dup $1F10 $1F18 within if  8+ exit  then
  dup $1F20 $1F28 within if  8+ exit  then
  dup $1F30 $1F38 within if  8+ exit  then
  dup $1F40 $1F48 within if  8+ exit  then
  dup $1F50 $1F58 within if  8+ exit  then
  dup $1F60 $1F68 within if  8+ exit  then
  dup $1F80 $1F88 within if  8+ exit  then
  dup $1F90 $1F98 within if  8+ exit  then
  dup $1FA0 $1FA8 within if  8+ exit  then
  dup $1FB0 $1FB2 within if  8+ exit  then
  $2000<?if  exit  then
  $2C61=?if  1− exit  then
  dup $2C67 $2C6D within over 1and 1− and if  1− exit  then
  $2C73=?if  1− exit  then
  dup $2C80 $2CE4 within over 1and and if  1− exit  then
  dup $2CEB $2CEF within over 1and and if  1− exit  then
  $2CF3=?if  1− exit  then
  dup $2D00 $2D26 within if  $1C60− exit  then
  $2D27=?if  drop $10C7 exit  then
  $2D2D=?if  drop $10CD exit  then
  dup $2C30 $2C5F within if  $30− exit  then
  $A640<?if  exit  then
  dup $A640 $A6A0 within over 1and and if  1− exit  then
  dup $A722 $A730 within over 1and and if  1− exit  then
  dup $A732 $A742 within over 1and and if  1− exit  then
  dup $A746 $A74C within over 1and and if  1− exit  then
  dup $A74E $A754 within over 1and and if  1− exit  then
  $A757=?if  1− exit  then
  dup $A764 $A76A within over 1and and if  1− exit  then
  $A77C=?if  1− exit  then
  dup $A780 $A788 within over 1and and if  1− exit  then
  $A78C=?if  1− exit  then
  dup $A7A0 $A7AA within over 1and and if  1− exit  then
  dup $A7B4 $A7B8 within over 1and and if  1− exit  then
  ;

vocabulary;
export Char
