#!/bin/bash
#
# Test the new code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

function fixup_time_info
{
	touch -d "$GIT_COMMITTER_DATE" ".git/patches/master/$1"
}

for pname in file dir/file dir/subdir/file ; do
	begin "guilt-new $pname"
	guilt-new "$pname"
	guilt-pop 2>&1
	fixup_time_info "$pname"
	guilt-push 2>&1

	begin "list_files"
	list_files
done

begin "guilt-push --all"
guilt-push --all 2>&1

begin "guilt-new append"
guilt-new append
guilt-pop 2>&1
fixup_time_info append
guilt-push 2>&1

begin "list_files"
list_files

begin "guilt-pop --all"
guilt-pop --all 2>&1

begin "guilt-new prepend"
guilt-new prepend
guilt-pop 2>&1
fixup_time_info prepend
guilt-push 2>&1

begin "list_files"
list_files

begin "guilt-new \"white space\""
shouldfail guilt-new "white space" 2>&1

begin "list_files"
list_files

for pname in prepend mode /abc ./blah ../blah abc/./blah abc/../blah abc/. abc/.. abc/ ; do
	begin "gult-new $pname"
	shouldfail guilt-new "$pname" 2>&1

	begin "list_files"
	list_files
done
