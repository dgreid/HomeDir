#!/bin/sh

mbsync -a
~/scripts/check_for_mail.sh &
pid=$!

neomutt

kill -9 "$pid"
mairix -p
