#!/bin/sh

# Takes the number of hours to run as an argument (default 2)
run_hours=${1:-2}

hour=0
while [ $hour -lt $run_hours ]
do
	min=0
	while [ $min -lt 12 ]
	do
		mbsync -aq
		mairix
		sleep 300
		min=$(( $min + 1 ))
	done
	hour=$(( $hour + 1 ))
done
mairix -p
