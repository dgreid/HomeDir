#!/bin/sh

while [ true ]
do
	mbsync -aq 2> /dev/null
	mairix
	sleep 300
	min=$(( $min + 1 ))
done
