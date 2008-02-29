#!/bin/bash
#
# Test the header code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

function fixup_time_info
{
	touch -d "$GIT_COMMITTER_DATE" ".git/patches/master/$1"
}

begin "guilt-header (no patches)"
shouldfail guilt-header 2>&1

begin "guilt-push -a"
guilt-push -a

begin "guilt-new -s -m \"blah blah blah\" patch-with-some-desc"
guilt-new -s -m "blah blah blah" patch-with-some-desc
guilt-pop
fixup_time_info patch-with-some-desc
guilt-push

begin "list_files"
list_files

begin "guilt-header"
guilt-header

guilt-series | while read n; do
	begin "guilt-header $n"
	guilt-header $n
done

begin "guilt-header non-existant"
shouldfail guilt-header non-existant 2>&1

# FIXME: how do we check that -e works?
