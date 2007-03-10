PREFIX=/usr/local

SCRIPTS = guilt \
	  $(wildcard guilt-*)

.PHONY: all 
all: doc
	@echo "Nothing to build, it is all bash :)"
	@echo "Try make install"

.PHONY: install
install:
	install -d $(PREFIX)/bin/
	install -m 755 $(SCRIPTS) $(PREFIX)/bin/

.PHONY: uninstall
uninstall:
	./uninstall $(PREFIX)/bin/ $(SCRIPTS)

.PHONY: doc
doc:
	$(MAKE) -C Documentation all

.PHONY: install-doc
install-doc:
	$(MAKE) -C Documentation install PREFIX=$(PREFIX)

.PHONY: test
test:
	make -C regression all

.PHONY: clean
clean: 
	$(MAKE) -C Documentation clean 
