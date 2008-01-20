#!/bin/bash
#
# Test the applied code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

begin "applied (empty)"
guilt-applied

guilt-series | while read n; do
	begin "push ($n)"
	guilt-push

	begin "applied ($n)"
	guilt-applied

	begin "applied -c ($n)"
	guilt-applied -c

	begin "list_files"
	list_files
done
