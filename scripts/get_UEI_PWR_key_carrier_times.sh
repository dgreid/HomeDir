#!/bin/bash
for i in `find . -name '*PWR.fi'`; do printf "%s - %s - %s\n" `head -1 $i | awk '{ print $1 }'` $i ` wc $i | awk '{ print $1 }'`; done | sort
