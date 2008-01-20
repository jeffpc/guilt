#!/bin/bash
#
# Test the series code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

begin "guilt-series"
guilt-series

begin "guilt-series -v"
guilt-series -v

guilt-series | while read n ; do
	begin "guilt-push ($n)"
	guilt-push

	begin "guilt-series -v"
	guilt-series -v
done

begin "list_files"
list_files
