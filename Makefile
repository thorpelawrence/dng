.PHONY: setup

build: dng.1 setup

setup:
	./setup.sh

dng.1: dng.adoc
	asciidoctor -b manpage dng.adoc

prefix = /usr/local
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1

install: dng.1
	install -d $(DESTDIR)$(bindir)
	install dng $(DESTDIR)$(bindir)
	install -d $(DESTDIR)$(man1dir)
	install dng.1 $(DESTDIR)$(man1dir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/dng
	rm -f $(DESTDIR)$(man1dir)/dng.1
	$(info WINEPREFIX=~/.wine-dng still exists, but is now safe to remove)
