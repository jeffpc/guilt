#!/bin/bash
#
# Test the init code
#

source $REG_DIR/scaffold

function relative_git_dir_path
{
	sed -e "s,GIT_DIR=$PWD/,GIT_DIR=,"
}

cmd setup_git_repo

cmd guilt-init

cmd list_files

shouldfail guilt-init | relative_git_dir_path

cmd list_files

cmd git-branch other

cmd git-checkout other

cmd guilt-init

cmd list_files

shouldfail guilt-init | relative_git_dir_path

cmd list_files
