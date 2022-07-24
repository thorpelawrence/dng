prefix = /usr/local
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1

installer_exe = AdobeDNGConverter_x64_13_4.exe

build: dng.1
ifneq ($(SKIPCHECKSUM), true) # skip if package manager checks integrity
	@shasum -c $(installer_exe).sha512
endif
	innoextract -sd build $(installer_exe)
	sed "s:{{datarootdir}}:$(datarootdir):g" dng > build/dng

clean:
	@rm -rf build

dng.1: dng.adoc
	asciidoctor -b manpage dng.adoc

install: build
	install -D -m 644 build/dng $(DESTDIR)$(bindir)
	install -D -m 644 dng.1 $(DESTDIR)$(man1dir)
	install -d -m755 $(DESTDIR)/$(datarootdir)/dng
	cp -r build/app $(DESTDIR)$(datarootdir)/dng
	cp -r build/commonappdata $(DESTDIR)$(datarootdir)/dng
	@find $(DESTDIR)/$(datarootdir)/dng -type f -exec chmod 644 "{}" \;
	@find $(DESTDIR)/$(datarootdir)/dng -type d -exec chmod 755 "{}" \;

uninstall:
	@rm -f $(DESTDIR)$(bindir)/dng
	@rm -f $(DESTDIR)$(man1dir)/dng.1
	@rm -rf $(DESTDIR)$(datarootdir)/dng
