MAN1_TXT= $(wildcard guilt-*.txt)
MAN7_TXT=guilt.txt

DOC_HTML=$(patsubst %.txt,%.html,$(MAN1_TXT) $(MAN7_TXT))

DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))

prefix?=$(PREFIX)
bindir?=$(prefix)/bin
htmldir?=$(prefix)/html
mandir?=$(prefix)/man
man1dir=$(mandir)/man1
man7dir=$(mandir)/man7
# DESTDIR=

ASCIIDOC=asciidoc
ASCIIDOC_EXTRA =
INSTALL?=install
DOC_REF = origin/man

all: html man

html: $(DOC_HTML)

$(DOC_HTML) $(DOC_MAN1) $(DOC_MAN7): asciidoc.conf

man: man1 man7
man1: $(DOC_MAN1)
man7: $(DOC_MAN7)

install: man
	$(INSTALL) -d -m755 $(DESTDIR)$(man1dir) $(DESTDIR)$(man7dir)
	$(INSTALL) -m644 $(DOC_MAN1) $(DESTDIR)$(man1dir)
	$(INSTALL) -m644 $(DOC_MAN7) $(DESTDIR)$(man7dir)

install-html: html
	$(INSTALL) -m644 $(DOC_HTML) $(DESTDIR)$(htmldir)

#
# Determine "include::" file references in asciidoc files.
#
doc.dep : $(wildcard *.txt) build-docdep.perl
	rm -f $@+ $@
	perl ./build-docdep.perl >$@+
	mv $@+ $@

-include doc.dep

cmds.txt: cmd-list.perl $(MAN1_TXT)
	perl ./cmd-list.perl

guilt.7 guilt.html: guilt.txt 

clean:
	rm -f *.xml *.html *.1 *.7 doc.dep
	rm -f cmds.txt

%.html : %.txt
	$(ASCIIDOC) -b xhtml11 -d manpage -f asciidoc.conf $(ASCIIDOC_EXTRA) $<

%.1 %.7 : %.xml
	xmlto -m callouts.xsl man $<

%.xml : %.txt
	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf $<
