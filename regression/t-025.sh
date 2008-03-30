#!/bin/bash
#
# Test the new code
#

source $REG_DIR/scaffold

cmd setup_repo

function fixup_time_info
{
	touch -d "$GIT_COMMITTER_DATE" ".git/patches/master/$1"
}

for pname in file dir/file dir/subdir/file ; do
	cmd guilt-new "$pname"
	cmd guilt-pop
	fixup_time_info "$pname"
	cmd guilt-push

	cmd list_files
done

cmd guilt-push --all

cmd guilt-new append
cmd guilt-pop
fixup_time_info append
cmd guilt-push

cmd list_files

cmd guilt-pop --all

cmd guilt-new prepend
cmd guilt-pop
fixup_time_info prepend
cmd guilt-push

cmd list_files

shouldfail guilt-new "white space"

cmd list_files

for pname in prepend mode /abc ./blah ../blah abc/./blah abc/../blah abc/. abc/.. abc/ ; do
	shouldfail guilt-new "$pname" 2>&1

	cmd list_files
done
