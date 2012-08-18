
dwm: dwm-source
	make -C dwm
	cp dwm/dwm ~/bin

dwm-source:
	hg clone http://hg.suckless.org/dwm
	cp dwm.config.h dwm/config.h
	patch -p0 < dwm.layout-per-tag-init.diff
