build/ncurses/ncurses.tar: | build/ncurses/
	$(MKDIR) build/ncurses/src
	(cd build/ncurses/src; $(PWD)/submodule/ncurses/configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=$(PWD)/build/ncurses/ncurses)
	$(MAKE) -C build/ncurses/src
	$(MAKE) -C build/ncurses/src install
	touch $@

build/emacs/emacs.tar: build/ncurses/ncurses.tar | build/emacs/
	cp -a submodule/emacs build/emacs/src
	(cd build/emacs/src && sh autogen.sh)
	(cd build/emacs/src && ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu LDFLAGS="-L$(PWD)/build/ncurses/ncurses/lib" CFLAGS="-Os -static" --without-all --without-json --without-x --prefix=$(PWD)/build/emacs/emacs)
	$(MAKE) -C build/emacs/src/src emacs
	rm -rf build/emacs/emacs
	$(MAKE) -C build/emacs/src install
	rm -rf build/emacs/emacs/share/info
	rm -rf build/emacs/emacs/share/emacs/*/lisp/leim
	rm -rf build/emacs/emacs/share/emacs/*/lisp/progmodes
	rm -rf build/emacs/emacs/share/emacs/*/lisp/gnus
	rm -rf build/emacs/emacs/share/emacs/*/lisp/cedet
	rm -rf build/emacs/emacs/share/emacs/*/lisp/vc
	rm -rf build/emacs/emacs/share/emacs/*/lisp/charsets
	rm -rf build/emacs/emacs/share/emacs/*/lisp/obsolete
	rm -rf build/emacs/emacs/share/emacs/*/etc/tutorials
	rm -rf build/emacs/emacs/libexec/emacs/*/aarch64-linux-gnu/movemail
	rm -rf build/emacs/emacs/share/emacs/*/etc/NEWS*
	rm -rf build/emacs/emacs/share/emacs/*/etc/images
	tar -C $(PWD)/build/emacs -cvf build/emacs/emacs.tar emacs
