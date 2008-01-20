#!/bin/bash
#
# Test the top code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

guilt-series | while read n ; do
	begin "guilt-top ($n)"
	guilt-top

	begin "list_files"
	list_files

	begin "guilt-push"
	guilt-push

	begin "list_files"
	list_files
done

begin "guilt-top ($n)"
guilt-top

begin "list_files"
list_files
