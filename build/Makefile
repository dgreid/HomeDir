dwm: dwm-source
	make -C dwm
	cp dwm/dwm ~/bin

dwm-source:
	git clone https://github.com/dgreid/dwm
	cp dwm.config.h dwm/config.h
	patch -p0 < dwm.layout-per-tag-init.diff
