#!/bin/bash
find . -iname '*.c*' -or -iname '*.h' -exec grep "$1"  /dev/null {} \;