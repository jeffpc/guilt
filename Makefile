PREFIX?=/usr/local
DESTDIR?=
INSTALL?=install

SCRIPTS = guilt \
	  $(filter-out $(wildcard *~),$(wildcard guilt-*))

.PHONY: all 
all: doc
	@echo "Nothing to build, it is all bash :)"
	@echo "Try make install"

.PHONY: install
install:
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/bin/
	$(INSTALL) -m 755 $(SCRIPTS) $(DESTDIR)$(PREFIX)/bin/

.PHONY: uninstall
uninstall:
	./uninstall $(DESTDIR)$(PREFIX)/bin/ $(SCRIPTS)

.PHONY: doc
doc:
	$(MAKE) -C Documentation all

.PHONY: install-doc
install-doc:
	$(MAKE) -C Documentation install PREFIX=$(PREFIX) DESTDIR=$(DESTDIR) INSTALL=$(INSTALL)

.PHONY: test
test:
	make -C regression all

.PHONY: clean
clean: 
	$(MAKE) -C Documentation clean 
