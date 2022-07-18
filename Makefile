prefix = /usr/local
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1

DOCKER = docker
ASCIIDOCTOR = asciidoctor

ifeq (, $(shell which asciidoctor))
	ASCIIDOCTOR = $(DOCKER) run --rm -u $(shell id -u):$(shell id -g) -v "$(PWD)":/documents asciidoctor/docker-asciidoctor asciidoctor
endif

.PHONY: wine_install

build: dng.1 wine_install

wine_install:
ifeq ($(shell id -u), 0)
	$(error running as root, but '$@' should be run as regular user)
endif
	./wine-install.sh $(HOME)/.wine-dng

wine_uninstall:
ifeq ($(shell id -u), 0)
	$(error running as root, but '$@' should be run as regular user)
endif
	rm -rf $(HOME)/.wine-dng

dng.1: dng.adoc
	$(ASCIIDOCTOR) -b manpage dng.adoc

install: dng.1
	install -d $(DESTDIR)$(bindir)
	install dng $(DESTDIR)$(bindir)
	install -d $(DESTDIR)$(man1dir)
	install dng.1 $(DESTDIR)$(man1dir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/dng
	rm -f $(DESTDIR)$(man1dir)/dng.1
	$(info WINEPREFIX=~/.wine-dng still exists, it can be removed by running 'make wine_uninstall')
