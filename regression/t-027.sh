#!/bin/bash
#
# Test the refresh code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

function fixup_time_info
{
	touch -d "$GIT_COMMITTER_DATE" ".git/patches/master/$1"
}

begin "guilt-refresh (no applied patches)"
echo abcdef >> def
shouldfail guilt-refresh 2>&1

begin "list_files"
list_files

begin "git-reset --hard HEAD"
git-reset --hard HEAD

begin "guilt-push modify"
guilt-push modify 2>&1

begin "guilt-refresh (applied patch)"
echo abcdef >> def
guilt-refresh
guilt-pop
fixup_time_info modify
guilt-push modify

begin "list_files"
list_files

# FIXME: we should check that the patch actually contains what it should,
# test arguments work the way they should
