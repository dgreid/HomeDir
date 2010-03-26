#!/bin/sh
while true
do
   xsetroot -name "$( acpi -b | awk '{ print $3 $4 }' | tr -d ',' ) $( date "+%b %d %H:%M" )"
   sleep 10
done
