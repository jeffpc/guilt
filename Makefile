PREFIX=/usr/local

SCRIPTS = guilt \
	  guilt-add \
	  guilt-applied \
	  guilt-delete \
	  guilt-header \
	  guilt-init \
	  guilt-new \
	  guilt-next \
	  guilt-patchbomb \
	  guilt-pop \
	  guilt-prev \
	  guilt-push \
	  guilt-refresh \
	  guilt-rm \
	  guilt-series \
	  guilt-status \
	  guilt-top \
	  guilt-unapplied

.PHONY: all 
all:
	@echo "Nothing to build, it is all bash :)"
	@echo "Try make install"

.PHONY: install
install:
	install -d $(PREFIX)/bin/
	install -m 755 $(SCRIPTS) $(PREFIX)/bin/

.PHONY: test
test:
	make -C regression all
