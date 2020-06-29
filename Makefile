#
# Global Settings
#

INSTALL = install
PREFIX  ?= $(ZSH)
DESTDIR ?= $(PREFIX)/custom/themes

#
# Targets
#

all:
	@echo "Nothing to do"

install:
	$(INSTALL) -m0755 -D lambda-mod.zsh-theme $(DESTDIR)/lambda-mod.zsh-theme
	$(INSTALL) -m0755 -D af-magic-mod.zsh-theme $(DESTDIR)/af-magic-mod.zsh-theme

uninstall:
	rm $(DESTDIR)/lambda-mod.zsh-theme
	rm $(DESTDIR)/af-magic-mod.zsh-theme

.PHONY: all install uninstall
