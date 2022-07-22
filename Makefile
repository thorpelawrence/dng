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
	@find build/app -type f -exec chmod 644 "{}" \;
	@find build/commonappdata -type d -exec chmod 755 "{}" \;

clean:
	@rm -rf build

dng.1: dng.adoc
	asciidoctor -b manpage dng.adoc

install: build
	install -D build/dng $(DESTDIR)$(bindir)
	install -D dng.1 $(DESTDIR)$(man1dir)
	install -d $(DESTDIR)/$(datarootdir)/dng
	cp -r build/app $(DESTDIR)$(datarootdir)/dng
	cp -r build/commonappdata $(DESTDIR)$(datarootdir)/dng

uninstall:
	@rm -f $(DESTDIR)$(bindir)/dng
	@rm -f $(DESTDIR)$(man1dir)/dng.1
	@rm -rf $(DESTDIR)$(datarootdir)/dng
