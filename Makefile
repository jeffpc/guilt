PREFIX=/usr/local

all:
	echo "Nothing to build, it is all bash :)"
	echo "Try make install"

install:
	install guilt* $(PREFIX)/bin/
