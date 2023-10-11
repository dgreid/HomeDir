#!/bin/sh

mbsync -a 2> /dev/null
~/scripts/check_for_mail.sh &
pid=$!

neomutt

kill -9 "$pid"
mbsync -a 2> /dev/null
mairix -p
