#!/bin/bash
#
# Test the commit code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

function opts_to_try
{
	cat << DONE
-n 0
-n 1
-a
--all
DONE
}

begin "guilt-commit"
shouldfail guilt-commit 2>&1

begin "list_files"
list_files
 
opts_to_try | while read opt; do
	begin "guilt-commit $opt"
	guilt-commit $opt 2>&1

	begin "list_files"
	list_files
done 


begin "guilt-push -a"
guilt-push -a

begin "guilt-commit"
shouldfail guilt-commit 2>&1

begin "list_files"
list_files
 
opts_to_try | while read opt; do
	begin "guilt-commit $opt"
	guilt-commit $opt 2>&1

	begin "list_files"
	list_files
done

echo > /dev/null
