#!/bin/bash
#
# Test the init code
#

source $REG_DIR/scaffold

function relative_git_dir_path
{
	sed -e "s,GIT_DIR=$PWD/,GIT_DIR=,"
}

begin "setup_git_repo"
setup_git_repo

begin "guilt-init"
guilt-init 2>&1

begin "list_files"
list_files

begin "guilt-init (should fail)"
shouldfail guilt-init 2>&1 | relative_git_dir_path

begin "list_files"
list_files

begin "git-branch other"
git-branch other

begin "git-checkout other"
git-checkout other 2> /dev/null

begin "guilt-init (other branch)"
guilt-init 2>&1

begin "list_files"
list_files

begin "guilt-init (other branch, should fail)"
shouldfail guilt-init 2>&1 | relative_git_dir_path

begin "list_files"
list_files
