#!/bin/sh

case $1 in
   blue)
      echo -ne "\033]10;#0030d0\007"
      ;;
   green)
      echo -ne "\033]10;#00e000\007"
      ;;
   red)
      echo -ne "\033]10;#d00000\007"
      ;;
esac

