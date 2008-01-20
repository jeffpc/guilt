#!/bin/bash
#
# Test the unapplied code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

begin "unapplied (empty)"
guilt-unapplied

guilt-series | while read n; do
	begin "push ($n)"
	guilt-push

	begin "unapplied ($n)"
	guilt-unapplied

	begin "list_files"
	list_files
done
