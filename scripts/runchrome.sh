#!/bin/sh
google-chrome --use-cras --proxy-pac-url=http://proxyconfig.corp.google.com/wpad.dat 2>&1 > /dev/null
