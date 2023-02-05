.PHONY: build checksum cargo_build clean install uninstall

prefix = /usr/local
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1

installer_exe = AdobeDNGConverter_x64_15_1_1.exe

build: checksum cargo_build build/app build/commonappdata

checksum:
ifneq ($(SKIPCHECKSUM), true) # skip if package manager checks integrity
	@shasum -c $(installer_exe).sha512
endif

cargo_build:
	install -d build

	datarootdir=$(datarootdir) cargo build --locked --release

	cp target/release/dng build

	@ # https://github.com/rust-lang/cargo/issues/6790
	find target/release/build -type f -path "target/release/build/dng-*/out/*" -exec cp {} build \;

build/app build/commonappdata:
	innoextract -sd build $(installer_exe)

clean:
	@rm -rf build
	@cargo clean

install: build
	install -d -m755 $(DESTDIR)$(bindir)
	install -m755 build/dng $(DESTDIR)$(bindir)

	install -d -m755 $(DESTDIR)$(bindir) $(DESTDIR)$(man1dir)
	install -m644 build/dng.1 $(DESTDIR)$(man1dir)

	install -d -m755 $(DESTDIR)$(datarootdir)/zsh/site-functions
	install -m644 build/_dng $(DESTDIR)$(datarootdir)/zsh/site-functions

	install -d -m755 $(DESTDIR)$(datarootdir)/bash-completion/completions
	install -m644 build/dng.bash $(DESTDIR)$(datarootdir)/bash-completion/completions/dng

	install -d -m755 $(DESTDIR)$(datarootdir)/fish/vendor_completions.d
	install -m644 build/dng.fish $(DESTDIR)$(datarootdir)/fish/vendor_completions.d

	install -d -m755 $(DESTDIR)$(datarootdir)/dng
	cp -r build/app $(DESTDIR)$(datarootdir)/dng
	cp -r build/commonappdata $(DESTDIR)$(datarootdir)/dng
	@find $(DESTDIR)/$(datarootdir)/dng -type f -exec chmod 644 "{}" \;
	@find $(DESTDIR)/$(datarootdir)/dng -type d -exec chmod 755 "{}" \;

uninstall:
	@rm -f $(DESTDIR)$(bindir)/dng
	@rm -f $(DESTDIR)$(man1dir)/dng.1
	@rm -f $(DESTDIR)$(datarootdir)/zsh/site-functions/_dng
	@rm -f $(DESTDIR)$(datarootdir)/bash-completion/completions/dng
	@rm -f $(DESTDIR)$(datarootdir)/fish/vendor_completions.d/dng.fish
	@rm -rf $(DESTDIR)$(datarootdir)/dng
