#!/bin/sh

while [ true ]
do
	mbsync -aq
	mairix
	sleep 300
	min=$(( $min + 1 ))
done
