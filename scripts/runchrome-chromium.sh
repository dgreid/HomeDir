#!/bin/sh
google-chrome --use-cras --enable-platform-apps --enable-media-stream --user-data-dir=/home/dgreid/.config/google-chrome-chromium --proxy-pac-url=http://proxyconfig.corp.google.com/wpad.dat 2>&1 > /dev/null
